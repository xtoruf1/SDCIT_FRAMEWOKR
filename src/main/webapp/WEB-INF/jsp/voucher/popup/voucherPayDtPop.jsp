<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="flex">
	<h2 class="popup_title">지급일 선택</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div class="popup_body">
	<div class="search">
		<table class="formTable" style="width:500px;">
			<tbody>
				<tr>
				<th>지급일</th>
					<td colspan="3">
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" name="payDt" id="payDt" class="txt datepicker" title="시작일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" class="dateClear" onclick="clearPickerValue('payDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<!-- 팝업 버튼 -->
<div class="btn_group mt-20 _center">
	<button type="button" class="btn btn_primary" onclick="returnVoucherPayDt();">확인</button>
	<button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">취소</button>
</div>

<script type="text/javascript">

	function returnVoucherPayDt(){

		if($("#payDt").val() == ""){
			alert("지급일은 필수입니다.");
			return;
		}

		if(!confirm("지급 하시겠습니까?")){
			return;
		}

		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		var returnObj = $('#payDt').val();

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