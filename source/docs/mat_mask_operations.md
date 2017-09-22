title: 矩阵的掩码操作
--------------

在矩阵上进行掩码操作是非常简单的。其思想是:根据`掩码矩阵`（也称作`核`）重新计算图像中每个像素的值。
这个掩码矩阵里面的值将决定临近的像素对新像素值的影响多大。从数学的观点上来看，我们利用我们给定的值做了一个加权平均。

## 测试例子

### 实现的功能
现在需要实现一个功能，对一张图像的对比度进行增强。基本上我们要对图像的每一个像素应用下面的公式：
<div align=center>
![1.png](/images/docs/mat_mask_operations/1.png)
</div>

### 公式理解

很多人看了公式后不能理解，其实上述的`I(i,j) = 5*I(i,j)-[I(i-1,j)+I(i+1,j)+I(i,j-1)+I(i,j+1)]`公式可以理解为：
要计算的中心点`I(i,j)`=中心点的值乘以5,再减去中心点上下左右相邻的值。
所以这里中心点的计算的值不是原值简简单单的乘以5,还受到原图像相邻的像素值影响。
这里也可以直接将公式转换中心点`I(i,j)`乘以一个权重值`M`，而M的权重值计算为：
<div align=center>
![2.png](/images/docs/mat_mask_operations/2.png)
</div>

## 实现思路

我们可以有两种实现方案：
- 第一种方式是直接套用上面的公式
- 第二种通过使用掩码

第一种就不用说了，第二种通过把掩码矩阵的中心放在你想要计算的像素上并把像素和覆盖在上面的掩码相加来使用掩码。
最易一些较大的矩阵，第二种方式会更加简单。
现在让我们来看看我们怎样通过基本的像素处理方法和使用`CV\filter2D`函数来做上述操作。

### 基本的方法

下面是我们自己实现上面公式的代码：

```php
function Sharpen(Mat $myImage, &$result)
{
    if ($myImage->depth() != CV_8U) {// accept only uchar images
        throw new Exception("图像必须未unchar类型");
    }

    $nChannels = $myImage->channels();
    $result = Mat::zerosBySize($myImage->size(), $myImage->type());
    for ($j = 1; $j < $myImage->rows - 1; ++$j) {//从矩阵第二行开始循环到倒数第二行
        for ($i = 1; $i < $myImage->cols - 1; ++$i) {//从矩阵第二列开始循环到倒数第二列
            for ($channel = 0; $channel < $nChannels; $channel++) {//循环每个像素的矩阵通道
                $value = $myImage->at($j, $i, $channel) * 5//原中心值乘以5
                    - $myImage->at($j, $i - 1, $channel)//减去中心值左边的值
                    - $myImage->at($j, $i + 1, $channel)//减去中心值右边的值
                    - $myImage->at($j - 1, $i, $channel)//减去中心值上面的值
                    - $myImage->at($j + 1, $i, $channel);//减去中心值下面的值
                $result->at($j, $i, $channel, $value);
            }
        }
    }
    //在图像的边界上，我们未对其做任何掩码操作，所以都赋值为0
    $result->row(0)->setTo(new Scalar(0));
    $result->row($result->rows - 1)->setTo(new Scalar(0));
    $result->col(0)->setTo(new Scalar(0));
    $result->col($result->cols - 1)->setTo(new Scalar(0));
}


```

### filter2D函数实现
应用这样的过滤器和应用图像处理的其它模块是共同的。首先你需要定义一个Mat对象，持有一个这样的掩码：

```php
$kernel = new Mat(3, 3, CV\CV_8SC1);
$kernel->at(0, 0, 0, 0);
$kernel->at(0, 1, 0, -1);
$kernel->at(0, 2, 0, 0);
$kernel->at(1, 0, 0, -1);
$kernel->at(1, 1, 0, 5);
$kernel->at(1, 2, 0, -1);
$kernel->at(2, 0, 0, 0);
$kernel->at(2, 1, 0, -1);
$kernel->at(2, 2, 0, 0);
```

然后，调用filter2D函数，指定输入和输出图像，和要使用的掩码：

```php
filter2D($myImage, $filter2DResult, $myImage->depth(), $kernel);
```

## 结果
运行的结果是一样的，但是时间差距就比较明显
<div align=center>
![3.png](/images/docs/mat_mask_operations/3.png)
</div>

## 完整代码下载地址
[例子地址](https://github.com/phpopencv/tutorial-demo/tree/master/core/mat_mask_operations)