<#include "/include/head.ftl">
<!--[if IE 9]>         <html class="no-js lt-ie10"> <![endif]-->
<!--[if gt IE 9]><!-->
<html class="no-js">
<!--<![endif]-->
<head>
  <meta charset="utf-8">
  <title>项目结转收入|朴新教育</title>
  <meta name="robots" content="noindex, nofollow">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
  <link rel="shortcut icon" href="${ctxResource}/bootstrap/appui/img/favicon.png">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/plugins-2.6.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/main-2.6.css">
  <link id="theme-link" rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/themes/social-2.4.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/themes-2.2.css" id="theme-sign">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/style.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/px/css/newDtGrid.css">
  <script src="${ctxResource}/bootstrap/appui/js/vendor/modernizr-2.8.3.min.js"></script>
  <script src="${ctxResource}/bootstrap/appui/js/plugins/socket.io.js"></script>
  <script src="${ctxResource}/bootstrap/appui/js/vendor/jquery-2.2.0.min.js"></script>
</head>
<body>
<div id="page-wrapper" class="page-loading">
  <div id="page-container" class="header-fixed-top sidebar-visible-lg-full enable-cookies">
    <#include "/layout/left.ftl">
    <div id="main-container">
      <#include "/layout/top.ftl">
      <div id="page-content">
        <div class="content-header">
          <div class="row">
            <div class="col-sm-6">
              <div class="header-section">
                <h1>项目结转收入</h1>
              </div>
            </div>
          </div>
        </div>
        <div class="block">
          <div class="form-horizontal for-choose-horizontal">
            <div class="form-group">
              <div class="col-md-4">
                <div class="input-group input-daterange" data-date-min-view-mode="1" data-date-format="yyyy-mm">
                  <input type="text" id="start_time" class="form-control" name="beginDate" placeholder="查询开始时间">
                  <span class="input-group-addon"><i class="fa fa-chevron-right"></i></span>
                  <input type="text" id="end_time" class="form-control" name="endDate" placeholder="查询结束时间">
                </div>
              </div>
              <div class="col-md-2">
                <button class="btn btn-primary" id="search">搜索</button>
              </div>
            </div>
          </div>
          <!-- button -->
          <div class="for-operate-wrap"></div>
          <!-- dtGrid -->
          <div id="tb_main_body" class="dt-grid-container"></div>
          <div id="tb_main_tool" class="dt-grid-toolbar-container"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${ctxResource}/bootstrap/js/bootstrap.min.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/plugins-2.6.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/app-2.4.js"></script>
<!-- dtGrid -->
<script type="text/javascript" src="${ctxResource}/bootstrap/px/js/jquery.dtGrid.js"></script>
<script type="text/javascript" src="${ctxResource}/bootstrap/px/js/lang/zh-cn.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/publicUse.js"></script>
<script>
$(function(){
    var PublicData = {
        // 页面加载时要初始化的信息、绑定事件等
        init:function(){
            var getDate = new Date();
            var getYear = getDate.getFullYear();
            var getMonth = (getDate.getMonth()+1)>9?(getDate.getMonth()+1):"0"+(getDate.getMonth()+1);
            $("#yearInput").val(getYear);
            $("#start_time,#end_time").val(getYear+"-"+getMonth);
            PublicData.initTable();
        },
        //初始化表格数据
        initTable:function(){
          var tables = {};
          var that = this;
          //定义表格列属性
          tables.dtGridColumns = [
              {id:'teachingItemName', title:'项目', type:'string', columnClass:'text-center'},
              {id:'samePeriod', title:'同期结转收入(万元)', type:'string', columnClass:'text-center'},
              {id:'currentPeriod', title:'本期结转收入(万元)', type:'string', columnClass:'text-center'},
              {id:'rateOfRise', title:'结转收入增长率(%)', type:'string', columnClass:'text-center', resolution: function(value, record, column, grid, dataNo, columnNo) {
                var content = value?value+"%":"";
                return content;
              }
              },
             
          ];
          //定义表格nibuzhi
          tables.dtGridOption = {
            lang:'zh-cn',
            freezecol:'',
            freezerow:'',
            ajaxLoad : true,
            loadURL: ctx+'/br/brIncomeCtrl/queryIncomeIncreaseContribution.do',
            exportFileName : '',
            columns : tables.dtGridColumns,
            check:false,
            gridContainer : 'tb_main_body',
            toolbarContainer : 'tb_main_tool',
            tools:'refresh|faseQuery|export[excel,pdf,]|print',
            pageSize : 10,
            pageSizeLimit : [10,20,50,100]
          }
          grid = $.fn.DtGrid.init(tables.dtGridOption);
          var getStartTimeArr = $("#start_time").val().split("-");
          var getEndTimeArr = $("#end_time").val().split("-");

          grid.diyparameters = {"groupFlag":"teachingItem","year":getStartTimeArr[0],"beginMonth":getStartTimeArr[1],"endMonth":getEndTimeArr[1]}
          grid.load();
          $(function(){
            $("#search").click(that.search);
          });
        },
        search:function(registerCodes){
          if(!$("#start_time").val()||!$("#end_time").val()) {
            return showAlertInfo("fail","请输入查询时间");
          }
          // 先判断查询的是否是同一年的
          if($("#start_time").val().split("-")[0]!==$("#end_time").val().split("-")[0]) {
            return showAlertInfo("fail","请查询同一年的收入");
          }
          var getStartTimeArr = $("#start_time").val().split("-");
          var getEndTimeArr = $("#end_time").val().split("-");
          grid.diyparameters = new Object();
          grid.diyparameters.groupFlag = "teachingItem";
          grid.diyparameters.year = getStartTimeArr[0];
          grid.diyparameters.beginMonth = getStartTimeArr[1];
          grid.diyparameters.endMonth = getEndTimeArr[1];
          grid.refresh(true);
        }
    };
    PublicData.init();
});
</script>
</body>
</html>