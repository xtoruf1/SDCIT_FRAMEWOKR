<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
	#prepaymentRegisteDetailPopupSheet-table {border-top: 0 !important;}
</style>

<form id="prepaymentRegisteDetailPopupForm" name="prepaymentRegisteDetailPopupForm" method="get" onsubmit="return false;">

<input type="hidden" name="fndYear" value="<c:out value="${param.fndYear}"/>" />
<input type="hidden" name="fndMonth" value="<c:out value="${param.fndMonth}"/>" />
<input type="hidden" name="fndTracd" value="<c:out value="${param.fndTracd}"/>" />
<input type="hidden" name="fndBank" value="<c:out value="${param.fndBank}"/>" />
<input type="hidden" name="loanSeq" value="<c:out value="${param.loanSeq}"/>" />
<input type="hidden" name="levelGb" value="<c:out value="${param.levelGb}"/>" />
<input type="hidden" name="interestRate" value="<c:out value="${param.interestRate}"/>" />

<input type="hidden" name="fndYear1" value="<c:out value="${fundVo.fndYear1}"/>" />
<input type="hidden" name="fndMonth1" value="<c:out value="${fundVo.fndMonth1}"/>" />
<input type="hidden" name="fndTracd1" value="<c:out value="${fundVo.fndTracd1}"/>" />
<input type="hidden" name="fndBank1" value="<c:out value="${fundVo.fndBank1}"/>" />
<input type="hidden" name="loanSeq1" value="<c:out value="${fundVo.loanSeq1}"/>" />

<input type="hidden" name="insertKey" value="N">

<input type="hidden" name="hFndYdt1" value="<c:out value="${fundVo.fndYdt1}"/>" />
<input type="hidden" name="hFndYdt2" value="<c:out value="${fundVo.fndYdt2}"/>" />
<input type="hidden" name="hFndYdt3" value="<c:out value="${fundVo.fndYdt3}"/>" />
<input type="hidden" name="hFndYdt4" value="<c:out value="${fundVo.fndYdt4}"/>" />

<input type="hidden" name="hFndYamt1" value="<c:out value="${fundVo.fndYamt1}"/>" />
<input type="hidden" name="hFndYamt2" value="<c:out value="${fundVo.fndYamt2}"/>" />
<input type="hidden" name="hFndYamt3" value="<c:out value="${fundVo.fndYamt3}"/>" />
<input type="hidden" name="hFndYamt4" value="<c:out value="${fundVo.fndYamt4}"/>" />
<input type="hidden" name="hFndRedamt" value="<c:out value="${fundVo.fndRedamt}"/>" />


<input type="hidden" name="hFndFinamt" value="<c:out value="${fundVo.fndFinamt}"/>" />


<input type="hidden" name="beforeFndFinamt" value="<c:out value="${fndBankListVo.fndFinamt}"/>" />
<input type="hidden" name="beforeFndYamt1" value="<c:out value="${fndBankListVo.fndYamt1}"/>">
<input type="hidden" name="beforeFndYamt2" value="<c:out value="${fndBankListVo.fndYamt2}"/>">
<input type="hidden" name="beforeFndYamt3" value="<c:out value="${fndBankListVo.fndYamt3}"/>">
<input type="hidden" name="beforeFndYamt4" value="<c:out value="${fndBankListVo.fndYamt4}"/>">

<input type="hidden" name="fndYamt" value="<c:out value="${fundVo.fndYamt}"/>" />

<input type="hidden" name="iFndRedamt" value="">

<input type="hidden" name="fndDay1" value="<c:out value="${fundVo.fndDay1}"/>" />
<input type="hidden" name="fndDay2" value="<c:out value="${fundVo.fndDay2}"/>" />
<input type="hidden" name="fndDay3" value="<c:out value="${fundVo.fndDay3}"/>" />
<input type="hidden" name="fndDay4" value="<c:out value="${fundVo.fndDay4}"/>" />


<input type="hidden" name="hFndFindt" value="<c:out value="${fundVo.fndFindt}"/>" />

<input type="hidden" name="fndLast" value="<c:out value="${fundVo.fndLast}"/>" />
<input type="hidden" name="speChk" value="<c:out value="${fundVo.speChk}"/>" />



<c:set var="disabledChk" value="" />
<c:set var="disabledChk2" value="" />
<c:set var="checked" value="" />
<c:set var="checked2" value="" />


<c:choose>
	<c:when test='${fundVo.fndYear1 eq "" or fundVo.fndYear1 eq null}'>
		<c:set var="disabledChk" 	value="" />
		<c:set var="disabledChk2" 	value="" />
		<c:set var="checked" 		value="checked" />
	</c:when>
	<c:otherwise>
		<c:set var="disabledChk"	value="disabled" />
		<c:set var="disabledChk2" 	value="disabled" />
		<c:set var="checked" 		value="" />
	</c:otherwise>
</c:choose>

<c:if test='${fundVo.cnt ne "0"}'>
	<c:set var="disabledChk" 	value="disabled" />
	<c:set var="checked" 		value="" />
	<c:set var="checked2" 		value="checked" />
</c:if>

<div class="winPopContinent">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">상환상세관리</h2>
		<div class="ml-auto">
			<button class="btn_sm btn_primary" 		onclick="doContent();"	id="button_09">업체상환정보</button>
			<button class="btn_sm btn_primary" 		onclick="doPrint();" 	>출력</button>
			<button class="btn_sm btn_secondary" 	onclick="doClose();"	>닫기</button>
		</div>
	</div>

	<div class="popup_body">

		<div class="cont_block">

			<div class="tit_bar">
				<label class="label_form">
					<input type="checkbox" class="form_checkbox" name="menu_04" id="menu_04" onclick="checkTitle('4')" />
					<span class="label">직접입력</span>
				</label>
				<button class="btn_sm btn_primary btn_modify_auth ml-auto" onclick="doSave();" id="button_01" style="display: none;">상환내역저장</button>
			</div>


			<table class="formTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:17.5%;">
					<col style="width:17.5%;">
					<col style="width:17.5%;">
					<col style="width:5%;">
					<col>
				</colgroup>
				<tr>
					<th rowspan="10">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="menu_01" id="menu_01" onclick="checkTitle('1')"  <c:out value="${checked}"  /> >
							<span class="label">정기상환</span>
						</label>
					</th>
					<th>회사명</th>
					<td>
						<input type="text" class="form_text" id="coNmKor" name="coNmKor" value="<c:out value="${fundVo.fndBiznm}"/>" style="width: 100%" maxlength="50"  placeholder="회사명" title="회사명" readonly="readonly" />
					</td>
					<th>신청액</th>
					<td class="align_r">
						<c:out value="${fundVo.fndReqamt}"/>
					</td>
					<td  colspan="2">
					</td>
				</tr>
				<tr>
					<th>대표자</th>
					<td>
						<input type="text" class="form_text" id="ceoNmKor" name="ceoNmKor" value="<c:out value="${fundVo.ceoNmKor}"/>" style="width: 100%" maxlength="50"  placeholder="대표자" title="대표자" />
					</td>
					<th>추천액</th>
					<td class="align_r">
						<c:out value="${fundVo.fndRecamt}"/>
					</td>
					<td  colspan="2" >
						<c:out value="${fundVo.fndRecdt}"/>
					</td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td>
						<c:out value="${fundVo.fndBizno}"/>
					</td>
					<th>융자액</th>
					<td class="align_r">
						<c:out value="${fundVo.fndFinamt}"/>
					</td>
					<td  colspan="2">
						<c:out value="${fundVo.fndFindt}"/>
					</td>
				</tr>
				<tr>
					<th>지역본부</th>
					<td>
						<c:out value="${fundVo.fndSitenm}"/>
					</td>
					<th>정기상환액</th>
					<td class="align_r">
						<c:out value="${fundVo.vfndSum1}"/>
					</td>
					<td  colspan="2">
					</td>
				</tr>
				<tr>
					<th>은행</th>
					<td>
						<c:out value="${fundVo.fndBankNm}"/>
					</td>
					<th>중도상환액</th>
					<td class="align_r">
						<c:out value="${fundVo.fndRedamt}"/>
					</td>
					<td  colspan="2">
					</td>
				</tr>
				<tr>
					<th>지점</th>
					<td>
						<input type="text" class="form_text " id="fndSbank" name="fndSbank" value="<c:out value="${fundVo.fndSbank}"/>"  maxlength="50" title="지점" />
					</td>
					<th>총상환액</th>
					<td class="align_r">
						<c:out value="${fundVo.vfndSum2}"/>
					</td>
					<th>잔액</th>
					<td class="align_r">
						<c:out value="${fundVo.vfndBal}"/>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td  colspan="5">
						<textarea rows="3" class="form_textarea" id="fndMemo" name="fndMemo" title="비고" style="height:99%; width:99%"><c:out value="${fundVo.fndMemo}"/></textarea>
					</td>
				</tr>
				<tr>
					<th>구분</th>
					<th>1차정기상환</th>
					<th>2차정기상환</th>
					<th>3차정기상환</th>
					<th colspan="2">4차정기상환</th>
				</tr>
				<tr>
					<th>금액</th>
					<td>
						<input type="text" class="form_text align_r" id="fndYamt1" name="fndYamt1" value="<c:out value="${fundVo.fndYamt1}"/>" style="width: 100%" maxlength="30" title="1차정기상환" readonly="readonly"
							onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
					</td>
					<td>
						<input type="text" class="form_text align_r" id="fndYamt2" name="fndYamt2" value="<c:out value="${fundVo.fndYamt2}"/>" style="width: 100%" maxlength="30" title="2차정기상환" readonly="readonly"
							onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
					</td>
					<td>
						<input type="text" class="form_text align_r" id="fndYamt3" name="fndYamt3" value="<c:out value="${fundVo.fndYamt3}"/>" style="width: 100%" maxlength="30" title="3차정기상환" readonly="readonly"
							onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
					</td>
					<td colspan="2">
						<input type="text" class="form_text align_r" id="fndYamt4" name="fndYamt4" value="<c:out value="${fundVo.fndYamt4}"/>" style="width: 100%" maxlength="30" title="3차정기상환" readonly="readonly"
							onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
					</td>
				</tr>
				<tr>
					<th>일자</th>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndYdt1" name="fndYdt1" value="<c:out value="${fundVo.fndYdt1}"/>" class="txt datepicker-compare" placeholder="1차정기상환일" title="1차정기상환일" readonly="readonly" disabled />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" id="fnd_ydtImg1" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
						</div>
					</td>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndYdt2" name="fndYdt2" value="<c:out value="${fundVo.fndYdt2}"/>" class="txt datepicker-compare" placeholder="2차정기상환일" title="2차정기상환일" readonly="readonly" disabled />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" id="fnd_ydtImg2" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
						</div>
					</td>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndYdt3" name="fndYdt3" value="<c:out value="${fundVo.fndYdt3}"/>" class="txt datepicker-compare" placeholder="3차정기상환일" title="3차정기상환일" readonly="readonly"  disabled/>
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" id="fnd_ydtImg3" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
						</div>
					</td>
					<td colspan="2">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="fndYdt4" name="fndYdt4" value="<c:out value="${fundVo.fndYdt4}"/>" class="txt datepicker-compare" placeholder="4차정기상환일" title="4차정기상환일" readonly="readonly"  disabled/>
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" id="fnd_ydtImg4" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
						</div>
					</td>
				</tr>

			 </table>
		</div>

		<div class="cont_block mt-20">

			<div class="tit_bar">
				<div class="ml-auto">
					<button class="btn_sm btn_primary btn_modify_auth" 		onclick="doInsert();" id="button_02" style="display: none;">신규</button>
					<button class="btn_sm btn_primary btn_modify_auth" 		onclick="doSheetSave();" id="button_03" style="display: none;">저장</button>
				</div>
			</div>

			<table class="formTable">
				<colgroup>
					<col style="width:15%;">
					<col>
				</colgroup>
				<tr>
					<th>
					<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="menu_02" id="menu_02" onclick="checkTitle('2')" />
							<span class="label">중도상환</span>
						</label>
					</th>
					<td style="padding:0">
						<div class="w100p">
							<div id="prepaymentRegisteDetailPopupSheet" class="sheet"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>


		<div class="cont_block mt-20">

	<%
	// 	if(fndVo.get("FND_YEAR1").equals("")){

	%>

	<c:choose>
		<c:when test='${fundVo.fndYear1 eq "" or fundVo.fndYear1 eq null}'>

			<div class="tit_bar">
				<button class="btn_sm btn_primary btn_modify_auth ml-auto" 	onclick="doBankSave();" id="button_04" style="display: none;">은행변경</button>
			</div>

			<table class="formTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col>
					<col>
					<col style="width:15%;">
					<col>
				</colgroup>
				<tr>
					<th rowspan="2">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="menu_03" id="menu_03" onclick="checkTitle('3')"   >
							<span class="label">은행변경</span>
						</label>
					</th>
					<th>은행/지점</th>
					<td>
						<fieldset class="widget">
							<select id="newFndBank" name="newFndBank" class="form_select" title="은행" style="width: 150px;" >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${COM004}" varStatus="status">
									<option value="<c:out value="${item.detailcd}"/>"><c:out value="${item.detailnm}"/></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
					<td>
						<input type="text" class="form_text " id="newFndSbank" name="newFndSbank"   maxlength="30" title="지점" readonly="readonly" />
					</td>
					<th>기준일</th>
					<td >
						<fieldset class="widget">
							<select id="newYdtDate" name="newYdtDate" class="form_select" title="기준일" style="width: 100px;" >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${dateRow}" varStatus="status">
									<option value="<c:out value="${item.fndYdt}"/>"><c:out value="${item.fndYdtValue}"/></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="4">
						<textarea rows="3" class="form_textarea" id="fndMemoBank" name="fndMemoBank" title="비고" style="height:99%; width:99%" readonly="readonly"></textarea>
					</td>
				</tr>
			 </table>
		</div>

	<%
	// 	}else{
	%>
	</c:when>
		<c:otherwise>

		<div class="tit_bar">
					<button class="btn_sm btn_primary btn_modify_auth" 		onclick="doBankDelete();" id="button_04" style="display: none;">삭제</button>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col>
					<col>
					<col style="width:15%;">
					<col>
				</colgroup>
				<tr>
					<th rowspan="2">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="menu_03" id="menu_03" onclick="checkTitle('3')"   >
							<span class="label">은행변경</span>
						</label>
					</th>
					<th>은행/지점</th>
					<td>
						<fieldset class="widget">
							<select id="newFndBank" name="newFndBank" class="form_select" title="은행" disabled="disabled" style="width: 150px;" >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${COM004}" varStatus="status">
									<option value="<c:out value="${item.detailcd}"/>"><c:out value="${item.detailnm}"/></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
					<td>
						<input type="text" class="form_text " id="newFndSbank" name="newFndSbank"   maxlength="30" title="지점" readonly="readonly"/>
					</td>
					<th>기준일</th>
					<td >
						<fieldset class="widget">
							<select id="newYdtDate" name="newYdtDate" class="form_select" title="기준일" style="width: 100px;" disabled="disabled" >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${dateRow}" varStatus="status">
									<option value="<c:out value="${item.fndYdt}"/>"><c:out value="${item.fndYdtValue}"/></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="4">
						<textarea rows="3" class="form_textarea" id="fndMemoBank" name="fndMemoBank" title="비고" style="height:99%; width:99%" readonly="readonly" ><c:out value="${fndBankListVo.fndMemo}"/></textarea>
					</td>
				</tr>
			 </table>
		</div>

		<%
	// 	}
	    %>
		</c:otherwise>
	</c:choose>

	</div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript">
var def1;
var def2;
var def3;
var def4;

	$(document).ready(function () {
		// DATE PICKER
		compareSEDatepicker('datepicker-compare');
		$('.ui-datepicker-trigger-compare').on('click', function(){
			$(this).datepicker('show');
		});

		initPrepaymentRegisteDetailBankPopupSheet();
		getFundBeforeList()


		var f = document.prepaymentRegisteDetailPopupForm;

		doDayCheck(f.fndDay1.value, f.fndDay2.value, f.fndDay3.value, f.fndDay4.value);

 		if(f.fndLast.value < parseFloat(getDate())){
 			f.menu_01.disabled = true;
 			f.menu_02.disabled = true;
 			f.menu_03.disabled = true;
 			f.menu_04.disabled = true;

 			f.menu_01.checked = false;
 			f.menu_02.checked = false;
 			f.menu_03.checked = false;
 			f.menu_04.checked = false;
 		}

		checkTitle('1');

	});

	// Sheet의 초기화 작업
	function initPrepaymentRegisteDetailBankPopupSheet() {
		var ibHeader = new IBHeader();
		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1,  MouseHoverMode: 2, NoFocusMode : 0});

		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"삭제",          	Type:"DelCheck",  	Hidden:0, Width:60,   Align:"Center",  SaveName:"chk",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 });
		ibHeader.addHeader({Header:"상태",          	Type:"Status",    	Hidden:1, Width:20,   Align:"Center",  SaveName:"status",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1 });
		ibHeader.addHeader({Header:"중도상환일",      	Type:"Date", 		Hidden:0, Width:150,  Align:"Center",  SaveName:"fndReddt",     KeyField:1,   CalcLogic:"",   Format:"yyyy-MM-dd",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
		ibHeader.addHeader({Header:"중도상환액",      	Type:"Float",     	Hidden:0, Width:300,  Align:"Right",   SaveName:"fndRedamt",    KeyField:1,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
		ibHeader.addHeader({Header:"융자년도",       	Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"fndYear",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"융자월",        	Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"fndMonth",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업고유번호",    	Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"fndTracd",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"은행코드",         Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"fndBank",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"융자차수",         Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"loanSeq",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
		ibHeader.addHeader({Header:"중도상환일(KEY)",   Type:"Text",      	Hidden:1, Width:120,  Align:"Center",  SaveName:"fndReddtSeq",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });


		var sheetId = "prepaymentRegisteDetailPopupSheet";
		var container = $("#"+sheetId)[0];
		if (typeof prepaymentRegisteDetailPopupSheet !== 'undefined' && typeof prepaymentRegisteDetailPopupSheet.Index !== 'undefined') {
			prepaymentRegisteDetailPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);

	};

	// 중도상환 조회
	function getFundBeforeList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/prepaymentRegisteDetailList.do" />'
			, data : $('#prepaymentRegisteDetailPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				prepaymentRegisteDetailPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}


	//상환내역저장
	function doSave(){

		var f = document.prepaymentRegisteDetailPopupForm;

		if(!doValidFormRequired(f)){
			return;
		}

		if(!valueCheck()){
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		if (!disabledFalse()){return;}
		var pParamData = $('#prepaymentRegisteDetailPopupForm').serializeObject();
		if (!disabledTrue()){return;}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/prepaymentRegisteDetailSave.do" />'
			, data : JSON.stringify(pParamData)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('저장되었습니다.');
				window.location.reload();
			}
		});

	}

	function disabledTrue() {
		$("#fndYdt1").attr("disabled", true);
		$("#fndYdt2").attr("disabled", true);
		$("#fndYdt3").attr("disabled", true);
		$("#fndYdt4").attr("disabled", true);
		return true;
	}

	function disabledFalse() {
		$("#fndYdt1").attr("disabled", false);
		$("#fndYdt2").attr("disabled", false);
		$("#fndYdt3").attr("disabled", false);
		$("#fndYdt4").attr("disabled", false);
		return true;
	}

	//은행변경 저장
	function doBankSave(){

		var f = document.prepaymentRegisteDetailPopupForm;

		if(f.newFndBank.value == "" || f.newFndBank.value == null){
			alert("은행을 선택해주세요.");
			f.newFndBank.focus();
			return;
		}

		if(f.newFndSbank.value == "" || f.newFndSbank.value == null){
			alert("지점을 입력해주세요.");
			f.newFndSbank.focus();
			return;
		}

		if(f.newYdtDate.value == "" || f.newYdtDate.value == null){
			alert("기준일을 선택해 주세요.");
			f.newYdtDate.focus();
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		var pParamData = $('#prepaymentRegisteDetailPopupForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/prepaymentRegisteDetailBankSave.do" />'
			, data : JSON.stringify(pParamData)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('저장되었습니다.');
				window.location.reload();
			}
		});

	}

	//은행 삭제
	function doBankDelete(){

		var f = document.form1;
		if(!confirm("변경된 은행 내역을 복구하겠습니까?")){
			return;
		}

		var pParamData = $('#prepaymentRegisteDetailPopupForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/prepaymentRegisteDetailBankDelete.do" />'
			, data : JSON.stringify(pParamData)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('삭제되었습니다.');
				window.location.reload();
			}
		});
	}

	//중도상환 저장
	function doSheetSave() {
		var sheetObj = prepaymentRegisteDetailPopupSheet;

		if (!sheetValueCheck()) {
			return;
		}

		var f = document.prepaymentRegisteDetailPopupForm;
		var fnd_redamt_sum = 0;
		if (sheetObj.LastRow() > 0) {
			for (var i = 1; sheetObj.LastRow() >= i; i++) {
				if(sheetObj.GetCellValue(i, 'status') == 'I') {
					fnd_redamt_sum = fnd_redamt_sum + parseFloat(sheetObj.GetCellValue(i, 'fndRedamt'));
				}
			}
		}
		f.iFndRedamt.value = fnd_redamt_sum;

		if (sheetObj.LastRow() > 0) {
			var totMoney =  '<c:out value="${fundVo.vfndSum2}"/>';//총상환액
			var remainMoney = '<c:out value="${fundVo.vfndBal}"/>';//잔액

			var numberTot = remainMoney.replace(/,/g, '').trim();
			var numRemain = fnd_redamt_sum.toString().replace(/,/g, '').trim();

			if ( parseFloat(numberTot) < parseFloat(numRemain) ) {
				alert('중도 상환 금액이 총상환금액 보다 큼니다.');
				return;
			}
		}

		if (sheetObj.LastRow() == 0) {
			alert('중도 상환내역이 없습니다.');

			return;
		}

		if (!confirm('저장하시겠습니까?')) {
			return;
		}

		var saveJson = prepaymentRegisteDetailPopupSheet.GetSaveJson();
		var ccf = getSaveDataSheetList('prepaymentRegisteDetailPopupForm', saveJson);

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/prepaymentRegisteDetailSheetSave.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('저장되었습니다.');

				window.location.reload();

				checkTitle('2');
			}
		});
	}

	function doReload(){

		var f = document.prepaymentRegisteDetailPopupForm;

<%-- 		var url = "<%=screenUrl%>.screen"; --%>


		url += "?fnd_year="+f.fndYear.value;
	    url += "&fnd_month="+f.fndMonth.value;
	    url += "&fnd_tracd="+f.fndTracd.value;
	    url += "&fnd_bank="+f.fndBank.value;
	    url += "&loan_seq="+f.loanSeq.value;

		f.action = url;

		f.target = "modal";
		window.name = "modal";

		f.submit();

	}

	//추가입력
	function doInsert() {
		var sheetObj = prepaymentRegisteDetailPopupSheet;
		var f = document.prepaymentRegisteDetailPopupForm;

		if(f.insertKey.value == "Y"){
			return;
		}

		f.insertKey.value = "Y";

// 		sheetObj.DataAutoTrim = false;
		sheetObj.SetDataAutoTrim(false);
		var rowIndex = sheetObj.DataInsert();


		sheetObj.SetCellEditable(rowIndex, "chk", false);
		sheetObj.SetCellEditable(rowIndex, "fndReddt",  true);
		sheetObj.SetCellEditable(rowIndex, "fndRedamt",  true);
		sheetObj.SelectCell(rowIndex, "fndReddt");

	}

	//검색
	function doSearch(sheetObj) {

		var f = document.prepaymentRegisteDetailPopupForm;

		getFundBeforeList();
<%-- 	    searchIBSheet("<%=screenUrl%>Data.screen", "<%=screenName%>Data", f, sheetObj);		 --%>

	}

	function valueCheck(){


		var f = document.prepaymentRegisteDetailPopupForm;


		if(parseFloat(f.hFndYdt1.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt1.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			return false;

		}

		if(parseFloat(f.hFndYdt2.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt2.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			return false;

		}

		if(parseFloat(f.hFndYdt3.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt3.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			return false;

		}

		if(parseFloat(f.hFndYdt4.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt4.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			return false;

		}

		if(f.fndDay1.value == "1" || f.fndDay1.value == "7"){
			alert("1차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
			f.fndYdt1.focus();
			return false;
		}

		if(f.fndDay2.value == "1" || f.fndDay2.value == "7"){
			alert("2차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
			f.fndYdt2.focus();
			return false;
		}

		if(f.fndDay3.value == "1" || f.fndDay3.value == "7"){
			alert("3차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
			f.fndYdt3.focus();
			return false;
		}

		if(f.fndDay4.value == "1" || f.fndDay4.value == "7"){
			alert("4차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
			f.fndYdt4.focus();
			return false;
		}

		var fnd_amt1 = parseFloat(f.fndYamt1.value.replace(/,/gi ,""));
		var fnd_amt2 = parseFloat(f.fndYamt2.value.replace(/,/gi ,""));
		var fnd_amt3 = parseFloat(f.fndYamt3.value.replace(/,/gi ,""));
		var fnd_amt4 = parseFloat(f.fndYamt4.value.replace(/,/gi ,""));
		var fnd_redamt = parseFloat(f.hFndRedamt.value.replace(/,/gi ,""));


		var fnd_sum = fnd_amt1 + fnd_amt2 + fnd_amt3 + fnd_amt4 + fnd_redamt;


		if(parseFloat(f.hFndFinamt.value.replace(/,/gi ,"")) != fnd_sum){
			alert("정기상환 금액이 융자액과 맞지않습니다.");
			return false;
		}

		return true;

	}



	function sheetCheck(sheetObj, key){

		if(sheetObj.LastRow() > 0){

			for(var i = 1; sheetObj.LastRow() >= i; i++){
				sheetObj.SetRowEditable(i, key);
				//alert(sheetObj.CellValue(i, "CHK"));
				sheetObj.SetCellValue(i, "chk", 0);
			}

		}

	}




	function checkTitle(val){
		var f = document.prepaymentRegisteDetailPopupForm;

		var sheetObj = prepaymentRegisteDetailPopupSheet;

		// 정기상환 체크시 (checked)
		if(val == "1" && f.menu_01.checked){
			def1 = $("#fndYamt1").val();
			def2 = $("#fndYamt2").val();
			def3 = $("#fndYamt3").val();
			def4 = $("#fndYamt4").val();

			f.menu_02.checked = false;
			f.menu_03.checked = false;

			f.coNmKor.readOnly = false;
			f.ceoNmKor.readOnly = false;
			f.fndSbank.readOnly = false;

			f.coNmKor.style.backgroundColor = "#ffffff";
			f.ceoNmKor.style.backgroundColor = "#ffffff";
			f.fndSbank.style.backgroundColor = "#ffffff";


			f.fndMemo.readOnly = false;
			f.fndMemo.style.backgroundColor = "#ffffff";

			document.getElementById("button_01").style.display = "";

			document.getElementById("button_02").style.display = "none";
			document.getElementById("button_03").style.display = "none";
			document.getElementById("button_04").style.display = "none";

			// 직접입력 체크시
			if(f.menu_04.checked){
				f.fndYamt1.readOnly = false;
				f.fndYamt2.readOnly = false;
				f.fndYamt3.readOnly = false;
				f.fndYamt4.readOnly = false;

				f.fndYamt1.style.backgroundColor = "#ffffff";
				f.fndYamt2.style.backgroundColor = "#ffffff";
				f.fndYamt3.style.backgroundColor = "#ffffff";
				f.fndYamt4.style.backgroundColor = "#ffffff";

				document.getElementById("fnd_ydtImg1").style.display = "";
				document.getElementById("fnd_ydtImg2").style.display = "";
				document.getElementById("fnd_ydtImg3").style.display = "";
				document.getElementById("fnd_ydtImg4").style.display = "";
			}

			// 적접입력 미체크시
			if(!f.menu_04.checked){
				f.fndYamt1.readOnly = true;
				f.fndYamt2.readOnly = true;
				f.fndYamt3.readOnly = true;
				f.fndYamt4.readOnly = true;

				f.fndYamt1.style.backgroundColor = "#DEDEDE";
				f.fndYamt2.style.backgroundColor = "#DEDEDE";
				f.fndYamt3.style.backgroundColor = "#DEDEDE";
				f.fndYamt4.style.backgroundColor = "#DEDEDE";

				document.getElementById("fnd_ydtImg1").style.display = "none";
				document.getElementById("fndYdt1").disabled = true;

				document.getElementById("fnd_ydtImg2").style.display = "none";
				document.getElementById("fndYdt2").disabled = true;

				document.getElementById("fnd_ydtImg3").style.display = "none";
				document.getElementById("fndYdt3").disabled = true;

				document.getElementById("fnd_ydtImg4").style.display = "none";
				document.getElementById("fndYdt4").disabled = true;
			}

		// 정기상환 체크시 (no checked)
		} else if(val == "1" && !f.menu_01.checked){
			f.coNmKor.readOnly = true;
			f.ceoNmKor.readOnly = true;
			f.fndSbank.readOnly = true;

			f.coNmKor.style.backgroundColor = "#DEDEDE";
			f.ceoNmKor.style.backgroundColor = "#DEDEDE";
			f.fndSbank.style.backgroundColor = "#DEDEDE";


			f.fndMemo.readOnly = true;
			f.fndMemo.style.backgroundColor = "#DEDEDE";

			document.getElementById("button_01").style.display = "none";


			f.fndYamt1.readOnly = true;
			f.fndYamt2.readOnly = true;
			f.fndYamt3.readOnly = true;
			f.fndYamt4.readOnly = true;

			f.fndYamt1.style.backgroundColor = "#DEDEDE";
			f.fndYamt2.style.backgroundColor = "#DEDEDE";
			f.fndYamt3.style.backgroundColor = "#DEDEDE";
			f.fndYamt4.style.backgroundColor = "#DEDEDE";

			document.getElementById("fnd_ydtImg1").style.display = "none";
			document.getElementById("fndYdt1").disabled = true;
			document.getElementById("fnd_ydtImg2").style.display = "none";
			document.getElementById("fndYdt2").disabled = true;
			document.getElementById("fnd_ydtImg3").style.display = "none";
			document.getElementById("fndYdt3").disabled = true;
			document.getElementById("fnd_ydtImg4").style.display = "none";
			document.getElementById("fndYdt4").disabled = true;
		}

		// 중도상환 체크시
		if(val == "2" && f.menu_02.checked){
			f.menu_01.checked = false;
			f.menu_03.checked = false;

			document.getElementById("button_02").style.display = "";
			document.getElementById("button_03").style.display = "";

			document.getElementById("button_01").style.display = "none";
			document.getElementById("button_04").style.display = "none";

			// 정기상환 잠금
			f.coNmKor.readOnly = true;
			f.ceoNmKor.readOnly = true;
			f.fndSbank.readOnly = true;

			f.coNmKor.style.backgroundColor = "#DEDEDE";
			f.ceoNmKor.style.backgroundColor = "#DEDEDE";
			f.fndSbank.style.backgroundColor = "#DEDEDE";


			f.fndMemo.readOnly = true;
			f.fndMemo.style.backgroundColor = "#DEDEDE";

			document.getElementById("button_01").style.display = "none";

			f.fndYamt1.readOnly = true;
			f.fndYamt2.readOnly = true;
			f.fndYamt3.readOnly = true;
			f.fndYamt4.readOnly = true;

			f.fndYamt1.style.backgroundColor = "#DEDEDE";
			f.fndYamt2.style.backgroundColor = "#DEDEDE";
			f.fndYamt3.style.backgroundColor = "#DEDEDE";
			f.fndYamt4.style.backgroundColor = "#DEDEDE";

			document.getElementById("fnd_ydtImg1").style.display = "none";
			document.getElementById("fndYdt1").disabled = true;
			document.getElementById("fnd_ydtImg2").style.display = "none";
			document.getElementById("fndYdt2").disabled = true;
			document.getElementById("fnd_ydtImg3").style.display = "none";
			document.getElementById("fndYdt3").disabled = true;
			document.getElementById("fnd_ydtImg4").style.display = "none";
			document.getElementById("fndYdt4").disabled = true;

			// 은행변경 잠금
			f.newFndSbank.readOnly = true;
			f.newFndSbank.style.backgroundColor = "#DEDEDE";

			f.fndMemoBank.readOnly = true;
			f.fndMemoBank.style.backgroundColor = "#DEDEDE";

			sheetCheck(sheetObj, true);
		} else if(val == "2" && !f.menu_02.checked){
			document.getElementById("button_02").style.display = "none";
			document.getElementById("button_03").style.display = "none";

			if (def1) {
				$("#fndYamt1").val(def1);
			}
			if (def2) {
				$("#fndYamt2").val(def2);
			}
			if (def3) {
				$("#fndYamt3").val(def3);
			}
			if (def4) {
				$("#fndYamt4").val(def4);
			}
		}

		// 은행변경 체크시
		if(val == "3" && f.menu_03.checked){
			f.menu_01.checked = false;
			f.menu_02.checked = false;

			document.getElementById("button_04").style.display = "";

			document.getElementById("button_01").style.display = "none";
			document.getElementById("button_02").style.display = "none";
			document.getElementById("button_03").style.display = "none";

			f.fndMemoBank.readOnly = false;
			f.fndMemoBank.style.backgroundColor = "#ffffff";

			f.newFndSbank.readOnly = false;
			f.newFndSbank.style.backgroundColor = "#ffffff";
		} else if(val == "3" && !f.menu_03.checked){
			document.getElementById("button_04").style.display = "none";

			f.newFndSbank.readOnly = true;
			f.newFndSbank.style.backgroundColor = "#DEDEDE";

			f.fndMemoBank.readOnly = true;
			f.fndMemoBank.style.backgroundColor = "#DEDEDE";
		}

		// 직접입력 체크시
		if(val == "4" && f.menu_01.checked && f.menu_04.checked){
			f.fndYamt1.readOnly = false;
			f.fndYamt2.readOnly = false;
			f.fndYamt3.readOnly = false;
			f.fndYamt4.readOnly = false;

			f.fndYamt1.style.backgroundColor = "#ffffff";
			f.fndYamt2.style.backgroundColor = "#ffffff";
			f.fndYamt3.style.backgroundColor = "#ffffff";
			f.fndYamt4.style.backgroundColor = "#ffffff";

			document.getElementById("fnd_ydtImg1").style.display = "";
			document.getElementById("fndYdt1").disabled = false;
			document.getElementById("fnd_ydtImg2").style.display = "";
			document.getElementById("fndYdt2").disabled = false;
			document.getElementById("fnd_ydtImg3").style.display = "";
			document.getElementById("fndYdt3").disabled = false;
			document.getElementById("fnd_ydtImg4").style.display = "";
			document.getElementById("fndYdt4").disabled = false;
		}

		if(val == "4" && f.menu_01.checked && !f.menu_04.checked){
			f.fndYamt1.readOnly = true;
			f.fndYamt2.readOnly = true;
			f.fndYamt3.readOnly = true;
			f.fndYamt4.readOnly = true;

			f.fndYamt1.style.backgroundColor = "#DEDEDE";
			f.fndYamt2.style.backgroundColor = "#DEDEDE";
			f.fndYamt3.style.backgroundColor = "#DEDEDE";
			f.fndYamt4.style.backgroundColor = "#DEDEDE";

			document.getElementById("fnd_ydtImg1").style.display = "none";
			document.getElementById("fndYdt1").disabled = true;
			document.getElementById("fnd_ydtImg2").style.display = "none";
			document.getElementById("fndYdt2").disabled = true;
			document.getElementById("fnd_ydtImg3").style.display = "none";
			document.getElementById("fndYdt3").disabled = true;
			document.getElementById("fnd_ydtImg4").style.display = "none";
			document.getElementById("fndYdt4").disabled = true;
		}

		if(val == "4" && !f.menu_01.checked && !f.menu_04.checked){
			f.fndYamt1.readOnly = true;
			f.fndYamt2.readOnly = true;
			f.fndYamt3.readOnly = true;
			f.fndYamt4.readOnly = true;

			f.fndYamt1.style.backgroundColor = "#DEDEDE";
			f.fndYamt2.style.backgroundColor = "#DEDEDE";
			f.fndYamt3.style.backgroundColor = "#DEDEDE";
			f.fndYamt4.style.backgroundColor = "#DEDEDE";

			document.getElementById("fnd_ydtImg1").style.display = "none";
			document.getElementById("fndYdt1").disabled = true;
			document.getElementById("fnd_ydtImg2").style.display = "none";
			document.getElementById("fndYdt2").disabled = true;
			document.getElementById("fnd_ydtImg3").style.display = "none";
			document.getElementById("fndYdt3").disabled = true;
			document.getElementById("fnd_ydtImg4").style.display = "none";
			document.getElementById("fndYdt4").disabled = true;
		}

		sheetCheck(sheetObj, false);
		doSearch(sheetObj);

		f.insertKey.value = "N";
		//f.FND_REDAMT.value = f.H_FND_REDAMT.value;

	}


	function sheetValueCheck(){

		var sheetObj = prepaymentRegisteDetailPopupSheet;


		if(sheetObj.LastRow() > 0){

			for(var i = 1; sheetObj.LastRow() >= i; i++){


				if(sheetObj.GetCellValue(i, "fndReddt") != ""){

					if(parseFloat(sheetObj.GetCellValue(i, "fndReddt").substring(4, 6)) > 12 || parseFloat(sheetObj.GetCellValue(i, "fndReddt").substring(4, 6)) <= 0){
						alert("월은 1~12 까지 입력가능합니다.");
						sheetObj.SelectCell(i, "fndReddt");
						return false;

					}else{

						if(sheetObj.GetCellValue(i, "fndReddt").substring(6, 8) > dlgLastDay(sheetObj.GetCellValue(i, "fndReddt").substring(0, 6)) ){
							alert(sheetObj.GetCellValue(i, "fndReddt").substring(0, 4)+"년 "+sheetObj.GetCellValue(i, "fndReddt").substring(4, 6)+"월은 "+dlgLastDay(sheetObj.GetCellValue(i, "fndReddt").substring(0, 6))+"일 까지 있습니다.");
							sheetObj.SelectCell(i, "fndReddt");
							return false;
						}else if(sheetObj.GetCellValue(i, "fndReddt").length != 8){
							alert("날짜를 제대로 입력해주세요");
							sheetObj.SelectCell(i, "fndReddt");
							return false;
						}

					}

					for(var j = i; sheetObj.LastRow() > j; j++){

	    				if(sheetObj.GetCellValue(i, "fndReddt") == sheetObj.GetCellValue(j+1, "fndReddt")){
	    					alert("중도상환일자를 중복해서 입력할 수 없습니다.");
	    					return false;
	    				}
	    			}
				}
			}
		}

		return true;

	}


	function doCal(row, col){

		var f = document.prepaymentRegisteDetailPopupForm;


		var sheetObj = prepaymentRegisteDetailPopupSheet;

		var fnd_yamt1 = parseFloat(f.hFndYamt1.value.replace(/,/gi, ''));
		var fnd_yamt2 = parseFloat(f.hFndYamt2.value.replace(/,/gi, ''));
		var fnd_yamt3 = parseFloat(f.hFndYamt3.value.replace(/,/gi, ''));
		var fnd_yamt4 = parseFloat(f.hFndYamt4.value.replace(/,/gi, ''));

		var fnd_ydt1 = parseFloat(f.fndYdt1.value.replace(/-/gi, ''));
		var fnd_ydt2 = parseFloat(f.fndYdt2.value.replace(/-/gi, ''));
		var fnd_ydt3 = parseFloat(f.fndYdt3.value.replace(/-/gi, ''));
		var fnd_ydt4 = parseFloat(f.fndYdt4.value.replace(/-/gi, ''));


		var fnd_sum1 = fnd_yamt1+ fnd_yamt2 + fnd_yamt3 + fnd_yamt4;
		var fnd_sum2 = fnd_yamt1+ fnd_yamt2 + fnd_yamt3;
		var fnd_sum3 = fnd_yamt1+ fnd_yamt2;
		var fnd_sum4 = fnd_yamt2 + fnd_yamt3 + fnd_yamt4;
		var fnd_sum5 = fnd_yamt3 + fnd_yamt4;

		var fnd_redamt = parseFloat(sheetObj.GetCellValue(row, "fndRedamt"));


		if( sheetObj.GetCellValue(row, "fndReddt") != "" && sheetObj.GetCellValue(row, "fndRedamt") != ""){

			if ( fnd_ydt1 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) ){
				if ( fnd_yamt1 <= fnd_redamt ){
					fnd_redamt = fnd_redamt - fnd_yamt1 ;
					f.fndYamt1.value = 0;
				} else {
					f.fndYamt1.value = plusComma(fnd_yamt1 - fnd_redamt) ;
					fnd_redamt = 0;
				}
			}else{

				f.fndYamt1.value = f.hFndYamt1.value;

			}

			if ( fnd_ydt2 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) ){
				if ( fnd_yamt2 <= fnd_redamt ){
					fnd_redamt = fnd_redamt - fnd_yamt2 ;
					f.fndYamt2.value = 0;
				} else{
					f.fndYamt2.value = plusComma(fnd_yamt2 - fnd_redamt) ;
					fnd_redamt = 0;
				}
			}else{

				f.fndYamt1.value = f.hFndYamt1.value;
				f.fndYamt2.value = f.hFndYamt2.value;

			}

			if ( fnd_ydt3 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) ){
				if ( fnd_yamt3 <= fnd_redamt ){
					fnd_redamt = fnd_redamt - fnd_yamt3 ;
					f.fndYamt3.value = 0;
				} else{
					f.fndYamt3.value = plusComma(fnd_yamt3 - fnd_redamt) ;
					fnd_redamt = 0;
				}
			}else{

				f.fndYamt1.value = f.hFndYamt1.value;
				f.fndYamt2.value = f.hFndYamt2.value;
				f.fndYamt3.value = f.hFndYamt3.value;

			}

			if ( fnd_ydt4 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) ){
				if( fnd_yamt4 < fnd_redamt ){

					alert("중도상환 금액이 잔액보다 많을 수 없습니다.");
					sheetObj.SetCellValue(row, "fndRedamt", 0);
					//sheetObj.GetCellValue(row, "fndRedamt");
					//sheetObj.SelectCell(row, "fndRedamt");
					f.fndYamt1.value = f.hFndYamt1.value;
					f.fndYamt2.value = f.hFndYamt2.value;
					f.fndYamt3.value = f.hFndYamt3.value;
					f.fndYamt4.value = f.hFndYamt4.value;
					return;

				}else{

					if ( fnd_yamt4 == fnd_redamt ){
						fnd_redamt = fnd_redamt - fnd_yamt4 ;
						f.fndYamt4.value = 0;
					} else{
						f.fndYamt4.value = plusComma(fnd_yamt4 - fnd_redamt) ;
						fnd_redamt = 0;
					}

				}

			}

			var fnd_redamt_sum = 0;

			if(sheetObj.LastRow() > 0){

				for(var i = 1; sheetObj.LastRow() >= i; i++){
					fnd_redamt_sum = fnd_redamt_sum + parseFloat(sheetObj.GetCellValue(i, "S_FND_REDAMT"));
				}

			}

			//alert(fnd_redamt_sum);


			f.iFndRedamt.value = fnd_redamt_sum;

		}

	}


	function doDelCal(row, col){

		var f = document.prepaymentRegisteDetailPopupForm;


		var sheetObj = prepaymentRegisteDetailPopupSheet;

		var fnd_yamt1 = parseFloat(f.hFndYamt1.value.replace(/,/gi, ''));
		var fnd_yamt2 = parseFloat(f.hFndYamt2.value.replace(/,/gi, ''));
		var fnd_yamt3 = parseFloat(f.hFndYamt3.value.replace(/,/gi, ''));
		var fnd_yamt4 = parseFloat(f.hFndYamt4.value.replace(/,/gi, ''));

		var fnd_ydt1 = parseFloat(f.fndYdt1.value.replace(/-/gi, ''));
		var fnd_ydt2 = parseFloat(f.fndYdt2.value.replace(/-/gi, ''));
		var fnd_ydt3 = parseFloat(f.fndYdt3.value.replace(/-/gi, ''));
		var fnd_ydt4 = parseFloat(f.fndYdt4.value.replace(/-/gi, ''));

		var fnd_redamt = parseFloat(sheetObj.GetCellValue(row, "fndRedamt"));

		var fnd_yamt =  parseFloat(f.fndYamt.value.replace(/,/gi, ''));

		f.fndYamt1.value = f.hFndYamt1.value;
		f.fndYamt2.value = f.hFndYamt2.value;
		f.fndYamt3.value = f.hFndYamt3.value;
		f.fndYamt4.value = f.hFndYamt4.value;

		if( sheetObj.GetCellValue(row, "fndReddt") != "" && sheetObj.GetCellValue(row, "fndRedamt") != ""){


			if ( fnd_ydt4 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) )
			{
				fnd_yamt4 = fnd_yamt4 + fnd_redamt ;
				if ( fnd_yamt4 > fnd_yamt )
				{
					fnd_redamt = fnd_yamt4 - fnd_yamt ;
					f.fndYamt4.value = plusComma(fnd_yamt) ;
				} else
				{
					if(fnd_redamt > 0){
						f.fndYamt4.value = plusComma(fnd_yamt4);
					}
					fnd_redamt = 0;
				}
			}

			if ( fnd_ydt3 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) )
			{
				fnd_yamt3 = fnd_yamt3 + fnd_redamt ;
				if ( fnd_yamt3 > fnd_yamt )
				{
					fnd_redamt = fnd_yamt3 - fnd_yamt ;
					f.fndYamt3.value = plusComma(fnd_yamt) ;
				} else
				{

					if(fnd_redamt > 0){
						f.fndYamt3.value = plusComma(fnd_yamt3);
					}
					fnd_redamt = 0;
				}
			}

			if ( fnd_ydt2 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) )
			{
				fnd_yamt2 = fnd_yamt2 + fnd_redamt ;
				if ( fnd_yamt2 > fnd_yamt )
				{
					fnd_redamt = fnd_yamt2 - fnd_yamt ;
					f.fndYamt2.value = plusComma(fnd_yamt) ;
				} else
				{
					if(fnd_redamt > 0){
						f.fndYamt2.value = plusComma(fnd_yamt2);
					}
					fnd_redamt = 0;
				}
			}


			if ( fnd_ydt1 > parseFloat(sheetObj.GetCellValue(row, "fndReddt")) )
			{
				fnd_yamt1 = fnd_yamt1 + fnd_redamt ;
				if ( fnd_yamt1 > fnd_yamt )
				{
					fnd_redamt = fnd_yamt1 - fnd_yamt ;
					f.fndYamt1.value = plusComma(fnd_yamt) ;
				} else
				{
					if(fnd_redamt > 0){
						f.fndYamt1.value = plusComma(fnd_yamt1);
					}
					fnd_redamt = 0;
				}
			}


			var fnd_redamt_sum = parseFloat(sheetObj.GetCellValue(row, "fndRedamt"));

		}

	}


	function doResetCal(row, cal){

		var f = document.prepaymentRegisteDetailPopupForm;

		f.fndYamt1.value = f.hFndYamt1.value;
		f.fndYamt2.value = f.hFndYamt2.value;
		f.fndYamt3.value = f.hFndYamt3.value;
		f.fndYamt4.value = f.hFndYamt4.value;
	}



	function doContent(){

		var f = document.prepaymentRegisteDetailPopupForm;

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 700;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = '/tfms/rpm/prepaymentRegisteDetailBankPopup.do';
		strUrl += "?fndYear="+f.fndYear.value;
		strUrl += "&fndMonth="+f.fndMonth.value;
		strUrl += "&fndTracd="+f.fndTracd.value;
		strUrl += "&fndBank="+f.fndBank.value;
		strUrl += "&loanSeq="+f.loanSeq.value;
		strUrl += "&fndFindt="+f.hFndFindt.value;

		window.open(strUrl, "prepaymentRegisteDetailBankPopup", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');

	}

	//달력 설정
	function compareSEDatepicker(className) {
		$('.' + className).datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString) {
				var thisDayName = $(this).attr('name');
				$('#' + thisDayName).val(dateString);

				fndDaySearch();



			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});
	}

	function fndDaySearch(){

		var f = document.prepaymentRegisteDetailPopupForm;

// 		submitXmlRequest("/tfms/rpm/FundDtSearch.screen", "FundDaySearch", f, "VALUEOBJECT");

		var pParamData = $('#prepaymentRegisteDetailPopupForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/fundDaySearch.do" />'
			, data : JSON.stringify(pParamData)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				var fndDay1 = data.result.fndDay1;
				var fndDay2 = data.result.fndDay2;
				var fndDay3 = data.result.fndDay3;
				var fndDay4 = data.result.fndDay4;

				doDayCheck(fndDay1, fndDay2, fndDay3, fndDay4);
			}
		});

	}

	//출력
	function doPrint(){

		var f = document.prepaymentRegisteDetailPopupForm;

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 700;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = '/tfms/rpm/prepaymentRegisteDetailPrintPopup.do';
		strUrl += "?fndYear="+f.fndYear.value;
		strUrl += "&fndMonth="+f.fndMonth.value;
		strUrl += "&fndTracd="+f.fndTracd.value;
		strUrl += "&fndBank="+f.fndBank.value;
		strUrl += "&loanSeq="+f.loanSeq.value;
		strUrl += "&fnd_findt="+f.hFndFindt.value;

		window.open(strUrl, "prepaymentRegisteDetailPrintPopup", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');
	}


	function doDayCheck(fnd_day1, fnd_day2, fnd_day3, fnd_day4){

		var f = document.prepaymentRegisteDetailPopupForm;

		f.fndDay1.value = fnd_day1;
		f.fndDay2.value = fnd_day2;
		f.fndDay3.value = fnd_day3;
		f.fndDay4.value = fnd_day4;

		if(fnd_day1 == "7"){
			f.fndYdt1.style.color = "#0000FF";
		}else if(fnd_day1 == "1"){
			f.fndYdt1.style.color = "#FF0000";
		}else{
			f.fndYdt1.style.color = "#595A5A";
		}

		if(fnd_day2 == "7"){
			f.fndYdt2.style.color = "#0000FF";
		}else if(fnd_day2 == "1"){
			f.fndYdt2.style.color = "#FF0000";
		}else{
			f.fndYdt2.style.color = "#595A5A";
		}

		if(fnd_day3 == "7"){
			f.fndYdt3.style.color = "#0000FF";
		}else if(fnd_day3 == "1"){
			f.fndYdt3.style.color = "#FF0000";
		}else{
			f.fndYdt3.style.color = "#595A5A";
		}

		if(fnd_day4 == "7"){
			f.fndYdt4.style.color = "#0000FF";
		}else if(fnd_day4 == "1"){
			f.fndYdt4.style.color = "#FF0000";
		}else{
			f.fndYdt4.style.color = "#595A5A";
		}
	}

	function prepaymentRegisteDetailPopupSheet_OnSearchEnd(code, msg) {


		if(prepaymentRegisteDetailPopupSheet.RowCount() > 0){

			for(var i = 0; prepaymentRegisteDetailPopupSheet.RowCount() >= i; i++){
				if(document.prepaymentRegisteDetailPopupForm.menu_02.checked == true){
					prepaymentRegisteDetailPopupSheet.SetCellEditable(i, "chk", true);
				}
			}

		}
    }

	function prepaymentRegisteDetailPopupSheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		var sName = prepaymentRegisteDetailPopupSheet.ColSaveName(Col);

		if(sName == "fndReddt"){
			if(document.prepaymentRegisteDetailPopupForm.menu_04.checked == false){
				doCal(Row, Col);
			}
		}

		if(sName == "fndRedamt"){
			if(document.prepaymentRegisteDetailPopupForm.menu_04.checked == false){
				doCal(Row, Col);
			}
		}

		if(sName == "chk"){

			if(Row != prepaymentRegisteDetailPopupSheet.RowCount()){
				prepaymentRegisteDetailPopupSheet.SetCellValue(Row, "chk",  "0");
			}else{

				if(document.prepaymentRegisteDetailPopupForm.menu_04.checked == false){

					if(prepaymentRegisteDetailPopupSheet.GetCellValue(Row, "chk") == "1"){
						doDelCal(Row, Col);
					}else if(prepaymentRegisteDetailPopupSheet.GetCellValue(Row, "chk") == "0"){
						doResetCal(Row, Col);
					}
				}
			}
		}

	}

	function doClose(){
		window.close();
// 		closeLayerPopup();
	}

</script>