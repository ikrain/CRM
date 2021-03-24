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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="jquery/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="static/css/self.css">
  <title>CRM-登录</title>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      CRM客户关系管理系统
      <span>©2020 CC</span>
    </div>
  </div>
  <div class="row">
    <div class="col-md-8">
      <img src="static/images/IMG_7114.JPG" alt="我是登录页面图片">
    </div>
    <div class="col-md-4">
      <div class="log-content">
        <div class="page-header" style="width: 350px;">
          <h1 style="color: black;">登录</h1>
        </div>
        <form action="#" class="form-horizontal" role="form">
          <input type="text" id="userInput" class="form-control" placeholder="用户名">
          <input type="password" id="pwdInput" class="form-control" placeholder="密码">
          <div style="position: fixed;">
            <span id="msg" style="color: red;"></span>
          </div>
          <button type="button" id="btn" class="btn btn-primary">登录</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="jquery/jquery-1.11.1-min.js"></script>
<%--<script src="jquery/bootstrap/js/popper.min.js"></script>--%>
<script src="jquery/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(function () {
        // 页面初始化后清空文本框
        $("#userInput").val("");
        $("#pwdInput").val("");
        // 页面初始化后，输入框获取焦距
        $("#userInput").focus();
        //为按钮添加监听
        $("#btn").click(function () {
            login();
        })
        //设置键盘回车事件
        $(window).keydown(function (event) {
            if (event.keyCode == 13) {
                login();
            }
        })
    })

    function login() {
        var user = $("#userInput").val();
        var pwd = $("#pwdInput").val();
        if (user == "" || pwd == "") {
            $("#msg").html("用户名和密码不能为空");
            return false;
        }
        // alert("登录成功");
        // ajax发送请求
        $.ajax({
            url: "user/login.do",
            type: "post",
            data: {
                "user": user,
                "pwd": pwd
            },
            dataType: "json",
            success(res) {
                if (res.success) {
                    // alert("登录成功");
                    window.location.href = "workbench/index.jsp";
                } else {
                    $("#msg").html(res.msg);
                }

            }
        })
    }
</script>
</body>
</html>
