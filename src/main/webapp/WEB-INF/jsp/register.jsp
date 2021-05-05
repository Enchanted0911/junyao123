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
    <title>注册界面</title>
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
        // 在注册前先判断确认密码是否成功
        function confirmPwd() {
            if ($("#confirmPwd").attr("readonly") === "readonly") {
                return false;
            }
            let confirmPwd = $("#confirmPwd").val();
            let pwd = $("#registerPwd").val();
            if (pwd !== confirmPwd) {
                $("#confirmMsg").html("两次输入密码不一致, 请重新输入密码");
                $("#registerPwd").focus();
                $("#registerPwd").val("");
                $("#confirmPwd").val("");
                $("#confirmPwd").attr("readonly", true);
                $("#submitBtn").attr("disabled", true);
                return false;
            } else {
                $("#confirmMsg").html("");
                return true;
            }
        }


        $(function () {
            if (window.top !== window) {
                window.top.location = window.location;
            }
            $("#registerAct").focus();
            $("#registerAct").val("");
            $("#registerName").val("");
            $("#registerPwd").val("");
            $("#confirmPwd").val("");

            // 注册邮箱失去焦点时验证邮件格式
            $("#registerAct").blur(function () {
                $("#passwordMsg").html("");
                $("#nameMsg").html("");
                $("#confirmMsg").html("");
                let email = $("#registerAct").val();
                let regex = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
                if (email === null || email === "") {
                    $("#emailMsg").html("请输入正确的邮箱!");
                    $("#registerName").attr("readonly", true);
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                } else if (email.length > 24) {
                    $("#emailMsg").html("邮箱长度必须小于25位!");
                    $("#registerName").attr("readonly", true);
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                }
                if (!regex.test(email)) {
                    $("#emailMsg").html("请输入正确的邮箱!");
                    $("#registerName").attr("readonly", true);
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                } else {
                    $("#emailMsg").html("");
                    $("#registerName").attr("readonly", false);
                }
            })

            // 注册名字失去焦点时验证姓名不能包含空格
            $("#registerName").blur(function () {
                $("#passwordMsg").html("");
                $("#confirmMsg").html("");
                if ($("#registerName").attr("readonly") === "readonly") {
                    $("#nameMsg").html("");
                    return;
                }
                let name = $("#registerName").val();
                let regex = /\s+/;
                if (name === null || name === "") {
                    $("#nameMsg").html("请输入用户名, 不能包含空白符!");
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                } else if (name.length > 9) {
                    $("#nameMsg").html("用户名长度必须小于10位, 且不能包含任何空白符!");
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                }
                if (regex.test(name)) {
                    $("#nameMsg").html("姓名不能包含空白字符!");
                    $("#registerPwd").attr("readonly", true);
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                } else {
                    $("#nameMsg").html("");
                    $("#registerPwd").attr("readonly", false);
                }
            })

            // 注册密码失去焦点时验证密码不能包含空格
            $("#registerPwd").blur(function () {
                $("#confirmMsg").html("");
                if ($("#registerPwd").attr("readonly") === "readonly") {
                    return;
                }
                let pwd = $("#registerPwd").val();
                let regex = /\s+/;
                if (pwd === null || pwd === "") {
                    $("#passwordMsg").html("请设置初始密码, 不能包含空白符!");
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                } else if (pwd.length > 18) {
                    $("#passwordMsg").html("密码长度必须小于19位!");
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                    return;
                }
                if (regex.test(pwd)) {
                    $("#passwordMsg").html("密码不能包含空白字符!");
                    $("#confirmPwd").attr("readonly", true);
                    $("#submitBtn").attr("disabled", true);
                } else {
                    $("#passwordMsg").html("");
                    $("#confirmPwd").attr("readonly", false);
                    $("#submitBtn").attr("disabled", false);
                }
            })


            $("#submitBtn").click(function () {
                if (confirmPwd()) {
                    register();
                }
            })
            $(window).keydown(function (event) {
                if (event.keyCode === 13 && confirmPwd()) {
                    register();
                }
            })
        })

        function register() {
            $.ajax({
                url: "settings/register.do",
                data: {
                    "registerAct": $("#registerAct").val(),
                    "registerName": $("#registerName").val(),
                    "registerPwd": $("#registerPwd").val()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        window.location.href = data.view;
                    } else {
                        $("#registerMsg").html(data.msg);
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
                <div style="height: 50px"><a href="static/crm/login.jsp"
                                             class="navbar-link btn btn-default btn-sm active" role="button"
                                             style="color: #c9a3ff;text-align: center">登录</a></div>
            </div>
        </nav>
    </header>
    <div style="position: relative;width:550px;height:500px;margin: 6% auto;">
        <div style="position: relative;margin: 0 10%;">
            <div>
                <h1 style="color: #cbeaff; float: left">注册</h1>
            </div>
            <form action="" class="form-horizontal" role="form" style="position: relative;top: 50px;">
                <div class="form-group form-group-lg">
                    <div>
                        <input id="registerAct" class="form-control" type="text" placeholder="注册邮箱"/>
                    </div>
                    <label class="checkbox" style="position: relative;left: 10px;color: red" id="emailMsg">
                    </label>
                </div>
                <div class="form-group form-group-lg">
                    <div style="position: relative; top: 10px">
                        <input id="registerName" class="form-control" type="text" placeholder="用户姓名"/>
                    </div>
                    <label class="checkbox" style="position: relative;left: 10px;top : 10px;color: red" id="nameMsg">
                    </label>
                </div>
                <div class="form-group form-group-lg">
                    <div style="position: relative; top: 10px">
                        <input id="registerPwd" class="form-control" type="password" placeholder="密码"/>
                    </div>
                    <label class="checkbox" style="position: relative;left: 10px; top : 10px;color: red"
                           id="passwordMsg">
                    </label>
                </div>
                <div class="form-group form-group-lg">
                    <div style="position: relative; top: 10px">
                        <input id="confirmPwd" class="form-control" type="password" placeholder="确认密码"/>
                    </div>
                    <label class="checkbox" style="position: relative;left: 10px;color: red;top: 10px" id="confirmMsg">
                    </label>
                </div>
                <div class="form-group form-group-lg">
                    <label class="checkbox" style="position: relative;left: 10px;color: red;top: 5px" id="registerMsg">
                    </label>
                    <button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"
                            style="position: relative;top: 15px;">注册
                    </button>
                </div>
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
