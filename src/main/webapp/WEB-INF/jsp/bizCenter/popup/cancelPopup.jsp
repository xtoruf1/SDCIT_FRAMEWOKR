<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="flex">
	<h2 class="popup_title">취소 사유</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closePopup();">닫기</button>
	</div>
</div>

<div class="popup_body" style="width:400px">
	<input type="text" class="form_text w100p" name="cancelPopup" id="cancelPopup" maxlength="1000">
</div>
<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="saveCancelPopup();">저장</button>
</div>

<script type="text/javascript">

	$(document).ready(function(){

	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function saveCancelPopup() {

		if ( $("#cancelPopup").val() == "" ) {
			alert("취소 사유를 입력해 주세요.");
			$("#cancelPopup").focus();
			return;
		}

		if(!confirm("예약을 취소 하시겠습니까?"))return;

		var returnObj = $("#cancelPopup").val();
		layerPopupCallback(returnObj);
		closeLayerPopup();
	}

	function closePopup() {
		closeLayerPopup();
	}

</script>