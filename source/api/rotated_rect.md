title: RotatedRect类
-------------------

表示可旋转矩形

## 成员属性

### $center

```php
public Point $center;
```

>表示矩形中心点

---

### $size


```php
public Size $size;
```

>表示矩形大小

---

### $angle

```
public double $angle;
```

>表示矩形角度,When the angle is 0, 90, 180, 270 etc., the rectangle becomes an up-right rectangle.

---

## 方法 

### __construct

```php
public function __construct(Point $center = null, Size $size = null, double $angle = 0.0)
```

>构造函数

参数说明：

- $center 矩形中心点，默认`new Point(0,0)`
- $size 矩形大小，默认`new Size(0,0)`
- $angle 矩形角度，默认0.0

返回：RotatedRect

---

