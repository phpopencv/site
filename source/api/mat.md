title: Mat类
-----------

用于储存图片信息矩阵的对象。

## 成员属性

### $rows

```php
public int $rows
```

>表示矩阵的列数

---

### $cols


```php
public int $cols
```

>表示矩阵的行数

---

### $type

```
private int $type
```

>表示矩阵的`位数`，`通道数`，`存储类型`

---

## 方法 

### __construct

```php
public function __construct(int $rows, int $cols, int $type, Scalar $scalar)
```

>创建新的Mat对象

参数说明：

- $rows 创建的矩阵的行数
- $cols 创建的矩阵的列数
- $type 矩阵类型
- $type 矩阵中像素的颜色，默认为new Scalar(0,0,0,0);

返回：Mat对象

---

### zeros

```php
public static function zeros(int $rows, int $cols, int $type)
```

>快速创建一个空的Mat对象

参数说明：

- $rows 创建的矩阵的行数
- $cols 创建的矩阵的列数
- $type 矩阵类型

返回：Mat

---

### print

```php
public function print(int $type)
```

>已字符串形式输出，展示Mat对象矩阵数据

参数说明：

- $type 输出字符的格式

---

### type

```php
public function type()
```

>返回Mat对象的type数值

返回：int

---

### depth

```php
public function depth()
```

>返回Mat对象的深度（位）

返回：int

---

### channels

```php
public function channels()
```

>返回Mat对象的通道数

返回：int

---

### isContinuous

```php
public function isContinuous()
```

> 判断Mat矩阵数据是否是连续性

返回：bool

---

### row

```php
public function row(int $y)
```

> 获取Mat矩阵第y行数据，并保存在新的Mat对象返回

返回：Mat

---

### col

```php
public function col(int $x)
```

> 获取Mat矩阵第x列数据，并保存在新的Mat对象返回

返回：Mat

---

### clone

```php
public function clone()
```

> 克隆当前调用clone方法的Mat对象，并且返回新的Mat对象

返回：Mat

---


### getImageROI

```php
public function getImageROI(Rect $rect)
```

> 获取指定区域roi矩阵，并以Mat对象返回

返回：Mat

---

### copyTo

```php
public function copyTo(Mat $mat, Mat $mask = NULL)
```

> 将当前调用copyTo对象的矩阵复制到$mat矩阵中，如果传入$mask则作为掩模，掩模必须为灰度图

---