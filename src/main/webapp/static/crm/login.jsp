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
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>JunYao-I see you.</title>
    <link rel="stylesheet" type="text/css" href="../bootstrap/css/bootstrap.min.css"/>
    <script type="javascript" src="../js/jquery-3.6.0.min.js"></script>
    <script type="javascript" src="../bootstrap/js/bootstrap.min.js"></script>
    <style type="text/css">
        .login {
            background-image: url(../crm/image/login.jpg);
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
    <base href="<%=basePath%>"/>
</head>
<body>
<section class="login">
    <header>
        <nav class="navbar navbar-default navbar-fixed-top" id="top" style="height: 50px">
            <div class="container-fluid" style="padding: 0% 5%;height: 50px">
                <div style="height: 50px"><p style="font-style: italic;font-family:'Times New Roman',serif;font-size: 20px">CRM</p></div>
                <div style="height: 50px"><a href="http://junyao.icu" class="navbar-link" style="color: black;text-align: center">back to JunYao home</a></div>
            </div>
        </nav>
    </header>
    <div style="position: absolute;width:450px;height:400px;margin: 12% 38%;">
        <div style="position: relative;margin: 12% 10%;">
            <div class="page-header">
                <h1 style="color: #cbeaff">登录</h1>
            </div>
            <form action="static/crm/workbench/index.html" class="form-horizontal" role="form">
                <div class="form-group form-group-lg">
                    <div style="width: 350px;">
                        <input class="form-control" type="text" placeholder="用户名">
                    </div>
                    <div style="width: 350px; position: relative;top: 20px;">
                        <input class="form-control" type="password" placeholder="密码">
                    </div>
                    <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                        <span id="msg"></span>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            style="width: 350px; position: relative;top: 45px;">登录
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>
</body>
</html>
