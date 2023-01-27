<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="popupConsultForm" name="popupConsultForm" method="post" onsubmit="return false;">
<input type="hidden" name="aiNo" value="${resultInfo.aiNo}" />
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">[&#35; ${param.aiNo}] 데이터 상세</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<div class="tbl_opt">
			<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col />
				<col style="width: 20%;" />
				<col />
			</colgroup>
			<tr>
				<th>상담서비스</th>
				<td colspan="3">${resultInfo.consultService}</td>
			</tr>
			<tr>
				<th>상담분야</th>
				<td>${resultInfo.consultTypeNm}</td>
				<th>데이터 구분</th>
				<td>${resultInfo.dataGb}</td>
			</tr>
			<tr>
				<th>공개여부 <strong class="point">*</strong></th>
				<td>
					<select id="openFg" name="openFg" class="form_select" title="공개여부">
						<option value="Y" <c:if test="${resultInfo.openFg eq 'Y'}">selected="selected"</c:if>>Y</option>
						<option value="N" <c:if test="${resultInfo.openFg eq 'N'}">selected="selected"</c:if>>N</option>
					</select>
				</td>
				<th>Data 사용여부 <strong class="point">*</strong></th>
				<td>
					<select id="useYn" name="useYn" onchange="showSaveButton();" class="form_select" title="Data 사용여부">
						<option value="" <c:if test="${resultInfo.useYn eq ''}">selected="selected"</c:if>>NULL</option>
						<option value="Y" <c:if test="${resultInfo.useYn eq 'Y'}">selected="selected"</c:if>>Y</option>
						<option value="N" <c:if test="${resultInfo.useYn eq 'N'}">selected="selected"</c:if>>N</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>신청자</th>
				<td>${resultInfo.reqUserNm}</td>
				<th>전문가</th>
				<td>${resultInfo.ansExpertNm}</td>
			</tr>
			<tr>
				<th>신청일자</th>
				<td>${resultInfo.reqCreDt}</td>
				<th>답변일자</th>
				<td>${resultInfo.ansCreDt}</td>
			</tr>
			<tr>
				<th>검수일자</th>
				<td colspan="3">${resultInfo.inspectUpdDt}</td>
			</tr>
		</table>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tr>
					<th>제목</th>
					<td>${resultInfo.reqTitle}</td>
				</tr>
				<tr>
					<th>질문 <strong class="point">*</strong></th>
					<td>
						<textarea id="reqContent" name="reqContent" rows="5" class="form_textarea" style="width: 100%;"><c:out value="${common:reverseXss(resultInfo.reqContent)}" escapeXml="false" /></textarea>
					</td>
				</tr>
				<tr>
					<th>답변 <strong class="point">*</strong></th>
					<td>
						<textarea id="ansContent" name="ansContent" rows="5" class="form_textarea" style="width: 100%;"><c:out value="${common:reverseXss(resultInfo.ansContent)}" escapeXml="false" /></textarea>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="btn_group mt-20 _center">
		<button type="button" id="consultSave" onclick="doDetailSave();" class="btn btn_primary btn_modify_auth">저장</button>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		showSaveButton();
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function showSaveButton() {
		var useYn = $('#useYn option:selected').val();

		if (useYn == '') {
			$('#consultSave').addClass('disabled');
			$('#consultSave').attr('disabled', true);
		} else {
			$('#consultSave').removeClass('disabled');
			$('#consultSave').attr('disabled', false);
		}
	}

	function doDetailSave() {
		var useYn = $('#openFg option:selected');

		if (isStringEmpty($('#openFg').val())) {
			alert('공개여부를 선택해 주세요.');
			$('#openFg').focus();

			return false;
		}

		var useYn = $('#useYn option:selected');

		if (isStringEmpty($('#useYn').val())) {
			alert('Data 사용여부를 선택해 주세요.');
			$('#useYn').focus();

			return false;
		}

		if (isStringEmpty($('#reqContent').val())) {
			alert('질문을 입력해 주세요.');
			$('#reqContent').focus();

			return false;
		}

		if (isStringEmpty($('#ansContent').val())) {
			alert('답변을 입력해 주세요.');
			$('#ansContent').focus();

			return false;
		}

		if (confirm('검수 데이터를 저장 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/com/saveAiConsultCheckData.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : $('#popupConsultForm').serialize()
				, async : true
				, spinner : true
				, success : function(data){
					// 콜백
					layerPopupCallback();
				}
			});
		}
	}
</script>