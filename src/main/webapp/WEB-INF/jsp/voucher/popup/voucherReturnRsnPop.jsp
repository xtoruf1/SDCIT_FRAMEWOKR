<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="flex">
	<h2 class="popup_title">바우처 신청 반려</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="cont_block" style="width: 700px;">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;">
		</colgroup>
		<tr>
			<th>반려사유</th>
			<td>
				<textarea id="returnRsn" rows="6" class="form_textarea"></textarea>
			</td>

		</tr>
	</table>
</div>

<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="returnVoucherAppl();">반려</button>
	<button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">취소</a>
</div>

<script type="text/javascript">

	function returnVoucherAppl() {

		if($("#returnRsn").val() == ""){
			alert("반려 사유는 필수입니다.");
			return;
		}

		if(!confirm("반려 하시겠습니까?")){
			return;
		}

		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = $('textarea#returnRsn').val();
		config.callbackFunction(returnObj);

		// 레이어 닫기
		closeLayerPopup();
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>