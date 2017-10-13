title: 人脸识别
-----------

{% note tip 注意 %}
注意：如果你想要扩展支持人脸识别功能，那么在安装OpenCV时候，需要安装[contrib模块](install.html#下载opencv-contrib模块)
{% endnote %}

PHPOpenCV使用FaceRecognizer类做人脸识别，所以你可以开始尝试人脸识别吧。本章将教你如何做基本的人脸识别。
目前可用的算法是：

- Eigenfaces (see EigenFaceRecognizer::create)
- Fisherfaces (see FisherFaceRecognizer::create)
- Local Binary Patterns Histograms (see LBPHFaceRecognizer::create)

## 人脸库Face Database

我们先获取一些数据来进行实验吧。我不想在这里做一个幼稚的例子。我们在研究人脸识别，所以我们需要一个真的人脸图像！
你可以自己创建自己的数据集，也可以从这里[http://face-rec.org/databases](http://face-rec.org/databases/)下载一个。

- [AT&TFacedatabase](http://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html)又称ORL人脸数据库，
    - 40个人，每人10张照片。照片在不同时间、不同光照、不同表情(睁眼闭眼、笑或者不笑)、不同人脸细节(戴眼镜或者不戴眼镜)下采集。
    - 所有的图像都在一个黑暗均匀的背景下采集的，正面竖直人脸(有些有有轻微旋转)。



- [YaleFacedatabase A](http://vision.ucsd.edu/content/yale-face-database) ORL数据库对于初始化测试比较适合，
    - 但它是一个简单的数据库，特征脸已经可以达到97%的识别率，所以你使用其他方法很难得到更好的提升。
    - Yale人脸数据库是一个对于初始实验更好的数据库，因为识别问题更复杂。
    - 这个数据库包括15个人(14个男人,1个女人)，每一个都有11个灰度图像，大小是320*243像素。数据库中有光照变化(中心光照、左侧光照、右侧光照)、表情变化(开心、正常、悲伤、瞌睡、惊讶、眨眼)、眼镜(戴眼镜或者没戴)。



- [ExtendedYale Facedatabase B](http://vision.ucsd.edu/~leekc/ExtYaleDatabase/ExtYaleB.html)
    - 此数据库包含38个人的2414张图片，并且是剪裁好的。这个数据库重点是测试特征提取是否对光照变化强健，因为图像的表情、遮挡等都没变化。
    - 我认为这个数据库太大，不适合这篇文章的实验，我建议使用ORL数据库。


## 数据准备

### 准备基本的数据图像
这里我们采用[AT&TFacedatabase](http://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html)数据集，又称ORL。
下载它并解压，可以看到一下结构：
![att_faces.png](/images/docs/face/att_faces.png)
可以看到每个人一个文件夹，每个文件夹下是这个人的十张照片，但是不是我们熟悉的BMP或者是PNG或者是JPEG格式的，而是PGM格式的。

### 准备自己的图像数据
准备好基本的人脸数据库后，我们不是要识别数据库的人脸，我们要做识别我们自己。既然这样，我们还需要准备自己的人俩图像

首先我们先写一个程序调用电脑摄像头进行对自己的头像拍摄

```php
use CV\VideoCapture;
use function CV\{
    waitKey, imshow, imwrite,destroyWindow
};

$capture = new VideoCapture();//创建视频对象
$capture->open(0);//打开电脑一个摄像头
if (!$capture->isOpened()) {
    exit('打开摄像头失败');
}
$frame = null;
$number = 1;
while (true) {
    $capture->read($frame);//把当前摄像头的图像捕捉并保存到$frame变量当中
    imshow("frame", $frame);//暂时摄像头捕捉到的图像
    $key = waitKey(50);//等待用户输入
    $myPicsPath = realpath('./myPics');//保存拍摄自己人脸的路径
    $filename = $myPicsPath . '/pic' . $number . '.jpg';//保存图像名称
    if ($key != -1) {
        $key = chr($key);
    }
    switch ($key) {
        case'p'://当用户键入'p'则拍照
            $number++;
            imwrite($filename, $frame);//保存图像
            imshow("photo", $frame);
            waitKey(500);
            destroyWindow("photo");
            break;
        case 's'://当用户键入's'，跳出循环
            break 2;
        default:
            break;
    }
}
```
保存为`photograph.php`，并直接用cli模式运行，然后让我们对着摄像头拍10张照片，这里我们只需要10张就足够了。
- 按“`p`”进行拍照
- 按“`s`”退出程序

![myPics.png](/images/docs/face/myPics.png)

### 对自己人脸图像预处理
在得到自己的人脸照片之后，还需要对这些照片进行一些预处理才能拿去训练模型。所谓预处理，其实就是检测并分割出人脸，并改变人脸的大小与下载的数据集中图片大小一致。
人脸检测在之前已经做了介绍。详情参考：[级联分类器](cascade_classifier.html)。用ROI分割即可。

检测出人脸之后改变大小使之与ORL人脸数据库人脸大小一致。
通过加断点在Locals里面或者是ImageWatch可以看到ORL人脸数据库人脸的大小是92 x 112。
![1.png](/images/docs/face/1.png)
这里只需要对检测后得到的ROI做一次resize即可。
#### 预处理代码
```php
use CV\CascadeClassifier;
use CV\Size;
use CV\Mat;
use function CV\{
    imread, cvtColor, equalizeHist, waitKey,resize,imwrite,imshow
};
use const CV\{
    COLOR_BGR2GRAY,CV_HAAR_DO_ROUGH_SEARCH
};

$cascadeClassifier = new CascadeClassifier();
$cascadeClassifier->load('./haarcascade_frontalface_alt2.xml');

$faces = [];
$imgGray = null;
$number = 10;
for ($i = 1; $i <= $number; $i++) {
    $filePath = './myPics/pic' . $i . '.jpg';
    if ($filePath = realpath($filePath)) {
        $img = imread($filePath);
        $imgGray = cvtColor($img, COLOR_BGR2GRAY);
        equalizeHist($imgGray, $imgGray);
        $cascadeClassifier->detectMultiScale($imgGray, $faces, 1.1, 3, CV_HAAR_DO_ROUGH_SEARCH, new Size(50, 50));
        for ($j = 0; $j < count($faces); $j++) {
            $faceROI = $img->getImageROI($faces[$j]);
            $MyFace = null;
            if ($faceROI->cols > 100) {
                resize($faceROI, $MyFace, new Size(92, 112));
                $facePath = './myFaces/';
                $facePath = realpath($facePath).'/MyFcae' . $i . '.jpg';
                imwrite($facePath, $MyFace);
                imshow("ii", $MyFace);
            }
            waitKey(10);
        }
    }
}

```
#### 处理后结果
![myFaces.png](/images/docs/face/myFaces.png)

### 整合数据

#### 整合自己的图像集到人脸数据目录
至此，我们就得到和ORL人脸数据库人脸大小一致的自己的人脸数据集。然后我们把自己的作为第41个人，
在我们下载的人脸文件夹下建立一个s41的子文件夹，把自己的人脸数据放进去。
就成了这样下面这样，最后一个文件夹里面是我自己的头像照片：
![2.png](/images/docs/face/2.png)

#### 生成csv文件 

```php
function searchDir($path, &$data)
{
    //判断是否未文件夹
    if (is_dir($path)) {
        $dp = dir($path);//
        while ($file = $dp->read()) {
            if ($file != '.' && $file != '..') {
                searchDir($path . '/' . $file, $data);
            }
        }
        $dp->close();
    }
    //判断是否未文件
    if (is_file($path)) {
        $data[] = $path;//加到data数组中
    }
}

function getDir($dir)
{
    $data = array();
    searchDir($dir, $data);
    return $data;
}


$paths = getDir('./att_faces');
//var_dump($paths);
$fp = fopen("at.txt", "w");
$pwdPath = realpath('./att_faces');
$strStartLen = strlen($pwdPath . "/s");
sort($paths, SORT_STRING);
$i = 0;
$oldNum = -1;
foreach ($paths as $key => $path) {
    $realpath = realpath($path);
    $info = explode("/", $realpath);
    $num = count($info) - 1;
    $filename = $info[$num];
    if (strpos($filename, ".pgm") || strpos($filename, ".jpg")) {
        $endLen = strpos($realpath, '/' . $filename);
        $num = substr($realpath, $strStartLen, $endLen - $strStartLen);
        $flag = fwrite($fp, $realpath . ';' . $num . "\r\n");
    }
}
fclose($fp);
```
保存为`generateCSV.php`并运行，会生成一个`at.txt文件`

## 人脸识别模型训练与识别

### 代码
```php
use CV\Mat;
use CV\Face\FaceRecognizer;
use CV\Face\LBPHFaceRecognizer;
use CV\Face\BaseFaceRecognizer;
use CV\Size;
use CV\Scalar;
use CV\Point;
use CV\CascadeClassifier;
use CV\VideoCapture;
use function CV\{
    normalize, imread, cvtColor, equalizeHist, rectangleByRect, imshow, waitKey, putText, imwrite, resize
};
use const CV\{
    NORM_MINMAX, CV_8UC1, CV_8UC3, IMREAD_GRAYSCALE, COLOR_BGR2GRAY, CV_HAAR_SCALE_IMAGE
};

// 创建和返回一个归一化后的图像矩阵
function norm_0_255(Mat $src)
{
    $dst = null;
    switch ($src->channels()) {
        case 1:
            normalize($src, $dst, 0, 255, NORM_MINMAX, CV_8UC1);
            break;
        case 3:
            normalize($src, $dst, 0, 255, NORM_MINMAX, CV_8UC3);
            break;
        default:
            $src->copyTo($dst);
            break;
    }
    return $dst;
}

function read_csv($filename, $separator = ';')
{
    $images = [];
    $labels = [];
    $file = fopen($filename, "r");
    while (!feof($file)) {
        $str = fgets($file);//fgets()函数从文件指针中读取一行
        if ($str) {
            $array = explode($separator, $str);
            $images[] = imread($array[0], IMREAD_GRAYSCALE);
            $labels[] = intval($array[1]);
        }
    }
    fclose($file);
    return [$images, $labels];
}

function run()
{
    $cvsPath = 'at.txt';
    list($images, $labels) = read_csv($cvsPath);
    if (count($images) < 2) {
        die('至少需要两张图片');
    }
    $faceRecognizer = LBPHFaceRecognizer::create();
    $faceRecognizer->train($images, $labels);//识别器训练
    $cascadeClassifier = new CascadeClassifier();
    $cascadeClassifier->load('./haarcascade_frontalface_alt2.xml');//加载人脸识别分类器
    $videoCapture = new VideoCapture(0);//打开默认摄像头
    if (!$videoCapture->isOpened()) {
        die('摄像头开启失败。');
    }

    $isStop = false;
    while (!$isStop) {
        $frame = null;
        $videoCapture->read($frame);//读取图像
        $gray = cvtColor($frame, COLOR_BGR2GRAY);//转为灰度图
        equalizeHist($gray, $gray);
        $faces = null;
        $cascadeClassifier->detectMultiScale($gray, $faces, 1.1, 2, CV_HAAR_SCALE_IMAGE, new Size(50, 50));
        $face = null;
        $textLb = null;
        for ($i = 0; $i < count($faces); $i++) {
            if ($faces[$i]->height > 0 && $faces[$i]->width > 0) {
                $face = $gray->getImageROI($faces[$i]);
                $textLb = new Point($faces[$i]->x, $faces[$i]->y - 10);
                rectangleByRect($frame, $faces[$i], new Scalar(255, 0, 0), 1, 8, 0);
                $faceLabel = $faceRecognizer->predict($face);
                if ($faceLabel == 41) {
                    $name = "hiho";
                    putText($frame, $name, $textLb, 3, 1, new Scalar(0, 0, 255));
                }

            }
        }
        imshow('frame', $frame);
        if (waitKey(50) >= 0) {
            $isStop = true;
        }
    }
}


run();
```

### 结果
![result.png](/images/docs/face/result.png)

## 代码下载
[代码地址](https://github.com/phpopencv/tutorial-demo/tree/master/faceRecognition)
