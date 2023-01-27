<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 600px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">채용기간을 선택해 주세요.</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 20%;" />
				<col />
			</colgroup>
			<tr>
				<th>채용기간</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="popupRecruitStDate" value="" class="txt datepicker" style="width: 120px;" placeholder="채용시작일자" title="채용시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setPopupDefaultPickerValue('popupRecruitStDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="popupRecruitEdDate" value="" class="txt datepicker" style="width: 120px;" placeholder="채용종료일자" title="채용종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setPopupDefaultPickerValue('popupRecruitEdDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doSaveRecruitPopup();" class="btn btn_primary btn_modify_auth">채용</button>
	</div>
</div>
</form>
<script type="text/javascript">
	function doSaveRecruitPopup() {
		if ($('#popupRecruitStDate').val() == '') {
			alert('채용시작일자를 선택해 주세요.');
			
			$('#popupRecruitStDate').focus();
			
			return;
		}
		
		if ($('#popupRecruitEdDate').val() == '') {
			alert('채용종료일자를 선택해 주세요.');
			
			$('#popupRecruitEdDate').focus();
			
			return;
		}
		
		var returnJson = {};
		returnJson['recruitStDate'] = $('#popupRecruitStDate').val()
		returnJson['recruitEdDate'] = $('#popupRecruitEdDate').val()
				
		// 콜백
		layerPopupCallback(returnJson);
	}
	
	function setPopupDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}
</script>