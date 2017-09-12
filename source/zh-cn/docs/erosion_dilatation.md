title: 腐蚀和膨胀
------------

## 目标

这篇教程你将会学到：
- 应用两个非常常见的形态算子：腐蚀和膨胀。为此，您将使用以下PHPOpenCV功能：
    - CV\erode
    - CV\dilate
    
## 理论

{% note tip 注意 %}
下面的解释出自浅墨的《OpenCV入门教程》
{% endnote %}

## 形态操作

形态学（morphology）一词通常表示生物学的一个分支，该分支研究研究动植物的形态和结构。而我们图像
处理的形态学，往往指数学形态学。下面一起来了解数学形态学的概念。

数学形态学（Mathematical morphology）是一门建立在`格论`和和`拓扑学`基础之上的图像分析学科，是数学
形态学图像处理的基本理论。其基本的函数包括：二值腐蚀和膨胀、二值开闭运算、骨架抽取、极限腐蚀、击
不击中变换、形态学梯度、Top-hat变换、颗粒分析、流域变换、灰度腐蚀和膨胀、灰度开闭运算、灰值形态
梯度等。

简单来讲，形态学操作的基本形状的一系列图像处理操作。PHPOpenCV未进行图像的形态学变换提供了快捷、方便的函数。
最基本的形态学操作有两种，分别是：膨胀（dilate）与腐蚀（erode）。

膨胀于腐蚀能实现多种多样的功能，主要如下。
- 消除噪声;
- 分割（isolate）出独立的图像元素，在图像中链接（join）相邻的像素;
- 寻早图像中的明显的极大值区域扩极小值区域;
- 求出图像的梯度。

在这里我们将简要说明膨胀和腐蚀，使用一下图像作为示例：
<div align=center>
![Morphology_1_Tutorial_Theory_Original_Image.png](/images/docs/erosion_dilatation/Morphology_1_Tutorial_Theory_Original_Image.png)
</div>

{% note tip 注意 %}
在提醒腐蚀和膨胀的讲解之前，首先提醒大家要注意，腐蚀和膨胀是对白色部分（高亮部分）而眼的，不是黑色部分。
膨胀是图像中的高亮部分进行膨胀，类是于“领域扩张”，效果图拥有比原图像更大的高亮区域；
腐蚀是原图中的高亮部分被腐蚀，类是于“领域被蚕食”，效果图拥有比原图像更小的高亮区域。
{% endnote %}


### 膨胀
膨胀（dilate）就是求局部最大值操作。从数学角度来说，膨胀或者腐蚀操作就是将图像（或图像的一部分区域，称之为A）
与核（称之为B）进行卷积。

核可以是任何形状和大小，它拥有一个独立定义出来的参考点，我们称其未锚点（anchorpoint）。多数情况下，核是一个小的，
中间带有参考点和实心的正方形或者圆盘。其实，可以把核视为模板或掩码。

而膨胀就是求局部最大值操作。核B与图形卷积，即计算核B覆盖的区域的像素点的最大值，并把这个最大值赋值给参考点指定的像素。
这样就会使图像中的高亮区域逐渐增长，如下图所示，这就是膨胀操作的初衷。
<div align=center>
![1.png](/images/docs/erosion_dilatation/1.png)
</div>  

示例图像膨胀后效果：
<div align=center>
![Morphology_1_Tutorial_Theory_Dilation.png](/images/docs/erosion_dilatation/Morphology_1_Tutorial_Theory_Dilation.png)
</div>  


### 腐蚀
大家应该知道，膨胀和腐蚀（erode）是相反的一堆操作，所以腐蚀就是求局部最小值的操作。
我们一般都会腐蚀和膨胀进行对比理解和学习。下文就可以看到，两者的函数原型也基本是一眼的。腐蚀操作示例如图所示：
<div align=center>
![2.png](/images/docs/erosion_dilatation/2.png)
</div>  

示例腐蚀结果图：
<div align=center>
![Morphology_1_Tutorial_Theory_Erosion.png.png](/images/docs/erosion_dilatation/Morphology_1_Tutorial_Theory_Erosion.png)
</div> 


## 程序例子

### 源码

```php
use CV\Mat;
use CV\Size;
use CV\Point;
use function CV\{
    imread,
    namedWindow,
    moveWindow,
    waitKey,
    createTrackbar,
    getStructuringElement,
    erode, imshow, dilate
};
use const CV\{
    IMREAD_COLOR, WINDOW_AUTOSIZE, MORPH_RECT, MORPH_CROSS, MORPH_ELLIPSE
};

$src = null;
$erosion_dst = null;
$dilation_dst = null;
$erosion_elem = 0;
$erosion_size = 0;
$dilation_elem = 0;
$dilation_size = 0;
const max_elem = 2;
const max_kernel_size = 21;

/**
 * 调整腐蚀核类型闭包
 * @param $num
 */
$erosionElemClosure = function ($num) {
    global $src;
    global $erosion_elem;
    global $erosion_size;
    $erosion_elem = $num;
    $erosion_type = 0;
    if ($erosion_elem == 0) {
        $erosion_type = MORPH_RECT;
    } else if ($erosion_elem == 1) {
        $erosion_type = MORPH_CROSS;
    } else if ($erosion_elem == 2) {
        $erosion_type = MORPH_ELLIPSE;
    }
    $element = getStructuringElement($erosion_type,
        new Size(2 * $erosion_size + 1, 2 * $erosion_size + 1),
        new Point($erosion_size, $erosion_size));
    $erosion_dst = null;
    erode($src, $erosion_dst, $element);
    imshow("Erosion Demo", $erosion_dst);
};

/**
 * 调整腐蚀核大小闭包
 * @param $num
 */
$erosionSizeClosure = function ($num) {
    global $src;
    global $erosion_elem;
    global $erosion_size;
    $erosion_size = $num;
    $erosion_type = 0;
    if ($erosion_elem == 0) {
        $erosion_type = MORPH_RECT;
    } else if ($erosion_elem == 1) {
        $erosion_type = MORPH_CROSS;
    } else if ($erosion_elem == 2) {
        $erosion_type = MORPH_ELLIPSE;
    }
    $element = getStructuringElement($erosion_type,
        new Size(2 * $erosion_size + 1, 2 * $erosion_size + 1),
        new Point($erosion_size, $erosion_size));
    $erosion_dst = null;
    erode($src, $erosion_dst, $element);
    imshow("Erosion Demo", $erosion_dst);
};

/**
 * 调整膨胀核类型闭包
 * @param $num
 */
$dilationElemClosure = function ($num) {
    global $src;
    global $dilation_elem;
    global $dilation_size;
    $dilation_elem = $num;
    $dilation_type = 0;
    if ($dilation_elem == 0) {
        $dilation_type = MORPH_RECT;
    } else if ($dilation_elem == 1) {
        $dilation_type = MORPH_CROSS;
    } else if ($dilation_elem == 2) {
        $dilation_type = MORPH_ELLIPSE;
    }
    $element = getStructuringElement($dilation_type,
        new Size(2 * $dilation_size + 1, 2 * $dilation_size + 1),
        new Point($dilation_size, $dilation_size));
    $dilation_dst = null;
    dilate($src, $dilation_dst, $element);
    imshow("Dilation Demo", $dilation_dst);
};

/**
 * 调整膨胀核大小闭包
 * @param $num
 */
$dilationSizeClosure = function ($num) {
    global $src;
    global $dilation_elem;
    global $dilation_size;
    $dilation_size = $num;
    $dilation_type = 0;
    if ($dilation_elem == 0) {
        $dilation_type = MORPH_RECT;
    } else if ($dilation_elem == 1) {
        $dilation_type = MORPH_CROSS;
    } else if ($dilation_elem == 2) {
        $dilation_type = MORPH_ELLIPSE;
    }
    $element = getStructuringElement($dilation_type,
        new Size(2 * $dilation_size + 1, 2 * $dilation_size + 1),
        new Point($dilation_size, $dilation_size));
    $dilation_dst = null;
    dilate($src, $dilation_dst, $element);
    imshow("Dilation Demo", $dilation_dst);
};

function run()
{
    global $src;
    global $erosion_elem;
    global $erosion_size;
    global $dilation_size;
    global $dilation_elem;
    global $erosionElemClosure;
    global $erosionSizeClosure;
    global $dilationElemClosure;
    global $dilationSizeClosure;
    $src = imread("cat.jpg", IMREAD_COLOR);//读取原图像
    if ($src->empty()) {
        die("can't load image.");
    }
    //创建两个窗口并命名
    namedWindow("Erosion Demo", WINDOW_AUTOSIZE);
    namedWindow("Dilation Demo", WINDOW_AUTOSIZE);
    moveWindow("Dilation Demo", $src->cols, 0);
    //添加调整腐蚀核类型滑条
    createTrackbar("Element:\n 0: Rect \n 1: Cross \n 2: Ellipse", "Erosion Demo",
        $erosion_elem, max_elem,
        $erosionElemClosure);
    //添加调整腐蚀核大小滑条
    createTrackbar("Kernel size:\n 2n +1", "Erosion Demo",
        $erosion_size, max_kernel_size,
        $erosionSizeClosure);
    //添加调整膨胀核类型滑条
    createTrackbar("Element:\n 0: Rect \n 1: Cross \n 2: Ellipse", "Dilation Demo",
        $dilation_elem, max_elem,
        $dilationElemClosure);
    //添加调整膨胀核大小滑条
    createTrackbar("Kernel size:\n 2n +1", "Dilation Demo",
        $dilation_size, max_kernel_size,
        $dilationSizeClosure);
    //展示原图
    imshow("Erosion Demo", $src);
    imshow("Dilation Demo", $src);

    waitKey(0);
}


run();

```

### 结果

原图效果：
<div align=center>
![cat.jpg](/images/docs/erosion_dilatation/cat.jpg)
</div> 

我们得到以下结果。自然地，改变轨道栏中的指标会给出不同的输出图像。试试吧！甚至可以尝试添加第三个Trackbar来控制迭代次数。
<div align=center>
![result.png](/images/docs/erosion_dilatation/result.png)
</div> 

### 代码下载地址
[代码下载地址](https://github.com/phpopencv/tutorial-demo/tree/master/ImgProc/erosion_dilatation)