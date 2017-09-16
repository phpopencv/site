title: 更多形态学：开运算、闭运算、形态学梯度、顶帽、黑帽
--------------------------------

上一节中，我们重点了解了`腐蚀`和`膨胀`者两种基本的形态操作，而运用这两种基本操作，
可以实现更高级的形态学变化。

所以，本节的主角是PHPOpenCV中的`morphologyEx`函数，它利用基本的膨胀和腐蚀技术，
来执行更高级的形态学变换，如`开闭运算`、形态学梯度、“顶帽”、“黑帽”等。

首先，我们需要知道，形态学的高级形态，往往都是简历在腐蚀和膨胀者两个基本操作智商的。
而关于腐蚀和膨胀，概念和细节以及相关代码请参考上一小节。对膨胀和腐蚀心中有数了。接
下来的高级形态学操作，应该就不难理解。
    
## 开运算
开运算（Opening Operation），其实上就是先腐蚀后膨胀的过程。其数学表示式如下：

<div align=center>
dst = open(src,element) = dilate(erode(src,element))
</div>

开运算可以用来消除小物体，在纤细点处分离物体，并且在平滑较大物体的边界的同事不明显
改变其面积。原始图和结果图如下：


<div align=center>
![Morphology_2_Tutorial_Theory_Opening.png](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Theory_Opening.png)
</div>

## 闭运算

先膨胀后再腐蚀的过程称为闭运算（Closing Operation），其数学表达式如下：
<div align=center>
dst = close(src,element) = erode(dilate(src,element))
</div>

闭运算能够排除小型黑洞（黑色区域）。原始图和效果图如下：

<div align=center>
![Morphology_2_Tutorial_Theory_Closing.png](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Theory_Closing.png)
</div>


## 形态学梯度
形态学梯度（Morphological Gradient）是膨胀图和腐蚀图之差，数学表示式如下：
<div align=center>
dst=morph-grad(src,element) = dilate(src,element)−erode(src,element)
</div>

对二值图像进行这一操作可以将团块（blob）的边缘突出出来。我们可以用形态学梯度来保留物体的
边缘轮廓，如下图：

<div align=center>
![Morphology_2_Tutorial_Theory_Gradient.png](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Theory_Gradient.png)
</div>


## 顶帽
顶帽运算（Top Hat）又常常被译为“礼帽”运算，是原图像与上文刚刚介绍的“开运算”的结果图之差，
数学表达式如下：
<div align=center>
dst=tophat(src,element)=src−open(src,element)
</div>
因为开运算带来的结果是放大了裂缝或者局部低亮度的区域。因此，从原图中减去开运算后的图，得
到的效果图突出了比原图轮廓周围的区域更明亮的区域，且这一操作与选择的核大小有关。

顶帽运算往往用来分离比邻近点亮一些的板块。在一副图像具有大幅的背景，而微小物品比较有规律的情况下，
可以使用顶帽运算进行背景提取。
<div align=center>
![Morphology_2_Tutorial_Theory_TopHat.png](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Theory_TopHat.png)
</div>


## 黑帽
黑帽（Black Hat）运算是闭运算的结果图与原图像之差。数学表达式为：
<div align=center>
dst=blackhat(src,element)=close(src,element)−src
</div>
黑帽运算后的效果图突出了比原图轮廓周围的区域更暗的区域，且这一操作和选择的核大小相关。
所以，黑帽运算用来分离比邻近点暗一些的斑块，效果图有着非常完美的轮廓。
<div align=center>
![Morphology_2_Tutorial_Theory_BlackHat.png](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Theory_BlackHat.png)
</div>

## 综合示例

### 代码
```php
use CV\Size;
use CV\Point;
use function CV\{
    getStructuringElement, morphologyEx, imshow, namedWindow,
    createTrackbar, getTrackBarPos, waitKey
};
use function CV\imread;
use const CV\{
    IMREAD_COLOR, WINDOW_AUTOSIZE
};

$src = null;
$dst = null;

$morph_elem = 0;
$morph_size = 0;
$morph_operator = 0;
const max_operator = 4;
const max_elem = 2;
const max_kernel_size = 21;

const window_name = "Morphology Transformations Demo";
const morphOperatorTrackBarName = "Operator:0: Opening - 1: Closing  \n 2: Gradient - 3: Top Hat \n 4: Black Hat";
const morphElemTrackBarName = "Element:\n 0: Rect - 1: Cross - 2: Ellipse";
const morphSizeTrackBarName = "Kernel size:\n 2n +1";

/**
 * 定义滑条回调闭包
 */
$Morphology_Operations = function () {
    global $morph_operator;
    global $morph_elem;
    global $morph_size;
    global $src;
    global $dst;

    $morph_operator = getTrackBarPos(morphOperatorTrackBarName, window_name);
    $morph_elem = getTrackBarPos(morphElemTrackBarName, window_name);
    $morph_size = getTrackBarPos(morphSizeTrackBarName, window_name);
    // Since MORPH_X : 2,3,4,5 and 6
    //![operation]
    $operation = $morph_operator + 2;
    //![operation]

    $element = getStructuringElement($morph_elem, new Size(2 * $morph_size + 1, 2 * $morph_size + 1), new Point($morph_size, $morph_size));
    /// Apply the specified morphology operation
    morphologyEx($src, $dst, $operation, $element);
    imshow(window_name, $dst);
};


function run()
{
    global $src;
    global $Morphology_Operations;
    global $morph_operator;
    global $morph_elem;
    global $morph_size;
    $src = imread('baboon.jpg', IMREAD_COLOR); // Load an image

    if ($src->empty()) {
        return false;
    }

    namedWindow(window_name, WINDOW_AUTOSIZE); // Create window

    //创建形态学操作类型调整滑条
    createTrackbar(morphOperatorTrackBarName, window_name,
        $morph_operator, max_operator,
        $Morphology_Operations);
    //创建操作的核类型调整滑条
    createTrackbar(morphElemTrackBarName, window_name,
        $morph_elem, max_elem,
        $Morphology_Operations);
    //创建核大小调整滑条
    createTrackbar(morphSizeTrackBarName, window_name,
        $morph_size, max_kernel_size,
        $Morphology_Operations);
    imshow(window_name, $src);

    waitKey(0);
    return true;
}

run();
```

### 运行结果
<div align=center>
![Morphology_2_Tutorial_Result.jpg](/images/docs/opening_closing_hats/Morphology_2_Tutorial_Result.jpg)
</div>

### 代码下载地址

[下载地址](https://github.com/phpopencv/tutorial-demo/tree/master/ImgProc/morphologyEx)
