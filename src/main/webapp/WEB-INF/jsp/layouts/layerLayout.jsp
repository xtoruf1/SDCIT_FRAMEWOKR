<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="modal-outer">
	<div class="modal-content">
		<div class="popContinent">
			<tiles:insertAttribute name="body" />
		</div>
	</div>
</div>
<div class="overlay"></div>
<script type="text/javascript">
	$(document).ready(function(){
		// MONTH PICKER
		jqueryMonthpicker('monthpicker');

		// DATE PICKER
		jqueryDatepicker('datepicker');
		$('.ui-datepicker-trigger').on('click', function(){
			$(this).datepicker('show');
		});

		// DOM 중복 아이디 체크
		// checkDuplicateDomId();

		// 쓰기권한
		if ('${pageModifyYn}' == 'Y') {
			$('.btn_modify_auth').removeClass('hide');
		} else if ('${user.infoCheckYn}' == 'N') {
			$('.btn_modify_auth').removeClass('hide');
		} else if ('${pageModifyYn}' == 'N') {
			$('.btn_modify_auth').addClass('hide');
		}
	});

	function closeLayerPopup() {
		$('body').removeClass('hiddenScroll');
		// timestamp로 내림차순 중 첫번째 요소를 가져온다.(shift는 원본 요소에서 사라지기 때문에 레이어 팝업 닫기에 사용했다.)
		var config = popupConfig.sort(function(a, b){
			return b['timestamp'] - a['timestamp'];
		}).shift();

		if (config) {
			// 레이어 정보를 삭제한다.
			$('#modalLayerPopup' + config.timestamp).remove();
		}
	}
</script>