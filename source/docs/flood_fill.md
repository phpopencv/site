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

### 源码
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

### 运行结果：
![1.png](/images/docs/flood_fill/1.png)

## 综合示例：漫水填充

本次的综合示例为OpenCV自带的一个程序。作者对其做了适当的修改并详细注释，供大家消化。
![2.png](/images/docs/flood_fill/2.png)
可以看到，此程序有不少按键功能。我们用鼠标对窗口中的图形进行多次单击，就可以得到类似`PhotoShp`
中的魔术棒的效果。当然短短的两百行写出来的东西，体现还是比不上PS的魔术棒工具的，代码如下：

### 源码

```php
use CV\Point;
use CV\Scalar;
use CV\Mat;
use function CV\{
    getStructuringElement, morphologyEx, imshow, namedWindow,
    createTrackbar, getTrackBarPos, waitKey, floodFill, cvtColor, setMouseCallback,
    threshold, destroyWindow
};
use function CV\imread;
use const CV\{
    IMREAD_COLOR, WINDOW_AUTOSIZE, COLOR_BGR2GRAY, CV_8UC1,
    EVENT_LBUTTONDOWN, FLOODFILL_FIXED_RANGE, THRESH_BINARY
};

$g_srcImage = null;//定义原始图
$g_dstImage = null;//目标图
$g_grayImage = null;//灰度图
$g_maskImage = null;//掩模图
$g_nFillMode = 1;//漫水填充的模式
$g_nLowDifference = 20;//负差最大值
$g_nUpDifference = 20;//正差最大值
$g_nConnectivity = 4;//表示floodFill函数标识符低八位的连通值
$g_bIsColor = true;//是否为彩色图的标识符布尔值
$g_bUseMask = false;//是否显示掩膜窗口的布尔值
$g_nNewMaskVal = 255;//新的重新绘制的像素值

function showHelpText()
{
    //输出一些帮助信息
    printf("\n\n\t欢迎来到漫水填充示例程序~");
    printf("\n\n\t本示例根据鼠标选取的点搜索图像中与之颜色相近的点，并用不同颜色标注。");

    printf("\n\n\t按键操作说明: \n\n"
        . "\t\t鼠标点击图中区域- 进行漫水填充操作\n"
        . "\t\t键盘按键【ESC】- 退出程序\n"
        . "\t\t键盘按键【1】-  切换彩色图/灰度图模式\n"
        . "\t\t键盘按键【2】- 显示/隐藏掩膜窗口\n"
        . "\t\t键盘按键【3】- 恢复原始图像\n"
        . "\t\t键盘按键【4】- 使用空范围的漫水填充\n"
        . "\t\t键盘按键【5】- 使用渐变、固定范围的漫水填充\n"
        . "\t\t键盘按键【6】- 使用渐变、浮动范围的漫水填充\n"
        . "\t\t键盘按键【7】- 操作标志符的低八位使用4位的连接模式\n"
        . "\t\t键盘按键【8】- 操作标志符的低八位使用8位的连接模式\n\n");
}

$onMouse = function (int $event, int $x, int $y) {
    global $g_nFillMode;
    global $g_nLowDifference;
    global $g_nUpDifference;
    global $g_nConnectivity;
    global $g_nNewMaskVal;
    global $g_bIsColor;
    global $g_dstImage;
    global $g_grayImage;
    global $g_bUseMask;
    global $g_maskImage;
    // 若鼠标左键没有按下，便返回
    //此句代码的OpenCV2版为：
    //if( event != CV_EVENT_LBUTTONDOWN )
    //此句代码的OpenCV3版为：
    if ($event != EVENT_LBUTTONDOWN)
        return;

    //-------------------【<1>调用floodFill函数之前的参数准备部分】---------------
    $seed = new Point($x, $y);
    $LowDifference = $g_nFillMode == 0 ? 0 : $g_nLowDifference;//空范围的漫水填充，此值设为0，否则设为全局的g_nLowDifference
    $UpDifference = $g_nFillMode == 0 ? 0 : $g_nUpDifference;//空范围的漫水填充，此值设为0，否则设为全局的g_nUpDifference

    //标识符的0~7位为g_nConnectivity，8~15位为g_nNewMaskVal左移8位的值，16~23位为CV_FLOODFILL_FIXED_RANGE或者0。
    //此句代码的OpenCV2版为：
    //int flags = g_nConnectivity + (g_nNewMaskVal << 8) +(g_nFillMode == 1 ? CV_FLOODFILL_FIXED_RANGE : 0);
    //此句代码的OpenCV3版为：
    $flags = $g_nConnectivity + ($g_nNewMaskVal << 8) + ($g_nFillMode == 1 ? FLOODFILL_FIXED_RANGE : 0);

    //随机生成bgr值
    $b = rand(0, 255);//随机返回一个0~255之间的值
    $g = rand(0, 255);//随机返回一个0~255之间的值
    $r = rand(0, 255);//随机返回一个0~255之间的值
    $rect = null;//定义重绘区域的最小边界矩形区域

    $newVal = $g_bIsColor ? new Scalar($b, $g, $r) : new Scalar($r * 0.299 + $g * 0.587 + $b * 0.114);//在重绘区域像素的新值，若是彩色图模式，取Scalar(b, g, r)；若是灰度图模式，取Scalar(r*0.299 + g*0.587 + b*0.114)

    $dst = $g_bIsColor ? $g_dstImage : $g_grayImage;//目标图的赋值
    $area = null;

    //--------------------【<2>正式调用floodFill函数】-----------------------------
    if ($g_bUseMask) {
        //此句代码的OpenCV2版为：
        //threshold(g_maskImage, g_maskImage, 1, 128, CV_THRESH_BINARY);
        //此句代码的OpenCV3版为：
        threshold($g_maskImage, $g_maskImage, 1, 128, THRESH_BINARY);
        $area = floodFill($dst, $seed, $newVal, $g_maskImage, $rect, new Scalar($LowDifference, $LowDifference, $LowDifference),
            new Scalar($UpDifference, $UpDifference, $UpDifference), $flags);
        imshow("mask", $g_maskImage);
    } else {
        $area = floodFill($dst, $seed, $newVal, null, $rect, new Scalar($LowDifference, $LowDifference, $LowDifference),
            new Scalar($UpDifference, $UpDifference, $UpDifference), $flags);
    }

    imshow("result", $dst);
    print_r($area . " 个像素被重绘\n");
};

function run()
{
    showHelpText();
    global $g_srcImage;
    global $g_dstImage;
    global $g_grayImage;
    global $g_maskImage;
    global $g_nLowDifference;
    global $g_nUpDifference;
    global $onMouse;
    global $g_bIsColor;
    global $g_bUseMask;
    $g_srcImage = imread("floodFill2.jpg", 1);
    if ($g_srcImage->empty()) {
        printf("读取图片错误~！ \n");
        return false;
    }

    $g_srcImage->copyTo($g_dstImage);//拷贝源图到目标图
    $g_grayImage = cvtColor($g_srcImage, COLOR_BGR2GRAY);//转换三通道的image0到灰度图
    $g_maskImage = new Mat($g_srcImage->rows + 2, $g_srcImage->cols + 2, CV_8UC1);//利用image0的尺寸来初始化掩膜mask

    namedWindow("result", WINDOW_AUTOSIZE);
    //创建Trackbar
    createTrackbar("Maximum of negative difference", "result", $g_nLowDifference, 255);

    createTrackbar("Maximum positive difference", "result", $g_nUpDifference, 255);
    setMouseCallback("result", $onMouse);
    //循环轮询按键
    while (true) {
        //先显示效果图
        imshow("result", $g_bIsColor ? $g_dstImage : $g_grayImage);

        //获取键盘按键
        $key = waitKey(0);
        //判断ESC是否按下，若按下便退出
        if (($key & 255) == 27) {
            printf("程序退出...........\n");
            break;
        }
        if ($key == -1) {
            continue;
        }
        $key = chr($key);
        //根据按键的不同，进行各种操作
        switch ($key) {
            //如果键盘“1”被按下，效果图在在灰度图，彩色图之间互换
            case '1':
                if ($g_bIsColor)//若原来为彩色，转为灰度图，并且将掩膜mask所有元素设置为0
                {
                    printf("键盘“1”被按下，切换彩色/灰度模式，当前操作为将【彩色模式】切换为【灰度模式】\n");
                    $g_grayImage = cvtColor($g_srcImage, COLOR_BGR2GRAY);
                    $g_maskImage->setTo(new Scalar(0, 0, 0, 0));    //将mask所有元素设置为0
                    $g_bIsColor = false;    //将标识符置为false，表示当前图像不为彩色，而是灰度
                } else//若原来为灰度图，便将原来的彩图image0再次拷贝给image，并且将掩膜mask所有元素设置为0
                {
                    printf("键盘“1”被按下，切换彩色/灰度模式，当前操作为将【彩色模式】切换为【灰度模式】\n");
                    $g_srcImage->copyTo($g_dstImage);
                    $g_maskImage->setTo(new Scalar(0, 0, 0, 0));
                    $g_bIsColor = true;//将标识符置为true，表示当前图像模式为彩色
                }
                break;
            //如果键盘按键“2”被按下，显示/隐藏掩膜窗口
            case '2':
                if ($g_bUseMask) {
                    destroyWindow("mask");
                    $g_bUseMask = false;
                } else {
                    namedWindow("mask", 0);
                    $g_maskImage->setTo(new Scalar(0, 0, 0, 0));
                    imshow("mask", $g_maskImage);
                    $g_bUseMask = true;
                }
                break;
            //如果键盘按键“3”被按下，恢复原始图像
            case '3':
                printf("按键“3”被按下，恢复原始图像\n");
                $g_srcImage->copyTo($g_dstImage);
                $g_grayImage = cvtColor($g_dstImage, COLOR_BGR2GRAY);
                $g_maskImage->setTo(new Scalar(0, 0, 0, 0));
                break;
            //如果键盘按键“4”被按下，使用空范围的漫水填充
            case '4':
                printf("按键“4”被按下，使用空范围的漫水填充\n");
                $g_nFillMode = 0;
                break;
            //如果键盘按键“5”被按下，使用渐变、固定范围的漫水填充
            case '5':
                printf("按键“5”被按下，使用渐变、固定范围的漫水填充\n");
                $g_nFillMode = 1;
                break;
            //如果键盘按键“6”被按下，使用渐变、浮动范围的漫水填充
            case '6':
                printf("按键“6”被按下，使用渐变、浮动范围的漫水填充\n");
                $g_nFillMode = 2;
                break;
            //如果键盘按键“7”被按下，操作标志符的低八位使用4位的连接模式
            case '7':
                printf("按键“7”被按下，操作标志符的低八位使用4位的连接模式\n");
                $g_nConnectivity = 4;
                break;
            //如果键盘按键“8”被按下，操作标志符的低八位使用8位的连接模式
            case '8':
                printf("按键“8”被按下，操作标志符的低八位使用8位的连接模式\n");
                $g_nConnectivity = 8;
                break;
        }
    }
    return true;

}

run();
```

### 运行结果
![3.png](/images/docs/flood_fill/3.png)![4.png](/images/docs/flood_fill/4.png)


## 代码下载地址
[源码地址](https://github.com/phpopencv/tutorial-demo/tree/master/ImgProc/floodFill)