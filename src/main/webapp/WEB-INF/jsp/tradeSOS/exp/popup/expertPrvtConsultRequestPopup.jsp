<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% 
	pageContext.setAttribute("cn", "\n");
%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<c:set var="rsrvDate" value="${fn:substring(result.rsrvDate, 0, 4)}-${fn:substring(result.rsrvDate, 4, 6)}-${fn:substring(result.rsrvDate, 6, 8)}" />
<form id="popupRegistForm" name="popupRegistForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="prvtConsultId" value="${result.prvtConsultId}" />
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">상담 상세</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col style="width: 40%;" />
				<col style="width: 15%;" />
				<col style="width: 30%;" />
			</colgroup>
			<tr>
				<th>예약시간</th>
				<td colspan="2" style="border-right-color: #fff;">${rsrvDate} ${fn:substring(result.rsrvTime, 0, 2)}:${fn:substring(result.rsrvTime, 2, 4)}</td>
				<td class="align_r"><button type="button" onclick="doSearchAiConsult('${replaceText}');" class="btn_tbl">AI 자문 확인</button></td>
			</tr>
			<tr>
				<th>신청자</th>
				<td>
					${result.reqNm}
					<c:if test="${not empty result.companyNm}">
						${result.companyNm}
					</c:if>
					<c:set var="currentDate" value="${nDate}" />
					<c:set var="rsrvDateTime" value="${result.rsrvDate}${result.rsrvTime}" />
					<c:choose>
						<c:when test="${result.consultChannel eq '03'}">
							(${result.cellPhone})
						</c:when>
						<c:when test="${result.consultChannel eq '01' or result.consultChannel eq '02'}">
							<c:if test="${currentDate gt rsrvDateTime}">
								(${result.cellPhone})
							</c:if>
						</c:when>
					</c:choose>
				</td>
				<th>상태</th>
				<td>${result.statusNm}</td>
			</tr>
			<tr>
				<th>상담분야</th>
				<td>${result.consultTypeNm}</td>
				<th>상담채널</th>
				<td>${fn:replace(result.consultChannelNm, "상담", "")}</td>
			</tr>
			<tr>
				<th>상담요지</th>
				<td colspan="3">${fn:replace(result.consultText, cn, "<br />")}</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td id="attachFieldList" colspan="3">
					<c:if test="${not empty result.reqOrgFileNm}">
						<div class="addedFile" style="margin-top: 10px;">
							<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${result.reqFileId}&fileSeq=${result.reqFileSeq}" class="filename">${result.reqOrgFileNm}</a>
							<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${result.reqFileId}&fileSeq=${result.reqFileSeq}', '${result.reqOrgFileNm}', 'membershipconsult_${profile}_${result.reqFileId}_${result.reqFileSeq}');" class="file_preview btn_tbl_border">
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</div>
					</c:if>
				</td>
			</tr>
			<!-- 취소사유 -->
			<c:if test="${result.statusCd eq '05' or result.statusCd eq '06'}">
				<tr>
					<th>취소사유</th>
					<td colspan="3">
						<c:if test="${not empty result.cancelReason}">
							${result.cancelReason}
						</c:if>
					</td>
				</tr>
			</c:if>
			<c:if test="${result.statusCd ne '03' and result.statusCd ne '05' and result.statusCd ne '09'}">
				<tr>
					<td colspan="4" class="align_ctr" style="height: 50px;border-left-color: #fff;border-right-color: #fff;border-bottom-color: #fff;">
						<fmt:parseDate var="currentD" value="${currentDate}" pattern="yyyyMMddHHmm" />
						<fmt:parseDate var="rsrvDT" value="${rsrvDateTime}" pattern="yyyyMMddHHmm" />
						<fmt:parseNumber var="startTime" value="${rsrvDT.time - (1000 * 60 * 5)}" integerOnly="true" />
						<fmt:parseNumber var="endTime" value="${rsrvDT.time + (1000 * 60 * 20)}" integerOnly="true" />
						<c:set var="isEnterConsult" value="N" />
						<c:if test="${currentD.time gt startTime}">
							<c:set var="isEnterConsult" value="Y" />
						</c:if>
						<c:set var="isEndConsult" value="N" />
						<c:if test="${currentD.time gt endTime}">
							<c:set var="isEndConsult" value="Y" />
						</c:if>
						<!-- 01 : 신청 -->
						<!-- 02 : 확정, 일지등록 -->
						<!-- 03 : 완료 -->
						<!-- 04 : 일지등록 -->
						<!-- 05 : 상담취소(고객) -->
						<!-- 06 : 상담취소(전문가) -->
						<!-- 07 : No Show(고객) -->
						<!-- 08 : No Show(전문가) -->
						<c:choose>
							<c:when test="${result.statusCd eq '01'}">
								<c:choose>
									<c:when test="${isEndConsult eq 'Y'}">
										<button type="button" class="btn_tbl btn_primary btn_modify_auth disabled">예약확정</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doConfirmConsult('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">예약확정</button>
									</c:otherwise>
								</c:choose>
								<button type="button" onclick="openPrvtCancelPopup('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #e31b32;">예약취소</button>
							</c:when>
							<c:when test="${result.statusCd eq '02'}">
								<c:choose>
									<c:when test="${isEndConsult eq 'Y'}">
										<button type="button" onclick="openPrvtConsultLogPopup('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">일지등록</button>
										<button type="button" onclick="doNoShowCustomerConsult('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #e31b32;">No Show(고객)</button>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${result.consultChannel eq '01'}">
												<button type="button" onclick="enterChatConsult();" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">채팅상담 시작</button>
											</c:when>
											<c:when test="${result.consultChannel eq '02'}">
												<button type="button" onclick="enterVideoOffice('${result.roomId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">화상상담 시작</button>
											</c:when>
										</c:choose>
										<button type="button" onclick="openPrvtConsultLogPopup('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">일지등록</button>
										<button type="button" onclick="openPrvtCancelPopup('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #e31b32;">예약취소</button>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${result.statusCd eq '04'}">
								<button type="button" onclick="openPrvtConsultLogPopup('${result.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">일지조회</button>
							</c:when>
							<c:when test="${result.statusCd eq '07'}">
								<button type="button" class="btn_tbl btn_primary btn_modify_auth disabled">No Show(고객)</button>
							</c:when>
							<c:when test="${result.statusCd eq '08'}">
								<button type="button" class="btn_tbl btn_primary btn_modify_auth disabled">No Show(전문가)</button>
							</c:when>
						</c:choose>	
					</td>
				</tr>
			</c:if>
		</table>
	</div>
</div>
</form>
<script type="text/javascript">
	function doConfirmConsult(prvtConsultId) {
		if (confirm('상담을 확정합니다. 진행 하시겠습니까?')) {
			var resultData = {};
			resultData['expertId'] = '${result.expertId}';
			resultData['consultTypeNm'] = '${result.consultTypeNm}';
			resultData['chatId'] = '${result.chatId}';
			resultData['roomId'] = '${result.roomId}';
			resultData['consultTypeCd'] = '${result.consultTypeCd}';
			resultData['statusCd'] = '${result.statusCd}';
			resultData['statusNm'] = '${result.statusNm}';
			resultData['reqFileId'] = '${result.reqFileId}';
			resultData['reqFileSeq'] = '${result.reqFileSeq}';
			resultData['reqOrgFileNm'] = '${result.reqOrgFileNm}';
			resultData['rsrvDate'] = '${result.rsrvDate}';
			resultData['rsrvTime'] = '${result.rsrvTime}';
			resultData['reqId'] = '${result.reqId}';
			resultData['reqNm'] = '${result.reqNm}';
			resultData['companyNm'] = '${result.companyNm}';
			resultData['expertNm'] = '${result.expertNm}';
			resultData['consultChannel'] = '${result.consultChannel}';
			resultData['consultChannelNm'] = '${result.consultChannelNm}';
			resultData['cancelReason'] = '${result.cancelReason}';
			resultData['prvtConsultId'] = '${result.prvtConsultId}';
			resultData['cellPhone'] = '${result.cellPhone}';
			resultData['endTime'] = '${result.rsrvEndTime}';
			
			resultData['apiRoomTitle'] = resultData['consultTypeNm'] + '_' + resultData['expertNm'];
			resultData['apiExpertNm'] = resultData['expertNm'];
			resultData['apiReqNm'] = resultData['reqNm'];

			// 화상 상담은 확정 시 알림톡에 접속 URL이 필요
			if (resultData['consultChannel'] == '02') {
				var reqId = resultData['reqId'];
				var userId = '';
				if (typeof reqId == 'string') {
					userId = encode64Han(reqId);
				} else {
					userId = encode64Han('${user.id}');
				}
				
				var reqNm = resultData['reqNm'];
				var userName = '';
				if (typeof reqNm == 'string') {
					userName = encode64Han(reqNm);
				} else {
					userName = encode64Han('${user.memberNm}');
				}
				
				resultData['apiAuthCode'] = encode64Han('${apiAuthCode}');
				resultData['companyCode'] = encode64Han('${companyCode}');
				resultData['userId'] = userId;
				resultData['userName'] = userName;
			}
			
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/confirmExpertPrvtConsult.do" />'
				, dataType : 'json'
				, contentType : 'application/json; charset=utf-8'
				, type : 'POST'
				, data : JSON.stringify(resultData)
				, async : true
				, spinner : true
				, success : function(data){
					layerPopupCallback();
				}
			});
		}
	}
	
	function doNoShowCustomerConsult(prvtConsultId) {
		if (confirm('No Show(고객) 상담으로 처리합니다. 맞습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/noShowCustomerExpertPrvtConsult.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					prvtConsultId : prvtConsultId
				}
				, async : true
				, spinner : true
				, success : function(data){
					layerPopupCallback();
				}
			});
		}
	}
</script>