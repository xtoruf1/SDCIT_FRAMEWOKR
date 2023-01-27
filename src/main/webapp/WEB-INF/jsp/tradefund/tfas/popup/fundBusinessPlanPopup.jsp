<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundBusinessPlanPopupForm" name="fundBusinessPlanPopupForm" method="post"  enctype="multipart/form-data"  onsubmit="return false;">
<input type="hidden" name="svrId" 		value="<c:out value="${param.svrId}"/>" />
<input type="hidden" name="applyId" 	value="<c:out value="${param.applyId}"/>" />
<%-- <input type="hidden" name="attFileId" 	value="<%=vo.get("ATT_FILE_ID")%>"> --%>
<%-- <input type="hidden" name="file_id"   	value="<%= StringUtils.cvtHTML(params.get("file_id")) %>"> --%>

<div style="max-width: 900px; max-height: 800pxpx;" class="fixed_pop_tit">

<!-- 팝업 타이틀 -->
<div class="flex popup_top">
	<h2 class="popup_title">KITA무역진흥자금 사업계획서(회사소개서)</h2>
	<div class="ml-auto">
	<c:if test='${param.isDisplay eq "P"}'>
		<button type="button"  class="btn_sm btn_primary btn_modify_auth" 		onclick="fundBusinessPlanPopupSave()">저장</button>
	</c:if>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body" >
	<table class="formTable">
		<colgroup>
			<col style="width:18%;">
			<col>
		</colgroup>
		<tr>
			<th >접수번호</th>
			<td >
				<c:out value="${param.applyId}"/>
			</td>
		</tr>
		<tr>
			<th rowspan="2">사업계획서 내용 <strong class="point">*</strong></th>
			<td >


				<c:set var="textReadOnly" value="" />
				<c:if test='${param.isDisplay eq "O"}'>
					<c:set var="textReadOnly" value="readonly" />
				</c:if>
<%-- 					<textarea name="BUSINESS_PLAN" class="text_01" onKeyUp="textareachk(this)" onFocus="JavaScript:inputTextOnFocus(this);" <%=textReadOnly %> onBlur="JavaScript:inputTextOutFocus(this);" isRequired="true" desc="무역기금융자 세부내용"><%=StringUtils.cvtHTML2(vo.get("BUSINESS_PLAN")) %></textarea> --%>
				<textarea rows="10" class="form_textarea" id="businessPlan" name="businessPlan" placeholder="무역기금융자 세부내용" title="무역기금융자 세부내용" style="height:99%; width:99%" required="required"
				onKeyUp="textareachk(this)"  <c:out value="${textReadOnly}"/> ><c:out value="${result.businessPlan}"/></textarea>
			</td>
		</tr>
		<tr>
            <td >
            	<div class="flex align_center">
            	(<input type="text" id="textareaCnt" name="textareaCnt" style="width:40px; font-size:14px; color:#5C5F68; border:0; ime-mode:disabled; text-align : right;"  readonly="readonly" /> ) / 4000 byte
            	</div>
            </td>
        </tr>
		<tr>
			<th>첨부파일</th>
			<td >
			<c:if test='${param.isDisplay eq "P"}'>
				<input type="hidden" id="attFileId" 	name="attFileId" value="<c:out value="${result.attFileId}"/>" />
				<input type="hidden" id="fileId" 		name="fileId" value="<c:out value="${param.fileId}"/>" />
				<input type="hidden" id="fileNo" 		name="fileNo" />
				<div id="attachFieldList">

				<c:if test="${not empty fileList}">
					<c:set var="lastFileSeq" value="0" />
					<c:forEach var="fileList" items="${fileList}" varStatus="status">
						<div class="addedFile" id="fileNo_<c:out value="${fileList.fileNo}"/>">
							<a href="javascript:doDownloadFile('<c:out value="${fileList.fileNo}"/>');" class="filename">
								<c:out value="${fileList.fileName}"/>
							</a>
							<a href="javascript:doDeleteFile('<c:out value="${fileList.fileNo}"/>');" class="btn_del">
								<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
							</a>
                              </div>
					</c:forEach>
				</c:if>

				</div>

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

			</c:if>

			<c:if test='${param.isDisplay eq "O"}'>

				<input type="hidden" id="attFileId" 	name="attFileId" value="<c:out value="${result.attFileId}"/>" />
				<input type="hidden" id="fileId" 		name="fileId" value="<c:out value="${param.fileId}"/>" />
				<input type="hidden" id="fileNo" 		name="fileNo" />
				<div id="attachFieldList">

				<c:if test="${not empty fileList}">
					<c:set var="lastFileSeq" value="0" />
					<c:forEach var="fileList" items="${fileList}" varStatus="status">
						<div class="addedFile" id="fileNo_<c:out value="${fileList.fileNo}"/>" >
							<a href="javascript:doDownloadFile('<c:out value="${fileList.fileNo}"/>');" class="filename">
								<c:out value="${fileList.fileName}"/>
							</a>
                              </div>
					</c:forEach>
				</c:if>

				</div>

				<div id="attachFieldEdit"></div>

			</c:if>
				<span style="color: #cc0000;">
				 *파일첨부시 주의사항*<br/>파일을 추가,삭제 후 [저장]버튼을 클릭하셔야 적용됩니다.
				</span>
			</td>
		</tr>
	 </table>
</div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function () {
		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});

		var f = document.fundBusinessPlanPopupForm;
		var obj = f.businessPlan;
  		var textarea_length = doValidLength(obj.value);
  		document.getElementById("textareaCnt").value = textarea_length;

  	  $("#st").prop('disabled',true);
	});

	//TextArea 길이 유효성 검사
	function textareachk(obj){
	    var textarea_length = doValidLength(obj.value);
	    document.getElementById("textareaCnt").value = textarea_length;

	    if(textarea_length > 4000){
	    	alert("4000 byte 이상 입력 하실수 없습니다.");
	    	obj.value = obj.value.substring(0,obj.value.length - 1);
	    	return false;
	    }
	    return true;
	}

	//첨부파일 다운로드
	function fundBusinessPlanPopupSave() {
		var f = document.fundBusinessPlanPopupForm;


		var textarea_length = doValidLength(document.fundBusinessPlanPopupForm.businessPlan.value);

		if(textarea_length > 4000){
	    	alert("4000 byte 이상 입력 하실수 없습니다.");
	    	return;
	    }

		global.ajaxSubmit($('#fundBusinessPlanPopupForm'), {
			type : 'POST'
			, url : '<c:url value="/tfas/popup/fundBusinessPlanSave.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				alert('사업계획서가 저장되었습니다.');
				closeLayerPopup();
	        }
		});
	}

	//행 선택 이벤트 ( From 값 매핑)
	function getValue(row){
		var formObj = document.form1;
		var sheetObj = sheet1;
		setFormFromSheet(formObj, sheetObj, row);

		formObj.statusChk.value = 'U';

		$('#attachFieldList').empty();
		$('#attachFieldEdit').empty();

		var attFileList = sheet1.GetCellValue(row, "attFileList");

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
				html += '		 '+fileName;
				html += '	</a> ';
				html += '	<a href="javascript:doDeleteFile(\''+fileNo+'\');" class="btn_del">';
				html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
				html += '	</a>';
				html += '</div>';

				$('#attachFieldList').append(html);
			}
		}
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
		html += '	<button type="button btn_modify_auth" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	//첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var form = document.fundBusinessPlanPopupForm;
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
					alert('해당 파일을 삭제하였습니다.');
					$('#fileNo_' + fileNo).hide();
				}
			});
		}
	}

</script>