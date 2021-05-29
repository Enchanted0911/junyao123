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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        let cancelAndSaveBtnDefault = true;

        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

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
            showRemarkList();
			// 展现关联的交易列表
			showTransactionList();
			// 展现关联的联系人列表
            showContactsList();
            // 打开修改的模态窗口
            $("#editBtn").click(function () {
                $.ajax({
                    url: "workbench/customer/getUserListAndCustomer.do",
                    data: {
                        "id": "${customer.id}"
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
                        $("#edit-phone").val(data.customer.phone);
                        $("#edit-contactSummary").val(data.customer.contactSummary);
                        $("#edit-nextContactTime").val(data.customer.nextContactTime);
                        $("#edit-address").val(data.customer.address);
                        $("#edit-name").val(data.customer.name);
                        $("#edit-owner").val(data.customer.owner);
                        $("#edit-description").val(data.customer.description);
                        $("#edit-id").val(data.customer.id);
                        $("#edit-website").val(data.customer.website);

                        // 打开模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                })
            });
            // 修改一个客户, 一般修改操作和添加操作有很大的相似度, 可以使用CV大法
            $("#updateBtn").click(function () {
                if ($.trim($("#edit-name").val()) === "" || $.trim($("#edit-owner").val()) === "") {
                    alert("请把必要信息填写完整 !!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/customer/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val()),
                        "name": $.trim($("#edit-name").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "website": $.trim($("#edit-website").val()),
                        "description": $.trim($("#edit-description").val())
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            window.location.reload();
                            // 关闭模态窗口
                            $("#editCustomerModal").modal("hide");
                        } else {
                            alert("修改客户失败");
                        }
                    }
                })
            });

            // 删除客户操作
            $("#deleteBtn").click(function () {
                if (confirm("确定删除所选的记录吗 ? ")) {
                    let param = "id=${customer.id}";
                    $.ajax({
                        url: "workbench/customer/delete.do",
                        data: param,
                        type: "post",
                        success: function (data) {
                            if (data === "true") {
                                alert("删除成功, 即将会回到联系人主界面");
                                window.location.href = "settings/customerIndex.do";
                            } else {
                                alert("sorry!删除客户失败 !");
                            }
                        }
                    })
                }
            });
            // 添加备注操作
            $("#remarkSaveBtn").click(function () {
                if ($.trim($("#remark").val()) === "") {
                    alert("请填写备注信息, 不能为空!")
                    return false;
                }
                $.ajax({
                    url: "workbench/customer/remarkSave.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "customerId": "${customer.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#remark").val("");
                            let html = "";
                            html += '<div class="remarkDiv" id="' + data.customerRemark.id + '" style="height: 60px;">';
                            html += '<img title="' + data.customerRemark.createBy + '" src="static/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;">';
                            html += '<h5 id="e' + data.customerRemark.id + '">' + data.customerRemark.noteContent + '</h5>';
                            html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;" id="s' + data.customerRemark.id + '">' + data.customerRemark.createTime + ' 由' + data.customerRemark.createBy + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.customerRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\'' + data.customerRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
                    url: "workbench/customer/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#e" + id).html(data.customerRemark.noteContent);
                            $("#s" + id).html(data.customerRemark.editTime + ' 由' + data.customerRemark.editBy);
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败 !");
                        }
                    }
                })
            })

			// 删除该客户的一条交易
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

            // 打开创建联系人的模态窗口
            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/contacts/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        let html = "<option></option>"
                        $.each(data, function (i, n) {
                            html += "<option value = '" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-owner").html(html);
                        // 设置下拉列表框的默认值为当前用户
                        // 在JS中使用EL表达式一定要套在字符串中
                        $("#create-owner").val("${user.id}");
                        //操作模态窗口的方式 :
                        //  需要操作模态窗口的jquery对象，调用modal方法，为该方法传递参数，show打开窗口，hide关闭模态窗口
                        $("#createContactsModal").modal("show");
                    }
                })
            });

            // 创建一个联系人
            $("#saveBtn").click(function () {
                if ($.trim($("#create-fullname").val()) === "" || $.trim($("#create-customerName").val()) === ""
                    || $.trim($("#create-owner").val()) === "" || $.trim($("#create-source").val()) === "") {
                    alert("请把必要信息填写完整 !!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/contacts/save.do",
                    data: {
                        "appellation": $.trim($("#create-appellation").val()),
                        "email": $.trim($("#create-email").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "job": $.trim($("#create-job").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val()),
                        "fullname": $.trim($("#create-fullname").val()),
                        "owner": $.trim($("#create-owner").val()),
                        "birth": $.trim($("#create-birth").val()),
                        "source": $.trim($("#create-source").val()),
                        "customerName": $.trim($("#create-customerName").val()),
                        "description": $.trim($("#create-description").val())
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            // 关闭模态窗口前reset表单,需要将jquery对象转成dom对象，因为dom有reset，jquery没有
                            $("#contactsAddForm")[0].reset();
                            // 关闭模态窗口
                            $("#createContactsModal").modal("hide");
                            window.location.reload();
                        } else {
                            alert("添加联系人失败");
                        }
                    }
                })
            });

            // 删除一个联系人
            $("#removeConBtn").click(function () {
                let id = $("#removeConId").val();
                let param = "id=" + id;
                $.ajax({
                    url: "workbench/contacts/delete.do",
                    data: param,
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            showContactsList();
                            $("#removeContactsModal").modal("hide");
                        } else {
                            alert("交易删除失败!")
                            $("#removeContactsModal").modal("hide");
                        }
                    }
                })
            })
        });

        // 展示备注信息
        function showRemarkList() {
            $.ajax({
                url: "workbench/customer/getRemarkListByCustomerId.do",
                data: {
                    "customerId": "${customer.id}"
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
                        html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;" id="s' + n.id + '">' + (n.editFlag === "0" ? n.createTime : n.editTime) + ' 由' + (n.editFlag === "0" ? n.createBy : n.editBy) + '</small>';
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
                url: "workbench/customer/removeRemark.do",
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

		// 展示关联的交易列表
		function showTransactionList() {
			$.ajax({
				url: "workbench/customer/getTransactionListByCustomerId.do",
				data: {
					"customerId": "${customer.id}"
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

		function setRemoveId(id) {
			$("#removeId").val(id);
		}

        // 展示关联的联系人列表
        function showContactsList() {
            $.ajax({
                url: "workbench/customer/getContactsListByCustomerId.do",
                data: {
                    "customerId": "${customer.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>'
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        html += 'onclick="window.location.href=\'workbench/contacts/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
                        html += '<td>' + n.email + '</td>'
                        html += '<td>' + n.mphone + '</td>'
                        html += '<td><a href="javascript:void(0);" onclick="setRemoveConId(\'' + n.id + '\')" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
                        html += '</tr>'
                    })
                    $("#contactsBody").html(html);
                }
            })
        }
        function setRemoveConId(id) {
            $("#removeConId").val(id);
        }
    </script>

</head>
<body>
<!-- 修改客户备注的模态窗口 -->
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

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <input type="hidden" id="removeConId">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="removeConBtn">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除该客户的一条交易 -->
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

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form id="contactsAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--	由AJAX获得	--%>
                            </select>
                        </div>
                        <label for="create-source" class="col-sm-2 control-label">来源<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-birth">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--      by AJAX     --%>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
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
        <h3>${customer.name} <small><a href="http://${customer.website}" target="_blank">${customer.website}</a></small>
        </h3>
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
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${customer.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${customer.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.address}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 10px; left: 40px;">
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
            <table id="activityTable2" class="table table-hover" style="width: 900px;">
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
                </tbody>
            </table>
        </div>

        <div>
			<a href="workbench/transaction/cusAdd.do?id=${customer.id}&name=${customer.name}&flagCus=true"
			   style="text-decoration: none;"><span
					class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 联系人 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="contactsBody">
<%--                <tr>--%>
<%--                    <td><a href="settings/contactsDetail.do" style="text-decoration: none;">李四</a></td>--%>
<%--                    <td>lisi@bjpowernode.com</td>--%>
<%--                    <td>13543645364</td>--%>
<%--                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal"--%>
<%--                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
<%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="addBtn"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>