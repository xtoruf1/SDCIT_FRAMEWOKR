<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 500px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">불용어 사전 등록</h2>
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
				<th>키워드</th>
				<td>
					<input type="text" id="stopword" name="stopword" value="" class="form_text w300p" title="불용어" maxlength="25" />
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doSave();" class="btn btn_primary btn_modify_auth">등록</button>
	</div>
</div>
<script type="text/javascript">

	//등록 밸리데이션
	function isValid() {
		if ( $('#stopword').val() == '' ) {
			alert('불용어를 입력해 주세요.');
			$('#stopword').focus();
			return false;
		}
		return true;
	}

	function doCheckData() {
		if (isValid()) {

			global.ajax({
				url : '<c:url value="/tradePro/stopword/selectTradeProStopWordDupCount.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					stopword : $('#stopword').val()
				}
				, async : true
				, spinner : true
				, success : function(data){
					if(data.dupCnt == '0') {
						doSave();
					}else {
						alert('이미 등록된 키워드 입니다.');
					}
				}
			});
		}
	}

	function doSave() {
		if (isValid()) {
			if (confirm('불용어를 등록 하시겠습니까?')) {
				global.ajax({
					url : '<c:url value="/tradePro/stopword/insertTradeProStopWord.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : {
						stopword : $('#stopword').val()
					}
					, async : true
					, spinner : true
					, success : function(data){
						if(data.dupCnt != '0') {
							alert('이미 등록된 키워드 입니다.');
						}else {
							// 콜백
							layerPopupCallback();
						}

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