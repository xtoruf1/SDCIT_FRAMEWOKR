<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="flex">
	<h2 class="popup_title">예약자 정보</h2>
	<div class="ml-auto">
		<button type="button" onclick="" 	class="btn_sm btn_primary btn_modify_auth">참석 확인</a>
	</div>
	<div class="ml-15">
		<button type="button" onclick="closeLayerPopup()" 	class="btn_sm btn_secondary">닫기</a>
	</div>
</div>

<form name="submitForm" id="submitForm" method="post"  >

<div class="popup_body">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tr>
			<th>회사명</th>
			<td id="param1"></td>
		</tr>
		<tr>
			<th>신청자명</th>
			<td id="param2"></td>
		</tr>
		<tr>
			<th>연락처</th>
			<td id="param3"></td>
		</tr>
		<tr>
			<th>예약일시</th>
			<td id="param4"></td>
		</tr>
		<tr>
			<th>회의실</th>
			<td id="param5"></td>
		</tr>
		<tr>
			<th>화상대여</th>
			<td id="param6"></td>
		</tr>
	</table>
</div>

	<div>
		<button type="button" class="btn" onclick="closePopup();">참석 확인</button>
	</div>
</form>


<script type="text/javascript">
// 레이어팝 업업 크기조정
$(".modal-content").css("height", "auto");
$(".modal-content").css("max-width", "50%");

$(document).ready(function () {

	$("#param1").text($("#corpName").val());
	$("#param2").text($("#userNm").val());
	$("#param3").text($("#coHp1").val() +"-"+ $("#coHp2").val()+"-"+ $("#coHp3").val() );
	$("#param4").text( $("#useYmd").val() +"  "+ $("#useTime").val() );
	$("#param5").text($("#roomNumber").val());

	if ( $("input:checkbox[id='useOa_vce']").is(":checked") == true ){
		$("#param6").text("Y");
	}else{
		$("#param6").text("N");
	}

});

// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
$('.modal').on('click', function(e){
	if (!$(e.target).is($('.modal-content, .modal-content *'))) {
		closeLayerPopup();
	}
});

function closePopup() {
	closeLayerPopup();
}


</script>
