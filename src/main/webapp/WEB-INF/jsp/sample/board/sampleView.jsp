<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="basicPageIndex" value="<c:out value='${param.basicPageIndex}' default='1'/>" />
<input type="hidden" name="boardPageIndex" value="<c:out value='${param.boardPageIndex}' default='1'/>" />
<input type="hidden" name="basicPageUnit" value="<c:out value='${param.basicPageUnit}' default='10'/>" />
<input type="hidden" name="boardPageUnit" value="<c:out value='${param.boardPageUnit}' default='10'/>" />
</form>
<form id="sampleForm" name="sampleForm" method="post" onsubmit="return false;">
<input type="hidden" name="boardSeq" value="${param.boardSeq}" />
<input type="hidden" name="articleSeq" value="${resultView.articleSeq}" />
<input type="hidden" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" name="attachSeq" value="${resultView.attachSeq}" />
<input type="hidden" name="fileSeq" value="1" />

<!-- 페이지 위치 -->
<div class="location">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 사용자 게시판</li>
	</ol>
</div>

<div class="contents">
	<table class="formTable">
		<caption>상세조회</caption>
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">제목</th>
			<td colspan="3"><c:out value="${resultView.title}" escapeXml="false" /></td>
		</tr>
		<tr>
			<th scope="row">등록아이디</th>
			<td>${resultView.regId}</td>
			<th scope="row">등록일</th>
			<td>
				<span class="num gray">${resultView.regDate}</span>
			</td>
		</tr>
		<tr>
			<th scope="row">조회수</th>
			<td colspan="3">${resultView.viewCnt}</td>
		</tr>
		<tr>
			<th scope="row">내용</th>
			<td colspan="3"><c:out value="${common:reverseXss(resultView.contents)}" escapeXml="false" /></td>
		</tr>
		<tr>
			<th scope="row">첨부파일</th>
			<td colspan="3">
				<c:if test="${not empty attachList}">
					<c:forEach var="result" items="${attachList}" varStatus="status">
						<a href="javascript:doDownloadFile('${result.fileSeq}');" class="attach_file">
							<img src="<c:url value='/images/icon/icon_file.gif' />" alt="첨부파일" /> ${result.fileNm}
						</a>
					</c:forEach>
				</c:if>
			</td>
		</tr>
		</tbody>
	</table>
	<div class="btn_group mt-20 _center">
		<a href="javascript:goWrite();" class="btn btn_primary">수정</a>
		<a href="javascript:doDelete();" class="btn btn_secondary">삭제</a>
		<a href="javascript:goList();" class="btn btn_secondary">목록</a>
	</div>
</div>
</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.sampleForm;
		lf = document.listForm;
	});

	function goWrite() {
		f.action = '<c:url value="/sample/board/sampleWrite.do" />';
		f.target = '_self';
		f.submit();
	}

	function doDelete() {
		if (confirm('해당 게시물을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/sample/board/sampleDelete.do" />'
				, data : $('#sampleForm').serialize()
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

	function goList() {
		lf.action = '<c:url value="/sample/board/sampleList.do" />';
		lf.target = '_self';
		lf.submit();
	}

	function doDownloadFile(fileSeq) {
		f.action = '<c:url value="/common/fileDownload.do" />';
		f.fileSeq.value = fileSeq;
		f.target = '_self';
		f.submit();
	}
</script>