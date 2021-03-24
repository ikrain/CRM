<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/bootstrap/js/bootstrap.min.js"></script>


  <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
        rel="stylesheet"/>
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
  <script type="text/javascript">
      $(function () {

          //为日期文本框添加日历，使用bootstrap的日历插件
          $("#expectedClosingDate").datetimepicker({
              minView: "month",
              language: 'zh-CN',
              format: 'yyyy-mm-dd',
              autoclose: true,
              todayBtn: true,
              pickerPosition: "bottom-left"
          });

          $("#isCreateTransaction").click(function () {
              if (this.checked) {
                  $("#create-transaction2").show(200);
              } else {
                  $("#create-transaction2").hide(200);
              }
          });

          $(window).keydown(function (event) {
              if (event.keyCode == 13) {
                  var name = $("#acName").val();
                  $.ajax({
                      url: "clue/queryAllActivityByName.do",
                      type: "post",
                      data: {
                          "name": name
                      },
                      dataType: "json",
                      success(data) {
                          // alert("查询成功");
                          var html = "";
                          $.each(data, function (i, n) {
                              html += '<tr>';
                              html += '<td><input type="radio" name="dx" value="' + n.id + '"/></td>';
                              html += '<td id="' + n.id + '">' + n.name + '</td>';
                              html += '<td>' + n.startDate + '</td>';
                              html += '<td>' + n.endDate + '</td>';
                              html += '<td>' + n.owner + '</td>';
                              html += '</tr>';
                          })
                          $("#activityContent").html(html);
                      }
                  })
                  return false;
              }
          })

          $("#determineBtn").click(function () {
              var $dx = $("input[name=dx]:checked");
              var id = $dx.val();
              var name = $("#" + id).html();
              $("#activityName").val(name);
              $("#activityId").val(id)
              // alert(id)
              // alert(name)
          })

          $("#convertBtn").click(function () {
              //转换的同时创建交易
              if ($("#isCreateTransaction").prop("checked")) {
                  $("#tranForm").submit();
              } else {
                  //无需创建交易，只需传入clue的id即可
                  window.location.href = "clue/convertClue.do?clueId=${param.id}";
              }

          })

      });
  </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
  <div class="modal-dialog" role="document" style="width: 90%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title">搜索市场活动</h4>
      </div>
      <div class="modal-body">
        <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
          <form class="form-inline" role="form">
            <div class="form-group has-feedback">
              <input type="text" id="acName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
              <span class="glyphicon glyphicon-search form-control-feedback"></span>
            </div>
          </form>
        </div>
        <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
          <thead>
          <tr style="color: #B3B3B3;">
            <td></td>
            <td>名称</td>
            <td>开始日期</td>
            <td>结束日期</td>
            <td>所有者</td>
            <td></td>
          </tr>
          </thead>
          <tbody id="activityContent">
          <%--<tr>
              <td><input type="radio" name="activity"/></td>
              <td>发传单</td>
              <td>2020-10-10</td>
              <td>2020-10-20</td>
              <td>zhangsan</td>
          </tr>
          <tr>
              <td><input type="radio" name="activity"/></td>
              <td>发传单</td>
              <td>2020-10-10</td>
              <td>2020-10-20</td>
              <td>zhangsan</td>
          </tr>--%>
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        <button type="button" id="determineBtn" class="btn btn-primary" data-dismiss="modal">确定</button>
      </div>
    </div>
  </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
  <h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
  新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
  新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
  <input type="checkbox" id="isCreateTransaction"/>
  为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

  <form id="tranForm" action="clue/convertClue.do" method="post">

    <input type="hidden" value="t" name="flag">

    <input type="hidden" name="activityId" id="activityId">

    <input type="hidden" value="${param.id}" name="clueId">

    <div class="form-group" style="width: 400px; position: relative; left: 20px;">
      <label for="amountOfMoney">金额</label>
      <input type="text" class="form-control" id="amountOfMoney" name="money">
    </div>
    <div class="form-group" style="width: 400px;position: relative; left: 20px;">
      <label for="tradeName">交易名称</label>
      <input type="text" class="form-control" id="tradeName" name="name">
    </div>
    <div class="form-group" style="width: 400px;position: relative; left: 20px;">
      <label for="expectedClosingDate">预计成交日期</label>
      <input type="text" class="form-control" id="expectedClosingDate" name="expectedDate">
    </div>
    <div class="form-group" style="width: 400px;position: relative; left: 20px;">
      <label for="stage">阶段</label>
      <select id="stage" class="form-control" name="stage">
        <option></option>
        <c:forEach items="${stage}" var="s">
          <option>${s.value}</option>
        </c:forEach>
      </select>
    </div>
    <div class="form-group" style="width: 400px;position: relative; left: 20px;">
      <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal"
                                                    data-target="#searchActivityModal"
                                                    style="text-decoration: none;"><span
              class="glyphicon glyphicon-search" id="searchActivity"></span></a></label>
      <input type="text" name="source" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
    </div>
  </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
  记录的所有者：<br>
  <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
  <input class="btn btn-primary" id="convertBtn" type="button" value="转换">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>