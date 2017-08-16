title: 基本的阈值操作
---

## 目标

在本篇教程中你将学到：

 - 使用PHPOpenCV的 `CV\threshold` 函数执行基本的阈值化操作


## 原理（很酷的哟）
{% note tip 注意 %}
下面的解释出自Bradski和Kaehler的《Learning OpenCV》一书
{% endnote %}

### 何为“阈值化”?

 - 最简单的图像分割操作
 - 应用示例：见我们想要分析的图像对象的区域进行分离。该分离基于目的像素和背景像素之间的强度变化。
 - 为了区分哪些像素是我们感兴趣的，哪些是剩余的(最终将被摒弃)， 我们将每个像素的强度值和一个“阈值”进行比较（阈值的大小视情况而定）。
 - 一旦我们正确分离了重要的像素，我们可以给它们设置一个固定的值来识别它们（即我们可以为它们分配值0（黑色），255（白色）或任何你需要的值）。
![Threshold_Tutorial_Theory_Example.jpg](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Example.jpg)

### 阈值化的类型

 - PHPOpenCV提供`CV\threshold` 函数来执行阈值化操作。
 - 使用此函数我们可以实现5种类型的阈值化操作。在下面的段落中将对它们进行解释。
 - 为了说明这些阈值化处理的工作原理，我们考虑一个像素的强度值为src（x，y）的源图像（即下图）。 在下面的讲述中， 我们将对此图进行各种阈值化操作。水平蓝线表示阈值（固定）。

![Threshold_Tutorial_Theory_Base_Figure.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Base_Figure.png)

#### 二值化

 - 这种阈值化操作可以被这样表示：


<div align = "center">\\texttt{dst} (x,y) = \fork{\texttt{maxVal}}{if \(\texttt{src}(x,y) > \texttt{thresh}\\)}{0}{otherwise}</div>

 - 如果像素 src(x,y) 的强度高于阈值，新的像素强度将被设置为maxVal. 否则像素强度将被设置为0
 
<div align = "center">
![Threshold_Tutorial_Theory_Binary.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Binary.png)
</div>

#### 反向二值化

 - 这种阈值化操作可以被这样表示：


<div align = "center">\\texttt{dst} (x,y) = \fork{0}{if \\(\\texttt{src}(x,y) > \\texttt{thresh}\\)}{\\texttt{maxVal}}{otherwise}</div>

 - 如果像素 src(x,y) 的强度高于阈值，新的像素强度将被设置为0. 否则像素强度将被设置为maxVal
 
<div align = "center">
![Threshold_Tutorial_Theory_Binary_Inverted.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Binary_Inverted.png)
</div>

#### 截位法

 - 这种阈值化操作可以被这样表示：


<div align = "center">\\texttt{dst} (x,y) = \fork{\texttt{threshold}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}</div>

 - 像素的最大强度值就是阈值，如果 src(x,y) 的强度值高于阈值，高出的部分将被截掉. 见下图：
 
<div align = "center">
![Threshold_Tutorial_Theory_Truncate.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Truncate.png)
</div>


#### 零阈值化

 - 这种阈值化操作可以被这样表示：


<div align = "center">\\texttt{dst} (x,y) = \fork{\texttt{src}(x,y)}{if \(\texttt{src}(x,y) > \texttt{thresh}\\)}{0}{otherwise}</div>

 - 如果 src(x,y) 低于阈值，则把新的像素值设置为0
 
<div align = "center">
![Threshold_Tutorial_Theory_Zero.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Zero.png)
</div>

#### 反零阈值化

 - 这种阈值化操作可以被这样表示：


<div align = "center">\\texttt{dst} (x,y) = \fork{0}{if \(\\texttt{src}(x,y) > \\texttt{thresh}\)}{\\texttt{src}(x,y)}{otherwise}</div>

 - 如果 src(x,y) 高于阈值，则把新的像素值设置为0
 
<div align = "center">
![Threshold_Tutorial_Theory_Zero_Inverted.png](/images/docs/tutorial_threshold/Threshold_Tutorial_Theory_Zero_Inverted.png)
</div>