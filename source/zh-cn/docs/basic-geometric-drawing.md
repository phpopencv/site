title: 基本绘图
---

## 目标

在本篇教程中你将学到：

 - 如何使用`cv::addWeighted`对两张图片进行相加
 - 在图像中使用`cv::Point`定义二维点
 - 使用`cv::Scalar`以及为何它很有用
 - 使用`cv::line`绘制一条直线
 - 使用`cv::ellipse`绘制一个椭圆
 - 使用`cv::rectangle`绘制一个矩形
 - 使用`cv::circle`绘制一个圆
 - 使用`cv::fillPoly`绘制一个填充的多边形

## 原理
在本篇教程中，我们将着重使用两个对象：`cv::Point` 和 `cv::Scalar` :

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

我们就定义了一个BGR颜色参数，其中:B(Blue)的值为$a,G(Green)的值为$b,R(Red)的值为$c


## 源代码

``` php
<?php
use CV\{Mat, Point, Size, Scalar};
use const CV\{CV_8UC3, LINE_8, FILLED, lineType};
use function CV\{ellipse, circle, fillPoly, rectangle, line, imshow, moveWindow, waitKey};

define('w', 400);

$atom_window = "Drawing 1: Atom";
$rook_window = "Drawing 2: Rook";
$atom_image = Mat::zeros(w, w, CV_8UC3);
$rook_image = Mat::zeros(w, w, CV_8UC3);
MyEllipse($atom_image, 90);
MyEllipse($atom_image, 0);
MyEllipse($atom_image, 45);
MyEllipse($atom_image, -45);
MyFilledCircle($atom_image, new Point(w/2, w/2));
MyPolygon($rook_image );
rectangle( 
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
imshow($atom_window, $atom_image);
// moveWindow($atom_window, 0, 200);
imshow($rook_window, $rook_image);

waitKey( 0 );
return(0);

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

function MyFilledCircle($img, $center) {
  circle( 
      $img,
      $center,
      w/32,
      new Scalar(0, 0, 255),
      FILLED,
      LINE_8 );
}

function MyPolygon($img) {
  $lineType = LINE_8;
  $rook_points[1] = array();
  $rook_points[0][0]  = new Point(    w/4,   7*w/8 );
  $rook_points[0][1]  = new Point(  3*w/4,   7*w/8 );
  $rook_points[0][2]  = new Point(  3*w/4,  13*w/16 );
  $rook_points[0][3]  = new Point( 11*w/16, 13*w/16 );
  $rook_points[0][4]  = new Point( 19*w/32,  3*w/8 );
  $rook_points[0][5]  = new Point(  3*w/4,   3*w/8 );
  $rook_points[0][6]  = new Point(  3*w/4,     w/8 );
  $rook_points[0][7]  = new Point( 26*w/40,    w/8 );
  $rook_points[0][8]  = new Point( 26*w/40,    w/4 );
  $rook_points[0][9]  = new Point( 22*w/40,    w/4 );
  $rook_points[0][10] = new Point( 22*w/40,    w/8 );
  $rook_points[0][11] = new Point( 18*w/40,    w/8 );
  $rook_points[0][12] = new Point( 18*w/40,    w/4 );
  $rook_points[0][13] = new Point( 14*w/40,    w/4 );
  $rook_points[0][14] = new Point( 14*w/40,    w/8 );
  $rook_points[0][15] = new Point(    w/4,     w/8 );
  $rook_points[0][16] = new Point(    w/4,   3*w/8 );
  $rook_points[0][17] = new Point( 13*w/32,  3*w/8 );
  $rook_points[0][18] = new Point(  5*w/16, 13*w/16 );
  $rook_points[0][19] = new Point(    w/4,  13*w/16 );
  // const Point* ppt[1] = { rook_points[0] };
  // int npt[] = { 20 };
  // fillPoly( img,
  //       $rook_points[0],
  //       20,
  //       1,
  //       new Scalar( 255, 255, 255 ),
  //       lineType );
}

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


### 代码解释


### 运行结果

<div align = "center">
![result.png](/images/docs/basic-geometric-drawing/result.png)
</div>

  
  
