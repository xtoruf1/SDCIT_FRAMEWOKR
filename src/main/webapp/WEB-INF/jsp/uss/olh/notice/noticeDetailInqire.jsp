<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="double-submit" uri="http://www.egovframe.go.kr/tags/double-submit/jsp" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>

<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${noticeManageVO.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${noticeManageVO.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>

<form id="noticeForms" name="noticeForms" method="get">

<input id="noticeId" name="noticeId" type="hidden" value="<c:out value="${result.noticeId}"/>"/>
<input id="atchFileId" name="atchFileId" type="hidden" value="${result.atchFileId}"/>
<input id="fileSn" name="fileSn" type="hidden" value=""/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<table class="formTable">
	<caption>상세조회</caption>
	<colgroup>
		<col style="width:15%;" />
		<col />
		<col style="width:15%;" />
		<col />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">제목</th>
		<td colspan="3"><c:out value="${result.title}"/></td>
	</tr>
	<tr>
		<th scope="row">작성일</th>
		<td><c:out value="${result.lastUpdusrPnttm}"/></td>
		<th scope="row">조회</th>
		<td><c:out value="${result.inqireCo}"/></td>
	</tr>
	<c:if test="${result.noticeItem != '' && result.noticeItem != null}">
	<tr>
		<th scope="row">공지</th>
		<td colspan="3"><c:out value="${result.noticeItem}" escapeXml="false"  /></td>
	</tr>
	</c:if>
	<tr>
		<th scope="row">내용</th>
		<td colspan="3"><c:out value="${result.cont}" escapeXml="false"  /></td>
	</tr>
	<tr>
		<th scope="row">첨부파일</th>
		<td colspan="3">
			<c:if test="${not empty attachList}">
				<div id="attachFieldList">
				<c:forEach var="fileResult" items="${attachList}" varStatus="status">
					<div class="addedFile">
						<a href="javascript:doDownloadFile('${fileResult.attachSeq}', '${fileResult.fileSeq}');" class="filename">
							${fileResult.fileNm}
						</a>
						<button type="button" onclick="viewer.showFileContents('${serverName}/common/util/noticeFileDownload.do?atchFileId=${fileResult.attachSeq}&fileSn=${fileResult.fileSeq}', '${fileResult.fileNm}', 'membershipexpert_${profile}_${fileResult.attachSeq}_${fileResult.fileSeq}');" class="file_preview btn_tbl_border">
							<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
						</button>
					</div>
				</c:forEach>
				</div>
			</c:if>
		</td>
	</tr>
	</tbody>
</table>


<div class="btn_group mt-20 _center">
	<a href="javascript:goWrite();" class="btn btn_primary btn_modify_auth">수정</a>
	<a href="javascript:doDelete();" class="btn btn_secondary btn_modify_auth">삭제</a>
	<a href="javascript:goList();" class="btn btn_secondary">목록</a>
</div>

</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.noticeForms;
		lf = document.listForm;
	});

	// 게시물 수정
	function goWrite( noticeId) {

		$('#noticeForms').attr("action", '<c:url value="/uss/olh/notice/noticeCnUpdtView.do" />');
		$('#noticeForms').attr("target", '_self');
		$('#noticeForms').submit();

	}

	// 게시물 삭제
	function doDelete() {
		if (confirm('해당 게시물을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/uss/olh/notice/noticeCnDelete.do" />'
				, data : $('#noticeForms').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 게시물을 삭제하였습니다.');
					goList();
				}
			});
		}
	}

	// 목록으로 가기
	function goList() {
		lf.action = '<c:url value="/uss/olh/notice/list.do" />';
		lf.target = '_self';
		lf.submit();
	}

	//첨부파일 다운로드
	function doDownloadFile(fileSeq, fileSn) {
		f.action = '<c:url value="/common/util/noticeFileDownload.do" />';
		f.atchFileId.value = fileSeq;
		f.fileSn.value = fileSn;
		f.target = '_self';
		f.submit();
	}


</script>