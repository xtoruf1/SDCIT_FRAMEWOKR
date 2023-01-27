<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="applicationPopupForm" name="applicationPopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<input type="hidden" name="prvPriType" value="" />
<input type="hidden" name="statusChk" value="<c:out value="${param.statusChk}" />" />
<input type="hidden" name="bsnAplEndDt" value="<c:out value="${tradeDayForm.bsnAplEndDt}" />" />
<input type="hidden" id="zipCdChk" name="zipCdChk" value="<c:out value="${fundForm.zipCdChk}" />" />
<input type="hidden" name="jejoupYn" value="<c:out value="${fundForm.jejoupYn}" />" />
<input type="hidden" name="serviceYn" value="<c:out value="${fundForm.serviceYn}" />" />
<input type="hidden" name="agrifoodYn" value="<c:out value="${fundForm.agrifoodYn}" />" />
<input type="hidden" name="receiptNo" value="<c:out value="${fundForm.receiptNo}" />" />
<input type="hidden" name="corpCnt" value="<c:out value="${corpCount}" />" />
<input type="hidden" name="appEditYn" value="<c:out value="${appEditYn}" />" />
<input type="hidden" name="proxyYn" value="<c:out value="${empty fundForm.proxyYn ? 'N' : fundForm.proxyYn}" />" />
<input type="hidden" name="stateChk" value="" />
<input type="hidden" id="speTapYnChk" name="speTapYnChk" value="<c:out value="${fundForm.speTapYn}" />" />
<input type="hidden" name="hiddenPriType" value="<c:out value="${fundForm.priType}" />" />
<input type="hidden" id="hiddenCeoUserNmKor0" name="hiddenCeoUserNmKor0" value="<c:out value="${fundForm.ceoUserNmKor0}" />" />
<input type="hidden" id="hiddenCeoUserNmKor" name="hiddenCeoUserNmKor" value="<c:out value="${fundForm.ceoUserNmKor}" />" />
<input type="hidden" id="hiddenEmpUserNmKor" name="hiddenEmpUserNmKor"	value="<c:out value="${fundForm.empUserNmKor}" />" />
<input type="hidden" id="hiddenWorkUserNmKor" name="hiddenWorkUserNmKor" value="<c:out value="${fundForm.workUserNmKor}" />" />
<input type="hidden" id="hiddenSpUserNmKor" name="hiddenSpUserNmKor" value="<c:out value="${fundForm.spUserNmKor}" />" />
<c:set var="indusNoCnt" value="${fn:length(indusNoList)}" />
<c:choose>
	<c:when test="${indusNoCnt > 0}">
		<c:forEach var="indus" items="${indusNoList}" varStatus="statusNo">
			<input type="hidden" name="hiddenAddress" value="<c:out value="${indus.addr}" />" />
			<input type="hidden" name="hiddenOfficeCd" value="<c:out value="${indus.officeCd}" />" />
			<input type="hidden" name="hiddenAddressId" value="<c:out value="${indus.indusInsurNo}" />" />
			<input type="hidden" name="hiddenAddressId1" value="<c:out value="${indus.indusNo1}" />" />
			<input type="hidden" name="hiddenAddressId2" value="<c:out value="${indus.indusNo2}" />" />
		</c:forEach>
	</c:when>
	<c:otherwise>
		<input type="hidden" name="hiddenAddress" value="" />
		<input type="hidden" name="hiddenOfficeCd" value="" />
		<input type="hidden" name="hiddenAddressId" value="" />
		<input type="hidden" name="hiddenAddressId1" value="" />
		<input type="hidden" name="hiddenAddressId2" value="" />
	</c:otherwise>
</c:choose>
<div style="width: 1170px;height: 750px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">
			<c:choose>
				<c:when test="${param.listPage eq '/tdms/agg/tradeDayTapCoChkSearch.do'}">수출의탑결과확인 - 신청서 작성</c:when>
				<c:when test="${param.listPage eq '/tdms/asm/tradeDayApplicationCheck.do'}">신청서 검토 - 신청서 작성</c:when>
				<c:when test="${param.listPage eq '/tdms/asm/tradeDayApplicationList.do'}">신청서 의뢰등록 - 신청서 작성</c:when>
				<c:when test="${param.listPage eq '/tdms/asm/tradeDayMemberId.do'}">무역업고유번호매칭 - 신청서 작성</c:when>
				<c:otherwise>신청서 의뢰등록 - 신청서 작성</c:otherwise>
			</c:choose>
		</h2>
		<div class="ml-auto">
			<c:if test="${appEditYn eq 'Y'}">
				<c:if test="${fundForm.state ne '02'}">
					<button type="button" onclick="doApplicationTempSave();" class="btn_sm btn_primary btn_modify_auth">임시저장</button>
				</c:if>
			</c:if>
			<c:if test="${fundForm.state eq '02'}">
				<button type="button" onclick="doApplicationTempUpdate();" class="btn_sm btn_primary btn_modify_auth">업체수정 처리</button>
			</c:if>
			<c:if test="${appEditYn eq 'Y'}">
				<c:if test="${not empty fundForm.state}">
					<button type="button" onclick="doApplicationSave();" class="btn_sm btn_primary btn_modify_auth">신청완료</button>
				</c:if>
			</c:if>
			<c:if test="${not empty param.applySeq}">
				<c:if test="${appEditYn eq 'Y'}">
					<button type="button" onclick="doApplicationDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
				</c:if>
			</c:if>
		</div>
		<div class="ml-15">
			<c:if test="${not empty param.applySeq}">
				<button type="button" onclick="doApplicationReport();" class="btn_sm btn_primary">신청서 출력</button>
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
					<col style="width: 8%;" />
					<col style="width: 10%;" />
					<col style="width: 18%;" />
					<col style="width: 10%;" />
					<col style="width: 20%;" />
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">신청구분</th>
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
				<c:if test="${priType eq 'S'}">
					<tr>
						<th rowspan="2">추천</th>
						<th>추천기관</th>
						<td colspan="5">
							<c:out value="${fundForm.spRecOrg}" />
							<input type="hidden" id="spRecOrg" name="spRecOrg" value="<c:out value="${fundForm.spRecOrg}" />" />
						</td>
					</tr>
					<tr>
						<th>추천부문</th>
						<td colspan="5"><c:out value="${fundForm.spRecKind}" /></td>
					</tr>
					<tr>
						<th rowspan="3">추천담당자</th>
						<th>성명</th>
						<td colspan="5"><c:out value="${fundForm.spRecName}" /></td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td colspan="3" class="phoneNum"><c:out value="${spRecTel}" /></td>
						<th>핸드폰번호</th>
						<td class="phoneNum"><c:out value="${spRecHp}" /></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="5">
							<c:if test="${fn:length(fundForm.spRecEmail) ne 1}">
								<c:out value="${fundForm.spRecEmail}" />
							</c:if>
						</td>
					</tr>
				</c:if>
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
					<col style="width: 12%;" />
					<col style="width: 10%;" />
					<col style="width: 20%;" />
					<col style="width: 8%;" />
					<col style="width: 8%;" />
					<col />
				</colgroup>
				<tr id="specialYgTr1">
					<th colspan="2">회사유형</th>
					<td colspan="6">
						<select name="coType" class="form_select" style="width: 13%;" title="회사유형">
							<c:forEach var="item" items="${spe002}" varStatus="status">
								<option value="<c:out value="${item.detailcd}" />" <c:if test="${fundForm.coType eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th colspan="2">무역업고유번호</th>
					<td><input type="text" id="memberId" name="memberId" value="<c:out value="${fundForm.memberId}" />" maxlength="10" class="form_text w100p" title="무역업고유번호" numberOnly /></td>
					<th>법인번호</th>
					<td>
						<input type="text" id="corpoNo1" name="corpoNo1" value="<c:out value="${fundForm.corpoNo1}" />" maxlength="6" class="form_text" style="width: 45%;text-align: center;" title="법인번호" numberOnly />
						- <input type="text" id="corpoNo2" name="corpoNo2" value="<c:out value="${fundForm.corpoNo2}" />" maxlength="9" class="form_text" style="width: 45%;text-align: center;" title="법인번호" numberOnly />
					</td>
					<th colspan="2">사업자등록번호</th>
					<td>
						<input type="text" id="bsNo1" name="bsNo1" value="<c:out value="${fundForm.bsNo1}" />" maxlength="3" class="form_text" style="width: 27%;text-align: center;" title="사업자등록번호" numberOnly />
						- <input type="text" id="bsNo2" name="bsNo2" value="<c:out value="${fundForm.bsNo2}" />" maxlength="2" class="form_text" style="width: 22%;text-align: center;" title="사업자등록번호" numberOnly />
						- <input type="text" id="bsNo3" name="bsNo3" value="<c:out value="${fundForm.bsNo3}" />" maxlength="5" class="form_text" style="width: 37%;text-align: center;" title="사업자등록번호" numberOnly />
					</td>
				</tr>
				<tr>
					<th rowspan="3">회사명</th>
					<th>국문 <strong class="point">*</strong></th>
					<td colspan="3"><input type="text" id="coNmKr" name="coNmKr" value="<c:out value="${fundForm.coNmKr}" />" maxlength="100" class="form_text w100p" title="회사명(국문)" /></td>
					<th rowspan="3">대표자</th>
					<th>국문 <strong class="point">*</strong></th>
					<td><input type="text" id="ceoKr" name="ceoKr" value="<c:out value="${fundForm.ceoKr}" />" maxlength="100" class="form_text w100p" title="대표자(국문)" /></td>
				</tr>
				<tr>
					<th>영문 <strong class="point">*</strong></th>
					<td colspan="3"><input type="text" id="coNmEn" name="coNmEn" value="<c:out value="${fundForm.coNmEn}" />" maxlength="100" class="form_text w100p" title="회사명(영문)" /></td>
					<th>영문 <strong class="point">*</strong></th>
					<td><input type="text" id="ceoEn" name="ceoEn" value="<c:out value="${fundForm.ceoEn}" />" maxlength="100" class="form_text w100p" title="대표자(영문)" /></td>
				</tr>
				<tr>
					<th>한자</th>
					<td colspan="3"><input type="text" id="coNmCh" name="coNmCh" value="<c:out value="${common:reverseXss(fundForm.coNmCh)}" escapeXml="false" />" maxlength="100" class="form_text w100p" title="회사명(한자)" /></td>
					<th>한자 <strong class="point">*</strong></th>
					<td><input type="text" id="ceoNmCh" name="ceoNmCh" value="<c:out value="${common:reverseXss(fundForm.ceoNmCh)}" escapeXml="false" />" maxlength="100" class="form_text w100p" title="대표자(한자)" /></td>
				</tr>
				<tr>
					<th rowspan="3">주소</th>
					<th rowspan="2">국문 <strong class="point">*</strong></th>
					<td colspan="3">
						<input type="text" id="coZipCd" name="coZipCd" value="<c:out value="${fundForm.coZipCd}" />" maxlength="6" class="form_text" style="width: 20%;" title="우편번호(국문)" readonly="readonly" />
						<span class="form_search" style="width: 79%;">
							<input type="text" id="coAddr1" name="coAddr1" value="<c:out value="${fundForm.coAddr1}" />" maxlength="200" class="form_text" style="width: 100%;" title="주소(국문)" readonly="readonly" />
							<button type="button" onclick="zipCodeListPopup('CO');" class="btn_icon btn_search" title="주소검색"></button>
						</span>
					</td>
					<th colspan="2">회사전화번호 <strong class="point">*</strong></th>
					<td><input type="text" id="coPhone" name="coPhone" value="<c:out value="${fundForm.coPhone}" />" maxlength="30" class="form_text w100p" title="회사전화번호" /></td>
				</tr>
				<tr>
					<td colspan="3"><input type="text" id="coAddr2" name="coAddr2" value="<c:out value="${fundForm.coAddr2}" />" maxlength="200" class="form_text w100p" title="상세주소(국문)" /></td>
					<th colspan="2">회사팩스번호 <strong class="point">*</strong></th>
					<td><input type="text" id="coFax" name="coFax" value="<c:out value="${fundForm.coFax}" />" maxlength="30" class="form_text w100p" title="회사팩스번호" /></td>
				</tr>
				<tr>
					<th>영문</th>
					<td colspan="3">
						<input type="text" id="coAddrEn" name="coAddrEn" value="<c:out value="${fundForm.coAddrEn}" />" maxlength="400" class="form_text w100p" title="주소(영문)" />
					</td>
					<th colspan="2">대표휴대전화 <strong class="point">*</strong></th>
					<td><input type="text" id="coHp" name="coHp" value="<c:out value="${coHp}" />" maxlength="15" class="form_text w100p" title="대표휴대전화" /></td>
				</tr>
				<tr>
					<th colspan="2">홈페이지 주소</th>
					<td colspan="6"><input type="text" id="coHomepage" name="coHomepage" value="<c:out value="${fundForm.coHomepage}" />" maxlength="100" class="form_text w100p" title="홈페이지 주소" /></td>
				</tr>
				<tr>
					<th colspan="2">E-Mail</th>
					<td colspan="6">
						<fieldset class="widget">
							<input type="text" id="coEmail1" name="coEmail1" value="<c:out value="${coEmail1}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="20" class="form_text" style="width: 15%;" title="E-Mail" />
							@
							<input type="text" id="coEmail2" name="coEmail2" value="<c:out value="${coEmail2}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="20" class="form_text" style="width: 17%;" title="E-Mail" />
							<select id="coEmailCon" name="coEmailCon" onchange="doEmailSelect('CO');" class="form_select" style="width: 15%;" title="E-Mail">
								<c:forEach var="item" items="${com014}" varStatus="status">
									<option value="<c:out value="${item.detailnm}" />" <c:if test="${coEmail2 eq item.detailnm}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
				</tr>
				<tr>
					<th rowspan="3">담당자</th>
					<th>성명 <strong class="point">*</strong></th>
					<td><input type="text" id="userNm" name="userNm" value="<c:out value="${fundForm.userNm}" />" maxlength="20" class="form_text w100p" title="담당자성명" /></td>
					<th>부서명 <strong class="point">*</strong></th>
					<td><input type="text" id="userDeptNm" name="userDeptNm" value="<c:out value="${fundForm.userDeptNm}" />" maxlength="60" class="form_text w100p" title="담당자부서명" /></td>
					<th colspan="2">직위명 <strong class="point">*</strong></th>
					<td><input type="text" id="userPosition" name="userPosition" value="<c:out value="${fundForm.userPosition}" />" maxlength="60" class="form_text w100p" title="담당자직위명" /></td>
				</tr>
				<tr>
					<th>전화번호 <strong class="point">*</strong></th>
					<td><input type="text" id="userPhone" name="userPhone" value="<c:out value="${userPhone}" />" maxlength="15" class="form_text w100p" title="담당자전화번호" /></td>
					<th>팩스번호 <strong class="point">*</strong></th>
					<td><input type="text" id="userFax" name="userFax" value="<c:out value="${userFax}" />" maxlength="15" class="form_text w100p" title="담당자팩스번호" /></td>
					<th colspan="2">휴대전화 <strong class="point">*</strong></th>
					<td><input type="text" id="userHp" name="userHp" value="<c:out value="${userHp}" />" maxlength="15" class="form_text w100p" title="담당자휴대전화" /></td>
				</tr>
				<tr>
					<th>E-Mail <strong class="point">*</strong></th>
					<td colspan="6">
						<fieldset class="widget">
							<input type="text" id="userEmail1" name="userEmail1" value="<c:out value="${userEmail1}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="20" class="form_text" style="width: 15%;" title="담당자이메일" />
							@
							<input type="text" id="userEmail2" name="userEmail2" value="<c:out value="${userEmail2}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="25" class="form_text" style="width: 17%;" title="담당자이메일" />
							<select id="userEmailCon" name="userEmailCon" onchange="doEmailSelect('USER');" class="form_select" style="width: 15%;" title="담당자이메일">
								<c:forEach var="item" items="${com014}" varStatus="status">
									<option value="<c:out value="${item.detailnm}" />" <c:if test="${userEmail2 eq item.detailnm}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
								</c:forEach>
							</select>
						</fieldset>
						<fieldset class="widget" style="padding-top: 5px;">
							<input type="text" id="userEmailSecond1" name="userEmailSecond1" value="<c:out value="${userEmailSecond1}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="20" class="form_text" style="width: 15%;" title="담당자이메일" />
							@
							<input type="text" id="userEmailSecond2" name="userEmailSecond2" value="<c:out value="${userEmailSecond2}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="25" class="form_text" style="width: 17%;" title="담당자이메일" />
							<select id="userEmailConSecond" name="userEmailConSecond" onchange="doEmailSelect('USER_SECOND');" class="form_select" style="width: 15%;" title="담당자이메일">
								<c:forEach var="item" items="${com014}" varStatus="status">
									<option value="<c:out value="${item.detailnm}" />" <c:if test="${userEmailSecond2 eq item.detailnm}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">신청업체 상세정보</h3>
		</div>
		<div id="normalYgDiv1" class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 18%;" />
					<col />
					<col style="width: 20%;" />
				</colgroup>
				<tr>
					<th rowspan="5">신청탑</th>
					<th>신청탑종류 <strong class="point">*</strong></th>
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
					<th>수출의탑 업체명 <strong class="point">*</strong></th>
					<td colspan="2"><input type="text" id="tapCoNmKr" name="tapCoNmKr" value="<c:out value="${fundForm.tapCoNmKr}" />" maxlength="50" class="form_text w100p" title="수출의탑 업체명" /></td>
				</tr>
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
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 8%;" />
					<col style="width: 10%;" />
					<col style="width: 23%;" />
					<col style="width: 21%;" />
					<col style="width: 15%;" />
					<col style="width: 4%;" />
					<col style="width: 12%;" />
					<col style="width: 7%;" />
				</colgroup>
				<tr>
					<th id="companyrs1" rowspan="${16 + (indusNoCnt == 0 ? indusNoCnt : (indusNoCnt - 1))}">신청업체</th>
					<th id="companyrs2" rowspan="${6 + (indusNoCnt == 0 ? indusNoCnt : (indusNoCnt - 1))}">업체규모 <strong id="specialCoType1" class="point">*</strong></th>
					<th colspan="3">주소(공장,사무소 등 전사업장)</th>
					<th colspan="2">산재보험관리번호</th>
					<th style="text-align: center;">
						<button type="button" onclick="addCompanyRow();" class="btn_tbl_border">추가</button>
					</th>
				</tr>
				<c:choose>
					<c:when test="${indusNoCnt > 0}">
						<c:forEach var="indus" items="${indusNoList}" varStatus="statusNo">
							<tr>
								<td colspan="3">
									<c:choose>
										<c:when test="${statusNo.index eq 0}">
											<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">
												<c:forEach var="item" items="${awd009A}" varStatus="status">
													<option value="<c:out value="${item.detailcd}" />" <c:if test="${indus.officeCd eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
												</c:forEach>
											</select>
											<input type="text" name="address" value="<c:out value="${indus.addr}" />" onchange="doBonsaYnTxt(this);" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />
										</c:when>
										<c:otherwise>
											<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">
												<c:forEach var="item" items="${awd009U}" varStatus="status">
													<option value="<c:out value="${item.detailcd}" />" <c:if test="${indus.officeCd eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
												</c:forEach>
											</select>
											<input type="text" name="address" value="<c:out value="${indus.addr}" />" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />
										</c:otherwise>
									</c:choose>
								</td>
								<td colspan="2">
									<input type="text" name="addressId" value="<c:out value="${indus.indusInsurNo}" />" maxlength="11" class="form_text w100p" title="산재보험번호" />
								</td>
								<td style="text-align: center;">
									<c:choose>
										<c:when test="${statusNo.index eq 0}">
											<button type="button" onclick="deleteCompanyRow(this);" class="btn_tbl_border" style="visibility: hidden;">삭제</button>
										</c:when>
										<c:otherwise>
											<button type="button" onclick="deleteCompanyRow(this);" class="btn_tbl_border">삭제</button>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3">
								<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">
									<c:forEach var="item" items="${awd009A}" varStatus="status">
										<option value="<c:out value="${item.detailcd}" />"><c:out value="${item.detailnm}" /></option>
									</c:forEach>
								</select>
								<input type="text" name="address" value="<c:out value="${fundForm.coAddr1}" /> <c:out value="${fundForm.coAddr2}" />" onchange="doBonsaYnTxt(this);" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />
							</td>
							<td colspan="2">
								<input type="text" name="addressId" value="" maxlength="11" class="form_text w100p" title="산재보험번호" />
							</td>
							<td style="text-align: center;">
								<button type="button" onclick="deleteCompanyRow(this);" class="btn_tbl_border" style="visibility: hidden;">삭제</button>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="companytr">
					<th>전년도 매출액(원)</th>
					<th>종업원수(명)</th>
					<th colspan="2">자본금(원)</th>
					<th colspan="2">설립년도</th>
				</tr>
				<tr>
					<td><input type="text" id="salAmount" name="salAmount" value="<fmt:formatNumber value="${fundForm.salAmount}" pattern="#,###" />" maxlength="50" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" class="form_text w100p" style="text-align: right;" title="전년도매출액" numberOnly /></td>
					<td><input type="text" id="workerCnt" name="workerCnt" value="<fmt:formatNumber value="${fundForm.workerCnt}" pattern="#,###" />" maxlength="50" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" class="form_text w100p" style="text-align: right;" title="종업원수" numberOnly /></td>
					<td colspan="2"><input type="text" id="capital" name="capital" value="<fmt:formatNumber value="${fundForm.capital}" pattern="#,###" />" maxlength="50" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" class="form_text w100p" style="text-align: right;" title="자본금" numberOnly /></td>
					<td colspan="2"><input type="text" id="coCretYear" name="coCretYear" value="<c:out value="${fundForm.coCretYear}" />" maxlength="4" class="form_text w100p" style="text-align: right;" title="설립년도" /></td>
				</tr>
				<tr>
					<th>기업구분</th>
					<th>본사소재지</th>
					<th colspan="4">상장여부</th>
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
					<td colspan="4">
						<c:forEach var="item" items="${awd027}" varStatus="status">
							<input type="radio" id="stockYn${status.count}" name="stockYn" value="<c:out value="${item.detailcd}" />" class="form_radio" <c:if test="${fundForm.stockYn eq item.detailcd}">checked="checked"</c:if> /> <c:out value="${item.detailnm}" />
						</c:forEach>
					</td>
				</tr>
				<tr id="normalYgTr1">
					<th rowspan="2">주거래은행 <strong class="point">*</strong></th>
					<th>은행명</th>
					<th>지점명</th>
					<th colspan="2">담당자</th>
					<th colspan="2">전화번호</th>
				</tr>
				<tr id="normalYgTr2">
					<td><input type="text" id="mainBankCd" name="mainBankCd" value="<c:out value="${fundForm.mainBankCd}" />" maxlength="50" class="form_text w100p" title="주거래은행명" /></td>
					<td><input type="text" id="mainBankbranchNm" name="mainBankbranchNm" value="<c:out value="${fundForm.mainBankbranchNm}" />" maxlength="50" class="form_text w100p" title="주거래은행지점" /></td>
					<td colspan="2"><input type="text" id="mainBankWrkNm" name="mainBankWrkNm" value="<c:out value="${fundForm.mainBankWrkNm}" />" maxlength="50" class="form_text w100p" title="주거래은행담당자" /></td>
					<td colspan="2"><input type="text" id="mainBankPhone" name="mainBankPhone" value="<c:out value="${mainBankPhone}" />" maxlength="50" class="form_text w100p" title="주거래은행전화번호" /></td>
				</tr>
				<tr id="normalYgTr3">
					<th rowspan="6">특이사항 <strong class="point">*</strong></th>
					<th>소비재 업체 여부</th>
					<th>전자상거래 활용 업체 여부</th>
					<th colspan="2">수출국 다변화 업체 여부</th>
					<th colspan="2">K-방산 업체 여부</th>
				</tr>
				<tr id="normalYgTr4">
					<td>
						<input type="radio" id="consumYnY" name="consumYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="consumYnN" name="consumYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td>
						<input type="radio" id="electronicYnY" name="electronicYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="electronicYnN" name="electronicYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td colspan="2">
						<input type="radio" id="exportYnY" name="exportYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="exportYnN" name="exportYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td colspan="2">
						<input type="radio" id="koreaDefenseYnY" name="koreaDefenseYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="koreaDefenseYnN" name="koreaDefenseYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
				</tr>
				<tr id="normalYgTr5">
					<th>K-방역 업체 여부</th>
					<th>K-ESG 업체 여부</th>
					<th colspan="2">신성장산업 업체 여부</th>
					<th colspan="2">수출물류 서비스 여부</th>
				</tr>
				<tr id="normalYgTr6">
					<td>
						<input type="radio" id="koreaCleanYnY" name="koreaCleanYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="koreaCleanYnN" name="koreaCleanYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td>
						<input type="radio" id="koreaEsgYnY" name="koreaEsgYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="koreaEsgYnN" name="koreaEsgYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td colspan="2">
						<input type="radio" id="newgenYnY" name="newgenYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="newgenYnN" name="newgenYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
					<td colspan="2">
						<input type="radio" id="explogiYnY" name="explogiYn" value="Y" class="form_radio" /> 예
						<input type="radio" id="explogiYnN" name="explogiYn" value="N" class="form_radio" checked="checked" /> 아니오
					</td>
				</tr>
				<tr id="normalYgTr7">
					<th colspan="6">무역일자리 창출 업체 여부 (<c:out value="${pyear.ppyear}" />년 대비 <c:out value="${pyear.pyear}" />년 고용인원증가)</th>
				</tr>
				<tr id="normalYgTr8">
					<td colspan="6">
						<input type="radio" id="worknewYnY" name="worknewYn" value="Y" onclick="disabledWorkNew(this);" class="form_radio" /> 예
						<input type="radio" id="worknewYnN" name="worknewYn" value="N" onclick="disabledWorkNew(this);" class="form_radio" checked="checked" /> 아니오
						&nbsp;&nbsp;&nbsp;
						<c:out value="${pyear.ppyear}" />년 : <input type="text" id="pastWorkerCnt" name="pastWorkerCnt" value="<fmt:formatNumber value="${fundForm.pastWorkerCnt}" pattern="#,###" />" onchange="doWorknew();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
						<c:out value="${pyear.pyear}" />년 : <input type="text" id="currWorkerCnt" name="currWorkerCnt" value="<fmt:formatNumber value="${fundForm.currWorkerCnt}" pattern="#,###" />" onchange="doWorknew();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
						증가수 : <input type="text" id="worknewCnt" name="worknewCnt" value="<fmt:formatNumber value="${fundForm.worknewCnt}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="10" class="form_text" style="width: 10%;text-align: right;" title="무역일자리 창출수" numberOnly /> 명
					</td>
				</tr>
				<tr>
					<th rowspan="2">업종선택 <strong id="specialCoType2" class="point">*</strong></th>
					<th>업종코드</th>
					<th>대분류</th>
					<th colspan="2">중분류</th>
					<th colspan="2">업종명</th>
				</tr>
				<tr>
					<td>
						<span class="form_search" style="width: 100%;">
							<input type="text" id="upCode" name="upCode" value="<c:out value="${fundForm.upCode}" />" maxlength="50" class="form_text w100p" title="업종코드" readonly="readonly" />
							<button type="button" onclick="upCodeListPopup();" class="btn_icon btn_search" title="업종검색"></button>
						</span>
					</td>
					<td><input type="text" id="upDep1" name="upDep1" value="<c:out value="${fundForm.upDep1}" />" maxlength="50" class="form_text w100p" title="대분류" readonly="readonly" /></td>
					<td colspan="2"><input type="text" id="upDep2" name="upDep2" value="<c:out value="${fundForm.upDep2}" />" maxlength="50" class="form_text w100p" title="중분류" readonly="readonly" /></td>
					<td colspan="2"><input type="text" id="upCodeNm" name="upCodeNm" value="<c:out value="${fundForm.upCodeNm}" />" maxlength="150" class="form_text w100p" title="업종명" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
		<div id="normalYgDiv2">
			<div class="flex">
				<h3 style="margin-top: 20px;">수출실적</h3>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 4%;" />
						<col style="width: 14%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 4%;" />
						<col style="width: 8%;" />
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
						<td><input type="text" id="twoDrExpAmt" name="twoDrExpAmt" value="<fmt:formatNumber value="${fundForm.twoDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastDrExpAmt" name="pastDrExpAmt" value="<fmt:formatNumber value="${fundForm.pastDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currDrExpAmt" name="currDrExpAmt" value="<fmt:formatNumber value="${fundForm.currDrExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도직수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="expAmtRate" name="expAmtRate" value="<c:out value="${fundForm.expAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="직수출증가율" readonly="readonly" /></td>
						<th rowspan="4">(1)</th>
						<th>HS Code</th>
						<td>
							<span class="form_search" style="width: 100%;">
								<input type="text" id="expItemHscode1" name="expItemHscode1" value="<c:out value="${fundForm.expItemHscode1}" />" maxlength="10" class="form_text" style="width: 70%;" title="HS코드1" />
								<input type="hidden" id="expItemMticode1" name="expItemMticode1" value="<c:out value="${fundForm.expItemMticode1}" />" />
								<button type="button" onclick="hsCodeListPopup('1');" class="btn_icon btn_search" title="HS CODE 검색"></button>
							</span>
						</td>
					</tr>
					<tr>
						<th>용역전자적 무체물<br />(B-1)</th>
						<td><input type="text" id="twoLc1ExpAmt" name="twoLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc1ExpAmt" name="pastLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc1ExpAmt" name="currLc1ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc1ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc1ExpAmtRate" name="lc1ExpAmtRate" value="<c:out value="${fundForm.lc1ExpAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th rowspan="2">HS품명 <strong class="point">*</strong></th>
						<td rowspan="2"><input type="text" id="expItemNm1" name="expItemNm1" value="<c:out value="${fundForm.expItemNm1}" />" maxlength="500" class="form_text w100p" title="품명1" /></td>
					</tr>
					<tr>
						<th>KTNET간접수출실적<br />(B-2)</th>
						<td><input type="text" id="twoLc2ExpAmt" name="twoLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc2ExpAmt" name="pastLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc2ExpAmt" name="currLc2ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc2ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc2ExpAmtRate" name="lc2ExpAmtRate" value="<c:out value="${fundForm.lc2ExpAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
					</tr>
					<tr>
						<th>전자상거래수출실적<br />(B-3)</th>
						<td><input type="text" id="twoLc3ExpAmt" name="twoLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLc3ExpAmt" name="pastLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLc3ExpAmt" name="currLc3ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc3ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lc3ExpAmtRate" name="lc3ExpAmtRate" value="<c:out value="${fundForm.lc3ExpAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th>MTI명</th>
						<td><input type="text" id="expItemMtiname1" name="expItemMtiname1" value="<c:out value="${fundForm.expItemMtiname1}" />" maxlength="200" class="form_text w100p" title="MTI 코드명" readonly="readonly" /></td>
					</tr>
					<input type="hidden" id="twoDrOmsExpAmt" name="twoDrOmsExpAmt" value="<c:out value="${fundForm.twoDrOmsExpAmt}" />" />
					<input type="hidden" id="pastDrOmsExpAmt" name="pastDrOmsExpAmt" value="<c:out value="${fundForm.pastDrOmsExpAmt}" />" />
					<input type="hidden" id="currDrOmsExpAmt" name="currDrOmsExpAmt" value="<c:out value="${fundForm.currDrOmsExpAmt}" />" />
					<input type="hidden" id="omsExpAmtRate" name="omsExpAmtRate" value="<c:out value="${fundForm.omsExpAmtRate}" />" />
					<tr>
						<th>로컬등 기타수출(C)</th>
						<td><input type="text" id="twoLc4ExpAmt" name="twoLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.twoLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" numberOnly /></td>
						<td><input type="text" id="pastLc4ExpAmt" name="pastLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.pastLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" numberOnly /></td>
						<td><input type="text" id="currLc4ExpAmt" name="currLc4ExpAmt" value="<fmt:formatNumber value="${fundForm.currLc4ExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" numberOnly /></td>
						<td><input type="text" id="lc4ExpAmtRate" name="lc4ExpAmtRate" value="<c:out value="${fundForm.lc4ExpAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th rowspan="4">(2)</th>
						<th>HS Code</th>
						<td>
							<span class="form_search" style="width: 100%;">
								<input type="text" id="expItemHscode2" name="expItemHscode2" value="<c:out value="${fundForm.expItemHscode2}" />" maxlength="10" class="form_text" style="width: 70%;" title="HS코드2" />
								<input type="hidden" id="expItemMticode2" name="expItemMticode2" value="<c:out value="${fundForm.expItemMticode2}" />" />
								<button type="button" onclick="hsCodeListPopup('2');" class="btn_icon btn_search" title="HS CODE 검색"></button>
							</span>
						</td>
					</tr>
					<input type="hidden" id="twoLcExpAmt" name="twoLcExpAmt" value="<c:out value="${fundForm.twoLcExpAmt}" />" />
					<input type="hidden" id="pastLcExpAmt" name="pastLcExpAmt" value="<c:out value="${fundForm.pastLcExpAmt}" />" />
					<input type="hidden" id="currLcExpAmt" name="currLcExpAmt" value="<c:out value="${fundForm.currLcExpAmt}" />" />
					<input type="hidden" id="lcExpAmtRate" name="lcExpAmtRate" value="<c:out value="${fundForm.lcExpAmtRate}" />" />
					<!--
					<tr>
						<th>기타수출 합계</th>
						<td><input type="text" id="twoLcExpAmt" name="twoLcExpAmt" value="<fmt:formatNumber value="${fundForm.twoLcExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastLcExpAmt" name="pastLcExpAmt" value="<fmt:formatNumber value="${fundForm.pastLcExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currLcExpAmt" name="currLcExpAmt" value="<fmt:formatNumber value="${fundForm.currLcExpAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도로컬수출" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="lcExpAmtRate" name="lcExpAmtRate" value="<c:out value="${fundForm.lcExpAmtRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="로컬수출증가율" readonly="readonly" /></td>
						<th>MTI명</th>
						<td><input type="text" id="expItemMtiname1" name="expItemMtiname1" value="<c:out value="${fundForm.expItemMtiname1}" />" maxlength="200" class="form_text w100p" title="MTI 코드명" readonly="readonly" /></td>
					</tr>
					-->
					<tr>
						<th>합계(A+B+C)</th>
						<td><input type="text" id="twoExpAmtSum" name="twoExpAmtSum" value="<fmt:formatNumber value="${fundForm.twoExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전전년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="pastExpAmtSum" name="pastExpAmtSum" value="<fmt:formatNumber value="${fundForm.pastExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="전년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="currExpAmtSum" name="currExpAmtSum" value="<fmt:formatNumber value="${fundForm.currExpAmtSum}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" title="당해년도합계" readonly="readonly" numberOnly /></td>
						<td><input type="text" id="expAmtSumRate" name="expAmtSumRate" value="<c:out value="${fundForm.expAmtSumRate}" />" maxlength="20" class="form_text w100p" style="text-align: right;" title="합계증가율" readonly="readonly" /></td>
						<th rowspan="2">HS품명 <strong class="point">*</strong></th>
						<td rowspan="2"><input type="text" id="expItemNm2" name="expItemNm2" value="<c:out value="${fundForm.expItemNm2}" />" maxlength="500" class="form_text w100p" title="품명2" /></td>
					</tr>
					<tr>
						<th colspan="2">③ 수입실적</th>
						<td class="align_ctr"> / </td>
						<td class="align_ctr"> / </td>
						<td><input type="text" id="impSiljuk" name="impSiljuk" value="<fmt:formatNumber value="${fundForm.impSiljuk}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" numberOnly /></td>
						<td class="align_ctr"> / </td>
					</tr>
					<tr>
						<th colspan="2">수입실적누락분</th>
						<td class="align_ctr"> / </td>
						<td class="align_ctr"> / </td>
						<td><input type="text" id="exImpSiljuk" name="exImpSiljuk" value="<fmt:formatNumber value="${fundForm.exImpSiljuk}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<td class="align_ctr"> / </td>
						<th>MTI명</th>
						<td><input type="text" id="expItemMtiname2" name="expItemMtiname2" value="<c:out value="${fundForm.expItemMtiname2}" />" maxlength="200" class="form_text w100p" title="MTI 코드명" readonly="readonly" /></td>
					</tr>
					<tr>
						<th colspan="2">④ 무역수지(당해년도)</th>
						<td colspan="2"><input type="text" id="tradeIndex" name="tradeIndex" value="<fmt:formatNumber value="${fundForm.tradeIndex}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text" style="width: 47%;text-align: right;" readonly="readonly" numberOnly /></td>
						<th>외화가득률</th>
						<td><input type="text" id="tradeIndexImprvRate" name="tradeIndexImprvRate" value="<fmt:formatNumber value="${fundForm.tradeIndexImprvRate}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<th colspan="3">※ HS CODE 숫자만 10자리 입력</th>
					</tr>
				</table>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 4%;" />
						<col style="width: 14%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 13%;" />
						<col style="width: 30%;" />
					</colgroup>
					<tr>
						<th rowspan="4">⑤<br />시<br />장<br />개<br />척</th>
						<th rowspan="2">당해년도 직수출</th>
						<th>5대시장(US$)</th>
						<td><input type="text" id="dvlpExploAmt" name="dvlpExploAmt" value="<fmt:formatNumber value="${fundForm.dvlpExploAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="dvlpExploAmtPor" name="dvlpExploAmtPor" value="<fmt:formatNumber value="${fundForm.dvlpExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>중국,미국,일본,홍콩,베트남</td>
					</tr>
					<tr>
						<th>기타(US$)</th>
						<td><input type="text" id="newMktExploAmt" name="newMktExploAmt" value="<fmt:formatNumber value="${fundForm.newMktExploAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="newMktExploAmtPor" name="newMktExploAmtPor" value="<fmt:formatNumber value="${fundForm.newMktExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>5대시장을 제외한 전지역</td>
					</tr>
					<tr>
						<th rowspan="2">당해년도 직수출<br />누락분</th>
						<th>5대시장(US$)</th>
						<td><input type="text" id="exDvlpExploAmt" name="exDvlpExploAmt" value="<fmt:formatNumber value="${fundForm.exDvlpExploAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
						<th>비중(%)</th>
						<td><input type="text" id="exDvlpExploAmtPor" name="exDvlpExploAmtPor" value="<fmt:formatNumber value="${fundForm.exDvlpExploAmtPor}" pattern="#,###" />" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" /></td>
						<td>중국,미국,일본,홍콩,베트남</td>
					</tr>
					<tr>
						<th>기타(US$)</th>
						<td><input type="text" id="exNewMktExploAmt" name="exNewMktExploAmt" value="<fmt:formatNumber value="${fundForm.exNewMktExploAmt}" pattern="#,###" />" onchange="doCalculate();" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="20" class="form_text w100p" style="text-align: right;" readonly="readonly" numberOnly /></td>
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
						<col style="width: 16%;" />
						<col style="width: 13%;" />
						<col style="width: 15%;" />
						<col style="width: 13%;" />
						<col style="width: 15%;" />
					</colgroup>
					<tr>
						<th rowspan="4">⑥<br />기<br />술<br />개<br />발</th>
						<th>신기술개발</th>
						<th>품목명</th>
						<td colspan="3"><input type="text" id="newTechItemNm" name="newTechItemNm" value="<c:out value="${fundForm.newTechItemNm}" />" maxlength="150" class="form_text w100p" /></td>
						<th>인증기관</th>
						<td><input type="text" id="newTechTerm" name="newTechTerm" value="<c:out value="${fundForm.newTechTerm}" />" maxlength="150" class="form_text w100p" /></td>
					</tr>
					<tr>
						<th>정부기술개발참여</th>
						<th>사업명</th>
						<td colspan="3"><input type="text" id="govTechNm" name="govTechNm" value="<c:out value="${fundForm.govTechNm}" />" maxlength="150" class="form_text w100p" /></td>
						<th>시행기관</th>
						<td><input type="text" id="govTechInst" name="govTechInst" value="<c:out value="${fundForm.govTechInst}" />" maxlength="150" class="form_text w100p" /></td>
					</tr>
					<tr>
						<th>수입대체상품생성</th>
						<th>품목명</th>
						<td colspan="3"><input type="text" id="impReplItemNm" name="impReplItemNm" value="<c:out value="${fundForm.impReplItemNm}" />" maxlength="150" class="form_text w100p" /></td>
						<th>품목수</th>
						<td><input type="text" id="impReplItemCnt" name="impReplItemCnt" value="<fmt:formatNumber value="${fundForm.impReplItemCnt}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="50" class="form_text w100p" style="text-align: right;" numberOnly /></td>
					</tr>
					<tr>
						<th>자기상표제품수출</th>
						<th>상표명</th>
						<td><input type="text" id="selfBrandExpItemNm" name="selfBrandExpItemNm" value="<c:out value="${fundForm.selfBrandExpItemNm}" />" maxlength="150" class="form_text w100p" /></td>
						<th>상표수</th>
						<td><input type="text" id="selfBrandExpCnt" name="selfBrandExpCnt" value="<fmt:formatNumber value="${fundForm.selfBrandExpCnt}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="50" class="form_text w100p" style="text-align: right;" numberOnly /></td>
						<th>품목수</th>
						<td><input type="text" id="selfBrandExpItemCnt" name="selfBrandExpItemCnt" value="<fmt:formatNumber value="${fundForm.selfBrandExpItemCnt}" pattern="#,###" />" onfocus="doNumberFloatFocusEvent(this);this.select();" onblur="doNumberFloatBlurEvent(this);" maxlength="50" class="form_text w100p" style="text-align: right;" numberOnly /></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">회사 공적사항</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 14%;" />
					<col style="width: 34%;" />
					<col />
				</colgroup>
				<tr>
					<c:choose>
						<c:when test="${priType eq 'S'}">
							<th colspan="2" style="text-align: left;border-right: 0px;">기본사항(한글 50자 이상 2000자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt1">0</span> / 2000)</th>
						</c:when>
						<c:otherwise>
							<th colspan="2" style="text-align: left;border-right: 0px;">기본사항(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt1">0</span> / 800)</th>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td colspan="3">
						<div id="divKongjukItem1" onclick="divFocus(this, 'textareaKongjukItem1', 'kongjukItem1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem1) > 0 ? 'none' : ''}" />;">
						</div>
						<div id="textareaKongjukItem1" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem1) > 0 ? '' : 'none'}" />;">
							<c:choose>
								<c:when test="${priType eq 'S'}">
									<textarea id="kongjukItem1" name="kongjukItem1" index="1" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기본 공적사항"><c:out value="${fundForm.kongjukItem1}" /></textarea>
								</c:when>
								<c:otherwise>
									<textarea id="kongjukItem1" name="kongjukItem1" index="1" onkeyup="textareaChk(this, 800);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기본 공적사항"><c:out value="${fundForm.kongjukItem1}" /></textarea>
								</c:otherwise>
							</c:choose>
						</div>
					</td>
				</tr>
				<c:if test="${priType ne 'S'}">
					<tr>
						<th colspan="2" style="text-align: left;border-right: 0px;">수출실적(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
						<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt2">0</span> / 800)</th>
					</tr>
					<tr>
						<td colspan="3">
							<div id="divKongjukItem2" onclick="divFocus(this, 'textareaKongjukItem2', 'kongjukItem2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem2) > 0 ? 'none' : ''}" />;">
							</div>
							<div id="textareaKongjukItem2" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem2) > 0 ? '' : 'none'}" />;">
								<textarea id="kongjukItem2" name="kongjukItem2" index="2" onkeyup="textareaChk(this, 800);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수출실적 공적사항"><c:out value="${fundForm.kongjukItem2}" /></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" style="text-align: left;border-right: 0px;">기술개발 및 품질향상 노력(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
						<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt3">0</span> / 800)</th>
					</tr>
					<tr>
						<td colspan="3">
							<div id="divKongjukItem3" onclick="divFocus(this, 'textareaKongjukItem3', 'kongjukItem3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem3) > 0 ? 'none' : ''}" />;">
							</div>
							<div id="textareaKongjukItem3" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem3) > 0 ? '' : 'none'}" />;">
								<textarea id="kongjukItem3" name="kongjukItem3" index="3" onkeyup="textareaChk(this, 800);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기술개발 및 품질향상 노력 공적사항"><c:out value="${fundForm.kongjukItem3}" /></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" style="text-align: left;border-right: 0px;">해외시장 개척활동(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
						<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt4">0</span> / 800)</th>
					</tr>
					<tr>
						<td colspan="3">
							<div id="divKongjukItem4" onclick="divFocus(this, 'textareaKongjukItem4', 'kongjukItem4');" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem4) > 0 ? 'none' : ''}" />;">
							</div>
							<div id="textareaKongjukItem4" style="width:100%; height: 150px;display: <c:out value="${fn:length(fundForm.kongjukItem4) > 0 ? '' : 'none'}" />;">
								<textarea id="kongjukItem4" name="kongjukItem4" index="4" onkeyup="textareaChk(this, 800);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="해외시장 개척활동 공적사항"><c:out value="${fundForm.kongjukItem4}" /></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" style="text-align: left;border-right: 0px;">기타 공적내용(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
						<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt5">0</span> / 800)</th>
					</tr>
					<tr>
						<td colspan="3">
							<textarea id="kongjukEtc" name="kongjukEtc" index="5" onkeyup="textareaChk(this, 800);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기타 공적내용 공적사항"><c:out value="${fundForm.kongjukEtc}" /></textarea>
						</td>
					</tr>
				</c:if>
				<input type="hidden" id="attFileId" name="attFileId" value="<c:out value="${fundForm.attFileId}" />" />
				<c:set var="fileAttachCnt" value="${fn:length(fileAttachList)}" />
				<c:choose>
					<c:when test="${priType eq 'S'}">
						<c:set var="awd017Cnt" value="${fn:length(awd017)}" />
						<tr>
							<th rowspan="${4 + awd017Cnt}">첨부파일 <strong class="point">*</strong></th>
							<td id="applicationAttachList" colspan="2" style="height: 35px;">
								<c:choose>
									<c:when test="${fileAttachCnt eq 0}">
										&nbsp;
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${fileAttachList}" varStatus="status">
											<div id="fileNo_<c:out value="${item.fileNo}" />" class="addedFile" data-detailcode="<c:out value="${item.mineType}" />">
												<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
												<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
													<a href="javascript:void(0);" onclick="doDeleteFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="btn_del">
														<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
													</a>
												</c:if>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th colspan="2" class="align_l">
								<span onclick="dofilterAttach('');" style="cursor: pointer;">
									* 전체파일
								</span>
								<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
									<span style="vertical-align: middle;padding-top: 3px;">
										<a href="javascript:void(0);" onclick="showUploadFilePopup('');" class="filename"><img src="<c:url value="/images/icon/icon_file.gif" />" /></a>
									</span>
								</c:if>
							</th>
						</tr>
						<tr>
							<th colspan="2" class="align_l">* 특수분야유공자 첨부파일</th>
						</tr>
						<c:forEach var="item" items="${awd017}" varStatus="status">
							<tr>
								<td colspan="2" class="align_l">
									<span onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <font style="color: red; font-weight: bold;"><c:out value="${item.chgCode02 eq 'Y' ? '(필수)' : ''}" /></font>
										<c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</span>
									<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
										<span style="vertical-align: middle;padding-top: 3px;">
											<a href="javascript:void(0);" onclick="showUploadFilePopup('<c:out value="${item.detailcd}" />');" class="filename"><img src="<c:url value="/images/icon/icon_file.gif" />" /></a>
										</span>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:set var="awd012Cnt" value="${fn:length(awd012)}" />
						<c:set var="awd013Cnt" value="${fn:length(awd013)}" />
						<tr>
							<th rowspan="${4 + awd012Cnt + awd013Cnt}">첨부파일 <strong class="point">*</strong></th>
							<td id="applicationAttachList" colspan="2" style="height: 35px;">
								<c:choose>
									<c:when test="${fileAttachCnt eq 0}">
										&nbsp;
									</c:when>
									<c:otherwise>
										<c:forEach var="item" items="${fileAttachList}" varStatus="status">
											<div id="fileNo_<c:out value="${item.fileNo}" />" class="addedFile" data-detailcode="<c:out value="${item.mineType}" />">
												<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
												<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
													<a href="javascript:void(0);" onclick="doDeleteFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="btn_del">
														<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
													</a>
												</c:if>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th colspan="2" class="align_l">
								<span onclick="dofilterAttach('');" style="cursor: pointer;">
									* 전체파일
								</span>
								<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
									<span style="vertical-align: middle;padding-top: 3px;">
										<a href="javascript:void(0);" onclick="showUploadFilePopup('');" class="filename"><img src="<c:url value="/images/icon/icon_file.gif" />" /></a>
									</span>
								</c:if>
							</th>
						</tr>
						<tr>
							<th colspan="2" class="align_l">* 포상신청업체 (수출의 탑과 수출업체종사자 동시신청시, 수출업체종사자 포상만 신청시)</th>
						</tr>
						<c:forEach var="item" items="${awd012}" varStatus="status">
							<tr>
								<td colspan="2" class="align_l">
									<span onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <font style="color: red; font-weight: bold;"><c:out value="${item.chgCode02 eq 'Y' ? '(필수)' : ''}" /></font>
										<c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</span>
									<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
										<span style="vertical-align: middle;padding-top: 3px;">
											<a href="javascript:void(0);" onclick="showUploadFilePopup('<c:out value="${item.detailcd}" />');" class="filename"><img src="<c:url value="/images/icon/icon_file.gif" />" /></a>
										</span>
									</c:if>
								</td>
							</tr>
						</c:forEach>
						<tr>
							<th colspan="2" class="align_l">* 수출의탑만 신청하는 업체</th>
						</tr>
						<c:forEach var="item" items="${awd013}" varStatus="status">
							<tr>
								<td colspan="2" class="align_l">
									<span onclick="dofilterAttach('<c:out value="${item.detailcd}" />');" style="cursor: pointer;">
										- <font style="color: red; font-weight: bold;"><c:out value="${item.chgCode02 eq 'Y' ? '(필수)' : ''}" /></font>
										<c:out value="${item.detailnm}" /> <c:out value="${item.chgCode01}" />
									</span>
									<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
										<span style="vertical-align: middle;padding-top: 3px;">
											<a href="javascript:void(0);" onclick="showUploadFilePopup('<c:out value="${item.detailcd}" />');" class="filename"><img src="<c:url value="/images/icon/icon_file.gif" />" /></a>
										</span>
									</c:if>
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
					<col style="width: 10%;" />
					<col style="width: 13%;" />
					<col style="width: 9%;" />
					<col style="width: 11%;" />
					<col style="width: 12%;" />
					<col style="width: 6%;" />
					<col style="width: 6%;" />
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
								<c:choose>
									<c:when test="${appEditYn eq 'Y'}">
										<button type="button" onclick="doSelectYg('30');" class="btn_tbl_primary">입력</button>
										<button type="button" onclick="doDeleteYg('30');" class="btn_tbl_primary">삭제</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doSelectYg('30');" class="btn_tbl_primary">조회</button>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th>수출의탑</th>
							<th>수출의탑(대표자)</th>
							<td id="ceoUserNmKor0" class="align_ctr"><c:out value="${fundForm.ceoUserNmKor0}" /></td>
							<input type="hidden" id="ceoUserNmKor0Hidden" name="ceoUserNmKor0Hidden" value="<c:out value="${fundForm.ceoUserNmKor0}" />" />
							<td id="ceoPos0" class="align_ctr"><c:out value="${fundForm.ceoPos0}" /></td>
							<td id="ceoJuminNo0" class="align_ctr"><c:out value="${fundForm.ceoJuminNo0}" /></td>
							<td id="ceoWrkTermYy0" class="align_r"><c:out value="${fundForm.ceoWrkTermYy0}" /> 년</td>
							<td id="ceoWrkTermMm0" class="align_r"><c:out value="${fundForm.ceoWrkTermMm0}" /> 개월</td>
							<td id="ceoHistory0"><c:out value="${fundForm.ceoHistory0}" /></td>
							<td class="align_ctr">
								<c:choose>
									<c:when test="${appEditYn eq 'Y'}">
										<button type="button" onclick="doAddressChk('10');" class="btn_tbl_primary">입력</button>
										<button type="button" onclick="doDeleteYg('10');" class="btn_tbl_primary">삭제</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doSelectYg('10');" class="btn_tbl_primary">조회</button>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th rowspan="3">개인포상</th>
							<th>
								대표자
								<c:if test="${(priType eq 'A' or priType eq 'T') and appEditYn eq 'Y'}">
									<!--
									<span id="ceoKong">(<input type="checkbox" name="ceoChk" value="Y" onclick="doCeoCopy();" class="form_checkbox" /><span style="color: #3781c8;">위와동일</span>)</span>
									-->
									<input type="hidden" name="ceoChk" value="N" />
								</c:if>
							</th>
							<td id="ceoUserNmKor" class="align_ctr"><c:out value="${fundForm.ceoUserNmKor}" /></td>
							<td id="ceoPos" class="align_ctr"><c:out value="${fundForm.ceoPos}" /></td>
							<td id="ceoJuminNo" class="align_ctr"><c:out value="${fundForm.ceoJuminNo}" /></td>
							<td id="ceoWrkTermYy" class="align_r"><c:out value="${fundForm.ceoWrkTermYy}" /> 년</td>
							<td id="ceoWrkTermMm" class="align_r"><c:out value="${fundForm.ceoWrkTermMm}" /> 개월</td>
							<td id="ceoHistory"><c:out value="${fundForm.ceoHistory}" /></td>
							<td class="align_ctr">
								<c:choose>
									<c:when test="${appEditYn eq 'Y'}">
										<button type="button" onclick="doSelectYg('21');" class="btn_tbl_primary">입력</button>
										<button type="button" onclick="doDeleteYg('21');" class="btn_tbl_primary">삭제</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doSelectYg('21');" class="btn_tbl_primary">조회</button>
									</c:otherwise>
								</c:choose>
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
								<c:choose>
									<c:when test="${appEditYn eq 'Y'}">
										<button type="button" onclick="doSelectYg('22');" class="btn_tbl_primary">입력</button>
										<button type="button" onclick="doDeleteYg('22');" class="btn_tbl_primary">삭제</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doSelectYg('22');" class="btn_tbl_primary">조회</button>
									</c:otherwise>
								</c:choose>
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
								<c:choose>
									<c:when test="${appEditYn eq 'Y'}">
										<button type="button" onclick="doSelectYg('23');" class="btn_tbl_primary">입력</button>
										<button type="button" onclick="doDeleteYg('23');" class="btn_tbl_primary">삭제</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="doSelectYg('23');" class="btn_tbl_primary">조회</button>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr>
					<th colspan="2">각자대표</th>
					<td colspan="7"><input type="text" id="eachCeoKr" name="eachCeoKr" value="<c:out value="${fundForm.eachCeoKr}" />" maxlength="100" class="form_text" style="width: 50%;" /></td>
				</tr>
				<tr>
					<th colspan="2">공동대표</th>
					<td colspan="2"><input type="text" id="jointCeoKr" name="jointCeoKr" value="<c:out value="${fundForm.jointCeoKr}" />" maxlength="20" class="form_text w100p" /></td>
					<th>수상이력</th>
					<td colspan="4"><input type="text" id="jointCeoHistory" name="jointCeoHistory" value="<c:out value="${fundForm.jointCeoHistory}" />" maxlength="100" class="form_text w100p" /></td>
				</tr>
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
			<h3 style="margin-top: 20px;">취소사유</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 16%;" />
					<col />
				</colgroup>
				<tr>
					<th>취소 여부</th>
					<td>
						<input type="radio" id="cancelYnY" name="cancelYn" value="Y" class="form_radio" <c:if test="${fundForm.cancelYn eq 'Y'}">checked="checked"</c:if> /> 예
						<input type="radio" id="cancelYnN" name="cancelYn" value="N" class="form_radio" <c:if test="${fundForm.cancelYn ne 'Y'}">checked="checked"</c:if> /> 아니오
					</td>
				</tr>
				<tr>
					<th style="text-align: left;border-right: 0px;">취소 내용</th>
					<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt8">0</span> / 1000)</th>
				</tr>
				<tr>
					<td colspan="2">
						<textarea id="cancelReason" name="cancelReason" index="8" onkeyup="textareaChk(this, 1000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="취소 내용"><c:out value="${fundForm.cancelReason}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">변경내역</h3>
		</div>
		<div class="mt-10">
			<c:set var="awd0040tCnt" value="${fn:length(awd0040tList)}" />
			<div style="overflow-y: hidden;">
				<table class="formTable">
					<colgroup>
						<col />
						<col style="width: 190px;" />
						<c:choose>
							<c:when test="${awd0040tCnt > 4}">
								<col style="width: 207px;" />
							</c:when>
							<c:otherwise>
								<col style="width: 190px;" />
							</c:otherwise>
						</c:choose>
					</colgroup>
					<tr>
						<th style="border-bottom: 0px;">변경내용</th>
						<th style="border-bottom: 0px;">변경아이디</th>
						<th style="border-bottom: 0px;">변경일</th>
					</tr>
				</table>
			</div>
			<div style="overflow-y: auto;height: 140px;">
				<table class="formTable" style="border-top: 1px solid #254f58;">
					<colgroup>
						<col />
						<col style="width: 190px;" />
						<col style="width: 190px;" />
					</colgroup>
					<c:choose>
						<c:when test="${awd0040tCnt > 0}">
							<c:forEach var="item" items="${awd0040tList}" varStatus="statusNo">
								<tr>
									<td><c:out value="${item.hisCdname}" /></td>
									<td align="center"><c:out value="${item.hisUserId}" /></td>
									<td align="center"><c:out value="${item.hisDate}" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="3" align="center">변경내역이 없습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
		<div class="mt-10">&nbsp;</div>
	</div>
</div>
</form>
<form id="applicationPopupDownloadForm" name="applicationPopupDownloadForm" method="post" onsubmit="return false;">
<input type="hidden" name="fileId" value="" />
<input type="hidden" name="fileNo" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		var f = document.applicationPopupForm;

		if (f.corpCnt.value > 0 && f.statusChk.value == 'I') {
			alert('이미 신청된 업체입니다. 확인 후 진행 바랍니다.');

			closeLayerPopup();
		}

		if (f.statusChk.value == 'I') {
			f.statusChk.value = 'U';
		}

		$('#applicationPopupForm #textCnt1').text($('#applicationPopupForm #kongjukItem1').val().length);
		<c:if test="${priType ne 'S'}">
			$('#applicationPopupForm #textCnt2').text($('#applicationPopupForm #kongjukItem2').val().length);
			$('#applicationPopupForm #textCnt3').text($('#applicationPopupForm #kongjukItem3').val().length);
			$('#applicationPopupForm #textCnt4').text($('#applicationPopupForm #kongjukItem4').val().length);
			$('#applicationPopupForm #textCnt5').text($('#applicationPopupForm #kongjukEtc').val().length);
		</c:if>

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
		// 상장회사
		setRadio(f.stockYn, '<c:out value="${empty fundForm.stockYn ? '1' : fundForm.stockYn}" />');

		doEmailSelect('CO');
		doEmailSelect('USER');
		doEmailSelect('USER_SECOND');

		disabledWorkNew(f.worknewYn);

		doCalculate();
		changeCoType();

		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		var priType = getSelectedValue(f.priType);

		if (priType == 'S') {
			$('tr[id^="normalYgTr"]').hide();
			$('tr[id^="specialYgTr"]').show();
			$('div[id^="normalYgDiv"]').hide();
		} else {
			$('tr[id^="normalYgTr"]').show();
			$('tr[id^="specialYgTr"]').hide();
			$('div[id^="normalYgDiv"]').show();
		}

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber([
			'#applicationPopupForm #coHp'
			, '#applicationPopupForm #userPhone'
			, '#applicationPopupForm #userFax'
			, '#applicationPopupForm #userHp'
			, '#applicationPopupForm #mainBankPhone'
		], 'W');

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#applicationPopupForm .phoneNum'], 'R');

		// 로딩이미지 종료
		$('#loading_image').hide();
	});

	function doApplicationReport() {
		var f = document.applicationPopupForm;

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
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공적조서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'T') {
			param += '&reportGb3=Y';		// 이력서
			param += '&reportGb4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공적조서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'S') {
			param += '&reportGb2=Y';		// 공적조서
			param += '&reportGb3=Y';		// 이력서
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

	function changePriType(obj) {
		var f = document.applicationPopupForm;

		if (f.hiddenPriType.value == '' || f.hiddenPriType.value == null) {
			return;
		}

		if (f.hiddenPriType.value == obj.value) {
			return;
		}

		showPriTypeChangePopup(f.svrId.value, f.applySeq.value, '', obj.value, 'tradeDayApplicationChangePriType');
	}

	function showPriTypeChangePopup(svrId, applySeq, priType, prvPriType, event) {
		var f = document.applicationPopupForm;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/priTypeChangePopup.do" />'
			, params : {
				svrId : svrId
				, applySeq : applySeq
				, prvPriType : prvPriType
			}
			, callbackFunction : function(resultObj){
				if (event == 'tradeDayApplicationDeleteYg') {
					var check = resultObj.check;

					if (check == 'save') {
						f.prvPriType.value = priType;

						global.ajax({
							url : '<c:url value="/tdms/popup/deleteKongJuk.do" />'
							, dataType : 'json'
							, type : 'POST'
							, data : {
								svrId : svrId
								, applySeq : applySeq
								, prvPriType : priType
							}
							, async : true
							, spinner : true
							, success : function(data){
								// alert('삭제 되었습니다.');

								// 레이어 닫기
								closeLayerPopup();

								if (priType == '10') {
									$('#applicationPopupForm #ceoUserNmKor0').html('');
									$('#applicationPopupForm #ceoPos0').html('');
									$('#applicationPopupForm #ceoJuminNo0').html('-');
									$('#applicationPopupForm #ceoWrkTermYy0').html('년');
									$('#applicationPopupForm #ceoWrkTermMm0').html('개월');
									$('#applicationPopupForm #ceoHistory0').html('');
								} else if (priType == '21') {
									$('#applicationPopupForm #ceoUserNmKor').html('');
									$('#applicationPopupForm #ceoPos').html('');
									$('#applicationPopupForm #ceoJuminNo').html('-');
									$('#applicationPopupForm #ceoWrkTermYy').html('년');
									$('#applicationPopupForm #ceoWrkTermMm').html('개월');
									$('#applicationPopupForm #ceoHistory').html('');
								} else if (priType == '22') {
									$('#applicationPopupForm #empUserNmKor').html('');
									$('#applicationPopupForm #empPos').html('');
									$('#applicationPopupForm #empJuminNo').html('-');
									$('#applicationPopupForm #empWrkTermYy').html('년');
									$('#applicationPopupForm #empWrkTermMm').html('개월');
									$('#applicationPopupForm #empHistory').html('');
								} else if (priType == '23') {
									$('#applicationPopupForm #workUserNmKor').html('');
									$('#applicationPopupForm #workPos').html('');
									$('#applicationPopupForm #workJuminNo').html('-');
									$('#applicationPopupForm #workWrkTermYy').html('년');
									$('#applicationPopupForm #workWrkTermMm').html('개월');
									$('#applicationPopupForm #workHistory').html('');
								}
							}
						});
					} else if (check == 'cancel') {
						alert('변경사유를 입력하지 않아 삭제가 취소 되었습니다.');

						closeLayerPopup();
					}
				} else if (event == 'tradeDayApplicationChangePriType') {
					var check = resultObj.check;

					if (check == 'save') {
						closeLayerPopup();

						var returnObj = {
							event : event
							, svrId : svrId
							, applySeq : applySeq
							, prvPriType : prvPriType
						};

						layerPopupCallback(returnObj);
					} else if (check == 'cancel') {
						closeLayerPopup();

						f.priType.value = f.hiddenPriType.value;

						if (prvPriType == 'A' || prvPriType == 'T') {
							setSelect(f.expTapPrizeCd, '<c:out value="${fundForm.expTapPrizeCd}" />');
							setRadio(f.priTapYn, '<c:out value="${empty fundForm.priTapYn ? 'Y' : fundForm.priTapYn}" />');
						} else {
							setSelect(f.expTapPrizeCd, '');
							setRadio(f.priTapYn, 'Y');
						}
					}
				} else if (event == 'tradeDayApplicationTempSave') {
					var check = resultObj.check;

					if (check == 'save') {
						f.coNmCh.value = strToAscii(f.coNmCh.value);
						f.ceoNmCh.value = strToAscii(f.ceoNmCh.value);

						f.stateChk.value = '01';

						global.ajax({
							url : '<c:url value="/tdms/popup/saveApplication.do" />'
							, dataType : 'json'
							, type : 'POST'
							, data : $('#applicationPopupForm').serialize()
							, async : true
							, spinner : true
							, success : function(data){
							}
						});
					} else if (check == 'cancel') {
						alert('변경사유를 입력하지 않아 저장이 취소 되었습니다.');

						closeLayerPopup();
					}
				}
			}
		});
	}

	function doEmailKey(event) {
		if (event.keyCode == 64) {
			event.returnValue = false;
		}
	}

	function doEmailChange(obj) {
		obj.value = obj.value.replace(/@/gi, '');
	}

	function doEmailSelect(val) {
		var f = document.applicationPopupForm;

		if (val == 'CO') {
			if (f.coEmailCon.value == '직접입력') {
				$('#applicationPopupForm #coEmail2').attr('readonly', false);
				$('#applicationPopupForm #coEmail2').css('background-color', '#ffffff');
			} else {
				f.coEmail2.value = f.coEmailCon.value;
				$('#applicationPopupForm #coEmail2').attr('readonly', true);
				$('#applicationPopupForm #coEmail2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'USER') {
			if (f.userEmailCon.value == '직접입력') {
				$('#applicationPopupForm #userEmail2').attr('readonly', false);
				$('#applicationPopupForm #userEmail2').css('background-color', '#ffffff');
			} else {
				f.userEmail2.value = f.userEmailCon.value;
				$('#applicationPopupForm #userEmail2').attr('readonly', true);
				$('#applicationPopupForm #userEmail2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'USER_SECOND') {
			if (f.userEmailConSecond.value == '직접입력') {
				$('#applicationPopupForm #userEmailSecond2').attr('readonly', false);
				$('#applicationPopupForm #userEmailSecond2').css('background-color', '#ffffff');
			} else {
				f.userEmailSecond2.value = f.userEmailConSecond.value;
				$('#applicationPopupForm #userEmailSecond2').attr('readonly', true);
				$('#applicationPopupForm #userEmailSecond2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'KONG') {
			if (f.emailCon.value == '직접입력') {
				$('#applicationPopupForm #email2').attr('readonly', false);
				$('#applicationPopupForm #email2').css('background-color', '#ffffff');
			} else {
				f.email2.value = f.emailCon.value;
				$('#applicationPopupForm #email2').attr('readonly', true);
				$('#applicationPopupForm #email2').css('background-color', '#f3f4f2');
			}
		}
	}

	function doCalculate() {
		var f = document.applicationPopupForm;

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

		// vExpAmtRate = (Math.pow((vCurrDrExpAmt/vTwoDrExpAmt), 1/2) -1) * 100;
		// f.expAmtRate.value = plusComma(Math.round(vExpAmtRate * 100) / 100);

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

	function divFocus(from, target, textarea) {
		$(from).hide();
		$('#applicationPopupForm #' + target).show();
		$('#applicationPopupForm #' + textarea).focus();
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

		$('#applicationPopupForm #textCnt' + index).text(textareaLength > limit ? limit : textareaLength);

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

	// 우편번호 팝업
	function zipCodeListPopup(addrGb) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/zipCodePopup.do" />'
			, callbackFunction : function(resultObj){
				if (addrGb == 'CO') {
					$('#applicationPopupForm #coZipCd').val(resultObj.zipNo);
					$('#applicationPopupForm #coAddr1').val(resultObj.roadAddrPart1);
					$('#applicationPopupForm #coAddr2').val(resultObj.roadAddrPart2);
					$('#applicationPopupForm #coAddrEn').val(resultObj.engAddr);

					doBonsaYn(resultObj.jusoGb);
				}

				$('#applicationPopupForm #zipCdChk').val('Y');
			}
		});
	}

	function doBonsaYn(jusoGb) {
		var f = document.applicationPopupForm;

		if (jusoGb == 'SU' || jusoGb == 'IC' || jusoGb == 'GG') {
			f.bonsaYn[0].checked = true;
			f.bonsaYn[1].checked = false;
		} else {
			f.bonsaYn[0].checked = false;
			f.bonsaYn[1].checked = true;
		}
	}

	function doBonsaYnTxt(jusoGb){
		var f = document.applicationPopupForm;

		if (jusoGb.value.length > 3) {
			jusoGb = jusoGb.value.substring(0, 2);
		}

		if (jusoGb == '서울' || jusoGb == '인천' || jusoGb == '경기') {
			f.bonsaYn[0].checked = true;
			f.bonsaYn[1].checked = false;
		} else {
			f.bonsaYn[0].checked = false;
			f.bonsaYn[1].checked = true;
		}
	}

	// 업종선택 팝업
	function upCodeListPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/upCodePopup.do" />'
			, callbackFunction : function(resultObj){
				var f = document.applicationPopupForm;

				var upDep1 = resultObj.chgCode01;

				f.upCode.value = resultObj.detailcd;
				f.upDep1.value = upDep1;
				f.upDep2.value = resultObj.chgCode02;
				f.upCodeNm.value = resultObj.detailnm;

				f.jejoupYn.value = 'N';
				f.serviceYn.value = 'N';
				f.agrifoodYn.value = 'N';

				if (upDep1 == '제조') {
					f.jejoupYn.value = 'Y';
				} else if (upDep1 == '서비스') {
					f.serviceYn.value = 'Y';
				} else if (upDep1 == '농림수산업') {
					f.agrifoodYn.value = 'Y';
				}

				doHsCodeChk();
			}
		});
	}

	function doHsCodeChk() {
		var f = document.applicationPopupForm;

		if (f.serviceYn.value == 'Y') {
			$('#applicationPopupForm #expItemHscode1').attr('readonly', false);
			$('#applicationPopupForm #expItemNm1').attr('readonly', false);
			$('#applicationPopupForm #expItemHscode2').attr('readonly', false);
			$('#applicationPopupForm #expItemNm2').attr('readonly', false);
			$('#applicationPopupForm #expItemHscode1').css('background-color', '#ffffff');
			$('#applicationPopupForm #expItemNm1').css('background-color', '#ffffff');
			$('#applicationPopupForm #expItemHscode2').css('background-color', '#ffffff');
			$('#applicationPopupForm #expItemNm2').css('background-color', '#ffffff');
		} else if (f.serviceYn.value == 'N') {
			$('#applicationPopupForm #expItemHscode1').attr('readonly', true);
			$('#applicationPopupForm #expItemNm1').attr('readonly', true);
			$('#applicationPopupForm #expItemHscode2').attr('readonly', true);
			$('#applicationPopupForm #expItemNm2').attr('readonly', true);
			$('#applicationPopupForm #expItemHscode1').css('background-color', '#f6f6f6');
			$('#applicationPopupForm #expItemNm1').css('background-color', '#f6f6f6');
			$('#applicationPopupForm #expItemHscode2').css('background-color', '#f6f6f6');
			$('#applicationPopupForm #expItemNm2').css('background-color', '#f6f6f6');
		}
	}

	// HS CODE 선택 팝업
	function hsCodeListPopup(val) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/hsCodePopup.do" />'
			, callbackFunction : function(resultObj){
				var hsCd = (resultObj.hsCd || '');

				if (hsCd.length == 10) {
					$('#applicationPopupForm #expItemHscode' + val).val(resultObj.hsCd);
					$('#applicationPopupForm #expItemMticode' + val).val(resultObj.mtiCd);
					$('#applicationPopupForm #expItemNm' + val).val(resultObj.korName);
					$('#applicationPopupForm #expItemMtiname' + val).val(resultObj.mtiNm);

					// 레이어 닫기
					closeLayerPopup();
				} else {
					alert('HS CODE는 10자리만 입력이 가능합니다.');

					return;
				}
			}
		});
	}

	function addCompanyRow() {
		var html = '';
		html += '<tr>';
		html += '	<td colspan="3">';
		html += '		<select name="officeCd" class="form_select" style="width: 13%;" title="사무실구분">';
					<c:forEach var="item" items="${awd009U}" varStatus="status">
		html += '				<option value="<c:out value="${item.detailcd}" />"><c:out value="${item.detailnm}" /></option>';
					</c:forEach>
		html += '		</select>';
		html += '		<input type="text" name="address" value="" maxlength="200" class="form_text" style="width: 86%;" title="산재보험가입 주소" />';
		html += '	</td>';
		html += '	<td colspan="2">';
		html += '		<input type="text" name="addressId" value="" maxlength="11" class="form_text w100p" title="산재보험번호" />';
		html += '	</td>';
		html += '	<td style="text-align: center;">';
		html += '		<button type="button" onclick="deleteCompanyRow(this);" class="btn_tbl_border">삭제</button>';
		html += '	</td>';
		html += '</tr>';

		var companyrs1 = $('#applicationPopupForm #companyrs1').attr('rowspan');
		$('#applicationPopupForm #companyrs1').attr('rowspan', (parseInt(companyrs1) + 1));

		var companyrs2 = $('#applicationPopupForm #companyrs2').attr('rowspan');
		$('#applicationPopupForm #companyrs2').attr('rowspan', (parseInt(companyrs2) + 1));

		$('#applicationPopupForm #companytr').before(html);
	}

	function deleteCompanyRow(obj) {
		var companyrs1 = $('#applicationPopupForm #companyrs1').attr('rowspan');
		$('#applicationPopupForm #companyrs1').attr('rowspan', (parseInt(companyrs1) - 1));

		var companyrs2 = $('#applicationPopupForm #companyrs2').attr('rowspan');
		$('#applicationPopupForm #companyrs2').attr('rowspan', (parseInt(companyrs2) - 1));

		$(obj).closest('tr').eq(0).remove();

		event.stopPropagation();
	}

	function disabledWorkNew(obj) {
		var valueYn = obj.value;

		if (valueYn == 'Y') {
			$('#applicationPopupForm #pastWorkerCnt').attr('disabled', false);
			$('#applicationPopupForm #currWorkerCnt').attr('disabled', false);
			$('#applicationPopupForm #worknewCnt').attr('disabled', false);
		} else {
			$('#applicationPopupForm #pastWorkerCnt').attr('disabled', true);
			$('#applicationPopupForm #currWorkerCnt').attr('disabled', true);
			$('#applicationPopupForm #worknewCnt').attr('disabled', true);
		}
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

	function doAddressChk(val) {
		var f = document.applicationPopupForm;

		var form1 = f.addressId;
		var form2 = f.officeCd;
		var form3 = f.address;

		var hiddenForm1 = f.hiddenAddressId;
		var hiddenForm2 = f.hiddenOfficeCd;
		var hiddenForm3 = f.hiddenAddress;

		var isMulti = checkMulti(form1);

		var isChk = true;

		if (isMulti == 'multi') {
			var len1 = form1.length;
			var len2 = hiddenForm1.length;

			if (len == len2) {
				for (var i = 0; i < len; i++) {
					if (form1[i].value != hiddenForm1[i].value) {
						isChk = false;
					}
					if (form2[i].value != hiddenForm2[i].value) {
						isChk = false;
					}
					if (form3[i].value != hiddenForm3[i].value) {
						isChk = false;
					}
				}
			} else {
				isChk = false;
			}

			if (!isChk) {
				alert('산재보험 정보가 변경된 내용이 있습니다.\n변경된 내용을 저장후 입력해 주세요.');

				return;
			}
		} else if (isMulti == 'single') {
			if (form1.value != hiddenForm1.value) {
				isChk = false;
			}
			if (form2.value != hiddenForm2.value) {
				isChk = false;
			}
			if (form3.value != hiddenForm3.value) {
				isChk = false;
			}

			if (!isChk) {
				alert('산재보험 정보가 변경된 내용이 있습니다.\n변경된 내용을 저장후 입력해 주세요.');

				return;
			}
		}

		if (isChk) {
			doSelectYg(val);
		}
	}

	// 유공자 공적 조서 팝업
	function doSelectYg(val) {
		var f = document.applicationPopupForm;

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
			    , editYn : f.appEditYn.value
				, bsnAplEndDt : f.bsnAplEndDt.value
				// , ceoChk : isChecked(f.ceoChk) ? 'Y' : 'N'
				, ceoChk : 'N'
			}
			, callbackFunction : function(resultObj){
				var event = resultObj.event;

				// 공적조서 저장
				if (event == 'tradeDayReferenceSave') {
					// 레이어 닫기
					closeLayerPopup();

					if (val == '10') {
						$('#applicationPopupForm #hiddenCeoUserNmKor0').val(resultObj.userNmKor);
						$('#applicationPopupForm #ceoUserNmKor0').html(resultObj.userNmKor);
						$('#applicationPopupForm #ceoUserNmKor0Hidden').val(resultObj.userNmKor);
						$('#applicationPopupForm #ceoPos0').html(resultObj.pos);
						$('#applicationPopupForm #ceoJuminNo0').html(resultObj.juminNo);
						$('#applicationPopupForm #ceoWrkTermYy0').html(resultObj.wrkTermYy + ' 년');
						$('#applicationPopupForm #ceoWrkTermMm0').html(resultObj.wrkTermMm + ' 개월');
						$('#applicationPopupForm #ceoHistory0').html(resultObj.history);
					} else if (val == '21') {
						$('#applicationPopupForm #hiddenCeoUserNmKor').val(resultObj.userNmKor);
						$('#applicationPopupForm #ceoUserNmKor').html(resultObj.userNmKor);
						$('#applicationPopupForm #ceoPos').html(resultObj.pos);
						$('#applicationPopupForm #ceoJuminNo').html(resultObj.juminNo);
						$('#applicationPopupForm #ceoWrkTermYy').html(resultObj.wrkTermYy + ' 년');
						$('#applicationPopupForm #ceoWrkTermMm').html(resultObj.wrkTermMm + ' 개월');
						$('#applicationPopupForm #ceoHistory').html(resultObj.history);
					} else if (val == '22') {
						$('#applicationPopupForm #hiddenEmpUserNmKor').val(resultObj.userNmKor);
						$('#applicationPopupForm #empUserNmKor').html(resultObj.userNmKor);
						$('#applicationPopupForm #empPos').html(resultObj.pos);
						$('#applicationPopupForm #empJuminNo').html(resultObj.juminNo);
						$('#applicationPopupForm #empWrkTermYy').html(resultObj.wrkTermYy + ' 년');
						$('#applicationPopupForm #empWrkTermMm').html(resultObj.wrkTermMm + ' 개월');
						$('#applicationPopupForm #empHistory').html(resultObj.history);
					} else if (val == '23') {
						$('#applicationPopupForm #hiddenWorkUserNmKor').val(resultObj.userNmKor);
						$('#applicationPopupForm #workUserNmKor').html(resultObj.userNmKor);
						$('#applicationPopupForm #workPos').html(resultObj.pos);
						$('#applicationPopupForm #workJuminNo').html(resultObj.juminNo);
						$('#applicationPopupForm #workWrkTermYy').html(resultObj.wrkTermYy + ' 년');
						$('#applicationPopupForm #workWrkTermMm').html(resultObj.wrkTermMm + ' 개월');
						$('#applicationPopupForm #workHistory').html(resultObj.history);
					} else if (val == '30') {
						$('#applicationPopupForm #hiddenSpUserNmKor').val(resultObj.userNmKor);
						$('#applicationPopupForm #spUserNmKor').html(resultObj.userNmKor);
						$('#applicationPopupForm #spPos').html(resultObj.pos);
						$('#applicationPopupForm #spJuminNo').html(resultObj.juminNo);
						$('#applicationPopupForm #spWrkTermYy').html(resultObj.wrkTermYy + ' 년');
						$('#applicationPopupForm #spWrkTermMm').html(resultObj.wrkTermMm + ' 개월');
						$('#applicationPopupForm #spHistory').html(resultObj.history);
					}
				}
			}
		});
	}

	// 유공자 공적 조서 삭제
	function doDeleteYg(val) {
		var f = document.applicationPopupForm;

		if (confirm('공적조서를 삭제 하시겠습니까?')) {
			var saveChk = true;

			var prvPriType = '';

			if (val == '10') {
				prvPriType = 'D1';
			} else if (val == '21') {
				prvPriType = 'D2';
			} else if (val == '22') {
				prvPriType = 'D3';
			} else if (val == '23') {
				prvPriType = 'D4';
			}

			showPriTypeChangePopup(f.svrId.value, f.applySeq.value, val, prvPriType, 'tradeDayApplicationDeleteYg');
		}
	}

	// 첨부파일 다운로드
	function doDownloadFile(fileId, fileNo) {
		var f = document.applicationPopupDownloadForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = fileId;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	function doApplicationTempUpdate() {
		if (confirm('임시저장 상태로 복구 하시겠습니까?')) {
			var f = document.applicationPopupForm;

			f.stateChk.value = '01';

			global.ajax({
				url : '<c:url value="/tdms/popup/saveTempUpdate.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					svrId : f.svrId.value
					, applySeq : f.applySeq.value
				}
				, async : true
				, spinner : true
				, success : function(data){
					// alert('처리 되었습니다.');

					var returnObj = {
						event : 'tradeDayApplicationTempUpdate'
						, svrId : f.svrId.value
						, applySeq : f.applySeq.value
					};

					layerPopupCallback(returnObj);
				}
			});
		}
	}

	function doCeoCopy() {
		var f = document.applicationPopupForm;

		if (f.ceoUserNmKor0Hidden.value == '' && f.ceoChk.checked) {
			alert('"수출의탑(대표자)"가 입력되지 않았습니다. 확인후 진행바랍니다.');

			f.ceoChk.checked = false;
		}

		if (f.ceoChk.checked) {
			if (confirm('수출의탑 대표자 내용을 동일하게 입력하시겠습니까?')) {
				var f = document.applicationPopupForm;

				global.ajax({
					url : '<c:url value="/tdms/popup/copyCeoKongJuk.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : {
						svrId : f.svrId.value
						, applySeq : f.applySeq.value
					}
					, async : true
					, spinner : true
					, success : function(data){
						if (data.resultInfo) {
							var info = data.resultInfo;

							$('#applicationPopupForm #ceoUserNmKor').html(info.userNmKor);
							$('#applicationPopupForm #ceoPos').html(info.pos);
							if (info.juminNo) {
								var juminNo1 = info.juminNo.substring(0, 6);
								var juminNo2 = info.juminNo.substring(6);

								$('#applicationPopupForm #ceoJuminNo').html(juminNo1 + '-' + juminNo2);
							}
							$('#applicationPopupForm #ceoWrkTermYy').html(info.wrkTermYy + ' 년');
							$('#applicationPopupForm #ceoWrkTermMm').html(info.wrkTermMm + ' 개월');
							$('#applicationPopupForm #ceoHistory').html(info.history);
						}
					}
				});
			} else {
				f.ceoChk.checked = false;

				return;
			}
		} else if (!f.ceoChk.checked) {
			return;
		}
	}

	function doValidTap(){
		var f = document.applicationPopupForm;

		var selected = getSelectedValue(f.expTapPrizeCd);
		var selectedText = getSelectedText(f.expTapPrizeCd);
		var curExpAmt = parseFloat(f.currExpAmtSum.value.replace(/,/gi, ''));

		if (selected == '') {
			alert('신청탑 종류를 확인후 진행 바랍니다.');
			f.expTapPrizeCd.focus();

			return false;
		}

		if (selected == '1000') {
			if (f.speTapYnChk.value == 'Y' || f.speTapYnChk.value == 'N') {
				alert('특별탑(서비스탑)으로 변경할 수 없습니다.');

				return false;
			}
		}

		<c:forEach var="item" items="${expTabCode}" varStatus="status">
			<c:set var="checkValue" value="${item.checkValue}" />
			if (selected == '<c:out value="${item.prizeCd}" />') {
				var msg = '신청탑종류가 부적합합니다. 확인 바랍니다.\n';
				msg += '\n  신청탑종류 : ' + selectedText;
				msg += '\n  당해년도 매출 : ' + f.currExpAmtSum.value;

				// 과거 포상 확인
				if (<c:out value="${checkValue}" /> <= parseFloat(<c:out value="${pastTap.checkValue}" />)) {
					alert('과거 수상 내역 이상의 상패만 신청할 수 있습니다. 확인 바랍니다.\n과거 수상 포상명 : ' + '<c:out value="${pastTap.prizeName}" />');

					return false;
				}

				if (curExpAmt < <c:out value="${checkValue}" />) {
					alert(msg);

					return false;
				}
			}
		</c:forEach>

		return true;
	}

	function doApplicationSave() {
		var f = document.applicationPopupForm;

		var priType = getSelectedValue(f.priType);

		if (priType == 'A' || priType == 'T') {
			if (!doValidTap()) {
				return;
			}
		}

		if (priType != 'S') {
			if (f.zipCdChk.value == 'N') {
				alert('우편번호가 잘못 되었습니다. 신주소 우편번호로 수정하십시오.');

				return;
			}
		}

		if (!doValidFormRequired(f)) {
			return;
		}

		if (priType == 'A') {
			if ($('#applicationPopupForm #hiddenCeoUserNmKor0').val() == '' || $('#applicationPopupForm #hiddenCeoUserNmKor0').val() == null) {
				alert('수출의 탑 대표자 공적조서를 입력하셔야 합니다.');

				return;
			}

			if (
				$('#applicationPopupForm #hiddenCeoUserNmKor').val() == ''
				&& $('#applicationPopupForm #hiddenEmpUserNmKor').val() == ''
				&& $('#applicationPopupForm #hiddenWorkUserNmKor').val() == ''
			) {
				alert('공적조서를 입력하셔야 합니다.');

				return;
			}

			if ($('#applicationPopupForm #worknewYnY').is(':checked') && $('#applicationPopupForm #worknewCnt').value <= 0) {
				alert('무역일자리 창출 업체일 경우 창출된 일자리 수를 입력해 주세요.');

				return;
			}
		} else if (priType == 'T') {
			if ($('#applicationPopupForm #hiddenCeoUserNmKor0').val() == '' || $('#applicationPopupForm #hiddenCeoUserNmKor0').val() == null) {
				alert('수출의 탑 대표자 공적조서를 입력하셔야 합니다.');

				return;
			}
		} else if (priType == 'P') {
			if (
				$('#applicationPopupForm #hiddenCeoUserNmKor').val() == ''
				&& $('#applicationPopupForm #hiddenEmpUserNmKor').val() == ''
				&& $('#applicationPopupForm #hiddenWorkUserNmKor').val() == ''
			) {
				alert('공적조서를 입력하셔야 합니다.');

				return;
			}
		} else if (priType == 'S') {
			if ($('#applicationPopupForm #hiddenSpUserNmKor').val() == '' || $('#applicationPopupForm #hiddenSpUserNmKor').val() == null) {
				alert('공적조서를 입력하셔야 합니다.');

				return;
			}
		}

		if (confirm('저장 하시겠습니까?')) {
			f.coNmCh.value = strToAscii(f.coNmCh.value);
			f.ceoNmCh.value = strToAscii(f.ceoNmCh.value);

			f.stateChk.value = '02';

			global.ajax({
				url : '<c:url value="/tdms/popup/saveApplication.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : $('#applicationPopupForm').serialize()
				, async : true
				, spinner : true
				, success : function(data){

					var returnObj = {
						event : 'tradeDayApplicationSave'
						, svrId : f.svrId.value
						, applySeq : f.applySeq.value
					};

					layerPopupCallback(returnObj);
				}
			});
		}
	}

	function doApplicationTempSave() {
		var f = document.applicationPopupForm;

		var priType = getSelectedValue(f.priType);

		if (priType == 'A' || priType == 'T') {
			if (!doValidTap()) {
				return;
			}
		}

		if (priType != 'S') {
			if (f.zipCdChk.value == 'N') {
				alert('우편번호가 잘못 되었습니다. 신주소 우편번호로 수정하십시오.');

				return;
			}
		}

		if (!doValidFormRequired(f)) {
			return;
		}

		if (confirm('저장 하시겠습니까?')) {
			if (f.hiddenPriType.value != '' && f.hiddenPriType.value != null) {
				if (f.hiddenPriType.value != priType) {
					showPriTypeChangePopup(f.svrId.value, f.applySeq.value, '', priType, 'tradeDayApplicationTempSave');
				} else {
					f.coNmCh.value = strToAscii(f.coNmCh.value);
					f.ceoNmCh.value = strToAscii(f.ceoNmCh.value);

					f.stateChk.value = '01';

					global.ajax({
						url : '<c:url value="/tdms/popup/saveApplication.do" />'
						, dataType : 'json'
						, type : 'POST'
						, data : $('#applicationPopupForm').serialize()
						, async : true
						, spinner : true
						, success : function(data){

							var returnObj = {
								event : 'tradeDayApplicationTempSave'
								, svrId : f.svrId.value
								, applySeq : f.applySeq.value
							};

							layerPopupCallback(returnObj);
						}
					});
				}
			} else {
				f.coNmCh.value = strToAscii(f.coNmCh.value);
				f.ceoNmCh.value = strToAscii(f.ceoNmCh.value);

				f.stateChk.value = '01';

				global.ajax({
					url : '<c:url value="/tdms/popup/saveApplication.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : $('#applicationPopupForm').serialize()
					, async : true
					, spinner : true
					, success : function(data){

						var returnObj = {
							event : 'tradeDayApplicationTempSave'
							, svrId : f.svrId.value
							, applySeq : f.applySeq.value
						};

						layerPopupCallback(returnObj);
					}
				});
			}
		}
	}

	function doApplicationDelete() {
		if (confirm('삭제 하시겠습니까?')) {
			var f = document.applicationPopupForm;

			global.ajax({
				url : '<c:url value="/tdms/popup/deleteApplication.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					svrId : f.svrId.value
					, applySeq : f.applySeq.value
				}
				, async : true
				, spinner : true
				, success : function(data){
					// alert('삭제 되었습니다.');

					var returnObj = {
						event : 'tradeDayApplicationDelete'
						, svrId : f.svrId.value
						, applySeq : f.applySeq.value
					};

					layerPopupCallback(returnObj);
				}
			});
		}
	}

	function strToAscii(str) {
		var conStr = '';
		for (var i = 0; i < str.length; i++) {
			chr = '&#' + str.charCodeAt(i) + ';';
			conStr = conStr + chr ;
		}

		// 변환된 아스키 코드 문자열 반환
		return conStr;
	}

	function doWorknew() {
		var f = document.applicationPopupForm;

		if (f.pastWorkerCnt.value == '') {
			f.pastWorkerCnt.value = 0;
		}
		if (f.currWorkerCnt.value == '') {
			f.currWorkerCnt.value = 0;
		}

		if (doNumberCheck(f.pastWorkerCnt.value.replace(/,/gi, '')) == false) {
			f.pastWorkerCnt.value = 0;
		}
		if (doNumberCheck(f.currWorkerCnt.value.replace(/,/gi, '')) == false) {
			f.currWorkerCnt.value = 0;
		}

		f.worknewCnt.value = plusComma(parseFloat(f.currWorkerCnt.value.replace(/,/gi, '')) - parseFloat(f.pastWorkerCnt.value.replace(/,/gi, '')));

		if (parseFloat(f.worknewCnt.value.replace(/,/gi, '')) > 0) {
			setRadio(f.worknewYn, 'Y');
		} else {
			setRadio(f.worknewYn, 'N');
		}

		f.pastWorkerCnt.value = plusComma(f.pastWorkerCnt.value);
		f.currWorkerCnt.value = plusComma(f.currWorkerCnt.value);
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

	function showUploadFilePopup(awdGb) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayFilePopup.do" />'
			, params : {
				attFileId: $('#applicationPopupForm #attFileId').val()
				, mineType: awdGb
				, fileType: 'file'
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();

				if (resultObj.attFileId) {
					$('#applicationPopupForm #attFileId').val(resultObj.attFileId);

					global.ajax({
						type : 'POST'
						, url : '<c:url value="/tdms/popup/selectApplcationAttachList.do" />'
						, data : {
							fileId : resultObj.attFileId
						}
						, dataType : 'json'
						, async : true
						, spinner : true
						, success : function(data){
							$('#applicationPopupForm #applicationAttachList').empty();

							if (data.attachList.length) {
								var attachList = data.attachList;

								for (var i = 0 ; i < attachList.length; i++) {
									var fileNo = attachList[i].fileNo;

									if (fileNo != '') {
										var mineType = attachList[i].mineType;
										var fileId = attachList[i].fileId;
										var fileName = attachList[i].fileName;

										var html = '';
										html += '<div id="fileNo_' + fileNo + '" class="addedFile" data-detailcode="' + mineType + '">';
										html += '	<a href="javascript:void(0);" onclick="doDownloadFile(\'' + fileId + '\', \'' + fileNo + '\');" class="filename">' + fileName + '</a>';
										<c:if test="${empty appEditYn or appEditYn eq 'Y'}">
											html += '	<a href="javascript:void(0);" onclick="doDeleteFile(\'' + fileId + '\', \'' + fileNo + '\');" class="btn_del">';
											html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
											html += '	</a>';
										</c:if>
										html += '</div>';

										$('#applicationPopupForm #applicationAttachList').append(html);
									}
								}
							}
						}
					});
				}
			}
		});
	}

	// 첨부파일 삭제
	function doDeleteFile(fileId, fileNo) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundFileDelete.do" />'
				, data : {
					fileId : fileId
					, fileNo : fileNo
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#applicationPopupForm #fileNo_' + fileNo).remove();
				}
			});
		}
	}

	function doNumberFloatFocusEvent(obj) {
		removeMinusMask(obj);
	}

	function doNumberFloatBlurEvent(obj) {
		try {
	      	var oNumber = obj.value.replace(/,/g, '');
			var sNumber = oNumber;
			var lNumber = '';
	        var tNumber = '';
	        var dotIndex = '';

			var bSign = '';
			var bDot = '';

			if (oNumber.indexOf('-') != -1) {
				bSign = 1;
			}

			if ((dotIndex = oNumber.indexOf('.')) != -1) {
				bDot = 1 ;
			}

			if (bSign) {
				if (bDot) {
					sNumber = oNumber.substring(1, dotIndex);
					lNumber = oNumber.substring(dotIndex);
				} else {
					sNumber = oNumber.substring(1);
				}
			} else {
				if (bDot) {
					sNumber = oNumber.substring(0, dotIndex);
					lNumber = oNumber.substring(dotIndex);
				}
			}

	        var i;
	        var j = 0;
	        var tLen = sNumber.length;

	      	if (sNumber.length <= 3) {
				return;
	      	}

			if (bSign) {
				tNumber += '-';
			}

	      	for (var i = 0 ; i < tLen ; i++ ) {
				if (i != 0 && (i % 3 == tLen % 3)) {
					tNumber += ',';
				}

	         	if (i < sNumber.length) {
	         		tNumber += sNumber.charAt(i);
	         	}
	    	}

	      	obj.value = tNumber + lNumber;
		} catch(errorObject) {
	    }
	}

	function removeMinusMask(obj) {
		try {
			if (obj.length == null) {
			  	obj.value = obj.value.replace(/(\,|\:)/g, '');
			} else {
				for (var i = 0 ; i < obj.length ; i++) {
				  	obj[i].value = obj[i].value.replace(/(\,|\:)/g, '');
				}
			}
		} catch (errorObject) {
	    }
	}

	function changeCoType() {
		var f = document.applicationPopupForm;
		var priType = getSelectedValue(f.priType);

		if (priType == 'S') {
			$('strong[id^="specialCoType"]').hide();
		}

		/*
		if (obj.value == '10') {
			$('strong[id^="specialCoType"]').show();
		} else if (obj.value == '20') {
			$('strong[id^="specialCoType"]').hide();
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