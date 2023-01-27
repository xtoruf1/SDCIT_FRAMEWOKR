<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="flex">
	<h2 class="popup_title">반려사유</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<input type="text" class="form_text w100p" name="returnReasonPopup" id="returnReasonPopup">
</div>

<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="returnSavePopup();">저장</button>
</div>

<script type="text/javascript">

	$(document).ready(function(){

	});

	function returnSavePopup() {

		if ( $("#returnReasonPopup").val() == "" ) {
			alert("반려 사유를 입력해 주세요.");
			$("#returnReasonPopup").focus();
			return;
		}

		if(!confirm("반려 후엔 E-Mail과 알림톡이 발송 됩니다. \n계속 하시겠습니까?"))return;

		var returnObj = $("#returnReasonPopup").val();
		layerPopupCallback(returnObj);
		closeLayerPopup();
	}

	function closePopup() {
		closeLayerPopup();
	}

</script>