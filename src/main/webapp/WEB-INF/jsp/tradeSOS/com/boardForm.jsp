<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<form id="listForm" name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="searchCreNm" value="${param.searchCreNm}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10' />" />
</form>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:choose>
			<c:when test="${empty resultView.boardId}">
				<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<form id="boardForm" name="boardForm" method="post" encType="multipart/form-data">
<input type="hidden" id="boardId" name="boardId" value="${resultView.boardId}" />
<input type="hidden" id="fileId" name="fileId" value="${resultView.fileId}" />
<div class="contents">
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="formTable">
		<caption>등록/수정 화면</caption>
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th>제목 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="title" name="title" value="${resultView.title}" maxlength="300" class="form_text w100p" title="제목" />
				</td>
			</tr>
			<tr>
				<th>내용 <strong class="point">*</strong></th>
				<td>
					<textarea id="result" name="result" rows="15" class="form_textarea w100p"><c:out value="${resultView.content}" escapeXml="false" /></textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td id="attachFieldList">
					<c:if test="${fn:length(fileList) > 0}">
						<c:forEach var="item" items="${fileList}" varStatus="status">
							<div class="addedFile" <c:if test="${status.first}">style="margin-top: 7px;"</c:if>>
								<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${item.fileId}&fileSeq=${item.fileSeq}" class="filename">
									${item.orgFileNm}
								</a>
								<a href="javascript:void(0);" onclick="deleteExpertFile(this, ${item.fileId}, ${item.fileSeq});" class="btn_del">
									<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
								</a>
							</div>
						</c:forEach>
					</c:if>
					<div class="add_line">
						<div class="form_file" style="width: 700px;">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" name="param_file" class="form_text" />
								<span class="btn_tbl">찾아보기</span>
							</label>
							<button type="button" onclick="addLine();" class="btn_tbl_border">추가</button>
						</div>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</form>
<script type="text/javascript">
	$(document).on('change', 'input:file[name="param_file"]', function(){  
		$(this).parents('div.inputFile').find('input:hidden[name^="fileSeq"]').val('');
		$(this).parents('div.inputFile').find('input:text[name^="fileName"]').val($(this).val().substring($(this).val().lastIndexOf('\\') + 1));
	});

	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
		oAppRef : oEditors
		, elPlaceHolder : 'result'
		, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
		, htParams : {
			// 툴바 사용 여부 (true : 사용 / false : 사용하지 않음)
			bUseToolbar : true
			// 입력창 크기 조절바 사용 여부 (true : 사용 / false : 사용하지 않음)
			, bUseVerticalResizer : true
			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true : 사용 / false : 사용하지 않음)
			, bUseModeChanger : true
		}
		, fCreator : 'createSEditor2'
	});
	
	function addLine() {
		var addStr = '';
		addStr += '<div class="add_line">';
		addStr += '	<div class="form_file" style="width: 700px;">';
		addStr += '		<p class="file_name">첨부파일을 선택하세요</p>';
		addStr += '		<label class="file_btn">';
		addStr += '			<input type="file" name="param_file" />';
		addStr += '			<span class="btn_tbl">찾아보기</span>';
		addStr += '		</label>';
		addStr += '		<button type="button" onclick="deleteRow(this);" class="btn_tbl_border">삭제</button>';
		addStr += '	</div>';
		addStr += '</div>';
		
		$('#attachFieldList').append(addStr);
	}
	
	function deleteRow(obj) {
		var clickedRow = $(obj).closest('.add_line');
		clickedRow.remove();
	}
	
	function deleteExpertFile(obj, fileId, fileSeq) {
		if (confirm('선택한 파일을 삭제 하겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/exp/deleteExpertFile.do" />'
				, data : {
					fileId : fileId
					, fileSeq : fileSeq
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					var clickedRow = $(obj).closest('.addedFile');
					clickedRow.remove();
				}
			});
		}
	}
	
	function deleteFile(addStr){
		$('input:hidden[name="fileSeq"]').val('');
		$('input:text[name="fileName"]').val('');
		$('input:file[name="param_file"]').val('');
	}

	function doSave() {
		var sHTML = oEditors.getById['result'].getIR();
		
		if ($('#boardForm #title').val() == '') {
			alert('제목을 입력해 주세요.');
			
			$('#boardForm #title').focus();
			
			return false;
		} else if (sHTML == '<p></p>' || sHTML == null) {
			alert('내용을 입력해 주세요.');
			
			return false;
		}

		oEditors.getById['result'].exec('UPDATE_CONTENTS_FIELD', []);
		
		var formData = new FormData();
		
		formData.append('title', $('#boardForm #title').val());
		formData.append('content', $('#boardForm #result').val());
		formData.append('boardId', $('#boardForm #boardId').val());
		
		if ($('#boardForm #fileId').val() != '') {
			formData.append('fileId', $('#boardForm #fileId').val());
		}
		
		for (var i = 0; i < $('input:file[name="param_file"]').length; i++) {
			if ($('input:file[name="param_file"]').eq(i).val() != '') {
				formData.append('param_file' + i, $('input:file[name="param_file"]')[i].files[0]);
			}
		}
		
		if (confirm('저장 하겠습니까?')) {
			$.ajax({
				url : '<c:url value="/tradePro/board/saveBoard.do" />'
				, type : 'POST'
				, data : formData
				, processData : false
				, contentType : false
				, success: function (data){
					if (data.result) {
						goList();	
					} else {
						alert(data.message);	
					}	
				}
			});
		}
	}
	
	function goList() {
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardForm.do'}">
			document.listForm.action = '<c:url value="/tradePro/board/boardList.do" />';
		</c:if>
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/memberBoardForm.do'}">
			document.listForm.action = '<c:url value="/tradePro/board/memberBoardList.do" />';
		</c:if>
		document.listForm.target = '_self';
		document.listForm.submit();
	}
</script>