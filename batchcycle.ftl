<#include "/include/head.ftl">
<!--[if IE 9]>         <html class="no-js lt-ie10"> <![endif]-->
<!--[if gt IE 9]><!-->
<html class="no-js">
<!--<![endif]-->
<head>
  <meta charset="utf-8">
  <title>批量导入循环班退班信息 |朴新教育</title>
  <meta name="robots" content="noindex, nofollow">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
  <link rel="shortcut icon" href="${ctxResource}/bootstrap/appui/img/favicon.png">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/plugins-2.6.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/main-2.6.css">
  <link id="theme-link" rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/themes/social-2.4.css">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/themes-2.2.css" id="theme-sign">
  <link rel="stylesheet" href="${ctxResource}/bootstrap/appui/css/style.css">
  <script src="${ctxResource}/bootstrap/appui/js/vendor/modernizr-2.8.3.min.js"></script>
  <script src="${ctxResource}/bootstrap/appui/js/plugins/socket.io.js"></script>
  <script src="${ctxResource}/bootstrap/appui/js/vendor/jquery-2.2.0.min.js"></script>
  <style type="text/css">
    .text-field {
      display: inline-block;
      width: 100px;
    }
    .file-wrap {
      position: relative;
    }
    .file {
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 170px;
      opacity: 0;
    }
    .import-result {
      display: none;
    }
  </style>
</head>
<body>
<div id="page-wrapper" class="page-loading">
    <!-- 公用页面加载loading -->
    <div class="preloader">
      <div class="inner">
        <div class="preloader-spinner themed-background hidden-lt-ie10"></div>
        <h3 class="text-primary visible-lt-ie10"><strong>Loading..</strong></h3>
      </div>
    </div>
    <div id="page-container" class="header-fixed-top sidebar-visible-lg-full enable-cookies">
        <#include "/layout/left.ftl">
        <div id="main-container">
            <#include "/layout/top.ftl">
            <div id="page-content">
                <div class="content-header">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="header-section">
                                <h1>批量导入循环班退班信息</h1>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="block">
                    <!-- <div class="block-title">
                        <h2>导入学员</h2>
                    </div> -->
                    <label>下载模板</label>
                    <div class="well">
                        请点击 <a class="btn btn-primary" href="${ctx}/quitTurnClass/BatchQuitTurnClassCtrl/downloadBatchQuitClassTemplate.do">下载模板</a> 按钮 ，下载批量导入循环班退费信息模板，并严格按照模板规范认真填写相关信息。
                    </div>
                    <label>上传文件</label>
                    <div class="mb30 file-wrap">
                        <input type="text" name="newclassfile_xls" id="textField" class="form-control text-field"> 
                        <button class="btn btn-default" type="button">浏览...</button>
                        <button class="btn btn-primary" id="btn-import"> 导入 </button>
                        <input type="file" name="fileField" class="file" id="input-import" size="28">
                         <p class="text-danger">注意：请在批量退费前做好发票已经退回确认；批量退费会将已经开具过发票的订单的发票状态更新为“已退回”。</p>
                    </div>
                    <div class="import-result" id="importResult">
                        <h3 class="text-success">导入数据有误，请核对后导入！</h3>
                        <label>部分导入失败，详细信息如下：</label>
                        <table class="table table-striped table-vcenter table-bordered">
                            <thead>
                              <tr>
                                <th>行号</th>
                                <th>学校编码</th>
                                <th>学员姓名</th>
                                <th>学员编码</th>
                                <th>班级编码</th>
                                <th>班级名称</th>
                                <th>退课次</th>
                                <th>退账目</th>
                                <th>退现金</th>
                                <th>退费校区</th>
                                <th>操作员账号</th>
                                <th>失败原因</th>
                              </tr>
                              <tbody id="failList">
                                  
                              </tbody>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${ctxResource}/bootstrap/js/bootstrap.min.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/plugins-2.6.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/app-2.4.js"></script>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script type="text/javascript" src="${ctxResource}/bootstrap/px/js/jquery.form.js"></script>
<script src="${ctxResource}/bootstrap/appui/js/publicUse.js"></script>
<script>
$(function(){
    $('#input-import').change(function(){
        $('#textField').val(this.value);
    });
    $("#btn-import").click(function(){
        if($('#textField').val() === ''){
            return showAlertInfo('fail','请先选择文件！');
        }
        if(!$("#myupload").hasClass("my-upload")) {
          $('#input-import').wrap("<form id='myupload' class='my-upload' style='display:inline-block' action='${ctx}/quitTurnClass/BatchQuitTurnClassCtrl/importBatchQuitClassData.do?classModelCode=CM05005&quitFeeType=01' method='post' enctype='multipart/form-data'></form>");
        }
        $('#myupload').ajaxSubmit({                                                       
            dataType:'json',
            beforeSend:function(){
                showLoading();
            },
            success:function(data){
                if(+data.result === 0){
                    var str = '';
                    $.each(data.failData,function(i,key){
                        str += '<tr><td>'+key.lineNum+'</td><td>'+key.schoolCode+'</td><td>'+
                                key.studentName+'</td><td>'+key.studentSn+'</td><td>'+key.classCode+
                                '</td><td>'+key.className+'</td><td>'+key.quitCSHour+
                                '</td><td>'+key.quitFee2Account+'</td><td>'+key.quitFee2Cast+'</td><td>'+key.areaName+'</td><td>'+key.operatorCode+
                                '</td><td>'+key.errInfo+'</td></tr>'
                    });

                    $('#failList').html(str);
                    $('#importResult').show();
                }else{
                  showAlertInfo('success','导入成功！');
                }
            },
            error:function(xhr){
              location.reload();
            }
        });
    });
});
</script>
</body>
</html>