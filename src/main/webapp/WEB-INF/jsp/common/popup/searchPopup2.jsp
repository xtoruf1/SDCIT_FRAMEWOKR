<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<h2 style="margin: 0px;">공통 팝업2</h2>
<div style="width: 500px;height: 300px;">
	<div style="text-align: center;">
		<div style="margin-top: 30px;">
			공통 팝업2
			<br />
			공통 팝업2
			<br />
			공통 팝업2
			<br />
			공통 팝업2
			<br />
			공통 팝업2
			<br />
			<br />
			<br />
			수정권한 : <span id="popup2Modify"></span>
		</div>
		<div class="btnAlign" style="margin-top: 100px;">
			<span class="aCenter">
				<button type="button" onclick="doLayerDataSave2();" class="btnBlue" style="cursor: pointer;">선택완료2</button>
			</span>
		</div>
	</div>
</div>
<script type="text/javascript">
	function doLayerDataSave2() {
		// 콜백
		var returnObj = '공통 팝업2';
		layerPopupCallback(returnObj);
		
		// 레이어 닫기
		closeLayerPopup();
	}
</script>