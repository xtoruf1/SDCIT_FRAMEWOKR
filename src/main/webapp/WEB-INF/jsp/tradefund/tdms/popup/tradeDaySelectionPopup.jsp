<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<%@ page import="java.util.List" %>
<%@ page import="egovframework.common.vo.CommonHashMap" %>
<%@ page import="egovframework.common.util.StringUtil" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="selectionPopupForm" name="selectionPopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<input type="hidden" name="prvPriType" value="" />
<input type="hidden" name="statusChk" value="<c:out value="${param.statusChk}" />" />
<c:set var="indusNoCnt" value="${fn:length(indusNoList)}" />
<div style="width: 1170px;height: 750px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">신청서 평가 - 조정</h2>
		<div class="ml-auto">
			<c:if test="${editYn eq 'Y'}">
				<button type="button" onclick="doSelectionSave();" class="btn_sm btn_primary btn_modify_auth">저장 및 선정</button>
			</c:if>
		</div>
		<div class="ml-15">
			<c:if test="${not empty param.applySeq}">
				<button type="button" onclick="doSelectionReport();" class="btn_sm btn_primary">신청서 출력</button>
			</c:if>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 8%;" />
				<col style="width: 28%;" />
				<col style="width: 10%;" />
				<col style="width: 20%;" />
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
					<col style="width: 18%;" />
					<col style="width: 10%;" />
					<col style="width: 20%;" />
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<tr>
					<th>신청구분</th>
					<td>
						<fieldset class="widget">
							<select id="priType" name="priType" onchange="changePriType(this);" class="form_select" style="width: 100%;" title="신청구분">
								<c:forEach var="item" items="${awd001}" varStatus="status">
									<c:choose>
										<c:when test="${param.priType eq 'S'}">
											<c:if test="${item.chgCode02 eq 'S2'}">
												<option value="<c:out value="${item.detailcd}" />" <c:if test="${priType eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
											</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${item.chgCode02 eq 'S1'}">
												<option value="<c:out value="${item.detailcd}" />" <c:if test="${priType eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
											</c:if>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</fieldset>
					</td>
					<th>접수번호</th>
					<td><div style="color: red;font-weight: bold;"><c:out value="${fundForm.receiptNoNm}" /></div></td>
					<th>대리신청여부</th>
					<td><c:out value="${fundForm.proxyYn eq 'Y' ? '대리신청' : '기업신청'}" /></td>
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
					<td>
						<c:out value="${fundForm.memberId}" />
						<input type="hidden" id="memberId" name="memberId" value="<c:out value="${fundForm.memberId}" />" />
					</td>
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
						<c:out value="${fundForm.coZipCd}" />
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
					<td class="phoneNum"><c:out value="${fundForm.coHp}" /></td>
				</tr>
				<tr>
					<th colspan="2">홈페이지 주소</th>
					<td colspan="3"><c:out value="${fundForm.coHomepage}" /></td>
					<th colspan="2">E-Mail</th>
					<td><c:out value="${fundForm.coEmail}" /></td>
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
					<td class="phoneNum"><c:out value="${fundForm.userPhone}" /></td>
					<th>팩스번호</th>
					<td class="phoneNum"><c:out value="${fundForm.userFax}" /></td>
					<th colspan="2">휴대전화</th>
					<td class="phoneNum"><c:out value="${fundForm.userHp}" /></td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td colspan="6">
						<c:out value="${fundForm.userEmail}" />
						<c:if test="${not empty fundForm.userEmail2}">
							<br />
							<c:out value="${fundForm.userEmail2}" />
						</c:if>
					</td>
				</tr>
			</table>
		</div>
		<c:if test="${param.priType ne 'S'}">
			<div class="flex">
				<h3 style="margin-top: 20px;">신청업체 상세정보</h3>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 8%;" />
						<col style="width: 18%;" />
						<col />
						<col style="width: 21%;" />
					</colgroup>
					<tr>
						<th rowspan="6">신청탑</th>
						<th>신청탑종류</th>
						<td colspan="2">
							<select id="expTapPrizeCd" name="expTapPrizeCd" class="form_select" style="width: 20%;" title="신청탑종류">
								<option value="">::: 선택 :::</option>
								<c:forEach var="item" items="${expTabCode}" varStatus="status">
									<option value="<c:out value="${item.prizeCd}" />" <c:if test="${fundForm.expTapPrizeCd eq item.prizeCd}">selected="selected"</c:if>><c:out value="${item.prizeName}" /></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>수출의탑 업체명</th>
						<td colspan="2"><c:out value="${fundForm.tapCoNmKr}" /></td>
					</tr>
					<!--
					<tr>
						<th>수출의탑 대표자명</th>
						<td colspan="2"><c:out value="${fundForm.tapCeoNmKr}" /></td>
					</tr>
					-->
					<tr>
						<th>과거수상수출탑</th>
						<td>위에서 선택한 수출의 탑 단위의 실적을 금년도에 처음으로 달성하였습니까?</td>
						<td>
							<input type="radio" id="priTapYnY" name="priTapYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="priTapYnN" name="priTapYn" value="N" class="form_radio" /> 아니오
						</td>
					</tr>
					<tr>
						<th>특별탑(서비스 탑) 신청여부</th>
						<td colspan="2">
							<input type="radio" id="speTapYnY" name="speTapYn" value="Y" class="form_radio" disabled="disabled" /> 특별탑, 수출의탑 동시신청
							<input type="radio" id="speTapYnH" name="speTapYn" value="H" class="form_radio" disabled="disabled" /> 특별탑만 신청
							<input type="radio" id="speTapYnN" name="speTapYn" value="N" class="form_radio" disabled="disabled" /> 신청하지 않음
						</td>
					</tr>
					<tr>
						<th>특별탑(서비스 탑) 신청분야</th>
						<td colspan="2"><c:out value="${fundForm.speTapNm}" /></td>
					</tr>
				</table>
			</div>
		</c:if>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 10%;" />
					<col style="width: 23%;" />
					<col style="width: 19%;" />
					<col style="width: 19%;" />
					<col style="width: 21%;" />
				</colgroup>
				<tr>
					<th id="companyrs1" rowspan="${16 + (indusNoCnt == 0 ? indusNoCnt : (indusNoCnt - 1))}">신청업체</th>
					<th id="companyrs2" rowspan="${6 + (indusNoCnt == 0 ? indusNoCnt : (indusNoCnt - 1))}">업체규모</th>
					<th colspan="3">주소(공장,사무소 등 전사업장)</th>
					<th>산재보험관리번호</th>
				</tr>
				<c:choose>
					<c:when test="${indusNoCnt > 0}">
						<c:forEach var="indus" items="${indusNoList}" varStatus="statusNo">
							<tr>
								<td colspan="3">
									<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">
										<c:forEach var="item" items="${awd009}" varStatus="status">
											<option value="<c:out value="${item.detailcd}" />" <c:if test="${indus.officeCd eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
										</c:forEach>
									</select>
									<input type="text" name="address" value="<c:out value="${indus.addr}" />" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />
								</td>
								<td>
									<input type="text" name="addressId" value="<c:out value="${indus.indusInsurNo}" />" maxlength="11" class="form_text w100p" title="산재보험번호" />
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3">
								<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">
									<c:forEach var="item" items="${awd009}" varStatus="status">
										<option value="<c:out value="${item.detailcd}" />"><c:out value="${item.detailnm}" /></option>
									</c:forEach>
								</select>
								<input type="text" name="address" value="" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />
							</td>
							<td>
								<input type="text" name="addressId1" value="" maxlength="4" class="form_text" style="width: 33%;" title="산재보험번호1" />
								<input type="text" name="addressId2" value="" maxlength="7" class="form_text" style="width: 65%;" title="산재보험번호2" />
								<input type="hidden" name="addressId" value="" />
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr>
					<th>전년도 매출액(원)</th>
					<th>종업원수(명)</th>
					<th>자본금(원)</th>
					<th>설립년도</th>
				</tr>
				<tr>
					<td align="right"><fmt:formatNumber value="${fundForm.salAmount}" pattern="#,###" /></td>
					<td align="right"><fmt:formatNumber value="${fundForm.workerCnt}" pattern="#,###" /></td>
					<td align="right"><fmt:formatNumber value="${fundForm.capital}" pattern="#,###" /></td>
					<td align="right"><c:out value="${fundForm.coCretYear}" /></td>
				</tr>
				<tr>
					<th>기업구분</th>
					<th>본사소재지</th>
					<th colspan="2">상장여부</th>
				</tr>
				<tr>
					<td>
						<c:forEach var="item" items="${awd007}" varStatus="status">
							<input type="radio" id="scale${status.count}" name="scale" value="<c:out value="${item.detailcd}" />" class="form_radio" <c:if test="${fundForm.scale eq item.detailcd}">checked="checked"</c:if> /> <c:out value="${item.detailnm}" />
						</c:forEach>
					</td>
					<td>
						<input type="radio" name="bonsaYn" value="N" class="form_radio" checked="checked" /> 수도권
						<input type="radio" name="bonsaYn" value="Y" class="form_radio" /> 지방
					</td>
					<td colspan="3">
						<c:forEach var="item" items="${awd027}" varStatus="status">
							<input type="radio" id="stockYn${status.count}" name="stockYn" value="<c:out value="${item.detailcd}" />" class="form_radio" <c:if test="${fundForm.stockYn eq item.detailcd}">checked="checked"</c:if> /> <c:out value="${item.detailnm}" />
						</c:forEach>
					</td>
				</tr>
				<c:if test="${param.priType ne 'S'}">
					<tr>
						<th rowspan="2">주거래은행</th>
						<th>은행명</th>
						<th>지점명</th>
						<th>담당자</th>
						<th>전화번호</th>
					</tr>
					<tr>
						<td <c:if test="${empty fundForm.mainBankCd}">style="height: 32px;"</c:if>><c:out value="${fundForm.mainBankCd}" /></td>
						<td><c:out value="${fundForm.mainBankbranchNm}" /></td>
						<td><c:out value="${fundForm.mainBankWrkNm}" /></td>
						<td class="phoneNum"><c:out value="${fundForm.mainBankPhone}" /></td>
					</tr>
					<tr>
						<th rowspan="6">특이사항</th>
						<th>소비재 업체 여부</th>
						<th>전자상거래 활용 업체 여부</th>
						<th>수출국 다변화 업체 여부</th>
						<th>K-방산 업체 여부</th>
					</tr>
					<tr>
						<td>
							<input type="radio" id="consumYnY" name="consumYn" value="Y" class="form_radio" disabled="disabled" /> 예
							<input type="radio" id="consumYnN" name="consumYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="electronicYnY" name="electronicYn" value="Y" class="form_radio" disabled="disabled" /> 예
							<input type="radio" id="electronicYnN" name="electronicYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="exportYnY" name="exportYn" value="Y" class="form_radio" disabled="disabled" /> 예
							<input type="radio" id="exportYnN" name="exportYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="koreaDefenseYnY" name="koreaDefenseYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="koreaDefenseYnN" name="koreaDefenseYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
					</tr>
					<tr>
						<th>K-방역 업체 여부</th>
						<th>K-ESG 업체 여부</th>
						<th>신성장산업 업체 여부</th>
						<th>수출물류 서비스 여부</th>
					</tr>
					<tr>
						<td>
							<input type="radio" id="koreaCleanYnY" name="koreaCleanYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="koreaCleanYnN" name="koreaCleanYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="koreaEsgYnY" name="koreaEsgYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="koreaEsgYnN" name="koreaEsgYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="newgenYnY" name="newgenYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="newgenYnN" name="newgenYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
						<td>
							<input type="radio" id="explogiYnY" name="explogiYn" value="Y" class="form_radio" /> 예
							<input type="radio" id="explogiYnN" name="explogiYn" value="N" class="form_radio" checked="checked" disabled="disabled" /> 아니오
						</td>
					</tr>
					<tr>
						<th colspan="4">무역일자리 창출 업체 여부 (<c:out value="${pyear.ppyear}" />년 대비 <c:out value="${pyear.pyear}" />년 고용인원증가)</th>
					</tr>
					<tr>
						<td colspan="4">
							<input type="radio" id="worknewYnY" name="worknewYn" value="Y" onclick="disabledWorkNew(this);" class="form_radio" disabled="disabled" /> 예
							<input type="radio" id="worknewYnN" name="worknewYn" value="N" onclick="disabledWorkNew(this);" class="form_radio" checked="checked" disabled="disabled" /> 아니오
							&nbsp;&nbsp;&nbsp;
							<c:out value="${pyear.ppyear}" />년 : <input type="text" id="pastWorkerCnt" name="pastWorkerCnt" value="<fmt:formatNumber value="${fundForm.pastWorkerCnt}" pattern="#,###" />" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
							<c:out value="${pyear.pyear}" />년 : <input type="text" id="currWorkerCnt" name="currWorkerCnt" value="<fmt:formatNumber value="${fundForm.currWorkerCnt}" pattern="#,###" />" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
							증가수 : <input type="text" id="worknewCnt" name="worknewCnt" value="<fmt:formatNumber value="${fundForm.worknewCnt}" pattern="#,###" />" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
						</td>
					</tr>
				</c:if>
				<tr>
					<th rowspan="2">업종선택</th>
					<th>업종코드</th>
					<th>대분류</th>
					<th>중분류</th>
					<th>업종명</th>
				</tr>
				<tr>
					<td <c:if test="${empty fundForm.upCode}">style="height: 32px;"</c:if>><c:out value="${fundForm.upCode}" /></td>
					<td><c:out value="${fundForm.upDep1}" /></td>
					<td><c:out value="${fundForm.upDep2}" /></td>
					<td><c:out value="${fundForm.upCodeNm}" /></td>
				</tr>
			</table>
		</div>
		<c:if test="${param.priType ne 'S'}">
			<div class="flex">
				<h3 style="margin-top: 20px;">수출실적</h3>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 4%;" />
						<col style="width: 14%;" />
						<col style="width: 14%;" />
						<col style="width: 14%;" />
						<col style="width: 14%;" />
						<col style="width: 12%;" />
						<col style="width: 3%;" />
						<col style="width: 7%;" />
						<col style="width: 18%;" />
					</colgroup>
					<tr>
						<th rowspan="7">②<br />수<br />출<br />실<br />적</th>
						<th>구분</th>
						<th>전전년도(US$)</th>
						<th>전년도(US$)</th>
						<th>당해년도(US$)</th>
						<th>증가율(%)</th>
						<th colspan="3">당해년도 주종 수출품목(금액순)</th>
					</tr>
					<tr>
						<th>직수출(A)</th>
						<td><input type="text" id="twoDrExpAmt" name="twoDrExpAmt" value="<fmt:formatNumber value="${fundForm.twoDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastDrExpAmt" name="pastDrExpAmt" value="<fmt:formatNumber value="${fundForm.pastDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currDrExpAmt" name="currDrExpAmt" value="<fmt:formatNumber value="${fundForm.currDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="expAmtRate" name="expAmtRate" value="<c:out value="${fundForm.expAmtRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="직수출증가율" readonly="readonly" /></td>
						<th rowspan="4">(1)</th>
						<th>HS Code</th>
						<td>
							<c:out value="${fundForm.expItemHscode1}" />
							<input type="hidden" id="expItemMticode1" name="expItemMticode1" value="<c:out value="${fundForm.expItemMticode1}" />" />
						</td>
					</tr>
					<tr>
						<th>용역전자적 무체물<br />(B-1)</th>
						<td><input type="text" id="twoLc1ExpAmt" name="twoLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc1ExpAmt" name="pastLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc1ExpAmt" name="currLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc1ExpAmtRate" name="lc1ExpAmtRate" value="<c:out value="${fundForm.lc1ExpAmtRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th rowspan="2">HS품명</th>
						<td rowspan="2"><c:out value="${fundForm.expItemNm1}" /></td>
					</tr>
					<tr>
						<th>KTNET간접수출실적<br />(B-2)</th>
						<td><input type="text" id="twoLc2ExpAmt" name="twoLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc2ExpAmt" name="pastLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc2ExpAmt" name="currLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc2ExpAmtRate" name="lc2ExpAmtRate" value="<c:out value="${fundForm.lc2ExpAmtRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
					</tr>
					<tr>
						<th>전자상거래수출실적<br />(B-3)</th>
						<td><input type="text" id="twoLc3ExpAmt" name="twoLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc3ExpAmt" name="pastLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc3ExpAmt" name="currLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc3ExpAmtRate" name="lc3ExpAmtRate" value="<c:out value="${fundForm.lc3ExpAmtRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th>MTI명</th>
						<td><c:out value="${fundForm.expItemMtiname1}" /></td>
					</tr>
					<input type="hidden" id="twoDrOmsExpAmt" name="twoDrOmsExpAmt" value="<c:out value="${fundForm.twoDrOmsExpAmt}" />" />
					<input type="hidden" id="pastDrOmsExpAmt" name="pastDrOmsExpAmt" value="<c:out value="${fundForm.pastDrOmsExpAmt}" />" />
					<input type="hidden" id="currDrOmsExpAmt" name="currDrOmsExpAmt" value="<c:out value="${fundForm.currDrOmsExpAmt}" />" />
					<input type="hidden" id="omsExpAmtRate" name="omsExpAmtRate" value="<c:out value="${fundForm.omsExpAmtRate}" />" />
					<tr>
						<th>로컬등 기타수출(C)</th>
						<td><input type="text" id="twoLc4ExpAmt" name="twoLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc4ExpAmt" name="pastLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc4ExpAmt" name="currLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc4ExpAmtRate" name="lc4ExpAmtRate" value="<c:out value="${fundForm.lc4ExpAmtRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th rowspan="4">(2)</th>
						<th>HS Code</th>
						<td>
							<c:out value="${fundForm.expItemHscode2}" />
							<input type="hidden" id="expItemMticode2" name="expItemMticode2" value="<c:out value="${fundForm.expItemMticode2}" />" />
						</td>
					</tr>
					<input type="hidden" id="twoLcExpAmt" name="twoLcExpAmt" value="<c:out value="${fundForm.twoLcExpAmt}" />" />
					<input type="hidden" id="pastLcExpAmt" name="pastLcExpAmt" value="<c:out value="${fundForm.pastLcExpAmt}" />" />
					<input type="hidden" id="currLcExpAmt" name="currLcExpAmt" value="<c:out value="${fundForm.currLcExpAmt}" />" />
					<input type="hidden" id="lcExpAmtRate" name="lcExpAmtRate" value="<c:out value="${fundForm.lcExpAmtRate}" />" />
					<tr>
						<th>합계(A+B+C)</th>
						<td><input type="text" id="twoExpAmtSum" name="twoExpAmtSum" value="<fmt:formatNumber value="${fundForm.twoExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전전년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastExpAmtSum" name="pastExpAmtSum" value="<fmt:formatNumber value="${fundForm.pastExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="전년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currExpAmtSum" name="currExpAmtSum" value="<fmt:formatNumber value="${fundForm.currExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" title="당해년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="expAmtSumRate" name="expAmtSumRate" value="<c:out value="${fundForm.expAmtSumRate}" />" maxlength="25" class="form_text w100p" style="text-align: right;" title="합계증가율" readonly="readonly" /></td>
						<th rowspan="2">HS품명</th>
						<td rowspan="2"><c:out value="${fundForm.expItemNm2}" /></td>
					</tr>
					<tr>
						<th colspan="2">③ 수입실적</th>
						<td class="align_ctr"> / </td>
						<td class="align_ctr"> / </td>
						<td><input type="text" id="impSiljuk" name="impSiljuk" value="<fmt:formatNumber value="${fundForm.impSiljuk}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<td class="align_ctr"> / </td>
					</tr>
					<tr>
						<th colspan="2">수입실적누락분</th>
						<td class="align_ctr"> / </td>
						<td class="align_ctr"> / </td>
						<td><input type="text" id="exImpSiljuk" name="exImpSiljuk" value="<fmt:formatNumber value="${fundForm.exImpSiljuk}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<td class="align_ctr"> / </td>
						<th>MTI명</th>
						<td><c:out value="${fundForm.expItemMtiname2}" /></td>
					</tr>
					<tr>
						<th colspan="2">④ 무역수지(당해년도)</th>
						<td colspan="2"><input type="text" id="tradeIndex" name="tradeIndex" value="<fmt:formatNumber value="${fundForm.tradeIndex}" pattern="#,###" />" maxlength="25" class="form_text" style="width: 47%;text-align: right;" readonly="readonly" numberOnly /></td>
						<th>외화가득률</th>
						<td><input type="text" id="tradeIndexImprvRate" name="tradeIndexImprvRate" value="<fmt:formatNumber value="${fundForm.tradeIndexImprvRate}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<th colspan="3">※ HS CODE 숫자만 10자리 입력</th>
					</tr>
				</table>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 4%;" />
						<col style="width: 14%;" />
						<col style="width: 10%;" />
						<col style="width: 18%;" />
						<col style="width: 10%;" />
						<col style="width: 16%;" />
						<col style="width: 28%;" />
					</colgroup>
					<tr>
						<th rowspan="4">⑤<br />시<br />장<br />개<br />척</th>
						<th rowspan="2">당해년도 직수출</th>
						<th>5대시장(US$)</th>
						<td><input type="text" id="dvlpExploAmt" name="dvlpExploAmt" value="<fmt:formatNumber value="${fundForm.dvlpExploAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="dvlpExploAmtPor" name="dvlpExploAmtPor" value="<fmt:formatNumber value="${fundForm.dvlpExploAmtPor}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>중국,미국,일본,홍콩,베트남</td>
					</tr>
					<tr>
						<th>기타(US$)</th>
						<td><input type="text" id="newMktExploAmt" name="newMktExploAmt" value="<fmt:formatNumber value="${fundForm.newMktExploAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="newMktExploAmtPor" name="newMktExploAmtPor" value="<fmt:formatNumber value="${fundForm.newMktExploAmtPor}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>5대시장을 제외한 전지역</td>
					</tr>
					<tr>
						<th rowspan="2">당해년도 직수출<br />누락분</th>
						<th>5대시장(US$)</th>
						<td><input type="text" id="exDvlpExploAmt" name="exDvlpExploAmt" value="<fmt:formatNumber value="${fundForm.exDvlpExploAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="exDvlpExploAmtPor" name="exDvlpExploAmtPor" value="<fmt:formatNumber value="${fundForm.exDvlpExploAmtPor}" pattern="#,###" />" maxlength="25" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>중국,미국,일본,홍콩,베트남</td>
					</tr>
					<tr>
						<th>기타(US$)</th>
						<td><input type="text" id="exNewMktExploAmt" name="exNewMktExploAmt" value="<fmt:formatNumber value="${fundForm.exNewMktExploAmt}" pattern="#,###" />" onchange="doCalculate();" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="exNewMktExploAmtPor" name="exNewMktExploAmtPor" value="<fmt:formatNumber value="${fundForm.exNewMktExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>5대시장을 제외한 전지역</td>
					</tr>
				</table>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 4%;" />
						<col style="width: 14%;" />
						<col style="width: 10%;" />
						<col style="width: 18%;" />
						<col style="width: 10%;" />
						<col style="width: 16%;" />
						<col style="width: 10%;" />
						<col style="width: 18%;" />
					</colgroup>
					<tr>
						<th rowspan="4">⑥<br />기<br />술<br />개<br />발</th>
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
						<th>수입대체상품생성</th>
						<th>품목명</th>
						<td colspan="3"><c:out value="${fundForm.impReplItemNm}" /></td>
						<th>품목수</th>
						<td style="text-align: right;"><c:out value="${fundForm.impReplItemCnt}" /></td>
					</tr>
					<tr>
						<th>자기상표제품수출</th>
						<th>상표명</th>
						<td><c:out value="${fundForm.selfBrandExpItemNm}" /></td>
						<th>상표수</th>
						<td style="text-align: right;"><c:out value="${fundForm.selfBrandExpCnt}" /></td>
						<th>품목수</th>
						<td style="text-align: right;"><c:out value="${fundForm.selfBrandExpItemCnt}" /></td>
					</tr>
				</table>
			</div>
		</c:if>
		<div class="flex">
			<h3 style="margin-top: 20px;">회사 공적사항</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 14%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2" style="text-align: left;">공적 내용</th>
				</tr>
				<tr>
					<td colspan="2">
						1) 기본사항<br /><br />
						<c:out value="${common:reverseXss(fundForm.kongjukItem1)}" escapeXml="false" />
						<c:if test="${param.priType ne 'S'}">
							<br /><br />
							2) 수출실적<br /><br />
							<c:out value="${common:reverseXss(fundForm.kongjukItem2)}" escapeXml="false" />
							<br /><br />
							3) 기술개발 및 품질향상 노력<br /><br />
							<c:out value="${common:reverseXss(fundForm.kongjukItem3)}" escapeXml="false" />
							<br /><br />
							4) 해외시장 개척활동<br /><br />
							<c:out value="${common:reverseXss(fundForm.kongjukItem4)}" escapeXml="false" />
							<br /><br />
							5) 기타 공적내용<br /><br />
							<c:out value="${common:reverseXss(fundForm.kongjukEtc)}" escapeXml="false" />
						</c:if>
					</td>
				</tr>
				<c:set var="fileAttachCnt" value="${fn:length(fileAttachList)}" />
				<c:choose>
					<c:when test="${priType eq 'S'}">
						<c:set var="awd017Cnt" value="${fn:length(awd017)}" />
						<tr>
							<th rowspan="${4 + awd017Cnt}">첨부파일</th>
							<td style="height: 35px;">
								<c:choose>
									<c:when test="${fileAttachCnt eq 0}">
										&nbsp;
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${fileAttachList}" varStatus="status">
											<div class="addedFile" data-detailcode="<c:out value="${item.mineType}" />">
												<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th class="align_l">
								<div onclick="dofilterAttach('');" style="cursor: pointer;">* 전체파일</div>
							</th>
						</tr>
						<tr>
							<th class="align_l">* 특수분야유공자 첨부파일</th>
						</tr>
						<c:forEach var="item" items="${awd017}" varStatus="status">
							<tr>
								<td class="align_l">
									<div onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:set var="awd012Cnt" value="${fn:length(awd012)}" />
						<c:set var="awd013Cnt" value="${fn:length(awd013)}" />
						<tr>
							<th rowspan="${4 + awd012Cnt + awd013Cnt}">첨부파일</th>
							<td style="height: 35px;">
								<c:choose>
									<c:when test="${fileAttachCnt eq 0}">
										&nbsp;
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${fileAttachList}" varStatus="status">
											<div class="addedFile" data-detailcode="<c:out value="${item.mineType}" />">
												<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th class="align_l">
								<div onclick="dofilterAttach('');" style="cursor: pointer;">* 전체파일</div>
							</th>
						</tr>
						<tr>
							<th class="align_l">* 포상신청업체 (수출의 탑과 수출업체종사자 동시신청시, 수출업체종사자 포상만 신청시)</th>
						</tr>
						<c:forEach var="item" items="${awd012}" varStatus="status">
							<tr>
								<td class="align_l">
									<div onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</div>
								</td>
							</tr>
						</c:forEach>
						<tr>
							<th class="align_l">* 수출의탑만 신청하는 업체</th>
						</tr>
						<c:forEach var="item" items="${awd013}" varStatus="status">
							<tr>
								<td class="align_l">
									<div onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">유공자(공적조서)</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 13%;" />
					<col style="width: 9%;" />
					<col style="width: 11%;" />
					<col style="width: 12%;" />
					<col style="width: 7%;" />
					<col style="width: 7%;" />
					<col style="width: 21%;" />
					<col style="width: 13%;" />
				</colgroup>
				<tr>
					<th colspan="9" class="align_l">⑦ 유공자</th>
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
				<c:choose>
					<c:when test="${priType eq 'S'}">
						<tr>
							<th>특수유공자</th>
							<th>대표자</th>
							<td id="spUserNmKor" class="align_ctr"><c:out value="${fundForm.spUserNmKor}" /></td>
							<td id="spPos" class="align_ctr"><c:out value="${fundForm.spPos}" /></td>
							<td id="spJuminNo" class="align_ctr"><c:out value="${fundForm.spJuminNo}" /></td>
							<td id="spWrkTermYy" class="align_r"><c:out value="${fundForm.spWrkTermYy}" /> 년</td>
							<td id="spWrkTermMm" class="align_r"><c:out value="${fundForm.spWrkTermMm}" /> 개월</td>
							<td id="spHistory"><c:out value="${fundForm.spHistory}" /></td>
							<td class="align_ctr">
								<button type="button" onclick="doSelectYg('30');" class="btn_tbl_primary">조회</button>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th>수출의탑</th>
							<th>수출의탑(대표자)</th>
							<td id="ceoUserNmKor0" class="align_ctr">
								<c:out value="${fundForm.ceoUserNmKor0}" />
								<input type="hidden" id="ceoUserNmKor0Hidden" name="ceoUserNmKor0Hidden" value="<c:out value="${fundForm.ceoUserNmKor0}" />" />
							</td>
							<td id="ceoPos0" class="align_ctr"><c:out value="${fundForm.ceoPos0}" /></td>
							<td id="ceoJuminNo0" class="align_ctr"><c:out value="${fundForm.ceoJuminNo0}" /></td>
							<td id="ceoWrkTermYy0" class="align_r"><c:out value="${fundForm.ceoWrkTermYy0}" /> 년</td>
							<td id="ceoWrkTermMm0" class="align_r"><c:out value="${fundForm.ceoWrkTermMm0}" /> 개월</td>
							<td id="ceoHistory0"><c:out value="${fundForm.ceoHistory0}" /></td>
							<td class="align_ctr">
								<button type="button" onclick="doSelectYg('10');" class="btn_tbl_primary">조회</button>
							</td>
						</tr>
						<tr>
							<th rowspan="3">개인포상</th>
							<th>대표자</th>
							<td id="ceoUserNmKor" class="align_ctr"><c:out value="${fundForm.ceoUserNmKor}" /></td>
							<td id="ceoPos" class="align_ctr"><c:out value="${fundForm.ceoPos}" /></td>
							<td id="ceoJuminNo" class="align_ctr"><c:out value="${fundForm.ceoJuminNo}" /></td>
							<td id="ceoWrkTermYy" class="align_r"><c:out value="${fundForm.ceoWrkTermYy}" /> 년</td>
							<td id="ceoWrkTermMm" class="align_r"><c:out value="${fundForm.ceoWrkTermMm}" /> 개월</td>
							<td id="ceoHistory"><c:out value="${fundForm.ceoHistory}" /></td>
							<td class="align_ctr">
								<button type="button" onclick="doSelectYg('21');" class="btn_tbl_primary">조회</button>
							</td>
						</tr>
						<tr>
							<th>종업원(사무직)</th>
							<td id="empUserNmKor" class="align_ctr"><c:out value="${fundForm.empUserNmKor}" /></td>
							<td id="empPos" class="align_ctr"><c:out value="${fundForm.empPos}" /></td>
							<td id="empJuminNo" class="align_ctr"><c:out value="${fundForm.empJuminNo}" /></td>
							<td id="empWrkTermYy" class="align_r"><c:out value="${fundForm.empWrkTermYy}" /> 년</td>
							<td id="empWrkTermMm" class="align_r"><c:out value="${fundForm.empWrkTermMm}" /> 개월</td>
							<td id="empHistory"><c:out value="${fundForm.empHistory}" /></td>
							<td class="align_ctr">
								<button type="button" onclick="doSelectYg('22');" class="btn_tbl_primary">조회</button>
							</td>
						</tr>
						<tr>
							<th>종업원(생산직)</th>
							<td id="workUserNmKor" class="align_ctr"><c:out value="${fundForm.workUserNmKor}" /></td>
							<td id="workPos" class="align_ctr"><c:out value="${fundForm.workPos}" /></td>
							<td id="workJuminNo" class="align_ctr"><c:out value="${fundForm.workJuminNo}" /></td>
							<td id="workWrkTermYy" class="align_r"><c:out value="${fundForm.workWrkTermYy}" /> 년</td>
							<td id="workWrkTermMm" class="align_r"><c:out value="${fundForm.workWrkTermMm}" /> 개월</td>
							<td id="workHistory"><c:out value="${fundForm.workHistory}" /></td>
							<td class="align_ctr">
								<button type="button" onclick="doSelectYg('23');" class="btn_tbl_primary">조회</button>
							</td>
						</tr>
						<tr>
							<th colspan="2">각자대표</th>
							<td colspan="7"><c:out value="${fundForm.eachCeoKr}" /></td>
						</tr>
						<tr>
							<th colspan="2">공동대표</th>
							<td colspan="2"><c:out value="${fundForm.jointCeoKr}" /></td>
							<th>수상이력</th>
							<td colspan="4"><c:out value="${fundForm.jointCeoHistory}" /></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">업체특성</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<tr>
					<th>특이업체 여부</th>
					<td>
						<input type="radio" id="specialYnY" name="specialYn" value="Y" class="form_radio" <c:if test="${fundForm.specialYn eq 'Y'}">checked="checked"</c:if> /> 예
						<input type="radio" id="specialYnN" name="specialYn" value="N" class="form_radio" <c:if test="${fundForm.specialYn ne 'Y'}">checked="checked"</c:if> /> 아니오
					</td>
				</tr>
				<tr>
					<th style="text-align: left;border-right: 0px;">업체특성 내용</th>
					<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt6">0</span> / 1000)</th>
				</tr>
				<tr>
					<td colspan="2">
						<textarea id="specialContent" name="specialContent" index="6" onkeyup="textareaChk(this, 1000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="업체 특성 내용"><c:out value="${fundForm.specialContent}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">업체검토</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<tr>
					<th>최종검토 여부</th>
					<td>
						<input type="radio" id="chkYnY" name="chkYn" value="Y" class="form_radio" <c:if test="${fundForm.chkYn eq 'Y'}">checked="checked"</c:if> /> 예
						<input type="radio" id="chkYnN" name="chkYn" value="N" class="form_radio" <c:if test="${fundForm.chkYn ne 'Y'}">checked="checked"</c:if> /> 아니오
					</td>
				</tr>
				<tr>
					<th style="text-align: left;border-right: 0px;">최종검토 내용</th>
					<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt7">0</span> / 1000)</th>
				</tr>
				<tr>
					<td colspan="2">
						<textarea id="remark" name="remark" index="7" onkeyup="textareaChk(this, 1000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="최종 검토 내용"><c:out value="${fundForm.remark}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">심사평가</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 12%;" />
					<col style="width: 15%;" />
					<col style="width: 10%;" />
					<col style="width: 12%;" />
					<col style="width: 12%;" />
					<col />
				</colgroup>
				<tr>
					<th rowspan="2">구분</th>
					<th rowspan="2">심사항목</th>
					<th rowspan="2">심사세부항목</th>
					<th rowspan="2">최대점수</th>
					<th colspan="2">평점</th>
					<th rowspan="2">메모 및 평점 변경 사유</th>
				</tr>
				<tr>
					<th>평점(신청기준)</th>
					<th>평점(협회인정)</th>
				</tr>
				<%
					List<CommonHashMap<String, Object>> calratingList = (List<CommonHashMap<String, Object>>)request.getAttribute("calratingList");

					int rowSize = calratingList.size();
				%>
				<%
					if (rowSize == 0) {
				%>
					<tr>
						<td colspan="7" class="align_ctr">심사 평가 내역이 없습니다. 점수 계산이 필요합니다.</td>
					</td>
				<%
					}
				%>
				<%
					String priNmChk = "";
					String priGbnNmChk = "";
					String scoreTypeNmChk = "";
					String sumChk = "";

					for (int i = 0; i < rowSize; i++) {
						priNmChk = "N";
						priGbnNmChk = "N";
						scoreTypeNmChk = "N";
						sumChk = "N";

				    	if (i > 0 && calratingList.get(i).get("priNm").equals(calratingList.get(i - 1).get("priNm"))) {
				    		priNmChk = "Y";
				    	}
				    	if (i < (rowSize - 1) && calratingList.get(i).get("priNm").equals(calratingList.get(i + 1).get("priNm"))) {
				    		sumChk = "Y";
				    	}
				    	if (i == (rowSize - 1)) {
				    		sumChk = "N";
				    	}
				    	if (i > 0 && calratingList.get(i).get("priGbnNm").equals(calratingList.get(i - 1).get("priGbnNm")) && "Y".equals(priNmChk)) {
				    		priGbnNmChk = "Y";
				    	}
				    	if (i > 0 && calratingList.get(i).get("scoreTypeNm").equals(calratingList.get(i - 1).get("scoreTypeNm"))) {
				    		scoreTypeNmChk = "Y";
				    	}
				%>
				<input type="hidden" id="priGbn" name="priGbn" value="<%=calratingList.get(i).get("priGbn")%>" />
				<input type="hidden" id="scoreType" name="scoreType" value="<%=calratingList.get(i).get("scoreType")%>" />
				<input type="hidden" id="priNmCnt" name="priNmCnt" value="<%=calratingList.get(i).get("priNmCnt")%>" />
				<input type="hidden" id="scorePrvPriType" name="scorePrvPriType" value="<%=calratingList.get(i).get("prvPriType")%>" />
				<tr>
				<%
						if ("N".equals(priNmChk)) {
				%>
					<td rowspan="<%=calratingList.get(i).get("priNmCnt")%>" class="align_ctr">
						<%=calratingList.get(i).get("priNm")%>
					</td>
				<%
						}
				%>
				<%
						if ("N".equals(priGbnNmChk)) {
				%>
					<td rowspan="<%=calratingList.get(i).get("priGbnNmCnt")%>">
						<%=calratingList.get(i).get("priGbnNm")%>
					</td>
				<%
						}
				%>
				<%
						if ("N".equals(scoreTypeNmChk)) {
				%>
					<td rowspan="<%=calratingList.get(i).get("scoreTypeNmCnt")%>">
						<%=calratingList.get(i).get("scoreTypeNm")%>
					</td>
				<%
						}
				%>
					<td class="align_ctr">
						<%=calratingList.get(i).get("maxScore")%>
						<input type="hidden" id="maxScore" name="maxScore" value="<%=calratingList.get(i).get("maxScore")%>" />
					</td>
					<td>
					    <input type="text" id="pointComp" name="pointComp" value="<%=calratingList.get(i).get("pointComp")%>" maxlength="30" class="form_text w100p" style="text-align: right;" readonly="readonly" />
					</td>
					<td>
						<input type="text" id="pointKita" name="pointKita" value="<%=calratingList.get(i).get("pointKita")%>" maxlength="4" class="form_text w100p" style="text-align: right;" onkeypress="doKeyPressEvent(this, 'FLOAT', event);" onfocus="inputTextOnFocus(this);doNumberFloatFocusEvent(this);this.select();" onBlur="inputTextOutFocus(this);doNumberFloatBlurEvent(this);doChangePoint('<%=i%>')" />
					</td>
					<td>
				<%
						String resnMemo = StringUtil.nullCheck(calratingList.get(i).get("resnMemo"));

						if ("300101".equals(calratingList.get(i).get("scoreType"))) {
				%>
					<input type="hidden" id="resnMemo" name="resnMemo" value="<%=resnMemo%>" />
				<%
						} else {
				%>
					<input type="text" id="resnMemo" name="resnMemo" value="<%=resnMemo%>" maxlength="1000" class="form_text w100p" style="text-align: right;" />
				<%
						}
				%>
					</td>
				</tr>
				<%
						if ("N".equals(sumChk)) {
							String priNm = StringUtil.nullCheck(calratingList.get(i).get("priNm"));
							priNm = priNm.replaceAll("<br />", "");
				%>
				<tr>
					<th colspan="3" class="align_ctr"><%=priNm%> 평가 합계</th>
					<th class="align_ctr">
						<%=calratingList.get(i).get("maxScoreSum")%>
						<input type="hidden" id="max<%=calratingList.get(i).get("prvPriType")%>" name="max<%=calratingList.get(i).get("prvPriType")%>" value="<%=calratingList.get(i).get("maxScoreSum")%>" />
					</th>
					<th class="align_ctr">
						<%=calratingList.get(i).get("pointCompSum")%>
						<input type="hidden" id="compSum<%=calratingList.get(i).get("prvPriType")%>" name="compSum<%=calratingList.get(i).get("prvPriType")%>" value="<%= calratingList.get(i).get("pointCompSum")%>" />
					</th>
					<th>
						<input type="text" id="kitaSum<%=calratingList.get(i).get("prvPriType")%>" name="kitaSum<%=calratingList.get(i).get("prvPriType")%>" value="<%= calratingList.get(i).get("pointKitaSum")%>" maxlength="4" class="form_text w100p" style="text-align: right;" readonly="readonly" />
					</th>
					<th>&nbsp;</th>
				</tr>
				<%
						}
					}
				%>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">조정</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 12%;" />
					<col style="width: 10%;" />
					<col style="width: 10%;" />
					<col style="width: 10%;" />
					<col style="width: 10%;" />
					<col />
					<col style="width: 18%;" />
				</colgroup>
				<tr>
					<th>구분</th>
					<th>기서훈명</th>
					<th>기서훈년도</th>
					<th>기서훈자</th>
					<th>대상자</th>
					<th>조정</th>
					<th>조정/탈락 사유</th>
					<th>조정/탈락 일시</th>
				</tr>
				<c:forEach var="past" items="${pastTapList}" varStatus="status1">
					<tr>
						<td align="center"><c:out value="${past.prvPriTypeNm}" /></td>
						<td align="left"><c:out value="${past.prizeName}" /></td>
						<td align="center"><c:out value="${past.praYear}" /></td>
						<td align="center"><c:out value="${past.pastUserNm}" /></td>
						<td align="center"><c:out value="${past.userNmKor}" /></td>
						<td align="center">
							<select name="selectState" class="form_select" title="조정">
								<c:forEach var="item" items="${awd004}" varStatus="status2">
									<option value="<c:out value="${item.detailcd}" />" <c:if test="${past.state eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
								</c:forEach>
							</select>
							<input type="hidden" name="selectPrvPriType" value="<c:out value="${past.prvPriType}" />" />
						</td>
						<td align="center"><input type="text" id="fundAwardClass" name="fundAwardClass" value="<c:out value="${past.fundAwardClass}" />" maxlength="100" class="form_text w100p" /></td>
						<td align="center"><c:out value="${past.selectInfo}" /></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div class="mt-10">&nbsp;</div>
	</div>
</div>
</form>
<form id="selectionPopupDownloadForm" name="selectionPopupDownloadForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="fileId" value="" />
<input type="hidden" name="fileNo" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		var f = document.selectionPopupForm;

		// 과거의 탑 수상여부
		setRadio(f.priTapYn, '<c:out value="${empty fundForm.priTapYn ? 'Y' : fundForm.priTapYn}" />');
		// 특별탑(서비스 탑) 신청여부
		setRadio(f.speTapYn, '<c:out value="${empty fundForm.speTapYn ? 'N' : fundForm.speTapYn}" />');
		// 기업구분
		setRadio(f.scale, '<c:out value="${empty fundForm.scale ? '2' : fundForm.scale}" />');
		// 본사지방소재여부
		setRadio(f.bonsaYn, '<c:out value="${fundForm.bonsaYn}" />');
		// 신청구분
		setSelect(f.priType, '<c:out value="${priType}" />');
		// 소비재 업체 여부
		setRadio(f.consumYn, '<c:out value="${fundForm.consumYn}" />');
		// 전자상거래 활용 업체 여부
		setRadio(f.electronicYn, '<c:out value="${fundForm.electronicYn}" />');
		// 수출국 다변화 업체 여부
		setRadio(f.exportYn, '<c:out value="${fundForm.exportYn}" />');
		// K-방산 업체 여부
		setRadio(f.koreaDefenseYn, '<c:out value="${fundForm.koreaDefenseYn}" />');
		// K-방역 업체 여부
		setRadio(f.koreaCleanYn, '<c:out value="${fundForm.koreaCleanYn}" />');
		// K-ESG 업체 여부
		setRadio(f.koreaEsgYn, '<c:out value="${fundForm.koreaEsgYn}" />');
		// 신성장산업 업체
		setRadio(f.newgenYn, '<c:out value="${fundForm.newgenYn}" />');
		// 수출물류 서비스 여부
		setRadio(f.explogiYn, '<c:out value="${fundForm.explogiYn}" />');
		// 무역일자리 창출 업체 여부
		setRadio(f.worknewYn, '<c:out value="${fundForm.worknewYn}" />');

		$('#selectionPopupForm #worknewCnt').attr('disabled', true);
		$('#selectionPopupForm #pastWorkerCnt').attr('disabled', true);
		$('#selectionPopupForm #currWorkerCnt').attr('disabled', true);

		// 상장회사
		setRadio(f.stockYn, '<c:out value="${empty fundForm.stockYn ? '1' : fundForm.stockYn}" />');

		<c:if test="${param.priType ne 'S'}">
			doCalculate();
		</c:if>

		setReadOnlySelect(f.priType);
		setReadOnlySelect(f.expTapPrizeCd);
		setRadioDisabledAll(f.priTapYn, true);
		setRadioDisabled(f.priTapYn, '<c:out value="${empty fundForm.priTapYn ? 'Y' : fundForm.priTapYn}" />', false);
		setRadioDisabledAll(f.scale, true);
		setRadioDisabled(f.scale, '<c:out value="${empty fundForm.scale ? '2' : fundForm.scale}" />', false);
		setRadioDisabledAll(f.bonsaYn, true);
		setRadioDisabled(f.bonsaYn, '<c:out value="${fundForm.bonsaYn}" />', false);

		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		$('#selectionPopupForm #priType').trigger('change');

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#selectionPopupForm .phoneNum'], 'R');

		// 로딩이미지 종료
		$('#loading_image').hide();
	});

	function doCalculate() {
		var f = document.selectionPopupForm;

		// 직수출 계산
		calculateDrExpAmt(f);
		// 직수출누락분 계산
		calculateDrOmsExpAmt(f);
		// 용역전자적 무체물
		calculateLcExpAmt1(f);
		// KTNET간접수출실적
		calculateLcExpAmt2(f);
		// 전자상거래수출실적
		calculateLcExpAmt3(f);
		// 로컬등 기타수출
		calculateLcExpAmt4(f);
		// 기타수출 합계
		calculateAmtLcSum(f);
		// 합계
		calculateAmtSum(f);
		// 무역수지, 외화가득률 계산법(당해년도)
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

	// 직수출누락분 계산
	function calculateDrOmsExpAmt(f) {
		var vTwoDrOmsExpAmt = '';
		var vPastDrOmsExpAmt = '';
		var vCurrDrOmsExpAmt = '';

		var vOmsExpAmtRate = '';
		var vTwoOmsExpAmtRate = '';
		var vPastOmsExpAmtRate = '';

		if (f.twoDrOmsExpAmt.value == '') {
			f.twoDrOmsExpAmt.value = 0;
		}
		if (f.pastDrOmsExpAmt.value == '') {
			f.pastDrOmsExpAmt.value = 0;
		}
		if (f.currDrOmsExpAmt.value == '') {
			f.currDrOmsExpAmt.value = 0;
		}

		vTwoDrOmsExpAmt = parseFloat(f.twoDrOmsExpAmt.value.replace(/,/gi, ''));
		vPastDrOmsExpAmt = parseFloat(f.pastDrOmsExpAmt.value.replace(/,/gi, ''));
		vCurrDrOmsExpAmt = parseFloat(f.currDrOmsExpAmt.value.replace(/,/gi, ''));

		f.twoDrOmsExpAmt.value = plusComma(vTwoDrOmsExpAmt);
		f.pastDrOmsExpAmt.value = plusComma(vPastDrOmsExpAmt);
		f.currDrOmsExpAmt.value = plusComma(vCurrDrOmsExpAmt);

		if (f.twoDrOmsExpAmt.value == 0) {
			if (f.pastDrOmsExpAmt.value == 0) {
				vTwoOmsExpAmtRate = 0;
			} else {
				vTwoOmsExpAmtRate = 100;
			}
		} else {
			vTwoOmsExpAmtRate = ((vPastDrOmsExpAmt - vTwoDrOmsExpAmt) / vTwoDrOmsExpAmt) * 100;
		}

		if (f.pastDrOmsExpAmt.value == 0) {
			if (f.currDrOmsExpAmt.value == 0) {
				vPastOmsExpAmtRate = 0;
			} else {
				vPastOmsExpAmtRate = 0;
			}
		} else {
			vPastOmsExpAmtRate = ((vCurrDrOmsExpAmt - vPastDrOmsExpAmt) / vPastDrOmsExpAmt) * 100;
		}

		vOmsExpAmtRate = (vTwoOmsExpAmtRate + vPastOmsExpAmtRate) / 2;
		f.omsExpAmtRate.value = plusComma(Math.round(vOmsExpAmtRate * 100) / 100);
	}

	// 용역전자적 무체물
	function calculateLcExpAmt1(f) {
		var vTwoLc1ExpAmt = '';
		var vPastLc1ExpAmt = '';
		var vCurrLc1ExpAmt = '';
		var vLc1ExpAmtRate = '';
		var vTwoLc1ExpAmtRate = '';
		var vPastLc1ExpAmtRate = '';

		if (f.twoLc1ExpAmt.value == '') {
			f.twoLc1ExpAmt.value = 0;
		}
		if (f.pastLc1ExpAmt.value == '') {
			f.pastLc1ExpAmt.value = 0;
		}
		if (f.currLc1ExpAmt.value == '') {
			f.currLc1ExpAmt.value = 0;
		}

		if (doNumberCheck(f.twoLc1ExpAmt.value.replace(/,/gi, '')) == false) {
			f.twoLc1ExpAmt.value = 0;
		}
		if (doNumberCheck(f.pastLc1ExpAmt.value.replace(/,/gi, '')) == false) {
			f.pastLc1ExpAmt.value = 0;
		}
		if (doNumberCheck(f.currLc1ExpAmt.value.replace(/,/gi, '')) == false) {
			f.currLc1ExpAmt.value = 0;
		}

		vTwoLc1ExpAmt = parseFloat(f.twoLc1ExpAmt.value.replace(/,/gi, ''));
		vPastLc1ExpAmt = parseFloat(f.pastLc1ExpAmt.value.replace(/,/gi, ''));
		vCurrLc1ExpAmt = parseFloat(f.currLc1ExpAmt.value.replace(/,/gi, ''));

		f.twoLc1ExpAmt.value = plusComma(vTwoLc1ExpAmt);
		f.pastLc1ExpAmt.value = plusComma(vPastLc1ExpAmt);
		f.currLc1ExpAmt.value = plusComma(vCurrLc1ExpAmt);

		if (f.twoLc1ExpAmt.value == 0) {
			if (f.pastLc1ExpAmt.value == 0) {
				vTwoLc1ExpAmtRate = 0;
			} else {
				vTwoLc1ExpAmtRate = 100;
			}
		} else {
			vTwoLc1ExpAmtRate = ((vPastLc1ExpAmt - vTwoLc1ExpAmt) / vTwoLc1ExpAmt) * 100;
		}

		if (f.pastLc1ExpAmt.value == 0) {
			if (f.currLc1ExpAmt.value == 0) {
				vPastLc1ExpAmtRate = 0;
			} else {
				vPastLc1ExpAmtRate = 100;
			}
		} else {
			vPastLc1ExpAmtRate = ((vCurrLc1ExpAmt - vPastLc1ExpAmt) / vPastLc1ExpAmt) * 100;
		}

		vLc1ExpAmtRate = (vTwoLc1ExpAmtRate + vPastLc1ExpAmtRate) / 2;
		f.lc1ExpAmtRate.value = plusComma(Math.round(vLc1ExpAmtRate * 100) / 100);
	}

	// KTNET간접수출실적
	function calculateLcExpAmt2(f) {
		var vTwoLc2ExpAmt = '';
		var vPastLc2ExpAmt = '';
		var vCurrLc2ExpAmt = '';
		var vLc2ExpAmtRate = '';
		var vPastLc2ExpAmtRate = '';
		var vTwoLc2ExpAmtRate = '';

		if (f.twoLc2ExpAmt.value == '') {
			f.twoLc2ExpAmt.value = 0;
		}
		if (f.pastLc2ExpAmt.value == '') {
			f.pastLc2ExpAmt.value = 0;
		}
		if (f.currLc2ExpAmt.value == '') {
			f.currLc2ExpAmt.value = 0;
		}

		if (doNumberCheck(f.twoLc2ExpAmt.value.replace(/,/gi, '')) == false) {
			f.twoLc2ExpAmt.value = 0;
		}
		if (doNumberCheck(f.pastLc2ExpAmt.value.replace(/,/gi, '')) == false) {
			f.pastLc2ExpAmt.value = 0;
		}
		if (doNumberCheck(f.currLc2ExpAmt.value.replace(/,/gi, '')) == false) {
			f.currLc2ExpAmt.value = 0;
		}

		vTwoLc2ExpAmt = parseFloat(f.twoLc2ExpAmt.value.replace(/,/gi, ''));
		vPastLc2ExpAmt = parseFloat(f.pastLc2ExpAmt.value.replace(/,/gi, ''));
		vCurrLc2ExpAmt = parseFloat(f.currLc2ExpAmt.value.replace(/,/gi, ''));

		f.twoLc2ExpAmt.value = plusComma(vTwoLc2ExpAmt);
		f.pastLc2ExpAmt.value = plusComma(vPastLc2ExpAmt);
		f.currLc2ExpAmt.value = plusComma(vCurrLc2ExpAmt);

		if (f.twoLc2ExpAmt.value == 0) {
			if (f.pastLc2ExpAmt.value == 0) {
				vTwoLc2ExpAmtRate = 0;
			} else {
				vTwoLc2ExpAmtRate = 100;
			}
		} else {
			vTwoLc2ExpAmtRate = ((vPastLc2ExpAmt - vTwoLc2ExpAmt) / vTwoLc2ExpAmt) * 100;
		}

		if (f.pastLc2ExpAmt.value == 0) {
			if (f.currLc2ExpAmt.value == 0) {
				vPastLc2ExpAmtRate = 0;
			} else {
				vPastLc2ExpAmtRate = 100;
			}
		} else {
			vPastLc2ExpAmtRate = ((vCurrLc2ExpAmt - vPastLc2ExpAmt) / vPastLc2ExpAmt) * 100;
		}

		vLc2ExpAmtRate = (vTwoLc2ExpAmtRate + vPastLc2ExpAmtRate) / 2;
		f.lc2ExpAmtRate.value = plusComma(Math.round(vLc2ExpAmtRate * 100) / 100);
	}

	// 전자상거래수출실적
	function calculateLcExpAmt3(f) {
		var vTwoLc3ExpAmt = '';
		var vPastLc3ExpAmt = '';
		var vCurrLc3ExpAmt = '';
		var vLc3ExpAmtRate = '';
		var vPastLc3ExpAmtRate = '';
		var vTwoLc3ExpAmtRate = '';

		if (f.twoLc3ExpAmt.value == '') {
			f.twoLc3ExpAmt.value = 0;
		}
		if (f.pastLc3ExpAmt.value == '') {
			f.pastLc3ExpAmt.value = 0;
		}
		if (f.currLc3ExpAmt.value == '') {
			f.currLc3ExpAmt.value = 0;
		}

		if (doNumberCheck(f.twoLc3ExpAmt.value.replace(/,/gi, '')) == false) {
			f.twoLc3ExpAmt.value = 0;
		}
		if (doNumberCheck(f.pastLc3ExpAmt.value.replace(/,/gi, '')) == false) {
			f.pastLc3ExpAmt.value = 0;
		}
		if (doNumberCheck(f.currLc3ExpAmt.value.replace(/,/gi, '')) == false) {
			f.currLc3ExpAmt.value = 0;
		}

		vTwoLc3ExpAmt = parseFloat(f.twoLc3ExpAmt.value.replace(/,/gi, ''));
		vPastLc3ExpAmt = parseFloat(f.pastLc3ExpAmt.value.replace(/,/gi, ''));
		vCurrLc3ExpAmt = parseFloat(f.currLc3ExpAmt.value.replace(/,/gi, ''));

		f.twoLc3ExpAmt.value = plusComma(vTwoLc3ExpAmt);
		f.pastLc3ExpAmt.value = plusComma(vPastLc3ExpAmt);
		f.currLc3ExpAmt.value = plusComma(vCurrLc3ExpAmt);

		if (f.twoLc3ExpAmt.value == 0) {
			if (f.pastLc3ExpAmt.value == 0) {
				vTwoLc3ExpAmtRate = 0;
			} else {
				vTwoLc3ExpAmtRate = 100;
			}
		} else {
			vTwoLc3ExpAmtRate = ((vPastLc3ExpAmt - vTwoLc3ExpAmt) / vTwoLc3ExpAmt) * 100;
		}

		if (f.pastLc3ExpAmt.value == 0) {
			if (f.currLc3ExpAmt.value == 0) {
				vPastLc3ExpAmtRate = 0;
			} else {
				vPastLc3ExpAmtRate = 100;
			}
		} else {
			vPastLc3ExpAmtRate = ((vCurrLc3ExpAmt - vPastLc3ExpAmt) / vPastLc3ExpAmt) * 100;
		}

		vLc3ExpAmtRate = (vTwoLc3ExpAmtRate + vPastLc3ExpAmtRate) / 2;
		f.lc3ExpAmtRate.value = plusComma(Math.round(vLc3ExpAmtRate * 100) / 100);
	}

	// 로컬등 기타수출
	function calculateLcExpAmt4(f) {
		var vTwoLc4ExpAmt = '';
		var vPastLc4ExpAmt = '';
		var vCurrLc4ExpAmt = '';
		var vLc4ExpAmtRate = '';
		var vTwoLc4ExpAmtRate = '';
		var vPastLc4ExpAmtRate = '';

		if (f.twoLc4ExpAmt.value == '') {
			f.twoLc4ExpAmt.value = 0;
		}
		if (f.pastLc4ExpAmt.value == '') {
			f.pastLc4ExpAmt.value = 0;
		}
		if (f.currLc4ExpAmt.value == '') {
			f.currLc4ExpAmt.value = 0;
		}

		if (doNumberCheck(f.twoLc4ExpAmt.value.replace(/,/gi, '')) == false) {
			f.twoLc4ExpAmt.value = 0;
		}
		if (doNumberCheck(f.pastLc4ExpAmt.value.replace(/,/gi, '')) == false) {
			f.pastLc4ExpAmt.value = 0;
		}
		if (doNumberCheck(f.currLc4ExpAmt.value.replace(/,/gi, '')) == false) {
			f.currLc4ExpAmt.value = 0;
		}

		vTwoLc4ExpAmt = parseFloat(f.twoLc4ExpAmt.value.replace(/,/gi, ''));
		vPastLc4ExpAmt = parseFloat(f.pastLc4ExpAmt.value.replace(/,/gi, ''));
		vCurrLc4ExpAmt = parseFloat(f.currLc4ExpAmt.value.replace(/,/gi, ''));

		f.twoLc4ExpAmt.value = plusComma(vTwoLc4ExpAmt);
		f.pastLc4ExpAmt.value = plusComma(vPastLc4ExpAmt);
		f.currLc4ExpAmt.value = plusComma(vCurrLc4ExpAmt);

		if (f.twoLc4ExpAmt.value == 0) {
			if (f.pastLc4ExpAmt.value == 0) {
				vTwoLc4ExpAmtRate = 0;
			} else {
				vTwoLc4ExpAmtRate = 100;
			}
		} else {
			vTwoLc4ExpAmtRate = ((vPastLc4ExpAmt - vTwoLc4ExpAmt) / vTwoLc4ExpAmt) * 100;
		}

		if (f.pastLc4ExpAmt.value == 0) {
			if (f.currLc4ExpAmt.value == 0) {
				vPastLc4ExpAmtRate = 0;
			} else {
				vPastLc4ExpAmtRate = 100;
			}
		} else {
			vPastLc4ExpAmtRate = ((vCurrLc4ExpAmt - vPastLc4ExpAmt) / vPastLc4ExpAmt) * 100;
		}

		vLc4ExpAmtRate = (vTwoLc4ExpAmtRate + vPastLc4ExpAmtRate) / 2;
		f.lc4ExpAmtRate.value = plusComma(Math.round(vLc4ExpAmtRate * 100) /100);
	}

	// 기타수출 합계
	function calculateAmtLcSum(f) {
		var vTwoLcExpAmt = parseFloat(f.twoLc4ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.twoLc1ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.twoLc2ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.twoLc3ExpAmt.value.replace(/,/gi, ''));

		var vPastLcExpAmt = parseFloat(f.pastLc4ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.pastLc1ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.pastLc2ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.pastLc3ExpAmt.value.replace(/,/gi, ''));

		var vCurrLcExpAmt = parseFloat(f.currLc4ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.currLc1ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.currLc2ExpAmt.value.replace(/,/gi, ''))
			+ parseFloat(f.currLc3ExpAmt.value.replace(/,/gi, ''));

		var vLcExpAmtRate = 0;
		var vPastLcExpAmtRate = 0;
		var vTwoLcExpAmtRate = 0;

		if (vTwoLcExpAmt == 0) {
			f.twoLcExpAmt.value = plusComma(f.twoLcExpAmt.value ? f.twoLcExpAmt.value : 0);
			vTwoLcExpAmt = parseFloat(f.twoLcExpAmt.value.replace(/,/gi, ''));
		} else {
			f.twoLcExpAmt.value = plusComma(vTwoLcExpAmt);
		}

		if (vPastLcExpAmt == 0) {
			f.pastLcExpAmt.value = plusComma(f.pastLcExpAmt.value ? f.pastLcExpAmt.value : 0);
			vPastLcExpAmt = parseFloat(f.pastLcExpAmt.value.replace(/,/gi, ''));
		} else {
			f.pastLcExpAmt.value = plusComma(vPastLcExpAmt);
		}

		if (vCurrLcExpAmt == 0) {
			f.currLcExpAmt.value = plusComma(f.currLcExpAmt.value ? f.currLcExpAmt.value : 0);
			vCurrLcExpAmt = parseFloat(f.currLcExpAmt.value.replace(/,/gi, ''));
		} else {
			f.currLcExpAmt.value = plusComma(vCurrLcExpAmt);
		}

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
		f.lcExpAmtRate.value = plusComma(Math.round(vLcExpAmtRate * 100) / 100);
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
		var vPastExpSumRate = 0;
		var vTwoExpSumRate = 0;

		if (!vTwoExpAmtSum) {
			vTwoExpAmtSum = 0;
		}
		if (!vPastExpAmtSum) {
			vPastExpAmtSum = 0;
		}
		if (!vCurrExpAmtSum) {
			vCurrExpAmtSum = 0;
		}

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

	// 무역수지, 외화가득률 계산법(당해년도)
	function calculateTradeIndex(f) {
		if (f.impSiljuk.value == '') {
			f.impSiljuk.value = 0;
		}
		if (f.exImpSiljuk.value == '') {
			f.exImpSiljuk.value = 0;
		}

		var vTradeIndex = parseFloat(f.currExpAmtSum.value.replace(/,/gi, ''))
			- parseFloat(f.impSiljuk.value.replace(/,/gi, ''))
			- parseFloat(f.exImpSiljuk.value.replace(/,/gi, ''));

		var vCurrExpAmtSum = parseFloat(f.currExpAmtSum.value.replace(/,/gi, ''));

		var vTradeIndexImprvRate = 0;

		f.tradeIndex.value = plusComma(vTradeIndex);
		f.impSiljuk.value = plusComma(parseFloat(f.impSiljuk.value.replace(/,/gi, '')));
		f.exImpSiljuk.value = plusComma(parseFloat(f.exImpSiljuk.value.replace(/,/gi, '')));

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

		var vExDvlpExploAmt = 0;
		var vExDvlpExploAmtPor = 0;

		var vCurrDrExpAmt = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''));

		if (f.dvlpExploAmt.value == '') {
			f.dvlpExploAmt.value = 0;
		}
		if (f.exDvlpExploAmt.value == '') {
			f.exDvlpExploAmt.value = 0;
		}

		vDvlpExploAmt = parseFloat(f.dvlpExploAmt.value.replace(/,/gi, ''));
		vExDvlpExploAmt = parseFloat(f.exDvlpExploAmt.value.replace(/,/gi, ''));

		f.dvlpExploAmt.value = plusComma(vDvlpExploAmt);
		f.exDvlpExploAmt.value = plusComma(vExDvlpExploAmt);

		if (f.currDrExpAmt.value == 0) {
			vDvlpExploAmtPor = 0;
			vExDvlpExploAmtPor = 0;
		} else {
			vDvlpExploAmtPor = (vDvlpExploAmt / vCurrDrExpAmt) * 100;
			vExDvlpExploAmtPor = (vExDvlpExploAmt / vCurrDrExpAmt) * 100;
		}

		f.dvlpExploAmtPor.value = plusComma(Math.round(vDvlpExploAmtPor));
		f.exDvlpExploAmtPor.value = plusComma(Math.round(vExDvlpExploAmtPor));
	}

	// 기타시장 비중
	function calculateNewMktExploAmtPor(f) {
		var vNewMktExploAmt = 0;
		var vNewMktExploAmtPor = 0;

		var vExNewMktExploAmt = 0;
		var vExNewMktExploAmtPor = 0;

		var vCurrDrExpAmt = parseFloat(f.currDrExpAmt.value.replace(/,/gi, ''));

		var vDvlpExploAmt = 0;

		if (f.dvlpExploAmt.value == '') {
			f.dvlpExploAmt.value = 0;
		}

		vDvlpExploAmt = parseFloat(f.dvlpExploAmt.value.replace(/,/gi, ''));

		if (f.newMktExploAmt.value == '') {
			f.newMktExploAmt.value = 0;
		}
		if (f.exNewMktExploAmt.value == '') {
			f.exNewMktExploAmt.value = 0;
		}

		f.newMktExploAmt.value = plusComma(vCurrDrExpAmt - vDvlpExploAmt);

		vNewMktExploAmt = parseFloat(f.newMktExploAmt.value.replace(/,/gi, ''));
		vExNewMktExploAmt = parseFloat(f.exNewMktExploAmt.value.replace(/,/gi, ''));

		f.exNewMktExploAmt.value = plusComma(vExNewMktExploAmt);

		if (f.currDrExpAmt.value == 0) {
			vNewMktExploAmtPor = 0;
			vExNewMktExploAmtPor = 0;
		} else {
			vNewMktExploAmtPor = (vNewMktExploAmt / vCurrDrExpAmt) * 100;
			vExNewMktExploAmtPor = (vExNewMktExploAmt / vCurrDrExpAmt) * 100;
		}

		f.newMktExploAmtPor.value = plusComma(Math.round(vNewMktExploAmtPor));
		f.exNewMktExploAmtPor.value = plusComma(Math.round(vExNewMktExploAmtPor));
	}

	function doNumberCheck(val) {
		var checkNum = /[0-9]/;

		for (var i = 0; i < val.length; i++) {
			if (!checkNum.test(val.charAt(i))) {
				alert('숫자가 아닙니다.');

				return false;
			}
		}

		return true;
	}

	function disabledWorkNew(obj) {
		var valueYn = obj.value;

		if (valYn == 'Y') {
			$('#selectionPopupForm #worknewCnt').attr('disabled', false);
		} else {
			$('#selectionPopupForm #worknewCnt').val('0');
			$('#selectionPopupForm #worknewCnt').attr('disabled', true);
		}
	}

	function textareaChk(obj, limit) {
		if (window.event) {
			key = window.event.keyCode;
		} else if (e) {
			key = e.which;
		} else {
			return true;
		}

	    keychar = String.fromCharCode(key);

	    var textareaLength = obj.value.length;
	    var index = obj.getAttribute('index');

		$('#selectionPopupForm #textCnt' + index).text(textareaLength > limit ? limit : textareaLength);

	    if (textareaLength > limit) {
	    	alert(limit + '자 이상 입력하실 수 없습니다.');
	    	obj.value = obj.value.substring(0, (limit - 1));

	    	return;
		}
	}

	function inputTextOnFocus(obj) {
		$(obj).css('border', '1px solid');
		$(obj).css('border-color', '#03a1fc');
	}

	function inputTextOutFocus(obj) {
		$(obj).css('border', '1px solid');
		$(obj).css('border-color', '#cccccc');
	}

	function doSelectionReport() {
		var f = document.selectionPopupForm;

		var reportGb = '';

		var priType = getSelectedValue(f.priType);

		if (priType == 'A') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'T') {
			reportGb += '&reportGB3=Y';		// 이력서
			reportGb += '&reportGB4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'S') {
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		var url = '';
		<c:choose>
			<c:when test="${profile eq 'prod'}">
				url = 'https://membership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:when>
			<c:otherwise>
				url = 'https://devmembership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:otherwise>
		</c:choose>
		url += '?svr_id=' + f.svrId.value + '&apply_seq=' + f.applySeq.value + reportGb;

		var popFocus = window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');
		popFocus.focus();

		return;

		/*
		var url = '<c:url value="/tdas/report/tradeDayInquiryPrint.do" />?svrId=' + f.svrId.value + '&applySeq=' + f.applySeq.value + '&memberId=' + f.memberId.value;

		var param  = '';
		var priType = getSelectedValue(f.priType);

		if (priType == 'A') {
			param += '&reportGb1=Y';	// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';	// 공 적 조 서
			param += '&reportGb3=Y';	// 이력서
			param += '&reportGb4=Y';	// 수출의 탑」 신청서(B)
		} else if (priType == 'T') {
			param += '&reportGb3=Y';	// 이력서
			param += '&reportGb4=Y';	// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			param += '&reportGb1=Y';	// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';	// 공 적 조 서
			param += '&reportGb3=Y';	// 이력서
		} else if (priType == 'S') {
			param += '&reportGb2=Y';	// 공 적 조 서
			param += '&reportGb3=Y';	// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		url += param;

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}
		*/
	}

	// 유공자 공적 조서 팝업
	function doSelectYg(val) {
		var f = document.selectionPopupForm;

		if (f.applySeq.value == '') {
			alert('저장후 공적조서를 작성하실 수 있습니다.');

			return false;
		}

		// 로딩이미지 시작
		$('#loading_image').show();

		f.prvPriType.value = val;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplicationReferencePopup.do" />'
			, params : {
				svrId : f.svrId.value
				, applySeq : f.applySeq.value
			    , priType : f.priType.value
			    , prvPriType : f.prvPriType.value
			    , editYn : 'N'
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	// 첨부파일 다운로드
	function doDownloadFile(fileId, fileNo) {
		var f = document.selectionPopupDownloadForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = fileId;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	function checkMulti(pram) {
		if (typeof(pram) != 'undefined' && typeof(pram.value) != 'undefined') {
			return 'single';
		} else if (typeof(pram) != 'undefined') {
			return 'multi';
		} else {
			return 'undefined';
		}
	}

	function doValidPoint() {
		var f = document.selectionPopupForm;

		if (f.statusChk.value != 'C') {
			return true;
		}

		for (var i = 0; i < f.pointComp.length - 1; i++) {
			if (f.pointKita[i].value != f.pointComp[i].value) {
				if (f.resnMemo[i].value == '') {
					alert('평점(협회인정) 수정후 변경사유를 입력하셔야 합니다.\n확인후 진행 바랍니다.');
					f.resnMemo[i].focus();

					return false;
				}

				if (f.resnMemo[i].value.length < 3) {
					alert('평점(협회인정) 수정사유는 3자 이상 입력하셔야 합니다.');
					f.resnMemo[i].focus();

					return false;
				}
			}
		}

		return true;
	}

	function doSelectionSave() {
		var f = document.selectionPopupForm;
		var priType = getSelectedValue(f.priType);

		// 평가 - 점수
		if (!doValidPoint()) {
			return;
		}

		var selCnt = f.selectState.length;
		var isMulti = checkMulti(f.selectState);

		if (isMulti == 'multi') {
			for (var i = 0; i < selCnt; i++) {
				if (getSelectedValue(f.selectState[i]) != '01' && f.fundAwardClass[i].value == '') {
					alert(getSelectedText(f.selectState[i]) + ' 사유를 입력하셔야 합니다.');
					f.fundAwardClass[i].focus();

					return false;
				}
			}
		} else {
			if (getSelectedValue(f.selectState) != '01' && f.fundAwardClass.value == '') {
				alert(getSelectedText(f.selectState) + ' 사유를 입력하셔야 합니다.');
				f.fundAwardClass.focus();

				return false;
			}
		}

		if (confirm('저장 하시겠습니까?')) {
			var pointKita = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="pointKita"]').length; i++) {
				pointKita.push($('#selectionPopupForm input[name="pointKita"]').eq(i).val());
			}
			var resnMemo = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="resnMemo"]').length; i++) {
				resnMemo.push($('#selectionPopupForm input[name="resnMemo"]').eq(i).val());
			}
			var priGbn = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="priGbn"]').length; i++) {
				priGbn.push($('#selectionPopupForm input[name="priGbn"]').eq(i).val());
			}
			var scorePrvPriType = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="scorePrvPriType"]').length; i++) {
				scorePrvPriType.push($('#selectionPopupForm input[name="scorePrvPriType"]').eq(i).val());
			}
			var scoreType = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="scoreType"]').length; i++) {
				scoreType.push($('#selectionPopupForm input[name="scoreType"]').eq(i).val());
			}

			var selectState = [];
			for (var i = 0; i < $('#selectionPopupForm select[name="selectState"]').length; i++) {
				selectState.push($('#selectionPopupForm select[name="selectState"]').eq(i).val());
			}
			var fundAwardClass = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="fundAwardClass"]').length; i++) {
				fundAwardClass.push($('#selectionPopupForm input[name="fundAwardClass"]').eq(i).val());
			}
			var selectPrvPriType = [];
			for (var i = 0; i < $('#selectionPopupForm input[name="selectPrvPriType"]').length; i++) {
				selectPrvPriType.push($('#selectionPopupForm input[name="selectPrvPriType"]').eq(i).val());
			}

			global.ajax({
				url : '<c:url value="/tdms/popup/saveSelection.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					svrId : f.svrId.value
					, applySeq : f.applySeq.value

					, specialContent : f.specialContent.value
					, specialYn : f.specialYn.value
					, remark : f.remark.value
					, chkYn : f.chkYn.value

					, pointKita : pointKita.join(',')
					, resnMemo : resnMemo.join(',')
					, priGbn : priGbn.join(',')
					, scorePrvPriType : scorePrvPriType.join(',')
					, scoreType : scoreType.join(',')

					, selectState : selectState.join(',')
					, fundAwardClass : fundAwardClass.join(',')
					, selectPrvPriType : selectPrvPriType.join(',')
				}
				, async : true
				, spinner : true
				, success : function(data){

					var returnObj = {
						event : 'tradeDaySelectionSave'
						, specialContent : f.specialContent.value
						, specialYn : f.specialYn.value
						, remark : f.remark.value
						, chkYn : f.chkYn.value

						, pointKita : pointKita.join(',')
						, resnMemo : resnMemo.join(',')
						, priGbn : priGbn.join(',')
						, scorePrvPriType : scorePrvPriType.join(',')
						, scoreType : scoreType.join(',')

						, selectState : selectState.join(',')
						, fundAwardClass : fundAwardClass.join(',')
						, selectPrvPriType : selectPrvPriType.join(',')
					};

					layerPopupCallback(returnObj);
				}
			});
		}
	}

	function doChangePoint(i) {
		var f = document.selectionPopupForm;

		var maxScore = parseFloat(f.maxScore[i].value.replace(/,/gi, ''));
		var point = parseFloat(f.pointKita[i].value.replace(/,/gi, ''));

		if (maxScore < point){
			alert('초대 점수를 초과할 수 없습니다. 확인 바랍니다.');
			f.pointKita[i].focus();

			return;
		}

		subSum();
	}

	function subSum() {
		var f = document.selectionPopupForm;
		var pcnt = f.pointKita.length;

		var sum1 = 0;
		var sum2 = 0;
		var sum3 = 0;

		for (var i = 0; i < pcnt; i++) {
			if (f.scorePrvPriType[i].value == '21') {
				sum1 += parseFloat(f.pointKita[i].value.replace(/,/gi, ''));
				f.kitaSum21.value = plusComma(Math.round(sum1 * 10) / 10);
			} else if (f.scorePrvPriType[i].value == '22') {
				sum2 += parseFloat(f.pointKita[i].value.replace(/,/gi, ''));
				f.kitaSum22.value = plusComma(Math.round(sum2 * 10) / 10);
			} else if (f.scorePrvPriType[i].value == '23') {
				sum3 += parseFloat(f.pointKita[i].value.replace(/,/gi, ''));
				f.kitaSum23.value = plusComma(Math.round(sum3 * 10) / 10);
			}
		}

		doColorChange();

		return true;
	}

	function doColorChange() {
		var f = document.selectionPopupForm;

		if (document.getElementById && document.getElementById('pointKita')) {
			for (var i = 0; i < f.pointKita.length -1; i++) {
				// 자동계산 점수와 협회 인정분이 틀린경우 폰트 붉은 색으로 변경 POINT_COMP, POINT_KITA
				if (f.pointComp[i].value == f.pointKita[i].value) {
					f.pointKita[i].style.color = '#595a5a';
				} else {
					f.pointKita[i].style.color = '#ff0000';
					f.resnMemo[i].style.color = '#ff0000';
				}
			}
		}
	}

	function dofilterAttach(detailcode) {
		$('.addedFile').show();
		$('.addedFile').css('margin-top', '');

		if (detailcode != '') {
			$('.addedFile')
	        .filter(function(){
	        	return $(this).data('detailcode') !== detailcode;
	        })
	        .hide();

			var index = 0;
			$('.addedFile').filter(function(){
				if ($(this).css('display') != 'none') {
					if (index == 0) {
						$(this).css('margin-top', '0px');

						index++;

						return true;
					} else {
						index++;

						return true;
					}
				} else {
					return false;
				}
			});
		} else {
			var index = 0;
			$('.addedFile').filter(function(){
				if ($(this).css('display') != 'none') {
					if (index != 0) {
						$(this).css('margin-top', '10px');
					}
				}

				index++;
			});
		}
	}

	function changePriType(obj) {
		/*
		var f = document.selectionPopupForm;

		if (obj.value == 'A' || obj.value == 'T') {
			document.getElementById('expTable').style.display = 'block';
			setSelect(f.expTapPrizeCd, '<c:out value="${fundForm.expTapPrizeCd}" />');
			setRadio(f.priTapYn, '<c:out value="${empty fundForm.priTapYn ? 'N' : fundForm.priTapYn}" />');
		} else {
			document.getElementById('expTable').style.display = 'none';
			setSelect(f.expTapPrizeCd, '');
			setRadio(f.priTapYn, 'N');
		}
		*/
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>