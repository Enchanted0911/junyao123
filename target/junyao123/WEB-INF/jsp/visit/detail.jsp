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

    <link rel="shortcut icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="72x72" href="static/imgs/title/cat.png">
    <link rel="apple-touch-icon" sizes="114x114" href="static/imgs/title/cat.png">
    <link rel="stylesheet" href="static/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
    <script src="static/crm/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        let cancelAndSaveBtnDefault = true;

        // 展示备注信息
        function showRemarkList() {
            $.ajax({
                url: "workbench/visit/getRemarkListByTaskId.do",
                data: {
                    "taskId": "${task.id}"
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
                        html += '<font color="gray">任务</font> <font color="gray">-</font> <b>${task.theme}</b> <small style="color: gray;" id="s' + n.id + '">' + (n.editFlag === "0" ? n.createTime : n.editTime) + ' 由' + (n.editFlag === "0" ? n.createBy : n.editBy) + '</small>';
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
                url: "workbench/visit/removeRemark.do",
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
            // 页面加载完毕, 展现该任务关联的备注信息列表
            showRemarkList();

            // 添加备注操作
            $("#remarkSaveBtn").click(function () {
                if ($.trim($("#remark").val()) === "") {
                    alert("请填写备注信息, 不能为空!")
                    return false;
                }
                $.ajax({
                    url: "workbench/visit/remarkSave.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "taskId": "${task.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#remark").val("");
                            let html = "";
                            html += '<div class="remarkDiv" id="' + data.taskRemark.id + '" style="height: 60px;">';
                            html += '<img title="' + data.taskRemark.createBy + '" src="static/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;">';
                            html += '<h5 id="e' + data.taskRemark.id + '">' + data.taskRemark.noteContent + '</h5>';
                            html += '<font color="gray">任务</font> <font color="gray">-</font> <b>${task.theme}</b> <small style="color: gray;" id="s' + data.taskRemark.id + '">' + data.taskRemark.createTime + ' 由' + data.taskRemark.createBy + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.taskRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\'' + data.taskRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
                    url: "workbench/visit/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#e" + id).html(data.taskRemark.noteContent);
                            $("#s" + id).html(data.taskRemark.editTime + ' 由' + data.taskRemark.editBy);
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败 !");
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

    </script>

</head>
<body>
<!-- 修改备注的模态窗口 -->
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
<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>拜访客户</h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='settings/visitEditTask.do';"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">主题</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.theme}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">到期日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.expectedDate}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">联系人</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.contactsId}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">状态</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.status}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">优先级</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.priority}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">任务所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${task.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">提醒时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.startDate}${task.repeatType == "" ? "" : "("}${task.repeatType}${task.repeatType == "" ? "" : "发"}${task.notifyType}${task.repeatType == "" ? "" : ")"}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${task.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${task.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${task.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${task.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${task.description}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: -20px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="remarkSaveBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>