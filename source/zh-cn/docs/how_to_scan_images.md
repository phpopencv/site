title: 如何使用PHPOpenCV访问图像像素，查找表格和时间测量
------------------------------------

## 目标

我们将解决一下问题：

- 如何操作图像中的每个像素？
- PHPOpenCV中的矩阵值储存？
- 如何衡量我们的算法的性能？
- 什么是查找表（lookup tables），为什么使用它们？

## 图像在内存中的储存方式

&emsp;&emsp;在之前的章节中，我们已经了解到图像矩阵的大小取决于所有的颜色模型，确切来说，取决于所有通道数。
如果是灰度图，矩阵如下所示：

<div align=center>
![1.png](/images/docs/how_to_scan_images/1.png)
</div>

&emsp;&emsp;而对多通道来说，矩阵中的列会包含多个子列，其中列个数与通道数相等。例如RGB颜色模型的矩阵：

<div align=center>
![2.png](/images/docs/how_to_scan_images/2.png)
</div>

## 颜色空间缩减

&emsp;&emsp;我们知道，若矩阵元素储存的是单通道元素（扩展中使用C或C++的无符号字符类型，也就是`unsigned char`），那么每个像素的值可以有256个不同值（0～255），
但如果是三通道图像（RGB等），这种储存格式的颜色数值就太多了（确切的说一个像素的值就有1600多万中，也就是256的3次方）。
用这么多的颜色来处理，可能会对我们的算法性能造成严重影响。  
&emsp;&emsp;其实，仅用这些颜色中具有代表性的很小的部分，就足以达到同样效果。  
&emsp;&emsp;在这种情况下，我们通常会采用颜色空间缩减（color space reduction），它在很多引用中可以大大降低运算的复杂度。
&emsp;&emsp;颜色空间缩减的做法是：将现有的颜色空间某个输入值进行`除法`和`乘法`操作，以获得较少的颜色数值。
比如颜色0到9可取值为新值0，10到19可取值未10,以此类推。
&emsp;&emsp;例如三通道图像每个通道取值可以是0～255,那么每个像素就有256x256x256个不同的值。我们可以定义：

- 0～9范围的取值未0;
- 10～19范围的取值未10;
- 20～29范围的取值未20;
- ...

&emsp;&emsp;这样的操作将颜色取值降为26x26x26种。定义域中进行的颜色缩减运算就可以表达为下面形式：
<div align=center>
![3.png](/images/docs/how_to_scan_images/3.png)
</div>

&emsp;&emsp;简单的颜色空间缩小算法就是将图像矩阵中每个像素套用这个公式进行一遍计算。但值得注意的是，我们做了一个除法和乘法。
这些操作对系统来说是昂贵的和需要一定的时间花销。此外，在像素值有限的情况下，现在只有0～255种值，即只有256中情况。
因此，对于较大的图像，预先计算所有可能的值，放到数组中，这样每种情况都不需计算，直接从数组中去结果即可。

```php
$divideWith = 10;
$table = [];
for($i = 0; $i <256; ++ $i){
    $table[$i] = $divideWith * intval($i/$divideWith);
}


```

于是`$table[$i]`存放的是值未$i的像素说减颜色空间的结果，如果获取的代码为：

```php
$value = $table[$value]
```

这样，简单的颜色空间缩减就可以由一下两部组成：
（1）遍历图像矩阵的每一个元素;
（2）对像素应用上述公式。

## 访问图像中的像素

PHPOpenCV中可以通过Mat对象中的`at`方法获取或设置对象的像素值

```php
use CV\Mat;
use const CV\{
    CV_8UC3
};

$mat = new Mat(3, 3, CV_8UC3);//创建3行3列3通道的矩阵
$mat->print();//打印修改前的矩阵
$mat->at(0,0,0,1);//设置第一行第一列第一通道的值为1
$mat->at(0,0,0);//获取第一行第一列第一通道的值
$mat->print();//打印修改后的矩阵

```



## LUT函数：Look up table
对于look up table操作，你可以直接用at方法，循环矩阵中的`行`、`列`、`通道`，进行遍历更改值。
PHPOpenCV中强烈推荐使用`CV\LUT`函数来惊醒。他用于批量惊醒图像元素查找、扫描与操作图像。其使用方法如下：

```php
$divideWith = 50;
$table = [];
for ($i = 0; $i < 256; ++$i) {
    $table[$i] = $divideWith * intval($i / $divideWith);
}
//简历一个mat对象用于查表
$lut = new Mat(1, 256, CV_8U);

for ($i = 0; $i < 256; $i++) {
    $lut->at(0, $i, 0, $table[$i]);
}

//查找表操作
LUT($src, $lut, $dst);

```


## 计时器
另外有一个问题是如何即使。可以利用这两个简便的即使函数

- CV\getTickCount()函数返回CPU自某个时间（入启动电脑）以来走过的时钟周期数
- CV\getTickFrequency()函数返回CPU一秒所走的时钟周期数。这样，我们就可以轻松地以秒未单位对某个运算即使。

这两个函数组合起来使用的实例如下。
```php

$timeStart = getTickCount();//记录起始时间
//do something... 
$time = (getTickCount()-$timeStart)/getTickFrequency();
echo $time;//输出运行时间

```

## 例子

要求对图片1.png进行图像缩减

### 代码
```php
use CV\Mat;
use CV\Formatter;
use const CV\{
    CV_8U,
    CV_8UC3,
    CV_8UC1,
    CV_8UC2
};
use function CV\{
    imread, LUT, imshow, waitKey, getTickCount, getTickFrequency
};

$divideWith = 50;
$table = [];
for ($i = 0; $i < 256; ++$i) {
    $table[$i] = $divideWith * intval($i / $divideWith);
}
$lut = new Mat(1, 256, CV_8U);
//$lut->print(Formatter::FMT_PYTHON);

for ($i = 0; $i < 256; $i++) {
    $lut->at(0, $i, 0, $table[$i]);
}
//$lut->print(Formatter::FMT_PYTHON);

$src = imread("./1.jpg");
$dst = null;
$timeStart = getTickCount();
//查找表操作
LUT($src, $lut, $dst);
$time = (getTickCount() - $timeStart) / getTickFrequency();
echo 'LUT方法时间为：'.$time."\r\n";

imshow("Original image", $src);
imshow("Result image", $dst);

waitKey(0);
```

### 结果
<div align=center>
![result.png](/images/docs/how_to_scan_images/result.png)
</div>

### 代码下载地址
[例子地址](https://github.com/phpopencv/tutorial-demo/tree/master/core/how_to_scan_images)

