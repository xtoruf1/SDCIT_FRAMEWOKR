<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 500px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">반려사유를 입력하세요.</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 30%;" />
				<col />
			</colgroup>
			<tr>
				<th>반려사유</th>
				<td>
					<textarea id="rejectDscr" name="rejectDscr" rows="5" class="form_textarea"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doReject();" class="btn btn_primary btn_modify_auth">신청서 반려</button>
	</div>
</div>
<script type="text/javascript">

	//반려 밸리데이션
	function isValid() {
		if ( $('#rejectDscr').val() == '' ) {
			alert('반려사유를 작성해 주세요.');
			$('#rejectDscr').focus();
			return false;
		}
		return true;
	}

	//신청서 반려
	function doReject() {
		if (isValid()) {
			if (confirm('신청서를 반려 하시겠습니까?')) {
				global.ajax({
					url : '<c:url value="/issue/cert/rejectCloseExportTop.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : {
						awardClosureId : '${param.awardClosureId}'
						,certMngId : '${param.certMngId}'
						,rejectDscr : $('#rejectDscr').val()
					}
					, async : true
					, spinner : true
					, success : function(data){
						// 콜백
						layerPopupCallback();
					}
				});
			}
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>