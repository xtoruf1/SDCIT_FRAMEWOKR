<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">공통 팝업</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_primary">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<!-- 팝업 내용 -->
<div class="popup_body">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tr>
			<th>제목</th>
			<td><input type="text" class="form_text w100p"></td>
		</tr>
		<tr>
			<th>수정권한</th>
			<td><span id="popup1Modify"></span></td>
		</tr>
		<tr>
			<th>기능</th>
			<td>
				<button type="button" onclick="openCommonPopup2();" class="btn_tbl" style="cursor: pointer;">샘플 레이어2</button>
				<button type="button" onclick="doLayerDataSave1();" class="btn_tbl" style="cursor: pointer;">선택완료1</button>
			</td>
		</tr>
	</table>
</div>

<!-- 팝업 버튼 -->
<div class="btn_group mt-20 _center">
	<a href="" class="btn btn_secondary">저장</a>
</div>

<script type="text/javascript">
	// 샘플 레이어2 팝업
	function openCommonPopup2() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/common/popup/searchPopup2.do" />'
			, callbackFunction : function(resultObj){
				alert('샘플 레이어2의 콜백');
				alert(resultObj);
			}
		});
	}

	function doLayerDataSave1() {
		// 콜백
		var returnObj = '공통 팝업1';
		layerPopupCallback(returnObj);
		
		// 레이어 닫기
		closeLayerPopup();
	}
</script>