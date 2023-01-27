<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<%
	/**
	 * @Class Name : areaSuggestListDetail.jsp
	 * @Description : 분야별 전문가 자문 상세 화면
	 * @Modification Information
	 * @
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2021.10.06	양지환		최초 생성
	 *
	 * @author 양지환
	 * @since 2021.10.06
	 * @version 1.0
	 * @see
	 *
	 */
%>
<script type="text/javascript">
	function press(event) {
		if (event.keyCode==13) {

		}
	}

	function fn_list() {
		location.href = "/tradeSOS/area/areaSuggestList.do";
	}

	// 레이어 팝업
	function openLayer(IdName){
		var openPop = $('#' + IdName);
		openPop.show();
	}
	function closePop(IdName) {
		var openPop = $('#' + IdName);
		openPop.hide();
	}

</script>

<!-- 분야별전문가 자문 - 상세 -->
<div class="page_tradesos">
	<!-- 페이지 위치 -->
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
		<c:if test="${resultData.onLine eq 'N'}">
			<button type="button" class="btn_sm btn_primary" onclick="fnSubmit();" >저장</button>
		</c:if>
			<button type="button" class="btn_sm btn_primary" onclick="openAnswerPopup();">답변</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
		</div>
	</div>
	<form id="frm" name="frm" method="post">
		<input type="hidden" id="reqId" name="reqId" value="<c:out value="${resultData.reqId}"/>"/>
		<input type="hidden" name="answerId" value="<c:out value="${resultAnswerData.answerId}"/>"/>
		<input type="hidden" name="eventSdcit" id="eventSdcit" value="Update"/>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">신청자 정보</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:15%">
					<col>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">회사명</th>
						<td>
							<div class="flex align_center">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<span class="form_search w100p">
										<input class="form_text w100p" type="text" id="companyNm" name="companyNm" value="<c:out value="${resultData.companyNm}"/>" maxlength="70">
										<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(1);"></button>
									</span>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.companyNm}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
						<th scope="row">무역업고유번호</th>
						<td>
							<div class="flex align_center">
								<c:choose>
									<c:when test="${resultData.onLine eq 'N'}">
										<span class="form_search w100p">
											<input type="text"  id="tradeNum" name="tradeNo" class="form_text w100p" onkeypress="fnNumber(this)" value="<c:out value="${resultData.tradeNo}"/>" maxlength="20">
											<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(2);"></button>
										</span>
									</c:when>
									<c:otherwise>
										<c:out value="${resultData.tradeNo}"/>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">대표자</th>
						<td>
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<input type="text"  id="companyPresident" name="companyPresident" class="form_text w100p" value="<c:out value="${resultData.companyPresident}"/>" maxlength="30">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.companyPresident}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">사업자등록번호</th>
						<td>
							<div class="flex align_center">
									<c:choose>
										<c:when test="${resultData.onLine eq 'N'}">
											<span class="form_search w100p">
												<input type="text"  id="regNo" name="companyNo" class="form_text w100p" onkeypress="fnNumber(this)" value="<c:out value="${resultData.companyNo}"/>" maxlength="20">
												<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(3);"></button>
											</span>
										</c:when>
										<c:otherwise>
											<c:out value="${resultData.companyNo}"/>
										</c:otherwise>
									</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">회사주소</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<input type="text" id="companyAddr" name="companyAddr" class="form_text w100p" value="<c:out value="${resultData.companyAddr}"/>" maxlength="200">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.companyAddr}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row">이름</th>
						<td>
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<input type="text"  name="caerNm" class="form_text w100p" value="<c:out value="${resultData.caerNm}"/>" maxlength="50">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.caerNm}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">이메일</th>
						<td>
							<div class="flex align_center form_row">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<input type="text" name="email1" class="form_text" value="<c:out value="${fn:split(resultData.email,'@')[0]}"/>" maxlength="49">
									<div class="spacing">@</div>
									<input type="text" name="email2" class="form_text" value="<c:out value="${fn:split(resultData.email,'@')[1]}"/>" maxlength="50">
									<select id="selectEmail" class="form_select">
										<option value="">직접입력</option>
										<c:forEach var="data" items="${code070}" varStatus="status">
											<option value="${data.cdNm}" <c:out value="${fn:split(resultData.email,'@')[1] == data.cdNm ? 'selected' : ''}"/>>${data.cdNm}</option>
										</c:forEach>
									</select>
									<input type="hidden" name="email" value="<c:out value="${resultData.email}"/>"/>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.email}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">핸드폰</th>
						<td>
							<div class="form_row" style="width:300px;">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<select name="cellula1" class="form_select">
										<option value="" selected="">선택</option>
										<c:forEach var="data" items="${code132}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.applyCell,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="cellula2" class="form_text" maxlength="4" onkeypress="fnNumber(this)" value="<c:out value="${fn:split(resultData.applyCell,'-')[1]}"/>">
									<input type="text" name="cellula3" class="form_text" maxlength="4" onkeypress="fnNumber(this)" value="<c:out value="${fn:split(resultData.applyCell,'-')[2]}"/>">
									<input type="hidden"  name="cellula" value="<c:out value="${resultData.applyCell}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.applyCell}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
						<th scope="row">전화번호</th>
						<td>
							<div class="form_row" style="width:300px;">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<select name="tel1" class="form_select">
										<option value="">선택</option>
										<c:forEach var="data" items="${code130}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.applyTel,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="tel2" class="form_text" maxlength="4" onkeypress="fnNumber(this)" value="<c:out value="${fn:split(resultData.applyTel,'-')[1]}"/>">
									<input type="text" name="tel3" class="form_text" maxlength="4" onkeypress="fnNumber(this)" value="<c:out value="${fn:split(resultData.applyTel,'-')[2]}"/>">
									<input type="hidden"  name="tel" value="<c:out value="${resultData.applyTel}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.applyTel}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">신청 내역</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:15%">
					<col>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"> 접수채널</th>
						<td><c:out value="${resultData.chnnelTpNm}"/></td>
						<th scope="row">상담분야</th>
						<td>
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<select name="reqTp"  class="form_select">
										<option value="" selected="selected">선택하세요</option>
										<c:forEach var="data" items="${code026}" varStatus="status">
											<option value="<c:out value="${data.cdId}"/>" <c:out value="${resultData.reqTp eq data.cdId ? 'selected' : '' }"/>><c:out value="${data.cdNm}"/></option>
										</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqTpNm}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row">공개여부</th>
						<td>
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<label class="label_form" for="radio1_1" >
										<input type="radio" class="form_radio" name="openFg" id="radio1_1" value="Y" <c:out value="${resultData.openFg eq 'Y' ? 'checked' : '' }"/>>
										<span class="label">공개</span>
									</label>
									<label for="radio1_2" class="label_form">
										<input type="radio" class="form_radio" name="openFg" id="radio1_2" value="N" <c:out value="${resultData.openFg eq 'N' ? 'checked' : '' }"/>>
										<span class="label">비공개</span>
									</label>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.openFg eq 'Y'? '공개' : '비공개' }"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">상태</th>
						<td><c:out value="${resultData.reqStatusNm}"/></td>
					</tr>
					<tr>
						<th scope="row"> 제목</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<input type="text"  name="reqTitle" class="form_text w100p" value="<c:out value="${resultData.reqTitle}"/>" maxlength="1200">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqTitle}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row">상세</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${resultData.onLine eq 'N'}">
									<textarea  name="reqContent" rows="3" class="form_textarea" maxlength="1000000" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.reqContent}"/></textarea>
								</c:when>
								<c:otherwise>
									${fn:replace(resultData.reqContent, newLineChar, "<br/>")}
								</c:otherwise>
							</c:choose>

						</td>
					</tr>
				</tbody>
			</table><!-- // 분야별전문가 자문 상세 테이블-->
		</div>
	</form>
	<div class="cont_block mt-40">
		<div class="tit_bar">
			<h3 class="tit_block">답변 내역</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:7.5%">
				<col style="width:7.5%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" colspan="2">담당 전문가</th>
					<td><c:out value="${resultAnswerData.admNm}"/></td>
					<th scope="row">답변 일자</th>
					<td><c:out value="${resultAnswerData.answerDt}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">답변 제목</th>
					<td colspan="3"><c:out value="${resultAnswerData.answerTitle}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">답변 내용</th>
					<td colspan="3">
	                    ${fn:replace(resultAnswerData.answerContent, newLineChar, "<br/>")}
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">관련법률</th>
					<th scope="row">법률</th>
					<td colspan="3"><c:out value="${resultAnswerData.law}"/></td>
				</tr>
				<tr>
					<th scope="row">조항</th>
					<td colspan="3"><c:out value="${resultAnswerData.lawClause}"/></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">기타참고사항</th>
					<td colspan="3"><c:out value="${resultAnswerData.dscr}"/></td>
				</tr>
			</tbody>
		</table><!-- // 분야별전문가 자문 검토결과 테이블-->
	</div>
	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">업체 이력</h3>
		</div>
		<div id='companyHistorySheet' class="colPosi"></div>
		<!-- .paging-->
		<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
		<!-- //.paging-->
	</div>
</div> <!-- // .page_tradesos -->
<form name="companyHistorySearchForm" id="companyHistorySearchForm" action ="" method="get">
	<input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
	<input type="hidden" name="tradeNo" value="<c:out value="${resultData.tradeNo}"/>"/>
</form>

<form id="searchForm">
	<input type="hidden" name="pageIndex" value="${resultData.pageIndex}" />
	<input type="hidden" name="frDt" value="${resultData.frDt}" />
	<input type="hidden" name="toDt" value="${resultData.toDt}" />
	<input type="hidden" name="reqTp" value="${resultData.reqTp}" />
	<input type="hidden" name="chnnelTp" value="${resultData.chnnelTp}" />
	<input type="hidden" name="reqStatus" value="${resultData.reqStatus}" />
	<input type="hidden" name="caerNm" value="${resultData.caerNm}" />
	<input type="hidden" name="tradeNo" value="${resultData.tradeNo}" />
	<input type="hidden" name="reqTitle" value="${resultData.reqTitle}" />
	<input type="hidden" name="resultQ" value="${resultData.resultQ}" />
	<input type="hidden" name="openFg" value="${resultData.openFg}" />
</form>

<script type="text/javascript">
	$(document).ready(function()
	{							//IBSheet 호출
		f_Init_tblSheet();		// 리스트  Sheet 셋팅
		getList();				// 목록 조회
	});

	function f_Init_tblSheet()
	{
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "ID"		, SaveName: "reqId"			, Align: "Center"	, Width: 50		, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "번호"		, SaveName: "rnum"			, Align: "Center"	, Width: 50});
		ibHeader.addHeader({Type: "Text", Header: "등록일"	, SaveName: "questionDt"	, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "제목"		, SaveName: "reqTitle"		, Align: "Left"		, Width: 300	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "신청자명"	, SaveName: "caerNm"		, Align: "Center"	, Width: 70});
		ibHeader.addHeader({Type: "Text", Header: "요약"		, SaveName: "ibSheetOption1", Align: "Center"	, Width: 70, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "상세"		, SaveName: "ibSheetOption2", Align: "Center"	, Width: 70, Cursor:"Pointer"});
		var sheetId = "companyHistorySheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	};

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		var jsonListData = [];

		if(pageIndex){
			$('#pageIndex').val(pageIndex);
		}

		$.ajax({
			url: '/tradeSOS/area/areaSuggestCompanyHistoryListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#searchForm').serialize(),
			success: function (data) {
				setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				companyHistorySheet.LoadSearchData({Data: data.resultList});
			},
			error:function(request,status,error) {
				alert('업체이력 조회에 실패했습니다.');
			}
		});
	}

	function openLayerPopup(tradeParam) {						//무역업 검색 팝업
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/tradeSearch.do'
			, params : {
				searchKeyword : tradeParam						//회사명 : 1, 무역업고유번호 :2, 사업자등록번호 구분 : 3
			}
			, callbackFunction : function(resultObj) {
				$('#companyNm').val(resultObj.companyKor);
				$('#tradeNum').val(resultObj.memberId);
				$('#regNo').val(resultObj.enterRegNo);
				$('#companyPresident').val(resultObj.presidentKor);
				$('#companyAddr').val(resultObj.korAddr1+resultObj.korAddr2);
			}
		});
	}

	// function fnCoSearchResult(result){
	// 	let company_nm = result["companyKor"];
	// 	let trade_no = result["memberId"];fn_summaryPop
	// 	let company_president = result["presidentKor"];
	// 	let company_no = result["enterRegNo"];
	// 	let company_addr = result["korAddr1"]+" "+result["korAddr2"] ;
	//
	//
	// 	$("input[name=companyNm]").val(company_nm);
	// 	$("input[name=tradeNo]").val(trade_no);
	// 	$("input[name=companyPresident]").val(company_president);
	// 	$("input[name=companyNo]").val(company_no);
	// 	$("input[name=companyAddr]").val(company_addr);
	// }


	// 요약팝업
 	function companyHistorySheet_OnClick(Row, Col, Value) {
		if (Row > 0){
			var req_id = companyHistorySheet.GetCellValue(Row, "reqId");
			if(companyHistorySheet.ColSaveName(Col) == "ibSheetOption1") {
				openlayerPopup(req_id);
			}else if (companyHistorySheet.ColSaveName(Col) == "ibSheetOption2"){
				window.open("/tradeSOS/area/areaSuggestListDetail.do?reqId="+req_id);
			}
		}
	};

	function openlayerPopup() {																			//상담 요약 팝업
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/area/popup/consultationSummary.do" />'
			, callbackFunction : function(resultObj){
			}
		});
	}

	function openAnswerPopup(){																			//답변 등록 팝업
		var pReqId = $('#reqId').val();
		global.openLayerPopup({
			 params : {
				 reqId : pReqId
			 }
			,popupUrl : '<c:url value="/tradeSOS/area/popup/registerAnswers.do" />'
			, callbackFunction : function(resultObj){
			}
		});
	}

	$("#selectEmail").on("change",function(){
		$("input[name=email2]").val($(this).val());
	})
	var submitFlag = true;
	function fnSubmit() {
		if (confirm('수정 하시겠습니까?')) {
		var form = document.frm;
		var email = $("input[name=email1]").val()+"@"+$("input[name=email2]").val()

		var tel =  $("select[name=tel1]").val()+"-"+$("input[name=tel2]").val()+"-"+$("input[name=tel3]").val();
		var cellula =  $("select[name=cellula1]").val()+"-"+$("input[name=cellula2]").val()+"-"+$("input[name=cellula3]").val();
		if (email == "@") {
			email == "";
		}
		if (cellula == "--") {
			cellula == "";
		}
		if (tel == "--") {
			tel == "";
		}
		$("input[name=email]").val(email);
		$("input[name=cellula]").val(cellula);
		$("input[name=tel]").val(tel);

		if (isStringEmpty($("input[name=companyNm]").val())){
			alert("회사명을 입력해주세요.");
			$("input[name=companyNm]").focus();
			return;
		}else if (isStringEmpty($("input[name=tradeNo]").val())){
			alert("무역업고유번호를 입력해주세요.");
			$("input[name=tradeNo]").focus();
			return;
		}else if (isStringEmpty($("input[name=companyPresident]").val())){
			alert("대표자명을 입력해주세요.");
			$("input[name=companyPresident]").focus();
			return;
		}else if (isStringEmpty($("input[name=companyNo]").val())){
			alert("사업자번호를 입력해주세요.");
			$("input[name=companyNo]").focus();
			return;
		}else if (isStringEmpty($("input[name=companyAddr]").val())){
			alert("회사주소를 입력해주세요.");
			$("input[name=companyAddr]").focus();
			return;
		}else if (isStringEmpty($("input[name=caerNm]").val())){
			alert("이름을 입력해주세요.");
			$("input[name=caerNm]").focus();
			return;
		}else if (isStringEmpty($("input[name=email]").val())){
			alert("이메일을 입력해주세요.");
			$("input[name=email]").focus();
			return;
		}else if (!checkEmail($("input[name=email]").val())){
			alert("이메일을 형식에 맞게 입력해주세요.");
			$("input[name=email1]").focus();
			return;
		}else if (isStringEmpty($("select[name=reqTp]").val())){
			alert("분야를 선택해주세요.");
			$("select[name=reqTp]").focus();
			return;
		}else if (isStringEmpty($("input[name=reqTitle]").val())){
			alert("신청 내역 제목을 입력해주세요.");
			$("input[name=reqTitle]").focus();
			return;
		}else if (isStringEmpty($("textarea[name=reqContent]").val())){
			alert("신청 내역 상담 내용을 입력해주세요.");
			$("textarea[name=reqContent]").focus();
			return;
		}else{
			if (submitFlag) {
				submitFlag = false;

				// var pReqId = $('#frm #reqId').val();
				// $('#answerFrm #reqId').val(pReqId);
				var formData = new FormData($('#frm')[0]);
				$.ajax({
					type: "post",
					enctype: 'multipart/form-data',
					url: "/tradeSOS/area/areaSuggestDetailProc.do",
					data: formData,
					processData: false,
					contentType: false,
					async: false,
					success: function (data) {
						fn_list();
					},
					error: function (request, status, error) {
						console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});
			}

			}
		}
	}

	function fnNumber(){
		if((event.keyCode<45)||(event.keyCode>57 || event.keyCide > 45 || event.keyCode <48) || (event.keyCode == 47))
			event.returnValue=false;
	}



	// function doResult(resultObj) {
	//
	// 	try {
	// 		if ( resultObj.getRequestEvent() == "AnswerProc" ) {
	// 			if( resultObj.getSuccess() == true) {
	// 				alert(resultObj.getMessage());
	// 				location.reload();
	// 			}
	// 		}else if ( resultObj.getRequestEvent() == "Update" ){
	// 			if( resultObj.getSuccess() == true) {
	// 				alert(resultObj.getMessage());
	// 				location.reload();
	// 			}
	// 		}
	//
	// 	} catch(errorObject) {
	// 		showErrorDlg("doResult()", errorObject);
	// 	}
	// }
</script>
