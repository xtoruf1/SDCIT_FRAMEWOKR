<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="viewPopupForm" name="viewPopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<div style="width: 1170px;height: 750px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">포상신청정보</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 8%;" />
				<col style="width: 26%;" />
				<col style="width: 10%;" />
				<col style="width: 18%;" />
				<col style="width: 16%;" />
				<col />
			</colgroup>
			<tr>
				<th rowspan="2">포상명</th>
				<td rowspan="2"><c:out value="${tradeDayForm.bsnNm}" /></td>
				<th>접수기간</th>
				<td><c:out value="${tradeDayForm.bsnAplStartDt}" /> ~ <c:out value="${tradeDayForm.bsnAplEndDt}" /></td>
				<th>수출실적 당해년도</th>
				<td><c:out value="${tradeDayForm.expNowyearStartDt}" /> ~ <c:out value="${tradeDayForm.expNowyearEndDt}" /></td>
			</tr>
			<tr>
				<th>포상일</th>
				<td><c:out value="${tradeDayForm.priDt}" /></td>
				<th>수출실적 이전년도</th>
				<td><c:out value="${tradeDayForm.expBefyearStartDt}" /> ~ <c:out value="${tradeDayForm.expBefyearEndDt}" /></td>
			</tr>
		</table>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 18%;" />
					<col />
				</colgroup>
				<tr>
					<th>신청구분</th>
					<td><c:out value="${fundForm.priTypeNm}" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">업체 기본정보</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 10%;" />
					<col style="width: 16%;" />
					<col style="width: 10%;" />
					<col style="width: 18%;" />
					<col style="width: 8%;" />
					<col style="width: 8%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">무역업고유번호</th>
					<td><c:out value="${fundForm.memberId}" /></td>
					<th>법인번호</th>
					<td><c:out value="${fundForm.corpoNo}" /></td>
					<th colspan="2">사업자등록번호</th>
					<td><c:out value="${fundForm.bsNo}" /></td>
				</tr>
				<tr>
					<th rowspan="3">회사명</th>
					<th>국문</th>
					<td colspan="3"><c:out value="${fundForm.coNmKr}" /></td>
					<th rowspan="3">대표자</th>
					<th>국문</th>
					<td><c:out value="${fundForm.ceoKr}" /></td>
				</tr>
				<tr>
					<th>영문</th>
					<td colspan="3"><c:out value="${fundForm.coNmEn}" /></td>
					<th>영문</th>
					<td><c:out value="${fundForm.ceoEn}" /></td>
				</tr>
				<tr>
					<th>한자</th>
					<td colspan="3"><c:out value="${common:reverseXss(fundForm.coNmCh)}" escapeXml="false" /></td>
					<th>한자</th>
					<td><c:out value="${common:reverseXss(fundForm.ceoNmCh)}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th rowspan="3">주소</th>
					<th rowspan="2">국문</th>
					<td colspan="3">
						<c:out value="${coZipCd1}" /> - <c:out value="${coZipCd2}" />
						<c:out value="${fundForm.coAddr1}" />
					</td>
					<th colspan="2">회사전화번호</th>
					<td><c:out value="${fundForm.coPhone}" /></td>
				</tr>
				<tr>
					<td colspan="3"><c:out value="${fundForm.coAddr2}" /></td>
					<th colspan="2">회사팩스번호</th>
					<td><c:out value="${fundForm.coFax}" /></td>
				</tr>
				<tr>
					<th>영문</th>
					<td colspan="3"><c:out value="${fundForm.coAddrEn}" /></td>
					<th colspan="2">대표휴대전화</th>
					<td class="phoneNum"><c:out value="${coHp}" /></td>
				</tr>
				<tr>
					<th rowspan="2">홈페이지<br />주소</th>
					<th>한글URL</th>
					<td colspan="3"><c:out value="${fundForm.coHomepage}" /></td>
					<th rowspan="2" colspan="2">대표 E-Mail</th>
					<td rowspan="2"><c:out value="${fundForm.coEmail}" /></td>
				</tr>
				<tr>
					<th>영문URL</th>
					<td colspan="3"><c:out value="${fundForm.co_homepageEn}" /></td>
				</tr>
				<tr>
					<th rowspan="3">담당자</th>
					<th>성명</th>
					<td><c:out value="${fundForm.userNm}" /></td>
					<th>부서명</th>
					<td><c:out value="${fundForm.userDeptNm}" /></td>
					<th colspan="2">직위명</th>
					<td><c:out value="${fundForm.userPosition}" /></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td class="phoneNum"><c:out value="${userPhone}" /></td>
					<th>팩스번호</th>
					<td class="phoneNum"><c:out value="${userFax}" /></td>
					<th colspan="2">휴대전화</th>
					<td class="phoneNum"><c:out value="${userHp}" /></td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td colspan="6"><c:out value="${fundForm.userEmail}" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">신청탑</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 18%;" />
					<col />
				</colgroup>
				<tr>
					<th>신청탑 종류</th>
					<td><c:out value="${fundForm.expTapPrizeNm}" /></td>
				</tr>
				<c:set var="priTapRow" value="1" />
				<c:choose>
					<c:when test="${fundForm.priTapYn eq 'Y'}">
						<c:set var="priTapRow" value="1" />
					</c:when>
					<c:when test="${fundForm.priTapYn eq 'N'}">
						<c:set var="priTapRow" value="2" />
					</c:when>
				</c:choose>
				<tr>
					<th rowspan="${priTapRow}">과거수상수출탑</th>
					<td>위에서 선택한 수출의 탑 단위의 실적을 금년도에 처음으로 달성하였습니까?&nbsp;&nbsp;<span style="font: bold;"><c:out value="${fundForm.priTapYnNm}" /></span></td>
				</tr>
				<c:if test="${fundForm.priTapYn eq 'N'}">
					<tr>
						<td>과거에 달성한 수출의 탑 실적년도 (<c:out value="${fundForm.pastYer}" />) 수출액 $ (<c:out value="${fundForm.pastRcd}" />)</td>
					</tr>
				</c:if>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">신청업체</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 18%;" />
					<col style="width: 16%;" />
					<col style="width: 12%;" />
					<col style="width: 16%;" />
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<c:set var="indusCnt" value="${fn:length(indusNoList)}" />
				<tr>
					<th rowspan="${indusCnt + 1}">사업장</th>
					<th colspan="4">주소(공장,사무소 등 전사업장)</th>
					<th>산재보험관리번호</th>
				</tr>
				<c:if test="${indusCnt > 0}">
					<c:forEach var="indus" items="${indusNoList}" varStatus="statusNo">
						<tr>
							<td colspan="4">
								<c:out value="${indus.officeNm}" />
								<c:out value="${indus.addr}" />
							</td>
							<td align="center">
								<c:out value="${indus.indusNo1}" />-<c:out value="${indus.indusNo2}" />
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<tr>
					<th>기업구분</th>
					<td><c:out value="${fundForm.scaleNm}" /></td>
					<th>전년도매출액(원)</th>
					<td><fmt:formatNumber value="${fundForm.salAmount}" pattern="#,###" /></td>
					<th>주거래 은행명</th>
					<td><c:out value="${fundForm.mainBankCd}" /></td>
				</tr>
				<tr>
					<th>본사소재지</th>
					<td><c:out value="${fundForm.bonsaYnNm}" /></td>
					<th>종업원수(명)</th>
					<td><fmt:formatNumber value="${fundForm.workerCnt}" pattern="#,###" /></td>
					<th>은행 지점명</th>
					<td><c:out value="${fundForm.mainBankbranchNm}" /></td>
				</tr>
				<tr>
					<th>제조업구분</th>
					<td><c:out value="${fundForm.jejoupYnNm}" /></td>
					<th>자본금(원)</th>
					<td><fmt:formatNumber value="${fundForm.capital}" pattern="#,###" /></td>
					<th>은행 담당자</th>
					<td><c:out value="${fundForm.mainBankWrkNm}" /></td>
				</tr>
				<tr>
					<th>서비스업 업체여부</th>
					<td><c:out value="${fundForm.serviceYnNm}" /></td>
					<th>설립년도</th>
					<td><c:out value="${fundForm.coCretYear}" /></td>
					<th>은행 전화번호</th>
					<td class="phoneNum"><c:out value="${mainBankPhone}" /></td>
				</tr>
				<tr>
					<th>농림수산업 수출업 영위업체</th>
					<td><c:out value="${fundForm.agrifoodYnNm}" /></td>
					<th>상장회사</th>
					<td colspan="3"><c:out value="${fundForm.stockYnNm}" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">당해년도 주종 수출품목(금액순)</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 18%;" />
					<col />
					<col style="width: 18%;" />
					<col />
				</colgroup>
				<tr>
					<th>1) HSCODE</th>
					<td><c:out value="${fundForm.expItemHscode1}" /></td>
					<th>품명</th>
					<td><c:out value="${fundForm.expItemNm1}" /></td>
				</tr>
				<tr>
					<th>2) HSCODE</th>
					<td><c:out value="${fundForm.expItemHscode2}" /></td>
					<th>품명</th>
					<td><c:out value="${fundForm.expItemNm2}" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">수출실적</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col style="width: 14%;" />
					<col style="width: 14%;" />
					<col style="width: 14%;" />
					<col style="width: 14%;" />
					<col style="width: 14%;" />
					<col style="width: 14%;" />
				</colgroup>
				<tr>
					<th>구분</th>
					<th>전전년도(US$)</th>
					<th>전년도(US$)</th>
					<th>당해년도(US$)</th>
					<th>증가율(%)</th>
					<th>구분</th>
					<th>당해년도</th>
				</tr>
				<tr>
					<th>직수출(A)</th>
					<td><input type="text" name="twoDrExpAmt" value="<fmt:formatNumber value="${fundForm.twoDrExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도직수출" readonly="readonly" /></td>
					<td><input type="text" name="pastDrExpAmt" value="<fmt:formatNumber value="${fundForm.pastDrExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도직수출" readonly="readonly" /></td>
					<td><input type="text" name="currDrExpAmt" value="<fmt:formatNumber value="${fundForm.currDrExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도직수출" readonly="readonly" /></td>
					<td><input type="text" name="expAmtRate" value="<fmt:formatNumber value="${fundForm.expAmtRate}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="직수출증가율" readonly="readonly" /></td>
					<th>수입실적(US$)</th>
					<td align="right"><input type="text" name="impSiljuk" value="<fmt:formatNumber value="${fundForm.impSiljuk}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
				</tr>
				<tr>
					<th>로컬등 기타수출(B)</th>
					<td><input type="text" name="twoLcExpAmt" value="<fmt:formatNumber value="${fundForm.twoLcExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" /></td>
					<td><input type="text" name="pastLcExpAmt" value="<fmt:formatNumber value="${fundForm.pastLcExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" /></td>
					<td><input type="text" name="currLcExpAmt" value="<fmt:formatNumber value="${fundForm.currLcExpAmt}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" /></td>
					<td><input type="text" name="lcExpAmtRate" value="<fmt:formatNumber value="${fundForm.lcExpAmtRate}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
					<th rowspan="2">무역수지(US$)<br />(외화가득율 %)</th>
					<td rowspan="2" align="right">
						<div>
							<input type="text" name="tradeIndex" value="<fmt:formatNumber value="${fundForm.tradeIndex}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" />
						</div>
						<div style="padding-top:5px;">
							<span style="vertical-align: middle;">(</span><input type="text" name="tradeIndexImprvRate" value="<fmt:formatNumber value="${fundForm.tradeIndexImprvRate}" pattern="#,###" />" maxlength="20" class="form_text" style="width: 45%;text-align: right;" readonly="readonly" /><span style="vertical-align: middle;">)</span>
						</div>
					</td>
				</tr>
				<tr>
					<th>합계(A+B)</th>
					<td><input type="text" name="twoExpAmtSum" value="<fmt:formatNumber value="${fundForm.twoExpAmtSum}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도합계" readonly="readonly" /></td>
					<td><input type="text" name="pastExpAmtSum" value="<fmt:formatNumber value="${fundForm.pastExpAmtSum}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도합계" readonly="readonly" /></td>
					<td><input type="text" name="currExpAmtSum" value="<fmt:formatNumber value="${fundForm.currExpAmtSum}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도합계" readonly="readonly" /></td>
					<td><input type="text" name="expAmtSumRate" value="<fmt:formatNumber value="${fundForm.expAmtSumRate}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="합계증가율" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">시장개척(당해년도 직수출)</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col style="width: 42%;" />
					<col style="width: 42%;" />
				</colgroup>
				<tr>
					<th>5대시장(US$)</th>
					<td>
						<input type="text" name="dvlpExploAmt" value="<fmt:formatNumber value="${fundForm.dvlpExploAmt}" pattern="#,###" />" maxlength="20" class="form_text" style="width: 30%;text-align: right;" readonly="readonly" />
						(<input type="text" name="dvlpExploAmtPor" value="<fmt:formatNumber value="${fundForm.dvlpExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text" style="width: 15%;text-align: right;" readonly="readonly" /> %)
					</td>
					<td>중국,미국,일본,홍콩,베트남</td>
				</tr>
				<tr>
					<th>기타시장(US$)</th>
					<td>
						<input type="text" name="newMktExploAmt" value="<fmt:formatNumber value="${fundForm.newMktExploAmt}" pattern="#,###" />" maxlength="20" class="form_text" style="width: 30%;text-align: right;" readonly="readonly" />
						(<input type="text" name="newMktExploAmtPor" value="<fmt:formatNumber value="${fundForm.newMktExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text" style="width: 15%;text-align: right;" readonly="readonly" /> %)
					</td>
					<td>5대 시장을 제외한 전 지역</td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">기술개발</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col style="width: 8%;" />
					<col />
					<col style="width: 8%;" />
					<col />
					<col style="width: 8%;" />
					<col />
				</colgroup>
				<tr>
					<th>신기술개발</th>
					<th>품목명</th>
					<td colspan="3"><c:out value="${fundForm.newTechItemNm}" /></td>
					<th>인증기관</th>
					<td><c:out value="${fundForm.newTechTerm}" /></td>
				</tr>
				<tr>
					<th>정부기술개발참여</th>
					<th>사업명</th>
					<td colspan="3"><c:out value="${fundForm.govTechNm}" /></td>
					<th>시행기관</th>
					<td><c:out value="${fundForm.govTechInst}" /></td>
				</tr>
				<tr>
					<th>수입대체상품생산</th>
					<th>품목명</th>
					<td colspan="3"><c:out value="${fundForm.impReplItemNm}" /></td>
					<th>품목수</th>
					<td align="right"><fmt:formatNumber value="${fundForm.impReplItemCnt}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>자기상표제품수출</th>
					<th>상표명</th>
					<td><c:out value="${fundForm.selfBrandExpItemNm}" /></td>
					<th>상표수</th>
					<td align="right"><fmt:formatNumber value="${fundForm.selfBrandExpCnt}" pattern="#,###" /></td>
					<th>품목수</th>
					<td align="right"><fmt:formatNumber value="${fundForm.selfBrandExpItemCnt}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">회사 공적사항</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col />
				</colgroup>
				<tr>
					<th colspan="3" style="text-align: left;">공적 내용</th>
				</tr>
				<tr>
					<td colspan="3">
						1) 기본사항<br /><br />
						<c:out value="${common:reverseXss(fundForm.kongjukItem1)}" escapeXml="false" />
						<br /><br />
						2) 수출실적<br /><br />
						<c:out value="${common:reverseXss(fundForm.kongjukItem2)}" escapeXml="false" />
						<br /><br />
						3) 기술개발 및 품질향상 노력<br /><br />
						<c:out value="${common:reverseXss(fundForm.kongjukItem3)}" escapeXml="false" />
						<br /><br />
						4) 해외시장 개척활동<br /><br />
						<c:out value="${common:reverseXss(fundForm.kongjukItem4)}" escapeXml="false" />
						<c:if test="${not empty fundForm.kongjukEtc}">
							<br /><br />
							5) 기타 공적내용<br /><br />
							<c:out value="${common:reverseXss(fundForm.kongjukEtc)}" escapeXml="false" />
						</c:if>
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<c:set var="fileAttachCnt" value="${fn:length(fileAttachList)}" />
				<tr>
					<th rowspan="${fileAttachCnt + 1}">첨부파일</th>
					<c:choose>
						<c:when test="${fileAttachCnt eq 0}">
							<td>&nbsp;</td>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${fileAttachList}" varStatus="status">
								<c:if test="${status.index eq 0}">
									<td>
										<div class="addedFile">
											<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
										</div>
									</td>
								</c:if>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tr>
				<c:if test="${fileAttachCnt > 0}">
					<c:forEach var="item" items="${fileAttachList}" varStatus="status">
						<c:if test="${status.index ne 0}">
							<tr>
								<td>
									<div class="addedFile">
										<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
									</div>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</c:if>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 12%;" />
					<col style="width: 9%;" />
					<col style="width: 9%;" />
					<col style="width: 12%;" />
					<col style="width: 6%;" />
					<col style="width: 6%;" />
					<col style="width: 25%;" />
					<col style="width: 11%;" />
				</colgroup>
				<tr>
					<th colspan="9">유공자</th>
				</tr>
				<tr>
					<th>구분</th>
					<th>추천자</th>
					<th>성명</th>
					<th>직위</th>
					<th>주민등록번호</th>
					<th colspan="2">근무기간(수공기간)</th>
					<th>과거포상기록</th>
					<th>공적조서/이력서</th>
				</tr>
				<c:set var="refCnt" value="0" />
				<c:if test="${fundForm.priType eq 'S'}">
					<c:set var="refCnt" value="${refCnt + 1}" />
					<tr>
						<th>특수유공자</th>
						<th>대표자</th>
						<td align="center"><c:out value="${fundForm.spUserNmKor}" /></td>
						<td align="center"><c:out value="${fundForm.spPos}" /></td>
						<td align="center"><c:out value="${fundForm.spJuminNo}" /></td>
						<td align="right"><c:out value="${fundForm.spCurwrkTermYy}" /> 년</td>
						<td align="right"><c:out value="${fundForm.spCurwrkTermMm}" /> 개월</td>
						<td align="left"><c:out value="${fundForm.spHistory}" /></td>
						<td align="center"><button type="button" onclick="showKongPopup('30');" class="btn_tbl_border" title="특수유공자공적조서입력">조회</button></td>
					</tr>
				</c:if>
				<c:if test="${fundForm.priType eq 'A' or fundForm.priType eq 'T'}">
					<c:set var="refCnt" value="${refCnt + 1}" />
					<tr>
						<th>수출의탑</th>
						<th>수출의탑(대표자)</th>
						<td align="center"><c:out value="${fundForm.ceoUserNmKor0}" /></td>
						<td align="center"><c:out value="${fundForm.ceoPos0}" /></td>
						<td align="center"><c:out value="${fundForm.ceoJuminNo0}" /></td>
						<td align="right"><c:out value="${fundForm.ceoCurwrkTermYy0}" /> 년</td>
						<td align="right"><c:out value="${fundForm.ceoCurwrkTermMm0}" /> 개월</td>
						<td align="left"><c:out value="${fundForm.ceoHistory0}" /></td>
						<td align="center"><button type="button" onclick="showKongPopup('10');" class="btn_tbl_border" title="수출의탑(대표자)공적조서입력">조회</button></td>
					</tr>
				</c:if>
				<c:if test="${fundForm.priType eq 'A' or fundForm.priType eq 'P'}">
					<c:set var="refCnt" value="${refCnt + 1}" />
					<tr>
						<th rowspan="4">개인포상</th>
						<th>대표자</th>
						<td align="center"><c:out value="${fundForm.ceoUserNmKor}" /></td>
						<td align="center"><c:out value="${fundForm.ceoPos}" /></td>
						<td align="center"><c:out value="${fundForm.ceoJuminNo}" /></td>
						<td align="right"><c:out value="${fundForm.ceoCurwrkTermYy}" /> 년</td>
						<td align="right"><c:out value="${fundForm.ceoCurwrkTermMm}" /> 개월</td>
						<td align="left"><c:out value="${fundForm.ceoHistory}" /></td>
						<td align="center"><button type="button" onclick="showKongPopup('21');" class="btn_tbl_border" title="대표자공적조서입력">조회</button></td>
					</tr>
					<tr>
						<th>종업원(사무직)</th>
						<td align="center"><c:out value="${fundForm.empUserNmKor}" /></td>
						<td align="center"><c:out value="${fundForm.empPos}" /></td>
						<td align="center"><c:out value="${fundForm.empJuminNo}" /></td>
						<td align="right"><c:out value="${fundForm.empCurwrkTermYy}" /> 년</td>
						<td align="right"><c:out value="${fundForm.empCurwrkTermMm}" /> 개월</td>
						<td align="left"><c:out value="${fundForm.empHistory}" /></td>
						<td align="center"><button type="button" onclick="showKongPopup('22');" class="btn_tbl_border" title="종업원(사무직)공적조서입력">조회</button></td>
					</tr>
					<tr>
						<th>종업원(생산직)</th>
						<td align="center"><c:out value="${fundForm.workUserNmKor}" /></td>
						<td align="center"><c:out value="${fundForm.workPos}" /></td>
						<td align="center"><c:out value="${fundForm.workJuminNo}" /></td>
						<td align="right"><c:out value="${fundForm.workCurwrkTermYy}" /> 년</td>
						<td align="right"><c:out value="${fundForm.workCurwrkTermMm}" /> 개월</td>
						<td align="left"><c:out value="${fundForm.workHistory}" /></td>
						<td align="center"><button type="button" onclick="showKongPopup('23');" class="btn_tbl_border" title="종업원(생산직)공적조서입력">조회</button></td>
					</tr>
					<tr>
						<th>공동대표</th>
						<td colspan="2"><c:out value="${fundForm.jointCeoKr}" /></td>
						<th>수상이력</th>
						<td colspan="4"><c:out value="${fundForm.jointCeoHistory}" /></td>
					</tr>
				</c:if>
				<c:if test="${refCnt eq 0}">
					<tr>
						<td colspan="9" align="center">데이터가 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col />
					<col style="width: 11%;" />
				</colgroup>
				<c:choose>
					<c:when test="${fundForm.priType eq 'A' or fundForm.priType eq 'P'}">
						<tr>
							<th rowspan="3">동시신청<br />(수출의탑+일반유공)<br />또는<br />일반유공 신청</th>
							<td><input type="checkbox" name="reportGb1" value="Y" class="form_checkbox" /> 수출업체종사자 포상신청서</td>
							<td rowspan="3" align="center">
								<button type="button" onclick="doReport('1');" class="btn_tbl_border" title="출력">출력</button>
							</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="reportGb2" value="Y" class="form_checkbox" /> 공적조서</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="reportGb3" value="Y" class="form_checkbox" /> 이력서</td>
						</tr>
					</c:when>
					<c:when test="${fundForm.priType eq 'S'}">
						<tr>
							<th>특수유공</th>
							<td>특수유공 출력</td>
							<td align="center">
								<button type="button" onclick="doReport('S');" class="btn_tbl_border" title="출력">출력</button>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th rowspan="2">수출의 탑만 신청</th>
							<td><input type="checkbox" name="reportGb4" value="Y" class="form_checkbox" /> 수출의 탑 신청서</td>
							<td rowspan="2" align="center">
								<button type="button" onclick="doReport('2');" class="btn_tbl_border" title="출력">출력</button>
							</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="reportGb5" value="Y" class="form_checkbox" /> 대표자 이력서</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="mt-10">&nbsp;</div>
	</div>
</div>
</form>
<form id="viewPopupDownloadForm" name="viewPopupDownloadForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="fileId" value="" />
<input type="hidden" name="fileNo" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		var f = document.viewPopupForm;

		doCalculate();

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#viewPopupForm .phoneNum'], 'R');

		// 로딩이미지 종료
		$('#loading_image').hide();
	});

	function doCalculate() {
		var f = document.viewPopupForm;

		// 직수출 계산
		calculateDrExpAmt(f);
		// 로컬등 기타수출
		calculateLcExpAmt(f);
		// 합계
		calculateAmtSum(f);
		// 무역수지, 외화가득률 계산법
		calculateTradeIndex(f);
		// 5대시장 비중
		calculateDvlpExploAmtPor(f);
		// 기타시장 비중
		calculateNewMktExploAmtPor(f);
	}

	// 직수출 계산
	function calculateDrExpAmt(f) {
		var vTwoDrExpAmt = '';
		var vPastDrExpAmt = '';
		var vCurrDrExpAmt = '';

		var vExpAmtRate = '';
		var vTwoAmtRate = '';
		var vPastAmtRate = '';

		if (f.twoDrExpAmt.value == '') {
			f.twoDrExpAmt.value = 0;
		}
		if (f.pastDrExpAmt.value == '') {
			f.pastDrExpAmt.value = 0;
		}
		if (f.currDrExpAmt.value == '') {
			f.currDrExpAmt.value = 0;
		}

		vTwoDrExpAmt = parseFloat(f.twoDrExpAmt.value.replace(/,/gi, ''));
		vPastDrExpAmt = parseFloat(f.pastDrExpAmt.value.replace(/,/gi, ''));
		vCurrDrExpAmt = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''));

		f.twoDrExpAmt.value = plusComma(vTwoDrExpAmt);
		f.pastDrExpAmt.value = plusComma(vPastDrExpAmt);
		f.currDrExpAmt.value = plusComma(vCurrDrExpAmt);

		if (f.twoDrExpAmt.value == 0) {
			if (f.pastDrExpAmt.value == 0) {
				vTwoAmtRate = 0;
			} else {
				vTwoAmtRate = 100;
			}
		} else {
			vTwoAmtRate = ((vPastDrExpAmt - vTwoDrExpAmt) / vTwoDrExpAmt) * 100;
		}

		if (f.pastDrExpAmt.value == 0) {
			if (f.currDrExpAmt.value == 0) {
				vPastAmtRate = 0;
			} else {
				vPastAmtRate = 100;
			}
		} else {
			vPastAmtRate = ((vCurrDrExpAmt - vPastDrExpAmt) / vPastDrExpAmt) * 100;
		}

		vExpAmtRate = (vTwoAmtRate + vPastAmtRate) / 2;
		f.expAmtRate.value = plusComma(Math.round(vExpAmtRate * 100) / 100);
	}

	// 로컬등 기타수출
	function calculateLcExpAmt(f) {
		var vTwoLcExpAmt = '';
		var vPastLcExpAmt = '';
		var vCurrLcExpAmt = '';

		var vLcExpAmtRate = '';
		var vTwoLcExpAmtRate = '';
		var vPastLcExpAmtRate = '';

		if (f.twoLcExpAmt.value == '') {
			f.twoLcExpAmt.value = 0;
		}
		if (f.pastLcExpAmt.value == '') {
			f.pastLcExpAmt.value = 0;
		}
		if (f.currLcExpAmt.value == '') {
			f.currLcExpAmt.value = 0;
		}

		if (doNumberCheck(f.twoLcExpAmt.value.replace(/,/gi, '')) == false) {
			f.twoLcExpAmt.value = 0;
		}
		if (doNumberCheck(f.pastLcExpAmt.value.replace(/,/gi, '')) == false) {
			f.pastLcExpAmt.value = 0;
		}
		if (doNumberCheck(f.currLcExpAmt.value.replace(/,/gi, '')) == false) {
			f.currLcExpAmt.value = 0;
		}

		vTwoLcExpAmt = parseFloat(f.twoLcExpAmt.value.replace(/,/gi, ''));
		vPastLcExpAmt = parseFloat(f.pastLcExpAmt.value.replace(/,/gi, ''));
		vCurrLcExpAmt = parseFloat(f.currLcExpAmt.value.replace(/,/gi, ''));

		f.twoLcExpAmt.value = plusComma(vTwoLcExpAmt);
		f.pastLcExpAmt.value = plusComma(vPastLcExpAmt);
		f.currLcExpAmt.value = plusComma(vCurrLcExpAmt);

		if (f.twoLcExpAmt.value == 0) {
			if (f.pastLcExpAmt.value == 0) {
				vTwoLcExpAmtRate = 0;
			} else {
				vTwoLcExpAmtRate = 100;
			}
		} else {
			vTwoLcExpAmtRate = ((vPastLcExpAmt - vTwoLcExpAmt) / vTwoLcExpAmt) * 100;
		}

		if (f.pastLcExpAmt.value == 0) {
			if (f.currLcExpAmt.value == 0) {
				vPastLcExpAmtRate = 0;
			} else {
				vPastLcExpAmtRate = 100;
			}
		} else {
			vPastLcExpAmtRate = ((vCurrLcExpAmt - vPastLcExpAmt) / vPastLcExpAmt) * 100;
		}

		vLcExpAmtRate = (vTwoLcExpAmtRate + vPastLcExpAmtRate) / 2;
		f.lcExpAmtRate.value = plusComma(Math.round(vLcExpAmtRate * 100) /100);
	}

	// 합계
	function calculateAmtSum(f) {
		var vTwoExpAmtSum = parseFloat(f.twoDrExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.twoLcExpAmt.value.replace(/,/gi, ''));

		var vPastExpAmtSum = parseFloat(f.pastDrExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.pastLcExpAmt.value.replace(/,/gi, ''));

		var vCurrExpAmtSum = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.currLcExpAmt.value.replace(/,/gi, ''));

		var vExpAmtSumRate = 0;
		var vTwoExpSumRate = 0;
		var vPastExpSumRate = 0;

		f.twoExpAmtSum.value = plusComma(vTwoExpAmtSum);
		f.pastExpAmtSum.value = plusComma(vPastExpAmtSum);
		f.currExpAmtSum.value = plusComma(vCurrExpAmtSum);

		if (f.twoExpAmtSum.value == 0) {
			if (f.pastExpAmtSum.value == 0) {
				vTwoExpSumRate = 0;
			} else {
				vTwoExpSumRate = 100;
			}
		} else {
			vTwoExpSumRate = ((vPastExpAmtSum - vTwoExpAmtSum) / vTwoExpAmtSum) * 100;
		}

		if (f.pastExpAmtSum.value == 0) {
			if (f.currExpAmtSum.value == 0) {
				vPastExpSumRate = 0;
			} else {
				vPastExpSumRate = 100;
			}
		} else {
			vPastExpSumRate = ((vCurrExpAmtSum - vPastExpAmtSum) / vPastExpAmtSum) * 100;
		}

		vExpAmtSumRate = (vTwoExpSumRate + vPastExpSumRate) / 2;
		f.expAmtSumRate.value = plusComma(Math.round(vExpAmtSumRate * 100) / 100);
	}

	// 무역수지, 외화가득률 계산법
	function calculateTradeIndex(f) {
		if (f.impSiljuk.value == '') {
			f.impSiljuk.value  = 0;
		}

		var vCurrExpAmtSum = parseFloat(f.currExpAmtSum.value.replace(/,/gi, ''));
		var vTradeIndex =  parseFloat(f.currExpAmtSum.value.replace(/,/gi, ''))
			- parseFloat(f.impSiljuk.value.replace(/,/gi, ''));
		var vTradeIndexImprvRate = 0;

		f.tradeIndex.value = plusComma(vTradeIndex);
		f.impSiljuk.value = plusComma(parseFloat(f.impSiljuk.value.replace(/,/gi, '')));

		if (f.currExpAmtSum.value == 0) {
			vTradeIndexImprvRate = 0;
		} else {
			vTradeIndexImprvRate = (vTradeIndex / vCurrExpAmtSum) * 100;
		}

		f.tradeIndexImprvRate.value = plusComma(Math.round(vTradeIndexImprvRate));
	}

	// 5대시장 비중
	function calculateDvlpExploAmtPor(f) {
		var vDvlpExploAmt = 0;
		var vDvlpExploAmtPor = 0;

		var vCurrDrExpAmt = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''));

		if (f.dvlpExploAmt.value == '') {
			f.dvlpExploAmt.value = 0;
		}

		vDvlpExploAmt = parseFloat(f.dvlpExploAmt.value.replace(/,/gi, ''));
		f.dvlpExploAmt.value = plusComma(vDvlpExploAmt);

		if (f.currDrExpAmt.value == 0) {
			vDvlpExploAmtPor = 0;
		} else {
			vDvlpExploAmtPor = (vDvlpExploAmt / vCurrDrExpAmt) * 100;
		}

		f.dvlpExploAmtPor.value = plusComma(Math.round(vDvlpExploAmtPor));
	}

	// 기타시장 비중
	function calculateNewMktExploAmtPor(f) {
		var vNewMktExploAmt = 0;
		var vNewMktExploAmtPor = 0;

		var vCurrDrExpAmt = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''));

		if (f.newMktExploAmt.value == '') {
			f.newMktExploAmt.value = 0;
		}

		vNewMktExploAmt = parseFloat(f.newMktExploAmt.value.replace(/,/gi, ''));
		f.newMktExploAmt.value = plusComma(vNewMktExploAmt);

		if (f.currDrExpAmt.value == 0) {
			vNewMktExploAmtPor = 0;
		} else {
			vNewMktExploAmtPor = (vNewMktExploAmt / vCurrDrExpAmt) * 100;
		}

		f.newMktExploAmtPor.value = plusComma(Math.round(vNewMktExploAmtPor));
	}

	function doNumberCheck(val) {
		var checkNum = /[0-9]/;

		if (!checkNum.test(val)) {
			alert('숫자가 아닙니다.');

			return false;
		}

		return true;
	}

	function doReport(val) {
		var f = document.viewPopupForm;

		var url = '';
		<c:choose>
			<c:when test="${profile eq 'prod'}">
				url = 'https://membership.kita.net/fai/award/popup/tradeDayInquiryPrint.do?svr_id=' + f.svrId.value + '&apply_seq=' + f.applySeq.value;
			</c:when>
			<c:otherwise>
				url = 'https://devmembership.kita.net/fai/award/popup/tradeDayInquiryPrint.do?svr_id=' + f.svrId.value + '&apply_seq=' + f.applySeq.value;
			</c:otherwise>
		</c:choose>

		if (val == '1') {
			if (f.reportGb1.checked == false && f.reportGb2.checked == false && f.reportGb3.checked == false) {
				alert('출력할 문서를 체크해 주세요.');

				return;
			}

			if (f.reportGb1.checked == true) {
				url += '&reportGB1=Y';
			}
			if (f.reportGb2.checked == true) {
				url += '&reportGB2=Y';
			}
			if (f.reportGb3.checked == true) {
				url += '&reportGB3=Y';
			}
		} else if (val == '2') {
			if (f.reportGb4.checked == false && f.reportGb5.checked == false) {
				alert('출력할 문서를 체크해 주세요.');

				return;
			}

			if (f.reportGb4.checked == true) {
				url += '&reportGB4=Y';
			}
			if (f.reportGb5.checked == true) {
				url += '&reportGB5=Y';
			}
		} else if (val == 'S') {
			url += '&reportGB2=Y';			// 공적조서
			url += '&reportGB3=Y';			// 이력서
		}

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}
	}

	function showKongPopup(val) {
		// 로딩이미지 시작
		$('#loading_image').show();

		var f = document.viewPopupForm;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayInquiryPopup.do" />'
			, params : {
				event : 'TradeDayInquiryPopupSearch'
				, svrId : f.svrId.value
			    , applySeq : f.applySeq.value
			    , prvPriType : val
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	// 첨부파일 다운로드
	function doDownloadFile(fileId, fileNo) {
		var f = document.viewPopupDownloadForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = fileId;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>