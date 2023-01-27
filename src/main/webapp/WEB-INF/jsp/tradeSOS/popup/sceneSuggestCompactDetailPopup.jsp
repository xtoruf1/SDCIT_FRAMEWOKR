<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">컨설팅 요약 내역</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
<form id="popForm" name="popForm" action="post">
	<!-- 컨설팅 요약 내역 -->
	<div id="searchPop" class="layerPopUpWrap">
		<div class="layerPopUp">
			<div class="layerWrap" style="width:700px;">
				<div class="box">
					<table class="boardwrite formTable">
						<colgroup>
							<col width="20%" />
							<col />
						</colgroup>
					<tbody>
						<tr>
							<th scope="row">컨설팅 신청 제목</th>
							<td><c:out value="${resultData.title}"/></td>
						</tr>
						<tr>
							<th scope="row">신청내용</th>
							<td>
								${fn:replace(resultData.regContent, newLineChar, "<br/>")}
							</td>
						</tr>
						<tr>
							<th scope="row">담당위원</th>
							<td><c:out value="${resultData.expertNm}"/></td>
						</tr>
						<tr>
							<th scope="row">상담내역</th>
							<td>
								${fn:replace(resultData.content, newLineChar, "<br/>")}
							</td>
						</tr>
						<tr>
							<th scope="row">규제 접수 내용</th>
							<td>
								${fn:replace(resultData.content2, newLineChar, "<br/>")}
							</td>
						</tr>
						<tr>
							<th scope="row">상담방법</th>
							<td><c:out value="${resultData.gubun eq '010'? '현장방문' : '전화 및 온라인'}"/></td>
						</tr>
						<c:if test="${not empty surveyResultData}">
							<tr>
								<th scope="row">전만적인 만족도</th>
								<td>
									<div class="ratingView">
										<c:forEach begin="1" end="5" varStatus="status">
											<c:set value="" var="classOn"/>
											<c:if test="${status.index le surveyResultData.survey02}">
												<c:set value="on" var="classOn"/>
											</c:if>
											<span class="star_bl <c:out value="${classOn}"/>"><c:out value="${status.index}"/>점</span>
										</c:forEach>
										<span class="fc_blue"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">자문위원 전문성</th>
								<td>
									<div class="ratingView">
										<c:forEach begin="1" end="5" varStatus="status">
											<c:set value="" var="classOn"/>
											<c:if test="${status.index le surveyResultData.survey03}">
												<c:set value="on" var="classOn"/>
											</c:if>
											<span class="star_bl <c:out value="${classOn}"/>"><c:out value="${status.index}"/>점</span>
										</c:forEach>
										<span class="fc_blue"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">자문위원 친절도</th>
								<td>
									<div class="ratingView">
										<c:forEach begin="1" end="5" varStatus="status">
											<c:set value="" var="classOn"/>
											<c:if test="${status.index le surveyResultData.survey04}">
												<c:set value="on" var="classOn"/>
											</c:if>
											<span class="star_bl <c:out value="${classOn}"/>"><c:out value="${status.index}"/>점</span>
										</c:forEach>
										<span class="fc_blue"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">자문위원 재신청</th>
								<td>
									<div class="ratingView">
										<c:forEach begin="1" end="5" varStatus="status">
											<c:set value="" var="classOn"/>
											<c:if test="${status.index le surveyResultData.survey05}">
												<c:set value="on" var="classOn"/>
											</c:if>
											<span class="star_bl <c:out value="${classOn}"/>"><c:out value="${status.index}"/>점</span>
										</c:forEach>
										<span class="fc_blue"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">자문위원 추천</th>
								<td>
									<div class="ratingView">
										<c:forEach begin="1" end="5" varStatus="status">
											<c:set value="" var="classOn"/>
											<c:if test="${status.index le surveyResultData.survey06}">
												<c:set value="on" var="classOn"/>
											</c:if>
											<span class="star_bl <c:out value="${classOn}"/>"><c:out value="${status.index}"/>점</span>
										</c:forEach>
										<span class="fc_blue"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">기타의견</th>
								<td><c:out value="${surveyResultData.dscr}"/></td>
							</tr>
						</c:if>
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
</div>

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