<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<%
 /**
  * @Class Name : problSuggestListRegPopup.jsp
  * @Description : 대메뉴 목록화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2016.04.28	이인오		최초 생성
  *
  * @author 이인오
  * @since 2016.04.28
  * @version 1.0
  * @see
  *
  */
%>
<!-- 컨설턴트/전문가 관리 - 애로건의 현황 상세 -->
<div class="flex">
	<h2 class="popup_title">애로건의 신청 대리입력</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="fnSubmit();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="page_tradesos popup_body">

<!-- ---------------------------------------------------애로건의 신청 대리입력----------------------------------------------------------------- -->

	<form name="submitForm" id="submitForm" method="post" enctype="multipart/form-data" >
		<input type='hidden' name='mode' value='I' />
		<input type="hidden" name ="tempMode"  />
		<input type="hidden" name="totContCnt"  value="1"/>
		<input type="hidden" name="currContCnt" />
		<input type="hidden" name="proState"  value="RY"/>
		<input type="hidden" name="depthArr" />
		<input type="hidden" name="fileArr" />
		<input type="hidden" name="filenameArr" />
		<input type="hidden" name="openYn" value="N" />
		<input type="hidden" name ="loginId"  value="<c:out value="${loginVO.user_id}"/>" />
		<input type="hidden" name="reqMemo" value="" />
		<input type="hidden" name="sendMail" id = "sendMail"  value="Y" />
		<input type="hidden" name="eventSdcit" id="eventSdcit" value="Save"/>
		<div class="btn_group align_ctr">
			
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" rowspan="5">회사정보</th>
					<th scope="row">회사명 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
						<span class="form_search w100p">
							<input class="form_text w100p" type="text" id="compnyNm" name="compnyNm"  value="">
							<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(1);"></button>
						</span>
						</div>
					</td>
					<th scope="row">무역업고유번호 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
						<span class="form_search w100p">
							<input class="form_text w100p" type="text" name="tradeNum" id="tradeNum" value="" >
							<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(2);"></button>
						</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">대표자 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="presidentKor" name="presidentKor" class="form_text w100p" value="">
					</td>
					<th scope="row">사업자등록번호 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
						<span class="form_search w100p">
							<input class="form_text w100p" type="text" name="regNo" id="regNo" value="">
							<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(3);"></button>
						</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">대표전화</th>
					<td>
						<div class="flex align_center">
						<select id="compPhone1" name="compPhone1" class="form_select">
							<option value="" selected="">선택</option>
							<c:forEach var="data" items="${code130}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" name="compPhone2" class="form_text w100p ml-8" maxlength="4" id="compPhone2">
						<input type="text" name="compPhone3" class="form_text w100p ml-8" maxlength="4" id="compPhone3">
						<input type="hidden" id="compPhone" name="compPhone"/>
						</div>
					</td>
					<th scope="row">FAX</th>
					<td>
						<div class="flex align_center">
						<select id="compFax1" ame="compFax1" class="form_select">
							<option value="" selected="">선택</option>
							<c:forEach var="data" items="${code130}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" name="compFax2" class="form_text w100p ml-8" maxlength="4" id="compFax2">
						<input type="text" name="compFax3" class="form_text w100p ml-8" maxlength="4" id="compFax3">
						</div>
							<input type="hidden" id="compFax" name="compFax"/>
					</td>
				</tr>
				<tr>
					<th scope="row">지역 <strong class="point">*</strong></th>
					<td>
						<select id="reqArea" name="reqArea" class="form_select">
							<option value="" selected="">소재지</option>
							<c:forEach var="data" items="${code120}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">취급품목 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="bizItems" name="bizItems" class="form_text w100p" value="">
					</td>
				</tr>
				<tr>
					<th scope="row">회사주소 <strong class="point">*</strong></th>
					<td colspan="3">
						<input type="text" id="compAddr" name="compAddr" class="form_text w100p" value="">
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">대리입력정보</th>
					<th scope="row">대리입력자 <strong class="point">*</strong></th>
					<td>
						<input type="text" name="proUserid" id="proUserid" class="form_text w100p" value="<c:out value="${user.memberNm}"/>">
					</td>
					<th scope="row">대리입력자 소속 <strong class="point">*</strong></th>
					<td>
						<input type="text" name="proDept" id="proDept" class="form_text w100p" value="">
					</td>
				</tr>
				<tr>
					<th scope="row">대리입력자 연락처 <strong class="point">*</strong></th>
					<td>
						<input type="text" name="proHp" id="proHp" class="form_text w100p" value="<c:out value="${user.handTel}"/>">
					</td>
					<th scope="row">대리입력자 E-mail <strong class="point">*</strong></th>
					<td>
						<input type="text" name="proEmail" id="proEmail"  class="form_text w100p" value="<c:out value="${user.emEmailAddr}"/>">
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="4">업체담당자</th>
					<th scope="row">이름 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="reqName" name="reqName" class="form_text w100p" value="">
					</td>
					<th scope="row">직위 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="reqPostion" name="reqPostion"  class="form_text w100p" value="">
					</td>
				</tr>
				<tr>
					<th scope="row">부서 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="reqDept" name="reqDept" class="form_text w100p" value="">
					</td>
					<th scope="row">휴대폰 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
						<select id="reqHp1" name="reqHp1" class="form_select">
							<option value="" selected="">선택</option>
							<c:forEach var="data" items="${code132}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" name="reqHp2" class="form_text w100p ml-8" value="" id="reqHp2" maxlength="4">
						<input type="text" name="reqHp3" class="form_text w100p ml-8" value="" id="reqHp3" maxlength="4">
						<input type="hidden" id="reqHp" name="reqHp"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td>
						<div class="flex align_center">
						<select id="reqPhone1" name="reqPhone1" class="form_select">
							<option value="" selected="">선택</option>
							<c:forEach var="data" items="${code130}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" name="reqPhone2" class="form_text w100p ml-8" value="" id="reqPhone2" maxlength="4">
						<input type="text" name="reqPhone3" class="form_text w100p ml-8" value="" id="reqPhone3" maxlength="4">
						<input type="hidden" id="reqPhone" name="reqPhone"/>
						</div>
					</td>
					</td>
					<th scope="row">FAX</th>
					<td>
						<div class="flex align_center">
						<select id="reqFax1" name="reqFax1" class="form_select">
							<option value="" selected="">선택</option>
							<c:forEach var="data" items="${code130}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" name="reqFax2" class="form_text w100p ml-8" maxlength="4" id="reqFax2" >
						<input type="text" name="reqFax3" class="form_text w100p ml-8" maxlength="4" id="reqFax3" >
						<input type="hidden" id="reqFax" name="reqFax"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">이메일 <strong class="point">*</strong></th>
					<td colspan="3">
						<div class="flex align_center">
						<input type="text" id="reqEmail1" name="reqEmail1" class="form_text">
						<div class="spacing">@</div>
						<input type="text" id="reqEmail2" name="reqEmail2" class="form_text">
						<select id="selectEmail" class="form_select ml-8">
							<option value="">직접입력</option>
							<c:forEach var="data" items="${code070}" varStatus="status">
								<option value="${data.cdNm}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<input type="hidden" id="reqEmail" name="reqEmail" maxlength="100"/>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="10">건의내용</th>
					<th scope="row">제목 <strong class="point">*</strong></th>
					<td colspan="3"><input type="text" id="reqTitle" name="reqTitle" maxlength="150" class="form_text w100p"></td>
				</tr>
				<tr>
					<th scope="row">분야 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
						<select id="reqCatHight" name="reqCatHight" class="form_select">
							<option value="" selected="selected">선택하세요</option>
							<c:forEach var="data" items="${codeCat}" varStatus="status">
								<option value="${data.cdId}" data-etc1="${data.etc1}">${data.cdNm}</option>
							</c:forEach>
						</select>
						<select id="reqCatMiddle" name="reqCatMiddle" class="form_select ml-8">
							<option value="" selected="selected">선택하세요</option>
						</select>
						</div>
					</td>
					<th scope="row">신청채널 <strong class="point">*</strong></th>
					<td>
						<select id="reqChannel" name="reqChannel" class="form_select">
							<option value="" selected="selected">선택하세요</option>
							<c:forEach var="data" items="${code110}" varStatus="status">
								<option value="${data.cdId}">${data.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3">
						<textarea id="reqContents" name="reqContents" rows="5" class="form_text w100p"></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">담당자의견</th>
					<td colspan="3">
						<textarea id="personComment" name="personComment" rows="5" class="form_text w100p"></textarea>
					</td>
				</tr>
				<!-- <tr>
					<th scope="row">공개여부</th>
					<td colspan="3">
						<input type="radio" name="" id="open" value="" checked="checked"> <label for="open">공개</label>
						<input type="radio" name="" id="closed" value=""> <label for="closed">비공개</label>
					</td>
				</tr> -->
				<tr>
					<th scope="row">첨부파일1</th>
					<td colspan="3">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="fileName1" name="attach" accept="${acceptFileExtension}"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일2</th>
					<td colspan="3">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="fileName2" name="attach" accept="${acceptFileExtension}"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일3</th>
					<td colspan="3">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="fileName3" name="attach" accept="${acceptFileExtension}"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일4</th>
					<td colspan="3">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="fileName4" name="attach" accept="${acceptFileExtension}"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일5</th>
					<td colspan="3">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="fileName5" name="attach" accept="${acceptFileExtension}"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
					</td>
				</tr>
			</tbody>
		</table><!-- // 애로건의 현황 신규입력 테이블-->
	</form>


</div> <!-- // .page_tradesos -->


<script type="text/javascript">


	function openTradePopup(tradeParam) {
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/tradeSearch.do'
			, params : {
				searchKeyword : tradeParam						//회사명 : 1, 무역업고유번호 :2, 사업자등록번호 구분 : 3
			}
			, callbackFunction : function(resultObj) {
				$('#submitForm #compnyNm').val(resultObj.companyKor);
				$('#submitForm #tradeNum').val(resultObj.memberId);
				$('#regNo').val(resultObj.enterRegNo);
				$('#presidentKor').val(resultObj.presidentKor);
				$('#compAddr').val(resultObj.korAddr1+resultObj.korAddr2);

			}
		});
	}

	jQuery(document).ready(function(){
		// 첨부파일
		$("input:file[name^='attach']").change(function(){
			$(this).parents('div.inputFile').find("input:hidden[name^='FILE_SEQ']").val("");
			$(this).parents('div.inputFile').find("input:text[name^='fileName']").val($(this).val().substring($(this).val().lastIndexOf("\\")+1));
		});
		// inputNum('trade_num');
		// inputNum('reg_no');
		// inputNum('comp_phone2');
		// inputNum('comp_phone3');
		// inputNum('comp_fax2');
		// inputNum('comp_fax3');
		// inputNum('req_hp2');
		// inputNum('req_hp3');
		// inputNum('req_phone2');
		// inputNum('req_phone3');
		// inputNum('req_fax2');
		// inputNum('req_fax3');
		// inputNum('pro_hp');
	});

	// function fnCoSearchResult(result){
	// 	var compny_nm = result["company_kor"];
	// 	var trade_num = result["member_id"];
	// 	var president_kor = result["president_kor"];
	// 	var reg_no = result["enter_reg_no"];
	// 	var comp_phone = result["tel_etc"];
	// 	var comp_fax = result["fax_etc"];
	// 	var comp_addr = result["kor_addr1"]+" "+result["kor_addr2"] ;
	//
	//
	// 	$("input[name=compny_nm]").val(compny_nm);
	// 	$("input[name=trade_num]").val(trade_num);
	// 	$("input[name=president_kor]").val(president_kor);
	// 	$("input[name=reg_no]").val(reg_no);
	// 	if (fnPhoneValidation(comp_phone)){
	// 		var comp_phone_arr = comp_phone.split("-")
	// 		$("select[name=comp_phone1]").val(comp_phone_arr[0]);
	// 		$("input[name=comp_phone2]").val(comp_phone_arr[1]);
	// 		$("input[name=comp_phone3]").val(comp_phone_arr[2]);
	// 	}
	// 	if (fnPhoneValidation(comp_fax)){
	// 		var comp_fax_arr = comp_fax.split("-")
	// 		$("select[name=comp_fax1]").val(comp_fax_arr[0]);
	// 		$("input[name=comp_fax2]").val(comp_fax_arr[1]);
	// 		$("input[name=comp_fax3]").val(comp_fax_arr[2]);
	// 	}
	// 	$("input[name=comp_addr]").val(comp_addr);
	// }
	function fnNumber(){
		if((event.keyCode<45)||(event.keyCode>57 || event.keyCide > 45 || event.keyCode <48) || (event.keyCode == 47))
			event.returnValue=false;
	}
	$("#selectEmail").on("change",function(){
		$("input[name=reqEmail2]").val($(this).val());
	})
	$("select[name=reqCatHight]").on("change",function(){
		var reqCatHight = $(this).find(':selected').data('etc1')
		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/selecttReqCatMiddelCodeListAjax.do",
			data: { catHight : reqCatHight},
			success:function(data){
				$("select[name=reqCatMiddle]").empty();
				$("select[name=reqCatMiddle]").append($("<option value=''>선택하세요</option>"));
				var optionList = data.resultList;
				for (var i = 0 ; i < optionList.length ; i++){
					var option = $("<option value='"+optionList[i].catMiddle+"'>"+optionList[i].codenm+"</option>");
					$("select[name=reqCatMiddle]").append(option);
				}
			}
		});
	});
	var submitFlag = true;
	function fnSubmit() {
		if (confirm('해당 게시물을 저장하시겠습니까?')) {
			var form = document.submitForm;


			//회사 FAX------------------------------------------------------------------------------------
			var compFax1 = form.compFax1.value;													// 회사 FAX
			var compFax2 = form.compFax2.value;													// 회사 FAX
			var compFax3 = form.compFax3.value;													// 회사 FAX

			//회사 대표전화------------------------------------------------------------------------------------
			var compPhone1 = form.compPhone1.value;													// 회사 대표전화
			var compPhone2 = form.compPhone2.value;													// 회사 대표전화
			var compPhone3 = form.compPhone3.value;													// 회사 대표전화

			//신청자 정보 핸드폰 ------------------------------------------------------------------------------------
			var reqHp1 = form.reqHp1.value;
			var reqHp2 = form.reqHp2.value;													// 신청자 정보 핸드폰
			var reqHp3 = form.reqHp3.value;													// 신청자 정보 핸드폰


			//신청자 정보 전화번호  ------------------------------------------------------------------------------------
			var reqPhone1 = form.reqPhone1.value;													//신청자 정보 전화번호
			var reqPhone2 = form.reqPhone2.value;													// 신청자 정보 전화번호
			var reqPhone3 = form.reqPhone3.value;													// 신청자 정보 전화번호
			//신청자 FAX  ------------------------------------------------------------------------------------
			var reqFax1 = form.reqFax1.value;													// 신청자 FAX
			var reqFax2 = form.reqFax2.value;													// 신청자 FAX
			var reqFax3 = form.reqFax3.value;													// 신청자 FAX

			var reqEmai1 = form.reqEmail1.value;													// 신청자 Email
			var reqEmai2 = form.reqEmail2.value;													// 신청자 Email
			form.reqEmail.value = reqEmai1 + "@" + reqEmai2;

			form.compFax.value = tel_block_chk(compFax1, compFax2, compFax3);
			form.compPhone.value = tel_block_chk(compPhone1, compPhone2, compPhone3);
			form.reqHp.value = tel_block_chk(reqHp1, reqHp2, reqHp3);
			form.reqPhone.value = tel_block_chk(reqPhone1, reqPhone2, reqPhone3);
			form.reqFax.value = tel_block_chk(reqFax1, reqFax2, reqFax3);

			//회사 정보 입력 validate
			if (isStringEmpty(form.compnyNm.value)) {
				alert("회사명은 필수입력 항목입니다.");
				form.compnyNm.focus();
				return;
			}

			if (isStringEmpty(form.tradeNum.value)) {
				alert("무역업고유번호는 필수입력 항목입니다.");
				form.tradeNum.focus();
				return;
			}

			if (isStringEmpty(form.presidentKor.value)) {
				alert("대표자명은 필수입력 항목입니다.");
				form.presidentKor.focus();
				return;
			}

			if (isStringEmpty(form.regNo.value)) {
				alert("사업자 등록번호는 필수입력 항목입니다.");
				form.regNo.focus();
				return;
			}
			if (isStringEmpty(form.reqArea.value)) {
				alert("지역은 필수입력 항목입니다.");
				form.reqArea.focus();
				return;
			}
			if (isStringEmpty(form.bizItems.value)) {
				alert("취급품목은 필수입력 항목입니다.");
				form.bizItems.focus();
				return;
			}
			if (isStringEmpty(form.compAddr.value)) {
				alert("회사주소는 필수입력 항목입니다.");
				form.compAddr.focus();
				return;
			}
			if (isStringEmpty(form.proUserid.value)) {
				alert("대리입력자는 필수입력 항목입니다.");
				form.proUserid.focus();
				return;
			}
			if (isStringEmpty(form.proDept.value)) {
				alert("대리입력자 소속은 필수입력 항목입니다.");
				form.proDept.focus();
				return;
			}
			if (isStringEmpty(form.proHp.value)) {
				alert("대리입력자 연락처는 필수입력 항목입니다.");
				form.proHp.focus();
				return;
			}
			if (isStringEmpty(form.proEmail.value)) {
				alert("대리입력자 E-mail은 필수입력 항목입니다.");
				form.proEmail.focus();
				return;
			}
			if (isStringEmpty(form.reqName.value)) {
				alert("이름은 필수입력 항목입니다.");
				form.reqName.focus();
				return;
			}

			if (isStringEmpty(form.reqPostion.value)) {
				alert("직위는 필수입력 항목입니다.");
				form.reqPostion.focus();
				return;
			}


			if (isStringEmpty(form.reqDept.value)) {
				alert("부서는 필수입력 항목입니다.");
				form.reqDept.focus();
				return;
			}

			var chkHp = form.reqHp.value.replaceAll('-', '');		//연락처 정규식 체크를 위한 replace
			if (!global.isHpTel(chkHp)) {
				alert("휴대폰번호는 필수입력 항목입니다.");
				form.reqHp1.focus();
				return;
			}
			if (isStringEmpty(form.reqEmail.value)) {
				alert("이메일은 필수입력 항목입니다.");
				form.reqEmail1.focus();
				return;
			}
			if (isStringEmpty(form.reqTitle.value)) {
				alert("제목은 필수입력 항목입니다");
				form.reqTitle.focus();
				return;
			}

			if (global.chkByte(form.reqTitle, 100, "제목은") == false) {
				return;
			}

			if (isStringEmpty(form.reqCatHight.value)) {
				alert("분야는 필수선택 사항입니다");
				form.reqCatHight.focus();
				return;
			}

			if (isStringEmpty(form.reqChannel.value)) {
				alert("신청채널은 필수입력 항목입니다.");
				form.reqChannel.focus();
				return;
			}

			var extensionArray = ['doc', 'docx', 'hwp', 'pdf', 'jpg', 'jpeg', 'gif', 'png', 'bmp'];							//파일 형식 확인
			var isValid = accessFileExtension(extensionArray);
			if (!isValid) {
				return false;
			}


			form.proState.value = "RY";


			global.ajaxSubmit($('#submitForm'), {
				type: 'POST'
				, url: '<c:url value="/tradeSOS/problem/problSuggestProc.do" />'
				, enctype: 'multipart/form-data'
				, dataType: 'json'
				, async: false
				, spinner: true
				, success: function (data) {
						closeLayerPopup();
						window.location.reload();
					}
			});

		}
	}


	function doResult(resultObj) {

		try {
			if ( resultObj.getRequestEvent() == "Save" ) {
				if( resultObj.getSuccess() == true) {
					alert(resultObj.getMessage());
					closeLayerPopup();
				}
			}
		} catch(errorObject) {
			showErrorDlg("doResult()", errorObject);
		}
	}


	function tel_block_chk(val1, val2, val3){					//전화번호 양식 맞춤
		var value = "";
		if(val1 == null || val2 == null || val3 == null){
			return false;
		}else{
			value = val1+"-"+val2+"-"+val3;
		}
		return value;
	}


	function fnPhoneValidation(value) {
		if (/^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}/.test(value)) {
			return true;
		}
		return false;
	}
</script>