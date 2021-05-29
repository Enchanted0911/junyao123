<%@ page import="icu.junyao.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="icu.junyao.crm.settings.service.DicService" %>
<%@ page import="java.util.Set" %>
<%@ page import="icu.junyao.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 只针对当前页面有效， 有必要需要在每个页面加上这段代码
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
    List<DicValue> dicValueList = (List<DicValue>) application.getAttribute("stageList");
    Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
    Set<String> set = pMap.keySet();
    // 正常状态和丢失状态的分割点
    int point = 0;
    for (int i = 0; i < dicValueList.size(); i++) {
        DicValue dicValue = dicValueList.get(i);
        String stage = dicValue.getValue();
        String possibility = pMap.get(stage);
        if ("0".equals(possibility)) {
            point = i;
            break;
        }
    }
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

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript">

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
                url: "workbench/transaction/removeRemark.do",
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
                    url: "workbench/transaction/remarkSave.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "tranId": "${tran.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#remark").val("");
                            let html = "";
                            html += '<div class="remarkDiv" id="' + data.tranRemark.id + '" style="height: 60px;">';
                            html += '<img title="' + data.tranRemark.createBy + '" src="static/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;">';
                            html += '<h5 id="e' + data.tranRemark.id + '">' + data.tranRemark.noteContent + '</h5>';
                            html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;" id="s' + data.tranRemark.id + '">' + data.tranRemark.createTime + ' 由' + data.tranRemark.createBy + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.tranRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="removeRemark(\'' + data.tranRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
                    url: "workbench/transaction/updateRemark.do",
                    data: {
                        "id": id,
                        "noteContent": $.trim($("#noteContent").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.flag === true) {
                            $("#e" + id).html(data.tranRemark.noteContent);
                            $("#s" + id).html(data.tranRemark.editTime + ' 由' + data.tranRemark.editBy);
                            $("#editRemarkModal").modal("hide");
                        } else {
                            alert("修改备注失败 !");
                        }
                    }
                })
            })

            // 删除操作
            $("#deleteBtn").click(function () {
                if (confirm("确定删除该条交易记录吗 ? ")) {
                    let param = "id=${tran.id}";
                    $.ajax({
                        url: "workbench/transaction/delete.do",
                        data: param,
                        type: "post",
                        success: function (data) {
                            if (data === "true") {
                                alert("删除成功, 即将会回到交易主界面");
                                window.location.href = "settings/transactionIndex.do";
                            } else {
                                alert("sorry!删除交易失败 !");
                            }
                        }
                    })
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


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            //页面加载完毕展示交易历史列表
            showHistoryList();

            // 展示备注信息
            showRemarkList();
        });

        function showHistoryList() {
            $.ajax({
                url: "workbench/transaction/getHistoryListByTranId.do",
                data: {
                    "tranId": "${tran.id}"
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    let html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.money + '</td>';
                        html += '<td>' + n.possibility + '</td>';
                        html += '<td>' + n.expectedDate + '</td>';
                        html += '<td>' + n.createTime + '</td>';
                        html += '<td>' + n.createBy + '</td>';
                        html += '</tr>';
                    })
                    $("#tranHistoryBody").html(html);
                }
            })
        }

        // 改变交易阶段
        function changeStage(stage, i) {
            $.ajax({
                url: "workbench/transaction/changeStage.do",
                data: {
                    "id": "${tran.id}",
                    "stage": stage,
                    "money": "${tran.money}",
                    "expectedDate": "${tran.expectedDate}"
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#stage").html(data.tran.stage);
                        $("#possibility").html(data.tran.possibility);
                        $("#editBy").html(data.tran.editBy);
                        $("#editTime").html(data.tran.editTime);

                        changeIcon(stage, i);
                        showHistoryList();
                    } else {
                        alert("改变阶段失败")
                    }
                }
            })
        }


        // 这个函数里面不能用三等于判断 要用双等于
        function changeIcon(stage, index1) {
            //当前阶段
            let currentStage = stage;
            //当前阶段可能性
            let currentPossibility = $("#possibility").html();
            //当前阶段的下标
            let index = index1;
            //前面正常阶段和后面丢失阶段的分界点下标, 注意java对象转换成JS对象要套在百分号中
            let point = "<%=point%>";
            //如果当前阶段的可能性为0 前7个一定是黑圈，后两个一个是红叉，一个是黑叉
            if (currentPossibility === "0") {
                //遍历前7个
                for (let i = 0; i < point; i++) {
                    //黑圈------------------------------
                    //移除掉原有的样式
                    $("#" + i).removeClass();
                    //添加新样式
                    $("#" + i).addClass("glyphicon glyphicon-record mystage");
                    //为新样式赋予颜色
                    $("#" + i).css("color", "#000000");
                }
                //遍历后两个
                for (let i = point; i < <%=dicValueList.size()%>; i++) {
                    //如果是当前阶段
                    if (i == index) {
                        //红叉-----------------------------
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                        $("#" + i).css("color", "#FF0000");
                        //如果不是当前阶段
                    } else {
                        //黑叉----------------------------
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                        $("#" + i).css("color", "#000000");
                    }
                }
                //如果当前阶段的可能性不为0 前7个绿圈，绿色标记，黑圈，后两个一定是黑叉
            } else {
                //遍历前7个 绿圈，绿色标记，黑圈
                for (let i = 0; i < point; i++) {
                    //如果是当前阶段
                    if (i == index) {
                        //绿色标记--------------------------
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-map-marker mystage");
                        $("#" + i).css("color", "#90F790");
                        //如果小于当前阶段
                    } else if (i < index) {
                        //绿圈------------------------------
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage");
                        $("#" + i).css("color", "#90F790");
                        //如果大于当前阶段
                    } else {
                        //黑圈-------------------------------
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-record mystage");
                        $("#" + i).css("color", "#000000");
                    }
                }
                //遍历后两个
                for (let i = point; i < <%=dicValueList.size()%>; i++) {
                    //黑叉----------------------------
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                    $("#" + i).css("color", "#000000");
                }
            }
        }

        // 展示备注信息
        function showRemarkList() {
            $.ajax({
                url: "workbench/transaction/getRemarkListByTranId.do",
                data: {
                    "tranId": "${tran.id}"
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
                        html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;" id="s' + n.id + '">' + (n.editFlag === "0" ? n.createTime : n.editTime) + ' 由' + (n.editFlag === "0" ? n.createBy : n.editBy) + '</small>';
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
    </script>

</head>
<body>
<!-- 修改交易备注的模态窗口 -->
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
        <h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/getUserListAndTran.do?id=' + '${tran.id}';">
            <span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%
        Tran tran = (Tran) request.getAttribute("tran");
        String currentStage = tran.getStage();
        String currentPossibility = pMap.get(currentStage);
        if ("0".equals(currentPossibility)) {
            for (int i = 0; i < dicValueList.size(); i++) {
                DicValue dicValue = dicValueList.get(i);
                String stage = dicValue.getValue();
                String possibility = pMap.get(stage);
                if ("0".equals(possibility)) {
                    if (stage.equals(currentStage)) {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #FF0000;"></span>
    -----------
    <%
    } else {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
    -----------
    <%
        }

    } else {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
    -----------
    <%

            }
        }
    } else {
        int index = 0;
        for (int i = 0; i < dicValueList.size(); i++) {
            DicValue dicValue = dicValueList.get(i);
            String stage = dicValue.getValue();
            if (stage.equals(currentStage)) {
                index = i;
                break;
            }
        }
        for (int i = 0; i < dicValueList.size(); i++) {
            DicValue dicValue = dicValueList.get(i);
            String stage = dicValue.getValue();
            String possibility = pMap.get(stage);
            if ("0".equals(possibility)) {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
    -----------
    <%
    } else {
        if (i == index) {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-map-marker mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
    -----------
    <%

    } else if (i < index) {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-ok-circle mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #90F790;"></span>
    -----------
    <%
    } else {
    %>
    <span id="<%=i%>" onclick="changeStage('<%=stage%>', '<%=i%>')" class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>" style="color: #000000;"></span>
    -----------
    <%
                    }
                }
            }
        }
    %>
    <%--        <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--              data-content="资质审查" style="color: #90F790;"></span>--%>
    <%--        -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="需求分析" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="价值建议" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="确定决策者" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="提案/报价" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="谈判/复审"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="成交"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="丢失的线索"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="因竞争丢失关闭"></span>--%>
    <%--    -------------%>
    <span class="closingDate">${tran.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b
                id="possibility">&nbsp;${tran.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${tran.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b
                id="editBy">${tran.editBy}&nbsp;&nbsp;</b><small id="editTime"
                                                                 style="font-size: 10px; color: gray;">${tran.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${tran.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${tran.nextContactTime}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
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

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="tranHistoryBody">
                <%--                <tr>--%>
                <%--                    <td>资质审查</td>--%>
                <%--                    <td>5,000</td>--%>
                <%--                    <td>10</td>--%>
                <%--                    <td>2017-02-07</td>--%>
                <%--                    <td>2016-10-10 10:10:10</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                </tr>--%>
                <%--                <tr>--%>
                <%--                    <td>需求分析</td>--%>
                <%--                    <td>5,000</td>--%>
                <%--                    <td>20</td>--%>
                <%--                    <td>2017-02-07</td>--%>
                <%--                    <td>2016-10-20 10:10:10</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                </tr>--%>
                <%--                <tr>--%>
                <%--                    <td>谈判/复审</td>--%>
                <%--                    <td>5,000</td>--%>
                <%--                    <td>90</td>--%>
                <%--                    <td>2017-02-07</td>--%>
                <%--                    <td>2017-02-09 10:10:10</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>