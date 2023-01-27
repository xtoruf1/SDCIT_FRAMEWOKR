<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	function press(event) {
		if (event.keyCode==13) {

		}
	}

	function fnList() {
		document.searchInsertForm.action = "/consultant/area/areaSuggestList.do";
		document.searchInsertForm.submit();
	}

</script>

<input type="hidden" name="topMenuId" value="" />
<!-- 분야별전문가 자문 - 상세 -->
<div class="page_tradesos">
	<!-- 등록 테이블-->
<%--	<h3 class="para_title">등록 테이블</h3>--%>
	<!-- 페이지 위치 -->
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="fnSubmit();" >저장</button>
			<button type="button" class="btn_sm btn_secondary" onclick="fnList();">목록</button>
		</div>
	</div>
	<form name="frm" id="frm" method="post">
		<input type="hidden" name="eventSdcit" id="eventSdcit" value="Save"/>
		<input type="hidden" id="reqId" name="reqId" value="0"/>
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
					<th scope="row">회사명 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
							<span class="form_search w100p">
								<input class="form_text w100p" type="text" id="companyNm" name="companyNm" maxlength="70">
								<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(1);"></button>
							</span>
						</div>
					</td>
					<th scope="row">무역업고유번호 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
							<span class="form_search w100p">
								<input type="text" id="tradeNum" name="tradeNo" class="form_text w100p" onkeypress="fnNumber(this)" maxlength="20">
								<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(2);"></button>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">대표자 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="companyPresident" name="companyPresident" class="form_text" maxlength="30">
					</td>
					<th scope="row">사업자등록번호 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
							<span class="form_search w100p">
								<input type="text" id="regNo" name="companyNo" class="form_text w100p" onkeypress="fnNumber(this)" maxlength="20">
							<button type="button" class="btn_icon btn_search" onclick="openLayerPopup(3);"></button>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">회사주소 <strong class="point">*</strong></th>
					<td colspan="3">
						<input type="text" id="companyAddr" name="companyAddr" class="form_text w100p" maxlength="200">
					</td>
				</tr>
				<tr>
					<th scope="row">이름 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="caerNm" name="caerNm" class="form_text" maxlength="50">
					</td>
					<th scope="row">이메일 <strong class="point">*</strong></th>
					<td>
						<div class="form_row">
							<input type="text" name="email1" class="form_text" maxlength="49">
							<div class="spacing">@</div>
							<input type="text" name="email2" class="form_text" maxlength="50">
							<select id="selectEmail" class="form_select">
								<option value="">직접입력</option>
								<c:forEach var="data" items="${code070}" varStatus="status">
									<option value="${data.cdNm}">${data.cdNm}</option>
								</c:forEach>
							</select>
							<input type="hidden" name="email"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">핸드폰</th>
					<td>
						<div class="form_row" style="width:300px;">
							<select name="cellula1" class="form_select">
								<option value="" selected="">선택</option>
								<c:forEach var="data" items="${code132}" varStatus="status">
									<option value="${data.cdId}">${data.cdId}</option>
								</c:forEach>
							</select>
							<input type="text" name="cellula2" class="form_text" maxlength="4" onkeypress="fnNumber(this)">
							<input type="text" name="cellula3" class="form_text" maxlength="4" onkeypress="fnNumber(this)">
						</div>
						<input type="hidden"  name="cellula">
					</td>
					<th scope="row">전화번호</th>
					<td>
						<div class="form_row" style="width:300px;">
							<select name="tel1" class="form_select">
								<option value="">선택</option>
								<c:forEach var="data" items="${code130}" varStatus="status">
									<option value="${data.cdId}">${data.cdId}</option>
								</c:forEach>
							</select>
							<input type="text" name="tel2" class="form_text" maxlength="4" onkeypress="fnNumber(this)">
							<input type="text" name="tel3" class="form_text" maxlength="4" onkeypress="fnNumber(this)">
							<input type="hidden"  name="tel">
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
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">공개여부 <strong class="point">*</strong></th>
					<td>
						<label class="label_form" for="radio1_1" >
							<input type="radio" class="form_radio" name="openFg" id="radio1_1" value="Y">
							<span class="label">공개</span>
						</label>	
						<label class="label_form" for="radio1_2">
							<input type="radio" class="form_radio" name="openFg" id="radio1_2" value="N" checked>
							<span class="label">비공개</span>
						</label>
					</td>
				</tr>
				<tr>
					<th scope="row">분야 <strong class="point">*</strong></th>
					<td>
						<select name="reqTp"  class="form_select">
							<option value="" selected="selected">선택하세요</option>
							<c:forEach var="data" items="${code026}" varStatus="status">
								<option value="<c:out value="${data.cdId}"/>"><c:out value="${data.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">제목 <strong class="point">*</strong></th>
					<td>
						<input type="text" name="reqTitle" class="form_text w100p" maxlength="1200">
					</td>
				</tr>
				<tr>
					<th scope="row">상담 내용 <strong class="point">*</strong></th>
					<td>
						<textarea  name="reqContent" rows="3" class="form_textarea" maxlength="300000" onkeyup="return textareaMaxLength(this);"></textarea>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">답변 내역</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:7.5%">
					<col style="width:7.5%">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<th scope="row" colspan="2">제목 <strong class="point">*</strong></th>
					<td>
						<input type="text"  name="answerTitle" class="form_text w100p" maxlength="1000">
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">상담 내용 <strong class="point">*</strong></th>
					<td>
						<textarea  name="answerContent" rows="3" class="form_textarea" maxlength="50000" onkeyup="return textareaMaxLength(this);"></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">관련법률</th>
					<th scope="row">법률</th>
					<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률   Ex) 관세법" name="law" maxlength="1000"></td>
				</tr>
				<tr>
					<th scope="row">조항</th>
					<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" name="lawClause" maxlength="1000"></td>
				</tr>
				<tr>
					<th scope="row" colspan="2">기타참고사항</th>
					<td><input type="text" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" name="dscr" maxlength="1000"></td>
				</tr>
				</tbody>
			</table>
		</div>
	</form>
	<!-- //등록 테이블-->
	<form id="searchInsertForm" name="searchInsertForm">
		<input type="hidden" name="pageIndex" value="${searchVO.pageIndex}" />
		<input type="hidden" name="frDt" value="${searchVO.frDt}" />
		<input type="hidden" name="toDt" value="${searchVO.toDt}" />
		<input type="hidden" name="reqTp" value="${searchVO.reqTp}" />
		<input type="hidden" name="chnnelTp" value="${searchVO.chnnelTp}" />
		<input type="hidden" name="reqStatus" value="${searchVO.reqStatus}" />
		<input type="hidden" name="caerNm" value="${searchVO.caerNm}" />
		<input type="hidden" name="tradeNo" value="${searchVO.tradeNo}" />
		<input type="hidden" name="reqTitle" value="${searchVO.reqTitle}" />
		<input type="hidden" name="resultQ" value="${searchVO.resultQ}" />
		<input type="hidden" name="openFg" value="${searchVO.openFg}" />
	</form>

</div> <!-- // .page_tradesos -->



<script type="text/javascript">

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

	function fnCoSearchResult(result){
		var company_nm = result["company_kor"];
		var trade_no = result["member_id"];
		var company_president = result["president_kor"];
		var company_no = result["enter_reg_no"];
		var company_addr = result["kor_addr1"]+" "+result["kor_addr2"] ;


		$("input[name=companyNm]").val(company_nm);
		$("input[name=tradeNo]").val(trade_no);
		$("input[name=companyPresident]").val(company_president);
		$("input[name=companyNo]").val(company_no);
		$("input[name=companyAddr]").val(company_addr);
	}

	$("#selectEmail").on("change",function(){
		$("input[name=email2]").val($(this).val());
	})
	var submitFlag = true;
	function fnSubmit() {

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
			alert("화사명을 입력해주세요.");
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
		}else if (isStringEmpty($("input[name=answerTitle]").val())){
			alert("답변 내역 제목을 입력해주세요.");
			$("input[name=answerTitle]").focus();
			return;
		}else if (isStringEmpty($("textarea[name=answerContent]").val())){
			alert("답변 내역 상담 내용을 입력해주세요.");
			$("textarea[name=answerContent]").focus();
			return;
		}else{
			if (submitFlag) {
				submitFlag = false;

				var formData = new FormData($('#frm')[0]);

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/tradeSOS/area/areaSuggestDetailProc.do" />'
					, data : $('#frm').serialize()
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						alert(data.MESSAGE);
						fnList();
					}
				});
			}
		}
	}


	function doResult(resultObj) {

		try {
			if ( resultObj.getRequestEvent() == "Save" ) {
				if( resultObj.getSuccess() == true) {
					alert(resultObj.getMessage());
					fn_list();
				}
			}
		} catch(errorObject) {
			showErrorDlg("doResult()", errorObject);
		}
	}

	function fnNumber(){
		if((event.keyCode<45)||(event.keyCode>57 || event.keyCide > 45 || event.keyCode <48) || (event.keyCode == 47))
			event.returnValue=false;
	}

</script>