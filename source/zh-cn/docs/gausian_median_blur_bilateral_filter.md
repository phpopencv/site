title: 图像平滑处理
-------------

## 目标

在本教程中，您将学习如何使用多种线性滤镜来平滑使用PHPOpenCV功能的图像，如：

- 均值滤波————CV\blur 函数
- 高斯滤波————CV\GaussianBlur函数
- 中值滤波————CV\medianBlur函数
- 双边滤波————CV\bilateralFilter函数

## 原理

{% note tip 注意 %}
下面的解释出自Richard Szeliski的[《Computer Vision: Algorithms and Applications》](http://szeliski.org/Book/)一书
{% endnote %}


- 平滑，也称为模糊，是一种简单而经常使用的图像处理操作。
- 平滑的原因很多。在本教程中，我们将专注于平滑以减少噪音（其他用途将在以下教程中看到）。
- 我们使用滤波器对图像进行平滑操作。最常见的是滤波器是线性滤波器，线性滤波处理输出的像素值`g(i,j))`为输入像素值`f(i+k,j+l)`的加权和

<div align=center>
![1.png](/images/docs/gausian_median_blur_bilateral_filter/1.png)
</div>



