<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="width: 500px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">추천서 승인일자를 입력하세요.</h2>
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
				<th>추천일</th>
				<td>
					<span class="form_datepicker">
						<input type="text" id="appDate" name="appDate" value="" class="txt datepicker" placeholder="추천일" title="추천일" readonly="readonly" />
						<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
					</span>
				</td>
			</tr>
			<tr>
				<th>발급부서</th>
				<td>
					<select id="deptCd" name="deptCd" class="form_select">
						<option value="">선택</option>
						<c:forEach var="list" items="${deptCdList}" varStatus="status">
						<option value="${list.code}">${list.codeNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<button type="button" onclick="doApply();" class="btn btn_primary btn_modify_auth">추천서 승인</button>
	</div>
</div>
<script type="text/javascript">

	//승인 밸리데이션
	function isValid() {
		if ( $('#appDate').val() == '' ) {
			alert('추천일을 선택해 주세요.');
			$('#appDate').focus();
			return false;
		}else if( $('#deptCd').val() == '' ){
			alert('발급부서를 선택해 주세요.');
			$('#deptCd').focus();
			return false;
		}
		return true;
	}

	//추천서 승인
	function doApply() {
		if (isValid()) {
			if (confirm('추천서를 승인 하시겠습니까?')) {
				global.ajax({
					url : '<c:url value="/issue/recommend/applyForeignVisa.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : {
						foreignVisaId : '${param.foreignVisaId}'
						,certMngId : '${param.certMngId}'
						,appDate : $('#appDate').val()
						,deptCd : $('#deptCd').val()
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

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	//오늘 날짜를 디폴트 값으로 넣음
	$(document).ready(function() {

		var today = new Date();

		var year = today.getFullYear();
		var month = ('0' + (today.getMonth() + 1)).slice(-2);
		var day = ('0' + today.getDate()).slice(-2);

		var dateString = year + '-' + month  + '-' + day;

		$('#appDate').val(dateString);
	});
</script>