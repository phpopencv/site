title: 漫水填充
-----------

本节我们将一起探讨OpenCV填充算法中漫水填充算法的相关的知识点，并了解OpenCV中实现漫水填充算法
的两个版本的`floodFill`函数的使用方法。

## 漫水填充的定义

漫水填充法是一种特定的颜色填充连通的区域，通过设置可连通像素的上下限以及联通方式来达到漫水填充经
常用来标记或分离图像的一部分，以便对其进行进一步处理或分析，也可以用来从输入图像获取掩码区域，
掩码会加速处理过程，或只处理掩码执定的像素点，操作的结果总是某个连续的区域。

## 漫水天从法的基本思想
所谓漫水填充，简单来说，就是自动选中了和种子点相连的区域，接着将该区域替换成指定的颜色，
这是个非常游泳的功能，经常用来标记或者分离图像的一部分进行处理或分析。漫水填充也可以用来
标记或分离图像的一部分，以便对其进行进一步处理或分析，也可以用来从输入图像获取掩码区域，
掩码会加速处理过程，或只处理掩码执定的像素点。

以填充算法为基础，类似PhotoShop的`魔术棒`选择工具就很容易实现了。漫水填充（FloodFill）是
查找和种子点连接的颜色相同点，魔术棒选择工具则是查找和种子点联通的颜色相近的点，把和初始种子像素
相近的点压进栈作为新的种子。


在PHPOpenCV中，漫水填充是填充算法中最通用的方法。他把原C++版OpenCV中重载的两个`FloodFill`函数
合并为一个。其中第4个参数中mask起关键区别作用。这个掩膜mask，就是用于进一步控制那些区域将被
填充颜色（比如说当对同意图像进行多次填充时）。其异同为：
- 相同的是：都在图像中选择一个种子点，然后把临近区域所有相似点填充上同样的颜色
- 不同的是：不一定将所有邻近像素点都染上同一颜色，漫水填充操作的结果总是某个连续的区域

当邻近像素位于给定的范围（从`$loDiff`到`$upDiff`）内或在原始`$seedPoint`像素值范围内时，
FloodFill函数就会为这个点涂上颜色。

## floodFill函数：
在PHPOpenCV中，漫水填充算法是由`floodFill`函数来实现，其作用是用我们指定的颜色从种子点开始填充一个
连接域。连通性由像素的接近值程度来衡量。源函数如下
```php
function floodFill(Mat $image, Point $seedPoint, Scalar $newVal, Mat $mat = null, Rect $rect = null, Scalar $loDiff = null, Scalar $upDiff = null, int $flags = 4)
{
    \\....
}
```

- （1）第一个参数，`Mat`类型的`$image`，输入/输出1通道或3通道，8位或浮点图像，具体参数由之后参数指明。
- （2）第二个参数，`Point`类型的`$seedPoint`，漫水填充算法的起始点。
- （3）弟三个参数，`Scalar`类型的`$newVal`，像素点被染色的值，即在重绘区域像素的新值。
- （4）第四个参数，`Mat`类型的`$mask`，表示操作掩膜。它应该为单通道，8位，长和宽上都比输入图像
`$image`大两个像素点的图像。`floodFill`需要使用以及更新掩膜。需要注意的是，漫水填充不会填充`$mask`
的非零像素区域。例如，一个边缘检测算子的输出可以用来作为掩膜，以防填充到边缘。同样的，也可以在多次的
函数调用中使用同一个掩膜，以确保填充的区域不会重叠。另外需要注意的是，掩膜`$mask`会闭需要填充的图像大，
所以`$mask`中与输入图像`(x,y)`像素点对应的点的坐标为(x+1,y+1)。
- （5）第五个参数，`Rect`类型的`$rect`，默认值为null，一个可选的参数，用于设置`floodFill`函数将
要重绘制区域的最小边界矩形区域。
- （6）第六个参数，`Scalar`类型的`$loDiff`，有默认值为null，表示当前观察像素值与其部件邻域像素值
或者待加入该部件的种子像素之间的亮度或颜色之负差（lower brightness/color difference）的最大值。
- （7）第七个参数，`Scalar`类型的`$loDiff`，有默认值为null，表示当前观察像素值与其部件邻域像素值
或者待加入该部件的种子像素之间的亮度或颜色之正差（lower brightness/color difference）的最大值。
- （8）第八个参数，`int`类型的`$flags`，操作标识符，此参数包含三个部分，比较复杂，我们一起详细看看。
    - （A） 低八位（第0～7位）用于控制算法的连通性 ，可取4（4为默认值）或者8.如果设为4,表示填充算法只考
    虑当前像素水平方向和垂直方向的相邻点;如果设为8，除上述相邻点外，还会包含对角线方向的相邻点。
    - （B） 高八位（16～23位）可以为0或者如下两种选项标识符的组合。
        - ① FLOODFILL_EIXED_RANGE：如果设置未这个标识符，就会考虑当前像素与种子像素之间的差，否则
         就考虑当前像素与其相邻像素的差。也就是说，这个范围是否动的。
        - ② FLOODFILL_MASK_ONLY:如果设置为这个标识符，函数不会去填充改变原始像素（也就是忽略第三个参数
        `$newVal`），而是去填充掩膜图像（`$mask`）。
        
    - （C）中间八位部分，上面关于高八位FLOODFILL_MASK_ONLY标识符中已经说得很明显，素要输入符合要求的掩码。
    floodFill的$flags参数的中间八位的值就是用于指定填充掩码图像的值。但是如果$flags中间八位的值未
    0，则掩码会用1来填充

## 简单例子
接着，来看一个关于`floodFill`的简单调用范例。
```php
use CV\Point;
use CV\Scalar;
use CV\Rect;
use function CV\{
    getStructuringElement, morphologyEx, imshow, namedWindow,
    createTrackbar, getTrackBarPos, waitKey, floodFill
};
use function CV\imread;
use const CV\{
    IMREAD_COLOR, WINDOW_AUTOSIZE
};

$src = imread("demo.jpg");
$rect = new Rect(0,0,0,0);
imshow('origin', $src);
floodFill($src, new Point(50, 300), new Scalar(155, 255, 55), null, $rect, new Scalar(20, 20, 20), new Scalar(20, 20, 20));
imshow('result', $src);

waitKey(0);
```

运行结果：
![1.png](/images/docs/flood_fill/1.png)