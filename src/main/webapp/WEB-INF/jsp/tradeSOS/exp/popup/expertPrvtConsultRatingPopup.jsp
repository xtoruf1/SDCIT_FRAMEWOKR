<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("crcn", "\r\n");
%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<c:set var="resultInfo" value="${result.info}" />
<c:set var="replaceText">${resultInfo.replaceConsultText}</c:set>
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">1:1상담 상세</h2>
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
				<th>예약일시</th>
				<td colspan="2" style="border-right-color: #fff;">
					${fn:substring(resultInfo.rsrvDate, 0, 4)}-${fn:substring(resultInfo.rsrvDate, 4, 6)}-${fn:substring(resultInfo.rsrvDate, 6, 8)}
					${fn:substring(resultInfo.rsrvTime, 0, 2)}:${fn:substring(resultInfo.rsrvTime, 2, 4)}
				</td>
				<td class="align_r"><button type="button" onclick="doSearchAiConsult('${replaceText}');" class="btn_tbl">AI 자문 확인</button></td>
			</tr>
			<tr>
				<th>신청자</th>
				<td colspan="3">
					${resultInfo.reqNm}
					<c:if test="${not empty resultInfo.cellPhone}">
						(${resultInfo.cellPhone})
					</c:if>
				</td>
			</tr>
			<tr>
				<th>상담분야</th>
				<td>${resultInfo.consultTypeNm}</td>
				<th>상담채널</th>
				<td>${fn:replace(resultInfo.consultChannelNm, "상담", "")}</td>
			</tr>
			<tr>
				<th>상담요지</th>
				<td colspan="3">${fn:replace(resultInfo.consultText, cn, "<br />")}</td>
			</tr>
			<!-- 취소사유 -->
			<c:if test="${resultInfo.statusCd eq '05' or resultInfo.statusCd eq '06'}">
				<tr>
					<th>취소사유</th>
					<td colspan="3">
						<c:if test="${not empty resultInfo.cancelReason}">
							${resultInfo.cancelReason}
						</c:if>
					</td>
				</tr>
			</c:if>
		</table>
		<div class="btn_group mt-20 _center">
			<c:if test="${resultInfo.statusCd ne '06'}">
				<button type="button" onclick="doConfirmPrvtConsult('${resultInfo.prvtConsultId}', '02');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #2b5075;">예약확정</button>
				<button type="button" onclick="openPrvtCancelPopup('${resultInfo.prvtConsultId}');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #e31b32;">예약취소</button>
			</c:if>
			<c:if test="${resultInfo.statusCd ne '07'}">
				<button type="button" onclick="doCancelPrvtConsult('${resultInfo.prvtConsultId}', '07');" class="btn_tbl btn_primary btn_modify_auth" style="background-color: #e31b32;">No Show(고객)</button>
			</c:if>
		</div>
		<table class="formTable mt-20">
			<colgroup>
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<c:set var="consultKeyPick" value="${result.consultKeyPick}" />
			<c:if test="${not empty consultKeyPick}">
				<tr>
					<th>키워드 픽</th>
					<td>
						<c:set var="arrayKeyword" value="${fn:split(consultKeyPick.keywordNm, '|')}" />
						<c:forEach var="item" items="${arrayKeyword}" varStatus="status">
							<c:if test="${not status.first}">
								<span style="color: #2B5075;">|</span>
							</c:if>
							<span style="color: #2B5075;">${item}</span>
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:set var="consultRating" value="${result.consultRating}" />
			<c:if test="${not empty consultRating}">
				<tr>
					<th>만족도</th>
					<td>
						<c:choose>
							<c:when test="${consultRating.ratingScore eq 1}">
								<img src="<c:url value='/images/admin/bl_star1.png' />" style="vertical-align: middle;" alt="1점" />
							</c:when>
							<c:when test="${consultRating.ratingScore eq 2}">
								<img src="<c:url value='/images/admin/bl_star2.png' />" style="vertical-align: middle;" alt="2점" />
							</c:when>
							<c:when test="${consultRating.ratingScore eq 3}">
								<img src="<c:url value='/images/admin/bl_star3.png' />" style="vertical-align: middle;" alt="3점" />
							</c:when>
							<c:when test="${consultRating.ratingScore eq 4}">
								<img src="<c:url value='/images/admin/bl_star4.png' />" style="vertical-align: middle;" alt="4점" />
							</c:when>
							<c:when test="${consultRating.ratingScore eq 5}">
								<img src="<c:url value='/images/admin/bl_star5.png' />" style="vertical-align: middle;" alt="5점" />
							</c:when>
						</c:choose>
						<span style="color: #3f68b6;vertical-align: middle;">${consultRating.ratingScore}</span>
					</td>
				</tr>
				<tr>
					<th>한줄평</th>
					<td>
						<c:if test="${not empty consultRating.reply}">
							${consultRating.reply}
						</c:if>
					</td>
				</tr>
			</c:if>
			<c:if test="${resultInfo.statusCd eq '04'}">
				<tr>
					<th>전문가</th>
					<td>${resultInfo.expertNm}</td>
				</tr>
				<tr>
					<th>상담일지</th>
					<td>
						<c:if test="${not empty resultInfo.consultLog}">
							${fn:replace(resultInfo.consultLog, cn, "<br />")}
						</c:if>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="attachFieldList">
						<c:forEach var="item" items="${fileList}" varStatus="status">
							<div class="addedFile" <c:if test="${status.first}">style="margin-top: 8px;"</c:if>>
								<a href="<c:url value='/tradeSOS/exp/expertFileDownload.do' />?fileId=${item.fileId}&fileSeq=${item.fileSeq}" class="filename">${item.orgFileNm}</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.fileId}&fileSeq=${item.fileSeq}', '${item.orgFileNm}', 'membershipconsult_${profile}_${item.fileId}_${item.fileSeq}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<th>관리자 전달사항</th>
					<td>
						<c:if test="${not empty resultInfo.notice}">
							${resultInfo.notice}
						</c:if>
					</td>
				</tr>
				<tr>
					<th>관련 법률(법률)</th>
					<td>
						<c:if test="${not empty resultInfo.law}">
							${resultInfo.law}
						</c:if>
					</td>
				</tr>
				<tr>
					<th>관련 법률(조항)</th>
					<td>
						<c:if test="${not empty resultInfo.lawClause}">
							${resultInfo.lawClause}
						</c:if>
					</td>
				</tr>
				<tr>
					<th>기타참고사항</th>
					<td>
						<c:if test="${not empty resultInfo.dscr}">
							${resultInfo.dscr}
						</c:if>
					</td>
				</tr>
			</c:if>
		</table>
	</div>
</div>
<script type="text/javascript">
	function doConfirmPrvtConsult(consultId, cancelStatusCd) {



		if (confirm('예약을 확정 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/cancelPrvtConsult.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					prvtConsultId : consultId
					, statusCd : cancelStatusCd
					, consultChannel : '${resultInfo.consultChannel}'
					, endTime : '${resultInfo.rsrvEndTime}'
					, rsrvTime : '${resultInfo.rsrvTime}'
					, rsrvDate : '${resultInfo.rsrvDate}'
					, consultTypeNm : '${resultInfo.consultTypeNm}'
					, expertNm : '${resultInfo.expertNm}'
					, expertId : '${resultInfo.expertId}'
					, reqId : '${resultInfo.reqId}'
					, reqNm : '${resultInfo.reqNm}'
					, apiRoomTitle : '${resultInfo.consultTypeNm}_${resultInfo.expertNm}'
					, apiExpertNm : '${resultInfo.expertNm}'
					, apiReqNm : '${resultInfo.reqNm}'
					, countYn : 'Y'
					, cancelReason : ''
				}
				, async : true
				, spinner : true
				, success : function(data){
					closeLayerPopup();

					getList();
				}
			});
		}
	}

	function doCancelPrvtConsult(consultId, cancelStatusCd) {
		if (confirm('No Show 상태로 변경 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/cancelPrvtConsult.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					prvtConsultId : consultId
					, statusCd : cancelStatusCd
					, countYn : 'Y'
					, cancelReason : 'No Show로 상담이 취소되었습니다.'
				}
				, async : true
				, spinner : true
				, success : function(data){
					closeLayerPopup();

					getList();
				}
			});
		}
	}

	function openPrvtCancelPopup(consultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtCancelAdminPopup.do" />'
			, params : {
				prvtConsultId : consultId
			}
			, callbackFunction : function(resultObj) {
				closeLayerPopup();

				layerPopupCallback();

				closeLayerPopup();
			}
		});
    }

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>