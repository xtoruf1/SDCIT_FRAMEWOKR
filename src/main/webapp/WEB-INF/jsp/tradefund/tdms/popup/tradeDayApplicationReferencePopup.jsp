<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="referencePopupForm" name="referencePopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<input type="hidden" name="prvPriType" value="<c:out value="${param.prvPriType}" />" />
<input type="hidden" name="bsnAplEndDt" value="<c:out value="${param.bsnAplEndDt}" />" />
<input type="hidden" name="state" value="<c:out value="${empty param.state ? '01' : param.state}" />" />
<input type="hidden" name="editYn" value="<c:out value="${param.editYn}" />" />
<div style="width: 1000px;height: 750px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">공적조서</h2>
		<div class="ml-auto">
			<c:if test="${param.editYn ne 'N'}">
				<button type="button" onclick="doReferenceSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:if>
		</div>
		<div class="ml-15">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<c:choose>
			<c:when test="${param.priType eq 'S'}">
				<div class="flex">
					<h3>특수유공 추천자 설정</h3>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 10%;" />
							<col style="width: 10%;" />
							<col />
							<col style="width: 20%;" />
							<col />
						</colgroup>
						<tr>
							<th rowspan="2">추천</th>
							<th>추천기관</th>
							<td colspan="3">
								<span class="form_search" style="width: 38%;">
									<input type="text" id="spRecOrg" name="spRecOrg" value="<c:out value="${referenceUser.spRecOrg}" />" maxlength="30" class="form_text" style="width: 38%;" title="추천기관" readonly="readonly" />
									<button type="button" onclick="spRecOrgListPopup();" class="btn_icon btn_search" title="추천기관 검색"></button>
								</span>
								<select id="spRecOrgPopYn" name="spRecOrgPopYn" onchange="fnSpRecOrgPopYn(this);" class="form_select" style="width: 15%;">
									<option value="P" selected="selected">팝업입력</option>
									<option value="S">직접입력</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>추천부문</th>
							<td colspan="3">
								<select id="spRecKind" name="spRecKind" class="form_select" style="width: 47%;">
									<c:forEach var="item" items="${spe000}" varStatus="status">
										<option value="<c:out value="${item.detailcd}" />" <c:if test="${referenceUser.spRecKind eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th rowspan="4">추천담당자</th>
							<th>성명</th>
							<td colspan="3"><input type="text" id="spRecName" name="spRecName" value="<c:out value="${referenceUser.spRecName}" />" maxlength="100" class="form_text" style="width: 30%;" title="추천담당자 성명" /></td>
						</tr>
						<tr>
							<th>E-Mail</th>
							<td colspan="3">
								<fieldset class="widget">
									<input type="text" id="spRecEmail1" name="spRecEmail1" value="<c:out value="${spEmail1}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="30" class="form_text" style="width: 18%;" title="추천담당자 이메일" />
									@
									<input type="text" id="spRecEmail2" name="spRecEmail2" value="<c:out value="${spEmail2}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="30" class="form_text" style="width: 21%;" title="추천담당자 이메일" />
									<select id="spRecEmailCon" name="spRecEmailCon" onchange="doReferenceEmailSelect('SP');" class="form_select" style="width: 20%;" title="추천담당자 이메일">
										<c:forEach var="item" items="${com014}" varStatus="status">
											<option value="<c:out value="${item.detailnm}" />" <c:if test="${spEmail2 eq item.detailnm}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
										</c:forEach>
									</select>
								</fieldset>
							</td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td colspan="3">
								<input type="text" id="spRecTel" name="spRecTel" value="<c:out value="${spRecTel}" />" maxlength="15" class="form_text" style="width: 30%;" title="추천담당자 전화번호" numberOnly />
							</td>
						</tr>
						<tr>
							<th>핸드폰번호</th>
							<td colspan="3">
								<input type="text" id="spRecHp" name="spRecHp" value="<c:out value="${spRecHp}" />" maxlength="15" class="form_text" style="width: 30%;" title="추천담당자 핸드폰번호" numberOnly />
							</td>
						</tr>
					</table>
				</div>
			</c:when>
			<c:otherwise>
				<input type="hidden" id="spRecOrg" name="spRecOrg" value="" />
				<input type="hidden" id="spRecKind" name="spRecKind" value="" />
				<input type="hidden" id="spRecName" name="spRecName" value="" />
				<input type="hidden" id="spRecEmail1" name="spRecEmail1" value="" />
				<input type="hidden" id="spRecEmail2" name="spRecEmail2" value="" />
				<input type="hidden" id="spRecTel" name="spRecTel" value="" />
				<input type="hidden" id="spRecHp" name="spRecHp" value="" />
			</c:otherwise>
		</c:choose>
		<c:if test="${param.priType eq 'S'}">
			<div class="flex">
				<h3 style="margin-top: 20px;">공적조서</h3>
			</div>
		</c:if>
		<div <c:if test="${param.priType eq 'S'}">class="mt-10"</c:if>>
			<table class="formTable">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 10%;" />
					<col style="width: 30%;" />
					<col style="width: 18%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="5">
						<c:choose>
							<c:when test="${param.prvPriType eq '10'}">수출의탑(대표자)</c:when>
							<c:when test="${param.prvPriType eq '21'}">대표자</c:when>
							<c:when test="${param.prvPriType eq '22'}">종업원(사무직)</c:when>
							<c:when test="${param.prvPriType eq '23'}">종업원(생산직)</c:when>
							<c:when test="${param.prvPriType eq '30'}">특수유공자</c:when>
						</c:choose>
					</th>
				</tr>
				<tr>
					<th colspan="2">내외구분 <strong class="point">*</strong></th>
					<td>
						<input type="radio" id="fromYnY" name="fromYn" value="Y" onclick="doFromChk();" class="form_radio" /> 내국인
						&nbsp;&nbsp;
						<input type="radio" id="fromYnN" name="fromYn" value="N" onclick="doFromChk();" class="form_radio" /> 외국인
					</td>
					<th>국적</th>
					<td><input type="text" id="bonjuk" name="bonjuk" value="<c:out value="${referenceUser.bonjuk}" />" maxlength="200" class="form_text w100p" title="국적" readonly="readonly" /></td>
				</tr>
				<tr>
					<th rowspan="4">성명</th>
					<th rowspan="2">한글 <strong class="point">*</strong></th>
					<td rowspan="2"><input type="text" id="userNmKor" name="userNmKor" value="<c:out value="${referenceUser.userNmKor}" />" maxlength="100" class="form_text w100p" title="성명(한글)" /></td>
					<th>주민등록번호 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="juminNo1" name="juminNo1" value="<c:out value="${referenceUser.juminNo1}" />" onchange="doBirthDay();" maxlength="6" class="form_text" style="width: 47%;" title="주민등록번호" numberOnly />
						-
						<input type="text" name="juminNo2" id="juminNo2" value="<c:out value="${referenceUser.juminNo2}" />" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onchange="doBirthDay();" maxlength="7" class="form_text" style="width: 48%;" title="주민등록번호" numberOnly />
					</td>
				</tr>
				<tr>
					<th>여권번호</th>
					<td><input type="text" id="passportNo" name="passportNo" value="<c:out value="${referenceUser.passportNo}" />" maxlength="50" class="form_text w100p" title="여권번호" /></td>
				</tr>
				<tr>
					<th>영문</th>
					<td><input type="text" id="userNmEn" name="userNmEn" value="<c:out value="${referenceUser.userNmEn}" />" maxlength="50" class="form_text w100p" title="성명(영문)" /></td>
					<th>생년월일 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="birthdayYy" name="birthdayYy" value="<c:out value="${birthdays[0]}" />" onChange="doAge();" maxlength="4" class="form_text" style="width: 25%;" title="생년월일" numberOnly />년
						<input type="text" id="birthdayMm" name="birthdayMm" value="<c:out value="${birthdays[1]}" />" onChange="doAge();" maxlength="2" class="form_text" style="width: 15%;" title="생년월일" numberOnly />월
						<input type="text" id="birthdayDd" name="birthdayDd" value="<c:out value="${birthdays[2]}" />" onChange="doAge();" maxlength="2" class="form_text" style="width: 15%;" title="생년월일" numberOnly />일
						<input type="text" id="age" name="age" value="<c:out value="${referenceUser.age}" />" onChange="doAge();" maxlength="2" class="form_text" style="width: 15%;" title="생년월일" numberOnly />세
					</td>
				</tr>
				<tr>
					<th>한자 <strong class="point">*</strong></th>
					<td><input type="text" id="userNmCh" name="userNmCh" value="<c:out value="${common:reverseXss(referenceUser.userNmCh)}" escapeXml="false" />" maxlength="50" class="form_text w100p" title="성명(한자)" /></td>
					<th>성별 <strong class="point">*</strong></th>
					<td>
						<input type="radio" id="sexMale" name="sex" value="M" class="form_radio" <c:if test="${referenceUser.sex eq 'M'}">checked="checked"</c:if> /> 남자
						&nbsp;&nbsp;
						<input type="radio" id="sexFemale" name="sex" value="F" class="form_radio" <c:if test="${referenceUser.sex ne 'M'}">checked="checked"</c:if> /> 여자
					</td>
				</tr>
				<tr>
					<th rowspan="2" colspan="2">현주소 <strong class="point">*</strong></th>
					<td colspan="3">
						<input type="text" id="zipCd" name="zipCd" value="<c:out value="${referenceUser.zipCd}" />" maxlength="6" class="form_text" style="width: 15%;" title="우편번호" readonly="readonly" />
						<span class="form_search" style="width: 84%;">
							<input type="text" id="addr1" name="addr1" value="<c:out value="${referenceUser.addr1}" />" maxlength="50" class="form_text" style="width: 100%;" title="주소" readonly="readonly" />
							<button type="button" onclick="zipCodeListPopup('');" class="btn_icon btn_search" title="주소검색"></button>
						</span>
					</td>
				</tr>
				<tr>
					<td colspan="3"><input type="text" id="addr2" name="addr2" value="<c:out value="${referenceUser.addr2}" />" maxlength="100" class="form_text" style="width: 99%;" title="주소" /></td>
				</tr>
				<tr>
					<th colspan="2">E-Mail</th>
					<td colspan="3">
						<fieldset class="widget">
							<input type="text" id="email1" name="email1" value="<c:out value="${email1}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="30" class="form_text" style="width: 18%;" title="이메일" />
							@
							<input type="text" id="email2" name="email2" value="<c:out value="${email2}" />" onkeypress="doEmailKey(this);" onchange="doEmailChange(this);" maxlength="30" class="form_text" style="width: 21%;" title="이메일" />
							<select id="emailCon" name="emailCon" onchange="doReferenceEmailSelect('KONG');" class="form_select" style="width: 20%;" title="이메일">
								<c:forEach var="item" items="${com014}" varStatus="status">
									<option value="<c:out value="${item.detailnm}" />" <c:if test="${email2 eq item.detailnm}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
				</tr>
				<tr>
					<th colspan="2">휴대전화번호</th>
					<td>
						<input type="text" id="mobile" name="mobile" value="<c:out value="${mobile}" />" maxlength="15" class="form_text" style="width: 100%;" title="휴대전화번호" numberOnly />
					</td>
					<th>구분 <strong class="point">*</strong></th>
					<td>
						<input type="radio" id="gbEmpCd10" name="gbEmpCd" value="10" class="form_radio" <c:if test="${empty referenceUser.gEmpCd or referenceUser.gEmpCd eq '10'}">checked="checked"</c:if> /> 일반
						&nbsp;&nbsp;
						<input type="radio" id="gbEmpCd20" name="gbEmpCd" value="20" class="form_radio" <c:if test="${referenceUser.gEmpCd eq '20'}">checked="checked"</c:if> /> 단체
						&nbsp;&nbsp;
						<input type="radio" id="gbEmpCd30" name="gbEmpCd" value="30" class="form_radio" <c:if test="${referenceUser.gEmpCd eq '30'}">checked="checked"</c:if> /> 공무원
					</td>
				</tr>
				<c:choose>
					<c:when test="${param.prvPriType eq '10' or param.prvPriType eq '21'}">
						<input type="hidden" id="job" name="job" value="<c:out value="${referenceUser.job}" />" />
						<input type="hidden" id="imwonYn" name="imwonYn" value="<c:out value="${referenceUser.imwonYn}" />" />
						<input type="hidden" id="deptPos" name="deptPos" value="<c:out value="${referenceUser.deptPos}" />" />
						<input type="hidden" id="rank" name="rank" value="<c:out value="${referenceUser.rank}" />" />
					</c:when>
					<c:otherwise>
						<tr>
							<th colspan="2">직업 <strong class="point">*</strong></th>
							<td><input type="text" id="job" name="job" value="<c:out value="${referenceUser.job}" />" maxlength="50" class="form_text w100p" title="직업" /></td>
							<th>임원여부 <strong class="point">*</strong></th>
							<td>
								<input type="radio" id="imwonYnY" name="imwonYn" value="Y" class="form_radio" <c:if test="${referenceUser.imwonYn eq 'Y'}">checked="checked"</c:if> /> 임원
								&nbsp;&nbsp;
								<input type="radio" id="imwonYnN" name="imwonYn" value="N" class="form_radio" <c:if test="${referenceUser.imwonYn ne 'Y'}">checked="checked"</c:if> /> 임원아님
							</td>
						</tr>
						<tr>
							<th colspan="2">소속(한글) <strong class="point">*</strong></th>
							<td><input type="text" id="deptPos" name="deptPos" value="<c:out value="${referenceUser.deptPos}" />" maxlength="60" class="form_text w100p" title="소속(한글)" /></td>
							<th>등급(직급, 계급) <strong class="point">*</strong></th>
							<td><input type="text" id="rank" name="rank" value="<c:out value="${referenceUser.rank}" />" maxlength="60" class="form_text w100p" title="등급(직급, 계급)" /></td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr>
					<th colspan="2">입사일자(현 재직사) <strong class="point">*</strong></th>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="enterYmd" name="enterYmd" value="<c:out value="${referenceUser.enterYmd}" />" maxlength="10" class="txt datepicker" style="width: 100px;" title="입사일자(현 재직사)" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('enterYmd');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</td>
					<th>직위 <strong class="point">*</strong></th>
					<td>
						<span class="form_search" style="width: 100%;">
							<input type="text" id="pos" name="pos" value="<c:out value="${referenceUser.pos}" />" maxlength="60" class="form_text w100p" title="직위" readonly="readonly" />
							<button type="button" onclick="dlgSearchCodeList();" class="btn_icon btn_search" title="직위 검색"></button>
						</span>
					</td>
				</tr>
				<tr>
					<th colspan="2">근무기간(재직기간) <strong class="point">*</strong></th>
					<td>
						<input type="text" id="curwrkTermYy" name="curwrkTermYy" value="<c:out value="${referenceUser.curwrkTermYy}" />" maxlength="2" class="form_text" style="width: 20%;" title="근무기간(재직기간)" numberOnly /> 년
						<input type="text" id="curwrkTermMm" name="curwrkTermMm" value="<c:out value="${referenceUser.curwrkTermMm}" />" maxlength="2" class="form_text" style="width: 20%;" title="근무기간(재직기간)" numberOnly /> 개월
						<input type="text" id="curwrkTermDd" name="curwrkTermDd" value="<c:out value="${referenceUser.curwrkTermDd}" />" maxlength="2" class="form_text" style="width: 20%;" title="근무기간(재직기간)" numberOnly /> 일
					</td>
					<th>총근무기간(수공기간) <strong class="point">*</strong></th>
					<td>
						<input type="text" id="wrkTermYy" name="wrkTermYy" value="<c:out value="${referenceUser.wrkTermYy}" />" maxlength="2" class="form_text" style="width: 20%;" title="총근무기간(수공기간)" numberOnly /> 년
						<input type="text" id="wrkTermMm" name="wrkTermMm" value="<c:out value="${referenceUser.wrkTermMm}" />" maxlength="2" class="form_text" style="width: 20%;" title="총근무기간(수공기간)" numberOnly /> 개월
						<input type="text" id="wrkTermDd" name="wrkTermDd" value="<c:out value="${referenceUser.wrkTermDd}" />" maxlength="2" class="form_text" style="width: 20%;" title="총근무기간(수공기간)" numberOnly /> 일
					</td>
				</tr>
				<tr>
					<th colspan="2">소속사업장 <strong class="point">*</strong></th>
					<td colspan="3">
						<select id="deptPosPlace" name="deptPosPlace" class="form_select w100p" title="소속사업장">
							<option value=""></option>
							<c:forEach var="item" items="${awd0011List}" varStatus="status">
								<option value="<c:out value="${item.detailcd}" />" <c:if test="${referenceUser.deptPosPlace eq item.detailcd}">selected="selected"</c:if>><c:out value="${item.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th colspan="2">공적요지 <strong class="point">*</strong><br />(50자 이상 75이내)</th>
					<td colspan="3">
						<textarea id="kongjukSum" name="kongjukSum" onkeyup="textareaChk(this, 75);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 100px;line-height: 18px;font-size: 15px;padding: 5px;" title="공적요지"><c:out value="${referenceUser.kongjukSum}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 30%;" />
					<col />
					<col style="width: 10%;" />
				</colgroup>
				<tr>
					<th colspan="3">국가연구개발사업 참여제재여부(해당사항 있는경우 반드시 기재)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>제재사유</th>
					<th style="text-align: center;">
						<button type="button" onclick="addHistoryRow('4');" class="btn_tbl_border">추가</button>
					</th>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList4) > 0}">
						<c:forEach var="item" items="${awd0021tList4}" varStatus="status">
							<tr>
								<td>
									<div class="group_datepicker">
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyDtTable4" value="<c:out value="${item.historyDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyToDtTable4" value="<c:out value="${item.historyToDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
									</div>
								</td>
								<td>
									<input type="text" name="historyTable4" value="<c:out value="${item.history}" />" maxlength="500" class="form_text w100p" />
								</td>
								<td style="text-align: center;">
									<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyDtTable4" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyToDtTable4" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
							</td>
							<td>
								<input type="text" name="historyTable4" value="" maxlength="500" class="form_text w100p" />
							</td>
							<td style="text-align: center;">
								<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="historytr4" style="display: none;">
					<td colspan="3"></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 30%;" />
					<col />
					<col style="width: 10%;" />
				</colgroup>
				<tr>
					<th colspan="3">주요경력(학력)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</th>
					<th style="text-align: center;">
						<button type="button" onclick="addHistoryRow('1');" class="btn_tbl_border">추가</button>
					</th>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList1) > 0}">
						<c:forEach var="item" items="${awd0021tList1}" varStatus="status">
							<tr>
								<td>
									<div class="group_datepicker">
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyDtTable1" value="<c:out value="${item.historyDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyToDtTable1" value="<c:out value="${item.historyToDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
									</div>
								</td>
								<td>
									<input type="text" name="historyTable1" value="<c:out value="${item.history}" />" maxlength="500" class="form_text w100p" />
								</td>
								<td style="text-align: center;">
									<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyDtTable1" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyToDtTable1" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
							</td>
							<td>
								<input type="text" name="historyTable1" value="" maxlength="500" class="form_text w100p" />
							</td>
							<td style="text-align: center;">
								<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="historytr1">
					<th>주요학력</th>
					<td colspan="2">
						<c:forEach var="item" items="${awd035}" varStatus="status">
							<input type="radio" id="lastHak${status.count}" name="lastHak" value="<c:out value="${item.detailcd}" />" class="form_radio" /> <c:out value="${item.detailnm}" />
						</c:forEach>
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 30%;" />
					<col />
					<col style="width: 10%;" />
				</colgroup>
				<tr>
					<th colspan="3">주요경력(경력)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</th>
					<th style="text-align: center;">
						<button type="button" onclick="addHistoryRow('2');" class="btn_tbl_border">추가</button>
					</th>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList2) > 0}">
						<c:forEach var="item" items="${awd0021tList2}" varStatus="status">
							<tr>
								<td>
									<div class="group_datepicker">
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyDtTable2" value="<c:out value="${item.historyDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyToDtTable2" value="<c:out value="${item.historyToDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
									</div>
								</td>
								<td>
									<input type="text" name="historyTable2" value="<c:out value="${item.history}" />" maxlength="500" class="form_text w100p" />
								</td>
								<td style="text-align: center;">
									<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyDtTable2" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyToDtTable2" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
							</td>
							<td>
								<input type="text" name="historyTable2" value="" maxlength="500" class="form_text w100p" />
							</td>
							<td style="text-align: center;">
								<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="historytr2" style="display: none;">
					<td colspan="3"></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 30%;" />
					<col />
					<col style="width: 10%;" />
				</colgroup>
				<tr>
					<th colspan="3">과거 포상기록(훈장, 포상, 표창별로 기록)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</th>
					<th style="text-align: center;">
						<button type="button" onclick="addHistoryRow('3');" class="btn_tbl_border">추가</button>
					</th>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList3) > 0}">
						<c:forEach var="item" items="${awd0021tList3}" varStatus="status">
							<tr>
								<td style="padding-left: 90px;">
									<div class="group_datepicker">
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" name="historyDtTable3" value="<c:out value="${item.historyDt}" />" class="txt datepicker" title="년월일" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										</div>
									</div>
								</td>
								<td>
									<input type="text" name="historyTable3" value="<c:out value="${item.history}" />" maxlength="500" class="form_text w100p" />
								</td>
								<td style="text-align: center;">
									<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td style="padding-left: 90px;">
								<div class="group_datepicker">
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" name="historyDtTable3" value="" class="txt datepicker" title="년월일" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										</span>
									</div>
								</div>
							</td>
							<td>
								<input type="text" name="historyTable3" value="" maxlength="500" class="form_text w100p" />
							</td>
							<td style="text-align: center;">
								<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr id="historytr3" style="display: none;">
					<td colspan="3"></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 30%;" />
					<col />
				</colgroup>
				<tr>
					<th>최근 5년이내 1년 이상의 해외근무경력</th>
					<td>
						<input type="radio" id="fognWorkYnY" name="fognWorkYn" value="Y" class="form_radio" <c:if test="${referenceUser.fognWorkYn eq 'Y'}">checked="checked"</c:if> /> 있음
						&nbsp;&nbsp;
						<input type="radio" id="fognWorkYnN" name="fognWorkYn" value="N" class="form_radio" <c:if test="${referenceUser.fognWorkYn eq 'N'}">checked="checked"</c:if> /> 없음
					</td>
				</tr>
			</table>
		</div>
		<c:choose>
			<c:when test="${param.prvPriType eq '21'}">
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기본사항(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt1">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk1Item1" onclick="divFocus(this, 'textareaKongjuk1Item1', 'kongjuk1Item1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk1Item1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item1) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk1Item1" name="kongjuk1Item1" index="1" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기본사항"><c:out value="${referenceUser.kongjuk1Item1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수출실적(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt2">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk1Item2" onclick="divFocus(this, 'textareaKongjuk1Item2', 'kongjuk1Item2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk1Item2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item2) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk1Item2" name="kongjuk1Item2" index="2" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수출실적"><c:out value="${referenceUser.kongjuk1Item2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기술개발 및 품질향상 노력(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt3">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk1Item3" onclick="divFocus(this, 'textareaKongjuk1Item3', 'kongjuk1Item3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk1Item3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item3) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk1Item3" name="kongjuk1Item3" index="3" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기술개발 및 품질향상 노력"><c:out value="${referenceUser.kongjuk1Item3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">해외시장 개척활동(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt4">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk1Item4" onclick="divFocus(this, 'textareaKongjuk1Item4', 'kongjuk1Item4');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item4) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk1Item4" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Item4) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk1Item4" name="kongjuk1Item4" index="4" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="해외시장 개척활동"><c:out value="${referenceUser.kongjuk1Item4}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기타 공적내용(800자 이내)</th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt5">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk1Etc" onclick="divFocus(this, 'textareaKongjuk1Etc', 'kongjuk1Etc');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Etc) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk1Etc" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk1Etc) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk1Etc" name="kongjuk1Etc" index="5" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기타 공적내용"><c:out value="${referenceUser.kongjuk1Etc}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수공기간(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt6">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj1" onclick="divFocus(this, 'textareaSanghunKj1', 'sanghunKj1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj1" name="sanghunKj1" index="6" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수공기간"><c:out value="${referenceUser.sanghunKj1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수상이력 및 혁신 기여도(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt7">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj2" onclick="divFocus(this, 'textareaSanghunKj2', 'sanghunKj2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj2" name="sanghunKj2" index="7" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수상이력 및 혁신 기여도,업무과제 창의적 해결 기여도"><c:out value="${referenceUser.sanghunKj2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">국가발전 및 국민생활 향상 기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt8">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj3" onclick="divFocus(this, 'textareaSanghunKj3', 'sanghunKj3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj3" name="sanghunKj3" index="8" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="국가발전 및 국민생활 향상 기여도,근무부서별 성과 기여도,조직학습 및 성장전략 기여도"><c:out value="${referenceUser.sanghunKj3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">조직문화 개선 기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt9">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj4" onclick="divFocus(this, 'textareaSanghunKj4', 'sanghunKj4');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj4) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj4" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj4) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj4" name="sanghunKj4" index="9" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="조직문화 개선 기여도,근무부서별 성과 기여도"><c:out value="${referenceUser.sanghunKj4}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">사회공헌 및 기타 기여도(800자 이내)</th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt11">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj6" onclick="divFocus(this, 'textareaSanghunKj6', 'sanghunKj6');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj6" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj6" name="sanghunKj6" index="11" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="사회공헌 및 기타 기여도"><c:out value="${referenceUser.sanghunKj6}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</c:when>
			<c:when test="${param.prvPriType eq '22' or param.prvPriType eq '23'}">
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기본사항(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt1">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item1" onclick="divFocus(this, 'textareaKongjuk2Item1', 'kongjuk2Item1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item1) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item1" name="kongjuk2Item1" index="1" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기본사항"><c:out value="${referenceUser.kongjuk2Item1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt2">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item2" onclick="divFocus(this, 'textareaKongjuk2Item2', 'kongjuk2Item2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item2) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item2" name="kongjuk2Item2" index="2" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="내부 성과 기여도,기여도"><c:out value="${referenceUser.kongjuk2Item2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수상등 공적내용(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt3">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item3" onclick="divFocus(this, 'textareaKongjuk2Item3', 'kongjuk2Item3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item3) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item3" name="kongjuk2Item3" index="3" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수상이력 및 혁신기여도,수상등 공적내용"><c:out value="${referenceUser.kongjuk2Item3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기타공적 및 결론(800자 이내)</th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt4">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Etc" onclick="divFocus(this, 'textareaKongjuk2Etc', 'kongjuk2Etc');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Etc) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Etc" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Etc) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Etc" name="kongjuk2Etc" index="4" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="국가발전 및 국민생활 향상 기여도,기타공적 및 결론"><c:out value="${referenceUser.kongjuk2Etc}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수공기간(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt6">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj1" onclick="divFocus(this, 'textareaSanghunKj1', 'sanghunKj1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj1" name="sanghunKj1" index="6" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수공기간"><c:out value="${referenceUser.sanghunKj1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">업무과제 창의적 해결 기여도(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt7">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj2" onclick="divFocus(this, 'textareaSanghunKj2', 'sanghunKj2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj2" name="sanghunKj2" index="7" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수상이력 및 혁신 기여도,업무과제 창의적 해결 기여도"><c:out value="${referenceUser.sanghunKj2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">조직학습 및 성장전략 기여도(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt8">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj3" onclick="divFocus(this, 'textareaSanghunKj3', 'sanghunKj3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj3" name="sanghunKj3" index="8" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="국가발전 및 국민생활 향상 기여도,근무부서별 성과 기여도,조직학습 및 성장전략 기여도"><c:out value="${referenceUser.sanghunKj3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">근무부서별 성과 기여도(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt9">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj4" onclick="divFocus(this, 'textareaSanghunKj4', 'sanghunKj4');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj4) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj4" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj4) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj4" name="sanghunKj4" index="9" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="조직문화 개선 기여도,근무부서별 성과 기여도"><c:out value="${referenceUser.sanghunKj4}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">사회공헌 및 기타 기여도(800자 이내)</th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt11">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj6" onclick="divFocus(this, 'textareaSanghunKj6', 'sanghunKj6');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj6" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj6" name="sanghunKj6" index="11" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="사회공헌 및 기타 기여도"><c:out value="${referenceUser.sanghunKj6}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</c:when>
			<c:when test="${param.prvPriType eq '30'}">
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">기본사항(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt1">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item1" onclick="divFocus(this, 'textareaKongjuk2Item1', 'kongjuk2Item1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item1) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item1" name="kongjuk2Item1" index="1" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="기본사항"><c:out value="${referenceUser.kongjuk2Item1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">내부 성과 기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt2">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item2" onclick="divFocus(this, 'textareaKongjuk2Item2', 'kongjuk2Item2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item2) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item2" name="kongjuk2Item2" index="2" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="내부 성과 기여도,기여도"><c:out value="${referenceUser.kongjuk2Item2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수상이력 및 혁신기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt3">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Item3" onclick="divFocus(this, 'textareaKongjuk2Item3', 'kongjuk2Item3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Item3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Item3) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Item3" name="kongjuk2Item3" index="3" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수상이력 및 혁신기여도,수상등 공적내용"><c:out value="${referenceUser.kongjuk2Item3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">국가발전 및 국민생활 향상 기여도(800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt4">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divKongjuk2Etc" onclick="divFocus(this, 'textareaKongjuk2Etc', 'kongjuk2Etc');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Etc) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaKongjuk2Etc" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.kongjuk2Etc) > 0 ? '' : 'none'}" />;">
									<textarea id="kongjuk2Etc" name="kongjuk2Etc" index="4" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="국가발전 및 국민생활 향상 기여도,기타공적 및 결론"><c:out value="${referenceUser.kongjuk2Etc}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">수공기간(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt6">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj1" onclick="divFocus(this, 'textareaSanghunKj1', 'sanghunKj1');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj1" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj1) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj1" name="sanghunKj1" index="6" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수공기간"><c:out value="${referenceUser.sanghunKj1}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">업무과제 창의적 해결 기여도(한글 200자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt7">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj2" onclick="divFocus(this, 'textareaSanghunKj2', 'sanghunKj2');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj2" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj2) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj2" name="sanghunKj2" index="7" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="수상이력 및 혁신 기여도,업무과제 창의적 해결 기여도"><c:out value="${referenceUser.sanghunKj2}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">근무부서별 성과 기여도(한글 50자 이상 800자 이내) <strong class="point">*</strong></th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt8">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj3" onclick="divFocus(this, 'textareaSanghunKj3', 'sanghunKj3');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj3" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj3) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj3" name="sanghunKj3" index="8" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="국가발전 및 국민생활 향상 기여도,근무부서별 성과 기여도,조직학습 및 성장전략 기여도"><c:out value="${referenceUser.sanghunKj3}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="mt-10">
					<table class="formTable">
						<colgroup>
							<col style="width: 50%;" />
							<col />
						</colgroup>
						<tr>
							<th style="text-align: left;border-right: 0px;">사회공헌 및 기타 기여도(800자 이내)</th>
							<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt11">0</span> / 2000)</th>
						</tr>
						<tr>
							<td colspan="2">
								<div id="divSanghunKj6" onclick="divFocus(this, 'textareaSanghunKj6', 'sanghunKj6');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? 'none' : ''}" />;">
								</div>
								<div id="textareaSanghunKj6" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj6) > 0 ? '' : 'none'}" />;">
									<textarea id="sanghunKj6" name="sanghunKj6" index="11" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="사회공헌 및 기타 기여도"><c:out value="${referenceUser.sanghunKj6}" /></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</c:when>
		</c:choose>
		<div class="mt-10" style="display: none;">
			<table class="formTable">
				<colgroup>
					<col style="width: 50%;" />
					<col />
				</colgroup>
				<tr>
					<th style="text-align: left;border-right: 0px;">무역진흥 기여도(800자 이내) <strong class="point">*</strong></th>
					<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt10">0</span> / 2000)</th>
				</tr>
				<tr>
					<td colspan="2">
						<div id="divSanghunKj5" onclick="divFocus(this, 'textareaSanghunKj5', 'sanghunKj5');" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj5) > 0 ? 'none' : ''}" />;">
						</div>
						<div id="textareaSanghunKj5" style="width:100%; height: 150px;display: <c:out value="${fn:length(referenceUser.sanghunKj5) > 0 ? '' : 'none'}" />;">
							<textarea id="sanghunKj5" name="sanghunKj5" index="10" onkeyup="textareaChk(this, 2000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="무역진흥 기여도"><c:out value="${referenceUser.sanghunKj5}" /></textarea>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<input type="hidden" id="attPictId" name="attPictId" value="<c:out value="${referenceUser.attPictId}" />" />
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 20%;" />
					<col />
					<col style="width: 15%;" />
				</colgroup>
				<tr>
					<th>이력서 사진 <strong class="point">*</strong></th>
					<td id="referencePictList" style="height: 35px;">
						<c:choose>
							<c:when test="${fn:length(pictAttachList) eq 0}">
								&nbsp;
							</c:when>
							<c:otherwise>
								<c:forEach var="item" items="${pictAttachList}" varStatus="status">
									<div id="file_<c:out value="${item.fileId}" />_<c:out value="${item.fileNo}" />" class="addedFile">
										<a href="javascript:void(0);" onclick="doReferenceDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
										<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
											<a href="javascript:void(0);" onclick="doReferenceDeleteFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="btn_del">
												<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
											</a>
										</c:if>
									</div>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</td>
					<td align="center">
						<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
							<label class="file_btn">
								<span class="btn_tbl"><a href="javascript:void(0);" onclick="showReferencePictPopup();" class="filename" style="color: #ffffff;">첨부파일</a></span>
							</label>
						</c:if>
					</td>
				</tr>
			</table>
		</div>
		<input type="hidden" id="attFileId" name="attFileId" value="<c:out value="${referenceUser.attFileId}" />" />
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 20%;" />
					<col />
					<col style="width: 15%;" />
				</colgroup>
				<tr>
					<th rowspan="2">첨부파일</th>
					<td id="referenceFileList" style="height: 35px;">
						<c:choose>
							<c:when test="${fn:length(fileAttachList) eq 0}">
								&nbsp;
							</c:when>
							<c:otherwise>
								<c:forEach var="item" items="${fileAttachList}" varStatus="status">
									<div id="file_<c:out value="${item.fileId}" />_<c:out value="${item.fileNo}" />" class="addedFile">
										<a href="javascript:void(0);" onclick="doReferenceDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
										<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
											<a href="javascript:void(0);" onclick="doReferenceDeleteFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="btn_del">
												<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
											</a>
										</c:if>
									</div>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</td>
					<td align="center">
						<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
							<label class="file_btn">
								<span class="btn_tbl"><a href="javascript:void(0);" onclick="showReferenceFilePopup();" class="filename" style="color: #ffffff;">첨부파일</a></span>
							</label>
						</c:if>
					</td>
				</tr>
				<c:forEach var="item" items="${awd014}" varStatus="status">
					<tr>
						<td colspan="2"	class="align_l">- <c:out value="${item.detailnm}" /></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div class="flex">
			<h3 style="margin-top: 20px;">비고</h3>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 50%;" />
					<col />
				</colgroup>
				<tr>
					<th style="text-align: left;border-right: 0px;">비고내용</th>
					<th style="text-align: right;border-left: 0px;padding-right: 10px;">(<span id="textCnt12">0</span> / 1000)</th>
				</tr>
				<tr>
					<td colspan="2">
						<textarea id="remark" name="remark" index="12" onkeyup="textareaChk(this, 1000);" onfocus="inputTextOnFocus(this);" onblur="inputTextOutFocus(this);" style="width: 100%;height: 150px;line-height: 18px;font-size: 15px;padding: 5px;" title="비고내용"><c:out value="${referenceUser.remark}" /></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">&nbsp;</div>
	</div>
</div>
</form>
<form id="referencePopupDownloadForm" name="referencePopupDownloadForm" method="post" onsubmit="return false;">
<input type="hidden" name="fileId" value="" />
<input type="hidden" name="fileNo" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		$('.datepicker').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString) {
				var inputName = $(this).attr('name');
				$('#' + inputName).val(dateString);

				$('label[for="all"]').css('background', '#fff');
				$('label[for="commCode_01"]').css('background', '#fff');
				$('label[for="commCode_02"]').css('background', '#fff');

				if (inputName == 'enterYmd') {
					doChangeDateCur(this);
				}
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});

		var f = document.referencePopupForm;

		// 내외구분
		setRadio(f.fromYn, '<c:out value="${empty referenceUser.fromYn ? 'Y' : referenceUser.fromYn}" />');
		// 주요학력
		setRadio(f.lastHak, '<c:out value="${empty referenceUser.lastHak ? 'Y' : referenceUser.lastHak}" />');

		var editYn = f.editYn.value;
		var prvPriType = f.prvPriType.value;

		if (prvPriType == '21') {
			$('#referencePopupForm #textCnt1').text($('#referencePopupForm #kongjuk1Item1').val().length);
			$('#referencePopupForm #textCnt2').text($('#referencePopupForm #kongjuk1Item2').val().length);
			$('#referencePopupForm #textCnt3').text($('#referencePopupForm #kongjuk1Item3').val().length);
			$('#referencePopupForm #textCnt4').text($('#referencePopupForm #kongjuk1Item4').val().length);
			$('#referencePopupForm #textCnt5').text($('#referencePopupForm #kongjuk1Etc').val().length);

			$('#referencePopupForm #textCnt6').text($('#referencePopupForm #sanghunKj1').val().length);
			$('#referencePopupForm #textCnt7').text($('#referencePopupForm #sanghunKj2').val().length);
			$('#referencePopupForm #textCnt8').text($('#referencePopupForm #sanghunKj3').val().length);
			$('#referencePopupForm #textCnt9').text($('#referencePopupForm #sanghunKj4').val().length);
			$('#referencePopupForm #textCnt11').text($('#referencePopupForm #sanghunKj6').val().length);
		} else if (prvPriType == '22' || prvPriType == '23') {
			$('#referencePopupForm #textCnt1').text($('#referencePopupForm #kongjuk2Item1').val().length);
			$('#referencePopupForm #textCnt2').text($('#referencePopupForm #kongjuk2Item2').val().length);
			$('#referencePopupForm #textCnt3').text($('#referencePopupForm #kongjuk2Item3').val().length);
			$('#referencePopupForm #textCnt4').text($('#referencePopupForm #kongjuk2Etc').val().length);

			$('#referencePopupForm #textCnt6').text($('#referencePopupForm #sanghunKj1').val().length);
			$('#referencePopupForm #textCnt7').text($('#referencePopupForm #sanghunKj2').val().length);
			$('#referencePopupForm #textCnt8').text($('#referencePopupForm #sanghunKj3').val().length);
			$('#referencePopupForm #textCnt9').text($('#referencePopupForm #sanghunKj4').val().length);
			$('#referencePopupForm #textCnt11').text($('#referencePopupForm #sanghunKj6').val().length);
		} else if (prvPriType == '30') {
			$('#referencePopupForm #textCnt1').text($('#referencePopupForm #kongjuk2Item1').val().length);
			$('#referencePopupForm #textCnt2').text($('#referencePopupForm #kongjuk2Item2').val().length);
			$('#referencePopupForm #textCnt3').text($('#referencePopupForm #kongjuk2Item3').val().length);
			$('#referencePopupForm #textCnt4').text($('#referencePopupForm #kongjuk2Etc').val().length);

			$('#referencePopupForm #textCnt6').text($('#referencePopupForm #sanghunKj1').val().length);
			$('#referencePopupForm #textCnt7').text($('#referencePopupForm #sanghunKj2').val().length);
			$('#referencePopupForm #textCnt8').text($('#referencePopupForm #sanghunKj3').val().length);
			$('#referencePopupForm #textCnt11').text($('#referencePopupForm #sanghunKj6').val().length);
		}
		$('#referencePopupForm #textCnt10').text($('#referencePopupForm #sanghunKj5').val().length);
		$('#referencePopupForm #textCnt12').text($('#referencePopupForm #remark').val().length);

		if (editYn == 'N') {
			initDivFocus('divSanghunKj1', 'textareaSanghunKj1', 'sanghunKj1');
			initDivFocus('divSanghunKj2', 'textareaSanghunKj2', 'sanghunKj2');
			initDivFocus('divSanghunKj3', 'textareaSanghunKj3', 'sanghunKj3');
			initDivFocus('divSanghunKj4', 'textareaSanghunKj4', 'sanghunKj4');
			initDivFocus('divSanghunKj5', 'textareaSanghunKj5', 'sanghunKj5');
			initDivFocus('divSanghunKj6', 'textareaSanghunKj6', 'sanghunKj6');
		}

		f.fromYn[0].focus();

		<c:if test="${param.priType eq 'S'}">
			doReferenceEmailSelect('SP');
		</c:if>
		doReferenceEmailSelect('KONG');

		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber([
			'#referencePopupForm #spRecTel'
			, '#referencePopupForm #spRecHp'
			, '#referencePopupForm #mobile'
		], 'W');

		// 로딩이미지 종료
		$('#loading_image').hide();
	});

	function doEmailKey(event) {
		if (event.keyCode == 64) {
			event.returnValue = false;
		}
	}

	function doEmailChange(obj) {
		obj.value = obj.value.replace(/@/gi, '');
	}

	function doReferenceEmailSelect(val) {
		var f = document.referencePopupForm;

		if (val == 'CO') {
			if (f.coEmailCon.value == '직접입력') {
				$('#referencePopupForm #coEmail2').attr('readonly', false);
				$('#referencePopupForm #coEmail2').css('background-color', '#ffffff');
			} else {
				f.coEmail2.value = f.coEmailCon.value;
				$('#referencePopupForm #coEmail2').attr('readonly', true);
				$('#referencePopupForm #coEmail2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'USER') {
			if (f.userEmailCon.value == '직접입력') {
				$('#referencePopupForm #userEmail2').attr('readonly', false);
				$('#referencePopupForm #userEmail2').css('background-color', '#ffffff');
			} else {
				f.userEmail2.value = f.userEmailCon.value;
				$('#referencePopupForm #userEmail2').attr('readonly', true);
				$('#referencePopupForm #userEmail2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'KONG') {
			if (f.emailCon.value == '직접입력') {
				$('#referencePopupForm #email2').attr('readonly', false);
				$('#referencePopupForm #email2').css('background-color', '#ffffff');
			} else {
				f.email2.value = f.emailCon.value;
				$('#referencePopupForm #email2').attr('readonly', true);
				$('#referencePopupForm #email2').css('background-color', '#f3f4f2');
			}
		} else if (val == 'SP') {
			if (f.spRecEmailCon.value == '직접입력') {
				$('#referencePopupForm #spRecEmail2').attr('readonly', false);
				$('#referencePopupForm #spRecEmail2').css('background-color', '#ffffff');
			} else {
				f.spRecEmail2.value = f.spRecEmailCon.value;
				$('#referencePopupForm #spRecEmail2').attr('readonly', true);
				$('#referencePopupForm #spRecEmail2').css('background-color', '#f3f4f2');
			}
		}
	}

	function doFromChk() {
		var f = document.referencePopupForm;

		if (f.fromYn[0].checked == true) {
			f.bonjuk.value = '';
			$('#referencePopupForm #bonjuk').attr('readonly', true);
			$('#referencePopupForm #bonjuk').css('background-color', '#f3f4f2');

			f.passportNo.value = '';
			$('#referencePopupForm #passportNo').attr('readonly', true);
			$('#referencePopupForm #passportNo').css('background-color', '#f3f4f2');
		} else if (f.fromYn[0].checked == false) {
			$('#referencePopupForm #bonjuk').attr('readonly', false);
			$('#referencePopupForm #bonjuk').css('background-color', '#ffffff');

			$('#referencePopupForm #passportNo').attr('readonly', false);
			$('#referencePopupForm #passportNo').css('background-color', '#ffffff');
		}
	}

	function doBirthDay() {
		var f = document.referencePopupForm;

		var year = '';
		var month = '';
		var day = '';

		if (f.juminNo1.value.length == 6 && f.juminNo2.value.length == 7) {
			if (
				f.juminNo2.value.substring(0, 1) == '3' || f.juminNo2.value.substring(0, 1) == '4'
				|| f.juminNo2.value.substring(0, 1) == '7' || f.juminNo2.value.substring(0, 1) == '8'
			) {
				year = '20';
			} else {
				year = '19';
			}

			doSex(f.juminNo2.value.substring(0, 1));

			year += f.juminNo1.value.substring(0, 2);
			month = f.juminNo1.value.substring(2, 4);
			day = f.juminNo1.value.substring(4, 6);

			f.birthdayYy.value = year;
			f.birthdayMm.value = month;
			f.birthdayDd.value = day;

			doAge();
		}

		if (f.juminNo1.value.length == 0 && f.juminNo2.value.length == 0) {
			f.birthdayYy.value = '';
		    f.birthdayMm.value = '';
			f.birthdayDd.value = '';
		}
	}

	function doSex(val) {
		var f = document.referencePopupForm;

		if (val == '1' || val == '3' || val == '5' || val == '7' || val == '9') {
			f.sex[0].checked = true;
			f.sex[1].checked = false;
		} else if (val == '2' || val == '4' || val == '6' || val == '8' || val == '0') {
			f.sex[0].checked = false;
			f.sex[1].checked = true;
		}
	}

	function doAge() {
		var f = document.referencePopupForm;

		var now = new Date();
	    var nowYear = now.getFullYear();
	    var nowMonth = now.getMonth() + 1;
	    var nowDay = now.getDate();

	    var toDay = nowMonth.toString() + nowDay.toString();

		if (f.juminNo1.value.length == 6 && f.juminNo2.value.length == 7) {
		    var year = f.birthdayYy.value;
		    var month = f.birthdayMm.value;
			var day = f.birthdayDd.value;

			if (day.length == 1) {
				day = '0' + day;
			}

			if (month > 12 || month < 0) {
				f.birthdayMm.value = '';
			}

			if (year.length != 4 || nowYear < year) {
				f.birthdayYy.value = '';
			}

			if (day > 31 || day < 0) {
				f.birthdayDd.value = '';
			}

			if (f.birthdayYy.value == '' || f.birthdayMm.value == '' || f.birthdayDd.value == '') {
				f.AGE.value = '';
			} else {
				if (parseFloat(toDay) >= parseFloat(month + day)) {
					f.age.value = nowYear - year;
				} else {
					f.age.value = nowYear - year - 1;
				}
			}
		}
	}

	function initDivFocus(from, target, textarea) {
		$('#referencePopupForm #' + from).hide();
		$('#referencePopupForm #' + target).show();
		$('#referencePopupForm #' + textarea).focus();
	}

	function divFocus(from, target, textarea) {
		$(from).hide();
		$('#referencePopupForm #' + target).show();
		$('#referencePopupForm #' + textarea).focus();
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

		$('#referencePopupForm #textCnt' + index).text(textareaLength > limit ? limit : textareaLength);

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
				$('#referencePopupForm #zipCd').val(resultObj.zipNo);
				$('#referencePopupForm #addr1').val(resultObj.roadAddrPart1);
				$('#referencePopupForm #addr2').val(resultObj.roadAddrPart2);
			}
		});
	}

	function doChangeDateCur(obj) {
		var day = obj.value.replace(/-/gi, '');
		for (var i = 0; obj.value.length > i; i++) {
			if (((obj.value.charCodeAt(i) < 48) || (obj.value.charCodeAt(i) > 57)) && (obj.value.charCodeAt(i) != 45)) {
	        	obj.value = '';
	        	day = '';
	    	}
		}

		if (day.length == 8) {
			obj.value = day.substring(0, 4) + '-' + day.substring(4, 6) + '-' + day.substring(6, 8);

			if (day.substring(4, 6) > 12 || day.substring(4, 6) <= 0) {
				obj.value = '';
				day = '';
			}

			if (day.substring(6, 8) > 31 || day.substring(6, 8) <= 0) {
				obj.value = '';
				day = '';
			}

			if (day.substring(6, 8) > dlgLastDay(day.substring(0, 6))) {
				alert(day.substring(0, 4) + '년 ' + day.substring(4, 6) + '월은 ' + dlgLastDay(day.substring(0, 6)) + '일 까지 있습니다.');

				obj.value = '';
			}
		} else {
			obj.value = '';
		}

		if (obj.value != '') {
			doChangeCurwrk(day);
		}
	}

	function doChangeCurwrk(val) {
		var f = document.referencePopupForm;

		if (val == '') {
			return;
		}

		var day = val.replace(/-/gi, '');
		var day2 = f.bsnAplEndDt.value.replace(/-/gi, '');

		var checkDate = new Date(day.substring(0, 4), parseInt(day.substring(4, 6)) - 1, parseInt(day.substring(6, 8)));
		var checkDate2 = new Date(day2.substring(0, 4), parseInt(day2.substring(4, 6)) - 1, parseInt(day2.substring(6, 8)));

		var chkDay = checkDate2.getTime() - checkDate.getTime();

		// 1분은 60초
		var miMilli = 1000 * 60 * 60 * 24;

		var chkDate = parseFloat(day2.substring(0, 4)) - parseFloat(day.substring(0, 4));

		if (parseFloat(day.substring(4, 6)) > parseFloat(day2.substring(4, 6))) {
			chkDate = chkDate - 1;
		}

		f.curwrkTermYy.value = chkDate;
		f.curwrkTermMm.value = Math.floor(monthsBetween(day2, day) % 12);
	}

	function monthsBetween(edate, sdate) {
	    var syear, smonth, sday;
	    var eyear, emonth, eday;
	    var diff_month = 1;

		// javascript 날짜형변수로 변환
		sdate = makeDateFormat(sdate);
		// javascript 날짜형변수로 변환
		edate = makeDateFormat(edate);

	    if (sdate == '') {
	    	return '';
	    }
	    if (edate == '') {
	    	return '';
	    }

	    syear = sdate.getYear();
	    eyear = edate.getYear();
	    smonth= sdate.getMonth() + 1;
	    emonth= edate.getMonth() + 1;
	    sday = sdate.getDate();
	    eday = edate.getDate();

		// 한달씩 더해서 몇개월 차이 생기는지 검사
	    while (sdate < edate) {
	        sdate = new Date(syear, smonth - 1 + diff_month, 0);

	        diff_month++;
	    }

	    if (sday > eday) {
	    	diff_month--;
	    }

	    diff_month = diff_month - 2;

	    return diff_month;
	}

	// yyyymmdd, yyyy-mm-dd, yyyy.mm.dd를 javascript 날짜형 변수로 변환
	function makeDateFormat(pdate) {
	    var yy, mm, dd, yymmdd;
	    var ar;

	 	// yyyy.mm.dd
	    if (pdate.indexOf('.') > -1) {
	        ar = pdate.split('.');
	        yy = ar[0];
	        mm = ar[1];
	        dd = ar[2];

	        if (mm < 10) {
	        	mm = '0' + mm;
	        }
	        if (dd < 10) {
	        	dd = '0' + dd;
	        }
		// yyyy-mm-dd
	    } else if (pdate.indexOf('-') > -1) {
	        ar = pdate.split('-');
	        yy = ar[0];
	        mm = ar[1];
	        dd = ar[2];

	        if (mm < 10) {
	        	mm = '0' + mm;
	        }
	        if (dd < 10) {
	        	dd = '0' + dd;
	        }
	    } else if (pdate.length == 8) {
	        yy = pdate.substr(0, 4);
	        mm = pdate.substr(4, 2);
	        dd = pdate.substr(6, 2);
	    }

	    yymmdd = yy + '/' + mm + '/' + dd;
	    yymmdd = new Date(yymmdd);

	    if (isNaN(yymmdd)) {
			return false;
	    }

		return yymmdd;
	}

	// 달력 초기화
	function setDefaultPickerValue(objId) {
		if (objId == 'enterYmd') {
			$('#' + objId).val('<c:out value="${referenceUser.enterYmd}" />');
		}
	}

	function fnSpRecOrgPopYn(obj) {
		var valueYn = obj.value;

		if (valueYn == 'P') {
			$('#referencePopupForm #spRecOrg').attr('readonly', true);
			$('#referencePopupForm #spRecOrg').css('background-color', '#f3f4f2');
		} else {
			$('#referencePopupForm #spRecOrg').attr('readonly', false);
			$('#referencePopupForm #spRecOrg').css('background-color', '');
		}
	}

	function spRecOrgListPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/spRecOrgPopup.do" />'
			, callbackFunction : function(resultObj){
				if (resultObj) {
					$('#referencePopupForm #spRecOrg').val(resultObj.detailnm);
				}
			}
		});
	}

	function dlgSearchCodeList() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradefund/cmn/popup/dlgSearchCodePopup.do" />'
			, callbackFunction : function(resultObj){
				if (resultObj) {
					$('#referencePopupForm #pos').val(resultObj.detailnm);
				}
			}
		});
	}

	function doReferenceSave() {
		var f = document.referencePopupForm;

		var prvPriType = f.prvPriType.value;

		if (prvPriType != '10' && prvPriType != '21' && prvPriType != '30') {
			if (parseFloat(f.enterYmd.value.replace(/-/gi, '')) > <c:out value="${bsnAplEndDtInfo.bsnAplEndDt3year}" />) {
				alert('근무기간이 3년 아래인 직원은 포상을 신청 할 수 없습니다.');

				return;
			}
		}

		if (f.userNmKor.value == '' || f.userNmKor.value == null) {
			alert('이름을 입력해 주세요.');
			f.userNmKor.focus();

			return;
		}

		if (!(f.kongjukSum.value.replace(/ /gi, '').length >= 50 &&  f.kongjukSum.value.replace(/ /gi, '').length <= 75)) {
			alert('공적요지는 50자 이상 75자 이내로 입력해 주세요.');
			f.kongjukSum.focus();

			return;
		}

		if (confirm('저장 하시겠습니까?')) {
			f.userNmCh.value = strToAscii(f.userNmCh.value);

			global.ajax({
				url : '<c:url value="/tdms/popup/saveApplicationReference.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : $('#referencePopupForm').serialize()
				, async : true
				, spinner : true
				, success : function(data){
					var juminNo = '';
					if (f.juminNo1.value != '' && f.juminNo2.value != '') {
						juminNo = f.juminNo1.value + '-' + f.juminNo2.value;
					}

					var history = '';
					if (f.historyTable3.length > 1) {
						history = f.historyTable3[0].value;
					} else {
						history = f.historyTable3.value;
					}

					var returnObj = {
						event : 'tradeDayReferenceSave'
						, svrId : f.svrId.value
						, applySeq : f.applySeq.value
						, userNmKor : f.userNmKor.value
						, pos : f.pos.value
						, juminNo : juminNo
						, wrkTermYy : f.wrkTermYy.value
						, wrkTermMm : f.wrkTermMm.value
						, history : history
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

	function addHistoryRow(gubun) {
		var html = '';

		html += '<tr>';
		if (gubun == '3') {
			html += '	<td style="padding-left: 90px;">';
		} else {
			html += '	<td>';
		}
		html += '		<div class="group_datepicker">';
		html += '			<div class="datepicker_box">';
		html += '				<span class="form_datepicker">';
		html += '					<input type="text" name="historyDtTable' + gubun + '" value="" class="txt datepicker" title="년월일" readonly="readonly" />';
		html += '					<img src="<c:url value="/images/icon_calender.png" />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />';
		html += '				</span>';
		html += '			</div>';
		if (gubun != '3') {
			html += '			<div class="spacing">~</div>';
			html += '			<div class="datepicker_box">';
			html += '				<span class="form_datepicker">';
			html += '					<input type="text" name="historyToDtTable' + gubun + '" value="" class="txt datepicker" title="년월일" readonly="readonly" />';
			html += '					<img src="<c:url value="/images/icon_calender.png" />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />';
			html += '				</span>';
			html += '			</div>';
		}
		html += '		</div>';
		html += '	</td>';
		html += '	<td>';
		html += '		<input type="text" name="historyTable' + gubun + '" value="" maxlength="500" class="form_text w100p" />';
		html += '	</td>';
		html += '	<td style="text-align: center;">';
		html += '		<button type="button" onclick="deleteHistoryRow(this);" class="btn_tbl_border">삭제</button>';
		html += '	</td>';
		html += '</tr>';

		$('#referencePopupForm #historytr' + gubun).before(html);

		$('.datepicker').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString) {
				var inputName = $(this).attr('name');
				$('#' + inputName).val(dateString);

				$('label[for="all"]').css('background', '#fff');
				$('label[for="commCode_01"]').css('background', '#fff');
				$('label[for="commCode_02"]').css('background', '#fff');

				if (inputName == 'enterYmd') {
					doChangeDateCur(this);
				}
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});

		$('.ui-datepicker-trigger').on('click', function(){
			$(this).datepicker('show');
		});
	}

	function deleteHistoryRow(obj) {
		$(obj).closest('tr').eq(0).remove();

		event.stopPropagation();
	}

	function showReferencePictPopup() {
		if ($('#referencePopupForm #referencePictList div').length > 0) {
			alert('사진은 한장만 저장 가능합니다.');

			return;
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayFilePopup.do" />'
			, params : {
				attFileId: $('#referencePopupForm #attPictId').val()
				, mineType: ''
				, fileType: 'pict'
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();

				if (resultObj.attFileId) {
					$('#referencePopupForm #attPictId').val(resultObj.attFileId);

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
							$('#referencePopupForm #referencePictList').empty();

							if (data.attachList.length) {
								var attachList = data.attachList;

								for (var i = 0 ; i < attachList.length; i++) {
									var fileNo = attachList[i].fileNo;

									if (fileNo != '') {
										var mineType = attachList[i].mineType;
										var fileId = attachList[i].fileId;
										var fileName = attachList[i].fileName;

										var html = '';
										html += '<div id="file_' + fileId + '_' + fileNo + '" class="addedFile">';
										html += '	<a href="javascript:void(0);" onclick="doReferenceDownloadFile(\'' + fileId + '\', \'' + fileNo + '\');" class="filename">' + fileName + '</a>';
										<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
											html += '	<a href="javascript:void(0);" onclick="doReferenceDeleteFile(\'' + fileId + '\', \'' + fileNo + '\');" class="btn_del">';
											html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
											html += '	</a>';
										</c:if>
										html += '</div>';

										$('#referencePopupForm #referencePictList').append(html);
									}
								}
							}
						}
					});
				}
			}
		});
	}

	function showReferenceFilePopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayFilePopup.do" />'
			, params : {
				attFileId: $('#referencePopupForm #attFileId').val()
				, mineType: ''
				, fileType: 'file'
			}
			, callbackFunction : function(resultObj){
				closeLayerPopup();

				if (resultObj.attFileId) {
					$('#referencePopupForm #attFileId').val(resultObj.attFileId);

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
							$('#referencePopupForm #referenceFileList').empty();

							if (data.attachList.length) {
								var attachList = data.attachList;

								for (var i = 0 ; i < attachList.length; i++) {
									var fileNo = attachList[i].fileNo;

									if (fileNo != '') {
										var mineType = attachList[i].mineType;
										var fileId = attachList[i].fileId;
										var fileName = attachList[i].fileName;

										var html = '';
										html += '<div id="file_' + fileId + '_' + fileNo + '" class="addedFile">';
										html += '	<a href="javascript:void(0);" onclick="doReferenceDownloadFile(\'' + fileId + '\', \'' + fileNo + '\');" class="filename">' + fileName + '</a>';
										<c:if test="${empty param.editYn or param.editYn eq 'Y'}">
											html += '	<a href="javascript:void(0);" onclick="doReferenceDeleteFile(\'' + fileId + '\', \'' + fileNo + '\');" class="btn_del">';
											html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
											html += '	</a>';
										</c:if>
										html += '</div>';

										$('#referencePopupForm #referenceFileList').append(html);
									}
								}
							}
						}
					});
				}
			}
		});
	}

	// 첨부파일 다운로드
	function doReferenceDownloadFile(fileId, fileNo) {
		var f = document.referencePopupDownloadForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = fileId;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	// 첨부파일 삭제
	function doReferenceDeleteFile(fileId, fileNo) {
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
					$('#referencePopupForm #file_' + fileId + '_' + fileNo).remove();
				}
			});
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>