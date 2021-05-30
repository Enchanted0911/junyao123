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
	<title>CRM企业客户关系管理系统</title>
	<link rel="stylesheet" href="static/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
	<script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
	<script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link rel="shortcut icon" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
	<link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
	<script>
		//页面加载完毕
		$(function () {

			//导航中所有文本颜色为黑色
			$(".liClass > a").css("color", "black");

			//默认选中导航菜单中的第一个菜单项
			$(".liClass:first").addClass("active");

			//第一个菜单项的文字变成白色
			$(".liClass:first > a").css("color", "white");

			//给所有的菜单项注册鼠标单击事件
			$(".liClass").click(function () {
				//移除所有菜单项的激活状态
				$(".liClass").removeClass("active");
				//导航中所有文本颜色为黑色
				$(".liClass > a").css("color", "black");
				//当前项目被选中
				$(this).addClass("active");
				//当前项目颜色变成白色
				$(this).children("a").css("color", "white");
			});
			$("#openEditPwdModal").click(function () {
				$("#newPwd").val("");
				$("#oldPwd").val("");
				$("#confirmPwd").val("");
				$("#editPwdModal").modal("show");
			})
			$("#updatePwdBtn").click(function () {
				let regex = /\s+/;
				if ($("#oldPwd").val() == "" || $("#oldPwd").val() == null) {
					alert("原密码为空, 请重新输入!");
					$("#newPwd").val("");
					$("#oldPwd").val("");
					$("#confirmPwd").val("");
					return false;
				}
				if ($("#newPwd").val() == "" || $("#newPwd").val() == null) {
					alert("请输入新密码!");
					$("#newPwd").val("");
					$("#confirmPwd").val("");
					return false;
				}
				if (regex.test($("#oldPwd").val())) {
					alert("密码中不能包含空白符, 请重新输入!");
					$("#newPwd").val("");
					$("#oldPwd").val("");
					$("#confirmPwd").val("");
					return false;
				}
				if ($("#newPwd").val() !== $("#confirmPwd").val()) {
					alert("两次输入的密码不一致, 请重新输入");
					$("#newPwd").val("");
					$("#confirmPwd").val("");
					return false;
				}
				if (regex.test($("#newPwd").val())) {
					alert("密码中不能包含空白符, 请重新输入!");
					$("#newPwd").val("");
					$("#confirmPwd").val("");
					return false;
				}
				$.ajax({
					url : "settings/updatePwd.do",
					data : {
						"id" : "${user.id}",
						"oldPwd" : $("#oldPwd").val(),
						"newPwd" : $("#newPwd").val()
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						// flag是验证旧密码正确标记 flag1 是验证修改密码成功标记
						if (data.flag == true) {
							if (data.flag1 == true) {
								alert("密码修改成功, 即将跳转到登录界面");
								window.location.href = "static/crm/login.jsp";
							} else {
								alert("未知错误, 修改密码失败!");
							}
						} else {
							alert("原密码错误! 请重新输入");
							$("#newPwd").val("");
							$("#confirmPwd").val("");
							$("#oldPwd").val("");
						}
					}
				})
			})


			window.open("settings/mainIndex.do", "workareaFrame");

		});

	</script>

</head>
<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
	<div class="modal-dialog" role="document" style="width: 30%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">我的资料</h4>
			</div>
			<div class="modal-body">
				<div style="position: relative; left: 40px;">
					姓名：<b>${user.name}</b><br><br>
					登录帐号：<b>${user.loginAct}</b><br><br>
					组织机构：<b>${user.deptno}</b><br><br>
					邮箱：<b>${user.email}</b><br><br>
					失效时间：<b>${user.expireTime}</b><br><br>
					允许访问IP：<b>${user.allowIps}</b>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 70%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改密码</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="password" class="form-control" id="oldPwd" style="width: 200%;">
						</div>
					</div>

					<div class="form-group">
						<label for="newPwd" class="col-sm-2 control-label">新密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="password" class="form-control" id="newPwd" style="width: 200%;">
						</div>
					</div>

					<div class="form-group">
						<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" id="updatePwdBtn">更新
				</button>
			</div>
		</div>
	</div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 30%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">离开</h4>
			</div>
			<div class="modal-body">
				<p>您确定要退出系统吗？</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal"
						onclick="window.location.href='static/crm/login.jsp';">确定
				</button>
			</div>
		</div>
	</div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
	<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
		CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;JunYao.</span></div>
	<div style="position: absolute; top: 15px; right: 15px;">
		<ul>
			<li class="dropdown user-dropdown">
				<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle"
				   data-toggle="dropdown">
					<span class="glyphicon glyphicon-user"></span> ${user.name} <span class="caret"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</a>
				<ul class="dropdown-menu">
					<li><a href="settings/index.do"><span class="glyphicon glyphicon-wrench"></span>
						系统设置</a></li>
					<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span
							class="glyphicon glyphicon-file"></span> 我的资料</a></li>
					<li><a href="javascript:void(0)" id="openEditPwdModal"><span
							class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
					<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span
							class="glyphicon glyphicon-off"></span> 退出</a></li>
				</ul>
			</li>
		</ul>
	</div>
</div>
	
	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
	
		<!-- 导航 -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="user/index.html" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 用户维护</a></li>
				<li class="liClass"><a href="role/index.html" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 角色维护</a></li>
				<li class="liClass"><a href="permission/index.html" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 许可维护</a></li>
				
				
			</ul>
			
			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- 工作区 -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- 底部 -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	
</body>
</html>