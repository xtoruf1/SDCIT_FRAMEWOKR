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
<c:set var="resultInfo" value="${result.info}" />
<c:set var="replaceContent">${resultInfo.replacePblcContent}</c:set>
<div style="width: 850px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">오픈상담 상세</h2>
		<div class="ml-auto">
			<button type="button" onclick="doSearchAiConsult('${replaceContent}');" class="btn_sm btn_primary">AI 자문 확인</button>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<tr>
				<th>작성자</th>
				<td>
					${resultInfo.reqNm}
				</td>
			</tr>
			<tr>
				<th>작성일시</th>
				<td>
					${resultInfo.creDate}
				</td>
			</tr>
			<tr>
				<th>연락처 / 이메일</th>
				<td>
					<c:if test="${not empty resultInfo.cellPhone}">
						${resultInfo.cellPhone}
					</c:if>
					<c:if test="${not empty resultInfo.cellPhone and not empty resultInfo.email}">
						/
					</c:if>
					<c:if test="${not empty resultInfo.email}">
						${resultInfo.email}
					</c:if>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${resultInfo.pblcTitle}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${fn:replace(resultInfo.pblcContent, cn, "<br />")}</td>
			</tr>
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
		</table>		
		<c:set var="resultInfoList" value="${result.infoList}" />
		<c:if test="${not empty resultInfoList}">
			<c:forEach var="item" items="${resultInfoList}" varStatus="status">
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 15%;" />
							<col />
						</colgroup>
						<tr>
							<th>전문가</th>
							<td>${item.expertNm}</td>
						</tr>
						<tr>
							<th>답변내용</th>
							<td>
								<c:if test="${not empty item.answerContent}">
									${fn:replace(item.answerContent, cn, "<br />")}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>관련 법률(법률)</th>
							<td>
								<c:if test="${not empty item.law}">
									${item.law}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>관련 법률(조항)</th>
							<td>
								<c:if test="${not empty item.lawClause}">
									${item.lawClause}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>기타참고사항</th>
							<td>
								<c:if test="${not empty item.dscr}">
									${item.dscr}
								</c:if>
							</td>
						</tr>
					</table>
				</div>
			</c:forEach>
		</c:if>
	</div>
</div>