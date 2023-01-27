<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<div class="fixed_pop_tit">

<div class="flex popup_top">
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		<button type="button" class="btn_sm btn_primary" onclick="doPrint();">출력</button>
	</div>
</div>


<div class="popup_body" id="printTable" style="width:1100px;">
	<div class="cont_block">
		<div>
			<h1 style="text-align: center; margin-bottom: 10px;"><c:out value="${params.awardTitle}"></c:out></h1>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
				<col/>
				<col style="width:20%" />
				<col/>
			</colgroup>
			<tbody>
				<tr>
					<th>업체명</th>
					<td>
						<c:out value='${companyInfo.companyName}'/>
					</td>
					<th>사업자등록번호</th>
					<td>
						<c:out value='${companyInfo.businessNo}'/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">1. 대표자 개요</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
				<col/>
				<col style="width:20%" />
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
			<h1 class="tit_block">2. 업체현황</h1>

		</div>
		<h3 class="tit_block">가. 개  요</h3>
		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
				<col/>
				<col style="width:20%" />
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
					<td  colspan="3">
						자체공장 : <c:out value="${companyInfo.ownFacCnt}"/>, 외주공장 : <c:out value="${companyInfo.outFacCnt}"/>
						<br>
						국내소재 : <c:out value="${companyInfo.domeFacCnt}"/>, 해외소재 : <c:out value="${companyInfo.oversFacCnt}"/>
					</td>
				</tr>
				<tr>
					<th>홈페이지</th>
					<td  colspan="3">
						<c:out value='${companyInfo.homepage}'/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<h3 class="tit_block">나. 연도별 수출실적</h3>
			<h3 class="ml-auto">(단위 : 천달러, %)</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
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
						<fmt:formatNumber value="${companyPerformanceInfo.indirectAmt1}" pattern="#,###"/>
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
<%-- 						<c:set var="color1" value="${companyPerformanceInfo.expRate1 > 0.0 ? 'red' : 'blue'}"/> --%>
<%-- 						<c:set var="upDown1" value="${companyPerformanceInfo.expRate1 > 0.0 ? '▲' : '▼'}"/> --%>
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

	<div class="cont_block" style='page-break-before:always;'>

		<div class="tbl_opt">
			<h3 class="tit_block">다. 국가별 수출액</h3>
			<h3 class="ml-auto">(단위 : 천달러, %)</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
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
		<div class="tbl_opt">
			<h3 class="tit_block">라. 재무제표</h3>
			<h3 class="ml-auto">(단위 : 백만원, %)</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
				<col/>
				<col/>
				<col/>
			</colgroup>
			<tbody>
				<tr class="popYearSet">
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
		<div class="tbl_opt">
			<h3 class="tit_block">마. 기술개발</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
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
					<th>기업부설연구소</th>
					<td colspan="3" class="align_ctr">
						<c:out value="${companyPerformanceInfo.researchYn eq 'Y' ? '있음' : '없음'}"></c:out>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">바. 담당자 연락처</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:20%" />
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

	<div class="cont_block" style='page-break-before:always;'>
		<div class="tit_bar">
			<h3 class="tit_block">제품이미지</h3>
		</div>
		<c:choose>
			<c:when test="${not empty productFileList}">
				<c:forEach items="${productFileList}" var="productFileList" varStatus="status">
					<img alt="" style="width: calc(1060px / 3); height: 200px;" src="/hanbit/hanbitApplicant/habitImage.do?attachSeq=${productFileList.attachSeq}&fileSeq=${productFileList.fileSeq}">
				</c:forEach>
			</c:when>
			<c:otherwise>
				<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
			</c:otherwise>
		</c:choose>
	</div>

	<c:forEach items="${companyIntroduction}" var="companyIntroduction" varStatus="status">
	<div class="cont_block" <c:if test="${status.count%2!=0}"> style='page-break-before:always;' </c:if> >
		<div class="tit_bar">
			<h3 class="tit_block"><c:out value='${companyIntroduction.templateTitle}'/></h3>
		</div>
		<div style="background-color: #ECECEC;">
			<p style="padding: 15px; height: 430px; word-break: break-all;">${fn:replace(companyIntroduction.content, newLineChar, "<br/>")}</p>
		</div>
	</div>
	</c:forEach>

	<div class="cont_block" style='page-break-before:always;'>
		<div class="tit_bar">
			<h3 class="tit_block">이력서</h3>
		</div>
		<table class="formTable">
			<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
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
										<img alt="" style="width: 150px;" src="/hanbit/hanbitApplicant/habitImage.do?attachSeq=${ceoPhoto.attachSeq}&fileSeq=${ceoPhoto.fileSeq}">
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
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
			</colgroup>
			<tbody>
				<tr>
					<th>기간</th>
					<th>학력 및 경력 사항</th>
					<th>비고</th>
				</tr>
				<c:choose>
					<c:when test="${not empty resumeEducaCareer}">
						<c:forEach items="${resumeEducaCareer}" var="resumeEducaCareer" varStatus="status">
							<tr>
								<td>
									<c:out value='${resumeEducaCareer.eduDate}'/>
								</td>
								<td>
									<c:out value='${resumeEducaCareer.eduDscr}'/>
								</td>
								<td></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3" style="text-align: center;">
								입력된 데이터가 없습니다.
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
			</colgroup>
			<tbody>
				<tr>
					<th>기간</th>
					<th>수상경력</th>
					<th>비고</th>
				</tr>
				<c:choose>
					<c:when test="${not empty resumeAwardsInfo}">
						<c:forEach items="${resumeAwardsInfo}" var="resumeAwardsInfo" varStatus="status">
							<tr>
								<td>
									<c:out value='${resumeAwardsInfo.awardDate}'/>
								</td>
								<td>
									<c:out value='${resumeAwardsInfo.awardDscr}'/>
								</td>
								<td>
									<c:out value='${resumeAwardsInfo.issueOrg}'/>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3" style="text-align: center;">
								입력된 데이터가 없습니다.
							</td>
						</tr>
					</c:otherwise>
				</c:choose>

			</tbody>
		</table>
	</div>

<!-- 	<div class="cont_block" style='page-break-before:always;'> -->
<!-- 		<div class="tit_bar"> -->
<!-- 			<h3 class="tit_block">상세평가</h3> -->
<!-- 		</div> -->
<!-- 		<table class="formTable"> -->
<%-- 			<colgroup> --%>
<%-- 			<col width="18%"> --%>
<%-- 			<col> --%>
<%-- 			<col width="15%"> --%>
<%-- 			</colgroup> --%>
<!-- 			<tbody> -->
<!-- 				<tr> -->
<!-- 					<th>항목</th> -->
<!-- 					<th>산출근거 단위 : 천달러 , %</th> -->
<!-- 					<th>점수</th> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						1. 최근 3년 평균 수출증가율 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						4년 전 수출액 : <fmt:formatNumber value='${selectApplicantScoreStandard.beforeExpAmt}' pattern="#,###"/> 평균 수출 증가율 : <c:out value='${selectApplicantScoreStandard.extRateAvg}'/> <c:out value='${selectApplicantScoreStandard.increaseTypeCd}'/>년 연속 수출 증가 : <c:out value='${selectApplicantScoreStandard.weightRate}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						${applicantScore.extRateScore} --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						2. 수출규모 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						최근 수출 금액 : <fmt:formatNumber value='${selectApplicantScoreStandard.lastExpAmt}' pattern="#,###"/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${applicantScore.extSizeScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						3. 해외 매출 비중 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						해외 매출비중 : <c:out value='${selectApplicantScoreStandard.overRate}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${applicantScore.overRateScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						4. 직수출 비중 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						직수출비중 : <c:out value='${selectApplicantScoreStandard.directRate}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${applicantScore.directRateScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						5. 기술개발 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						기업부설 연구소 :  <c:out value="${selectApplicantScoreStandard.researchYn eq 'Y' ? 有 : '無'}"/> 국내,해외 인증 : <c:out value='${selectApplicantScoreStandard.totalCertCount}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${applicantScore.researchScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						6. 업력 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						설립연도 : <c:out value='${selectApplicantScoreStandard.sinceYear}'/>년 <c:out value='${selectApplicantScoreStandard.since}'/>년 --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${resumePersonalInfo.sinceScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						7. 재무제표 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						영업이익 달성연도 : <c:out value='${selectApplicantScoreStandard.profitYear}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						<c:out value='${applicantScore.profitScore}'/> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						8. 크레탑 신용반영 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						신용등급 :   <c:out value='${selectApplicantScoreStandard.creditRating}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						${applicantScore.creditScore} --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						9. 대표이사 재직기간 -->
<!-- 					</td> -->
<!-- 					<td> -->
<%-- 						대표이사 재직기간 : <c:out value='${selectApplicantScoreStandard.ceoTenure}'/> --%>
<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						${applicantScore.ceoScore} --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						10. 심사위원회 평가 -->
<!-- 					</td> -->
<!-- 					<td> -->

<!-- 					</td> -->
<!-- 					<td class="score align_ctr"> -->
<%-- 						${applicantScore.judgeScore} --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<th colspan="2">계</th> -->
<%-- 					<th class="totScore align_ctr">${applicantScore.totScore}</th> --%>
<!-- 				</tr> -->
<!-- 			</tbody> -->
<!-- 		</table> -->
<!-- 	</div> -->

</div>

</div>

<script type="text/javascript">


	$(document).ready(function(){

		getYear();

	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function getYear() {

		var now = new Date();	// 현재 날짜 및 시간
		var year = now.getFullYear();	// 연도
		year = year - 5;

		for(var i = 0; i < 4; i++) {
			year++;
			$('.popYearSet').append('<th>'+year+'</th>')
		}
	}

	function doPrint() {

		var _nbody = null;
        var _body = document.body; //innerHtml 이 아닌 실제 HTML요소를 따로 보관.
        var printDiv = document.createElement("div"); //프린트 할 영역의 DIV 생성(DIV높이 너비 등 설정 편하게 하기 위한 방법)


        window.onbeforeprint = function(){
            // initBody = document.body.innerHTML;

		// 프린트하는 영역도 아닌데 이를 숨기는 의도를 잘 모르겠습니다.
//              document.getElementsByClassName('btn_group')[0].style.display = "none";
             //$('#btn_group').hide();
             document.getElementById("printTable").style.height = "60%";
             document.getElementById("printTable").style.maxWidth = "100%";

            // 굳이 클래스네임은 선언하지 않아도 됩니다.
//             printDiv.className = "IBSheet_PrintDiv";
            var val = document.getElementById('printTable').innerHTML;
            document.body = _nbody = document.createElement("body");
            _nbody.appendChild(printDiv);
            printDiv.innerHTML = val; //프린트 할 DIV에 필요한 내용 삽입.
        };
        window.onafterprint = function(){
            // 프린트 후 printDiv 삭제.
            _nbody.removeChild(printDiv);
            // body영역 복원
            document.body = _body;
            //이젠 필요없으니 삭제.
            _nbody = null;
            // 아까 위에서 숨겼던 버튼들 복원.
//              document.getElementsByClassName('btn_group')[1].style.display = "";
           // $('#btn_group').show();
        };
        window.print();
	}

</script>
