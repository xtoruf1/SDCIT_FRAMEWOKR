<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchConsultTypeCd" value="${param.searchConsultTypeCd}" />
<input type="hidden" name="searchStatusCd" value="${param.searchStatusCd}" />
<input type="hidden" name="searchStartDate" value="${param.searchStartDate}" />
<input type="hidden" name="searchEndDate" value="${param.searchEndDate}" />
<input type="hidden" name="searchReqNm" value="${param.searchReqNm}" />
<input type="hidden" name="searchExptTypeCd" value="${param.searchExptTypeCd}" />
<input type="hidden" name="searchExptText" value="${param.searchExptText}" />
<input type="hidden" name="searchPblcTitle" value="${param.searchPblcTitle}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="aiPopupForm" name="aiPopupForm" method="post">
<input type="hidden" id="apiCallYn" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" value="${detail.pblcContentText}" />
</form>
<input type="hidden" id="pblcConsultId" value="${param.pblcConsultId}" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="openConsultTypePopup();" class="btn_sm btn_primary btn_modify_auth">상담분야 변경</button>
		<button type="button" onclick="doDeletePblcConsult();" class="btn_sm btn_secondary btn_modify_auth">전체삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="openAiConsultPopup();" class="btn_sm btn_primary">AI 자문 확인</button>
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
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
				<div class="ml-auto">
					<button type="button" onclick="doDeleteAnswer('${item.answerId}');" class="btn_sm btn_primary btn_modify_auth">답변삭제</button>
				</div>
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
	// 답변삭제
	function doDeleteAnswer(answerId) {
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/deleteAnswer.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data :  {
					pblcConsultId : $('#pblcConsultId').val()
					, answerId : answerId
				}
				, async : true
				, spinner : true
				, success : function(data){
					<c:choose>
						<c:when test="${empty user}">
							location.href = '<c:url value="/tradeSOS/exp/openConsultation.do" />';
						</c:when>
						<c:otherwise>
							location.reload();
						</c:otherwise>
					</c:choose>
				}
			});
		}
	}
	
	// 신청서, 답변, 이력 모두 삭제
	function doDeletePblcConsult() {
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/deletePblcConsult.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data :  {
					pblcConsultId : $('#pblcConsultId').val()
				}
				, async : true
				, spinner : true
				, success : function(data){
					<c:if test="${empty user}">
						alert('로그인이 필요합니다.');
					</c:if>
					
					// 삭제후 목록 (로그인 상태가 아니여도 목록 URL로 보낼경우 로그인 후 returnUrl로 사용)
					location.href = '<c:url value="/tradeSOS/exp/openConsultation.do" />';
				}
			});
		}
	}
	
	// 상담분야 변경 팝업
	function openConsultTypePopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/pblcConsultTypePopup.do" />'
			, params : {
				pblcConsultId : $('#pblcConsultId').val()
				, consultTypeCd : '${detail.consultTypeCd}'
				, pblcTitle : '${detail.pblcTitle}'
			}
			, callbackFunction : function(resultObj){
				goList();
			}
		});
    }
	
	// AI자문 새탭 열기
	function openAiConsultPopup() {
		// 에디터 내용에 텍스트 없이 이미지만 등록이 가능한 상태라 내용에 이미지파일만 존재 할 경우 했을 경우 detail.pblcContentText 가 공백상태
		if ($('#reqContents').val() == '') {
			alert('이미지는 AI자문을 확인 할 수 없습니다.');
			
			return false;
		}
		
		timestamp = new Date().getTime();
		popupName = 'aiPopup_' + timestamp;
		
		window.open('', popupName);
		
		document.aiPopupForm.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
		document.aiPopupForm.target = popupName;
		document.aiPopupForm.submit();
	}
	
	// 목록
	function goList() {
		document.listForm.action = '<c:url value="/tradeSOS/exp/openConsultation.do" />';
		document.listForm.target = '_self';
		document.listForm.submit();
	}
</script>