<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">통역 요약 내역</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<form id="popForm" name="popForm" action="post">
	<!-- 통역 요약 내역 팝업 -->
	<div id="searchPop" class="layerPopUpWrap">
		<div class="layerPopUp">
			<div class="layerWrap" style="width:700px;">
				<%--<h3 class="para_title no_bg">통역 요약 내역</h3>--%>
				<div class="box">
					<table class="boardwrite formTable">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">시작일</th>
								<td><c:out value="${applyDetailVO.interPreStartDate}"/></td>
								<th scope="row" style="text-align: left;padding-left: 20px;">종료일</th>
								<td><c:out value="${applyDetailVO.interPreEndDate}"/></td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">통역언어</th>
								<td><c:out value="${applyDetailVO.languageNm}"/></td>
								<th scope="row" style="text-align: left;padding-left: 20px;">장소</th>
								<td><c:out value="${applyDetailVO.interPrePlace}"/></td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">통역분야</th>
								<td colspan="3"><c:out value="${applyDetailVO.interPreTypeNm}"/></td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">소요시간</th>
								<td><c:out value="${applyDetailVO.orderInterPreTime}"/></td>
								<th scope="row" style="text-align: left;padding-left: 20px;">업체부담금</th>
								<td><c:out value="${applyDetailVO.selfSupportMoney}"/></td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">바우처지원금</th>
								<td><c:out value="${applyDetailVO.tradeSupportMoney}"/></td>
								<th scope="row" style="text-align: left;padding-left: 20px;">사용금액</th>
									<td>${applyDetailVO.selfSupportMoney + applyDetailVO.tradeSupportMoney}</td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">통지서발송</th>
								<td>
									<c:if test="${applyDetailVO.mailCnt > 0}">
										발송 ( ${applyDetailVO.mailCnt} 회)
									</c:if>
									<c:if test="${applyDetailVO.mailCnt == 0}">
										미발송
									</c:if>
								</td>
								<th scope="row" style="text-align: left;padding-left: 20px;">잠금설정여부</th>
								<td>
									<c:if test="${applyDetailVO.lockYn == 'Y'}">
										잠금중
									</c:if>
									<c:if test="${applyDetailVO.lockYn ne'Y'}">
										잠금 해제중
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_group align_ctr">
					<%--<button type="button" class="ui-button ui-widget ui-corner-all" onclick="">확인</button>--%>
					<%--<button type="button" class="ui-button ui-widget ui-corner-all" onclick="closePopup();">닫기</button>--%>
				</div>
				<button type="button" class="btn_pop_close" onclick="closePopup();"></button>
			</div>
			<div class="layerFilter"></div>
		</div>
	</div>
</form>
<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

	});

	function closePopup() {
		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = '공통 팝업1 ID : modalLayerPopup' + config.timestamp;
		config.callbackFunction(returnObj);

		// 레이어 닫기
		closeLayerPopup();
	}

</script>