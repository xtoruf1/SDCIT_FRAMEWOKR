<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doPrintPopup();">출력</button>
		<c:if test="${params.sendYn eq 'N'}">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doUpdateData();">수출입 데이터 갱신</button>
			<c:if test="${companyInfo.statusCd eq '10'}">
				<button type="button" id="selectionBtn" class="btn_sm btn_primary btn_modify_auth" onclick="doSelection();">선정</button>
			</c:if>
			<c:if test="${companyInfo.statusCd eq '20'}">
				<button type="button" id="selectionCancelBtn" class="btn_sm btn_primary btn_modify_auth" onclick="doSelectionCancel();">선정취소</button>
			</c:if>
		</c:if>
		<button type="button" class="btn_sm btn_primary" onclick="goList();">목록</button>
	</div>
</div>

<form id="frm" method="post">
	<!-- 목록이동 파라미터 -->
	<input type="hidden" name="searchAwardRound" value='<c:out value="${params.searchAwardRound}"></c:out>'>
	<input type="hidden" name="searchRegStartDt" value='<c:out value="${params.searchRegStartDt}"></c:out>'>
	<input type="hidden" name="searchRegEndDt" value='<c:out value="${params.searchRegEndDt}"></c:out>'>
	<input type="hidden" name="searchCompanyName" value='<c:out value="${params.searchCompanyName}"></c:out>'>
	<input type="hidden" name="searchBusinessNo" value='<c:out value="${params.searchBusinessNo}"></c:out>'>
	<input type="hidden" name="searchTradeNo" value='<c:out value="${params.searchTradeNo}"></c:out>'>
	<input type="hidden" name="searchCeoName" value='<c:out value="${params.searchCeoName}"></c:out>'>
	<input type="hidden" name="searchStartScore" value='<c:out value="${params.searchStartScore}"></c:out>'>
	<input type="hidden" name="searchEndScore" value='<c:out value="${params.searchEndScore}"></c:out>'>
	<input type="hidden" name="searchStatus" value='<c:out value="${params.searchStatus}"></c:out>'>
	<!-- 목록이동 파라미터 -->
	<input type="hidden" name="traderId" value='<c:out value="${params.traderId}"></c:out>'>
	<input type="hidden" name="applId" value='<c:out value="${params.applId}"></c:out>'>
	<input type="hidden" name="tradeNo" value='<c:out value="${companyInfo.tradeNo}"></c:out>'>
	<input type="hidden" name="exptBaseMonth" value='<c:out value="${params.exptBaseMonth}"></c:out>'>
	<input type="hidden" name="selectCount" value='<c:out value="${params.selectCount}"></c:out>'>
	<input type="hidden" name="awardTitle" value='<c:out value="${params.awardTitle}"></c:out>'>
	<input type="hidden" name="indirectAmt1" value='<c:out value="${companyPerformanceInfo.indirectAmt1}"></c:out>'>
	<input type="hidden" name="indirectAmt2" value='<c:out value="${companyPerformanceInfo.indirectAmt2}"></c:out>'>
	<input type="hidden" name="indirectAmt3" value='<c:out value="${companyPerformanceInfo.indirectAmt3}"></c:out>'>
	<input type="hidden" name="indirectAmt4" value='<c:out value="${companyPerformanceInfo.indirectAmt4}"></c:out>'>

	<div class="cont_block">
		<div class="tabGroup">
			<div class="tab_header">
				<button type="button" class="tab on" onclick="scoreSaveBtnCon(1);">기본정보</button>
				<button type="button" class="tab" onclick="scoreSaveBtnCon(2);">공적요약</button>
				<button type="button" class="tab" onclick="scoreSaveBtnCon(3);">이력서</button>
				<button type="button" class="tab" onclick="scoreSaveBtnCon(4);">상세평가</button>
				<c:if test="${params.sendYn eq 'N'}">
				<button type="button" id="scoreSaveBtn" class="btn_sm btn_primary btn_modify_auth ml-auto" style="margin-bottom: 3px;" onclick="doSaveScore();">평가점수 저장</button>
				</c:if>
			</div>
			<div class="tab_body">
				<div class="tab_cont on">
					<div class="cont_block">
						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col style="width:15%" />
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>업체명</th>
									<td>
										<c:out value='${companyInfo.companyName}'/>
									</td>
									<th>신용등급</th>
									<td>
										<c:out value='${companyInfo.creditRating}'/>
									</td>
								</tr>
								<tr>
									<th>사업자등록번호</th>
									<td>
										<c:out value='${companyInfo.businessNo}'/>
									</td>
									<th>무역업고유번호</th>
									<td>
										<c:out value='${companyInfo.tradeNo}'/> / <c:out value="${empty companyInfo.tradeNo ? '비회원사' : '회원사'}"/>
									</td>
								</tr>
								<tr>
									<th>평가점수</th>
									<td>
										<c:out value='${companyInfo.totScore}'/>
									</td>
									<th>선정여부</th>
									<td class="choiceYn">
										<c:out value="${companyInfo.choiceYn eq '선정' ? '선정' : '미선정'}"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">대표자</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col style="width:15%" />
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>성명</th>
									<td>
										<c:out value='${companyInfo.ceoName}'/>
									</td>
									<th>출생년도</th>
									<td>
										<c:out value='${companyInfo.birthYear}'/>년
									</td>
								</tr>
								<tr>
									<th>직위</th>
									<td>
										<c:out value='${companyInfo.position}'/>
									</td>
									<th>대표이사 근무기간</th>
									<td>
										<c:out value='${companyInfo.tenure}'/>년
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">업체현황</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col style="width:15%" />
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>소재지</th>
									<td colspan="3">
										<c:out value='${companyInfo.address}'/>
									</td>
								</tr>
								<tr>
									<th>설립연도</th>
									<td colspan="1">
										<c:out value='${companyInfo.since}'/>년
									</td>
									<th>수출개시연도</th>
									<td colspan="1">
										<c:out value='${companyInfo.expStartYear}'/>년
									</td>
								</tr>
								<tr>
									<th rowspan="2">자본금</th>
									<td rowspan="2">
										<fmt:formatNumber value='${companyInfo.capital}' pattern="#,###"/>원
									</td>
									<th>상시근로자수</th>
									<td>
										<c:out value='${companyInfo.workerCount}'/>명
									</td>
								</tr>
								<tr>
									<th>신규고용자수</th>
									<td>
										<c:out value='${companyInfo.newWorkerCount}'/>명
									</td>
								</tr>
								<tr>
									<th>기업규모</th>
									<td>
										<c:out value='${companyInfo.companySize}'/>
									</td>
									<th>업종</th>
									<td>
										<c:out value='${companyInfo.businessType}'/>
									</td>
								</tr>
								<tr>
									<th rowspan="2">주생산품</th>
									<td>
										<c:out value='${companyInfo.mainProduct1}'/>
									</td>

									<th rowspan="2">주수출품</th>
									<td>
										<c:out value='${companyInfo.mainExp1}'/>
									</td>

								</tr>
								<tr>
									<td>
										<c:out value='${companyInfo.mainProduct2}'/>
									</td>
									<td>
										<c:out value='${companyInfo.mainExp2}'/>
									</td>
								</tr>

								<tr>
									<th>생산시설 보유여부</th>
									<td colspan="3">
										<c:out value="${companyInfo.factoryYn eq 'Y' ? '보유' : '미보유'}"/>
									</td>
								</tr>
								<tr>
									<th>생산시설 현황</th>
									<td colspan="3">
										자체공장 : <c:out value="${companyInfo.ownFacCnt}"/>, 외주공장 : <c:out value="${companyInfo.outFacCnt}"/>
										<br>
										국내소재 : <c:out value="${companyInfo.domeFacCnt}"/>, 해외소재 : <c:out value="${companyInfo.oversFacCnt}"/>
									</td>
								</tr>
								<tr>
									<th>홈페이지</th>
									<td colspan="3">
										<c:out value='${companyInfo.homepage}'/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">연도별 수출실적 (단위 : 천달러)</h3>
						</div>
						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col/>
								<col/>
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>구분</th>
									<c:forEach items="${directHeader}" var="directHeader" varStatus="status">
										<th><c:out value="${directHeader.directHeaderDate}"/></th>
									</c:forEach>
								</tr>
								<tr>
									<th>직접수출</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.directAmt1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.directAmt2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.directAmt3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.directAmt4}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>간접수출</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.indirectAmt1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.indirectAmt2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.indirectAmt3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.indirectAmt4}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>합계(증가율)</th>
									<td class="align_r">
<%-- 										<c:set var="color1" value="${companyPerformanceInfo.expRate1 > 0.0 ? 'red' : 'blue'}"/> --%>
<%-- 										<c:set var="upDown1" value="${companyPerformanceInfo.expRate1 > 0.0 ? '▲' : '▼'}"/> --%>
										<fmt:formatNumber value='${companyPerformanceInfo.sumAmt1}' pattern="#,###"/>
									</td>
									<td class="align_r">
										<c:set var="color2" value="${companyPerformanceInfo.expRate2 > 0.0 ? 'red' : 'blue'}"/>
										<c:set var="upDown2" value="${companyPerformanceInfo.expRate2 > 0.0 ? '▲' : '▼'}"/>
										<fmt:formatNumber value='${companyPerformanceInfo.sumAmt2}' pattern="#,###"/> <c:if test='${not empty companyPerformanceInfo.expRate2}'> ( <strong style="color: ${color2}">${upDown2}</strong> <c:out value="${fn:replace(companyPerformanceInfo.expRate2, '-', '')}"/>%)</c:if>
									</td>
									<td class="align_r">
										<c:set var="color3" value="${companyPerformanceInfo.expRate3 > 0.0 ? 'red' : 'blue'}"/>
										<c:set var="upDown3" value="${companyPerformanceInfo.expRate3 > 0.0 ? '▲' : '▼'}"/>
										<fmt:formatNumber value='${companyPerformanceInfo.sumAmt3}' pattern="#,###"/> <c:if test='${not empty companyPerformanceInfo.expRate3}'> ( <strong style="color: ${color3}">${upDown3}</strong> <c:out value="${fn:replace(companyPerformanceInfo.expRate3, '-', '')}"/>%)</c:if>
									</td>
									<td class="align_r">
										<c:set var="color4" value="${companyPerformanceInfo.expRate4 > 0.0 ? 'red' : 'blue'}"/>
										<c:set var="upDown4" value="${companyPerformanceInfo.expRate4 > 0.0 ? '▲' : '▼'}"/>
										<fmt:formatNumber value='${companyPerformanceInfo.sumAmt4}' pattern="#,###"/> <c:if test='${not empty companyPerformanceInfo.expRate4}'> ( <strong style="color: ${color4}">${upDown4}</strong> <c:out value="${fn:replace(companyPerformanceInfo.expRate4, '-', '')}"/>%)</c:if>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">국가별 수출액 (단위 : 천달러)</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col/>
								<col/>
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>국가</th>
									<th> <c:out value="${companyPerformanceInfo.countryName1}"/> </th>
									<th> <c:out value="${companyPerformanceInfo.countryName2}"/> </th>
									<th> <c:out value="${companyPerformanceInfo.countryName3}"/> </th>
									<th> <c:out value="${companyPerformanceInfo.countryName4}"/> </th>
									<th>기타 전체</th>
								</tr>
								<tr>
									<th>수출액</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryAmt1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryAmt2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryAmt3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryAmt4}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.elseCountryAmt}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>비중</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryRate1}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryRate2}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryRate3}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.countryRate4}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.elseCountryRate}" pattern="#,###"/>%
									</td>
								</tr>
								<tr>
									<th>기타 수출액</th>
									<td colspan="5" class="align_l">
										<c:out value="${companyPerformanceInfo.elseCountryDscr}"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">재무제표 (단위 : 백만원)</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col/>
								<col/>
							</colgroup>
							<tbody>
								<tr class="yearSet">
									<th>구분</th>
								</tr>
								<tr>
									<th>총 매출액</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.salesAmt1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.salesAmt2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.salesAmt3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.salesAmt4}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>영업이익</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.oprtProfit1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.oprtProfit2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.oprtProfit3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.oprtProfit4}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>당기순이익</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.netProfit1}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.netProfit2}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.netProfit3}" pattern="#,###"/>
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.netProfit4}" pattern="#,###"/>
									</td>
								</tr>
								<tr>
									<th>해외매출비중</th>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.overRate1}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.overRate1}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.overRate1}" pattern="#,###"/>%
									</td>
									<td class="align_r">
										<fmt:formatNumber value="${companyPerformanceInfo.overRate1}" pattern="#,###"/>%
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">기술개발</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col/>
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>종류</th>
									<th>인증 및 특허</th>
									<th>개수</th>
									<th>비고</th>
								</tr>
								<tr>
									<th>해외인증</th>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.overCertTitle}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.overCertCount}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.overCertDscr}'/>
									</td>
								</tr>
								<tr>
									<th>국내인증</th>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.dmstCertTitle}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.dmstCertCount}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.dmstCertDscr}'/>
									</td>
								</tr>
								<tr>
									<th>특허</th>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.patentTitle}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.patentCount}'/>
									</td>
									<td class="align_l">
										<c:out value='${companyPerformanceInfo.patentDscr}'/>
									</td>
								</tr>
								<tr>
									<th>기업부설 연구소</th>
									<td colspan="3" class="align_ctr">
										<c:out value="${companyPerformanceInfo.researchYn eq 'Y' ? '있음' : '없음'}"></c:out>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">담당자 연락처</h3>
						</div>

						<table class="formTable">
							<colgroup>
								<col style="width:15%" />
								<col/>
								<col/>
								<col/>
								<col/>
							</colgroup>
							<tbody>
								<tr>
									<th>구분</th>
									<th>성명</th>
									<th>사무번호</th>
									<th>휴대전화번호</th>
									<th>이메일</th>
								</tr>
								<tr>
									<th>대표자</th>
									<td class="align_ctr">
										<c:out value='${companyInfo.ceoName}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.ceoTel}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.ceoPhone}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.ceoEmail}'/>
									</td>
								</tr>
								<tr>
									<th>담당자</th>
									<td class="align_ctr">
										<c:out value='${companyInfo.chargeName}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.chargeTel}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.chargePhone}'/>
									</td>
									<td class="align_ctr">
										<c:out value='${companyInfo.chargeEmail}'/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block">제품이미지</h3>
						</div>
						<c:choose>
							<c:when test="${not empty productFileList}">
								<c:forEach items="${productFileList}" var="productFileList" varStatus="status">
									<img alt="" style="width: calc(1060px / 3.5); height: 200px;" src="/hanbit/hanbitApplicant/habitImage.do?attachSeq=${productFileList.attachSeq}&fileSeq=${productFileList.fileSeq}">
								</c:forEach>
							</c:when>
							<c:otherwise>
								<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
							</c:otherwise>
						</c:choose>

					</div>
				</div>

				<div class="tab_cont _border">
					<c:forEach items="${companyIntroduction}" var="companyIntroduction" varStatus="status">
					<div class="cont_block">
						<div class="tit_bar">
							<h3 class="tit_block"><c:out value='${companyIntroduction.templateTitle}'/></h3>
						</div>
						<div style="background-color: #ECECEC;">
							<p style="padding: 15px; height: 430px; word-break: break-all;">${fn:replace(companyIntroduction.content, newLineChar, "<br/>")}</p>
						</div>
					</div>
					</c:forEach>
				</div>

				<div class="tab_cont">
					<div class="cont_block">
						<table class="formTable">
							<colgroup>
							<col width="15%">
							<col>
							<col width="15%">
							<col>
							</colgroup>
							<tbody>
								<tr>
									<th rowspan="4">사진</th>
									<td rowspan="4">
										<figure class="photo">
											<c:choose>
												<c:when test="${not empty ceoPhoto}">
													<c:forEach items="${ceoPhoto}" var="ceoPhoto" varStatus="status">
														<div>
															<img alt="" style="width: 150px;" src="/hanbit/hanbitApplicant/habitImage.do?attachSeq=${ceoPhoto.attachSeq}&fileSeq=${ceoPhoto.fileSeq}">
														</div>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
												</c:otherwise>
											</c:choose>
										</figure>
									</td>
									<th rowspan="2">성명</th>
									<td>
										(한글) <c:out value='${resumePersonalInfo.nameKor}'/>
									</td>
								</tr>
								<tr>
									<td>
										(한자) <c:out value='${resumePersonalInfo.nameChn}'/>
									</td>
								</tr>
								<tr>
									<th>생년월일 / 연령</th>
									<td>
										<c:out value='${resumePersonalInfo.birthDate}'/> / <c:out value='${resumePersonalInfo.age}'/>
									</td>
								</tr>
								<tr>

									<th>CEO형태</th>
									<td>
										<c:out value='${resumePersonalInfo.ceoType}'/>
									</td>
								</tr>
								<tr>
									<th rowspan="${resumeEducaCareerCnt + 1 }">학력 및 경력 사항</th>
									<c:forEach items="${resumeEducaCareer}" var="resumeEducaCareer" varStatus="status">
										<tr>
											<td colspan="3">
												<c:out value='${resumeEducaCareer.eduDate}'/> &nbsp; <c:out value='${resumeEducaCareer.eduDscr}'/>
											</td>
										</tr>
									</c:forEach>
								</tr>
								<tr>
									<th rowspan="${resumeAwardsInfoCnt + 1}">수상경력</th>
									<c:choose>
										<c:when test="${not empty resumeAwardsInfo}">
											<c:forEach items="${resumeAwardsInfo}" var="resumeAwardsInfo" varStatus="status">
												<tr>
													<td colspan="3">
														<c:out value='${resumeAwardsInfo.awardDate}'/> &nbsp; <c:out value='${resumeAwardsInfo.awardDscr}'/> &nbsp; (<c:out value='${resumeAwardsInfo.issueOrg}'/>)
													</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<td colspan="3">
												입력된 정보가 없습니다.
											</td>
										</c:otherwise>
									</c:choose>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<div class="tab_cont">
					<div class="cont_block">
						<table class="formTable">
							<colgroup>
							<col width="18%">
							<col>
							<col width="15%">
							</colgroup>
							<tbody>
								<tr>
									<th>항목</th>
									<th>산출근거 단위 : 천달러 , %</th>
									<th>점수</th>
								</tr>
								<tr>
									<td>
										1. 최근 3년 평균 수출증가율
									</td>
									<td>
										<strong>4년 전 수출액</strong> : <fmt:formatNumber value='${selectApplicantScoreStandard.beforeExpAmt}' pattern="#,###"/>  &nbsp; <strong>평균 수출 증가율</strong> : <c:out value='${selectApplicantScoreStandard.extRateAvg}'/>  &nbsp;  <strong><c:out value='${selectApplicantScoreStandard.increaseTypeCd}'/>년 연속 수출 증가</strong> : <c:out value='${selectApplicantScoreStandard.weightRate}'/>
									</td>
									<td class="score align_ctr" id="extRateScore">
									</td>
								</tr>
								<tr>
									<td>
										2. 수출규모
									</td>
									<td>
										<strong>최근 수출 금액</strong> : <fmt:formatNumber value='${selectApplicantScoreStandard.lastExpAmt}' pattern="#,###"/>
									</td>
									<td class="score align_ctr" id="extSizeScore">
									</td>
								</tr>
								<tr>
									<td>
										3. 해외 매출 비중
									</td>
									<td>
										<strong>해외 매출비중</strong> : <c:out value='${selectApplicantScoreStandard.overRate}'/>
									</td>
									<td class="score align_ctr" id="overRateScore">
									</td>
								</tr>
								<tr>
									<td>
										4. 직수출 비중
									</td>
									<td>
										<strong>직수출비중</strong> : <c:out value='${selectApplicantScoreStandard.directRate}'/>
									</td>
									<td class="score align_ctr" id="directRateScore">
									</td>
								</tr>
								<tr>
									<td>
										5. 기술개발
									</td>
									<td>
										<strong>기업부설 연구소</strong> :  <c:out value="${selectApplicantScoreStandard.researchYn eq 'Y' ? '有' : '無'}"/> &nbsp; <strong>국내, 해외 인증</strong> : <c:out value='${selectApplicantScoreStandard.totalCertCount}'/>
									</td>
									<td class="score align_ctr" id="researchScore">
									</td>
								</tr>
								<tr>
									<td>
										6. 업력
									</td>
									<td>
										<strong>설립연도</strong> : <c:out value='${selectApplicantScoreStandard.sinceYear}'/>년 <c:out value='${selectApplicantScoreStandard.since}'/>년
									</td>
									<td class="score align_ctr" id="sinceScore">
									</td>
								</tr>
								<tr>
									<td>
										7. 재무제표
									</td>
									<td>
										<strong>영업이익 달성연도</strong> : <c:out value='${selectApplicantScoreStandard.profitYear}'/>
									</td>
									<td class="score align_ctr" id="profitScore">
									</td>
								</tr>
								<tr>
									<td>
										8. 크레탑 신용반영
									</td>
									<td>
										<fieldset class="form_group  group_item">
											<strong>신용등급</strong>&nbsp; : &nbsp;
											<select class="form_select group_item" name="creditRating">
												<option value="">선택</option>
												<c:forEach items="${creditCode}" var="creditCode" varStatus="status">
													<option value="<c:out value="${creditCode.code}" />" <c:out value="${ creditCode.code eq companyInfo.creditRating ? 'selected' : '' }" /> ><c:out value="${creditCode.codeNm}"/></option>
												</c:forEach>
											</select>
											<c:if test="${empty companyInfo.creditRating}">
												<strong><span class="group_item" style="color: red;">※ 신용등급 미반영 상태입니다.</span></strong>
											</c:if>
										</fieldset>
									</td>
									<td class="score align_ctr" id="creditScore">
									</td>
								</tr>
								<tr>
									<td>
										9. 대표이사 재직기간
									</td>
									<td>
										<strong>대표이사 재직기간</strong> : <c:out value='${selectApplicantScoreStandard.ceoTenure}'/>년
									</td>
									<td class="score align_ctr" id="ceoScore">
									</td>
								</tr>
								<tr>
									<td>
										10. 심사위원회 평가
									</td>
									<td>

									</td>
									<td class="align_ctr">
										<input type="text" id="judgeScore" name="judgeScore" class="form_text align_ctr" oninput="this.value = this.value.replace(/[^0-9]/g, '');" onchange="sumScore();" maxlength="2">
									</td>
								</tr>
								<tr>
									<th colspan="2">계</th>
									<th id="totScore"></th>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	var scChangeYn = 'N';

	$(document).ready(function(){
		$('#scoreSaveBtn').hide();
		getYear();
		getScore();
	});

	function scoreSaveBtnCon(val) {

		if(val != '4') {
			$('#scoreSaveBtn').hide();
		} else {
			$('#scoreSaveBtn').show();
		}
	}

	function getYear() {

		var now = new Date();	// 현재 날짜 및 시간
		var year = now.getFullYear();	// 연도
		year = year - 5;

		for(var i = 0; i < 4; i++) {
			year++;
			$('.yearSet').append('<th>'+year+'년</th>');
		}
	}

	function goList() {
		$('#frm').attr('action', '/hanbit/hanbitApplicant/hanbitApplicantList.do');
		$('#frm').submit();
	}

	function getScore() {

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/selectHanbitApplicantScore.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				var info = data.applicantScore;

				var key1 = Object.keys(data.applicantScore);

				for(var i = 0; i < key1.length; i++) {	// 바우처 상세정보 값세팅

					var value = data.applicantScore[key1[i]];

					if(key1[i] == 'judgeScore'){
						$('#'+key1[i]).val(value);
					} else {
						$('#'+key1[i]).text(value);
					}
				}
			}
		});

	}

	function doPrintPopup() {

		if(scChangeYn == 'Y'){
			if(!confirm('변경된 점수가 있습니다. 변경되지 않은 정보로 출력하시겠습니까?')){
				return;
			}
		}

		var traderId = $('input[name=traderId]').val();
		var applId = $('input[name=applId]').val();
		var exptBaseMonth = $('input[name=exptBaseMonth]').val();
		var awardTitle = $('input[name=awardTitle]').val();

		global.openLayerPopup({
			popupUrl : '/hanbit/hanbitApplicant/popup/hanbitApplicantPrint.do'
			, params : {'traderId' : traderId,
				  	    'applId' : applId,
				  	    'exptBaseMonth' : exptBaseMonth,
				  	    'awardTitle' : awardTitle}
		});
	}

	function chkScore() {

		var numChk = /[^0-9]/;

		var totscore = $('#judgeScore').val();

		if(numChk.test(totscore)) {
			alert('숫자만 입력해 주세요.');
			$('#judgeScore').focus();
			return false;
		}
		return true;
	}

	function sumScore() {

		if(chkScore() == false) {
			return;
		}

		var totscore = Number($('#judgeScore').val());

		$('.score').each(function() {
			var strScore = $(this).text();
			var numScore = Number(strScore);
			totscore += numScore;
		})

		$('#totScore').text(totscore);
		scChangeYn = 'Y';

	}

	function doSaveScore() {	// 저장

		if(chkScore() == false) {
			return;
		}

		var totScore = Number($('#totScore').text());

		if(100 < totScore) {
			alert('총점은 100점보다 클 수 없습니다.');
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return false;
		}

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/saveScore.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				scChangeYn = 'N';
				alert('평가점수가 저장되었습니다.');

			}
		});
	}

	function doSelection() {

		if(!confirm("선정하시겠습니까?")){
			return false;
		}

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/applicantSelection.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if(data.result == false) {
					alert(data.message);
					return;
				} else {
					goList();
				}
			}
		});
	}

	function doSelectionCancel() {

		if(!confirm("선정취소 하시겠습니까?")){
			return false;
		}

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/applicantSelectionCancel.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				goList();
			}
		});
	}

	function doUpdateData() {	// 수출입 데이터 수정

		$('#loading_image').show(); // 로딩이미지 시작

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitApplicant/updateTraderApplScore.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#loading_image').hide(); // 로딩이미지 종료
				window.location.reload();
			}
		});
	}

</script>
