<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<form id="aiConsultForm" name="aiConsultForm" method="post">
<input type="hidden" id="rtnPageType" name="rtnPageType" value="${params.rtnPageType}" />
<input type="hidden" id="currentPageNo" name="currentPageNo" value="${params.currentPageNo}" />
<input type="hidden" id="pblcConsultId" name="pblcConsultId" value="<c:out value="${params.pblcConsultId}" />" />
<input type="hidden" id="stringAiConsultList" name="stringAiConsultList" value="${params.stringAiConsultList}" />
<input type="hidden" id="apiCallYn" name="apiCallYn" value="N" />
<input type="hidden" id="orderCol" name="orderCol" value="${params.orderCol}" />
<input type="hidden" id="reqContents" name="reqContents" value="${params.reqContents}" />
<input type="hidden" id="searchBtnType" name="searchBtnType" value="${params.searchBtnType}" />
<input type="hidden" id="consultTypeCd" name="consultTypeCd" value="${params.consultTypeCd}" />
<input type="hidden" id="startDate" name="startDate" value="${params.startDate}" />
</form>
<div class="cont_block contents">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">${detail.pblcTitle}</td>
			</tr>
			<tr>
				<th scope="row">분야</th>
				<td>${detail.consultTypeNm}</td>
				<th scope="row">상태</th>
				<td>${detail.statusNm}</td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td colspan="3">${detail.reqNm}</td>
			</tr>
			<tr>
				<th scope="row">연락처</th>
				<td>${detail.cellPhone}</td>
				<th scope="row">이메일</th>
				<td>${detail.email}</td>
			</tr>
			<tr>
				<th scope="row">채택전문가</th>
				<td>${detail.expertNm}</td>
				<th scope="row">답변수</th>
				<td>${detail.answerCnt}</td>
			</tr>
			<tr>
				<th scope="row">작성일자</th>
				<td>${detail.creDate}</td>
				<th scope="row">조회수</th>
				<td>${detail.hitsCount}</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td colspan="3"><c:out value="${common:reverseXss(detail.pblcContent)}" escapeXml="false" /></td>
			</tr>
		</tbody>
	</table>
</div>
<c:if test="${not empty answerList}">
	<c:forEach var="item" items="${answerList}" varStatus="status">
		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar">
				<h3 class="tit_block">답변 내역</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">작성자</th>
						<td>${item.expertNm}</td>
						<th scope="row">작성일자</th>
						<td>${item.creDate}</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td colspan="3"><c:out value="${common:reverseXss(item.answerContent)}" escapeXml="false" /></td>
					</tr>
					<tr>
						<th scope="row">관련 법률(법률)</th>
						<td colspan="3">${item.law}</td>
					</tr>
					<tr>
						<th scope="row">관련 법률(조항)</th>
						<td colspan="3">${item.lawClause}</td>
					</tr>
					<tr>
						<th scope="row">기타참고사항</th>
						<td colspan="3">${item.dscr}</td>
					</tr>
				</tbody>
			</table>
		</div>
	</c:forEach>
</c:if>
<script type="text/javascript">	
	function goList() {
		var rtnPageType = $('#rtnPageType').val();
		
		var f = document.aiConsultForm;
		if (rtnPageType == 'top5') {
			if (location.href.indexOf('tradeSOSAi') > -1) {
				f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultService.do" />';
			} else {
				f.action = '<c:url value="/tradeSOS/com/aiConsultService.do" />';
			}
		} else {
			if (location.href.indexOf('tradeSOSAi') > -1) {
				f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
			} else {
				f.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
			}
		}	
		f.submit();
	}
</script>