<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 500px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">변경할 상담분야를 선택하세요.</h2>
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
				<th>상담분야</th>
				<td>
					<select id="popupConsultTypeCd" name="popupConsultTypeCd" class="form_select w100p" title="상담분야">
						<option value="">선택</option>
						<c:forEach var="item" items="${consultTypeList}" varStatus="status">
							<option value="${item.consultTypeCd}" <c:if test="${item.consultTypeCd eq param.consultTypeCd}">selected="selected"</c:if>>${item.consultTypeNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doChangeConsultType();" class="btn btn_primary btn_modify_auth">상담분야 변경</button>
	</div>
</div>
<script type="text/javascript">
	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function isConsultTypeValid() {
		var popupConsultTypeCd = $('select[name="popupConsultTypeCd"] option:selected');

		if (isStringEmpty(popupConsultTypeCd.val())) {
			alert('변경할 상담분야를 선택해 주세요.');
			popupConsultTypeCd.focus();

			return false;
		}

		return true;
	}

	function doChangeConsultType() {
		if (isConsultTypeValid()) {
			if (confirm('상담분야를 변경 하시겠습니까?')) {
				global.ajax({
					url : '<c:url value="/tradeSOS/exp/changePblcConsultType.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : {
						pblcConsultId : '${param.pblcConsultId}'
						, pblcTitle : '${param.pblcTitle}'
						, consultTypeCd : $('#popupConsultTypeCd').val()
						, consultTypeNm : $('#popupConsultTypeCd option:selected').text()
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
</script>