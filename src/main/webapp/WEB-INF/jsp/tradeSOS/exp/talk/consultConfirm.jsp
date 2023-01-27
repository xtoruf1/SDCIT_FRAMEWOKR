<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<%
	pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="format-detection" content="telephone=no" />
<title>TradePro</title>
<style>
	html, body {margin: 0; padding: 0; width: 100%; height: 100%; }
	body {background-color:#f8f8f9; }
	.confirmWrap {overflow-y:auto; height:100%; box-sizing:border-box; padding:30px 14px 80px;}
	.confirmWrap .logo img {display:block;font-size:0;width:169px;height:38px;margin: 0 auto;}
	.confirmContent {background-color:#fff;padding:30px 14px 15px;}
	.confirmContent strong {display:block;text-align:center;font-size:16px;color:#333;margin-bottom:30px;}
	.confirmContent strong span {color:#005bbb}
	.confirmContent table {width:100%;table-layout: fixed;border:0;border-spacing:0;border-collapse:collapse;border-top:1px solid #666666;}
	.confirmContent table th {background-color:#f4f5f7}
	.confirmContent table th,
	.confirmContent table td {padding:15px 10px;border-bottom:1px solid #e6e6e6;font-size:14px;color:#333}
	.btn_group {padding-top:20px; text-align: center; align-content: center;}
	.btn_standard {border-radius:3px; background-color:#606080; border:none; color:#fff; font-weight:bold; font-size:16px; margin-right:5px; padding:0;}
	.btn_standard {width:40%; height:50px; line-height:24px; cursor:pointer; vertical-align:middle;}
	.noShow { background-color:#e31b32}
</style>
<script type="text/javascript" src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/global.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common.js' />"></script>
<!-- IBSheet7 -->
<script type="text/javascript" src="<c:url value='/lib/ibsheet/${profile}/ibleaders.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetinfo.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheet.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibexcel-min.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetHeader.js' />"></script>
<script type="text/javascript" src="<c:url value='/lib/ibsheet/ibsheetcommon.js' />"></script>
<script src="https://asp.4nb.co.kr/kita/_api/js/util.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		if ('${consultDetail.statusCd}' == '01') {
			alert('예약확정 버튼을 눌러야 예약이 확정됩니다.');
		}
	});
	
	function showConfirm() {
		$('#cancelTr').hide();
		$('#btnDiv').show();
		$('#cancelDiv').hide();
	}
	
	function showCancel() {
		$('#cancelTr').show();
		$('#btnDiv').hide();
		$('#cancelDiv').show();
	}
	
	function confirmConsult() {
		if (confirm('예약을 확정 하시겠습니까?')) {
			var jsonParam = {
				prvtConsultId : '${consultDetail.prvtConsultId}'
				, apiAuthCode : encode64Han('${apiAuthCode}')
				, companyCode : encode64Han('${companyCode}')
				, userId : encode64Han('${consultDetail.reqId}')
				, userName : encode64Han('${consultDetail.reqNm}')
				, statusCd : '${consultDetail.statusCd}'
			};
			
			global.ajax({
				url : '<c:url value="/system/tradeSOS/api/confirmExpertPrvtConsultAPI.do" />'
				, dataType : 'json'
				, contentType : 'application/json; charset=utf-8'
				, type : 'POST'
				, data : JSON.stringify(jsonParam)
				, async : true
				, spinner : true
				, success : function(data){
					alert('예약이 확정 되었습니다.');
					
					$('#btnDiv').hide();
				}
			});
		}
	}
	
	function cancelConsult() {
		if ($('#cancelReason').val() == '') {
			alert('취소사유를 입력해 주세요.');
			
			$('#cancelReason').focus();
			
			return;	
		}
		
		if (confirm('예약을 취소 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/cancelExpertPrvtConsultMobile.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					prvtConsultId : '${consultDetail.prvtConsultId}'
					, cancelReason : $('#cancelReason').val()
				}
				, async : true
				, spinner : true
				, success : function(data){
					if (data.result) {
						alert('예약이 취소 되었습니다.');
						
						$('#btnDiv').hide();
						$('#cancelDiv').hide();
						$('#cancelTd').html('<font color="ff0000;">' + $('#cancelReason').val() + '</font>');
						$('#cancelTr').show();
					} else {
						alert(data.message);
					}
				}
			});
		}
	}
</script>
</head>
<body>
<div class="confirmWrap">
	<h1 class="logo"><img src="<c:url value='/images/common/logo_tradepro.png' />" alt="TradePro" /></h1>
	<div class="confirmContent">
		<strong>상담정보입니다.</strong>
		<table>
			<colgroup>
				<col style="width: 90px;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>분야</th>
					<td><c:out value="${consultDetail.consultTypeNm}" /></td>
				</tr>
				<tr>
					<th>상담채널</th>
					<td><c:out value="${consultDetail.consultChannelNm}" /></td>
				</tr>
				<tr>
					<th>상담자</th>
					<td><c:out value="${consultDetail.reqNm}"/></td>
				</tr>
				<c:if test="${consultDetail.consultChannel eq '03'}">
					<tr>
						<th>연락처</th>
						<td><c:out value="${consultDetail.cellPhone}" /></td>
					</tr>
				</c:if>	
				<tr>
					<th>상담일시</th>
					<td>
						<c:out value="${fn:substring(consultDetail.rsrvDate, 0, 4)}"/>-<c:out value="${fn:substring(consultDetail.rsrvDate, 4, 6)}"/>-<c:out value="${fn:substring(consultDetail.rsrvDate, 6, 8)}"/>
						<c:out value="${fn:substring(consultDetail.rsrvTime, 0, 2)}"/>:<c:out value="${fn:substring(consultDetail.rsrvTime, 2, 4)}"/>
					</td>
				</tr>
				<tr>
					<th>상담요지</th>
					<td><c:out value="${fn:replace(consultDetail.consultText, newLine , '<br/>')}" escapeXml="false" /></td>
				</tr>
				<tr id="cancelTr" style="display: none;">
					<th>취소사유</th>
					<td id="cancelTd">
						<input type="text" id="cancelReason" name="cancelReason" value="" maxlength="50" style="width: 80%;height: 32px;" placeholder="취소사유를 입력해 주세요." />
					</td>
				</tr>
				<c:if test="${consultDetail.statusCd eq '05' or consultDetail.statusCd eq '06'}">
					<tr>
						<th>취소사유</th>
						<td><font color="ff0000;"><c:out value="${consultDetail.cancelReason}" /></font></td>
					</tr>
				</c:if>
			</tbody>
		</table>
		<c:if test="${consultDetail.statusCd eq '01'}">
			<div class="btn_group btn_full" id="btnDiv">
				<button type="button" onclick="confirmConsult();" class="btn_standard">예약확정</button>
				<button type="button" onclick="showCancel();" class="btn_standard noShow">예약취소</button>
			</div>
			<div class="btn_group btn_full" id="cancelDiv" style="display: none;">
				<button type="button" onclick="showConfirm();" class="btn_standard">이전</button>
				<button type="button" onclick="cancelConsult();" class="btn_standard noShow">취소확인</button>
			</div>
		</c:if>
	</div>
</div>
</body>
</html>