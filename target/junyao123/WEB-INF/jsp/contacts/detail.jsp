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

    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <link rel="stylesheet" href="static/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
    <link href="static/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          rel="stylesheet"/>
    <script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="static/crm/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script>

        //默认情况下取消和保存按钮是隐藏的
        let cancelAndSaveBtnDefault = true;

        //打开编辑备注的模态窗口
        function editRemark(id) {
            $("#remarkId").val(id);
            let noteContent = $("#e" + id).html();
            $("#noteContent").val(noteContent);
            $("#editRemarkModal").modal("show");
        }

        // 删除单条备注信息
        function removeRemark(id) {
            $.ajax({
                url: "workbench/contacts/removeRemark.do",
                data: {
                    "id": id
                },
                type: "post",
                success: function (data) {
                    if (data === "true") {
                        $("#" + id).remove();
                    } else {
                        alert("删除备注失败 ! ");
                    }
                }
            })
        }

        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            // 客户名称自动补全插件
            $("#edit-customerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "workbench/contacts/getCustomerName.do",
                        {"name": query},
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 500
            });
            // 展示备注信息
            showRemarkList();

            // 展示关联的市场活动列表
            showActivityList();

            // 展现关联的交易列表
            showTransactionList();

            // 打开修改的模态窗口
            $("#editBtn").click(function () {
                $.ajax({
                    url: "workbench/contacts/getUserListAndContacts.do",
                    data: {
                        "id": "${contacts.id}"
                    },
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        // 处理所有者下拉框
                        let html = "<option></option>";
                        $.each(data.uList, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        })
                        $("#edit-owner").html(html);

                        // 处理单条Contacts
                        $("#edit-appellation").val(data.contacts.appellation);
                        $("#edit-email").val(data.contacts.email);
                        $("#edit-mphone").val(data.contacts.mphone);
                        $("#edit-job").val(data.contacts.job);
                        $("#edit-contactSummary").val(data.contacts.contactSummary);
                        $("#edit-nextContactTime").val(data.contacts.nextContactTime);
                        $("#edit-address").val(data.contacts.address);
                        $("#edit-fullname").val(data.contacts.fullname);
                        $("#edit-owner").val(data.contacts.owner);
                        $("#edit-birth").val(data.contacts.birth);
                        $("#edit-source").val(data.contacts.source);
                        $("#edit-customerName").val(data.contacts.customerId);
                        $("#edit-description").val(data.contacts.description);

                        // 打开模态窗口
                        $("#editContactsModal").modal("show");
                    }
                })

            });
            // 修改一个联系人, 一般修改操作和添加操作有很大的相似度, 可以使用CV大法
            $("#updateBtn").click(function () {
                if ($.trim($("#edit-fullname").val()) === "" || $.trim($("#edit-customerName").val()) === ""
                    || $.trim($("#edit-owner").val()) === "" || $.trim($("#edit-source").val()) === "") {
                    alert("请把必要信息填写完整 !!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/update.do",
                    data: {
                        "id": "${contacts.id}",
                        "appellation": $.trim($("#edit-appellation").val()),
                        "email": $.trim($("#edit-email").val()),
                        "mphone": $.trim($("#edit-mphone").val()),
                        "job": $.trim($("#edit-job").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val()),
                        "fullname": $.trim($("#edit-fullname").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "birth": $.trim($("#edit-birth").val()),
                        "source": $.trim($("#edit-source").val()),
                        "customerName": $.trim($("#edit-customerName").val()),
                        "description": $.trim($("#edit-description").val())
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            window.location.reload();
                            $("#editContactsModal").modal("hide");
                        } else {
                            alert("修改联系人失败");
                        }
                    }
                })
            });

            // 删除联系人操作
            $("#deleteBtn").click(function () {
                if (confirm("确定删除所选的记录吗 ? ")) {
                    let param = "id=${contacts.id}";
                    $.ajax({
                        url: "workbench/contacts/delete.do",
                        data: param,
                        type: "post",
                        success: function (data) {
                            if (data === "true") {
                                alert("删除成功, 即将会回到联系人主界面");
                                window.location.href = "settings/contactsIndex.do";
                            } else {
                                alert("sorry!删除联系人失败 !");
                            }
                        }
                    })
                }
            });

            // 删除该联系人的一条交易
            $("#removeBtn").click(function () {
                let id = $("#removeId").val();
                let param = "id=" + id;
                $.ajax({
                    url: "workbench/transaction/delete.do",
                    data: param,
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            showTransactionList();
                            $("#removeTransactionModal").modal("hide");
                        } else {
                            alert("交易删除失败!")
                            $("#removeTransactionModal").modal("hide");
                        }
                    }
                })
            })

            // 市场活动源的搜索操作
            $("#activityName").keydown(function (event) {
                if (event.keyCode === 13) {
                    $.ajax({
                        url: "workbench/contacts/getActivityListByNameAndNotRelation.do",
                        data: {
                            "activityName": $.trim($("#activityName").val()),
                            "contactsId": "${contacts.id}"
                        },
                        type: "get",
                        success: function (data) {
                            let html = "";
                            $.each(data, function (i, n) {
                                html += '<tr>';
                                html += '<td><input type="checkbox" name="checkbox01" value="' + n.id + '"/></td>';
                                html += '<td>' + n.name + '</td>';
                                html += '<td>' + n.startDate + '</td>';
                                html += '<td>' + n.endDate + '</td>';
                                html += '<td>' + n.owner + '</td>';
                                html += '</tr>';
                            })
                            $("#addActivityRelation").html(html);
                        }
                    })
                    // 强行中止该方法, 禁用模态窗口的默认回车事件(回刷新清空并关闭模态窗口)
                    return false;
                }
            })

            // 关联市场活动窗口复选框操作
            $("#bindSelectAll").click(function () {
                $("input[name = checkbox01]").prop("checked", this.checked);
            });
            // 注意动态生成的元素是不能以普通绑定事件的形式生成
            // 动态生成的元素，用on方法的形式来触发事件
            // 语法 ：$(需要绑定元素的有效外层元素).on(绑定事件的方式, 需要绑定的元素的jquery对象, 回调函数)
            $("#addActivityRelation").on("click", $("input[name = checkbox01]"), function () {
                $("#bindSelectAll").prop("checked", $("input[name = checkbox01]").length === $("input[name = checkbox01]:checked").length);
            });

            // 新关联一条市场活动
            $("#bindBtn").click(function () {
                let $checkbox01 = $("input[name=checkbox01]:checked");
                if ($checkbox01.length === 0) {
                    alert("请选择需要关联的市场活动");
                } else {
                    let param = "contactsId=${contacts.id}&";
                    for (let i = 0; i < $checkbox01.length; i++) {
                        param += i === 0 ? "activityId=" + $($checkbox01[i]).val() : "&activityId=" + $($checkbox01[i]).val();
                    }
                    $.ajax({
                        url: "workbench/contacts/bind.do",
                        data: param,
                        type: "post",
                        success: function (data) {
                            if ("true" === data) {
                                // 关联成功刷新市场活动列表
                                showActivityList();

                                // 清除搜索框中的信息, 复选框中的选中去掉, 清空addActivityRelation中的内容
                                $("#addActivityRelation").html("");
                                $("#activityName").val("");
                                $("#bindSelectAll").prop("checked", false);

                                // 关闭模态窗口
                                $("#bindActivityModal").modal("hide");
                            } else {
                                alert("关联市场活动失败");
                            }
                        }
                    })
                }
            })

            // 解除一条联系人-市场活动关联
            $("#unbindBtn").click(function () {
                let id = $("#unbindId").val();
                $.ajax({
                    url: "workbench/contacts/unbind.do",
                    data: {
                        "id": id
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            showActivityList();
                            $("#unbindActivityModal").modal("hide");
                        } else {
                            alert("解除关联失败");
                        }
                    }
                })
            })

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            // 添加备注操作
            $("#remarkSaveBtn").click(function () {
                if ($.trim($("#remark").val()) === "") {
                    alert("请填写备注信息, 不能为空!")
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/remarkSave.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "contactsId": "${contacts.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#remark").val("");
                            let html = "";
                            html += '<div class="remarkDiv" id="' + data.contactsRemark.id + '" style="height: 60px;">';
                            html += '<img title="' + data.contactsRemark.createBy + '" src="static/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;">';
                            html += '<h5 id="e' + data.contactsRemark.id + '">' + data.contactsRemark.noteContent + '</h5>';
                            html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}</b> <small style="color: gray;" id="s' + data.contactsRemark.id + '">' + data.contactsRemark.createTime + ' 由' + data.contactsRemark.createBy + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.contactsRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\'' + data.contactsRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);
                        } else {
                            alert("添加备注失败!");
                        }
                    }
                })
            })

            // 修改备注操作
            $("#updateRemarkBtn").click(function () {
                let id = $("#remarkId").val();
                if ($.trim($("#noteContent").val()) === "") {
                    if (confirm("备注为空, 将被删除, 确定删除所选的记录吗 ? ")) {
                        removeRemark(id);
                    }
                    $("#editRemarkModal").modal("hide");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#e" + id).html(data.contactsRemark.noteContent);
                            $("#s" + id).html(data.contactsRemark.editTime + ' 由' + data.contactsRemark.editBy);
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败 !");
                        }
                    }
                })
            })

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })
        });

        // 展示备注信息
        function showRemarkList() {
            $.ajax({
                url: "workbench/contacts/getRemarkListByContactsId.do",
                data: {
                    "contactsId": "${contacts.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data, function (i, n) {
                        // javascript:void(0); 禁用超链接 只能以出发事件的形式操作
                        // 注意动态生成的元素必须套接在字符串中
                        html += '<div class="remarkDiv" id="' + n.id + '" style="height: 60px;">';
                        html += '<img title="' + n.createBy + '" src="static/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;">';
                        html += '<h5 id="e' + n.id + '">' + n.noteContent + '</h5>';
                        html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}</b> <small style="color: gray;" id="s' + n.id + '">' + (n.editFlag === "0" ? n.createTime : n.editTime) + ' 由' + (n.editFlag === "0" ? n.createBy : n.editBy) + '</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    // before 在该标签的上面添加html
                    $("#remarkDiv").before(html);
                }
            })
        }

        // 展示关联的市场活动列表
        function showActivityList() {
            $.ajax({
                url: "workbench/contacts/getActivityListByContactsId.do",
                data: {
                    "contactsId": "${contacts.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td>' + n.name + '</td>'
                        html += '<td>' + n.startDate + '</td>'
                        html += '<td>' + n.endDate + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td><a href="javascript:void(0);" onclick="setUnbindId(\'' + n.id + '\')" data-toggle="modal" data-target="#unbindActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>'
                        html += '</tr>'
                    })
                    $("#activityBody").html(html);
                }
            })
        }

        // 展示关联的交易列表
        function showTransactionList() {
            $.ajax({
                url: "workbench/contacts/getTransactionListByContactsId.do",
                data: {
                    "contactsId": "${contacts.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        html += 'onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.money + '</td>'
                        html += '<td>' + n.stage + '</td>'
                        html += '<td>' + n.possibility + '</td>'
                        html += '<td>' + n.expectedDate + '</td>'
                        html += '<td>' + n.type + '</td>'
                        html += '<td><a href="javascript:void(0);" onclick="setRemoveId(\'' + n.id + '\')" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
                        html += '</tr>'
                    })
                    $("#transactionBody").html(html);
                }
            })
        }

        // 打开解除市场活动关联时把要解除的关联关系id赋值给隐藏域
        function setUnbindId(id) {
            $("#unbindId").val(id);
        }

        function setRemoveId(id) {
            $("#removeId").val(id);
        }
    </script>

</head>
<body>
<!-- 修改联系人备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除该联系人的一条交易 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <input type="hidden" id="removeId">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="removeBtn">解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbindActivityModal" role="dialog">
    <input type="hidden" id="unbindId">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">解除关联</h4>
            </div>
            <div class="modal-body">
                <p>您确定要解除该关联关系吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="unbindBtn">解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="bindActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="activityName"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable2" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="bindSelectAll"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="addActivityRelation">
                    <%--							<tr>--%>
                    <%--								<td><input type="checkbox"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="checkbox"/></td>--%>
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
                <button type="button" class="btn btn-primary" id="bindBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--   由ajax提供   --%>
                            </select>
                        </div>
                        <label for="edit-source" class="col-sm-2 control-label">来源<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname">
                        </div>
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-birth">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${contacts.fullname}${contacts.appellation} <small> - ${contacts.customerId}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.fullname}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${contacts.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${contacts.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${contacts.job}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${contacts.birth}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${contacts.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${contacts.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${contacts.nextContactTime}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${contacts.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>
<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 20px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" id="remarkSaveBtn" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="transactionBody">
                <%--                <tr>--%>
                <%--                    <td><a href="settings/transactionDetail.do" style="text-decoration: none;">动力节点-交易01</a></td>--%>
                <%--                    <td>5,000</td>--%>
                <%--                    <td>谈判/复审</td>--%>
                <%--                    <td>90</td>--%>
                <%--                    <td>2017-02-07</td>--%>
                <%--                    <td>新业务</td>--%>
                <%--                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal"--%>
                <%--                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="workbench/transaction/add.do?flag=true&id=${contacts.id}&fullname=${contacts.fullname}"
               style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--						<tr>--%>
                <%--							<td><a href="settings/activityDetail.do" style="text-decoration: none;">发传单</a></td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--						</tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bindActivityModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>