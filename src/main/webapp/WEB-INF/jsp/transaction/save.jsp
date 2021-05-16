<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 只针对当前页面有效， 有必要需要在每个页面加上这段代码
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

    Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");

    Set<String> set = pMap.keySet();
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
    <script src="static/crm/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script>
        // 如果是json数据格式, 最后一个逗号会被自动忽略, 不需要加判断条件去除最后多出的逗号
        let json = {

            <%

                for(String key:set){

                    String value = pMap.get(key);
            %>

            "<%=key%>": <%=value%>,

            <%
                }

            %>

        };
        $(function () {
            $(".time1").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "bottom-left"
            });
            $(".time2").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "top-left"
            });
            // 客户名称自动补全插件
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "workbench/transaction/getCustomerName.do",
                        {"name": query},
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 500
            });

            // 为阶段的下拉框, 绑定选中下拉框的事件, 根据选中的阶段填写可能性
            $("#create-transactionStage").change(function () {
                // let stage = $("#create-transactionStage").val();
                let stage = this.value;

                /*
                    我们现在以json.key的形式不能取得value
                    因为今天的stage是一个可变的变量
                    如果是这样的key，那么我们就不能以传统的json.key的形式来取值
                    我们要使用的取值方式为
                    json[key]
                 */
                let possibility = json[stage];

                //为可能性的文本框赋值
                $("#create-possibility").val(possibility);
            })

            // 打开搜索市场活动的模态窗口
            $("#openSearchModelBtn").click(function () {
                $("#findMarketActivity").modal("show");
            })

            // 搜索市场活动模态窗口中 执行搜索并展现市场活动列表
            $("#activityName").keydown(function (event) {
                if (event.keyCode === 13) {
                    $.ajax({
                        url: "workbench/clue/getActivityListByName.do",
                        data: {
                            "activityName": $.trim($("#activityName").val())
                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {
                            let html = "";
                            $.each(data, function (i, n) {
                                html += '<tr>';
                                html += '<td><input type="radio" name="checkbox01" value="' + n.id + '"/></td>';
                                html += '<td id="' + n.id + '">' + n.name + '</td>';
                                html += '<td>' + n.startDate + '</td>';
                                html += '<td>' + n.endDate + '</td>';
                                html += '<td>' + n.owner + '</td>';
                                html += '</tr>';
                            })
                            $("#activitySearchBody").html(html);
                        }
                    })

                    return false;
                }
            })

            // 提交市场活动源, 填充两项信息(名字 , id), id在隐藏域中
            $("#submitActivityBtn").click(function () {
                let $checkbox01 = $("input[name=checkbox01]:checked");
                let id = $checkbox01.val();
                let name = $("#" + id).html();
                $("#activityName_01").val(name);
                $("#activityId").val(id);
                $("#findMarketActivity").modal("hide");
            })

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
            $("#saveBtn").click(function () {
                if ($.trim($("#create-customerName").val()) === "" || $.trim($("#create-transactionOwner").val()) === ""
                    || $.trim($("#create-clueSource").val()) === "" || $.trim($("#contactsName_01").val()) === ""
                    || $.trim($("#create-transactionName").val()) === "" || $.trim($("#create-expectedClosingDate").val()) === ""
                    || $.trim($("#create-transactionStage").val()) === "") {
                    alert("请把必要信息填写完整!");
                    return false;
                }
                $("#tranForm").submit();
            })
        })
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="activityName" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

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
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
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
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="workbench/transaction/save.do" id="tranForm" class="form-horizontal" role="form"
      style="position: relative; top: -30px;" method="post">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <option></option>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建"
                   name="customerName">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage" name="stage">
                <option></option>
                <c:forEach items="${stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="t">
                    <option value="${t.value}">${t.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <c:forEach items="${sourceList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="activityName_01" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                        id="openSearchModelBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="activityName_01" placeholder="点击搜索图标搜索" disabled>
            <input type="hidden" id="activityId" name="activityId">
        </div>
    </div>

    <div class="form-group">
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
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
        </div>
    </div>

</form>
</body>
</html>