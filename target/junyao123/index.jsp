<%--
  Created by IntelliJ IDEA.
  User: wu
  Date: 2021/4/20
  Time: 13:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 只针对当前页面有效， 有必要需要在每个页面加上这段代码
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>JunYao-I see you.</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <!-- Bootstrap CSS-->
    <link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome CSS-->
    <link rel="stylesheet" href="static/font-awesome/font-awesome-4.7.0/css/font-awesome.min.css">
    <!-- Google fonts - Montserrat for headings, Cardo for copy-->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:400,700|Cardo:400,400italic,700">
    <!-- Lightbox-->
    <link rel="stylesheet" href="static/css/lightbox.min.css">
    <!-- theme stylesheet-->
    <link rel="stylesheet" href="static/css/style.default.css" id="theme-stylesheet">
    <!-- Favicon-->
    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <script src="static/js/jquery-3.6.0.min.js"></script>

    <!-- Leaflet CSS - For the map-->
    <link rel="stylesheet" href="static/css/leaflet.css">
    <!-- Tweaks for older IEs--><!--[if lt IE 9]>
    <script src="static/js/html5shiv.min.js"></script>
    <script src="static/js/respond.min.js"></script><![endif]-->
    <base href="<%=basePath%>"/>

    <script>
        $(function () {
            if(window.top !== window) {
                window.top.location = window.location;
            }
        })
    </script>
</head>
<body>
<section id="intro" style="background-image: url('static/imgs/home/home.jpg');background-size:auto auto;" class="intro">
    <div class="overlay"></div>
    <div class="content">
        <div class="container clearfix">
            <div class="row">
                <div class="col-lg-8 col-md-12 mx-auto">
                    <p class="italic">Oh, hello, nice to meet you!</p>
                    <h1>I am JS&W</h1>
                    <p class="italic">The performance of our true self, is our own choice, all this than we have the
                        capacity even more important.</p>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- intro end-->
<!-- navbar-->
<header class="header">
    <nav class="navbar navbar-expand-lg">
        <div class="container"><a href="#intro" class="navbar-brand link-scroll">Jun<img src="static/imgs/title/cat.png"
                                                                                         alt=""
                                                                                         class="img-fluid">Yao</a>&nbsp;&nbsp;
            <a href="https://blog.csdn.net/junyaoweidongli/article/list/1">My CSDN</a>
            <button type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
                    class="navbar-toggler navbar-toggler-right"><i class="fa fa-bars"></i></button>
            <div id="navbarSupportedContent" class="collapse navbar-collapse">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item"><a href="#intro" class="nav-link link-scroll">Home</a></li>
                    <li class="nav-item"><a href="#about" class="nav-link link-scroll">About </a></li>
                    <li class="nav-item"><a href="#services" class="nav-link link-scroll">Specialization</a></li>
                    <li class="nav-item"><a href="#portfolio" class="nav-link link-scroll">Portfolio</a></li>
                    <li class="nav-item"><a href="#text" class="nav-link link-scroll">Project</a></li>
                    <li class="nav-item"><a href="#contact" class="nav-link link-scroll">Contact</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<!-- about-->
<section id="about" style="background-image: url('static/imgs/about/about.jpg');" class="text">
    <div class="container">
        <div class="row">
            <div class="col-lg-6">
                <h2 class="heading">About me</h2>
                <p class="lead">Frankly, I don't know what should I write</p>
                <p>Love learning</p>
                <p>Well, I am a 22 grade fresh graduate, seeking a job in, still have no experience temporarily </p>
            </div>
            <div class="col-lg-5 mx-auto">
                <p><img src="static/imgs/about/about01.jpg" alt="" class="img-fluid rounded-circle"></p>
            </div>
        </div>
    </div>
</section>
<!-- about end-->
<!-- Specialization-->
<section id="services" style="background-color: #eee">
    <div class="container">
        <div class="row services">
            <div class="col-lg-12">
                <h2 class="heading">Specialize</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="box">
                            <div class="icon"><i class="fa fa-laptop"></i></div>
                            <h5>Coding</h5>
                            <p>Familiar with Java, understand C/C++ and Python. Understand HTML CSS JS and AJAX Jquery.
                                Understand common Linux commands. Comprehend the use of Mysql and JDBC. <br>
                                There shall be more...</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="box">
                            <div class="icon"><i class="fa fa-etsy"></i></div>
                            <h5>English</h5>
                            <p>Good command of English,mostly,learn from foreign forums or websites, such as
                                StackOverflow, Github, Coursera.
                                By the way,I fancy American/English drama.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="box">
                            <div class="icon"><i class="fa fa-book"></i></div>
                            <h5>Self-learning</h5>
                            <p>Strong ability to study independently. <br>
                                Live and learn.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Specialization end-->

<!-- Portfolio / gallery-->
<section id="portfolio" class="gallery">
    <div class="container clearfix">
        <div class="row">
            <div class="col-lg-12">
                <div class="row">
                    <div class="col-md-12 col-lg-8">
                        <h2 class="heading">Portfolio</h2>
                        <p>All sad people like poetry.Happy people like songs.</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="box"><a href="static/imgs/pro/pro01.jpg" data-lightbox="image-1"
                                            data-title="The past will always come and we will accept it."
                                            class="has-border"><img
                                src="static/imgs/pro/pro01.jpg" alt="image" class="img-fluid"></a></div>
                    </div>
                    <div class="col-md-4">
                        <div class="box"><a href="static/imgs/pro/pro02.jpg" data-lightbox="image-1"
                                            data-title="It is easy to forgive someone else's mistake, it is difficult to forgive someone else's right."
                                            class="has-border"><img
                                src="static/imgs/pro/pro02.jpg" alt="image" class="img-fluid"></a></div>
                    </div>
                    <div class="col-md-4">
                        <div class="box"><a href="static/imgs/pro/pro03.jpg" data-lightbox="image-1"
                                            data-title="Death is but the next great adventure." class="has-border"><img
                                src="static/imgs/pro/pro03.jpg" alt="image" class="img-fluid"></a></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Portfolio / gallery end-->
<!-- text page-->
<section id="text" class="text-page section-inverse">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <h2 class="heading">Project</h2>
                <div class="row">
                    <div class="col-md-6">
                        <p>CRM<a href="static/crm/index.html" style="color: #95999c"><i
                                class="fa fa-rocket"></i>go</a></p>
                    </div>
                    <div class="col-md-6">
                        <p>It should be more later... <a href="#" style="color: #95999c"><i class="fa fa-rocket"></i>go</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- text page end-->
<!-- contact-->
<section id="contact" style="background-color: #fff;" class="text-page pb-4">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <h2 class="heading">Contact</h2>
                <div class="row">
                    <div class="col-lg-6">
                        <p>QQEmail</p>
                        <p>2938097081@qq.com</p>
                    </div>
                    <div class="col-lg-6">
                        <p>Gmail</p>
                        <p>wjssazpjya@gmail.com</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<div id="map"></div>
<footer style="background-color: #111;">
    <div class="container">
        <div class="row copyright">
            <div class="col-md-6">
                <p class="mb-md-0 text-center text-md-left">Copyright &copy; 2021 JunYao.</p>
            </div>
            <div class="col-md-6">
                <p class="credit mb-md-0 text-center text-md-right">No more let Life divide, what Death can join
                    together.</p>
            </div>
        </div>
    </div>
</footer>
<!-- JavaScript files-->
<script src="static/js/jquery-3.6.0.min.js"></script>
<script src="static/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="static/js/jquery.cookie.js"></script>
<script src="static/js/lightbox.min.js"></script>
<script src="static/js/leaflet.js"></script>
<script src="static/js/front.js"></script>
</body>
</html>

