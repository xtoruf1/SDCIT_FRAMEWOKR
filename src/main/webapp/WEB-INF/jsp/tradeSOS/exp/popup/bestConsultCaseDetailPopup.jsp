<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 1000px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">BEST상담사례 상세</h2>
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
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<tr>
				<th>제목</th>
				<td colspan="5">
					${resultInfo.reqTitle}
					<input type="hidden" id="consultCd" value="${resultInfo.consultCd}" />
					<input type="hidden" id="consultId" value="${resultInfo.consultId}" />
					<input type="hidden" id="answerId" value="${resultInfo.answerId}" />
				</td>
			</tr>
			<tr>
				<th>구분</th>
				<td>
					${resultInfo.consultService}
				</td>
				<th>상담 채널</th>
				<td>
					${resultInfo.consultChannel}
				</td>
				<th>상담 분야</th>
				<td>
					${resultInfo.consultTypeNm}
				</td>
			</tr>
			<tr>
				<th>신청자</th>
				<td>
					${resultInfo.reqUserNm}
				</td>
				<th>답변수</th>
				<td>
					${resultInfo.answerCnt}
				</td>
				<th>조회수</th>
				<td>
					${resultInfo.viewCnt}
				</td>
			</tr>
			<tr>
				<th>상담 일자</th>
				<td colspan="5">
					${resultInfo.reqDate}
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="5">
					<div id="htmlReqContent"><c:out value="${resultInfo.reqContent}" escapeXml="false" /></div>
					<div id="editReqContent"><textarea id="reqContent" rows="10" class="form_textarea" style="width: 100%;"><c:out value="${resultInfo.textReqContent}" escapeXml="false" /></textarea></div>
				</td>
			</tr>
		</table>
		<div class="flex">
			<h3 style="margin-top: 20px;">답변 내역</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tr>
					<th>전문가</th>
					<td>${resultInfo.expertNm}</td>
					<th>상담 분야</th>
					<td>${resultInfo.exptCnstTys}</td>
				</tr>
				<tr>
					<th>채택 여부</th>
					<td>${resultInfo.chooseYn}</td>
					<th>답변일자</th>
					<td>${resultInfo.ansDate}</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<div id="htmlAnsContent"><c:out value="${resultInfo.ansContent}" escapeXml="false" /></div>
						<div id="editAnsContent"><textarea id="ansContent" rows="10" class="form_textarea" style="width: 100%;"><c:out value="${resultInfo.textAnsContent}" escapeXml="false" /></textarea></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="btn_group mt-20 _center">
		<button type="button" id="chooseCaseSave" onclick="doChangeModify();" class="btn btn_primary btn_modify_auth">수정</button>
		<button type="button" id="chooseCaseCancel" onclick="doChangeCancel();" class="btn btn_secondary" style="display: none;">취소</button>
	</div>
</div>
<script type="text/javascript">
	var editorObject = [];
	$(document).ready(function(){
		<c:if test="${resultInfo.consultCd eq '2'}">
			// 상담신청 에디터 생성
			nhn.husky.EZCreator.createInIFrame({
				oAppRef : editorObject
				, elPlaceHolder : 'reqContent'
				, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
				, htParams : {
					// 툴바 사용 여부 (true : 사용 / false : 사용하지 않음)
					bUseToolbar : true
					// 입력창 크기 조절바 사용 여부 (true : 사용 / false : 사용하지 않음)
					, bUseVerticalResizer : true
					// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true : 사용 / false : 사용하지 않음)
					, bUseModeChanger : true
					, fOnBeforeUnload : function(){
					}
				}
				, fOnAppLoad : function(){
					editorObject.getById['reqContent'].exec('SET_IR', ['']);
					editorObject.getById['reqContent'].exec('PASTE_HTML', ['<c:out value="${resultInfo.reqContent}" escapeXml="false" />']);
				}
				, fCreator : 'createSEditor2'
			});

			// 상담답변 에디터 생성
			nhn.husky.EZCreator.createInIFrame({
				oAppRef : editorObject
				, elPlaceHolder : 'ansContent'
				, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
				, htParams : {
					// 툴바 사용 여부 (true : 사용 / false : 사용하지 않음)
					bUseToolbar : true
					// 입력창 크기 조절바 사용 여부 (true : 사용 / false : 사용하지 않음)
					, bUseVerticalResizer : true
					// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true : 사용 / false : 사용하지 않음)
					, bUseModeChanger : true
					, fOnBeforeUnload : function(){
					}
				}
				, fOnAppLoad : function(){
					editorObject.getById['ansContent'].exec('SET_IR', ['']);
					editorObject.getById['ansContent'].exec('PASTE_HTML', ['<c:out value="${resultInfo.ansContent}" escapeXml="false" />']);
				}
				, fCreator : 'createSEditor2'
			});
		</c:if>

		$('#htmlReqContent').show();
		$('#editReqContent').hide();
		$('#htmlAnsContent').show();
		$('#editAnsContent').hide();
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function doChangeModify() {
		$('.class_smarteditor2').css('height', '341px'); 								// 스마트 에디터 height 지정
		$('.class_smarteditor2').attr('src', $('.class_smarteditor2').attr('src'));		// 스마트 에디터 iframe 새로고침

		$('#htmlReqContent').hide();
		$('#editReqContent').show();
		$('#htmlAnsContent').hide();
		$('#editAnsContent').show();

		$('#chooseCaseSave').removeAttr('onclick');
		$('#chooseCaseSave').attr('onclick', 'doAnsContentUpdate();')
		$('#chooseCaseSave').text('저장');
		$('#chooseCaseCancel').show();
	}

	function doChangeCancel() {
		$('#htmlReqContent').show();
		$('#editReqContent').hide();
		$('#htmlAnsContent').show();
		$('#editAnsContent').hide();

		$('#chooseCaseSave').removeAttr('onclick');
		$('#chooseCaseSave').attr('onclick', 'doChangeModify();')
		$('#chooseCaseSave').text('수정');
		$('#chooseCaseCancel').hide();
	}

	function doAnsContentUpdate() {
		<c:if test="${resultInfo.consultCd eq '2'}">
			editorObject.getById['reqContent'].exec('UPDATE_CONTENTS_FIELD', []);
			editorObject.getById['ansContent'].exec('UPDATE_CONTENTS_FIELD', []);
		</c:if>

		if (isStringEmpty($('#reqContent').val())) {
			alert('상담 내용을 입력해 주세요.');
			$('#reqContent').focus();

			return false;
		}

		if (isStringEmpty($('#ansContent').val())) {
			alert('답변 내용을 입력해 주세요.');
			$('#ansContent').focus();

			return false;
		}

		if (confirm('상담/답변 내용을 저장 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/saveBestCaseReqAnsContent.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					consultCd : $('#consultCd').val()
					, consultId : $('#consultId').val()
					, answerId : $('#answerId').val()
					, requestContent : $('#reqContent').val()
					, answerContent : $('#ansContent').val()
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
</script>