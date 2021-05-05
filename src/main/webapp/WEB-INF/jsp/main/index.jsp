<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// 只针对当前页面有效， 有必要需要在每个页面加上这段代码
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>CRM企业客户关系管理系统</title>
	<link rel="stylesheet" href="static/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
	<script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
	<script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link rel="shortcut icon" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
</head>
<body>
	<img src="static/crm/image/home.png" style="position: relative;background-size:cover;background-attachment:fixed;width: 100%;height: 100%"/>
</body>
</html>