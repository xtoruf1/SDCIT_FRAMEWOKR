<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="popupSettingForm" name="popupSettingForm" method="post" onsubmit="return false;">
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">신규상담시간 설정</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col style="width: 45%;" />
				<col style="width: 15%;" />
				<col style="width: 25%;" />
			</colgroup>
			<tr>
				<th>변동월</th>
				<td>
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>
					<span class="form_row" style="min-width: 120px;">
						<select id="popupFromYear" name="popupFromYear" class="form_select" title="변동년">
							<option value="">선택</option>
							<option value="${sysYear}">${sysYear}</option>
							<option value="${sysYear + 1}">${sysYear + 1}</option>
						</select> 
						<i class="append">년</i>
					</span>
					<span class="form_row" style="min-width: 120px;">
						<select id="popupFromMonth" name="popupFromMonth" class="form_select" title="변동월">
							<option value="">선택</option>
							<option value="01">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
						</select> 
						<i class="append">월</i>
					</span>
				</td>
				<th>설정시간</th>
				<td>
					<span class="form_row" style="min-width: 120px;">
						<select id="popupSetTime" name="popupSetTime" class="form_select" title="설정시간">
							<option value="">선택</option>
							<option value="15">15</option>
							<option value="20">20</option>
							<option value="30">30</option>
						</select> 
						<i class="append">분</i>
					</span>
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doSaveSettingPopup();" class="btn btn_primary btn_modify_auth">등록</button>
	</div>
</div>
</form>
<script type="text/javascript">
	function isSettingPopupValid() {
		var popupFromYear = $('select[name="popupFromYear"] option:selected');
		
		if (isStringEmpty(popupFromYear.val())) {
			alert('변동년도를 선택해 주세요.');
			popupFromYear.focus();
			
			return false;
		}
		
		var popupFromMonth = $('select[name="popupFromMonth"] option:selected');
		
		if (isStringEmpty(popupFromMonth.val())) {
			alert('변동월을 선택해 주세요.');
			popupFromMonth.focus();
			
			return false;
		}
		
		var popupSetTime = $('select[name="popupSetTime"] option:selected');
		
		if (isStringEmpty(popupSetTime.val())) {
			alert('설정시간을 선택해 주세요.');
			popupSetTime.focus();
			
			return false;
		}
		
		return true;
	}

	function doSaveSettingPopup() {
		if (isSettingPopupValid()) {
			if (confirm('신규 상담시간을 등록 하시겠습니까?')) {
				var returnJson = $('#popupSettingForm').serializeObject();
				
				// 콜백
				layerPopupCallback(returnJson);
			}
		}
	}
</script>