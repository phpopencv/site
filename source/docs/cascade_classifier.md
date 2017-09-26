title: 级联分类器
---

## 目标
在本教程中，您将学习如何：
使用 `CV\CascadeClassifier` 类来检测视频流中的物体. 特别地, 我们将使用函数:
- `load` 来加载一个 `.xml` 分类器文件. 它既可以是Haar特征也可以是LBP特征的分类器.
- `detectMultiScale` 来进行图像检测

## 代码
```php
use CV\Mat;
use CV\CascadeClassifier;
use CV\Size;
use CV\Point;
use CV\Scalar;
use CV\VideoCapture;
use const CV\{
    COLOR_BGR2GRAY, CASCADE_SCALE_IMAGE
};
use function CV\{
    cvtColor, equalizeHist, ellipse, circle, imshow, waitKey
};

$face_cascade_name = "haarcascade_frontalface_alt.xml";
$eyes_cascade_name = "haarcascade_eye_tree_eyeglasses.xml";
$face_cascade = new CascadeClassifier();
$eyes_cascade = new CascadeClassifier();
$window_name = "Capture - Face detection";

function detectAndDisplay(Mat $frame)
{
    global $face_cascade;
    global $eyes_cascade;
    global $window_name;
    $faces = [];
    $frame_gray = null;
    $frame_gray = cvtColor($frame, COLOR_BGR2GRAY);
    equalizeHist($frame_gray, $frame_gray);
    //-- Detect faces
    $face_cascade->detectMultiScale($frame_gray, $faces, 1.1, 2, 0 | CASCADE_SCALE_IMAGE, new Size(30, 30));
    for ($i = 0; $i < count($faces); $i++) {
        $center = new Point($faces[$i]->x + $faces[$i]->width / 2, $faces[$i]->y + $faces[$i]->height / 2);
        ellipse($frame, $center, new Size($faces[$i]->width / 2, $faces[$i]->height / 2), 0, 0, 360, new Scalar(255, 0, 255), 4, 8, 0);
        $faceROI = $frame_gray->getImageROI($faces[$i]);
        $eyes = [];
        //-- In each face, detect eyes
        $eyes_cascade->detectMultiScale($faceROI, $eyes, 1.1, 2, 0 | CASCADE_SCALE_IMAGE, new Size(30, 30));
        for ($j = 0; $j < count($eyes); $j++) {
            $eye_center = new Point ($faces[$i]->x + $eyes[$j]->x + $eyes[$j]->width / 2, $faces[$i]->y + $eyes[$j]->y + $eyes[$j]->height / 2);
            $radius = round(($eyes[$j]->width + $eyes[$j]->height) * 0.25);
            circle($frame, $eye_center, $radius, new Scalar(255, 0, 0), 4, 8, 0);
        }
    }
    //-- Show what you got
    imshow($window_name, $frame);
}

function run()
{
    global $face_cascade;
    global $face_cascade_name;
    global $eyes_cascade;
    global $eyes_cascade_name;
    $capture = new VideoCapture();
    $frame = null;
    //-- 1. Load the cascades
    if (!$face_cascade->load($face_cascade_name)) {
        printf("--(!)Error loading face cascade\n");
        return -1;
    };
    if (!$eyes_cascade->load($eyes_cascade_name)) {
        printf("--(!)Error loading eyes cascade\n");
        return -1;
    };
    //-- 2. Read the video stream
    $capture->open(-1);
    if (!$capture->isOpened()) {
        printf("--(!)Error opening video capture\n");
        return -1;
    }
    while ($capture->read($frame)) {
        if ($frame->empty()) {
            printf(" --(!) No captured frame -- Break!");
            break;
        }
        //-- 3. Apply the classifier to the frame
        detectAndDisplay($frame);
        $key = waitKey(10);
        if ($key == 27) {
            break;
        } // escape
    }
    return 0;
}

run();
```

## 运行结果
1.下图就是使用上述代码对内置摄像头的视频流进行人脸检测的结果图像:
![1.png](/images/docs/cascade_classifier/1.png)
{% note tip 注意 %}
复制分类器文件 haarcascade_frontalface_alt.xml 和 haarcascade_eye_tree_eyeglasses.xml 到你的当前目录下. 他们在OpenCV安装文件夹 opencv/data/haarcascades 里面.
{% endnote %}

2.下图是使用分类器文件 lbpcascade_frontalface.xml (LBP特征训练的) 进行的检测结果. 对于双眼的检测依旧使用刚才使用过的分类器.
![2.png](/images/docs/cascade_classifier/2.png)

## 源码地址
[源码地址](https://github.com/phpopencv/tutorial-demo/tree/master/objectDetection)