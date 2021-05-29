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
    <script src="static/crm/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">

        $(function () {
            pageList(1, 3);
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $(".time").datetimepicker({
                minView: "month",
                format: 'yyyy-mm-dd',
                language: 'zh-CN',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            // 复选框操作
            $("#selectAll").click(function () {
                $("input[name = checkbox01]").prop("checked", this.checked);
            });
            // 注意动态生成的元素是不能以普通绑定事件的形式生成
            // 动态生成的元素，用on方法的形式来触发事件
            // 语法 ：$(需要绑定元素的有效外层元素).on(绑定事件的方式, 需要绑定的元素的jquery对象, 回调函数)
            $("#customerBody").on("click", $("input[name = checkbox01]"), function () {
                $("#selectAll").prop("checked", $("input[name = checkbox01]").length === $("input[name = checkbox01]:checked").length);
            });

            // 搜索框操作
            $("#searchBtn").click(function () {
                // 查询前先把搜索框的内容保存一下
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-website").val($.trim($("#search-website").val()));
                $("#hidden-phone").val($.trim($("#search-phone").val()));
                pageList(1, 3);
            });
            // 打开创建的模态窗口
            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/customer/getUserList.do",
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
                        $("#createCustomerModal").modal("show");
                    }
                })
            });
            // 创建一个客户
            $("#saveBtn").click(function () {
                if ($.trim($("#create-name").val()) === "" || $.trim($("#create-owner").val()) === "") {
                    alert("请把必要信息填写完整 !!!");
                    return false;
                }
                $.ajax({
                    url: "workbench/customer/save.do",
                    data: {
                        "phone": $.trim($("#create-phone").val()),
                        "website": $.trim($("#create-website").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val()),
                        "name": $.trim($("#create-name").val()),
                        "owner": $.trim($("#create-owner").val()),
                        "description": $.trim($("#create-description").val())
                    },
                    type: "post",
                    success: function (data) {
                        if ("true" === data) {
                            pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口前reset表单,需要将jquery对象转成dom对象，因为dom有reset，jquery没有
                            $("#customerAddForm")[0].reset();
                            // 关闭模态窗口
                            $("#createCustomerModal").modal("hide");
                        } else {
                            alert("添加市场活动失败");
                        }
                    }
                })
            });

            // 打开修改的模态窗口
            $("#editBtn").click(function () {
                let $checkbox01 = $("input[name = checkbox01]:checked");
                if ($checkbox01.length === 0) {
                    alert("请选择要修改的记录 !");
                } else if ($checkbox01.length > 1) {
                    alert("每次只能修改一条记录, 请选择要修改的那条 !");
                } else {
                    let id = $checkbox01.val();
                    $.ajax({
                        url: "workbench/customer/getUserListAndCustomer.do",
                        data: {
                            "id": id
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
                }
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
                            // 第一个参数表示 操作后停留在当前页 第二个参数表示 操作后维持已经设置好的每页展现的记录数
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage'), $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口
                            $("#editCustomerModal").modal("hide");
                        } else {
                            alert("修改客户失败");
                        }
                    }
                })
            });

            // 删除操作
            $("#deleteBtn").click(function () {
                let $checkbox01 = $("input[name = checkbox01]:checked");
                if ($checkbox01.length === 0) {
                    alert("请选择要删除的记录");
                } else {
                    if (confirm("确定删除所选的记录吗 ? ")) {
                        let param = "";
                        for (let i = 0; i < $checkbox01.length; i++) {
                            param += i === $checkbox01.length - 1 ? "id=" + $($checkbox01[i]).val() : "id=" + $($checkbox01[i]).val() + "&";
                        }
                        $.ajax({
                            url: "workbench/customer/delete.do",
                            data: param,
                            type: "post",
                            success: function (data) {
                                if (data === "true") {
                                    // 有待完善
                                    pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("sorry!删除客户失败 !");
                                }
                            }
                        })
                    }
                }
            });
        });

        function pageList(pageNo, pageSize) {
            // 每次刷新列表, 去除复选框的选中
            $("#selectAll").prop("checked", false);
            // 查询前将隐藏域中的信息取出来, 重新赋给搜索框
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-website").val($.trim($("#hidden-website").val()));
            $("#search-phone").val($.trim($("#hidden-phone").val()));
            $.ajax({
                url: "workbench/customer/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "phone": $.trim($("#search-phone").val()),
                    "website": $.trim($("#search-website").val())
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="checkbox01" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;"';
                        html += 'onclick="window.location.href=\'workbench/customer/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.phone + '</td>';
                        html += '<td>' + n.website + '</td>';
                        html += '</tr>';
                    })
                    $("#customerBody").html(html);

                    // 数据处理完毕后结合分页查询，对前端展示分页信息
                    let totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    $("#customerPage").bs_pagination({
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
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-phone"/>
<input type="hidden" id="hidden-website"/>
<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="customerAddForm" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--	由AJAX提供     --%>
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
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
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="search-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">
                <%--						<tr>--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='settings/customerDetail.do';">动力节点</a></td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td>010-84846003</td>--%>
                <%--							<td>http://www.bjpowernode.com</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='settings/customerDetail.do';">动力节点</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>010-84846003</td>--%>
                <%--                            <td>http://www.bjpowernode.com</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="customerPage"></div>
        </div>

    </div>

</div>
</body>
</html>