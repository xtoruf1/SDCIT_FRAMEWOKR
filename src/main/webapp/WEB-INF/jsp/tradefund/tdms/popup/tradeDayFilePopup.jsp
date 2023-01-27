<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 700px;">
	<div class="flex">
		<h2 class="popup_title">파일 등록</h2>
		<div class="ml-auto">
			<button type="button" onclick="doTradeDayFileSave();" class="btn_sm btn_primary bnt_modify_auth">저장</a>
		</div>
		<div class="ml-15">
			<button type="button" onclick="closeLayerPopup()" class="btn_sm btn_secondary">닫기</a>
		</div>
	</div>
	<form id="filePopupForm" name="filePopupForm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="attFileId" value="<c:out value="${param.attFileId}" />" />
	<input type="hidden" name="mineType" value="<c:out value="${param.mineType}" />" />
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 20%;" />
				<col />
			</colgroup>
			<tr>
				<th>첨부파일</th>
				<td>
					<div class="form_group">
						<div class="form_file" style="width: 100%;">
							<p class="file_name">첨부파일을 선택하세요.</p>
							<label class="file_btn">
								<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
								<input type="hidden" name="attachFileSeq" value="1" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	</form>
</div>
<script type="text/javascript">
	//저장
	function doTradeDayFileSave() {
		if ($('#filePopupForm #attachFile').val() == '') {
			alert('첨부파일을 선택하세요.');
			$('#filePopupForm #attachFile').focus();

			return;
		}

		<c:if test="${param.fileType eq 'pict'}">
			var f = document.filePopupForm;

			var fileExtension = f.attachFile.value.substring(f.attachFile.value.lastIndexOf('.') + 1);

			if (
				fileExtension.toLowerCase() != 'jpg'
				&& fileExtension.toLowerCase() != 'gif'
				&& fileExtension.toLowerCase() != 'png'
				&& fileExtension.toLowerCase() != 'bmp'
				&& fileExtension.toLowerCase() != 'jpeg'
			) {
				alert('이미지 파일만 올려 주세요.');

				return;
			}
		</c:if>

		if (confirm('첨부파일을 저장하시겠습니까?')) {
			global.ajaxSubmit($('#filePopupForm'), {
				type : 'POST'
				, url : '<c:url value="/tdms/popup/saveTradeDayPopupFile.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					var rowData = {
						attFileId: (data.attFileId || '')
					}

					layerPopupCallback(rowData);
		        }
			});
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>