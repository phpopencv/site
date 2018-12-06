<header id="banner" class="wrapper">
  <div class="inner">
    <h2 id="banner-title">{{ page.subtitle }}</h2>
    <div id="banner-start">
      <span id="banner-start-command">git clone https://github.com/hihozhou/php-opencv.git</span>
      <a id="banner-start-link" href="https://doc.phpopencv.org"><i class="fa fa-arrow-right"></i></a>
    </div>
    <div id="banner-share">{{ partial('partial/share') }}</div>
  </div>
</header>
<div id="content-wrap">
  <div class="wrapper">
    <div class="inner">
      {{ page.content }}
      <ul id="intro-cmd-wrap">
        <li class="intro-cmd-item">git clone https://github.com/hihozhou/php-opencv.git</li>
        <li class="intro-cmd-item">cd php-opencv</li>
        <li class="intro-cmd-item">phpize</li>
        <li class="intro-cmd-item">./configure --with-php-config=/your/php-config --enable-debug</li>
        <li class="intro-cmd-item">make && make install</li>
      </ul>
      <div id="intro-get-started-wrap">
        <a href="https://doc.phpopencv.org" id="intro-get-started-link">{{ __('index.get_started') }}</a>
      </div>
    </div>
  </div>
</div>