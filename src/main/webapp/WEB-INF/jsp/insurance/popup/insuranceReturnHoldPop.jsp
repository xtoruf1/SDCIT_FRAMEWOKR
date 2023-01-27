<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form id="submitForm" name="submitForm">
	<div class="cont_block" style="width: 500px;">
		<div class="flex">
			<h3 class="popup_title">수출입 단체보험 가입보류</h3>
			<div class="ml-auto">
				<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
			</div>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width: 20%;"/>
				<col />
			</colgroup>
			<tr>
				<th>보류사유</th>
				<td>
					<textarea id="popReturnRsn" name="popReturnRsn" class="form_textarea" rows="6" maxlength="1300">업체부담금 미납</textarea>
				</td>
			</tr>
		</table>
	</div>

	<div class="btn_group mt-20 _center">
		<button type="button" class="btn btn_primary" onclick="returnPayDt();">확인</button>
		<button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">취소</a>
	</div>
</form>

<script type="text/javascript">

	function returnPayDt(){

		debugger;

		var form = document.submitForm;

		if($("#popReturnRsn").val() == ""){
			alert("가입보류 사유는 필수입니다.");
			return;
		}

		if($("#popReturnRsn").val() != ""){
			if(global.chkByte(form.popReturnRsn, 1300, '가입보류 사유') == false) {
				return;
			}
		}

		if(!confirm("가입보류 하시겠습니까?")){
			return;
		}

		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = $('textarea#popReturnRsn').val();

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