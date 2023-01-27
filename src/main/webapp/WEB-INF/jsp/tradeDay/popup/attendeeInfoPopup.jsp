<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div style="padding:20px;">
<!-- 팝업 타이틀 -->
<div class="flex">
	<c:choose>
		<c:when test="${searchVO.attendTypeCd eq 'VIP'}">
			<h2 class="popup_title">VIP 정보</h2>
		</c:when>
		<c:otherwise>
			<h2 class="popup_title">참석자 정보</h2>
		</c:otherwise>
	</c:choose>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closePopup();">닫기</button>
	</div>
</div>
<form id="attendInfoForm" name="attendInfoForm" action="post">
	<input type="hidden"  name="attendId" value="<c:out value='${searchVO.attendId}'/>"/>
	<input type="hidden"  name="applySeq" value="<c:out value='${searchVO.applySeq}'/>"/>
	<input type="hidden"  name="svrId"value="<c:out value='${searchVO.svrId}'/>"/>
	<input type="hidden"  name="qrCheckYn"value="<c:out value='${qrCheckYn}'/>"/>
	<input type="hidden"  name="scanner"value="<c:out value='${scanner}'/>"/>
	<input type="hidden"  name="attendName"value="<c:out value='${searchVO.attendName}'/>"/>
	<input type="hidden"  name="laureateName"value="<c:out value='${searchVO.laureateName}'/>"/>
	<input type="hidden"  name="success" id="success" value="<c:out value='${SUCCESS}'/>"/>
	<input type="hidden"  name="message" id="message" value="<c:out value='${MESSAGE}'/>"/>

		<c:choose>
			<c:when test="${searchVO.attendTypeCd eq 'VIP'}">
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
											<th scope="row" >VIP명</th>
											<td><c:out value="${searchVO.attendName}"/></td>
										</tr>
										<tr>
											<th scope="row" >주민(여권)번호</th>
											<td><c:out value="${searchVO.attendJuminNo}"/></td>
										</tr>
										<tr>
											<th scope="row" >연락처</th>
											<td><c:out value="${searchVO.attendPhone}"/></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_group mt-20 _center">
								<c:choose>
									<c:when test="${searchVO.useYn eq 'Y'}">
										<c:if test="${searchVO.attendYn eq 'N'}">
											<button type="button" class="btn btn_primary"  onclick="fnVipAttendCnfrm();">참석확인</button>
										</c:if>
										<c:if test="${searchVO.attendYn eq 'Y'}">
											<button type="button" class="btn btn_primary disabled">이미 참석된 인원 입니다.</button>
										</c:if>
									</c:when>
									<c:otherwise>
											<button type="button" class="btn btn_primary disabled" style="color:#EBFFFF; background-color: #e41212">참석불가한 인원 입니다.</button>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="layerFilter"></div>
					</div>
				</div>
			</c:when>
			<c:otherwise>
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
											<th scope="row" >수상종류</th>
											<td><c:out value="${searchVO.awardTypeNm}"/></td>
										</tr>
										<tr>
											<th scope="row" >수상자</th>
											<td><c:out value="${searchVO.laureateName}"/></td>
										</tr>
										<tr>
											<th scope="row" >참석자 / 관계</th>
											<td><c:out value="${searchVO.attendName}"/> / <c:out value="${searchVO.attendTypeNm}"/></td>
										</tr>
										<tr>
											<th scope="row" >주민(여권)번호</th>
										<c:if test="${searchVO.attendForeignCd == '01'}"> <%-- 01 : 국내인 / 02: 외국인--%>
											<td><c:out value="${searchVO.attendJuminNo}"/></td>
										</c:if>
										<c:if test="${searchVO.attendForeignCd == '02'}">
											<td><c:out value="${searchVO.passportNo}"/></td>
										</c:if>
										</tr>
										<tr>
											<th scope="row" >연락처</th>
											<td><c:out value="${searchVO.attendPhone}"/></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_group mt-20 _center">
								<c:choose>
									<c:when test="${searchVO.useYn eq 'Y'}">
										<c:if test="${searchVO.attendYn eq 'N'}">
											<button type="button" class="btn btn_primary"  onclick="fnAttendCnfrm();">참석확인</button>
										</c:if>
										<c:if test="${searchVO.attendYn eq 'Y'}">
											<button type="button" class="btn btn_primary disabled">이미 참석된 인원 입니다.</button>
										</c:if>
									</c:when>
									<c:otherwise>
											<button type="button" class="btn btn_primary disabled" style="color:#EBFFFF; background-color: #e41212">참석불가한 인원 입니다.</button>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="layerFilter"></div>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
</form>
</div>
<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

	});

	/**
	 * VIP 참석 확인
	 */
	function fnVipAttendCnfrm() {
		if (confirm('참석 확인 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/updateVipAttendCnfrm.do" />'
				, data: $('#attendInfoForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					alert(data.MESSAGE);
					closePopup();
					var scanner = data.scanner;

					if( scanner == 'Y') { // 스캐너 일때( 현황 갱신)
						window.location.reload(true);
					}
				}
			});
		}
	}

	/**
	 * 참석 확인
	 */
	function fnAttendCnfrm() {

		if (confirm('참석 확인 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/updateAttendCnfrm.do" />'
				, data: $('#attendInfoForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					alert(data.MESSAGE);
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