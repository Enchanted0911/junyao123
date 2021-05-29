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

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			language: 'zh-CN',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		pageList(1, 3);
		// 搜索框操作
		$("#searchBtn").click(function () {
			// 查询前先把搜索框的内容保存一下
			$("#hidden-theme").val($.trim($("#search-theme").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()));
			$("#hidden-status").val($.trim($("#search-status").val()));
			$("#hidden-expectedDate").val($.trim($("#search-expectedDate").val()));
			$("#hidden-priority").val($.trim($("#search-priority").val()));
			pageList(1, 3);
		});
		// 复选框操作
		$("#selectAll").click(function () {
			$("input[name = checkbox01]").prop("checked", this.checked);
		});
		// 注意动态生成的元素是不能以普通绑定事件的形式生成
		// 动态生成的元素，用on方法的形式来触发事件
		// 语法 ：$(需要绑定元素的有效外层元素).on(绑定事件的方式, 需要绑定的元素的jquery对象, 回调函数)
		$("#taskBody").on("click", $("input[name = checkbox01]"), function () {
			$("#selectAll").prop("checked", $("input[name = checkbox01]").length === $("input[name = checkbox01]:checked").length);
		});

		// 跳转到修改的界面
		$("#editBtn").click(function () {
			let $checkbox01 = $("input[name = checkbox01]:checked");
			if ($checkbox01.length === 0) {
				alert("请选择要修改的记录 !");
			} else if ($checkbox01.length > 1) {
				alert("每次只能修改一条记录, 请选择要修改的那条 !");
			} else {
				let id = $checkbox01.val();
				window.location.href = "workbench/visit/getUserListAndTask.do?id=" + id;
			}
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
						url: "workbench/visit/delete.do",
						data: param,
						type: "post",
						success: function (data) {
							if (data === "true") {
								// 有待完善
								pageList(1, $("#taskPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								alert("sorry!删除交易失败 !");
							}
						}
					})
				}
			}
		});
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		
	});
	function pageList(pageNo, pageSize) {
		// 每次刷新列表, 去除复选框的选中
		$("#selectAll").prop("checked", false);
		// 查询前将隐藏域中的信息取出来, 重新赋给搜索框
		$("#search-theme").val($.trim($("#hidden-theme").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-contactsName").val($.trim($("#hidden-contactsName").val()));
		$("#search-status").val($.trim($("#hidden-status").val()));
		$("#search-expectedDate").val($.trim($("#hidden-expectedDate").val()));
		$("#search-priority").val($.trim($("#hidden-priority").val()));
		$.ajax({
			url: "workbench/visit/pageList.do",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"theme": $.trim($("#search-theme").val()),
				"owner": $.trim($("#search-owner").val()),
				"contactsName": $.trim($("#search-contactsName").val()),
				"status": $.trim($("#search-status").val()),
				"expectedDate": $.trim($("#search-expectedDate").val()),
				"priority": $.trim($("#search-priority").val())
			},
			type: "get",
			dataType: "json",
			success: function (data) {
				let html = "";
				$.each(data.dataList, function (i, n) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="checkbox01" value="' + n.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;"';
					html += 'onclick="window.location.href=\'workbench/visit/detail.do?id=' + n.id + '\';">' + n.theme + '</a></td>';
					html += '<td>' + n.expectedDate + '</td>';
					html += '<td>' + n.contactsId + '</td>';
					html += '<td>' + n.status + '</td>';
					html += '<td>' + n.priority + '</td>';
					html += '<td>' + n.owner + '</td>';
					html += '</tr>';
				})
				$("#taskBody").html(html);

				// 数据处理完毕后结合分页查询，对前端展示分页信息
				let totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
				$("#taskPage").bs_pagination({
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
<input type="hidden" id="hidden-theme"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-contactsName"/>
<input type="hidden" id="hidden-status"/>
<input type="hidden" id="hidden-expectedDate"/>
<input type="hidden" id="hidden-priority"/>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>任务列表</h3>
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
				      <div class="input-group-addon">主题</div>
				      <input class="form-control" type="text" id="search-theme">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">到期日期</div>
				      <input class="form-control time" type="text" id="search-expectedDate">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select class="form-control" id="search-status">
						  <option></option>
						  <c:forEach items="${returnStateList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">优先级</div>
					  <select class="form-control" id="search-priority">
						  <option></option>
						  <c:forEach items="${returnPriorityList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/visit/add.do';"><span class="glyphicon glyphicon-plus"></span> 任务</button>
				  <button type="button" class="btn btn-default" onclick="alert('这个功能还未实现哦');"><span class="glyphicon glyphicon-plus"></span> 通话</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>主题</td>
							<td>到期日期</td>
							<td>联系人</td>
							<td>状态</td>
							<td>优先级</td>
							<td>所有者</td>
						</tr>
					</thead>
					<tbody id="taskBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="taskPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>