<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="padding:20px;">
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">수상자 정보</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closePopup();">닫기</button>
	</div>
</div>
<form id="pickupInfoForm" name="pickupInfoForm" action="post">
	<input type="hidden"  name="attendId" value="<c:out value='${resultData.attendId}'/>"/>
	<input type="hidden"  name="awardTypeCd" id="awardTypeCd" value="<c:out value='${searchVO.awardTypeCd}'/>"/>
	<input type="hidden"  name="awardType" id="awardType" value=""/>
	<input type="hidden"  name="applySeq" value="<c:out value='${resultData.applySeq}'/>"/>
	<input type="hidden"  name="svrId"value="<c:out value='${resultData.svrId}'/>"/>
	<input type="hidden"  name="laureateName"value="<c:out value='${resultData.laureateName}'/>"/>
	<input type="hidden"  name="scanner"value="<c:out value='${scanner}'/>"/>
	<input type="hidden"  name="attendName"value="<c:out value='${resultData.attendName}'/>"/>
	<input type="hidden"  name="success" id="success" value="<c:out value='${SUCCESS}'/>"/>
	<input type="hidden"  name="message" id="message" value="<c:out value='${MESSAGE}'/>"/>
	<input type="hidden"  name="pickupYn" id="pickupYn" value="<c:out value='${resultData.pickupYn }'/>"/>
	<input type="hidden"  name="qrChk" id="qrChk" value="<c:out value='${qrChk }' default='N'/>"/>
	<input type="hidden"  name="cancelYn" id="cancelYn" value=""/>

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
								<th scope="row" >접수번호</th>
								<td><c:out value="${resultData.receiptNo}"/></td>
							</tr>
							<tr>
								<th scope="row" >회사명</th>
								<td><c:out value="${resultData.companyName}"/></td>
							</tr>
					<%--		<tr>
								<th scope="row" >포상구분</th>
								<td><c:out value="${resultData.awardTypeNm}"/></td>
							</tr>--%>
							<tr>
								<th scope="row" >포상명</th>
								<td><c:out value="${resultData.prizeName}"/></td>
							</tr>
							<tr>
								<th scope="row" >수상자/연락처</th>
								<td><c:out value="${resultData.laureateName}"/> / <c:out value="${resultData.laureatePhone}"/></td>
							</tr>
						<c:if test="${not empty resultData.delegateName }">
							<c:if test="${resultData.laureateName != resultData.delegateName}">
							<tr>
								<th scope="row" >대리인/연락처</th>
								<td><c:out value="${resultData.delegateName}"/> / <c:out value="${resultData.delegatePhone}"/></td>
							</tr>
							<tr>
								<th scope="row" >주민(여권)번호</th>
								<td><c:out value="${resultData.delegateJuminNo}"/></td>
							</tr>
							</c:if>
						</c:if>
						</tbody>
					</table>
				</div>
				<div class="btn_group mt-20 _center">
					<%-- 개인포상 일 경우--%>
					<c:if test="${searchVO.awardType == 'P'}">
						<c:if test="${resultData.pickupYn eq 'N'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCnfrm();">수령확인</button>
						</c:if>
						<c:if test="${resultData.pickupYn eq 'Y'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCancel();" style="background-color: #EF3E33">수령취소</button>
						</c:if>
					</c:if>

					<%-- 수출의탑만 일 경우--%>
					<c:if test="${searchVO.awardType == 'TOP'}">
						<c:if test="${resultData.pickupYn eq 'N'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCnfrm('TOP', '');">수령확인</button>
						</c:if>
						<c:if test="${resultData.pickupYn eq 'Y'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCancel('TOP', '');" style="background-color: #EF3E33">수령취소</button>
						</c:if>
					</c:if>

					<%-- 수출의탑 및 50 일 경우 --%>
					<c:if test="${searchVO.awardType == 'T'}">
						<%-- 수출의탑 --%>
						<c:choose>
							<c:when test="${ resultData.pickupYn == 'N' or resultData.pickupYn == 'C'}">
								<button type="button" class="btn btn_primary"  onclick="fnPickupCnfrm('T', '');" style="padding-left: 15px; padding-right: 15px; text-align: center;">수출의탑 수령확인</button>
							</c:when>
							<c:when test="${ resultData.pickupYn == 'Y' or resultData.pickupYn == 'T'}">
								<button type="button" class="btn btn_primary"  onclick="fnPickupCancel('T', '');" style="background-color: #EF3E33; padding-left: 15px; padding-right: 15px; text-align: center;">수출의탑 수령취소</button>
							</c:when>
						</c:choose>
						<%-- 개인포상 --%>
						<c:if test="${resultData.pickupYn eq 'N' or resultData.pickupYn == 'T'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCnfrm('', 'P');" style="padding-left: 15px; padding-right: 15px; text-align: center;">개인포상 수령확인</button>
						</c:if>
						<c:if test="${resultData.pickupYn eq 'Y' or resultData.pickupYn == 'C'}">
							<button type="button" class="btn btn_primary"  onclick="fnPickupCancel('', 'P');" style="background-color: #EF3E33; padding-left: 15px; padding-right: 15px; text-align: center;">개인포상 수령취소</button>
						</c:if>
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

        setTimeout(function () {
            var qrChk = $('#qrChk').val();
            var awardTypeCdChk = $('#awardTypeCd').val();

			if(awardTypeCdChk == '50' || awardTypeCdChk == '10') {

			} else {
				//QR 진입 시
				if( qrChk == "Y") {
              		alert($('#message').val());
          		}
			}

	    }, 300);

	});

	/**
	 * 수령 확인
	 */
	function fnPickupCnfrm(topPickUp, selfPickUp) {
		var massge = "";
		var pickupYn = $('#pickupYn').val();
		var cancelYn = "N";

		if (topPickUp == 'T') {

			if (pickupYn == 'C') {
				$('#pickupYn').val("Y");
			} else if (pickupYn == 'N') {
				$('#pickupYn').val("T");
				$('#awardType').val("T");
			}

			massge = "수출의탑 포상을 수령 확인 하시겠습니까?";
		} else if(topPickUp == 'TOP') {
			$('#pickupYn').val("Y");
			$('#awardType').val("TOP");
			massge = "수출의탑 포상을 수령 확인 하시겠습니까?";
	    }else if(selfPickUp == 'P') {

			if( pickupYn == 'T') {
				$('#pickupYn').val("Y");
				$('#awardType').val("P");
			} else if( pickupYn == 'N') {
				$('#pickupYn').val("C");
				$('#awardType').val("P");
			}
			massge = "개인포상을 수령 확인 하시겠습니까?";
		} else {
			massge = "개인포상을 수령 확인 하시겠습니까?";
			$('#pickupYn').val("Y");
			$('#awardType').val("P");
		}

		if (confirm(massge)) {

			$('#cancelYn').val("N"); // 수령취소 아닐때

			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/updatePickupCnfrm.do"/>'
				, data: $('#pickupInfoForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					if( data.MESSAGE != null ){
						alert(data.MESSAGE);
					}

					layerPopupCallback(data);
					closePopup();

					var qrChk = data.qrCheckYn;
					var scanner = data.scanner;

					if( qrChk == 'N') { // 수동참석처리 일때(리스트갱신)
						getList();
					}

					if( scanner == 'Y') { // 스캐너 일때( 현황 갱신)
						window.location.reload(true);
					}
				}
			});
		}
	}

	/**
	 * 수령 취소
	 */
	function fnPickupCancel(topPickUp, selfPickUp) {

		var massge = "";
		var pickupYn = $('#pickupYn').val();
		var cancelYn = "N";

		if( topPickUp == 'T') {

			 if( pickupYn == 'T') {
				$('#pickupYn').val("N");
			} else if( pickupYn == 'Y') {
				$('#pickupYn').val("C");


			 }

			massge = "수출의탑 포상을 수령 취소 하시겠습니까?";
		} else if(selfPickUp == 'P') {

			 if( pickupYn == 'C') {
				$('#pickupYn').val("N");
			} else if( pickupYn == 'Y') {
				$('#pickupYn').val("T");
			 }
			massge = "개인포상을 수령 취소 하시겠습니까?";
		} else {
			massge = "개인포상을 수령 취소 하시겠습니까?";
			$('#pickupYn').val("N");
		}

		if (confirm(massge)) {

			$('#cancelYn').val("Y"); // 수령취소일때

			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/updatePickupCnfrm.do"/>'
				, data: $('#pickupInfoForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					$('#loading_wrapper').hide();
					if( data.MESSAGE != null ){
						alert(data.MESSAGE);
					}
					layerPopupCallback(data);
					closePopup();

					var qrChk = data.qrCheckYn;
					var scanner = data.scanner;

					if( qrChk == 'N') { // 수동참석처리 일때(리스트갱신)
						getList();
					}

					if( scanner == 'Y') { // 스캐너 일때( 현황 갱신)
						window.location.reload(true);
					}

				}
			});
		}
	}

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