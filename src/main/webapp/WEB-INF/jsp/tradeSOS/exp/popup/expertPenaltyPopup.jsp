<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="popupPenaltyForm" name="popupPenaltyForm" method="post" onsubmit="return false;">
<input type="hidden" id="popupPenaltyId" name="popupPenaltyId" value="" />
<div style="width: 700px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">전문가 패널티 부여</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col />
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<tr>
				<th>전문가</th>
				<td colspan="3">
					<select id="popupExpertId" name="popupExpertId" class="form_select" title="전문가">
						<option value="">선택</option>
						<c:forEach var="list" items="${expertList}" varStatus="status">
							<option value="${list.expertId}">${list.expertNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>발생사유</th>
				<td colspan="3">
					<input type="text" id="popupPenaltyReason" name="popupPenaltyReason" value="" maxlength="100" class="form_text w100p" title="발생사유" />
				</td>
			</tr>
			<tr>
				<th>발생일자</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="popupPenaltyDate" name="popupPenaltyDate" value="" class="txt datepicker" placeholder="발생일자" title="발생일자" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
						</span>
						<button type="button" onclick="setPopupDefaultPickerValue('popupPenaltyDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
				<th>패널티</th>
				<td>
					<input type="text" id="popupPenaltyScore" name="popupPenaltyScore" value="" onkeyup="this.value=this.value.replace(/[^0123456789\-]/g, '');" class="form_text w100p" title="패널티" />
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<c:choose>
			<c:when test="${empty param.penaltyId}">
				<button type="button" onclick="doSavePenaltyPopup();" class="btn btn_primary btn_modify_auth">등록</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doSavePenaltyPopup();" class="btn btn_primary btn_modify_auth">수정</button>
				<button type="button" onclick="doDeletePenaltyPopup();" class="btn btn_secondary btn_modify_auth">삭제</button>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function() {
		$('#popupPenaltyId').val('${param.penaltyId}')
		<c:if test="${not empty param.expertId}">
			$('#popupExpertId').val('${param.expertId}').prop('selected', true);
			$('#popupExpertId').prop('disabled', true);
		</c:if>
		$('#popupPenaltyReason').val('${param.penaltyReason}');
		<c:if test="${not empty param.penaltyDate}">
			datepickerById('popupPenaltyDate', null);
			$('#popupPenaltyDate').datepicker('setDate', new Date('${fn:substring(param.penaltyDate, 0, 4)}-${fn:substring(param.penaltyDate, 4, 6)}-${fn:substring(param.penaltyDate, 6, 8)}'));
		</c:if>
		$('#popupPenaltyScore').val('${param.penaltyScore}');
	});

	function isPenaltyPopupValid() {
		var popupExpertId = $('select[name="popupExpertId"] option:selected');
		
		if (isStringEmpty(popupExpertId.val())) {
			alert('전문가를 선택해 주세요.');
			popupExpertId.focus();
			
			return false;
		}
		
		if (isStringEmpty($('#popupPenaltyReason').val())) {
			alert('발생사유를 입력해 주세요.');
			$('#popupPenaltyReason').focus();
			
			return false;
		}
		
		if (isStringEmpty($('#popupPenaltyDate').val())) {
			alert('발생일자를 입력해 주세요.');
			$('#popupPenaltyDate').focus();
			
			return false;
		}
		
		if (isStringEmpty($('#popupPenaltyScore').val())) {
			alert('패널티를 입력해 주세요.');
			$('#popupPenaltyScore').focus();
			
			return false;
		}
		
		return true;
	}

	function doSavePenaltyPopup() {
		if (isPenaltyPopupValid()) {
			var msg = '해당 전문가에게 패널티를 부여 하시겠습니까?';
			
			<c:if test="${not empty param.penaltyId}">
				msg = '해당 전문가의 패널티를 수정 하시겠습니까?';
			</c:if>
			
			if (confirm(msg)) {
				var returnJson = $('#popupPenaltyForm').serializeObject();
				
				returnJson['action'] = 'IU';
				
				// 콜백
				layerPopupCallback(returnJson);
			}
		}
	}
	
	function doDeletePenaltyPopup() {
		if (confirm('해당 전문가의 패널티를 삭제 하시겠습니까?')) {
			var returnJson = {};
			
			returnJson['penaltyId'] = $('#popupPenaltyId').val(); 
			returnJson['action'] = 'D';
			
			// 콜백
			layerPopupCallback(returnJson);	
		}
	}
	
	function setPopupDefaultPickerValue(objId) {
		$('#' + objId).val('${lastMonth}');
		
		<c:choose>
			<c:when test="${empty param.penaltyDate}">
				$('#' + objId).val('');
			</c:when>
			<c:otherwise>
				$('#' + objId).val('${fn:substring(param.penaltyDate, 0, 4)}-${fn:substring(param.penaltyDate, 4, 6)}-${fn:substring(param.penaltyDate, 6, 8)}');
			</c:otherwise>
		</c:choose>
	}
</script>