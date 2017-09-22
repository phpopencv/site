title: 图像操作
-----------

## 输入和输出

### 图像

加载一张图片文件：

```php
$img = imread($filename);

```

如果您读取jpg文件，则默认创建3通道图像。如果需要灰度图像，请使用：

```php
$img = imread($filename,0);
```

{% note tip 注意 %}
文件的格式由其内容决定（前几个字节）保存图像：
{% endnote %}

```php
imwrite($filename,$img);
```

{% note tip 注意 %}
文件的格式由其扩展名决定。
使用imdecode和imencode从/到内存而不是文件读写图像。
{% endnote %}

## 图像基本操作

### 访问像素的值
使用`at`方法
```
$value = $img->at($row, $col, $channel);
```

可以使用相同的方法来改变像素的值：
```php
$img->at($row, $col, $channel, 128);
```

### 内存管理和引用计数
PHP中的Mat使用C++ 的Mat实现，内存管理是自动创建和销毁的。
这里注意个是引用计数，C++的Mat矩阵本来就有引用计数，而php本来也有引用计数。
在大多数情况下，直接赋值是用同一个PHP对象，而指向的又是同一个矩阵。

如果想要复制数据，可以使用`CV\Mat->copyTo`或`CV\Mat->clone`，如：
```php
$img = imread("image.jpg");
$img1 = $img.clone（）;//此时更改$img不会对$img1影响
```

### 图像可视化

在开发过程中看到算法的中间结果是非常有用的。OpenCV提供了可视化图像的便捷方式。可以使用以下方式显示8U图像：
```php
$img = imread("image.jpg");
namedWindow（"image",WINDOW_AUTOSIZE）;
imshow（"image",$img）;
waitKey();
```

`waitKey`会等待，直到用户键入操作。

