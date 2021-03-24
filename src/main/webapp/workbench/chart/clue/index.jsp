<%
  String basePath = request.getScheme() + "://" +
          request.getServerName() + ":" +
          request.getServerPort() +
          request.getContextPath() + "/";

/*
需求：

根据交易表中的不同的阶段的数量进行一个统计，最终形成一个漏斗图（倒三角）

将统计出来的阶段的数量比较多的，往上面排列
将统计出来的阶段的数量比较少的，往下面排列

例如：
01资质审查  10条
02需求分析  85条
03价值建议  3条
...
07成交      100

sql:
按照阶段进行分组

resultType="map"

select

stage,count(*)

from tbl_tran

group by stage
*/
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <base href="<%=basePath%>">
  <title>线索数据统计图</title>
  <script type="text/javascript" src="ECharts/echarts.min.js"></script>
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript">
      $(function () {
          $.ajax({
              url: "transaction/queryTranByGroup.do",
              type: "get",
              dataType: "json",
              success(data) {
                  // 基于准备好的dom，初始化echarts实例
                  var myChart = echarts.init(document.getElementById('main'));

                  option = {
                      title: {
                          text: '线索数据统计图',
                      },
                      xAxis: {
                          type: 'category',
                          data: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
                      },
                      yAxis: {
                          type: 'value'
                      },
                      series: [{
                          data: [120, 200, 150, 80, 70, 110, 130, 120, 200, 150, 80, 70],
                          type: 'bar',
                          showBackground: true,
                          backgroundStyle: {
                              color: 'rgba(220, 220, 220, 0.8)'
                          }
                      }]
                  };


                  // 指定图表的配置项和数据
                  option1 = {
                      title: {
                          text: '交易漏斗图',
                          subtext: '展现交易统计信息'
                      },
                      series: [
                          {
                              name: '交易漏斗图',
                              type: 'funnel',
                              left: '10%',
                              top: 60,
                              //x2: 80,
                              bottom: 60,
                              width: '80%',
                              // height: {totalHeight} - y - y2,
                              min: 0,
                              max: data.total,
                              minSize: '0%',
                              maxsize: '100%',
                              sort: 'descending',
                              gap: 2,
                              label: {
                                  show: true,
                                  position: 'inside'
                              },
                              labelLine: {
                                  length: 10,
                                  lineStyle: {
                                      width: 1,
                                      type: 'solid'
                                  }
                              },
                              itemStyle: {
                                  borderColor: '#fff',
                                  borderWidth: 1
                              },
                              emphasis: {
                                  label: {
                                      fontSize: 20
                                  }
                              },
                              data: data.dataList
                              /*[
                                  {value: 60, name: '访问'},
                                  {value: 40, name: '咨询'},
                                  {value: 20, name: '订单'},
                                  {value: 80, name: '点击'},
                                  {value: 100, name: '展现'}
                              ]*/
                          }
                      ]
                  };

                  // 使用刚指定的配置项和数据显示图表。
                  myChart.setOption(option);
              }
          })

      })
  </script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="main" style="width: 1000px;height:600px;"></div>
</body>
</html>
