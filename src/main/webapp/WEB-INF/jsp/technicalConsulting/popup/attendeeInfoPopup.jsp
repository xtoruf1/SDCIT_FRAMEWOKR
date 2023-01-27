<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div style="padding:20px;">
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">참석자 정보</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closePopup();">닫기</button>
	</div>
</div>
<form id="attendInfoForm" name="attendInfoForm" action="post">
	<input type="hidden"  name="devCfrcId" value="<c:out value='${searchVO.devCfrcId}'/>"/>
	<input type="hidden"  name="applId" value="<c:out value='${searchVO.applId}'/>"/>
	<input type="hidden"  name="chargeName"value="<c:out value='${searchVO.chargeName}'/>"/>
	<input type="hidden"  name="qrCheckYn"value="<c:out value='${qrCheckYn}'/>"/>
	<input type="hidden"  name="success" id="success" value="<c:out value='${SUCCESS}'/>"/>
	<input type="hidden"  name="message" id="message" value="<c:out value='${MESSAGE}'/>"/>
	<div id="searchPop" class="layerPopUpWrap">
		<div class="layerPopUp">
			<div class="layerWrap attendeeInfo">
				<%--<h3 class="para_title no_bg">통역 요약 내역</h3>--%>
				<div class="box">
					<table class="formTable">
						<colgroup>
							<col width="35%" />
							<col/>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" >회사명</th>
								<td><c:out value="${searchVO.companyName}"/></td>
							</tr>
							<tr>
								<th scope="row" >대표자명</th>
								<td><c:out value="${searchVO.ceoName}"/></td>
							</tr>
							<tr>
								<th scope="row" >담당자명</th>
								<td><c:out value="${searchVO.chargeName}"/></td>
							</tr>
							<tr>
								<th scope="row" >담당자직책</th>
								<td><c:out value="${searchVO.chargePosition}"/></td>
							</tr>
							<tr>
								<th scope="row" >담당자연락처</th>
								<td><c:out value="${searchVO.chargePhone}"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_group mt-20 _center">
					<c:if test="${searchVO.attendYn eq 'N'}">
					<button type="button" class="btn btn_primary"  onclick="fn_AttendCnfrm();">참석확인</button>
					</c:if>
					<c:if test="${searchVO.attendYn eq 'Y'}">
					<button type="button" class="btn btn_primary disabled">이미 참석된 인원 입니다.</button>
					</c:if>
				</div>
			</div>
			<div class="layerFilter"></div>
		</div>
	</div>
</form>
</div>
<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

	});

	/**
	 * 참석 확인
	 */
	function fn_AttendCnfrm() {

		if (confirm('참석 확인 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/technicalConsulting/updateAttendCnfrm.do" />'
				, data: $('#attendInfoForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					alert(data.MESSAGE);
					closePopup();
					var qrChk = data.qrCheckYn;
					if( qrChk == 'N') {
						getList();
					}
				}
			});
		}
	}

	/**
	 * 레이어 팝업 닫기
	 */
	function closePopup() {
		$('body').removeClass('hiddenScroll');
		// timestamp로 내림차순 중 첫번째 요소를 가져온다.(shift는 원본 요소에서 사라지기 때문에 레이어 팝업 닫기에 사용했다.)
		var config = popupConfig.sort(function(a, b){
			return b['timestamp'] - a['timestamp'];
		}).shift();

		if (config) {
			// 레이어 정보를 삭제한다.
			$('#modalLayerPopup' + config.timestamp).remove();
		}

		$('#scanner').val("");
		$('#scanner').focus();
	}

</script>