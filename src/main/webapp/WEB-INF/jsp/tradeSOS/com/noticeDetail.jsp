<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="listForm" name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchNoticeTypeCd" value="${param.searchNoticeTypeCd}" />
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10' />" />
</form>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<form id="noticeForm" name="noticeForm" method="post">
<input type="hidden" id="noticeId" name="noticeId" value="${noticeDetail.noticeId}" />
<input type="hidden" id="fileId" name="fileId" value="${noticeDetail.fileId}" />
<div class="cont_block">
	<table class="formTable">
		<colgroup>
			<col style="width: 12%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>${noticeDetail.title}</td>
			</tr>
			<tr>
				<th scope="row">구분</th>
				<td>${noticeDetail.noticeTypeNm}</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td>
					<div style="min-height: 300px;">
						<c:out value="${noticeDetail.contents}" escapeXml="false" />
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td id="attachFieldList">
					<c:choose>
						<c:when test="${fn:length(fileList) > 0}">
							<c:forEach var="item" items="${fileList}" varStatus="status">
								<div class="addedFile" <c:if test="${status.first}">style="margin-top: 10px;"</c:if>>
									<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${item.fileId}&fileSeq=${item.fileSeq}" class="filename">${item.orgFileNm}</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.fileId}&fileSeq=${item.fileSeq}', '${item.orgFileNm}', 'membershipboard_${profile}_${item.fileId}_${item.fileSeq}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</c:when>
					</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</form>
<script type="text/javascript">
	function goList() {
		<c:if test="${param.authType eq 'pro'}">
			document.listForm.action = '<c:url value="/tradeSOS/notice/proNoticeList.do" />';
		</c:if>
		<c:if test="${param.authType eq 'trade'}">
			document.listForm.action = '<c:url value="/tradeSOS/notice/tradeNoticeList.do" />';
		</c:if>
		<c:if test="${param.authType eq 'consult'}">
			document.listForm.action = '<c:url value="/tradeSOS/notice/consultNoticeList.do" />';
		</c:if>
		<c:if test="${param.authType eq 'trans'}">
			document.listForm.action = '<c:url value="/tradeSOS/notice/transNoticeList.do" />';
		</c:if>
		document.listForm.target = '_self';
		document.listForm.submit();
	}
</script>