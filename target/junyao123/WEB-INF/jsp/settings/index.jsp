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
    <div style="position: relative; top: 30px; width: 60%; height: 100px; left: 20%;">
        <div class="page-header">
            <h3>系统设置</h3>
        </div>
    </div>
    <div style="position: relative; width: 55%; height: 70%; left: 22%;">
        <div style="position: relative; width: 33%; height: 50%;">
            常规
            <br><br>
            <a href="javascript:void(0);">个人设置</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%;">
            安全控制
            <br><br>
            <!--
            <a href="org/index.jsp" style="text-decoration: none; color: red;">组织机构</a>
             -->
            <a href="settings/deptIndex.do">部门管理</a>
            <br>
            <a href="settings/qxIndex.do">权限管理</a>
        </div>

        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            定制
            <br><br>
            <a href="javascript:void(0);">模块</a>
            <br>
            <a href="javascript:void(0);">模板</a>
            <br>
            <a href="javascript:void(0);">定制内容复制</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            自动化
            <br><br>
            <a href="javascript:void(0);">工作流自动化</a>
            <br>
            <a href="javascript:void(0);">计划</a>
            <br>
            <a href="javascript:void(0);">Web表单</a>
            <br>
            <a href="javascript:void(0);">分配规则</a>
            <br>
            <a href="javascript:void(0);">服务支持升级规则</a>
        </div>

        <div style="position: relative; width: 34%; height: 50%;  left: 66%; top: -200%">
            扩展及API
            <br><br>
            <a href="javascript:void(0);">API</a>
            <br>
            <a href="javascript:void(0);">其它的</a>
        </div>
        <div style="position: relative; width: 34%; height: 50%; left: 66%; top: -200%">
            数据管理
            <br><br>
            <a href="static/crm/settings/dictionary/index.html">数据字典表</a>
            <br>
            <a href="javascript:void(0);">导入</a>
            <br>
            <a href="javascript:void(0);">导出</a>
            <br>
            <a href="javascript:void(0);">存储</a>
            <br>
            <a href="javascript:void(0);">回收站</a>
            <br>
            <a href="javascript:void(0);">审计日志</a>
        </div>
    </div>
</div>
</body>
</html>