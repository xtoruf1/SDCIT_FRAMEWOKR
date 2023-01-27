<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="basicPageIndex" value="<c:out value='${param.basicPageIndex}' default='1'/>" />
<input type="hidden" name="boardPageIndex" value="<c:out value='${param.boardPageIndex}' default='1'/>" />
<input type="hidden" name="basicPageUnit" value="<c:out value='${param.basicPageUnit}' default='10'/>" />
<input type="hidden" name="boardPageUnit" value="<c:out value='${param.boardPageUnit}' default='10'/>" />
</form>
<form id="sampleForm" name="sampleForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="boardSeq" value="${param.boardSeq}" />
<input type="hidden" id="articleSeq" name="articleSeq" value="<c:out value='${resultView.articleSeq}' default='0' />" />
<input type="hidden" id="groupId" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" id="attachSeq" name="attachSeq" value="${resultView.attachSeq}" />
<input type="hidden" name="fileSeq" value="1" />

<!-- 페이지 위치 -->
<div class="location">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 사용자 게시판</li>
	</ol>
</div>

<div class="contents">
	<table class="formTable">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>
					<input type="text" name="title" value="<c:out value="${resultView.title}" escapeXml="false" />" class="textType form_text w100p" />
				</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td>
					<textarea id="contents" name="contents" rows="20" style="width: 100%;"><c:out value="${resultView.contents}" escapeXml="false" /></textarea>
				</td>
			</tr>
			<c:if test="${not empty resultView.articleSeq}">
<%--			<tr>
				<th scope="row">첨부파일</th>
				<td>
					<c:if test="${not empty attachList}">
						<c:forEach var="result" items="${attachList}" varStatus="status">
							<div id="fileSeq${result.fileSeq}" <c:if test="${not status.first}">style="margin-top: 10px;"</c:if>>
								<a href="javascript:doDownloadFile('${result.fileSeq}');">
									<img src="<c:url value='/images/icon/icon_file.gif' />" alt="첨부파일" /> ${result.fileNm}
								</a>
								<a href="javascript:doDeleteFile('${result.fileSeq}');">
									<img src="<c:url value='/images/icon/icon_close.gif' />" alt="" />
								</a>
							</div>
						</c:forEach>
					</c:if>
				</td>
			</tr>--%>
			<tr>
				<th>첨부파일 목록</th>
				<td>
					<div id="attachFieldList">
					<c:forEach var="fileResult" items="${attachList}" varStatus="status">
						<div class="addedFile" id="${fileResult.fileSeq}">
							<a href="javascript:doDownloadFile('${fileResult.fileSeq}');">
								<c:out value="${fileResult.fileNm}"/>
							</a>
							<a href="javascript:doDeleteFile('${fileResult.fileSeq}');">
								<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
							</a>
					<%--		<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/scene/tradeSOSFileDownload.do?attachDocumId=${fileResult.attachDocumId}&attachSeqNo=${fileResult.attachSeqNo}', '${fileResult.attachDocumNm}', 'membershipexpert_${profile}_${fileResult.attachDocumId}_${fileResult.attachSeqNo}');" class="file_preview btn_tbl_border">
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>--%>
						</div>
					</c:forEach>
					</div>
				</td>
			</tr>
			</c:if>
			<tr>
				<th scope="row">첨부파일</th>
				<td>
					<div class="mb5px flex">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
								<input type="hidden" name="attachFileSeq" value="1" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<button type="button" onclick="doAddAttachField();" class="btn_tbl_border">추가</button>
					</div>
					<div id="attachFieldEdit"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="btn_group mt-20 _center">
		<c:choose>
			<c:when test="${empty resultView.articleSeq}">
				<a href="javascript:doInsert();" class="btn btn_primary">저장</a>
			</c:when>
			<c:otherwise>
				<a href="javascript:;doUpdate()" class="btn btn_primary">저장</a>
			</c:otherwise>
		</c:choose>
		<a href="javascript:doCancel();" class="btn btn_secondary">취소</a>
	</div>
</div>
</form>
<script type="text/javascript">
	var f;
	var lf;
	var editorObject = [];
	$(document).ready(function(){
		f = document.sampleForm;
		lf = document.listForm;
		<c:if test="${empty resultView.articleSeq}">
			f.title.focus();
		</c:if>

		nhn.husky.EZCreator.createInIFrame({
			oAppRef : editorObject
			, elPlaceHolder : 'contents'
			, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
			, htParam : {
				// 툴바 사용 여부 (true: 사용 / false : 사용하지 않음)
				bUseToolbar : true
				// 입력창 크기 조절바 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseVerticalResizer : true
				// 모드 탭 (Editor | HTML | TEXT) 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseModeChanger : true
			}
		})
	});

	function isValid() {
		if (isStringEmpty(f.title.value)) {
			alert('제목을 입력해 주세요.');
			f.title.focus();

			return false;
		}

		editorObject.getById['contents'].exec('UPDATE_CONTENTS_FIELD', []);

		if (isStringEmpty(f.contents.value)) {
			alert('내용을 입력해 주세요.');
			f.contents.focus();

			return false;
		}

		return true;
	}

	function doInsert() {
		if (isValid()) {
			if (confirm('해당 게시물을 등록하시겠습니까?')) {
				if (isStringEmpty($('#attachFile').val())) {
                	$('#attachFile').prop('disabled', true);
                }

				global.ajaxSubmit($('#sampleForm'), {
					type : 'POST'
					, url : '<c:url value="/sample/board/sampleInsert.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						goList();
			        }
				});
			}
		}
	}

	function doUpdate() {
		if (isValid()) {
			if (confirm('해당 게시물을 수정하시겠습니까?')) {
				if (isStringEmpty($('#attachFile').val())) {
                	$('#attachFile').prop('disabled', true);
                }

				global.ajaxSubmit($('#sampleForm'), {
					type : 'POST'
					, url : '<c:url value="/sample/board/sampleUpdate.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success: function(data){
						goList();
			        }
				});
			}
		}
	}

	function doCancel() {
		<c:choose>
			<c:when test="${empty resultView.articleSeq}">
				goList();
			</c:when>
			<c:otherwise>
				f.action = '<c:url value="/sample/board/sampleView.do" />';
				f.target = '_self';
				f.submit();
			</c:otherwise>
		</c:choose>
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

	function doDeleteFile(fileSeq) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/fileDelete.do" />'
				, data : {
					groupId : $('#groupId').val()
					, attachSeq : $('#attachSeq').val()
					, fileSeq : fileSeq
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#fileSeq' + fileSeq).hide();
				}
			});
		}
	}

	// 첨부파일 필드 추가
	function doAddAttachField() {
		var attachCnt = 0;
		$('input[name="attachFileSeq"]').each(function(){
			attachCnt = $(this).val();
		});

		var attachFileSeq = parseInt(attachCnt) + 1;

		var html = '';
		html += '<div id="field' + attachFileSeq + '" class="mb5px flex mt-5">';
		html += '	<div class="form_file">';
		html += '		<p class="file_name">첨부파일을 선택하세요</p>';
		html += '		<label class="file_btn">';
		html += '			<input type="file" name="attachFile" class="txt" title="첨부파일" />';
		html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
		html += '			<span class="btn_tbl">찾아보기</span>';
		html += '		</label>';
		html += '	</div>';
		html += '	<button type="button" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
	}
</script>