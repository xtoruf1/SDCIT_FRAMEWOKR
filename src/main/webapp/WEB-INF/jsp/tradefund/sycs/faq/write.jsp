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
	<input type="hidden" name="acctTypeId" value="${param.acctTypeId}" />
	<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
	<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>

<form id="viewForm" name="viewForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" id="faqSeq" name="faqSeq" value="${resultView.faqSeq}" />
	<!-- 페이지 위치 -->
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<c:choose>
				<c:when test="${empty resultView.faqSeq}">
					<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">저장</button>
				</c:when>
				<c:otherwise>
					<button type="button" onclick="doUpdate();" class="btn_sm btn_primary btn_modify_auth">저장</button>
				</c:otherwise>
			</c:choose>
			<button type="button" onclick="doDelete();" class="btn_sm btn_primary btn_modify_auth">삭제</button>
			<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
		</div>
	</div>
	<div class="contents">
		<table class="formTable">
			<colgroup>
				<col style="width: 10%;" />
				<col style="width: 20%;" />
				<col style="width: 10%;" />
				<col style="width: 13%;" />
				<col style="width: 10%;" />
				<col style="width: 13%;" />
				<col style="width: 10%;" />
				<col />
			</colgroup>
			<tr>
				<th>분류</th>
				<td>
					<select name="faqClassCd" id="faqClassCd" class="form_select">
						<c:forEach var="list" items="${awd030}" varStatus="status">
							<option value="${list.code}"<c:if test="${resultView.faqClassCd == list.code}"> selected</c:if>>${list.codenm}</option>
						</c:forEach>
					</select>
				</td>
				<th>분류번호</th>
				<td>
					<input type="number" id="faqClassNo" name="faqClassNo" value="${resultView.faqClassNo}" class="form_text" title="분류번호" />
				</td>
				<th>등록자</th>
				<td>
					<input type="text" id="faqInuser" name="faqInuser" value="${resultView.faqInuser}" class="form_text" readonly="readonly" title="등록자" />
				</td>
				<th>등록일</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="faqIndate" name="faqIndate" value="${resultView.faqIndate}" class="txt datepicker" title="등록일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('faqIndate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3">
					<input type="text" id="faqQ" name="faqQ" value="${resultView.faqQ}" class="form_text w90p" title="질문" />
				</td>
				<th>중요도여부</th>
				<td>
					<label class="label_form">
						<input type="checkbox" class="form_checkbox" name="chkFaqLevel" <c:out value="${resultView.faqLevel eq '1' ? 'checked' : ''}"/> >
						<input type="hidden" name="faqLevel" value="<c:out value="${resultView.faqLevel }"/>">
					</label>
				</td>
				<th>게시판구분</th>
				<td>
					<select name="faqGb" id="faqGb" class="form_select">
						<c:forEach var="list" items="${com010}" varStatus="status">
							<option value="${list.code}"<c:if test="${resultView.faqGb == list.code}"> selected</c:if>>${list.codenm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="7">
					<textarea class="form_textarea" rows="10" id="faqA" name="faqA" title="내용"> <c:out value="${resultView.faqA}" escapeXml="false" /> </textarea>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="7">
					<input type="hidden" id="attFileId" 	name="attFileId" value="${resultView.attFileId}"/>
					<input type="hidden" id="fileId" 		name="fileId" />
					<input type="hidden" id="fileNo" 		name="fileNo" />
					<div id="attachFieldList"></div>
					<div class="mb5px flex">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
								<input type="hidden" name="attachFileSeq" value="1" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<button type="button" onclick="doAddAttachField();" class="btn_tbl_border btn_modify_auth">추가</button>
					</div>
					<div id="attachFieldEdit"></div>
				</td>
			</tr>
		 </table>
	</div>
</form>

<script type="text/javascript">
	var viewForm;
	var listForm;
	$(document).ready(function(){
		viewForm = document.viewForm;
		listForm = document.listForm;
		<c:if test="${empty resultView.faqInuser}">
			viewForm.faqInuser.value = "${user.memberNm}";
		</c:if>
		<c:if test="${!empty resultView.attFileId}">
			setFileList();
		</c:if>
	});

	function setFileList(){
		$('#attachFieldList').empty();
		$('#attachFieldEdit').empty();

		var attFileList = "${resultView.attFileList}";
		console.log("attFileList : ", attFileList);
		var fileList = attFileList.split('@');
		var fileNoArr = fileList[0].split('^');
		var fileNameArr = fileList[1].split('^');

		for( var i = 0 ; i < fileNoArr.length ; i++ ){
			var fileNo = fileNoArr[i];
			var fileName = fileNameArr[i];
			if( fileNo != ''){
				var html = '';
				html += '<div class="addedFile" id="fileNo_'+fileNo+'" >';
				html += '	<a href="javascript:doDownloadFile(\''+fileNo+'\');" class="filename">';
				html += '		'+fileName;
				html += '	</a> ';
				html += '	<a href="javascript:doDeleteFile(\''+fileNo+'\');" class="btn_del">';
				html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
				html += '	</a>';
				html += '</div>';

				$('#attachFieldList').append(html);
			}
		}
	}

	function isValid() {
		if (isStringEmpty(viewForm.faqClassNo.value)) {
			alert('분류번호를 입력해 주세요.');
			viewForm.faqClassNo.focus();
			return false;
		}

		if (isStringEmpty(viewForm.faqInuser.value)) {
			alert('등록일을 입력해 주세요.');
			viewForm.faqInuser.focus();
			return false;
		}

		if (isStringEmpty(viewForm.faqQ.value)) {
			alert('제목을 입력해 주세요.');
			viewForm.faqQ.focus();
			return false;
		}

		if (isStringEmpty(viewForm.faqA.value)) {
			alert('내용을 입력해 주세요.');
			viewForm.faqA.focus();
			return false;
		}

		if( viewForm.chkFaqLevel.checked == true){
			viewForm.faqLevel.value = '1'
		}else{
			viewForm.faqLevel.value = '9999'
		}

		return true;
	}

	function doInsert() {
		if (isValid()) {
			if (confirm('저장 하시겠습니까?')) {

				if (isStringEmpty($('#attachFile').val())) {
		        	$('#attachFile').prop('disabled', true);
		        }

				global.ajaxSubmiviewFormilForm'), {
					type : 'POST'
					, url : '<c:url value="/sycs/faq/insert.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						// alert('해당 게시물을 등록하였습니다.');
						goList();
			        }
				});
			}
		}
	}

	function doUpdate() {
		if (isValid()) {
			if (confirm('수정 하시겠습니까?')) {

				if (isStringEmpty($('#attachFile').val())) {
		        	$('#attachFile').prop('disabled', true);
		        }

				global.ajaxSubmit($('#viewForm'), {
					type : 'POST'
					, url : '<c:url value="/sycs/faq/update.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						// alert('해당 게시물을 수정하였습니다.');
						goList();
			        }
				});
			}
		}
	}

	function goList() {
		listForm.action = '<c:url value="/sycs/faq/list.do" />';
		listForm.target = '_self';
		listForm.submit();
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
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

	//첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var form = document.viewForm;
		form.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		form.fileNo.value = fileNo;
		form.fileId.value = form.attFileId.value;
		form.target = '_self';
		form.submit();
	}

	//첨부파일 삭제
	function doDeleteFile(fileNo) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundFileDelete.do" />'
				, data : {
					fileId : $('#attFileId').val()
					, fileNo : fileNo
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					// alert('해당 파일을 삭제하였습니다.');
					$('#fileNo_' + fileNo).hide();
				}
			});
		}
	}

</script>