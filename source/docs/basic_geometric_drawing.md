title: 基本绘图
---

## 目标

在本篇教程中你将学到：

 - 在图像中使用`CV\Point`定义二维点
 - 使用`CV\Scalar`以及为何它很有用
 - 使用`CV\line`绘制一条直线
 - 使用`CV\ellipse`绘制一个椭圆
 - 使用`CV\rectangleByPoint`绘制一个矩形
 - 使用`CV\circle`绘制一个圆
 - 使用`CV\fillPoly`绘制一个填充的多边形

## 原理
在本篇教程中，我们将着重使用两个对象：`CV\Point` 和 `CV\Scalar` :

### Point对象
Point对象表示一个由它的图像坐标`x`和`y`指定的二维点。我们可以像下面这样定义它：

``` php
$pt = new Ponit();
$pt->x = 10;
$pt->y = 8;
```
或

``` php
$pt = new Ponit(10,8);
```

### Scalar对象

 - 代表一个4元素的向量。 Scalar对象在PHPOpenCV中被广泛地用于传递像素的值。
 - 在本教程中，我们将使用它来表示BGR颜色值（3个参数）。 如果不打算使用最后一个参数的话，则无需定义它。
 - 让我们来看个小例子， 当我们需要一个代表颜色的参数时，像下面这样写：
``` php
$color = new Scalar($a, $b, $c);
```

这样我们就定义了一个`BGR`表示的颜色参数，其中:B(Blue)的值为$a,G(Green)的值为$b,R(Red)的值为$c


## 源代码

``` php
namespace CV;

use CV\{
    Mat, Point, Size, Scalar
};
use const CV\{
    CV_8UC3, LINE_8, FILLED
};
use function CV\{
    ellipse, circle, fillPoly, rectangleByPoint, line, imshow, moveWindow, waitKey
};

define('w', 400);

$atom_window = "Drawing 1: Atom";
$rook_window = "Drawing 2: Rook";
$atom_image = Mat::zeros(w, w, CV_8UC3);
$rook_image = Mat::zeros(w, w, CV_8UC3);
MyEllipse($atom_image, 90);
MyEllipse($atom_image, 0);
MyEllipse($atom_image, 45);
MyEllipse($atom_image, -45);
MyFilledCircle($atom_image, new Point(w / 2, w / 2));
MyPolygon($rook_image);
rectangleByPoint(
    $rook_image,
    new Point(0, 7 * w / 8),
    new Point(w, w),
    new Scalar(0, 255, 255),
    FILLED,
    LINE_8);
MyLine($rook_image, new Point(0, 15 * w / 16), new Point(w, 15 * w / 16));
MyLine($rook_image, new Point(w / 4, 7 * w / 8), new Point(w / 4, w));
MyLine($rook_image, new Point(w / 2, 7 * w / 8), new Point(w / 2, w));
MyLine($rook_image, new Point(3 * w / 4, 7 * w / 8), new Point(3 * w / 4, w));
imshow($atom_window, $atom_image);
moveWindow($atom_window, 0, 200);
imshow($rook_window, $rook_image);
moveWindow($rook_window, w, 200);
waitKey(0);
return (0);

function MyEllipse($img, $angle)
{
    $thickness = 2;
    $lineType = 8;
    ellipse(
        $img,
        new Point(w / 2, w / 2),
        new Size(w / 4, w / 16),
        $angle,
        0,
        360,
        new Scalar(255, 0, 0),
        $thickness,
        $lineType);
}

function MyFilledCircle($img, $center)
{
    circle(
        $img,
        $center,
        w / 32,
        new Scalar(0, 0, 255),
        FILLED,
        LINE_8);
}

function MyPolygon($img)
{
    $lineType = LINE_8;
    $rook_points[0] = new Point(w / 4, 7 * w / 8);
    $rook_points[1] = new Point(3 * w / 4, 7 * w / 8);
    $rook_points[2] = new Point(3 * w / 4, 13 * w / 16);
    $rook_points[3] = new Point(11 * w / 16, 13 * w / 16);
    $rook_points[4] = new Point(19 * w / 32, 3 * w / 8);
    $rook_points[5] = new Point(3 * w / 4, 3 * w / 8);
    $rook_points[6] = new Point(3 * w / 4, w / 8);
    $rook_points[7] = new Point(26 * w / 40, w / 8);
    $rook_points[8] = new Point(26 * w / 40, w / 4);
    $rook_points[9] = new Point(22 * w / 40, w / 4);
    $rook_points[10] = new Point(22 * w / 40, w / 8);
    $rook_points[11] = new Point(18 * w / 40, w / 8);
    $rook_points[12] = new Point(18 * w / 40, w / 4);
    $rook_points[13] = new Point(14 * w / 40, w / 4);
    $rook_points[14] = new Point(14 * w / 40, w / 8);
    $rook_points[15] = new Point(w / 4, w / 8);
    $rook_points[16] = new Point(w / 4, 3 * w / 8);
    $rook_points[17] = new Point(13 * w / 32, 3 * w / 8);
    $rook_points[18] = new Point(5 * w / 16, 13 * w / 16);
    $rook_points[19] = new Point(w / 4, 13 * w / 16);
    fillPoly($img,
        $rook_points,
        new Scalar(255, 255, 255),
        $lineType);
}

function MyLine($img, $start, $end)
{
    $thickness = 2;
    $lineType = LINE_8;
    line($img,
        $start,
        $end,
        new Scalar(0, 0, 0),
        $thickness,
        $lineType);
}

```


### 代码解释
1.既然我们打算绘制两张示例图片 (一张原子图和一张国际象棋中的车的图篇)，我们需要创建两张图片和两个窗口来展示它们。
  ``` php
  $atom_window = "Drawing 1: Atom";
  $rook_window = "Drawing 2: Rook";
  $atom_image = Mat::zeros(w, w, CV_8UC3);
  $rook_image = Mat::zeros(w, w, CV_8UC3);
  ```
  
2.我们创建函数来绘制不同的几何图形。 例如，我们使用`MyEllipse`和`MyFilledCircle`绘制原子图：
   ``` php
   MyEllipse($atom_image, 90);
   MyEllipse($atom_image, 0);
   MyEllipse($atom_image, 45);
   MyEllipse($atom_image, -45);
   MyFilledCircle($atom_image, new Point(w/2, w/2));
  ```
3.为了绘制国际象棋中的车，我们使用`MyLine`, `rectangleByPoint` 和`MyPolygon`:
   ``` php
    MyPolygon($rook_image);
    rectangleByPoint( 
           $rook_image,
           new Point( 0, 7*w/8 ),
           new Point( w, w),
           new Scalar( 0, 255, 255 ),
           FILLED,
           LINE_8 );
    MyLine($rook_image, new Point( 0, 15*w/16 ), new Point( w, 15*w/16 ));
    MyLine($rook_image, new Point( w/4, 7*w/8 ), new Point( w/4, w ));
    MyLine($rook_image, new Point( w/2, 7*w/8 ), new Point( w/2, w ));
    MyLine($rook_image, new Point( 3*w/4, 7*w/8 ), new Point( 3*w/4, w ));
  ```

4.让我们检查一下这些函数的内部实现：
 * MyLine
    ``` php
    function MyLine($img, $start, $end) {
      $thickness = 2;
      $lineType = LINE_8;
      line( 
        $img,
        $start,
        $end,
        new Scalar(0, 0, 0),
        $thickness,
        $lineType );
    }
    ```

    如所见, `MyLine` 仅仅调用`CV\line`函数 , which does the following:
     - 从起始点($start)到终点($end)绘制一条直线 
     - 该线会被展示在`$img`参数所表示的图像中
     - 该线的颜色由参数`new Scalar(0, 0, 0)`决定，这是一RGB表示色，对应的颜色是黑色
     - 该线的宽度由`$thicknes`参数设置 (在此例中其值为2)
     - 该线为八连接线型(a 8-connected one), `$lineType = LINE_8`

 * MyEllipse
    ``` php
    function MyEllipse($img, $angle) {
      $thickness = 2;
      $lineType = 8;
      ellipse(
           $img,
           new Point( w/2, w/2 ),
           new Size( w/4, w/16 ),
           $angle,
           0,
           360,
           new Scalar(255, 0, 0),
           $thickness,
           $lineType );
    }
    ```
    从上方的代码中，我们可以观察到`CV\ellipse`函数会绘制这样的一个椭圆：
     - 该椭圆会被展示在`$img`参数所表示的图像中
     - 该椭圆的几何中心位于点`new Point(w/2, w/2)` 并被封闭在一个大小为`new Size(w/4, w/16)` 的盒子中（注：实际上`w/4`, `w/16`分别代表该椭圆的横半轴轴长和纵半轴轴长）
     - 该椭圆会转动的角度为`$angle`度
     - 椭圆弧起始角度为`0`,椭圆弧终止角度为`360`
     - 图像的颜色会是`new Scalar(255, 0, 0)` ，这在BGR颜色系统中表示蓝色
     - 该椭圆的宽度为2
     
 * MyFilledCircle
     ``` php
     function MyFilledCircle($img, $center) {
       circle( 
           $img,
           $center,
           w/32,
           new Scalar(0, 0, 255),
           FILLED,
           LINE_8 );
     }
     ```

     同`ellipse`函数相似，我们可以观察到`circle`函数接收如下参数：
     - 该圆会被展示在`$img`参数所表示的图像中
     - 该圆的几何中心位于点`$center`
     - 该圆的半径为`w/32`
     - 该圆的颜色为`new Scalar(255, 0, 0)` ，这在BGR颜色系统中表示红色
     - 由于`$thickness = -1` （`$thickness`参数默认值为`-1`），该圆将被绘制填充满


 * MyPolygon
     ``` php
     function MyPolygon($img)
         {
             $lineType = LINE_8;
             $rook_points[0] = new Point(w / 4, 7 * w / 8);
             $rook_points[1] = new Point(3 * w / 4, 7 * w / 8);
             $rook_points[2] = new Point(3 * w / 4, 13 * w / 16);
             $rook_points[3] = new Point(11 * w / 16, 13 * w / 16);
             $rook_points[4] = new Point(19 * w / 32, 3 * w / 8);
             $rook_points[5] = new Point(3 * w / 4, 3 * w / 8);
             $rook_points[6] = new Point(3 * w / 4, w / 8);
             $rook_points[7] = new Point(26 * w / 40, w / 8);
             $rook_points[8] = new Point(26 * w / 40, w / 4);
             $rook_points[9] = new Point(22 * w / 40, w / 4);
             $rook_points[10] = new Point(22 * w / 40, w / 8);
             $rook_points[11] = new Point(18 * w / 40, w / 8);
             $rook_points[12] = new Point(18 * w / 40, w / 4);
             $rook_points[13] = new Point(14 * w / 40, w / 4);
             $rook_points[14] = new Point(14 * w / 40, w / 8);
             $rook_points[15] = new Point(w / 4, w / 8);
             $rook_points[16] = new Point(w / 4, 3 * w / 8);
             $rook_points[17] = new Point(13 * w / 32, 3 * w / 8);
             $rook_points[18] = new Point(5 * w / 16, 13 * w / 16);
             $rook_points[19] = new Point(w / 4, 13 * w / 16);
             fillPoly($img,
                 $rook_points,
                 new Scalar(255, 255, 255),
                 $lineType);
         }
     ```

     绘制一个填充的多边形，我们使用函数`CV\fillPoly`。我们注意到：:
     - 在$img上绘制多边形
     - 传入需要绘制的点数组，数组中每个值用`CV\Point`对象表示，这里我们传入20个点
     - 多边形的颜色由Scalar（255,255,255）定义，它是白色的BGR值

 * rectangleByPoint
     ``` php
     rectangleByPoint( 
            $rook_image,
            new Point( 0, 7*w/8 ),
            new Point( w, w),
            new Scalar( 0, 255, 255 ),
            FILLED,
            LINE_8 );
     ```

     最后我们再来看一下`CV\rectangleByPoint` 函数:
     - 该矩形会被绘制在`$rook_image`参数所表示的图像中
     - 该矩形的两个对角顶点由`new Point( 0, 7*w/8 )` 和`new Point( w, w)`决定
     - 该矩形的颜色为`new Scalar( 0, 255, 255 )`，这在BGR颜色系统中表示黄色
     - 由于`$thickness`参数给定的值为`FILLED` （即-1），该矩形将被绘制填充满

### 运行结果
运行你的程序后会返回如下结果：

![result.png](/images/docs/basic_geometric_drawing/result.png)

### 源码地址

[https://github.com/phpopencv/tutorial-demo/blob/master/Matrix/Drawing_1.php](https://github.com/phpopencv/tutorial-demo/blob/master/Matrix/Drawing_1.php)



  
