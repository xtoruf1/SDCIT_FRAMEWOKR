<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 		uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="<c:url value='/js/sso/aes.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/sso/AesUtil.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/sso/pbkdf2.js' />"></script>
<c:set var="todayYear" value="${todayYear}" />
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>

<form id="form1" name="form1" method="get" onsubmit="return false;">

<input type="hidden" name="statusChk"     	value="">
<input type="hidden" name="svrId"     id="svrId"		value="<c:out value="${param.svrId}"/>" />
<input type="hidden" name="applyId"   id="applyId"  	value="<c:out value="${param.applyId}"/>" />
<input type="hidden" name="gubun"   id="gubun"  	value="<c:out value="${param.gubun}"/>" />
<input type="hidden" name="fileId" 			value="<c:out value="${fundVo.fileId}"/>" />
<input type="hidden" name="tradeDept"     	value="<c:out value="${fundVo.tradeDept}"/>">
<input type="hidden" name="recoSendYn"     	value="<c:out value="${fundVo.recoSendYn}"/>" />
<input type="hidden" name="moneyUse2"     	value="<c:out value="${fundVo.moneyUse2}"/>" />
<input type="hidden" name="moneyUse3"     	value="<c:out value="${fundVo.moneyUse3}"/>" />

<input type="hidden" name="bsnStartDt"     	value="<c:out value="${param.bsnStartDt}"/>" />

<input type="text"   name="display_none" style="display:none"/>
<input type="hidden" name="listPage" 		value="<c:out value="${param.listPage}"/>" />
<input type="hidden" name="parentListPage" 	value="<c:out value="${param.parentListPage}"/>" />

<!-- 상위 검색조건 -->
<input type="hidden" name="searchSvrId"     	value="<c:out value="${param.searchSvrId}"/>" />
<input type="hidden" name="searchTitle"     	value="<c:out value="${param.searchTitle}"/>" />
<input type="hidden" name="searchCoNmKor"     	value="<c:out value="${param.searchCoNmKor}"/>" />
<input type="hidden" name="searchBsNo"     		value="<c:out value="${param.searchBsNo}"/>" />
<input type="hidden" name="searchIndustryNo"    value="<c:out value="${param.searchIndustryNo}"/>" />
<input type="hidden" name="searchCeoNmKor"     	value="<c:out value="${param.searchCeoNmKor}"/>" />
<input type="hidden" name="searchApplyId"     	value="<c:out value="${param.searchApplyId}"/>" />
<input type="hidden" name="searchSt"     		value="<c:out value="${param.searchSt}"/>" />
<input type="hidden" name="searchTradeDept"     value="<c:out value="${param.searchTradeDept}"/>" />
<input type="hidden" name="searchRecoSendYn"    value="<c:out value="${param.searchRecoSendYn}"/>" />

<!-- 보모 페이지 검색 조건 -->
<input type="hidden" name="searchYear" 		value="<c:out value="${param.searchYear}"/>" />
<%-- <INPUT type="hidden" name="searchTitle" 	value="<c:out value="${param.searchTitle}"/>" /> --%>

<!-- 페이지 위치 -->
<div class="location _fixed">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doCreport();" 			class="btn_sm btn_primary bnt_modify_auth">기업신용정보</a>
		<a href="javascript:doPrint();" 			class="btn_sm btn_primary bnt_modify_auth">신청서 인쇄</a>
		<c:if test="${not empty fundVo.budinessPlan}" >
		<a href="javascript:businessPlanPopup();" 	class="btn_sm btn_primary bnt_modify_auth">사업계획서 조회</a>
		</c:if>
	</div>
	<div class="ml-15">
		<c:if test='${ (param.readYn ne "Y")  and (fund0000Vo.st eq "02") }' >
			<c:if test='${ (fundVo.recoSendYn eq "N") or (user.fundAuthType eq "ADMIN") }'>
				<a href="javascript:doSave();" 			class="btn_sm btn_primary bnt_modify_auth">저장</a>
			</c:if>
		</c:if>

		<a href="javascript:doList();" 			class="btn_sm btn_secondary">목록</a>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">KITA무역진흥자금 내역</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col/>
			<col style="width:15%;">
			<col/>
			<col style="width:15%;">
			<col/>
		</colgroup>
		<tr>
			<th >기금융자명</th>
			<td colspan="5"><c:out value="${fund0000Vo.title}"/></td>
		</tr>
		<tr>
			<th>접수기간</th>
			<td>
			<c:out value="${fund0000Vo.bsnDt}"/>
			</td>
			<th>융자 1차 지급일</th>
			<td>
			<c:out value="${fund0000Vo.fund1Dt}"/>
			</td>
			<th>추천유효기간</th>
			<td>
			<c:out value="${fund0000Vo.validDt}"/>
			</td>
		</tr>
		<tr>
			<th>사업기간</th>
			<td>
			<c:out value="${fund0000Vo.bsnAplDt}"/>
			</td>
			<th>융자 2차 지급일</th>
			<td>
			<c:out value="${fund0000Vo.fund2Dt}"/>
			</td>
			<th>
				진행상태
			</th>
			<td><span style="color:red;">
			<c:out value="${fund0000Vo.stNm}"/>
			</span></td>
		</tr>
	 </table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">신청상세정보</h3>
		<div class="ml-auto">
<%-- 		<c:if test="${not empty fundVo.coCrdtRtStdYear}" > --%>
<!-- 			<span>연도:</span> -->
<%-- 			<c:out value="${fundVo.coCrdtRtStdYear}"/> --%>
<%-- 		</c:if> --%>
<%-- 		<c:if test="${not empty fundVo.coCrdtRt}" > --%>
<!-- 			<span>신용등급:</span> -->
<%-- 			<c:out value="${fundVo.coCrdtRt}"/> --%>
<%-- 		</c:if> --%>
			<span>접수번호 :</span>
			<c:out value="${fundVo.applyId}"/>
		</div>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width:7.5%;">
			<col style="width:7.5%;">
			<col/>
			<col style="width:12%;">
			<col/>
			<col style="width:12%;">
			<col/>
		</colgroup>
		<tr>
			<th rowspan="2" colspan="2">(1)무역업고유번호<br/><br/>사업자등록번호</th>
			<td>
				<input type="text" class="form_text w100p" id="bsNo" name="bsNo" value="<c:out value="${fundVo.bsNo}"/>" maxlength="30" readonly="readonly" placeholder="무역업고유번호" title="무역업고유번호" />
			</td>
			<th rowspan="2" >(2)회사명</th>
			<td rowspan="2" >
				<input type="text" class="form_text w100p" id="coNmKor" name="coNmKor" value="<c:out value="${fundVo.coNmKor}"/>" maxlength="40"  placeholder="회사명" title="회사명" />
			</td>
			<th rowspan="2" >(3)대표자
			</th>
			<td rowspan="2" >
				<input type="text" class="form_text w100p" id="ceoNmKor" name="ceoNmKor" value="<c:out value="${fundVo.ceoNmKor}"/>" maxlength="40"  placeholder="대표자" title="대표자" />
			</td>
		</tr>
		<tr>
			<td>
				<input type="text" class="form_text w100p" id="industryNo" name="industryNo" value="<c:out value="${fundVo.industryNo}"/>" maxlength="30" readonly="readonly"  placeholder="사업자등록번호" title="사업자등록번호" />
			</td>
		</tr>

		<tr>
			<th rowspan="2" ><span style="color:#b00000;">(4)</span>주소</th>
			<th rowspan="2" ><button type="button" class="btn_tbl" onclick="doSaveAddr()">주소수정</button></th>
			<td rowspan="2" colspan="3">
				<div>
					<div class="flex align_center form_row w100p">
						<input type="text" class="form_text" id="coZipCd" name="coZipCd" value="<c:out value="${fundVo.coZipCd}"/>" size="6" maxlength="6" readonly="readonly" required="required"  placeholder="우편번호" title="우편번호" />
						<span class="form_search w70p ml-8">
							<input type="text" class="form_text" id="coAddr1" name="coAddr1" value="<c:out value="${fundVo.coAddr1}"/>" size="40" maxlength="500" readonly="readonly" required="required"  placeholder="주소" title="주소" />
							<button type="button" class="btn_icon btn_search" title="주소검색" onclick="zipCodeListPopup()"></button>
						</span>
					</div>
					<div class="w100p mt-5">
						<input type="text" class="form_text w100p" id="coAddr2" name="coAddr2" value="<c:out value="${fundVo.coAddr2}"/>" size="65" maxlength="500" required="required" placeholder="주소" title="주소" />
					</div>
				</div>
			</td>
			<th rowspan="2" ><span style="color:#b00000;">(5)</span>회사전화번호<br/><br/>회사팩스번호</th>
			<td >
				<input type="text" class="form_text w100p" id="coTelNum" name="coTelNum" value="<c:out value="${fundVo.coTelNum}"/>" maxlength="15" placeholder="회사전화번호" title="회사전화번호"  />
			</td>
		</tr>
		<tr>
			<td>
				<input type="text" class="form_text w100p" id="coFaxNum" name="coFaxNum" value="<c:out value="${fundVo.coFaxNum}"/>" maxlength="15" placeholder="회사팩스번호" title="회사팩스번호"  />
			</td>
		</tr>

		<tr>
			<th colspan="2" ><span style="color:#b00000;">(6)</span>홈페이지</th>
			<td colspan="3">
				<input type="text" class="form_text w100p" id="homeAddr" name="homeAddr" value="<c:out value="${fundVo.homeAddr}"/>" maxlength="70" placeholder="홈페이지" title="홈페이지" />
			</td>
			<th  >(7)업종구분</th>
			<td >
				<label class="label_form">
					<input type="radio" class="form_radio" name="jejoupYn" value="Y" <c:out value="${jejoup_ynChk1}"/>  >
					<span class="label">제조</span>
				</label>

				<label class="label_form">
					<input type="radio" class="form_radio" name="jejoupYn" value="N" <c:out value="${jejoup_ynChk2}"/> >
					<span class="label">비제조</span>
				</label>
			</td>
		</tr>
		<tr>
			<th colspan="2" rowspan="2" >(8)주요수출국가<br/><br/>주요수출품목</th>
			<td colspan="3">
				<input type="text" class="form_text w100p" id="mainexpnation" name="mainexpnation" value="<c:out value="${fundVo.mainexpnation}"/>" maxlength="101" placeholder="주요수출국가" title="주요수출국가" />
			</td>
			<th rowspan="2" >(9)전년도매출액</th>
			<td rowspan="2" >
				<div class="form_row">
					<input type="text" class="form_text align_r" id="salAmount" name="salAmount" value="<c:out value="${fundVo.salAmount}"/>" maxlength="30" placeholder="전년도매출액" title="전년도매출액"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /> <span class="append">(원)</span>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<input type="text" class="form_text w100p" id="productname" name="productname" value="<c:out value="${fundVo.productname}"/>" maxlength="70" placeholder="주요수출품목" title="주요수출품목" />
			</td>
		</tr>
		<tr>
			<th colspan="2" >(10)자본금</th>
			<td>
				<div class="form_row">
					<input type="text" class="form_text align_r" id="capital" name="capital" value="<c:out value="${fundVo.capital}"/>" maxlength="30" placeholder="자본금" title="자본금"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">(원)</span>
				</div>
			</td>
			<th>(11)종업원</th>
			<td>
				<div class="form_row">
					<input type="text" class="form_text align_r" id="workerCnt" name="workerCnt" value="<c:out value="${fundVo.workerCnt}"/>" maxlength="30" placeholder="종업원" title="종업원"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">(명)</span>
				</div>
			</td>
			<th>(12)설립년도</th>
			<td>
				<div class="form_row">
					<input type="text" class="form_text" id="coCretYear" name="coCretYear" value="<c:out value="${fundVo.coCretYear}"/>" maxlength="4" placeholder="설립년도" title="설립년도"
					 onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">(년)</span>
				</div>
			</td>
		</tr>
		<tr>
			<th rowspan="2"><span style="color:#b00000;">(13)</span>담당자</th>
			<th>성명</th>
			<td>
				<input type="text" class="form_text w100p" id="membNm" name="membNm" value="<c:out value="${fundVo.membNm}"/>" maxlength="30" placeholder="성명" title="성명"/>
			</td>
			<th >부서명 / 직위명</th>
			<td>
				<div class="form_row">
					<input type="text" class="form_text" id="membDeptnm" name="membDeptnm" value="<c:out value="${fundVo.membDeptnm}"/>" maxlength="30" placeholder="부서명" title="부서명"/>
					<div class="spacing">/</div>
					<input type="text" class="form_text" id="membPosition" name="membPosition" value="<c:out value="${fundVo.membPosition}"/>" maxlength="30" placeholder="직위명" title="직위명"/>
				</div>
			</td>
			<th >전화번호</th>
			<td >
				<input type="text" class="form_text w100p" id="membTel" name="membTel" value="<c:out value="${fundVo.membTel}"/>" maxlength="15" placeholder="전화번호" title="전화번호" onkeypress="doKeyPressEvent(this, 'TEL', event)" />
			</td>
		</tr>

		<tr>
			<th>이메일</th>
			<td>
				<input type="text" class="form_text w100p" id="membEmail" name="membEmail" value="<c:out value="${fundVo.membEmail}"/>" maxlength="80" placeholder="이메일" title="이메일"/>
			</td>
			<th >핸드폰번호</th>
			<td >
				<input type="text" class="form_text w100p" id="membHp" name="membHp" value="<c:out value="${fundVo.membHp}"/>" maxlength="15" placeholder="핸드폰" title="핸드폰" onkeypress="doKeyPressEvent(this, 'TEL', event)" />
			</td>
			<th >팩스번호</th>
			<td >
				<input type="text" class="form_text w100p" id="membFax" name="membFax" value="<c:out value="${fundVo.membFax}"/>" maxlength="15" placeholder="팩스번호" title="팩스번호" onkeypress="doKeyPressEvent(this, 'TEL', event)" />
			</td>
		</tr>

		<table class="formTable">
			<colgroup>
				<col width="7.5%">
				<col width="15%">
				<col width="*">
				<col width="*">
				<col width="*">
			</colgroup>
			<tr>
				<th rowspan="4" align="center" onclick="getAmtCheck()">(14)수출실적
					<br/>
					<br/>
					<button type="button" class="btn_tbl">조회</button>
				</th>
				<th>구분</th>
				<th>
					<c:out value="${yearVo.twoYear}"/>년
				</th>
				<th>
					<c:out value="${yearVo.oneYear}"/>년
				</th>
				<th>
					증가율(%)
				</th>
			</tr>
			<tr>
				<th>직수출(A)</th>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="expAmount2" name="expAmount2" value="<c:out value="${fundVo.expAmount2}"/>" maxlength="13" readonly="readonly" placeholder="2년전수출실적" title="2년전수출실적"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="expAmount1" name="expAmount1" value="<c:out value="${fundVo.expAmount1}"/>" maxlength="13" readonly="readonly" placeholder="1년전수출실적" title="1년전수출실적"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<input type="text" class="form_text align_r" id="expRate" name="expRate" value="<c:out value="${fundVo.expRate}"/>" maxlength="20" readonly="readonly" placeholder="수출실적증가율" title="수출실적증가율"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">%</span>
					</div>
				</td>
			</tr>
			<tr>
				<th>로컬등 기타수출(B)</th>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="etcExpAmount2" name="etcExpAmount2" value="<c:out value="${fundVo.etcExpAmount2}"/>" maxlength="13"  placeholder="2년전기타수출" title="2년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="etcExpAmount1" name="etcExpAmount1" value="<c:out value="${fundVo.etcExpAmount1}"/>" maxlength="13"  placeholder="1년전기타수출" title="1년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<input type="text" class="form_text align_r" id="etcExpRate" name="etcExpRate" value="<c:out value="${fundVo.etcExpRate}"/>" maxlength="20" readonly="readonly" placeholder="기타수출증가율" title="기타수출증가율"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">%</span>
					</div>
				</td>
			</tr>
			<tr>
				<th>합계(A+B)</th>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="sumExpAmount2" name="sumExpAmount2" value="<c:out value="${fundVo.sumExpAmount2}"/>" maxlength="13" readonly="readonly" placeholder="2년전합계" title="2년전합계"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="sumExpAmount1" name="sumExpAmount1" value="<c:out value="${fundVo.sumExpAmount1}"/>" maxlength="13" readonly="readonly" placeholder="1년전합계" title="1년전합계"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
					</div>
				</td>
				<td class="align_r">
					<div class="form_row">
						<input type="text" class="form_text align_r" id="expIncrsRate" name="expIncrsRate" value="<c:out value="${fundVo.expIncrsRate}"/>" maxlength="20" readonly="readonly" placeholder="합계증가율" title="합계증가율"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">%</span>
					</div>
				</td>
			</tr>
		<tr >
			<th  rowspan="5" class="align_l">(15)<br/>해상/항공운임<br/>사용액</th>
			<th  class="align_ctr">구분</th>
			<th  class="align_ctr">2019년6월 ~ 2020년5월</th>
			<th  class="align_ctr">2020년6월 ~ 2021년5월</th>
			<th  class="align_ctr">증가율(%)</th>
		</tr>

		<tr >
			<th  >해상운임(A)</th>
			<td  class="align_r">
				<input type="text" class="form_text align_r" id="speSeaAmount2" name="speSeaAmount2" value="<c:out value="${fundVo.speSeaAmount2}"/>" maxlength="13"  placeholder="2년전수출실적" title="2년전수출실적"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speSeaAmount1" name="speSeaAmount1" value="<c:out value="${fundVo.speSeaAmount1}"/>" maxlength="13"  placeholder="1년전수출실적" title="1년전수출실적"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speSeaRate" name="speSeaRate" value="<c:out value="${fundVo.speSeaRate}"/>" maxlength="20"  placeholder="수출실적증가율" title="수출실적증가율" readonly="readonly"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />%
			</td>
		</tr>

		<tr >
			<th  >항공운임(B)</th>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speAirAmount2" name="speAirAmount2" value="<c:out value="${fundVo.speAirAmount2}"/>" maxlength="13"  placeholder="2년전기타수출" title="2년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speAirAmount1" name="speAirAmount1" value="<c:out value="${fundVo.speAirAmount1}"/>" maxlength="13"  placeholder="1년전기타수출" title="1년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speAirRate" name="speAirRate" value="<c:out value="${fundVo.speAirRate}"/>" maxlength="20"  placeholder="기타수출증가율" title="기타수출증가율" readonly="readonly"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />%
			</td>
		</tr>

		<tr >
			<th  >특송/내륙 등(C)</th>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speEtcAmount2" name="speEtcAmount2" value="<c:out value="${fundVo.speEtcAmount2}"/>" maxlength="13"  placeholder="2년전기타수출" title="2년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speEtcAmount1" name="speEtcAmount1" value="<c:out value="${fundVo.speEtcAmount1}"/>" maxlength="13"  placeholder="1년전기타수출" title="1년전기타수출"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='speSum()' />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speEtcRate" name="speEtcRate" value="<c:out value="${fundVo.speEtcRate}"/>" maxlength="20"  placeholder="기타수출증가율" title="기타수출증가율" readonly="readonly"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />%
			</td>
		</tr>

		<tr >
			<th >합계(A+B+C)</th>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speSumAmount2" name="speSumAmount2" value="<c:out value="${fundVo.speSumAmount2}"/>" maxlength="13" readonly="readonly" placeholder="2년전합계" title="2년전합계"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speSumAmount1" name="speSumAmount1" value="<c:out value="${fundVo.speSumAmount1}"/>" maxlength="13" readonly="readonly" placeholder="2년전합계" title="1년전합계"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />
			</td>
			<td  class="align_r" >
				<input type="text" class="form_text align_r" id="speIncrsRate" name="speIncrsRate" value="<c:out value="${fundVo.speEtcRate}"/>" maxlength="20"  readonly="readonly" placeholder="합계증가율" title="합계증가율"
					onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"   />%
			</td>
		</tr>




			<tr>
				<th colspan="2" >(16)현재보유LC</th>
				<td class="align_r">
					<input type="text" class="form_text align_r" id="lcAmount" name="lcAmount" value="<c:out value="${fundVo.lcAmount}"/>" maxlength="13" placeholder="현재보유LC" title="현재보유LC"
					readonly="readonly" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
				</td>
				<th>
					(17)계약금액
				</th>
				<td class="align_r">
					<div class="form_row">
						<span class="prepend">US$</span><input type="text" class="form_text align_r" id="extContrAmount" name="extContrAmount" value="<c:out value="${fundVo.extContrAmount}"/>" style="width: 80%" maxlength="13"  placeholder="계약금액" title="계약금액"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
					</div>
				</td>
			</tr>
	 	</table>

	 	<table class="formTable">
			<colgroup>
				<col width="7.5%">
				<col width="15%">
				<col width="*">
				<col width="25.8%">
				<col width="*">
			</colgroup>

			<tr>
				<th rowspan="3" align="left">(18)융자</th>
				<th >자금용도</th>
				<td>
					<c:set var="moneyUseNm" value="" />
					<c:if test='${fundVo.moneyUse1 eq "A"}'>
						<c:set var="moneyUseNm" value="해외시장개척자금" />
					</c:if>
					<c:if test='${fundVo.moneyUse2 eq "B"}'>
						<c:choose>
							<c:when test='${moneyUseNm eq ""}'>
								<c:set var="moneyUseNm" value="${moneyUseNm} +수출이행자금" />
							</c:when>
							<c:otherwise>
								<c:set var="moneyUseNm" value="${moneyUseNm} +, 수출이행자금" />
							</c:otherwise>
						</c:choose>
					</c:if>
					<c:if test='${fundVo.moneyUse3 eq "C"}'>
						<c:set var="moneyUseNm" value="수출마케팅자금" />
					</c:if>
						<select id="moneyUse1" name="moneyUse1" class="form_select wAuto" >
							<c:forEach var="item" items="${LMS005}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq fundVo.moneyUse1}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>

				</td>
				<th>자금신청액<br/>
					&nbsp;(신청한도: 30,000,000원, 금리: 1.5%)
				</th>
				<td>
					<select id="necessAmount" name="necessAmount" class="form_select" >
						<option value="30000000" <c:if test='${"30,000,000" eq fundVo.necessAmount}'>selected="selected"</c:if>>30,000,000</option>
						<option value="20000000" <c:if test='${"20,000,000" eq fundVo.necessAmount}'>selected="selected"</c:if>>20,000,000</option>
						<option value="10000000" <c:if test='${"10,000,000" eq fundVo.necessAmount}'>selected="selected"</c:if>>10,000,000</option>
					</select>
					(원)
				</td>
			</tr>
			<tr>
				<th >융자희망은행</th>
				<td>
					<select id="mainBankCd" name="mainBankCd" class="form_select" >
						<c:forEach var="item" items="${COM004}" varStatus="status">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq fundVo.mainBankCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>
				<td colspan="2">
					<div class="form_row">
						<input type="text" class="form_text " id="mainBankBranchNm" name="mainBankBranchNm" value="<c:out value="${fundVo.mainBankBranchNm}"/>" style="width: 30%" maxlength="30" title="융자희망은행지점" /> <span class="append">(지점)</span>
					</div>
				</td>
			</tr>
			<tr>
				<th >담보종류</th>
				<td colspan="3">

					<input type="hidden" id="mortgageAmountArr" name="mortgageAmountArr" value="<c:out value="${fundVo.mortgageAmount}"/>" />

					<c:forEach var="item" items="${JCS003}" varStatus="status">
						<ul>
							<li class="form_row mt-5">
								<label class="label_form">
									<input type="checkbox" class="form_checkbox" name="mortgage" value="<c:out value="${item.detailcd}"/>" <c:if test="${fn:contains(fundVo.mortgage, item.detailcd )}">checked="checked"</c:if>>
									<span class="label" style="min-width: 120px;"><c:out value="${item.detailnm}"/></span>
								</label>
								<c:set var="cnt" value="0" />
								<c:forEach var="mortgage" items="${mortgageList}" varStatus="mortgageListStatus">
									<c:if test="${mortgage.mortgage eq item.detailcd }">
										<c:set var="cnt" value="1" />
										<input type="text" class="form_text align_r mortgageAmount" id="mortgageAmount<c:out value="${item.detailcd}"/>" name="mortgageAmount" value="<c:out value="${mortgage.mortgageAmount}"/>"  maxlength="13" title="담보금액"
										onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  /><span class="append">(원)</span>
									</c:if>
								</c:forEach>
								<c:if test="${cnt eq 0 }">
									<input type="text" class="form_text align_r mortgageAmount" id="mortgageAmount<c:out value="${item.detailcd}"/>" name="mortgageAmount" value=""  maxlength="13" title="담보금액"
									onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /><span class="append">(원)</span>
								</c:if>
							</li>
						</ul>
					</c:forEach>
				</td>
			</tr>
		</table>


		<c:set var="colspan" value="5" />
<c:choose>
	<c:when test='${yearChk eq "Y"}'>
			<c:set var="colspan" value="4" />

		<table class="formTable">
			<colgroup>
				<col width="7.5%">
				<col width="15%">
				<col width="15%">
				<col width="*">
			</colgroup>
			<tr>
				<th rowspan="8" align="left">(19)<br/>&nbsp;자금사용계획</th>
				<th align="center" >자금용도</th>
				<th align="center" >예상소요금액 (단위: 원)</th>
				<th align="center" >대상국가 및 품목</th>
			</tr>
			<tr >
				<th >수출해상운임</th>
				<td align="right" >
					<input type="text" class="form_text align_r" id="spePlancd11amt" name="spePlancd11amt" value="<c:out value="${fundVo.spePlancd11amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>
				<td  >
					<input type="text" class="form_text " id="spePlancd1Nationitem" name="spePlancd1Nationitem" value="<c:out value="${fundVo.spePlancd1Nationitem}"/>"  maxlength="95" title="" />
				</td>
			</tr>

			<tr >
				<th  >수출항공운임</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="spePlancd21amt" name="spePlancd21amt" value="<c:out value="${fundVo.spePlancd21amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>

				<td  >
					<input type="text" class="form_text " id="spePlancd2Nationitem" name="spePlancd2Nationitem" value="<c:out value="${fundVo.spePlancd2Nationitem}"/>"  maxlength="95" title="" />
				</td>
			</tr>

			<tr >
				<th  >수출용 원자재 수입 해상운임</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="spePlancd31amt" name="spePlancd31amt" value="<c:out value="${fundVo.spePlancd31amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>

				<td  >
					<input type="text" class="form_text " id="spePlancd3Nationitem" name="spePlancd3Nationitem" value="<c:out value="${fundVo.spePlancd2Nationitem}"/>"  maxlength="95" title="" />
				</td>
			</tr>

			<tr >
				<th  >수출용 원자재 수입 항공운임</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="spePlancd41amt" name="spePlancd41amt" value="<c:out value="${fundVo.spePlancd41amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>

				<td  >
					<input type="text" class="form_text " id="spePlancd4Nationitem" name="spePlancd4Nationitem" value="<c:out value="${fundVo.spePlancd4Nationitem}"/>"  maxlength="100" title="" />
				</td>
			</tr>

			<tr >
				<th  >수출용 내륙운송운임</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="spePlancd51amt" name="spePlancd51amt" value="<c:out value="${fundVo.spePlancd51amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>

				<td  >
					<input type="text" class="form_text " id="spePlancd5Nationitem" name="spePlancd5Nationitem" value="<c:out value="${fundVo.spePlancd5Nationitem}"/>"  maxlength="95" title="" />
				</td>
			</tr>

			<tr >
				<th  >기타</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="spePlancd61amt" name="spePlancd61amt" value="<c:out value="${fundVo.spePlancd61amt}"/>" maxlength="13"  placeholder="" title=""
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='spePlanAmtSum(this)' />
				</td>

				<td  >
					<input type="text" class="form_text " id="spePlancd6Nationitem" name="spePlancd6Nationitem" value="<c:out value="${fundVo.spePlancd6Nationitem}"/>"  maxlength="95" title="" />
				</td>
			</tr>


			<tr >
				<th  >합계</th>
				<td  align="right" >
					<input type="text" class="form_text align_r" id="speSumPlancd1amt" name="speSumPlancd1amt" value="<c:out value="${fundVo.speSumPlancd1amt}"/>" maxlength="13"  placeholder="" title="" readonly="readonly"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
				</td>

				<td  >
					<input type="hidden" class="form_text align_r" id="speSumPlancdAllAmt" name="speSumPlancdAllAmt" value="<c:out value="${fundVo.speSumPlancdAllAmt}"/>" maxlength="13"  placeholder="" title="" readonly="readonly"
						onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
				</td>
			</tr>



</c:when>	<%--  <c:when test='${yearChk eq "Y"}'>  --%>
<c:otherwise>

	</table>
	<table class="formTable">

		<colgroup>
			<col width="100px">
			<col width="210px">
			<col width="120px">
			<col width="120px">
			<col width="*">
		</colgroup>

		<tr>
			<th rowspan="12" >(19)<br/>&nbsp;자금사용계획</th>
			<th align="center" rowspan="2">비용구분</th>
			<th align="center" colspan="2">예상소요금액 (단위: 원)</th>
			<th align="center" rowspan="2">마케팅 활동 대상국가 및 품목</th>
		</tr>

		<tr>
			<th align="center">1년차</th>
			<th align="center">2년차</th>
		</tr>


		<tr>
			<th >국내 외 전시/박람회 참가</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd11amt" name="plancd11amt" value="<c:out value="${fundVo.plancd11amt}"/>" style="width: 100%" maxlength="13" title="국내 외 전시/박람회 참가 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd12amt" name="plancd12amt" value="<c:out value="${fundVo.plancd12amt}"/>" style="width: 100%" maxlength="13" title="국내 외 전시/박람회 참가 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd1Nationitem" name="plancd1Nationitem" value="<c:out value="${fundVo.plancd1Nationitem}"/>" style="width: 100%" maxlength="13" title="국내 외 전시/박람회 참가 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >수출 상담회 참가</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd21amt" name="plancd21amt" value="<c:out value="${fundVo.plancd21amt}"/>" style="width: 100%" maxlength="13" title="수출 상담회 참가 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd22amt" name="plancd22amt" value="<c:out value="${fundVo.plancd22amt}"/>" style="width: 100%" maxlength="13" title="수출 상담회 참가 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd2Nationitem" name="plancd2Nationitem" value="<c:out value="${fundVo.plancd2Nationitem}"/>" style="width: 100%" maxlength="13" title="수출 상담회 참가 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >바이어 초청</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd31amt" name="plancd31amt" value="<c:out value="${fundVo.plancd31amt}"/>" style="width: 100%" maxlength="13" title="바이어 초청 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd32amt" name="plancd32amt" value="<c:out value="${fundVo.plancd32amt}"/>" style="width: 100%" maxlength="13" title="바이어 초청 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd3Nationitem" name="plancd3Nationitem" value="<c:out value="${fundVo.plancd3Nationitem}"/>" style="width: 100%" maxlength="13" title="바이어 초청 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >바이어 방문</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd41amt" name="plancd41amt" value="<c:out value="${fundVo.plancd41amt}"/>" style="width: 100%" maxlength="13" title="바이어 방문 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd42amt" name="plancd42amt" value="<c:out value="${fundVo.plancd42amt}"/>" style="width: 100%" maxlength="13" title="바이어 방문 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd4Nationitem" name="plancd4Nationitem" value="<c:out value="${fundVo.plancd4Nationitem}"/>" style="width: 100%" maxlength="13" title="바이어 방문 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >해외 특허 획득</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd51amt" name="plancd51amt" value="<c:out value="${fundVo.plancd51amt}"/>" style="width: 100%" maxlength="13" title="해외 특허 획득 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd52amt" name="plancd52amt" value="<c:out value="${fundVo.plancd52amt}"/>" style="width: 100%" maxlength="13" title="해외 특허 획득 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd5Nationitem" name="plancd5Nationitem" value="<c:out value="${fundVo.plancd5Nationitem}"/>" style="width: 100%" maxlength="13" title="해외 특허 획득 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >해외 규격인증 획득</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd61amt" name="plancd61amt" value="<c:out value="${fundVo.plancd61amt}"/>" style="width: 100%" maxlength="13" title="해외 규격인증 획득 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd62amt" name="plancd62amt" value="<c:out value="${fundVo.plancd62amt}"/>" style="width: 100%" maxlength="13" title="해외 규격인증 획득 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd6Nationitem" name="plancd6Nationitem" value="<c:out value="${fundVo.plancd6Nationitem}"/>" style="width: 100%" maxlength="13" title="해외 규격인증 획득 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >해외 홍보</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd71amt" name="plancd71amt" value="<c:out value="${fundVo.plancd71amt}"/>" style="width: 100%" maxlength="13" title="해외 홍보 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd72amt" name="plancd72amt" value="<c:out value="${fundVo.plancd62amt}"/>" style="width: 100%" maxlength="13" title="해외 홍보 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd7Nationitem" name="plancd7Nationitem" value="<c:out value="${fundVo.plancd7Nationitem}"/>" style="width: 100%" maxlength="13" title="해외 홍보 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >해외 시장조사</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd81amt" name="plancd81amt" value="<c:out value="${fundVo.plancd81amt}"/>" style="width: 100%" maxlength="13" title="해외 홍보 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd82amt" name="plancd82amt" value="<c:out value="${fundVo.plancd82amt}"/>" style="width: 100%" maxlength="13" title="해외 홍보 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd8Nationitem" name="plancd8Nationitem" value="<c:out value="${fundVo.plancd8Nationitem}"/>" style="width: 100%" maxlength="13" title="해외 홍보 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >기타</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd91amt" name="plancd91amt" value="<c:out value="${fundVo.plancd91amt}"/>" style="width: 100%" maxlength="13" title="기타 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="plancd92amt" name="plancd92amt" value="<c:out value="${fundVo.plancd92amt}"/>" style="width: 100%" maxlength="13" title="기타 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='planAmtSum(this)' />
			</td>
			<td >
				<input type="text" class="form_text " id="plancd9Nationitem" name="plancd9Nationitem" value="<c:out value="${fundVo.plancd9Nationitem}"/>" style="width: 100%" maxlength="13" title="기타 마케팅 활동 대상국가 및 품목"  />
			</td>
		</tr>

		<tr>
			<th >합계</th>
			<td align="right" >
				<input type="text" class="form_text align_r" id="sumPlancd1amt" name="sumPlancd1amt" value="<c:out value="${fundVo.sumPlancd1amt}"/>" style="width: 100%" maxlength="13" title="합계 예상소요금액 1년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<td align="right" >
				<input type="text" class="form_text align_r" id="sumPlancd2amt" name="sumPlancd2amt" value="<c:out value="${fundVo.sumPlancd2amt}"/>" style="width: 100%" maxlength="13" title="합계 예상소요금액 2년차"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)"  />
			</td>
			<td >
				<input type="text" class="form_text align_r" id="sumPlancdAllAmt" name="sumPlancdAllAmt" value="<c:out value="${fundVo.sumPlancdAllAmt}"/>" style="width: 100%" maxlength="13" title="전체 합계"  />
			</td>
		</tr>

</c:otherwise>	<%--  <c:when test='${yearChk eq "Y"}'>--%>
</c:choose>
<c:if test="${not empty fundVo.planDesc}" >
		<tr >
			<td colspan="<c:out value="${colspan}"/>">
			상기의 KITA무역진흥자금 (19)자금사용계획에 대해 구체적으로 기술하여 주시기 바랍니다. <span style="color:#006BFF">(최대입력은 A4용지 2/3 분량)</span>
			</td>
		</tr>
		<tr >
			<td colspan="<c:out value="${colspan}"/>">
				<textarea rows="18" class="form_textarea" id="planDesc" name="planDesc" title="자금사용계획내용" ><c:out value="${fundVo.planDesc}"/></textarea>
			</td>
		</tr>
</c:if>
	</table>
	<br/>

	<table class="formTable">
		<colgroup>
			<col width="90px">
			<col width="110px">
			<col width="110px">

			<col width="110px">
			<col width="110px">

			<col width="110px">
			<col width="110px">

			<col width="110px">
			<col width="*">
		</colgroup>

		<tr>
			<th rowspan="2" align="center" >※참고<br>(기융자)</th>
			<th >회원가입일</th>
			<td ><c:out value="${reg_date}"/>
			</td>
			<th >개업년원일</th>
			<td ><c:out value="${found_date}"/>
			</td>
			<th >기융자횟수</th>
			<td ><c:out value="${beforeCnt}"/>
			</td>
			<th >상환잔액</th>
			<td style="color:#ff0000;">
			<c:out value="${ret0010Vo.vfndBal}"/>
			</td>
		</tr>
		<tr>
			<td colspan="8" style="padding: 0; border: 0;">

				<table>
					<colgroup>
						<col width="*">
						<col width="120px">
						<col width="100px">
						<col width="120px">
						<col width="100px">
						<col width="120px">
					</colgroup>
					<tr>
						<th style="border: 0;">사업명</th>
						<th style="border-top: 0;">추천금액</th>
						<th style="border-top: 0;">1차융자일자</th>
						<th style="border-top: 0;">1차융자금액</th>
						<th style="border-top: 0;">2차융자일자</th>
						<th style="border-top: 0;">2차융자금액</th>
					</tr>
			<c:choose>
				<c:when test="${fn:length(beforeList) > 0}">

					<c:forEach var="before" items="${beforeList}" varStatus="status">
					<tr>
						<td>
							<c:out value="${before.title}"/>
						</td>
						<td >
							<c:out value="${before.recdAmount}"/>&nbsp;
						</td>
						<td>
							<c:choose>
								<c:when test='${before.recdDt eq ""}'>
									&nbsp;
								</c:when>
								<c:otherwise>
									<c:out value="${before.recdDt}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:if test='${before.defntAmount ne "0"}'>
								<c:out value="${before.defntAmount}"/>
							</c:if>	&nbsp;
						</td>
						<td style="text-align: center;">
							<c:choose>
								<c:when test='${before.recdDt2 eq ""}'>
									&nbsp;
								</c:when>
								<c:otherwise>
									<c:out value="${before.recdDt2}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:if test='${before.defntAmount2 ne "0"}'>
								<c:out value="${before.defntAmount2}"/>
							</c:if>	&nbsp;
						</td>
					</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>

					<tr>
						<td style="border-left: 0;">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</c:otherwise>
			</c:choose>
				</table>


			</td>
		</tr>
	</table>
	<c:if test='${validChk eq "Y"}'>
	<div class="tit_bar mt-10">
		<h3 class="tit_block"  style="color:red;">※ 유효기간이 지나지 않은 추천서가 있는 업체입니다.</h3>
	</div>


	<table class="formTable">
		<colgroup>
			<col width="90px">
			<col width="*">
		</colgroup>

		<tr>
			<th align="center" >※참고<br>(추천서)</th>
			<td style="padding: 0; border-right: 0;">
				<table >
					<colgroup>
						<col width="*">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
					</colgroup>

					<tr>
						<th style="border-top: 0;">사업명</th>
						<th style="border-top: 0;">은행명</th>
						<th style="border-top: 0;">추천금액</th>
						<th style="border-top: 0;">1차융자일자</th>
						<th style="border-top: 0;">1차융자금액</th>
						<th style="border-top: 0;">2차융자일자</th>
						<th style="border-top: 0;">2차융자금액</th>
					</tr>

			<c:choose>
				<c:when test="${fn:length(validList) > 0}">
					<c:forEach var="valid" items="${validList}" varStatus="status">
					<tr>
						<td style="border: 0;">
							<c:out value="${valid.title}"/>
						</td>
						<td style="text-align: left; border-bottom: 0px;">
							<c:out value="${valid.mainBankNm}"/>
						</td>
						<td style="text-align: right; border-bottom: 0px;">
							<c:out value="${valid.recdAmount}"/>
						</td>
						<td style="text-align: center; border-bottom: 0px;">
							<c:choose>
								<c:when test='${valid.recdDt eq ""}'>
									&nbsp;
								</c:when>
								<c:otherwise>
									<c:out value="${valid.recdDt}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right; border-bottom: 0px;">
							<c:if test='${valid.defntAmount eq "0"}'>
								<c:out value="${valid.defntAmount}"/>
							</c:if>	&nbsp;
						</td>
						<td style="text-align: center; border-bottom: 0px;">
							<c:choose>
								<c:when test='${valid.recdDt2 eq ""}'>
									&nbsp;
								</c:when>
								<c:otherwise>
									<c:out value="${valid.recdDt2}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right; border-bottom: 0px;">
							<c:if test='${valid.defntAmount2 eq "0"}'>
								<c:out value="${valid.defntAmount2}"/>
							</c:if>	&nbsp;
						</td>
					</tr>
					</c:forEach>


				</c:when>	<%-- 				<c:when test="${fn:length(validList) > 0}"> --%>
				<c:otherwise>
					<tr>
						<td style="border-left: 0; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: left; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: right; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: center; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: right; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: center; border-bottom: 0;">&nbsp;</td>
						<td style="text-align: right; border-bottom: 0;">&nbsp;</td>
					</tr>
					</c:otherwise>
					</c:choose>	<%-- 				<c:when test="${fn:length(validList) > 0}"> --%>
				</table>
			</td>
		</tr>
	</table>

	</c:if>	<%-- 	<c:if test='${validChk eq "Y"}'> --%>




	<div class="tit_bar mt-20">
		<h3 class="tit_block">항목별 평가</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col width="120px">
			<col width="150px">
			<col width="200px">
			<col width="80px">
			<col width="130px">
			<col width="60px">
			<col width="130px">
			<col width="60px">
			<col width="*">
		</colgroup>

		<tr>
			<th align="center" rowspan="2">구분</th>
			<th align="center" rowspan="2">심사항목</th>
			<th align="center" rowspan="2">심사세부항목</th>
			<th align="center" rowspan="2">최대점수</th>
			<th align="center" colspan="4">평점</th>
			<th align="center" rowspan="2">메모 및 평점 변경 사유</th>
		</tr>
		<tr>
			<th align="center" colspan="2">평점(신청기준)</th>
			<th align="center" colspan="2">평점(협회인정)</th>
		</tr>
		<!-- CALRATING_ROW -->

	<c:set var="pri_nm_chk" 		value="" />
	<c:set var="pri_gbn_nm_chk" 	value="" />
	<c:set var="score_type_nm_chk" 	value="" />

	<c:forEach var="calrating" items="${calratingList}" varStatus="listStatus">
		<c:set var="pri_nm_chk" 		value="N" />
		<c:set var="pri_gbn_nm_chk" 	value="N" />
		<c:set var="score_type_nm_chk" 	value="N" />


<c:if test='${listStatus.last eq false }'>


		<c:if test='${listStatus.index > 0 and calrating.priNm eq calratingList[listStatus.index-1].priNm}'>
			<c:set var="pri_nm_chk" 		value="Y" />
		</c:if>
		<c:if test='${listStatus.index > 0 and calrating.priGbnNm eq calratingList[listStatus.index-1].priGbnNm}'>
			<c:set var="pri_gbn_nm_chk" 		value="Y" />
		</c:if>
		<c:if test='${listStatus.index > 0 and calrating.scoreTypeNm eq calratingList[listStatus.index-1].scoreTypeNm}'>
			<c:set var="score_type_nm_chk" 		value="Y" />
		</c:if>
		<tr >
			<td style="display:none;">

				<input type="hidden" id="priGbn" 			name="priGbn" 				value="<c:out value="${calrating.priGbn}"/>"/>
				<input type="hidden" id="scoreType" 		name="scoreType" 			value="<c:out value="${calrating.scoreType}"/>"/>
				<input type="hidden" id="pointCompCodeval" 	name="pointCompCodeval" 	value="<c:out value="${calrating.pointCompCodeval}"/>"/>
				<input type="hidden" id="pointKitaCodeval" 	name="pointKitaCodeval" 	value="<c:out value="${calrating.pointKitaCodeval}"/>"/>
			</td>

		<c:if test='${pri_nm_chk eq "N"}'>
			<th align="center"  rowspan="<c:out value="${calrating.priNmCnt}"/>">
				<c:out value="${calrating.priNm}"/>
			</th>
		</c:if>
		<c:if test='${pri_gbn_nm_chk eq "N"}'>
			<th align="left"  rowspan="<c:out value="${calrating.priGbnNmCnt}"/>">
				<c:out value="${calrating.priGbnNm}"/>
			</th>
		</c:if>
		<c:if test='${score_type_nm_chk eq "N"}'>
			<th align="left"  rowspan="<c:out value="${calrating.scoreTypeNmCnt}"/>">
				<c:out value="${calrating.scoreTypeNm}"/>
			</th>
		</c:if>

			<td align="center" ><c:out value="${calrating.maxScore}"/></td>
			<td align="center" >
			<c:choose>
				<c:when test='${calrating.scoreType eq "351010"}'>
						<select id="pointCompSelect" name="pointCompSelect" class="form_select" disabled="disabled" >
							<c:forEach var="item" items="${JCS001_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointCompCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "353020"}'>
						<select id="pointCompSelect" name="pointCompSelect" class="form_select" disabled="disabled" >
							<c:forEach var="item" items="${JCS002_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointCompCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "901010"}'>
						<select id="pointCompSelect" name="pointCompSelect" class="form_select" disabled="disabled" >
							<c:forEach var="item" items="${JCS004_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointCompCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "204010"}'>
						<select id="pointCompSelect" name="pointCompSelect" class="form_select" disabled="disabled" >
							<c:forEach var="item" items="${JCS004_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointCompCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>

				<c:otherwise>
						<select id="pointCompSelect" name="pointCompSelect" class="form_select" disabled="disabled" >
							<c:forEach var="item" items="${score}" varStatus="status">
								<c:if test='${calrating.scoreType eq item.scoreType}'>
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.basisScore eq calrating.pointComp}">selected="selected"</c:if>><c:out value="${item.basisScoreRan}"/></option>
								</c:if>
							</c:forEach>
						</select>

				</c:otherwise>
			</c:choose>
			</td>

			<td align="center" >
				<input type="text" class="form_text align_r" id="pointComp" name="pointComp" value="<c:out value="${calrating.pointComp}"/>" style="width: 100%" maxlength="30" title=""  readonly="readonly" />
			</td>

			<td align="center" >
			<c:choose>
				<c:when test='${calrating.scoreType eq "351010"}'>
						<select id="pointKitaSelect" name="pointKitaSelect" class="form_select" onchange='javascript:doChangePoint(this, <c:out value="${listStatus.index}"/>)' >
							<c:forEach var="item" items="${JCS001_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.basisScore eq calrating.pointKitaCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "353020"}'>
						<select id="pointKitaSelect" name="pointKitaSelect" class="form_select" onchange='javascript:doChangePoint(this, <c:out value="${listStatus.index}"/>)' >
							<c:forEach var="item" items="${JCS002_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointKitaCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "901010"}'>
						<select id="pointKitaSelect" name="pointKitaSelect" class="form_select" onchange='javascript:doChangePoint(this, <c:out value="${listStatus.index}"/>)' >
							<c:forEach var="item" items="${JCS004_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointKitaCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>
				<c:when test='${calrating.scoreType eq "204010"}'>
						<select id="pointKitaSelect" name="pointKitaSelect" class="form_select" onchange='javascript:doChangePoint(this, <c:out value="${listStatus.index}"/>)' >
							<c:forEach var="item" items="${JCS004_T2}" varStatus="status">
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.detailcd eq calrating.pointKitaCodeval}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
				</c:when>

				<c:otherwise>
						<select id="pointKitaSelect" name="pointKitaSelect" class="form_select" onchange='javascript:doChangePoint(this, <c:out value="${listStatus.index}"/>)'>
							<c:forEach var="item" items="${score}" varStatus="status">

								<c:if test='${calrating.scoreType eq item.scoreType}'>
								<option value="<c:out value="${item.basisScore}"/>" <c:if test="${item.basisScore eq calrating.pointKita}">selected="selected"</c:if>><c:out value="${item.basisScoreRan}"/></option>
								</c:if>
							</c:forEach>
						</select>

				</c:otherwise>
			</c:choose>
			</td>

			<td align="center" >
				<input type="text" class="form_text align_r" id="pointKita" name="pointKita" value="<c:out value="${calrating.pointKita}"/>" style="width: 100%" maxlength="30" title=""  readonly="readonly" />
			</td>
			<td align="center" >
				<input type="text" class="form_text " id="resnMemo" name="resnMemo" value="<c:out value="${calrating.resnMemo}"/>" style="width: 100%" maxlength="1000" title=""  />
			</td>
		</tr>

</c:if>

<c:if test='${listStatus.last eq true }'>
		<tr>
			<th align="center"  rowspan="4">
				<input type="hidden" id="priGbn" 			name="priGbn" 			value="<c:out value="${calrating.priGbn}"/>" />
				<input type="hidden" id="scoreType" 		name="scoreType" 		value="<c:out value="${calrating.scoreType}"/>" />
				<input type="hidden" id="pointKitaSelect" 	name="pointKitaSelect" 	value="0" />
			종합평가
			</th>
			<th align="left"  rowspan="4">종합평가</th>
			<th align="left" >참고사항(신용등급)</th>
			<td align="left" colspan="5">
				<c:if test="${not empty fundVo.coCrdtRt}" >
					<c:out value="${fundVo.coCrdtRt}"/> (기준: <c:out value="${fundVo.coCrdtRtStdYear}"/>년)
				</c:if>
			</td>
			<td></td>
		</tr>
		<tr>
			<th align="left" >지부장 점수</th>
			<td align="center" ><c:out value="${calrating.maxScore}"/></td>
			<td align="left"  colspan="4">
				<input type="hidden" name="pointComp" id="pointComp"  value="<c:out value="${calrating.pointComp}"/>"/>
				<input type="text" class="form_text " id="pointKita" name="pointKita" value="<c:out value="${calrating.pointKita}"/>" style="width: 100%; text-align : right;" maxlength="2" title=""
				 onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onBlur="doSum('JIBU', this)" />

			</td>
			<td align="left" ></td>
		</tr>
	 	<tr>
			<th align="left" rowspan="2">지부장 의견</th>
			<td  colspan="6">
				<label for="chkYn1"><input type="checkbox" class="form_checkBox" name="chkYn1" id="chkYn1" value="<c:out value="${fundVo.chkYn1 eq 'Y' ? 'Y' : 'N'}" />" <c:if test="${fundVo.chkYn1 eq 'Y'}" >checked</c:if> /> 수출용 원자재 및 완제품 구매자금 지원</label>
				<br/>
				<label for="chkYn2"><input type="checkbox" class="form_checkBox" name="chkYn2" id="chkYn2" value="<c:out value="${fundVo.chkYn2 eq 'Y' ? 'Y' : 'N'}" />" <c:if test="${fundVo.chkYn2 eq 'Y'}" >checked</c:if> /> 해외 마케팅 비용 지원</label>
				<br/>
				<label for="chkYn3"><input type="checkbox" class="form_checkBox" name="chkYn3" id="chkYn3" value="<c:out value="${fundVo.chkYn3 eq 'Y' ? 'Y' : 'N'}" />" <c:if test="${fundVo.chkYn3 eq 'Y'}" >checked</c:if> /> 국내외 전시/박람회 참가 및 바이어 초청 비용 지원</label>
			</td>

		</tr>
		<tr>
			<td colspan="6">
				<textarea rows="3" class="form_textarea" id="resnMemo" name="resnMemo" title="지부장 의견" onKeyUp="textareachk(this)" ><c:out value="${calrating.resnMemo}"/></textarea>
			</td>
		</tr>
		<tr>
			<th align="center"  colspan="3">총점</th>
			<td align="center" ><c:out value="${calrating.maxScoreSum}"/></td>
			<td align="left"  colspan="2">
				<input type="text" class="form_text align_r" id="pointCompSum" name="pointCompSum" value="<c:out value="${calrating.pointCompSum}"/>" style="width: 100%" maxlength="3" title="" readonly="readonly"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<td align="left"  colspan="2">
				<input type="text" class="form_text align_r" id="pointKitaSum" name="pointKitaSum" value="<c:out value="${calrating.pointKitaSum}"/>" style="width: 100%" maxlength="3" title="" readonly="readonly"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<td align="left" ></td>
		</tr>
</c:if>
		</c:forEach>
	 </table>


	<div class="tit_bar mt-20">
		<h3 class="tit_block">
		선정 &nbsp;
		<c:if test='${feeCheckVo > 0 }'>
			<span style="color:red;">(회비 : <c:out value="${feeCheckVo}"/>년 미납 업체)</span>
		</c:if>
		<span id="chk_tem_million" style="color:red; display:none;">(<c:out value="${yearVo.oneYear}"/>년 직수출 이천만불 이상업체)</span>
		</h3>
	</div>
	<table class="formTable">
		<colgroup>
			<col width="100px">
			<col width="215px">
			<col width="100px">
			<col width="150px">
			<col width="100px">
			<col width="150px">
			<col width="100px">
			<col width="*">
		</colgroup>

		<tr >
			<th align="center" >확인일자</th>
			<td align="left" >
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="fixedDate" name="fixedDate" class="txt datepicker-compare" placeholder="접수기간 시작" title="접수기간 시작" readonly="readonly"  value="<c:out value="${fundVo.fixedDate}"/>"  />
						<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" />
						<input type="hidden" id="dummyStartDate" value="" />
					</span>
				</div>
			</td>
			<th align="center" >선정여부</th>
			<td align="center" >
				<select id="st" name="st" class="form_select"  >
					<c:forEach var="item" items="${LMS003}" varStatus="status">
						<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq fundVo.st}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
					</c:forEach>
				</select>
			</td>
			<th align="center" >추천금액</th>
			<td align="center" >
				<input type="text" class="form_text align_r" id="recdAmount" name="recdAmount" value="<c:out value="${fundVo.recdAmount}"/>" style="width: 100%" maxlength="30" title=""
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<th align="center" >선정자</th>
			<td align="center" >
				<c:out value="${fundVo.fixedWorkerNm}"/>  <fmt:formatDate value="${fundVo.fixedWorkdate}" pattern="yyyy-MM-dd HH:mm"/>
			</td>
		</tr>

		<c:set var="defnt_chk" value="Y" />
			<c:if test='${fundVo.defntAmount > 0 or fundVo.defntAmount2 > 0 or fundVo.defntAmount3 > 0 }'>
				<c:set var="defnt_chk" value="N" />
			</c:if>


		<c:if test='${fundVo.st eq "03" or fundVo.st eq "05" and defnt_chk eq "Y" }'>

		<tr >
			<th align="center" >포기사유</th>
			<td align="left"  colspan="4">
				<input type="text" class="form_text " id="cancelMsg" name="cancelMsg" value="<c:out value="${fundVo.cancelMsg}"/>" style="width: 100%" maxlength="101" title="포기사유" />
			</td>
			<td align="center" >
				<c:if test='${fundVo.st ne "05" }'>
					<button type="button" class="btn_tbl btn_modify_auth" onclick="doSaveCancel();">포기처리</button>
				</c:if>
			</td>
			<th align="center" >취소담당자</th>
			<td align="center" >
				<c:out value="${fundVo.cancelUserNm}"/>  <fmt:formatDate value="${fundVo.cancelDate}" pattern="yyyy-MM-dd HH:mm"/>
			</td>
		</tr>

		</c:if>
	</table>
</div>


<div style="display:none;">
	<table>
		<tr height="25" >
			<td class="search_table_title" style="padding-left: 5px;">직수출누락분(B)</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">US$ &nbsp;
				<input type="text" class="form_text align_r" id="omisExpAmount2" name="omisExpAmount2" value="<c:out value="${fundVo.omisExpAmount2}"/>" style="width: 100%" maxlength="13" title="2년전직수출누락분"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
			</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">US$ &nbsp;
				<input type="text" class="form_text align_r" id="omisExpAmount1" name="omisExpAmount1" value="<c:out value="${fundVo.omisExpAmount1}"/>" style="width: 100%" maxlength="13" title="1년전직수출누락분"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" onchange='expSum()' />
			</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">
				<input type="text" class="form_text align_r" id="omisExpRate" name="omisExpRate" value="<c:out value="${fundVo.omisExpRate}"/>" style="width: 100%" maxlength="20" title="직수출누락분증가율"
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /> %
			</td>
		</tr>
		<tr height="25">
			<td class="search_table_title" style="padding-left: 5px;">일본 직수출(D)</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">US$ &nbsp;
				<input type="text" class="form_text align_r" id="japExpAmount2" name="japExpAmount2" value="<c:out value="${fundVo.japExpAmount2}"/>" style="width: 100%" maxlength="20" title=""
				onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">US$ &nbsp;
			<input type="text" class="form_text align_r" id="japExpAmount1" name="japExpAmount1" value="<c:out value="${fundVo.japExpAmount1}"/>" style="width: 100%" maxlength="20" title=""
			onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
			</td>
			<td class="search_table_data" align="right" style="padding-left: 3px; padding-right:3px">
			<input type="text" class="form_text align_r" id="japExpRate" name="japExpRate" value="<c:out value="${fundVo.japExpRate}"/>" style="width: 100%" maxlength="20" title=""
			onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" /> %
			</td>
		</tr>
	</table>
</div>


<div class="cont_block mt-20">
	<div class="tit_bar">
		<h3 class="tit_block">과거신청이력</h3>
	</div>

	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
</div>

</form>


<script type="text/javascript">
	$(document).ready(function(){
		setExpPhoneNumber(['#membHp', '#membTel', '#membFax'], 'W');

		$('input:checkbox[name=mortgage]').click(function(){
			var checked = $(this).is(':checked');
			var checkVal = $(this).val();
			var checkId = $(this).attr('id');

			if(!checked){
				$("#mortgageAmount"+checkVal).val("0");
			}
		});

		expSum();
		speSum();
		doColorChange();
		stCheck();
		spePlanAmtSum();
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",            Type:"Seq",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"no"             });
		ibHeader.addHeader({Header:"기금융자코드",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"svrId",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수번호",        	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"applyId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업번호",     	Type:"Text",      Hidden:true,   Width:90,   Align:"Center",  SaveName:"bsNo",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"기금융자명",      	Type:"Text",      Hidden:false,  Width:260,  Align:"Left",    SaveName:"title",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"신청일자",        	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"creDate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"자금신청액",      	Type:"AutoSum",   Hidden:false,  Width:100,  Align:"Right",   SaveName:"necessAmount", CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"기융자금액",    	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   SaveName:"loanSum",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"평점\n(신청)",    	Type:"Int",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"pointComp",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"평점\n(협회)",    	Type:"Int",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"pointKita",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"결과",           	Type:"Combo",     Hidden:false,  Width:70,   Align:"Center",  SaveName:"st",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , ComboCode: "<c:out value="${saLMS003.detailcd}"/>", ComboText: "<c:out value="${saLMS003.detailnm}"/>" });
		ibHeader.addHeader({Header:"추천서",        	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"recoSendYn",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"특별융자 여부",     Type:"Text",      Hidden:true,   Width:90,   Align:"Center",  SaveName:"speChk",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 });
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);

		sheet1.SetColFontBold("title", true);
		sheet1.SetDataLinkMouse("title", true);
	}



	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationSpeSelectionHistoryList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
// 				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				if ( data.resultCnt > 0 ){
					$(".cont_block mt-20").show();
				}else{
					$(".cont_block mt-20").hide();
				}
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}


	function doList(){
	    var f = document.form1;

// 		var url = f.listPage.value;
		var url = '';
		if($('#gubun').val() == 'selection') {
			url = '/tfms/ssm/applicationSpeSelectionList.do';
		}
		if($('#gubun').val() == 'appl') {
			url = '/tfms/ssm/applicationSpeList.do';
		}

		f.action = url;
		f.target = "_self";
		f.method = "post";
		f.submit();

	}


	/* 신청 화면 스크립트  시작------*/
	function expAmountIncrease(){

		var f = document.form1;

		var v_EXP_AMOUNT_1 = "";
		var v_EXP_AMOUNT_2 = "";
		var v_EXP_RATE = "";

		if(f.expAmount1.value=="") f.expAmount1.value = 0;
		if(f.expAmount2.value=="") f.expAmount2.value = 0;


		v_EXP_AMOUNT_1 = parseFloat(f.expAmount1.value.replace(/,/gi ,""));
		v_EXP_AMOUNT_2 = parseFloat(f.expAmount2.value.replace(/,/gi ,""));


		if(f.expAmount2.value == 0) {
			v_EXP_RATE = 0;
		}else{
			v_EXP_RATE = ((v_EXP_AMOUNT_1 - v_EXP_AMOUNT_2) / v_EXP_AMOUNT_2) * 100;
		}


		f.expAmount1.value = plusComma(v_EXP_AMOUNT_1);
		f.expAmount2.value = plusComma(v_EXP_AMOUNT_2);
		f.expRate.value = plusComma(Math.floor(v_EXP_RATE));


	}


	function omisExpAmountIncrease(){

		var f = document.form1;

		var v_OMIS_EXP_AMOUNT_1 = "";
		var v_OMIS_EXP_AMOUNT_2 = "";
		var v_OMIS_EXP_RATE = "";

		if(f.omisExpAmount1.value=="") f.omisExpAmount1.value = 0;
		if(f.omisExpAmount2.value=="") f.omisExpAmount2.value = 0;

		v_OMIS_EXP_AMOUNT_1 = parseFloat(f.omisExpAmount1.value.replace(/,/gi ,""));
		v_OMIS_EXP_AMOUNT_2 = parseFloat(f.omisExpAmount2.value.replace(/,/gi ,""));

		if(f.omisExpAmount2.value == 0) {
			v_OMIS_EXP_RATE = 0;
		}else{
			//v_OMIS_EXP_RATE = ((v_OMIS_EXP_AMOUNT_1 - v_OMIS_EXP_AMOUNT_2) / v_OMIS_EXP_AMOUNT_2) * 100;
			v_OMIS_EXP_RATE = (100/v_OMIS_EXP_AMOUNT_2)*(v_OMIS_EXP_AMOUNT_1 - v_OMIS_EXP_AMOUNT_2) ;
		}

		f.omisExpAmount1.value = plusComma(v_OMIS_EXP_AMOUNT_1);
		f.omisExpAmount2.value = plusComma(v_OMIS_EXP_AMOUNT_2);
		f.omisExpRate.value = plusComma(Math.floor(v_OMIS_EXP_RATE));

	}

	function etcExpAmountIncrease(){

		var f = document.form1;

		var v_ETC_EXP_AMOUNT_1 = "";
		var v_ETC_EXP_AMOUNT_2 = "";
		var v_ETC_EXP_RATE = "";

		if(f.etcExpAmount1.value=="") f.etcExpAmount1.value = 0;
		if(f.etcExpAmount2.value=="") f.etcExpAmount2.value = 0;


		v_ETC_EXP_AMOUNT_1 = parseFloat(f.etcExpAmount1.value.replace(/,/gi ,""));
		v_ETC_EXP_AMOUNT_2 = parseFloat(f.etcExpAmount2.value.replace(/,/gi ,""));


		if(f.etcExpAmount2.value == 0) {
			v_ETC_EXP_RATE = 0;
		}else{
			v_ETC_EXP_RATE = ((v_ETC_EXP_AMOUNT_1 - v_ETC_EXP_AMOUNT_2) / v_ETC_EXP_AMOUNT_2) * 100;
		}

		f.etcExpAmount1.value = plusComma(v_ETC_EXP_AMOUNT_1);
		f.etcExpAmount2.value = plusComma(v_ETC_EXP_AMOUNT_2);
		f.etcExpRate.value = plusComma(Math.floor(v_ETC_EXP_RATE));

	}

	function japExpAmountIncrease(){

		var f = document.form1;

		var v_JAP_EXP_AMOUNT_1 = "";
		var v_JAP_EXP_AMOUNT_2 = "";
		var v_JAP_EXP_RATE = "";

		if(f.japExpAmount1.value=="") f.japExpAmount1.value = 0;
		if(f.japExpAmount2.value=="") f.japExpAmount2.value = 0;


		v_JAP_EXP_AMOUNT_1 = parseFloat(f.japExpAmount1.value.replace(/,/gi ,""));
		v_JAP_EXP_AMOUNT_2 = parseFloat(f.japExpAmount2.value.replace(/,/gi ,""));


		if(f.japExpAmount2.value == 0) {
			v_JAP_EXP_RATE = 0;
		}else{
			v_JAP_EXP_RATE = ((v_JAP_EXP_AMOUNT_1 - v_JAP_EXP_AMOUNT_2) / v_JAP_EXP_AMOUNT_2) * 100;
		}


		f.japExpAmount1.value = plusComma(v_JAP_EXP_AMOUNT_1);
		f.japExpAmount2.value = plusComma(v_JAP_EXP_AMOUNT_2);
		f.japExpRate.value = plusComma(Math.floor(v_JAP_EXP_RATE));

	}

	function expSum(){

		var f = document.form1;

		expAmountIncrease();
		omisExpAmountIncrease();
		etcExpAmountIncrease();
		japExpAmountIncrease();

		var v_SUM_EXP_AMOUNT_1 = parseFloat(f.expAmount1.value.replace(/,/gi ,""))
								+ parseFloat(f.omisExpAmount1.value.replace(/,/gi ,""))
								+ parseFloat(f.etcExpAmount1.value.replace(/,/gi ,""));
								//+ parseFloat(f.JAP_EXP_AMOUNT_1.value.replace(/,/gi ,""));

		var v_SUM_EXP_AMOUNT_2 = parseFloat(f.expAmount2.value.replace(/,/gi ,""))
								+ parseFloat(f.omisExpAmount2.value.replace(/,/gi ,""))
								+ parseFloat(f.etcExpAmount2.value.replace(/,/gi ,""));
								//+ parseFloat(f.JAP_EXP_AMOUNT_2.value.replace(/,/gi ,""));

		var v_EXP_INCRS_RATE = 0;

		if(f.sumExpAmount2.value == 0){

			v_EXP_INCRS_RATE = 0;

		}else{

			v_EXP_INCRS_RATE = ((v_SUM_EXP_AMOUNT_1 - v_SUM_EXP_AMOUNT_2) / v_SUM_EXP_AMOUNT_2) * 100;

		}


		f.sumExpAmount1.value = plusComma(v_SUM_EXP_AMOUNT_1);
		f.sumExpAmount2.value = plusComma(v_SUM_EXP_AMOUNT_2);
		f.expIncrsRate.value = plusComma(Math.floor(v_EXP_INCRS_RATE));


		var v_ten_million = parseFloat(f.expAmount1.value.replace(/,/gi ,""))	+ parseFloat(f.omisExpAmount1.value.replace(/,/gi ,""));
		if(v_ten_million > 120000000){
			document.getElementById("chk_tem_million").style.display = "";
		}else{
			document.getElementById("chk_tem_million").style.display = "none";
		}
	}

	function planAmtSum(val){


		var f = document.form1;

		if(f.plancd11amt.value == "") f.plancd11amt.value = 0;
		if(f.plancd12amt.value == "") f.plancd12amt.value = 0;

		if(f.plancd21amt.value == "") f.plancd21amt.value = 0;
		if(f.plancd22amt.value == "") f.plancd22amt.value = 0;

		if(f.plancd31amt.value == "") f.plancd31amt.value = 0;
		if(f.plancd32amt.value == "") f.plancd32amt.value = 0;

		if(f.plancd41amt.value == "") f.plancd41amt.value = 0;
		if(f.plancd42amt.value == "") f.plancd42amt.value = 0;

		if(f.plancd51amt.value == "") f.plancd51amt.value = 0;
		if(f.plancd52amt.value == "") f.plancd52amt.value = 0;

		if(f.plancd61amt.value == "") f.plancd61amt.value = 0;
		if(f.plancd62amt.value == "") f.plancd62amt.value = 0;

		if(f.plancd71amt.value == "") f.plancd71amt.value = 0;
		if(f.plancd72amt.value == "") f.plancd72amt.value = 0;

		if(f.plancd81amt.value == "") f.plancd81amt.value = 0;
		if(f.plancd82amt.value == "") f.plancd82amt.value = 0;

		if(f.plancd91amt.value == "") f.plancd91amt.value = 0;
		if(f.plancd92amt.value == "") f.plancd92amt.value = 0;

		if(f.plancd101amt.value == "") f.plancd101amt.value = 0;
		if(f.plancd102amt.value == "") f.plancd102amt.value = 0;

		if(f.plancd111amt.value == "") f.plancd111amt.value = 0;
		if(f.plancd112amt.value == "") f.plancd112amt.value = 0;


		f.sumPlancd1amt.value = plusComma(parseFloat(f.plancd11amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd21amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd31amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd41amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd51amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd61amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd71amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd81amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd101amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd111amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd91amt.value.replace(/,/gi, "")));

		f.sumPlancd2amt.value = plusComma(parseFloat(f.plancd12amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd22amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd32amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd42amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd52amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd62amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd72amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd82amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd102amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd112amt.value.replace(/,/gi, ""))
								+ parseFloat(f.plancd92amt.value.replace(/,/gi, "")));

		val.value = plusComma(val.value);


	}


	//우편번호 팝업
	function zipCodeListPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/zipCodePopup.do" />'
			, callbackFunction : function(resultObj){
				$("input[name=coZipCd]").val(resultObj.zipNo);
				$("input[name=coAddr1]").val(resultObj.roadAddrPart1);
				$("input[name=coAddr2]").val(resultObj.roadAddrPart2);
			}
		});
	}

	function indsPropRadio(val){
		if(val == "none"){
			document.getElementById("indsPropCnt").value = "";
			document.getElementById("indsPropCnt").readOnly = true;
			document.getElementById("indsPropCnt").style.backgroundColor = "#DEDEDE";
		}else{
			document.getElementById("indsPropCnt").readOnly = false;
			document.getElementById("indsPropCnt").style.backgroundColor = "#ffffff";
		}
	}

	//신청서 인쇄
	function doPrint(){
		var profile = '<c:out value="${profile}"/>';
		var svrId = $("#svrId").val();
		var applyId = $("#applyId").val();
		var bsNo = $("#bsNo").val();
		var left, top, nWidth, nHeight, url ,strUrl ;

		if ( svrId != "" && applyId !="" && bsNo !=""  ){
			nWidth = 780;
			nHeight = 550;
			left = ((screen.width - nWidth) / 2);
			top = ((screen.height - nHeight) / 2);

			if ( profile == "local" || profile == "dev"    ){
				strUrl = "https://devmembership.kita.net/fai/fund/popup/fundInquirySpePrint.do?";
			}else{
				strUrl = "https://membership.kita.net/fai/fund/popup/fundInquirySpePrint.do?";
			}

			strUrl +=	 "svr_id="+svrId;
			strUrl +=	 "&apply_id="+applyId;
			strUrl +=	 "&bs_no="+bsNo;
			strUrl +=	 "&bs_no_force="+bsNo;
			window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');
		}else{
			return false;
		}

/* 		var f = document.form1;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfas/popup/fundInquirySpePrintPopup.do" />'		///tfas/popup/FundInquiryPrintPopup.screen
			, params : {
				 svrId 	 : f.svrId.value
			   , applyId : f.applyId.value
			   , bsNo 	 : f.bsNo.value
			}
			, callbackFunction : function(resultObj){
			}
		}); */
	}

	//사업계획서 조회
	function businessPlanPopup() {

		var f = document.form1;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfas/popup/fundBusinessPlanPopup.do" />'		///tfas/popup/FundInquiryPrintPopup.screen
			, params : {
				 svrId 	 : f.svrId.value
			   , applyId : f.applyId.value
			   , fileId 	 : f.fileId.value
			   , isDisplay 	 : 'P'
			}
			, callbackFunction : function(resultObj){
			}
		});

	}

	function tecnlgCheck(val){
		var f = document.form1;
		if(val == "none"){
			document.getElementById("tecnlg").checked = false;
			document.getElementById("tecnlg2").checked = false;
			document.getElementById("tecnlg3").checked = false;
		}else{
			document.getElementById("tecnlg4").checked = false;
		}
	}

	/* 신청 화면 스크립트  끝-------*/

	/* ===== 점수 계산 ==========시작*/
	function doChangePoint(obj, i){
		var f = document.form1;

		f.pointKita[i].value = getSelectedValue(obj);

		doSum();
	}


	function doChangePoint2(obj, i){
		var f = document.form1;
		var s_code = getSelectedValue(obj);
		var key = '<c:out value="${saSCORE_ROW1.basisScore}"/>'.split("|");
		var value = '<c:out value="${saSCORE_ROW1.basisStart}"/>'.split("|");

		for(var row = 0; row< key.length; row++){
			if(s_code == value[row]){
				f.pointKita[i].value = key[row];
			}
		}
		doSum();
	}
	function doChangePoint3(obj, i){
		var f = document.form1;
		var s_code = getSelectedValue(obj);
		var key = '<c:out value="${saSCORE_ROW2.basisScore}"/>'.split("|");
		var value = '<c:out value="${saSCORE_ROW2.basisStart}"/>'.split("|");

		for(var row = 0; row< key.length; row++){
			if(s_code == value[row]){
				f.pointKita[i].value = key[row];
			}
		}
		doSum();
	}
	function doChangePoint4(obj, i){
		var f = document.form1;
		var s_code = getSelectedValue(obj);
		var key = '<c:out value="${saSCORE_ROW3.basisScore}"/>'.split("|");
		var value = '<c:out value="${saSCORE_ROW3.basisStart}"/>'.split("|");

		for(var row = 0; row< key.length; row++){
			if(s_code == value[row]){
				f.pointKita[i].value = key[row];
			}
		}
		doSum();
	}
	function doChangePoint5(obj, i){
		var f = document.form1;
		var s_code = getSelectedValue(obj);
		var key = '<c:out value="${saSCORE_ROW4.basisScore}"/>'.split("|");
		var value = '<c:out value="${saSCORE_ROW4.basisStart}"/>'.split("|");

		for(var row = 0; row< key.length; row++){
			if(s_code == value[row]){
				f.pointKita[i].value = key[row];
			}
		}
		doSum();
	}

	function doSum(jibu, obj){
		var f = document.form1;
		var sum_comp = 0;
		var sum_kita = 0;

		if(jibu == 'JIBU'){
			f.pointComp[f.pointComp.length-1].value = obj.value;
		}

		for(var i =0; i < f.pointKita.length; i++){
			sum_kita += parseFloat(f.pointKita[i].value);
		}
		for(var i =0; i < f.pointComp.length; i++){
			sum_comp += parseFloat(f.pointComp[i].value);
		}
		f.pointCompSum.value = sum_comp;// + parseFloat(f.POINT_KITA[f.POINT_COMP.length].value);
		f.pointKitaSum.value = sum_kita;
		doColorChange();
	}

	function doColorChange(){

		var f = document.form1;

		if ( $("#pointKita").val() == "" || $("#pointKita").val() == null ){
			return;
		}

		for(var i =0; i < f.pointKita.length -1 ; i++){
			/*자동계산 점수와 협회 인정분이 틀린경우 폰트 붉은 색으로 변경 POINT_COMP, POINT_KITA*/
			if(f.pointComp[i].value == f.pointKita[i].value){
				f.pointKita[i].style.color = "#595A5A";
			}else{
				f.pointKita[i].style.color = "#ff0000";
			}
		}

	}
	/* ===== 점수 계산 ==========끝*/

	function textareachk(obj){
	    if (window.event) {
	        key = window.event.keyCode;
	    } else if (e) {
	        key = e.which;
	    } else {
	        return true;
	    }
	    keychar = String.fromCharCode(key);
	    var textarea_length = doValidLength(obj.value);
	    //document.getElementById("textarea_cnt").value = textarea_length;

	    if(textarea_length > 1000){
	    	alert("1000 byte 이상 입력 하실수 없습니다.");
	    	obj.value = obj.value.substring(0,obj.value.length - 1);
	    	return false;
	    }
	    return true;
	}

	function doSave(){
		var f = document.form1;
		var feechk = '<c:out value="${feeCheckVo}"/>';

		var st_val = getSelectedValue(f.st);
		if(st_val == '03' && feechk > 0){
 			alert("무역협회 회비 미납 업체 입니다. 확인후 진행 바랍니다.");
 			return false;
		}

		var v_ten_million = parseFloat(f.expAmount1.value.replace(/,/gi ,""))	+ parseFloat(f.omisExpAmount1.value.replace(/,/gi ,""));
		if(st_val == '03' && v_ten_million > 120000000){
			alert("전년도 매출이 이천만불 초과 업체입니다. 확인후 진행 바랍니다.");
			return false;
		}


		if(!doValidFormRequired(f)){
			return;
		}

  		if(!validation_form1()){
			return;
		}


		var mortgageAmount = '';
		var totalAmt = 0 ;
		var errorAmtNm = '';
		$('input:checkbox[name=mortgage]:checked').each(function(index, element){
			var amtNm = 'mortgageAmount' + $(this).val();
			var amt = $('#'+amtNm).val().replace(/,/gi ,"");

			if( amt == '' || amt == '0'){
				errorAmtNm = amtNm;
				return false;
			}

			if( index != 0 ){
				mortgageAmount =  mortgageAmount + ',' ;
			}

			mortgageAmount = mortgageAmount + amt;
			totalAmt = totalAmt + parseInt(amt);
		})

		if( errorAmtNm != '' ){
			alert('담보종류 금액을 입력해주세요');
			$('#'+errorAmtNm).focus();
			return ;
		}


		var necessAmount = $("#necessAmount option:selected").val().replace(/,/gi ,"");
		if( totalAmt != necessAmount ){
			alert('자금신청액과 담보 금액이 동일하지 않습니다.');
			$('#necessAmount').focus();
			return false;
		}

		$('#mortgageAmountArr').val(mortgageAmount);

		if ( $('#chkYn1').is(':checked') == true ){
			$("#chkYn1").val("Y");
		}
		if ( $('#chkYn2').is(':checked') == true ){
			$("#chkYn2").val("Y");
		}
		if ( $('#chkYn3').is(':checked') == true ){
			$("#chkYn3").val("Y");
		}

		 global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationSpeSelectionSaveData.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장되었습니다.");
				goLocation();
			}
		});

	}

	//주소 수정
	function doSaveAddr(){
		var f = document.form1;

		if(!confirm("주소를 수정하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationSpeSelectionSaveDataAddr.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장되었습니다.");
			}
		});

	}

	function doSaveCancel(){
		var f = document.form1;

		if(!confirm("신청서를 포기 처리 하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationSpeSelectionSaveDataCancel.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장되었습니다.");
				goLocation();
			}
		});

	}


	function validation_form1(){
		var f = document.form1;
		/*협회인정분 수정 후 변경사유 기입 확인*/
		for(var i=0;i<f.pointCompSelect.length-1;i++){
			if(f.pointKitaSelect[i].value != f.pointCompSelect[i].value){
				if(f.resnMemo[i].value == ""){
					alert("평점(협회인정) 수정후 변경사유를 입력하셔야 합니다.\n확인후 진행 바랍니다.");
					f.resnMemo[i].focus();
					return false;
				}
				if(f.resnMemo[i].value.length < 3){
					alert("평점(협회인정) 수정사유는 3자 이상 입력하셔야합니다.");
					f.resnMemo[i].focus();
					return false;
				}
			}
		}
		/* 지부장 의견 확인 */
		var row_cnt = f.pointCompSelect.length;
		var peri_chk =  parseFloat(f.pointKita[row_cnt].value);
		if(peri_chk > 20){
			alert("지부장 최고 점수는 20점입니다. 확인후 진행 바랍니다.");
			f.pointKita[row_cnt].focus();
			return false;
		}
		if(peri_chk > 0 && f.resnMemo[row_cnt].value == ""){
			alert("지부장 의견을 입력 바랍니다.");
			f.resnMemo[row_cnt].focus();
			return false;
		}

		var RECD_AMOUNT = parseFloat(f.recdAmount.value.replace(/,/gi, ""));
		var NECESS_AMOUNT = parseFloat(f.necessAmount.value.replace(/,/gi, ""));

		/* if(RECD_AMOUNT <= 0){
			alert("추천금액이 0원 입니다. 확인후 진행바랍니다.");
			f.RECD_AMOUNT.focus();
			return false;
		} */

		if(RECD_AMOUNT>NECESS_AMOUNT){
			alert("추천금액이 자금신청액을 초과할수없습니다. 확인후 진행바랍니다.");
			f.recdAmount.focus();
			return false;
		}
		return true;
	}

	function stCheck(){
		var f = document.form1;
		var st_val = getSelectedValue(f.st);

		if(st_val == '03'){
			f.recdAmount.disabled  = false;
			f.recdAmount.value = '<c:out value="${fundVo.recdAmount}"/>';
		}else if(st_val == '01'){
			f.recdAmount.disabled  = false;
			f.recdAmount.value = '<c:out value="${fundVo.recdAmount}"/>';
		}else{
			f.recdAmount.disabled  = true;
			f.recdAmount.value = '';
		}
	}



	//수출실적 조회
	function getAmtCheck(){

		var f = document.form1;

		if(!confirm("수출실적을 다시 조회 하시겠습니까?")){
			return ;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfas/reg/fundInquiryCheckAmt.do" />'
			, data : { bsNo : $('#bsNo').val() }
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				if ( data.result != null ){
					f.expAmount2.value  = data.result.ppyear ;
					f.expAmount1.value  = data.result.pyear;
					f.japExpAmount2.value  = data.result.ppyearJp;
					f.japExpAmount1.value  = data.result.pyearJp;
					expSum();
					alert("수출실적을 다시 불러왔습니다.\n저장버튼을 눌러야 갱신됩니다.");
				}
			}
		});

	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);

	 	if( colNm == 'title' ){
	 		goApplicationSelect(Row);
	 	}

	}

	function goApplicationSelect(Row){

	    var f = document.form1;
	    f.svrId.value 		= sheet1.GetCellValue(Row, "svrId");
	    f.applyId.value 	= sheet1.GetCellValue(Row, "applyId");
	    f.bsNo.value 		= sheet1.GetCellValue(Row, "bsNo");

		var url = '<c:url value="/tfms/ssm/applicationSpeSelection.do" />';

		f.action = url;
		f.method = "post";
		f.target = "_blank";
		f.submit();
	}

	//신청업체선정 상세
	function goLocation(){
		var url = "/tfms/ssm/applicationSpeSelection.do";

		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","post");
		newForm.attr("action", url );
		newForm.attr("target","_self");
		newForm.append($('<input/>', {type: 'hidden', name: 'svrId', value: $("#svrId").val() }));
		newForm.append($('<input/>', {type: 'hidden', name: 'applyId', value: $("#applyId").val() }));
		newForm.append($('<input/>', {type: 'hidden', name: 'bsNo', value: $("#bsNo").val() }));
		newForm.appendTo('body');
		newForm.submit();
	}

   eval(function(p, a, c, k, e, r) { e = function(c) { return c.toString(a) }; if (!''.replace(/^/, String)) { while (c--) r[e(c)] = k[c] || e(c); k = [ function(e) { return r[e] } ]; e = function() { return '\\w+' }; c = 1 } ; while (c--) if (k[c]) p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c]); return p } ( '0 2="5";0 1=3 4(c,6);7 8(a){b 1.9(2,a)}', 13, 13, 'var|aesUtil|authKey|new|AesUtil|49304d395130556955796834586e784e516d315651673d3d|100|function|niceEncrypt|encrypt||return|128' .split('|'), 0, {}))

   function encrypt(brn) {
      if (brn == '') {
         alert('사업자 번호가 미존재 하여 나이스 기업 분석 보고서를 열람할 수 없습니다.');
      } else {
         var biz_ins_no = brn.replace(/-/g, '');

         // 암호화 사업자번호
         var e_bz_ins_no = niceEncrypt(biz_ins_no);
         window.open('http://www.creport.co.kr/nicednb/login/login.do?cmd=kitaLogin&id=kitadata&bz_ins_no=' + e_bz_ins_no);
      }
   }

	function doCreport(){
		encrypt($('#industryNo').val());
	}


	function spePlanAmtSum(val){

		var f = document.form1;

		if(f.spePlancd11amt.value == "") f.spePlancd11amt.value = 0;

		if(f.spePlancd21amt.value == "") f.spePlancd21amt.value = 0;

		if(f.spePlancd31amt.value == "") f.spePlancd31amt.value = 0;

		if(f.spePlancd41amt.value == "") f.spePlancd41amt.value = 0;

		if(f.spePlancd51amt.value == "") f.spePlancd51amt.value = 0;

		if(f.spePlancd61amt.value == "") f.spePlancd61amt.value = 0;

		f.spePlancd11amt.value = plusComma(parseFloat(f.spePlancd11amt.value.replace(/,/gi, "")));
		f.spePlancd21amt.value = plusComma(parseFloat(f.spePlancd21amt.value.replace(/,/gi, "")));
		f.spePlancd31amt.value = plusComma(parseFloat(f.spePlancd31amt.value.replace(/,/gi, "")));
		f.spePlancd41amt.value = plusComma(parseFloat(f.spePlancd41amt.value.replace(/,/gi, "")));
		f.spePlancd51amt.value = plusComma(parseFloat(f.spePlancd51amt.value.replace(/,/gi, "")));
		f.spePlancd61amt.value = plusComma(parseFloat(f.spePlancd61amt.value.replace(/,/gi, "")));


		f.speSumPlancd1amt.value = plusComma(parseFloat(f.spePlancd11amt.value.replace(/,/gi, ""))
								+ parseFloat(f.spePlancd21amt.value.replace(/,/gi, ""))
								+ parseFloat(f.spePlancd31amt.value.replace(/,/gi, ""))
								+ parseFloat(f.spePlancd41amt.value.replace(/,/gi, ""))
								+ parseFloat(f.spePlancd51amt.value.replace(/,/gi, ""))
								+ parseFloat(f.spePlancd61amt.value.replace(/,/gi, "")))
								;

		f.speSumPlancdAllAmt.value = f.speSumPlancd1amt.value;



	}


	function speSum(){

		var f = document.form1;

		speSeaIncrease();
		speAirIncrease();
		speEtcIncrease();


		var v_SPE_SUM_AMOUNT_1 = parseFloat(f.speSeaAmount1.value.replace(/,/gi ,""))
								+ parseFloat(f.speAirAmount1.value.replace(/,/gi ,""))
								+ parseFloat(f.speEtcAmount1.value.replace(/,/gi ,""));

		var v_SPE_SUM_AMOUNT_2 = parseFloat(f.speSeaAmount2.value.replace(/,/gi ,""))
								+ parseFloat(f.speAirAmount2.value.replace(/,/gi ,""))
								+ parseFloat(f.speEtcAmount2.value.replace(/,/gi ,""));

		var v_SPE_INCRS_RATE = 0;

		f.speSumAmount1.value = plusComma(v_SPE_SUM_AMOUNT_1);
		f.speSumAmount2.value = plusComma(v_SPE_SUM_AMOUNT_2);

		if(f.speSumAmount2.value == 0){
			if(f.speSumAmount1.value == 0){
				v_SPE_INCRS_RATE = 0;
			}else{
				v_SPE_INCRS_RATE = 100;
			}

		}else{

			v_SPE_INCRS_RATE = ((v_SPE_SUM_AMOUNT_1 - v_SPE_SUM_AMOUNT_2) / v_SPE_SUM_AMOUNT_2) * 100;

		}


		f.speIncrsRate.value = plusComma(Math.floor(v_SPE_INCRS_RATE));

	}

	function speSeaIncrease(){

		var f = document.form1;

		var v_SPE_SEA_AMOUNT_1 = "";
		var v_SPE_SEA_AMOUNT_2 = "";
		var v_SPE_SEA_RATE = "";

		if(f.speSeaAmount1.value=="") f.speSeaAmount1.value = 0;
		if(f.speSeaAmount2.value=="") f.speSeaAmount2.value = 0;


		v_SPE_SEA_AMOUNT_1 = parseFloat(f.speSeaAmount1.value.replace(/,/gi ,""));
		v_SPE_SEA_AMOUNT_2 = parseFloat(f.speSeaAmount2.value.replace(/,/gi ,""));


		f.speSeaAmount1.value = plusComma(v_SPE_SEA_AMOUNT_1);
		f.speSeaAmount2.value = plusComma(v_SPE_SEA_AMOUNT_2);

		if(f.speSeaAmount2.value == 0) {
			if(f.speSeaAmount1.value == 0) {
				v_SPE_SEA_RATE = 0;
			}else{
				v_SPE_SEA_RATE = 100;
			}
		}else{
			v_SPE_SEA_RATE = ((v_SPE_SEA_AMOUNT_1 - v_SPE_SEA_AMOUNT_2) / v_SPE_SEA_AMOUNT_2) * 100;
		}


		f.speSeaRate.value = plusComma(Math.floor(v_SPE_SEA_RATE));


	}

	function speAirIncrease(){

		var f = document.form1;

		var v_SPE_AIR_AMOUNT_1 = "";
		var v_SPE_AIR_AMOUNT_2 = "";
		var v_SPE_AIR_RATE = "";

		if(f.speAirAmount1.value=="") f.speAirAmount1.value = 0;
		if(f.speAirAmount2.value=="") f.speAirAmount2.value = 0;

		v_SPE_AIR_AMOUNT_1 = parseFloat(f.speAirAmount1.value.replace(/,/gi ,""));
		v_SPE_AIR_AMOUNT_2 = parseFloat(f.speAirAmount2.value.replace(/,/gi ,""));

		f.speAirAmount1.value = plusComma(v_SPE_AIR_AMOUNT_1);
		f.speAirAmount2.value = plusComma(v_SPE_AIR_AMOUNT_2);

		if(f.speAirAmount2.value == 0) {
			if(f.speAirAmount1.value == 0){
				v_SPE_AIR_RATE = 0;
			}else{
				v_SPE_AIR_RATE = 100;
			}
		}else{
			//v_OMIS_EXP_RATE = ((v_OMIS_EXP_AMOUNT_1 - v_OMIS_EXP_AMOUNT_2) / v_OMIS_EXP_AMOUNT_2) * 100;
			v_SPE_AIR_RATE = (100/v_SPE_AIR_AMOUNT_2)*(v_SPE_AIR_AMOUNT_1 - v_SPE_AIR_AMOUNT_2) ;
		}


		f.speAirRate.value = plusComma(Math.floor(v_SPE_AIR_RATE));

	}

	function speEtcIncrease(){

		var f = document.form1;

		var v_SPE_ETC_AMOUNT_1 = "";
		var v_SPE_ETC_AMOUNT_2 = "";
		var v_SPE_ETC_RATE = "";

		if(f.speEtcAmount1.value=="") f.speEtcAmount1.value = 0;
		if(f.speEtcAmount2.value=="") f.speEtcAmount2.value = 0;


		v_SPE_ETC_AMOUNT_1 = parseFloat(f.speEtcAmount1.value.replace(/,/gi ,""));
		v_SPE_ETC_AMOUNT_2 = parseFloat(f.speEtcAmount2.value.replace(/,/gi ,""));

		f.speEtcAmount1.value = plusComma(v_SPE_ETC_AMOUNT_1);
		f.speEtcAmount2.value = plusComma(v_SPE_ETC_AMOUNT_2);

		if(f.speEtcAmount2.value == 0) {
			if(f.speEtcAmount1.value == 0) {
				v_SPE_ETC_RATE = 0;
			}else{
				v_SPE_ETC_RATE = 100;
			}
		}else{
			v_SPE_ETC_RATE = ((v_SPE_ETC_AMOUNT_1 - v_SPE_ETC_AMOUNT_2) / v_SPE_ETC_AMOUNT_2) * 100;
		}

		f.speEtcRate.value = plusComma(Math.floor(v_SPE_ETC_RATE));

	}


</script>