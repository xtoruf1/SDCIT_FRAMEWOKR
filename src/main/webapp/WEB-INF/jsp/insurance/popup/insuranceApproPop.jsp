<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="cont_block" style="width: 400px;">
	<div class="flex">
		<h2 class="popup_title">지급일 선택</h2>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:40%">
			<col>
		</colgroup>
		<tr>
			<th>업체부담금 납부일자</th>
			<td>
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="popPayDate" name="popPayDate" class="txt datepicker" title="지급일" readonly="readonly" />
						<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
					</span>

					<!-- clear 버튼 -->
					<button type="button" onclick="clearPickerValue('popPayDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
				</div>
			</td>
		</tr>
		<tr>
			<th>영수증 발급 여부</th>
			<td>
				<select class="form_select w100p" name="useYn" id="useYn">
					<option value="Y">발급</option>
					<option value="N">미발급</option>
				</select>
			</td>
		</tr>
	</table>

</div>

<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="returnPayDt();">승인</button>
	<button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">취소</a>
</div>

<script type="text/javascript">

	function returnPayDt(){

		if($("#popPayDate").val() == ""){
			alert("업체부담금 납부일자를 입력해 주세요.");
			return;
		}

		if(!confirm("승인 하시겠습니까?")){
			return;
		}

		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = [];

		var payDate = $('#popPayDate').val();
		var useYn = $('#useYn').val();

		returnObj.push(payDate, useYn);
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