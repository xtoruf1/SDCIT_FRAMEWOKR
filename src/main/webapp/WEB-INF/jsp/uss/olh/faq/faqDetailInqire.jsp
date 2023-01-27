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
<input type="hidden" name="searchCondition" value="${searchVO.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${searchVO.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>

<form name="faqManageForm" id="faqManageForm" method="post">
	<input name="faqId" id="faqId" type="hidden" value="<c:out value="${result.faqId}"/>"/>
	<input id="atchFileId" name="atchFileId" type="hidden" value="${result.atchFileId}"/>
	<input id="fileSn" name="fileSn" type="hidden" value=""/>
	<div class="page_faq_detail">
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
			</colgroup>
			<tr>
				<th>분류</th>
				<td><c:out value="${result.qestnCdNm}"/>  </td>
			</tr>
			<c:if test="${not empty result.qestnSubCdNm}">
				<tr>
					<th>세부 분류</th>
					<td><c:out value="${result.qestnSubCdNm}"/>  </td>
				</tr>
			</c:if>
			<tr>
				<th>질문 제목</th>
				<td><c:out value="${result.qestnSj}"/>  </td>
			</tr>
			<!--
			<tr>
				<th class="dTitle">질문 내용</th>
				<td class="dWrap">
					<div class="dCont"><c:out value="${result.qestnCn}"/></div>
				</td>
			</tr>
			 -->
			<tr>
				<th class="dTitle">답변 내용</th>
				<td class="dWrap">
					<div class="dCont">
						<c:out value="${result.answerCn}" escapeXml="false"/>
					</div>
				</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td><c:out value="${result.inqireCo}"/></td>
			</tr>
			<tr>
				<th scope="row">첨부파일 목록</th>
				<td>
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
			<tr>
				<th>등록일자</th>
				<td><c:out value="${result.lastUpdusrPnttm}"/></td>
			</tr>
		</table>
		<div class="btn_group mt-20 _center">
			<button type="button" onclick="goWrite();"  class="btn btn_primary btn_modify_auth">수정</button>
			<button type="button" onclick="doDelete();" class="btn btn_secondary btn_modify_auth">삭제</button>
			<button type="button" onclick="goList();" class="btn btn_secondary">목록</button>
		</div>
	</div><!-- //.page_faq_detail-->
</form>
<script type="text/javascript">
	var f;
	var lf;
	$(document).ready(function(){
		f = document.faqManageForm;
		lf = document.listForm;
	});

	// 게시물 수정
	function goWrite() {
		$('#faqManageForm').attr("action", '<c:url value="/uss/olh/faq/faqCnUpdtView.do" />');
		$('#faqManageForm').attr("target", '_self');
		$('#faqManageForm').submit();
	}

	// 게시물 삭제
	function doDelete() {
		if (confirm('해당 게시물을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/uss/olh/faq/faqCnDelete.do" />'
				, data : $('#faqManageForm').serialize()
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
		lf.action = '<c:url value="/uss/olh/faq/list.do" />';
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