<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">상담예약 취소</h2>
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
			</colgroup>
			<tr>
				<th>작성자</th>
				<td>${result.reqNm}</td>
			</tr>
			<tr>
				<th>예약일시</th>
				<td>
					${fn:substring(result.rsrvDate, 0, 4)}-${fn:substring(result.rsrvDate, 4, 6)}-${fn:substring(result.rsrvDate, 6, 8)}
					${fn:substring(result.rsrvTime, 0, 2)}:${fn:substring(result.rsrvTime, 2, 4)}
				</td>
			</tr>
			<tr>
				<th>전문분야</th>
				<td>${result.consultTypeNm}</td>
			</tr>
			<tr>
				<th>상담채널</th>
				<td>${result.consultChannelNm}</td>
			</tr>
			<tr>
				<th>취소사유</th>
				<td>
					<input type="text" id="popupCancelReason" name="popupCancelReason" value="" maxlength="100" class="form_text w100p" placeholder="취소사유를 입력해 주세요." title="취소사유" />
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doCancelConsultAdmin('${result.prvtConsultId}');" class="btn btn_primary btn_modify_auth">상담 예약 취소</button>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
		$('#popupCancelReason').focus();
	});

	function doCancelConsultAdmin(consultId) {
		if ($('#popupCancelReason').val() == '') {
			alert('취소사유를 입력해 주세요.');
			
			$('#popupCancelReason').focus();
			
			return;	
		}
				
		if (confirm('예약취소 상태로 변경 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/cancelPrvtConsult.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					prvtConsultId : consultId
					, statusCd : '06'
					, countYn : 'N'
					, cancelReason : $('#popupCancelReason').val()
				}
				, async : true
				, spinner : true
				, success : function(data){
					layerPopupCallback();
				}
			});
		}
	}
</script>