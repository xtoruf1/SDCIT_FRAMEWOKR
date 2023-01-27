<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="cont_block" style="width: 400px;">
	<div class="flex">
		<h3 class="popup_title">수출입 단체보험 환불</h3>
		<div class="ml-auto">
			<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:40%">
			<col>
		</colgroup>
		<tr>
			<th>환불일자</th>
			<td>
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="popReturnDate" name="returnDate" class="txt datepicker" title="환불일자" readonly="readonly" />
						<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
					</span>

					<!-- clear 버튼 -->
					<button type="button" onclick="clearPickerValue('returnDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
				</div>
			</td>
		</tr>
	</table>
</div>

<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="returnPayDt();">환불</button>
	<button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">취소</a>
</div>


<script type="text/javascript">

	function returnPayDt(){

		if($("#popReturnDate").val() == ""){
			alert("환불일자를 입력해 주세요.");
			return;
		}

		if(!confirm("환불 하시겠습니까?")){
			return;
		}

		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = $('#popReturnDate').val();

		config.callbackFunction(returnObj);


		closeLayerPopup();
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>