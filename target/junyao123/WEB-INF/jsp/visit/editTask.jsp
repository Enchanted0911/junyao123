<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link href="static/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          rel="stylesheet"/>
    <script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            editRepeatType();
            editNotifyType();
            $(".time1").datetimepicker({
                format: 'yyyy-mm-dd HH:ii',
                language: 'zh-CN',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $(".time2").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $("#reminderTime").click(function () {
                if (this.checked) {
                    $("#reminderTimeDiv").show("200");
                } else {
                    $("#reminderTimeDiv").hide("200");
                }
            });
            // 打开搜索联系人的模态窗口
            $("#openSearchContactsModelBtn").click(function () {
                $("#findContacts").modal("show");
            })

            // 搜索联系人模态窗口中 执行搜索并展现联系人列表
            $("#contactsName").keydown(function (event) {
                if (event.keyCode === 13) {
                    $.ajax({
                        url: "workbench/transaction/getContactsListByName.do",
                        data: {
                            "contactsName": $.trim($("#contactsName").val())
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            let html = "";
                            $.each(data, function (i, n) {
                                html += '<tr>';
                                html += '<td><input type="radio" name="checkbox01" value="' + n.id + '"/></td>';
                                html += '<td id="' + n.id + '">' + n.fullname + '</td>';
                                html += '<td>' + n.email + '</td>';
                                html += '<td>' + n.mphone + '</td>';
                                html += '</tr>';
                            })
                            $("#contactsSearchBody").html(html);
                        }
                    })
                    return false;
                }
            })

            // 提交联系人, 填充两项信息(名字 , id), id在隐藏域中
            $("#submitContactsBtn").click(function () {
                let $checkbox01 = $("input[name=checkbox01]:checked");
                let id = $checkbox01.val();
                let name = $("#" + id).html();
                $("#contactsName_01").val(name);
                $("#contactId").val(id);
                $("#findContacts").modal("hide");
            })
            // 保存一条新添加的交易
            $("#updateBtn").click(function () {
                if ($.trim($("#edit-theme").val()) === "" || $.trim($("#edit-owner").val()) === "" || $.trim($("#contactsName_01").val()) === "") {
                    alert("请把必要信息填写完整!");
                    return false;
                }
                $("#taskForm").submit();
            })
        });
        function editRepeatType () {
            $("#edit-repeatType").val("${task.repeatType}");
        }
        function editNotifyType () {
            $("#edit-notifyType").val("${task.notifyType}");
        }
    </script>
</head>
<body>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="contactsName" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsSearchBody">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div style="position:  relative; left: 30px;">
    <h3>修改任务</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
        <button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="workbench/visit/update.do" id="taskForm" class="form-horizontal" role="form">
    <input type="hidden" name="id" value="${task.id}">
    <div class="form-group">
        <label for="edit-owner" class="col-sm-2 control-label">任务所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-owner" name="owner">
                <c:forEach items="${uList}" var="u">
                    <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-theme" class="col-sm-2 control-label">主题<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-theme" value="${task.theme}" name="theme">
        </div>
    </div>
    <div class="form-group">
        <label for="edit-expectedDate" class="col-sm-2 control-label">到期日期</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time2" id="edit-expectedDate" value="${task.expectedDate}" name="expectedDate">
        </div>
        <label for="contactsName_01" class="col-sm-2 control-label">联系人名称<span
                style="font-size: 15px; color: red;">*</span>&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                            id="openSearchContactsModelBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="contactsName_01" placeholder="点击搜索图标搜索" disabled>
            <input type="hidden" id="contactId" name="contactsId">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-status" class="col-sm-2 control-label">状态</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-status" name="status">
                <option></option>
                <c:forEach items="${returnStateList}" var="t">
                    <option value="${t.value}" ${task.status eq t.value ? "selected" : ""}>${t.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-priority" class="col-sm-2 control-label">优先级</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-priority" name="priority">
                <option></option>
                <c:forEach items="${returnPriorityList}" var="t">
                    <option value="${t.value}" ${task.priority eq t.value ? "selected" : ""}>${t.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-description" name="description">${task.description}</textarea>
        </div>
    </div>

    <div style="position: relative; left: 103px;">
        <span><b>提醒时间</b></span>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="checkbox" id="reminderTime" checked>
    </div>

    <div id="reminderTimeDiv"
         style="width: 500px; height: 180px; background-color: #EEEEEE; position: relative; left: 185px; top: 20px;">
        <div class="form-group" style="position: relative; top: 10px;">
            <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control time1" id="edit-startDate" value="${task.startDate}" name="startDate">
            </div>
        </div>

        <div class="form-group" style="position: relative; top: 15px;">
            <label for="edit-repeatType" class="col-sm-2 control-label">重复类型</label>
            <div class="col-sm-10" style="width: 300px;">
                <select class="form-control" id="edit-repeatType" name="repeatType">
                    <option></option>
                    <option>每天</option>
                    <option>每周</option>
                    <option>每月</option>
                    <option>每年</option>
                </select>
            </div>
        </div>

        <div class="form-group" style="position: relative; top: 20px;">
            <label for="edit-notifyType" class="col-sm-2 control-label">通知类型</label>
            <div class="col-sm-10" style="width: 300px;">
                <select class="form-control" id="edit-notifyType" name="notifyType">
                    <option></option>
                    <option>邮箱</option>
                    <option>弹窗</option>
                </select>
            </div>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>