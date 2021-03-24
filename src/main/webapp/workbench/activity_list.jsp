<%
  String basePath = request.getScheme() + "://" +
          request.getServerName() + ":" +
          request.getServerPort() +
          request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <base href="<%=basePath%>">
  <meta charset="UTF-8">
  <link href="jquery/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
  <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
        rel="stylesheet"/>
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
  <%--<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>--%>
  <script type="text/javascript">
      $.fn.datetimepicker.dates['zh-CN'] = {
          days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
          daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
          daysMin: ["日", "一", "二", "三", "四", "五", "六", "日"],
          months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
          monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
          today: "今天",
          suffix: [],
          meridiem: ["上午", "下午"]
      };
  </script>
  <%--分页--%>
  <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
  <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
  <%--<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>--%>
  <script type="text/javascript">
      var rsc_bs_pag = {
          go_to_page_title: 'Go to page',
          rows_per_page_title: 'Rows per page',
          current_page_label: 'Page',
          current_page_abbr_label: 'p.',
          total_pages_label: 'of',
          total_pages_abbr_label: '/',
          total_rows_label: 'of',
          rows_info_records: 'records',
          go_top_text: '首页',
          go_prev_text: '上一页',
          go_next_text: '下一页',
          go_last_text: '末页'
      };
  </script>
  <script type="text/javascript">
      $(function () {

          //点击市场活动，同时显示所有市场活动
          activityList(1, 2);

          //点击创建活动按钮
          $("#createActivity").click(function () {

              //为日期文本框添加日历，使用bootstrap的日历插件
              $(".time").datetimepicker({
                  minView: "month",
                  language: 'zh-CN',
                  format: 'yyyy-mm-dd',
                  autoclose: true,
                  todayBtn: true,
                  pickerPosition: "bottom-left"
              });

              //先清所有有内容
              // $("#reset")[0].reset();

              //更新下拉列表中内容
              $.ajax({
                  url: "user/selectUser.do",
                  type: "get",
                  dataType: "json",
                  success(data) {
                      // alert(data);
                      var html = "";
                      $.each(data, function (i, n) {
                          html += "<option value='" + n.id + "'>" + n.name + "</option>";
                      })
                      $("#create-marketActivityOwner").html(html);
                  }
              })
          })

          //点击创建活动的保存按钮
          $("#saveBtn").click(function () {
              $.ajax({
                  url: "activity/addActivity.do",
                  type: "post",
                  data: {
                      "owner": $.trim($("#create-marketActivityOwner").val()),
                      "name": $.trim($("#create-marketActivityName").val()),
                      "startDate": $.trim($("#create-startTime").val()),
                      "endDate": $.trim($("#create-endTime").val()),
                      "cost": $.trim($("#create-cost").val()),
                      "description": $.trim($("#create-describe").val())
                  },
                  dataType: "json",
                  success(data) {
                      if (data.success) {
                          // alert("活动添加成功");
                          //创建活动之后，立即刷新市场活动列表，跳转到首页，并显示用户设定的记录数
                          activityList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                      } else {
                          alert("活动添加失败")
                      }
                  }
              })
          })

          //查询按钮
          $("#queryActivity").click(function () {
              //将隐藏域中数据加入到条件输入框
              $("#hidden-name").val($.trim($("#name").val()));
              $("#hidden-owner").val($.trim($("#owner").val()));
              $("#hidden-startDate").val($.trim($("#startTime").val()));
              $("#hidden-endDate").val($.trim($("#endTime").val()));
              activityList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
          })

          //全选
          $("#qx").click(function () {
              $("input[name=xz]").prop("checked", this.checked);
          })

          //以下这种做法是不行的， 因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
          /*$("input[name=xz]").click(function () {
              alert(123);
          })*/

          //单选
          $("#dataBody").on("click", $("input[name=xz]"), function () {
              $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);
          })

          //删除市场活动操作
          $("#delActivity").click(function () {
              var $xz = $("input[name=xz]:checked");
              if ($xz.length == 0) {
                  alert("请选择所要删除的记录");
              } else {
                  //提示用户是否删除
                  if (confirm("是否删除所选记录")) {
                      var param = "";
                      //拼接参数
                      for (var i = 0; i < $xz.length; i++) {
                          param += "id=" + $($xz[i]).val();
                          if (i < $xz.length - 1) {
                              param += "&";
                          }
                      }
                      //alert(param)
                      $.ajax({
                          url: "activity/delActivity.do",
                          type: "post",
                          data: param,
                          dataType: "json",
                          success(data) {
                              if (data.success) {
                                  alert("活动删除成功");
                                  //删除活动之后，立即刷新市场活动列表，跳转到首页，并维持用户每页显示记录数
                                  activityList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                              } else {
                                  alert("活动删除失败")
                              }
                          }
                      })
                  }

              }

          })

          //点击修改市场活动按钮
          $("#changeActivity").click(function () {
              var $xz = $("input[name=xz]:checked");		//获取到所有被选中的复选框
              if ($xz.length == 0) alert("请选择所要修改的记录");
              else if ($xz.length > 1) alert("一次只能修改单条记录");
              else {
                  var id = $xz.val();
                  // alert(id);
                  $.ajax({
                      url: "activity/editActivity.do",
                      type: "post",
                      data: {
                          "id": id
                      },
                      dataType: "json",
                      success(data) {
                          //前端所需要的数据
                          //1、目标activity数据	2、用户列表
                          // alert(data);
                          //为修改模态窗口添加所有者信息
                          var html = "";
                          $.each(data.userList, function (i, n) {
                              html += "<option value='" + n.id + "'>" + n.name + "</option>"
                          })
                          $("#edit-marketActivityOwner").html(html);
                          //为修改模态窗口添加其他信息
                          $("#edit-id").val(data.activity.id);
                          $("#edit-marketActivityOwner").val(data.activity.owner);
                          $("#edit-marketActivityName").val(data.activity.name);
                          $("#edit-startTime").val(data.activity.startDate);
                          $("#edit-endTime").val(data.activity.endDate);
                          $("#edit-cost").val(data.activity.cost);
                          $("#edit-describe").val(data.activity.description);

                          //显示修改模态窗口
                          $("#editActivityModal").modal("show");
                      }
                  })
              }
          })

          //点击修改模态窗口的保存按钮
          $("#saveActivity").click(function () {
              $.ajax({
                  url: "activity/modifyActivity.do",
                  type: "post",
                  data: {
                      "id": $.trim($("#edit-id").val()),
                      "owner": $.trim($("#edit-marketActivityOwner").val()),
                      "name": $.trim($("#edit-marketActivityName").val()),
                      "startDate": $.trim($("#edit-startTime").val()),
                      "endDate": $.trim($("#edit-endTime").val()),
                      "cost": $.trim($("#edit-cost").val()),
                      "description": $.trim($("#edit-describe").val())
                  },
                  dataType: "json",
                  success(data) {
                      if (data.success) {
                          // alert("活动信息修改成功");
                          //活动修改后仍停留该页，并且维持用户每页显示记录数
                          activityList($("#activityPage").bs_pagination('getOption', 'currentPage')
                              , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                      } else alert("活动信息修改失败");
                  }
              })
          })
      });

      //查询市场活动列表
      function activityList(pageNo, pageSize) {
          //alert(pageNo);
          //取消勾选
          $("#qx").prop("checked", false);
          //通过隐藏域为条件框赋值
          $("#name").val($.trim($("#hidden-name").val()));
          $("#owner").val($.trim($("#hidden-owner").val()));
          $("#startTime").val($.trim($("#hidden-startDate").val()));
          $("#endTime").val($.trim($("#hidden-endDate").val()));

          $.ajax({
              url: "activity/queryActivity.do",
              type: "post",
              data: {
                  "pageNo": pageNo,
                  "pageSize": pageSize,
                  "name": $.trim($("#name").val()),
                  "owner": $.trim($("#owner").val()),
                  "startDate": $.trim($("#startTime").val()),
                  "endDate": $.trim($("#endTime").val())
              },
              dataType: "json",
              success(data) {
                  // alert("查询成功");
                  var html = "";
                  $.each(data.activityList, function (i, n) {
                      html += '<tr class="active">';
                      html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>'
                      html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'activity/activityDetail.do?id=' + n.id + '\';">' + n.name + '</a></td>'
                      html += '<td>' + n.owner + '</td>'
                      html += '<td>' + n.startDate + '</td>'
                      html += '<td>' + n.endDate + '</td>'
                      html += '</tr>';
                  })
                  $("#dataBody").html(html);

                  //计算总页数
                  var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                  $("#activityPage").bs_pagination({
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

                      onChangePage: function (event, data) {
                          activityList(data.currentPage, data.rowsPerPage);
                      }
                  });
              }
          })
      }
  </script>
</head>
<body>

<%--为查询框设置隐藏域--%>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 85%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
      </div>
      <div class="modal-body">
        
        <form class="form-horizontal" id="reset" role="form">
          
          <div class="form-group">
            <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="create-marketActivityOwner">
              </select>
            </div>
            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-marketActivityName">
            </div>
          </div>
          
          <div class="form-group">
            <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control time" id="create-startTime">
            </div>
            <label for="create-endTime" class="col-sm-2 control-label time">结束日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control time" id="create-endTime">
            </div>
          </div>
          <div class="form-group">
            
            <label for="create-cost" class="col-sm-2 control-label">成本</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="create-cost">
            </div>
          </div>
          <div class="form-group">
            <label for="create-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="create-describe"></textarea>
            </div>
          </div>
        
        </form>
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" id="saveBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
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
          
          <input type="hidden" id="edit-id">
          
          <div class="form-group">
            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <select class="form-control" id="edit-marketActivityOwner">
              
              </select>
            </div>
            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                    style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-marketActivityName">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-startTime">
            </div>
            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-endTime">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
            <div class="col-sm-10" style="width: 300px;">
              <input type="text" class="form-control" id="edit-cost">
            </div>
          </div>
          
          <div class="form-group">
            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 81%;">
              <textarea class="form-control" rows="3" id="edit-describe"></textarea>
            </div>
          </div>
        
        </form>
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" id="saveActivity" class="btn btn-primary" data-dismiss="modal">更新</button>
      </div>
    </div>
  </div>
</div>


<div>
  <div style="position: relative; left: 10px; top: -10px;">
    <div class="page-header">
      <h3>市场活动列表</h3>
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
            <input class="form-control" id="name" type="text">
          </div>
        </div>
        
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">所有者</div>
            <input class="form-control" id="owner" type="text">
          </div>
        </div>
        
        
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">开始日期</div>
            <input class="form-control" type="text" id="startTime"/>
          </div>
        </div>
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-addon">结束日期</div>
            <input class="form-control" type="text" id="endTime">
          </div>
        </div>
        
        <button type="button" id="queryActivity" class="btn btn-default">查询</button>
      
      </form>
    </div>
    
    <div class="btn-toolbar" role="toolbar"
         style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
      <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" id="createActivity" class="btn btn-primary" data-toggle="modal"
                data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button type="button" id="changeActivity" class="btn btn-default"><span
                class="glyphicon glyphicon-pencil"></span> 修改
        </button>
        <button type="button" id="delActivity" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
      </div>
    
    </div>
    <div style="position: relative;top: 10px;">
      <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
          <td><input type="checkbox" id="qx"/></td>
          <td>名称</td>
          <td>所有者</td>
          <td>开始日期</td>
          <td>结束日期</td>
        </tr>
        </thead>
        <tbody id="dataBody">
        </tbody>
      </table>
    </div>
    
    <div style="height: 50px; position: relative;top: 30px;">
      <div id="activityPage"></div>
    </div>
  
  </div>
</div>

</body>
</html>