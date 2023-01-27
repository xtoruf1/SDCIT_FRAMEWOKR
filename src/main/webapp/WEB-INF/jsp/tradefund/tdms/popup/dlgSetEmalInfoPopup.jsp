<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="emailPopupForm" name="emailPopupForm" method="post" onsubmit="return false;">
<div style="width: 750px;height: 730px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">E-Mail양식 설정</h2>
		<div class="ml-auto">
			<button type="button" onclick="doEmailInfoPopupSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="doEmailInfoPopupSearch();" class="btn_sm btn_primary">검색</button>
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
				<th>포상년도</th>
				<td>
					<select name="searchPraYear" onchange="doSearchSelecYear();" class="form_select" style="width: 25%;" title="포상년도">
						<option value="">선택</option>
						<c:forEach var="item" items="${yearList}" varStatus="status">
							<option value="<c:out value="${item.praYear}" />" <c:if test="${param.searchPraYear eq item.praYear}">selected="selected"</c:if>><c:out value="${item.praYear}" /></option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 20%;" />
					<col />
				</colgroup>
				<tr>
					<th>년도</th>
					<td><input type="text" name="praYear" value="<c:out value="${awd0093t.praYear}" />" maxlength="4" class="form_text" style="width: 25%;" title="년도" numberOnly /></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="title" value="<c:out value="${awd0093t.title}" />" maxlength="200" class="form_text w100p" title="제목" /></td>
				</tr>
				<tr>
					<th>발신</th>
					<td><input type="text" name="sender" value="<c:out value="${awd0093t.sender}" />" maxlength="500" class="form_text w100p" title="발신" /></td>
				</tr>
				<tr>
					<th>무역의 날 행사</th>
					<td><input type="text" name="tradedayDate" value="<c:out value="${awd0093t.tradedayDate}" />" maxlength="200" class="form_text w100p" title="무역의 날 행사" /></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 20%;" />
					<col />
				</colgroup>
				<tr>
					<th>포상배포일시</th>
					<td><input type="text" name="deployDate" value="<c:out value="${awd0093t.deployDate}" />" maxlength="200" class="form_text w100p" title="포상배포일시" /></td>
				</tr>
				<tr>
					<th>포상배포장소</th>
					<td><input type="text" name="deployPlace" value="<c:out value="${awd0093t.deployPlace}" />" maxlength="500" class="form_text w100p" title="포상배포장소" /></td>
				</tr>
				<tr>
					<th>수령자지참물</th>
					<td><input type="text" name="bringReceipt" value="<c:out value="${awd0093t.bringReceipt}" />" maxlength="bringReceipt" class="form_text w100p" title="수령자지참물" /></td>
				</tr>
				<tr>
					<th>인수증 출력방법</th>
					<td><input type="text" name="receiptsPrint" value="<c:out value="${awd0093t.receiptsPrint}" />" maxlength="200" class="form_text w100p" title="인수증 출력방법" /></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 20%;" />
					<col />
				</colgroup>
				<tr>
					<th>지방소재</th>
					<td><input type="text" name="localReceipt" value="<c:out value="${awd0093t.localReceipt}" />" maxlength="500" class="form_text w100p" title="지방소재 인수방법" /></td>
				</tr>
				<tr>
					<th>서울소재</th>
					<td><input type="text" name="seoulReceipt" value="<c:out value="${awd0093t.seoulReceipt}" />" maxlength="500" class="form_text w100p" title="서울소재 인수방법" /></td>
				</tr>
				<tr>
					<th>참고사항<br />(<span id="textCnt1">0</span> / 2000)</th>
					<td>
						<textarea name="remark" index="1" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="참고사항"><c:out value="${awd0093t.remark}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		var f = document.emailPopupForm;

		$('#emailPopupForm #textCnt1').text(f.remark.value.length);
	});

	function doSearchSelecYear() {
		var f = document.emailPopupForm;

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/popup/dlgSetEmalInfoList.do" />'
			, data : {
				searchPraYear : f.searchPraYear.value
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if (data.resultInfo) {
					var resultInfo = data.resultInfo;

					f.praYear.value = (resultInfo.praYear || '');
					f.title.value = (resultInfo.title || '');
					f.sender.value = (resultInfo.sender || '');
					f.tradedayDate.value = (resultInfo.tradedayDate || '');

					f.deployDate.value = (resultInfo.deployDate || '');
					f.deployPlace.value = (resultInfo.deployPlace || '');
					f.bringReceipt.value = (resultInfo.bringReceipt || '');
					f.receiptsPrint.value = (resultInfo.receiptsPrint || '');

					f.localReceipt.value = (resultInfo.localReceipt || '');
					f.seoulReceipt.value = (resultInfo.seoulReceipt || '');
					f.remark.value = (resultInfo.remark || '');

					$('#emailPopupForm #textCnt1').text(f.remark.value.length);
				}
			}
		});
	}

	function textareaChk(obj, limit) {
		if (window.event) {
			key = window.event.keyCode;
		} else if (e) {
			key = e.which;
		} else {
			return true;
		}

	    keychar = String.fromCharCode(key);

	    var textareaLength = obj.value.length;
	    var index = obj.getAttribute('index');

		$('#emailPopupForm #textCnt' + index).text(textareaLength > limit ? limit : textareaLength);

	    if (textareaLength > limit) {
	    	alert(limit + '자 이상 입력하실 수 없습니다.');
	    	obj.value = obj.value.substring(0, (limit - 1));

	    	return;
		}
	}

	function inputTextOnFocus(obj) {
		$(obj).css('border', '1px solid');
		$(obj).css('border-color', '#03a1fc');
	}

	function inputTextOutFocus(obj) {
		$(obj).css('border', '1px solid');
		$(obj).css('border-color', '#cccccc');
	}

	function doEmailInfoPopupSave() {
		var f = document.emailPopupForm;

		if (!doValidFormRequired(f)) {
			return;
		}

		if (confirm('저장 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tdms/popup/saveDlgSetEmalInfo.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : $('#emailPopupForm').serialize()
				, async : true
				, spinner : true
				, success : function(data){
				}
			});
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>