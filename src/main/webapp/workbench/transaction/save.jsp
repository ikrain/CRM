<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String basePath = request.getScheme() + "://" +
          request.getServerName() + ":" +
          request.getServerPort() +
          request.getContextPath() + "/";
  Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
  Set<String> set = pMap.keySet();
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <base href="<%=basePath%>">
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
  <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
  <script type="text/javascript">
      var json = {
          <%
              for(String key:set){
                  String value = pMap.get(key);
          %>
          "<%=key%>":<%=value%>,
          <%
              }
          %>
      }
      $(function () {
          //为日期文本框添加日历，使用bootstrap的日历插件
          $(".time").datetimepicker({
              minView: "month",
              language: 'zh-CN',
              format: 'yyyy-mm-dd',
              autoclose: true,
              todayBtn: true,
              pickerPosition: "bottom-left"
          });

          $(".time2").datetimepicker({
              minView: "month",
              language: 'zh-CN',
              format: 'yyyy-mm-dd',
              autoclose: true,
              todayBtn: true,
              pickerPosition: "top-left"
          });

          //客户名称自动补全
          $("#create-customerName").typeahead({
              source: function (query, process) {
                  $.get(
                      "transaction/getCustomerName.do",
                      {"name": query},
                      function (data) {
                          //alert(data);
                          process(data);
                      },
                      "json"
                  );
              },
              delay: 500
          });

          //跳转到该页面后，更新用户下拉列表中内容
          $.ajax({
              url: "transaction/selectUser.do",
              type: "get",
              dataType: "json",
              success(data) {
                  // alert(data);
                  var html = "";
                  $.each(data, function (i, n) {
                      html += "<option value='" + n.id + "'>" + n.name + "</option>";
                  })
                  $("#create-transactionOwner").html(html);
              }
          })

          $("#create-stage").change(function () {
              var stage = $("#create-stage").val();
              var possibility = json[stage];
              $("#create-possibility").val(possibility);
          })

          $("#saveBtn").click(function () {
              $("#tranForm").submit();
          })

      })
  </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
  <div class="modal-dialog" role="document" style="width: 80%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title">查找市场活动</h4>
      </div>
      <div class="modal-body">
        <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
          <form class="form-inline" role="form">
            <div class="form-group has-feedback">
              <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
              <span class="glyphicon glyphicon-search form-control-feedback"></span>
            </div>
          </form>
        </div>
        <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
          <thead>
          <tr style="color: #B3B3B3;">
            <td></td>
            <td>名称</td>
            <td>开始日期</td>
            <td>结束日期</td>
            <td>所有者</td>
          </tr>
          </thead>
          <tbody>
          <tr>
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
          </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
  <div class="modal-dialog" role="document" style="width: 80%;">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </button>
        <h4 class="modal-title">查找联系人</h4>
      </div>
      <div class="modal-body">
        <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
          <form class="form-inline" role="form">
            <div class="form-group has-feedback">
              <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
              <span class="glyphicon glyphicon-search form-control-feedback"></span>
            </div>
          </form>
        </div>
        <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
          <thead>
          <tr style="color: #B3B3B3;">
            <td></td>
            <td>名称</td>
            <td>邮箱</td>
            <td>手机</td>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td><input type="radio" name="activity"/></td>
            <td>李四</td>
            <td>lisi@bjpowernode.com</td>
            <td>12345678901</td>
          </tr>
          <tr>
            <td><input type="radio" name="activity"/></td>
            <td>李四</td>
            <td>lisi@bjpowernode.com</td>
            <td>12345678901</td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>


<div style="position:  relative; left: 30px;">
  <h3>创建交易</h3>
  <div style="position: relative; top: -40px; left: 70%;">
    <button type="button" id="saveBtn" class="btn btn-primary">保存</button>
    <button type="button" class="btn btn-default">取消</button>
  </div>
  <hr style="position: relative; top: -40px;">
</div>
<form action="transaction/addOneTransaction.do" class="form-horizontal" id="tranForm" role="form"
      style="position: relative; top: -30px;">
  <div class="form-group">
    <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
            style="font-size: 15px; color: red;">*</span></label>
    <div class="col-sm-10" style="width: 300px;">
      <select class="form-control" id="create-transactionOwner" name="owner">
        <%--<option>zhangsan</option>
        <option>lisi</option>
        <option>wangwu</option>--%>
      </select>
    </div>
    <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" id="create-amountOfMoney" name="money">
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-transactionName" class="col-sm-2 control-label">名称<span
            style="font-size: 15px; color: red;">*</span></label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" id="create-transactionName" name="name">
    </div>
    <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
            style="font-size: 15px; color: red;">*</span></label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control time" id="create-expectedClosingDate" name="expectedDate">
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
            style="font-size: 15px; color: red;">*</span></label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" name="customerId" id="create-customerName"
             placeholder="支持自动补全，输入客户不存在则新建">
    </div>
    <label for="create-stage" class="col-sm-2 control-label">阶段<span
            style="font-size: 15px; color: red;">*</span></label>
    <div class="col-sm-10" style="width: 300px;">
      <select class="form-control" id="create-stage" name="stage">
        <option></option>
        <%--<option>资质审查</option>
        <option>需求分析</option>
        <option>价值建议</option>
        <option>确定决策者</option>
        <option>提案/报价</option>
        <option>谈判/复审</option>
        <option>成交</option>
        <option>丢失的线索</option>
        <option>因竞争丢失关闭</option>--%>
        <c:forEach items="${stage}" var="s">
          <option value="${s.value}">${s.text}</option>
        </c:forEach>
      </select>
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
    <div class="col-sm-10" style="width: 300px;">
      <select class="form-control" id="create-transactionType" name="type">
        <option></option>
        <%--<option>已有业务</option>
        <option>新业务</option>--%>
        <c:forEach items="${transactionType}" var="t">
          <option value="${t.value}">${t.text}</option>
        </c:forEach>
      </select>
    </div>
    <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" id="create-possibility" name="possibility">
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
    <div class="col-sm-10" style="width: 300px;">
      <select class="form-control" id="create-clueSource" name="source">
        <option></option>
        <%--<option>广告</option>
        <option>推销电话</option>
        <option>员工介绍</option>
        <option>外部介绍</option>
        <option>在线商场</option>
        <option>合作伙伴</option>
        <option>公开媒介</option>
        <option>销售邮件</option>
        <option>合作伙伴研讨会</option>
        <option>内部研讨会</option>
        <option>交易会</option>
        <option>web下载</option>
        <option>web调研</option>
        <option>聊天</option>--%>
        <c:forEach items="${source}" var="s">
          <option value="${s.value}">${s.text}</option>
        </c:forEach>
      </select>
    </div>
    <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                       data-toggle="modal"
                                                                                       data-target="#findMarketActivity"><span
            class="glyphicon glyphicon-search"></span></a></label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" id="create-activitySrc" value="发传单a" name="activityId">
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                        data-toggle="modal"
                                                                                        data-target="#findContacts"><span
            class="glyphicon glyphicon-search"></span></a></label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control" id="create-contactsName" value="马云" name="contactsId">
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-describe" class="col-sm-2 control-label">描述</label>
    <div class="col-sm-10" style="width: 70%;">
      <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
    <div class="col-sm-10" style="width: 70%;">
      <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
    </div>
  </div>
  
  <div class="form-group">
    <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
    <div class="col-sm-10" style="width: 300px;">
      <input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
    </div>
  </div>

</form>
</body>
</html>