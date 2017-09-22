title: 使用OpenCV添加（混合）两个图像
---

## 目标

在本篇教程中*你*将学到：

 - 什么是_线性混合_ 以及为何它如此有用;
 - 如何使用`cv::addWeighted`对两张图片进行相加

## 原理

{% note tip 注意 %}
下面的解释出自Richard Szeliski的[《Computer Vision: Algorithms and Applications》](http://szeliski.org/Book/)一书
{% endnote %}

通过之前的教程，我们已经对像素操作有了一点了解。一个有趣的二元（双输入）运算符是线性混合运算符：

<div align = "center">g(x)=(1−α)f0(x)+αf1(x)</div>

通过变化 α 在 0→1 之间的值，此操作可以被用于呈现两张照片（或视频）之间的淡入淡出效果, 就像在幻灯片放映和电影中看到的一样 (很酷, 对吧?)

## 源代码

``` php
<?php
use function CV\{ imread, imshow, addWeighted, waitkey};

$alpha = 0.5;
$beta = 0.0;
$dst = null;

fwrite(STDOUT, "* Enter alpha [0-1]: "); 
$input = trim(fgets(STDIN)); 

if( $input >= 0 && $input <= 1 ) { 
	$alpha = $input; 
}

$src1 = imread('./LinuxLogo.jpg');//load image1
$src2 = imread('./WindowsLogo.jpg');//load image2

$beta = 1 - $alpha;
addWeighted($src1, $alpha, $src2, $beta, 0.0, $dst);

imshow( "Linear Blend", $dst );
waitKey(0);
return 0;
```


### 代码解释

1.既然我们要执行：
								<div align = "center">g(x)=(1−α)f0(x)+αf1(x)</div>
								
								
我们就需要两张源图片 ( f0(x) 和 f1(x)). 所以我们首先按照通常的方式加载他们：

``` php
$src1 = imread('./img1.jpg');
$src2 = imread('./img2.jpg');
```

<figure class="half">
![LinuxLogo.jpg](/images/docs/adding_images/LinuxLogo.jpg)
![WindowsLogo.jpg](/images/docs/adding_images/WindowsLogo.jpg)
</figure>

 **警告：**

由于我们要相加$src1和$src2, 故而他们的尺寸（宽和高）和类型必须相同t。

2.现在我们需要生成函数中  g(x) 所表示的图像. 为此我们需要用到 cv::addWeighted  函数：
``` php
$beta = 1 - $alpha;
addWeighted($src1, $alpha, $src2, $beta, 0.0, $dst);
```

 cv::addWeighted 函数会执行如下运算:
								<div align = "center">dst=α⋅src1+β⋅src2+γ</div>
								
在这个例子中, γ 的值就是上述代码中的  0.0 这一参数。

3.创建窗口，展示图像并等待用户结束程序：
``` php
imshow( "Linear Blend", $dst );
waitKey(0);
```

### 运行结果

<div align = "center">
![result.png](/images/docs/adding_images/result.png)
</div>


### 源码地址

[https://github.com/phpopencv/tutorial-demo/tree/master/core/AddingImages](https://github.com/phpopencv/tutorial-demo/tree/master/core/AddingImages)
  
  
