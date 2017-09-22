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

`h(k,l)`被称为内核，它只不过是过滤器的系数。  
它有助于可视化过滤器作为一个窗口的系数滑动横跨图像
- 有很多种过滤器，这里我们将提到最常用的：
 
## 归一化框过滤器

- 这个过滤器是最简单的！每个输出像素是其内核邻居的均值（均为相等权重）
- 内核如下：

<div align=center>
![2.png](/images/docs/gausian_median_blur_bilateral_filter/2.png)
</div>

## 高斯滤波器

- 可能是最有用的过滤器（虽然不是最快的）。高斯滤波是通过将输入数组中的每个点与高斯核进行卷积来完成的，然后将它们相加以产生输出数组。
- 只是为了使图片更清晰，一维高斯内核是这样的

<div align=center>
![3.jpg](/images/docs/gausian_median_blur_bilateral_filter/3.jpg)
</div>

假设图像为1D，您可以注意到位于中间的像素将具有最大的权重。其邻居的权重随着它们与中心像素之间的空间距离的增加而减小。

{% note tip 注意 %}
2D高斯可以表示为：
    <div align=center>
    ![4.png](/images/docs/gausian_median_blur_bilateral_filter/4.png)
    </div>
    
其中μ是平均值（峰值）和σ表示方差（每个变量x和y）
{% endnote %}


## 中值滤波
中值滤波器遍历信号的每个元素（在这种情况下为图像），并用其相邻像素的中位数（位于估计像素周围的正方形邻域）中替换每个像素。


## 双边滤波

- 到目前为止，我们已经解释了一些过滤器，其主要目标是平滑输入图像。然而，有时过滤器不仅可以消除噪音，还可以使边缘平滑。为了避免这种情况（至少在一定程度上），我们可以使用双边筛选器。
- 以与高斯滤波器类似的方式，双边滤波器也考虑相邻像素，其权重分配给它们。这些权重具有两个分量，其中第一个是高斯滤波器使用的相同加权。第二个组件考虑了相邻像素与被评估的像素之间的强度差异。
- 有关更详细的说明，您可以查看此链接

## 代码例子

- 这个程序是做什么的？
    - 加载图像
    - 应用4种不同的过滤器（在理论中解释），并顺序显示过滤的图像
- 可下载的代码：[点击这里](https://github.com/phpopencv/tutorial-demo/tree/master/ImgProc/Smoothing)
- 代码一览：

```php
use CV\{
    Mat, Point, Scalar, Size
};
use function CV\{
    putText, imshow, waitKey, namedWindow, imread,
    blur, GaussianBlur, medianBlur, bilateralFilter,moveWindow
};

use const CV\{
    FONT_HERSHEY_COMPLEX, WINDOW_AUTOSIZE, IMREAD_COLOR
};

const DELAY_CAPTION = 1500;
const DELAY_BLUR = 100;
const MAX_KERNEL_LENGTH = 31;

$windowName = 'Smoothing Demo';
$src = null;
$dst = null;

function displayCaption(string $caption)
{
    global $src, $dst, $windowName;
    $dst = Mat::zerosBySize($src->size(), $src->type());
    putText(
        $dst,
        $caption,
        new Point($src->cols / 4, $src->rows / 2),
        FONT_HERSHEY_COMPLEX,
        1,
        new Scalar(255, 255, 255)
    );

    imshow($windowName, $dst);
    $key = waitKey(DELAY_CAPTION);
    if ($key >= 0) {
        return -1;
    }
    return 0;
}

function displayDst(int $delay)
{
    global $dst, $windowName;
    imshow($windowName, $dst);
    $key = waitKey($delay);
    if ($key >= 0) {
        return -1;
    }
    return 0;
}

function run()
{
    global $windowName, $src, $dst;
    namedWindow($windowName, WINDOW_AUTOSIZE);
    moveWindow($windowName,0,0);

    // Load the source image
    $src = imread("lena.jpg", IMREAD_COLOR);

    if (displayCaption("Original Image") != 0) {
        return 0;
    }
    $dst = $src->clone();
    if (displayDst(DELAY_CAPTION) != 0) {
        return 0;
    }

    /// Applying Homogeneous blur
    if (displayCaption("Homogeneous Blur") != 0) {
        return 0;
    }

    //![blur]
    for ($i = 1; $i < MAX_KERNEL_LENGTH; $i = $i + 2) {
        blur($src, $dst, new Size($i, $i), new Point(-1, -1));
        if (displayDst(DELAY_BLUR) != 0) {
            return 0;
        }
    }
    //![blur]

    /// Applying Gaussian blur
    if (displayCaption("Gaussian Blur") != 0) {
        return 0;
    }

    //![gaussianblur]
    for ($i = 1; $i < MAX_KERNEL_LENGTH; $i = $i + 2) {
        GaussianBlur($src, $dst, new Size($i, $i), 0, 0);
        if (displayDst(DELAY_BLUR) != 0) {
            return 0;
        }
    }
    //![gaussianblur]

    /// Applying Median blur
    if (displayCaption("Median Blur") != 0) {
        return 0;
    }

    //![medianblur]
    for ($i = 1; $i < MAX_KERNEL_LENGTH; $i = $i + 2) {
        medianBlur($src, $dst, $i);
        if (displayDst(DELAY_BLUR) != 0) {
            return 0;
        }
    }
    //![medianblur]

    /// Applying Bilateral Filter
    if (displayCaption("Bilateral Blur") != 0) {
        return 0;
    }

    //![bilateralfilter]
    for ($i = 1; $i < MAX_KERNEL_LENGTH; $i = $i + 2) {
        bilateralFilter($src, $dst, $i, $i * 2, $i / 2);
        if (displayDst(DELAY_BLUR) != 0) {
            return 0;
        }
    }
    //![bilateralfilter]

    /// Wait until user press a key
    displayCaption("End: Press a key!");

    waitKey(0);

    return 0;


}

run();
```

### 运行结果

<div align=center>
    <video id="video" controls="" src="/images/docs/gausian_median_blur_bilateral_filter/result.mp4">
          <p>Your user agent does not support the HTML5 Video element.</p>
    </video>
</div>



