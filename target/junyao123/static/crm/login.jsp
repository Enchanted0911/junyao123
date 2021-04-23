<%--
  Created by IntelliJ IDEA.
  User: wu
  Date: 2021/4/21
  Time: 21:00
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
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>登录界面</title>
    <link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css"/>
    <script src="static/js/jquery-3.6.0.min.js"></script>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <style type="text/css">
        .login {
            background-image: url(static/crm/image/login.jpg);
            position: absolute;
            width: 100%;
            height: 100%;
            min-height: 600px;
            padding: 0;
            background-size: cover;
            background-position: center center;
            overflow: hidden;
            background-attachment: fixed;
        }
    </style>
    <script>
        $(function () {
            if(window.top != window) {
                window.top.location = window.location;
            }
            $("#loginAct").focus();
            $("#loginAct").val("");
            $("#submitBtn").click(function () {
                login();
            })
            $(window).keydown(function (event) {
                if (event.keyCode === 13) {
                    login();
                }
            })
        })

        function login() {
            let loginAct = $.trim($("#loginAct").val());
            let loginPwd = $.trim($("#loginPwd").val());
            if (loginAct === "" || loginPwd === "") {
                $("#msg").html("账号密码不能为空!")
                return false;
            }
            $.ajax({
                url: "settings/login.do",
                data: {
                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        window.location.href = data.view;
                    } else {
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>
<body>
<section class="login">
    <header>
        <nav class="navbar navbar-default navbar-fixed-top" id="top" style="height: 50px">
            <div class="container-fluid" style="padding: 0% 5%;height: 50px">
                <div style="height: 50px"><p
                        style="font-style: italic;font-family:'Times New Roman',serif;font-size: 20px">CRM</p></div>
                <div style="height: 50px"><a href="index.jsp" class="navbar-link"
                                             style="color: black;text-align: center">back to JunYao home</a></div>
            </div>
        </nav>
    </header>
    <div style="position: relative;width:550px;height:400px;margin: 12% auto;">
        <div style="position: relative;margin: 0 10%;">
            <div class="page-header">
                <h1 style="color: #cbeaff">登录</h1>
            </div>
            <form action="" class="form-horizontal" role="form" style="position: relative;top: 20px">
                <div class="form-group form-group-lg">
                    <input id="loginAct" class="form-control" type="text" placeholder="用户名"/>
                </div>
                <div class="form-group form-group-lg" style="position: relative; top: 10px">
                    <input id="loginPwd" class="form-control" type="password" placeholder="密码"/>
                </div>
                <div class="checkbox" style="position: relative;left: 10px;">
                    <span id="msg" style="color: red"></span>
                </div>
                <button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"
                        style="position: relative;top: 25px;">登录
                </button>
            </form>
        </div>
    </div>
    <footer class="fixed-bottom">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-md-2 text-center text-md-left" style="font-style: italic">Copyright &copy; 2021
                        JunYao.</p>
                </div>
            </div>
        </div>
    </footer>
</section>
</body>
</html>
