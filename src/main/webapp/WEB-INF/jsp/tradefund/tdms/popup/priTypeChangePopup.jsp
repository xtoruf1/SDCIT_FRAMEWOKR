<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="priTypePopupForm" name="priTypePopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<input type="hidden" name="priType" value="<c:out value="${param.priType}" />" />
<input type="hidden" name="prvPriType" value="<c:out value="${param.prvPriType}" />" />
<div style="width: 500px;height: 220px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">신청구분 변경사유</h2>
		<div class="ml-auto">
			<button type="button" onclick="doPriTypePopupSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="doPriTypePopupCancel();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col />
			</colgroup>
			<tr>
				<td>
					<textarea name="hisResn" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="변경사유"></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	function doPriTypePopupSave() {
		var f = document.priTypePopupForm;

		if (f.hisResn.value == '' || f.hisResn.value == null) {
			alert('신청구분 변경사유를 입력해 주세요.');
			f.hisResn.focus();

			return;
		}

		global.ajax({
			url : '<c:url value="/tdms/popup/savePriTypeUpdateResn.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : $('#priTypePopupForm').serialize()
			, async : true
			, spinner : true
			, success : function(data){
				var returnObj = {
					check : 'save'
				}

				// 콜백
				layerPopupCallback(returnObj);
			}
		});
	}

	function doPriTypePopupCancel() {
		var returnObj = {
			check : 'cancel'
		}

		// 콜백
		layerPopupCallback(returnObj);
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>