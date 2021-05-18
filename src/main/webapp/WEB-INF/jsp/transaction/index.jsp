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

<script>


	$(function(){
		pageList(1, 3);
		// 搜索框操作
		$("#searchBtn").click(function () {
			// 查询前先把搜索框的内容保存一下
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-type").val($.trim($("#search-type").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			pageList(1, 3);
		});
		// 复选框操作
		$("#selectAll").click(function () {
			$("input[name = checkbox01]").prop("checked", this.checked);
		});
		// 注意动态生成的元素是不能以普通绑定事件的形式生成
		// 动态生成的元素，用on方法的形式来触发事件
		// 语法 ：$(需要绑定元素的有效外层元素).on(绑定事件的方式, 需要绑定的元素的jquery对象, 回调函数)
		$("#transactionBody").on("click", $("input[name = checkbox01]"), function () {
			$("#selectAll").prop("checked", $("input[name = checkbox01]").length === $("input[name = checkbox01]:checked").length);
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
						url: "workbench/transaction/delete.do",
						data: param,
						type: "post",
						success: function (data) {
							if (data === "true") {
								// 有待完善
								pageList(1, $("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								alert("sorry!删除交易失败 !");
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
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-type").val($.trim($("#hidden-type").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$.ajax({
			url: "workbench/transaction/pageList.do",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"name": $.trim($("#search-name").val()),
				"owner": $.trim($("#search-owner").val()),
				"contactsName": $.trim($("#search-contactsName").val()),
				"source": $.trim($("#search-source").val()),
				"stage": $.trim($("#search-stage").val()),
				"type": $.trim($("#search-type").val()),
				"customerName": $.trim($("#search-customerName").val())
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				let html = "";
				$.each(data.dataList, function (i, n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="checkbox01" value="' + n.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;"';
					html += 'onclick="window.location.href=\'workbench/transaction/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
					html += '<td>' + n.customerId + '</td>';
					html += '<td>' + n.stage + '</td>';
					html += '<td>' + n.type + '</td>';
					html += '<td>' + n.owner + '</td>';
					html += '<td>' + n.source + '</td>';
					html += '<td>' + n.contactsId + '</td>';
					html += '</tr>';
				})
				$("#transactionBody").html(html);

				// 数据处理完毕后结合分页查询，对前端展示分页信息
				let totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
				$("#transactionPage").bs_pagination({
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
<input type="hidden" id="hidden-customerName"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-contactsName"/>
<input type="hidden" id="hidden-stage"/>
<input type="hidden" id="hidden-type"/>

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
						  <option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
						  <option></option>
						  <c:forEach items="${transactionTypeList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do?flag=false';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.do';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='settings/transactionDetail.do';">动力节点-交易01</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>新业务</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>李四</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='settings/transactionDetail.do';">动力节点-交易01</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>谈判/复审</td>--%>
<%--                            <td>新业务</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>李四</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="transactionPage"></div>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>