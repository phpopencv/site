title: 人脸识别
---

PHPOpenCV使用FaceRecognizer类做人脸识别，所以你可以开始尝试人脸识别吧。本章将教你如何做基本的人脸识别。
目前可用的算法是：

- Eigenfaces (see EigenFaceRecognizer::create)
- Fisherfaces (see FisherFaceRecognizer::create)
- Local Binary Patterns Histograms (see LBPHFaceRecognizer::create)

## 人脸库

我们先获取一些数据来进行实验吧。我不想在这里做一个幼稚的例子。
我们在研究人脸识别，所以我们需要一个真的人脸图像！
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
保存php文件，并直接用cli模式运行，然后让我们对着摄像头拍10张照片。

