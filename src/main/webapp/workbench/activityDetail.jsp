<%
  String basePath = request.getScheme() + "://" +
          request.getServerName() + ":" +
          request.getServerPort() +
          request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <base href="<%=basePath%>">
  <meta charset="UTF-8">
  <link href="jquery/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap/js/bootstrap.min.js"></script>
  <script type="text/javascript">

      //默认情况下取消和保存按钮是隐藏的
      var cancelAndSaveBtnDefault = true;

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

          //跳转到活动详细信息页面后，自动发送ajax请求，获取该活动的备注信息
          showActivityRemark();

          //为备注添加修改和删除图标动画
          $("#remarkBody").on("mouseover", ".remarkDiv", function () {
              $(this).children("div").children("div").show();
          })
          $("#remarkBody").on("mouseout", ".remarkDiv", function () {
              $(this).children("div").children("div").hide();
          });

          // 在详细删除市场活动
          $("#delDetailActivity").click(function () {
              var activityId = 'id=' + $("#detailActivityId").val()
              //alert(activityId)
              if (confirm("是否确定删除？")) {
                  $.ajax({
                      url: 'activity/delActivity.do',
                      data: activityId,
                      type: 'post',
                      dataType: 'json',
                      success(data) {
                          if (data.success) {
                              alert('删除成功')
                              window.location.href = "workbench/activity_list.jsp"
                          } else {
                              alert('删除失败')
                          }
                      }
                  })
              }
          })

          //在详细信息页面编辑市场该活动
          $("#editDetailActivity").click(function () {

          })

          //为保存按钮注册监听
          $("#updateRemarkBtn").click(function () {
              var remarkId = $("#remarkId").val();
              var noteContent = $.trim($("#noteContent").val());
              $.ajax({
                  url: 'activityRemark/editActivityRemark.do',
                  data: {
                      "id": remarkId,
                      "noteContent": noteContent
                  },
                  type: "get",
                  dataType: "json",
                  success(data) {
                      if (data.success) {
                          // alert("修改成功")
                          //刷新所修改该的记录
                          $("#a" + remarkId).html(data.noteContent);
                          $("#b" + remarkId).html(data.currentTime + "由" + data.editBy);
                          $("#editRemarkModal").modal("hide");
                      } else alert("修改失败")
                  }
              })
          })

          //添加信息的备注信息
          $("#newRemarkBtn").click(function () {
              var remark = $("#remark").val();
              $.ajax({
                  url: 'activityRemark/addActivityRemark.do',
                  data: {
                      "remark": remark,
                      "activityId": "${activity.id}"
                  },
                  type: "get",
                  dataType: "json",
                  success(data) {
                      var html = "";
                      if (data.success) {
                          //alert("增加成功")
                          //在页面中加入新增备注信息
                          html += '<div id="' + data.id + '" class="remarkDiv" style="height: 60px;">';
                          html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
                          html += '<div style="position: relative; top: -40px; left: 40px;" >';
                          html += ' <h5 id="a' + data.id + '">' + data.noteContent + '</h5>';
                          html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="b' + data.id + '"> ' + (data.createTime) + ' 由' + (data.createBy) + '</small>';
                          html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                          html += '<a class="myHref" onclick="editRemark(\'' + data.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                          html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                          html += '<a class="myHref" onclick="deleteRemark(\'' + data.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                          html += '</div></div></div>';
                          $("#remarkDiv").before(html);
                          $("#remark").val("");           //将注释文本框置空
                      } else alert("增加失败")
                  }
              })
          })
      });

      //跳转到活动详细信息页面后，自动发送ajax请求，获取该活动的备注信息
      function showActivityRemark() {
          $.ajax({
              url: 'activityRemark/getActivityRemark.do',
              data: {
                  "activityId": "${activity.id}"
              },
              type: "get",
              dataType: "json",
              success(data) {
                  //获取到一个备注结合
                  var html = "";
                  $.each(data, function (i, n) {
                      html += '<div id="' + n.id + '" class="remarkDiv" style="height: 60px;">';
                      html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
                      html += '<div style="position: relative; top: -40px; left: 40px;" >';
                      html += ' <h5 id="a' + n.id + '">' + n.noteContent + '</h5>';
                      html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="b' + n.id + '"> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>';
                      html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                      html += '<a class="myHref" onclick="editRemark(\'' + n.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                      html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                      html += '<a class="myHref" onclick="deleteRemark(\'' + n.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                      html += '</div></div></div>';
                  })
                  $("#remarkDiv").before(html);
              }
          })
      }

      //修改备注信息
      function editRemark(id) {
          // alert(id);
          $("#remarkId").val(id);
          var noteContext = $("#a" + id).html();
          $("#noteContent").val(noteContext);
          $("#editRemarkModal").modal("show");
      }

      //删除备注信息
      function deleteRemark(id) {
          if (confirm("是否确定删除该条备注记录")) {
              $.ajax({
                  url: 'activityRemark/delActivityRemark.do',
                  data: {
                      "id": id
                  },
                  type: "get",
                  dataType: "json",
                  success(data) {
                      if (data.success) {
                          // alert("删除成功")
                          $("#" + id).remove(); //将已删除的备注从页面移除
                      } else alert("删除失败")
                  }
              })
          }
      }
  
  </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
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
            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
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

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 85%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
      </div>
      <div class="modal-body">
        
        <form class="form-horizontal" role="form">
          
          <div class="form-group">
            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-marketActivityOwner">
                <option>zhangsan</option>
                <option>lisi</option>
                <option>wangwu</option>
              </select>
            </div>
            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
            </div>
            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-cost" value="5,000">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
            </div>
          </div>
        
        </form>
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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
    <h3>市场活动——${activity.name}<small>&nbsp;&nbsp;${activity.startDate} ~ ${activity.endDate}</small></h3>
  </div>
  <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
    <button type="button" id="editDetailActivity" class="btn btn-default" data-toggle="modal"
            data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑
    </button>
    <button type="button" id="delDetailActivity" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span>
      删除
    </button>
  </div>
</div>

<input type="hidden" id="detailActivityId" value="${activity.id}">

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
  <div style="position: relative; left: 40px; height: 30px;">
    <div style="width: 300px; color: gray;">所有者</div>
    <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
    <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
    <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
    <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
    <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
  </div>
  
  <div style="position: relative; left: 40px; height: 30px; top: 10px;">
    <div style="width: 300px; color: gray;">开始日期</div>
    <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
    <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
    <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
    <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
    <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
  </div>
  <div style="position: relative; left: 40px; height: 30px; top: 20px;">
    <div style="width: 300px; color: gray;">成本</div>
    <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
    <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
  </div>
  <div style="position: relative; left: 40px; height: 30px; top: 30px;">
    <div style="width: 300px; color: gray;">创建者</div>
    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small
            style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
    <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
  </div>
  <div style="position: relative; left: 40px; height: 30px; top: 40px;">
    <div style="width: 300px; color: gray;">修改者</div>
    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small
            style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
    <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
  </div>
  <div style="position: relative; left: 40px; height: 30px; top: 50px;">
    <div style="width: 300px; color: gray;">描述</div>
    <div style="width: 630px;position: relative; left: 200px; top: -20px;">
      <b>
        ${activity.description}
      </b>
    </div>
    <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
  </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
  <div class="page-header">
    <h4>备注</h4>
  </div>
  
  <%--通过ajax请求获取备注信息，操作dom对象加入到这里--%>
  
  <!-- 备注 -->
  <%--<div class="remarkDiv" style="height: 60px;">
      <img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">
      <div style="position: relative; top: -40px; left: 40px;" >
          <h5>呵呵！</h5>
          <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
          <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
              <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
          </div>
      </div>
  </div>--%>
  
  <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
    <form role="form" style="position: relative;top: 10px; left: 10px;">
      <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                placeholder="添加备注..."></textarea>
      <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
        <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
        <button type="button" id="newRemarkBtn" class="btn btn-primary">保存</button>
      </p>
    </form>
  </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>