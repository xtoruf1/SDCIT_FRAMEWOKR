<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="egovframework.common.Constants" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<div class="cont_block" style="width: 850px;">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">신청 정보</h3>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width: 17%;" />
			<col />
			<col style="width: 17%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th>신청 업체명</th>
				<td><c:out value="${applyInfo.companyName}" /></td>
				<th>신청 일시</th>
				<td><c:out value="${applyInfo.applyDate}" /></td>
			</tr>
			<tr>
				<th>사업자 번호</th>
				<td><c:out value="${applyInfo.businessNo}" /></td>
				<th>무역업 번호</th>
				<td><c:out value="${applyInfo.tradeNo}" /></td>
			</tr>
			<tr>
				<th>신청자</th>
				<td><c:out value="${applyInfo.applyName}" /></td>
				<th>회원등급</th>
				<td><c:out value="${applyInfo.memberGrade}" /></td>
			</tr>
			<tr>
				<th>휴대폰</th>
				<td><c:out value="${applyInfo.applyPhone}" /></td>
				<th>이메일</th>
				<td><c:out value="${applyInfo.applyEmail}" /></td>
			</tr>
			<tr>
				<th>신청항목</th>
				<td><c:out value="${applyInfo.optionName}" /></td>
				<th>상태</th>
				<td><c:out value="${applyInfo.statusCdNm}" /></td>
			</tr>
			<tr>
				<th>이용금액</th>
				<td><c:out value="${applyInfo.useAmt}" /></td>
				<th>할인금액</th>
				<td><c:out value="${applyInfo.discountAmt}" /></td>
			</tr>
			<tr>
				<th>신청내용</th>
				<td colspan="3"><c:out value="${applyInfo.dscr}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="3">
					<c:choose>
						<c:when test="${fn:length(fileList) > 0}">
							<c:forEach var="item" items="${fileList}" varStatus="status">
								<div class="addedFile" <c:if test="${not status.first}">style="margin-top: 10px;"</c:if>>
									<a href="<c:url value="/common/fileDownload.do" />?attachSeq=${applyInfo.fileId}&groupId=<%=Constants.GROUP_ID_MEMBERSHIP%>&fileSeq=${item.fileSeq}" class="filename">${item.fileNm}</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/common/fileDownload.do?attachSeq=${applyInfo.fileId}&groupId=<%=Constants.GROUP_ID_MEMBERSHIP%>&fileSeq=${item.fileSeq}', '${item.fileNm}', 'dcsc_apply_service_${profile}_${applyInfo.fileId}_<%=Constants.GROUP_ID_MEMBERSHIP%>_${item.fileSeq}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기"> 미리보기
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
<form id="fileForm" name="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="applyId" name="applyId" value="<c:out value="${param.applyId}" />" />
<input type="hidden" id="groupId" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" id="attachSeq" name="attachSeq" value="<c:out value="${applyInfo.fileId}" />" />
<input type="hidden" name="fileSeq" value="1" />
</form>
<script type="text/javascript">
	var f;

	$(document).ready(function(){
		f = document.fileForm;
	});

	function doDownloadFile(fileSeq) {
		f.action = '<c:url value="/common/fileDownload.do" />';
		f.fileSeq.value = fileSeq;
		f.target = '_self';
		f.submit();
	}
</script>