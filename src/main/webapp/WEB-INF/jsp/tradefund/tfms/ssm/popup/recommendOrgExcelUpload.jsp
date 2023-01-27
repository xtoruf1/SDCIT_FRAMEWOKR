<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="flex">
	<h3 class="popup_title">엑셀양식 업로드</h3>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<button type="button" class="btn_sm btn_primary" onclick="doUploadExcelDownload();">업로드용 양식다운</button>
<button type="button" class="btn_sm btn_primary" onclick="doUpload();">엑셀 업로드</button>

<script type="text/javascript">

	//레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function doUploadExcelDownload() {
		$('#downForm').attr('action','/tfms/ssm/popup/recommendOrgUploadFormExcelDown.do');
		$('#downForm').submit();
	}

	function doUpload() {
		listSheet.SetUploadingImage('/images/common/loading.gif');
		listSheet.LoadExcel({Append:1});
		closeLayerPopup();
	}

</script>