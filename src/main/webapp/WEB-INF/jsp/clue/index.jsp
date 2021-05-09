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
    <link href="static/bs_pagination/jquery.bs_pagination.min.css" rel="stylesheet"/>
    <script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="static/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="static/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script src="static/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "top-left"
            });

            // 搜索框操作
            $("#searchBtn").click(function () {
                // 查询前先把搜索框的内容保存一下
                $("#hidden-fullname").val($.trim($("#search-fullname").val()));
                $("#hidden-company").val($.trim($("#search-company").val()));
                $("#hidden-phone").val($.trim($("#search-phone").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-mphone").val($.trim($("#search-mphone").val()));
                $("#hidden-state").val($.trim($("#search-state").val()));
                $("#hidden-source").val($.trim($("#search-source").val()));
                pageList(1, 2);
            });

            // 复选框操作
            $("#selectAll").click(function () {
                $("input[name = checkbox01]").prop("checked", this.checked);
            });
            // 注意动态生成的元素是不能以普通绑定事件的形式生成
            // 动态生成的元素，用on方法的形式来触发事件
            // 语法 ：$(需要绑定元素的有效外层元素).on(绑定事件的方式, 需要绑定的元素的jquery对象, 回调函数)
            $("#clueBody").on("click", $("input[name = checkbox01]"), function () {
                $("#selectAll").prop("checked", $("input[name = checkbox01]").length === $("input[name = checkbox01]:checked").length);
            });

            pageList(1, 2);

            // 打开创建线索的模态窗口
            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        let html = "<option></option>"
                        $.each(data, function (i, n) {
                            html += "<option value = '" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-clueOwner").html(html);
                        // 设置下拉列表框的默认值为当前用户
                        // 在JS中使用EL表达式一定要套在字符串中
                        $("#create-clueOwner").val("${user.id}");
                        //操作模态窗口的方式 :
                        //  需要操作模态窗口的jquery对象，调用modal方法，为该方法传递参数，show打开窗口，hide关闭模态窗口
                        $("#createClueModal").modal("show");
                    }
                })
            })

            // 保存一条新建的线索
            $("#saveBtn").click(function () {
                if ($.trim($("#create-fullname").val()) === "" || $.trim($("#create-appellation").val()) === "" || $.trim($("#create-state").val()) === ""
                    || $.trim($("#create-clueOwner").val()) === "" || $.trim($("#create-company").val()) === "" || $.trim($("#create-phone").val()) === ""
                || $.trim($("#create-mphone").val()) === "" || $.trim($("#create-source").val()) === "") {
                    alert("请填写完整必要的信息!!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/clue/save.do",
                    type: "post",
                    data: {
                        "fullname": $.trim($("#create-fullname").val()),
                        "appellation": $.trim($("#create-appellation").val()),
                        "owner": $.trim($("#create-clueOwner").val()),
                        "company": $.trim($("#create-company").val()),
                        "job": $.trim($("#create-job").val()),
                        "email": $.trim($("#create-email").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "website": $.trim($("#create-website").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "state": $.trim($("#create-state").val()),
                        "source": $.trim($("#create-source").val()),
                        "description": $.trim($("#create-description").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    success: function (data) {
                        if ("true" === data) {
                            pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口前reset表单,需要将jquery对象转成dom对象，因为dom有reset，jquery没有
                            $("#clueAddForm")[0].reset();
                            $("#createClueModal").modal("hide");
                        } else {
                            alert("线索添加失败");
                        }
                    }
                })
            })

            // 打开修改线索的模态窗口
            $("#editBtn").click(function () {
                let $checkbox01 = $("input[name = checkbox01]:checked");
                if ($checkbox01.length === 0) {
                    alert("请选择要修改的记录 !");
                } else if ($checkbox01.length > 1) {
                    alert("每次只能修改一条记录, 请选择要修改的那条 !");
                } else {
                    let id = $checkbox01.val();
                    $.ajax({
                        url: "workbench/clue/getUserListAndClue.do",
                        type: "get",
                        data: {
                            "id" : id
                        },
                        dataType: "json",
                        success: function (data) {
                            // 处理所有者下拉框
                            let html = "<option></option>";
                            $.each(data.uList, function (i, n) {
                                html += "<option value='" + n.id + "'>" + n.name + "</option>";
                            })
                            $("#edit-clueOwner").html(html);
                            $("#edit-clueOwner").val("${user.id}");

                            // 处理单条Clue
                            $("#edit-company").val(data.clue.company);
                            $("#edit-appellation").val(data.clue.appellation);
                            $("#edit-state").val(data.clue.state);
                            $("#edit-source").val(data.clue.source);
                            $("#edit-fullname").val(data.clue.fullname);
                            $("#edit-phone").val(data.clue.phone);
                            $("#edit-mphone").val(data.clue.mphone);
                            $("#edit-description").val(data.clue.description);
                            $("#edit-website").val(data.clue.website);
                            $("#edit-job").val(data.clue.job);
                            $("#edit-email").val(data.clue.email);
                            $("#edit-contactSummary").val(data.clue.contactSummary);
                            $("#edit-nextContactTime").val(data.clue.nextContactTime);
                            $("#edit-address").val(data.clue.address);
                            $("#edit-clueId").val(data.clue.id);

                            // 打开模态窗口
                            $("#editClueModal").modal("show");
                        }
                    })
                }
            });

            // 修改一个线索, 一般修改操作和添加操作有很大的相似度, 可以使用CV大法
            $("#updateBtn").click(function () {
                if ($.trim($("#edit-fullname").val()) === "" || $.trim($("#edit-appellation").val()) === "" || $.trim($("#edit-state").val()) === ""
                    || $.trim($("#edit-clueOwner").val()) === "" || $.trim($("#edit-company").val()) === "" || $.trim($("#edit-phone").val()) === ""
                    || $.trim($("#edit-mphone").val()) === "" || $.trim($("#edit-source").val()) === "") {
                    alert("请填写完整必要的信息!!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/clue/update.do",
                    data: {
                        "id" : $.trim($("#edit-clueId").val()),
                        "fullname": $.trim($("#edit-fullname").val()),
                        "appellation": $.trim($("#edit-appellation").val()),
                        "owner": $.trim($("#edit-clueOwner").val()),
                        "company": $.trim($("#edit-company").val()),
                        "job": $.trim($("#edit-job").val()),
                        "email": $.trim($("#edit-email").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "website": $.trim($("#edit-website").val()),
                        "mphone": $.trim($("#edit-mphone").val()),
                        "state": $.trim($("#edit-state").val()),
                        "source": $.trim($("#edit-source").val()),
                        "description": $.trim($("#edit-description").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val())
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            // 第一个参数表示 操作后停留在当前页 第二个参数表示 操作后维持已经设置好的每页展现的记录数
                            pageList($("#cluePage").bs_pagination('getOption', 'currentPage'), $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口
                            $("#editClueModal").modal("hide");
                        } else {
                            alert("修改线索失败");
                        }
                    }
                })
            });
        });

        function pageList(pageNo, pageSize) {
            // 每次刷新列表, 去除复选框的选中
            $("#selectAll").prop("checked", false);
            // 查询前将隐藏域中的信息取出来, 重新赋给搜索框
            $("#search-fullname").val($("#hidden-fullname").val());
            $("#search-company").val($("#hidden-company").val());
            $("#search-phone").val($("#hidden-phone").val());
            $("#search-owner").val($("#hidden-owner").val());
            $("#search-mphone").val($("#hidden-mphone").val());
            $("#search-state").val($("#hidden-state").val());
            $("#search-source").val($("#hidden-source").val());
            $.ajax({
                url: "workbench/clue/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "fullname": $("#search-fullname").val(),
                    "company": $("#search-company").val(),
                    "phone": $("#search-phone").val(),
                    "owner": $("#search-owner").val(),
                    "mphone": $("#search-mphone").val(),
                    "state": $("#search-state").val(),
                    "source": $("#search-source").val()
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="checkbox01" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        html += 'onclick="window.location.href=\'workbench/clue/detail.do?id=' + n.id + '\';">' + n.fullname + '</a></td>';
                        html += '<td>' + n.company + '</td>';
                        html += '<td>' + n.phone + '</td>';
                        html += '<td>' + n.mphone + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.state + '</td>';
                        html += '</tr>';
                    })
                    $("#clueBody").html(html);

                    // 数据处理完毕后结合分页查询，对前端展示分页信息
                    let totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    $("#cluePage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            })
        }
    </script>
</head>
<body>
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-state">
<input type="hidden" id="hidden-source">

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form id="clueAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <%--     由ajax填充数据    --%>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源<span
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
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
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

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-clueId">
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <%--     由AJAX获得     --%>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="search-company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="search-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-state">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAll"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <%--                <tr>--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='settings/clueDetail.do';">李四先生</a></td>--%>
                <%--                    <td>动力节点</td>--%>
                <%--                    <td>010-84846003</td>--%>
                <%--                    <td>12345678901</td>--%>
                <%--                    <td>广告</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>已联系</td>--%>
                <%--                </tr>--%>
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='settings/clueDetail.do';">李四先生</a></td>--%>
                <%--                    <td>动力节点</td>--%>
                <%--                    <td>010-84846003</td>--%>
                <%--                    <td>12345678901</td>--%>
                <%--                    <td>广告</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>已联系</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="cluePage"></div>
            <%--            <div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
            <%--            </div>--%>
            <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
            <%--                <div class="btn-group">--%>
            <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
            <%--                        10--%>
            <%--                        <span class="caret"></span>--%>
            <%--                    </button>--%>
            <%--                    <ul class="dropdown-menu" role="menu">--%>
            <%--                        <li><a href="#">20</a></li>--%>
            <%--                        <li><a href="#">30</a></li>--%>
            <%--                    </ul>--%>
            <%--                </div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
            <%--            </div>--%>
            <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
            <%--                <nav>--%>
            <%--                    <ul class="pagination">--%>
            <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
            <%--                        <li class="active"><a href="#">1</a></li>--%>
            <%--                        <li><a href="#">2</a></li>--%>
            <%--                        <li><a href="#">3</a></li>--%>
            <%--                        <li><a href="#">4</a></li>--%>
            <%--                        <li><a href="#">5</a></li>--%>
            <%--                        <li><a href="#">下一页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
            <%--                    </ul>--%>
            <%--                </nav>--%>
            <%--            </div>--%>
        </div>
    </div>
</div>
</body>
</html>