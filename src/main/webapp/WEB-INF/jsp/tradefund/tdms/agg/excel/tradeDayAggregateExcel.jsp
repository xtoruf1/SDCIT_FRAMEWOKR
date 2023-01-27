<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String clientBrowser = request.getHeader("User-Agent");
    SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
    Date time = new Date();
    String nowDate = format1.format(time);
	String excelFileNm = "신청접수현황집계표";
	String convName1 = java.net.URLEncoder.encode(excelFileNm + '_' + nowDate+".xls","UTF-8");

	if(clientBrowser.indexOf("MSIE 5.5") != -1 || clientBrowser.indexOf("MSIE 6.0") != -1){
		response.setHeader("Content-Disposition", "attachment;filename=" + convName1);
	}else {
		response.setHeader("Content-Disposition", "filename=" + convName1);
	}
%>
<html>
    <head>
        <title>무역지원서비스</title>
        <meta http-equiv="Content-Type" ontent="application/vnd.ms-excel; charset=utf-8"/>
        <style type="text/css">
            h4 {position:relative; padding:5px 0 5px 12px; font-size:16px;border-left:4px solid #0082fa}
            table {font-size:14px;}
            table {width:100%; border-top:1px solid #8b8ba2; margin-bottom:15px;}
            table tr {width:100%;}
            table th {height:36px; border-right:1px solid #ddd; border-bottom:1px solid #ddd; background-color:#eee;}
            table td {height:36px; padding:8px; border-right:1px solid #ddd; border-bottom:1px solid #ddd;
            text-align:center;}
            table th:last-child {border-right:0;}
        </style>
    </head>
    <body>
            ${htmlData}
    </body>

</html>