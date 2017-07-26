title: 安装
---

在安装PHPOpenCV首先需要安装OpenCV

## 安装OpenCV

### 安装前准备

``` bash
$ sudo apt-get install gcc-4.8 g++-4.8
$ sudo apt-get install build-essential
$ sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt-get install libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
```

### 下载opencv_contrib模块

该模块主要用户人脸识别等扩展功能。

``` bash
$ git clone https://github.com/opencv/opencv_contrib.git
$ cd opencv_contrib
$ git checkout 3.3.0-rc
$ cd ..
```

### 下载opencv

``` bash
$ git clone https://github.com/opencv/opencv.git
$ cd opencv
$ git checkout 3.3.0-rc

```

### 编译安装opencv
```bash
$ mkdir build
$ cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules ..
$ make -j6
$ sudo make install
$ sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
$ sudo ldconfig
```

### 检测
编译安装完后，可以使用pkg-config来检测是否安装成功
```bash
$ pkg-config --libs opencv
```

## 安装PHPOpenCV扩展

### 下载并安装PHPOpenCV扩展库

```bash
$ git clone https://github.com/hihozhou/php-opencv.git
$ cd php-opencv
$ phpize
$ ./configure --with-php-config=/your/php-config --enable-debug
$ make && make install
```

### 配置php.ini

```
extension="opencv.so path"
```

到目前为止，你已经成功安装开发所需要的准备了，接下来让我们来开启计算机视觉开发的大门。

