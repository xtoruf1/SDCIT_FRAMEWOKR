<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : topMenu.jsp
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
<script type="text/javascript">
	function press(event) {
		if (event.keyCode==13) {

		}
	}
	function fn_list() {
		document.listForm.action = "/tradeSOS/com/translationMember.do";
		document.listForm.submit();
	}

</script>
<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<form name="listForm" id="listForm" method="post">
	<c:forEach var="params" items="${param}"  varStatus="status">
		<input type="hidden" id="<c:out value="${params.key}"/>" name="<c:out value="${params.key}"/>" value="<c:out value="${params.value}"/>" />
	</c:forEach>
</form>

<form name="registForm" id="registForm" method="post" encType="multipart/form-data">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="procType" value="${searchVO.procType}" />
	<input type="hidden" name="expertTp" id="expertTp" value="${searchVO.procType eq 'I' ? '001' : resultData.expertTp}"/>
	<input type="hidden" name="expertGrp" value="">
	<!-- 컨설턴트/전문가 관리 - 통번역 전문위원 상세 -->
	<div class="page_tradesos">
		<div class="location">
			<!-- 네비게이션 -->
			<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
			<!-- 네비게이션 -->
			<!-- 검색 테이블 -->
			<div class="ml-auto">
				<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
			</div>
		</div>
		<div class="tit_bar">
			<h3 class="tit_block">신청정보</h3>
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
					<th scope="row">증명사진</th>
					<td colspan="3">
						<div class="form_file">
							<figure id="photoBox">
								<c:choose>
									<c:when test="${!empty resultFile}">
										<img src="<c:out value="/cmm/fms/getMemberImage.do?attachDocumId=${resultFile.attachDocumId}&attachSeqNo=${resultFile.attachSeqNo}"/>" alt="" style="width: 108px;height: 144px;">
									</c:when>
									<c:otherwise>
										<img src="/images/admin/defaultImg.jpg" alt="" style="width: 108px;height: 144px;">
									</c:otherwise>
								</c:choose>
							</figure>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td>
						<div class="flex align_center">
							<input type="text" id="name" name="name" class="form_text w100p" value="<c:out value="${resultData.name}"/>" readonly="readonly">
							<input type="text" id="expertId" name="expertId" class="form_text w100p ml-8" value="<c:out value="${resultData.expertId}"/>" readonly="readonly">
						</div>
					</td>
					<th scope="row">주민등록번호</th>
					<td>
						<div class="flex align_center">
							<input type="hidden" name="residentNo" id="residentNo"/>
							<input type="text" id="resident_no_temp1" name="resident_no_temp1" class="form_text w100p" maxlength="6" value="${!empty(resultData.residentNo) ? fn:substring(resultData.residentNo,0,6) : ''}" numberOnly>
							<div class="spacing">-</div>
							<input type="text" id="resident_no_temp2" name="resident_no_temp2" class="form_text w100p" maxlength="7" value="${!empty(resultData.residentNo) ? fn:substring(resultData.residentNo,6,13) : ''}" numberOnly>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">계좌번호</th>
					<td>
						<input type="text" id="account" name="account" class="form_text w100p" value="<c:out value="${resultData.account}"/>">
					</td>
					<th scope="row">예금주</th>
					<td>
						<input type="text" id="accountNm" name="accountNm" class="form_text w100p" maxlength="30" value="${resultData.accountNm}" >
					</td>
				</tr>
				<tr>
					<th scope="row">휴대전화</th>
					<td>
						<input type="hidden" id="tel" name="tel" value="<c:out value="${resultData.tel}"/>"/>
						<div class="flex align_center">
						<c:choose>
							<c:when test="${fn:length(resultData.tel) eq 10}">
								<input type="text" id="tel1"  class="form_text w100p"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,3,6)}"/>" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,6,10)}"/>" maxlength="4" numberOnly>
							</c:when>
							<c:when test="${fn:length(resultData.tel) eq 11}">
								<input type="text" id="tel1"  class="form_text w100p"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,3,7)}"/>" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,7,11)}"/>" maxlength="4" numberOnly>
							</c:when>
							<c:otherwise>
								<input type="text" id="tel1"  class="form_text w100p"  value="" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="" maxlength="4" numberOnly>
							</c:otherwise>
						</c:choose>
						</div>
					</td>
					<th scope="row">소재지</th>
					<td>
						<select name="region" id="region" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach items="${regionList}" var="item" varStatus="status">
								<option value="${item.cdId}" <c:if test="${resultData.region eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="hidden" id="email" name="email" value="${resultData.email}">
						<div class="flex align_center">
						<c:choose>
							<c:when test="${!empty resultData.email}">
								<input type="text" id="email1" class="form_text w100p" value="${fn:split(resultData.email,'@')[0]}">
								<div class="spacing">@</div>
								<input type="text" id="email2" class="form_text w100p" value="${fn:split(resultData.email,'@')[1]}">
							</c:when>
							<c:otherwise>
								<input type="text" id="email1" class="form_text w100p">
								<div class="spacing">@</div>
								<input type="text" id="email2" class="form_text w100p">
							</c:otherwise>
						</c:choose>
						</div>
					</td>
					<th scope="row">활동여부</th>
					<td>
						<input type="radio" class="form_radio" name="st_yn" id="work" value="N" <c:if test="${empty resultData.stYn or (!empty(resultData.stYn) and resultData.stYn eq 'N')}">checked="checked"</c:if>> <label for="work">활동</label>
						<input type="radio" class="form_radio" name="st_yn" id="leave" value="Y"<c:if test="${!empty(resultData.stYn) and resultData.stYn eq 'Y'}">checked="checked"</c:if>> <label for="leave">활동종료</label>
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>
						<input type="radio" class="form_radio" id="translation1" name="gubun" value="A" onchange="expertTpChange(this.value);" <c:if test="${empty resultData.gubun or (!empty resultData.gubun and resultData.gubun eq 'A')}">checked</c:if>> <label for="translation1">통/번역</label>
						<input type="radio" class="form_radio" id="translation2" name="gubun" value="I" onchange="expertTpChange(this.value);" <c:if test="${!empty resultData.gubun and resultData.gubun eq 'I'}">checked</c:if>> <label for="translation2">통역</label>
						<input type="radio" class="form_radio" id="translation3" name="gubun" value="T" onchange="expertTpChange(this.value);" <c:if test="${!empty resultData.gubun and resultData.gubun eq 'T'}">checked</c:if>> <label for="translation3">번역</label>
						<input type="radio" class="form_radio" id="translation4" name="gubun" value="C" onchange="expertTpChange(this.value);" <c:if test="${!empty resultData.gubun and resultData.gubun eq 'C'}">checked</c:if>> <label for="translation4">전화통역</label>
					</td>
					<th scope="row">언어</th>
					<td>
						<select name="language" id="language" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach items="${languageList}" var="item" varStatus="status">
								<option value="${item.cdId}" <c:if test="${resultData.language eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">통역구분</th>
					<td>
						<label for="item_chk1"><input type="checkbox" class="form_checkbox" id="item_chk1" name="trans_gubun2" value="A" <c:if test="${!empty resultData.transGubun2 and fn:containsIgnoreCase(resultData.transGubun2,'A')}">checked</c:if>> 방문통역</label>
						<label for="item_chk2"><input type="checkbox" class="form_checkbox" id="item_chk2" name="trans_gubun2" value="B" <c:if test="${!empty resultData.transGubun2 and fn:containsIgnoreCase(resultData.transGubun2,'B')}">checked</c:if>> 화상통역</label>
					</td>
					<th scope="row">기수</th>
					<td>
						<select name="order_no" id="order_no" class="form_select w100p">
							<option value="">선택</option>
							<c:forEach items="${orderNoList}" var="item" varStatus="status">
								<option value="${item.cdId}" <c:if test="${resultData.orderNo eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">선호문서형태</th>
					<td colspan="3">
						<input type="hidden" name="favor_doc" id="favor_doc">
						<ul class="inp_list divide5">
							<c:forEach items="${favorDocList}" var="item" varStatus="status">
								<li>
									<label for="item_papers${status.count}">
										<input type="checkbox" class="form_checkbox" id="item_papers${status.count}" name="favorDocArr" value="${item.cdId}"
											   <c:if test="${!empty resultData.favorDoc and fn:indexOf(resultData.favorDoc, item.cdId) != -1}">checked</c:if>>
										<c:out value="${item.cdNm}"/>
									</label>
								</li>
							</c:forEach>
						</ul>
					</td>
				</tr>
				<tr>
					<th scope="row">전문분야</th>
					<td colspan="3">
						<input type="hidden" name="transGubun" id="transGubun">
						<ul class="inp_list divide5">
							<c:forEach items="${transGubunList}" var="item" varStatus="status">
								<li>
									<label for="item_gubunChk${status.count}">
										<input type="checkbox" class="form_checkbox" id="item_gubunChk${status.count}" name="transGubunArr" value="${item.cdId}"
											   <c:if test="${!empty resultData.transGubun and fn:indexOf(resultData.transGubun, item.cdId) != -1}">checked</c:if>>
										<c:out value="${item.cdNm}"/>
									</label>
								</li>
							</c:forEach>
							<%--<li><label for="item_gubunChk1"><input type="checkbox" id="item_gubunChk1"> 무역서신</label></li>
							<li><label for="item_gubunChk2"><input type="checkbox" id="item_gubunChk2"> 제품카달로그</label></li>
							<li><label for="item_gubunChk3"><input type="checkbox" id="item_gubunChk3"> 계약서</label></li>
							<li><label for="item_gubunChk4"><input type="checkbox" id="item_gubunChk4"> 매뉴얼</label></li>
							<li><label for="item_gubunChk5"><input type="checkbox" id="item_gubunChk5"> 기타</label></li>--%>
						</ul>
					</td>
				</tr>
				<tr>
					<th scope="row">품목군</th>
					<td colspan="3">
						<input type="hidden" name="item_type" id="item_type">
						<ul class="inp_list divide5">
							<c:forEach items="${itemTypeList}" var="item" varStatus="status">
								<li>
									<label for="item_type${status.count}">
										<input type="checkbox" class="form_checkbox" id="item_type${status.count}" name="item_type_arr" value="${item.cdId}"
											   <c:if test="${!empty resultData.itemType and fn:indexOf(resultData.itemType, item.cdId) != -1}">checked</c:if>>
										<c:out value="${item.cdNm}"/>
									</label>
								</li>
							</c:forEach>
							<%--<li><label for="item_type1"><input type="checkbox" id="item_type1"> 농수축산/식품 </label></li>
							<li><label for="item_type2"><input type="checkbox" id="item_type2"> 광산물/기초원료 </label></li>
							<li><label for="item_type3"><input type="checkbox" id="item_type3"> 화학원료/재품</label></li>
							<li><label for="item_type4"><input type="checkbox" id="item_type4"> 화장품/여성용품 </label></li>
							<li><label for="item_type5"><input type="checkbox" id="item_type5"> 귀금속/신변용품</label></li>
							<li><label for="item_type6"><input type="checkbox" id="item_type6"> 주방용품/생활용품</label></li>
							<li><label for="item_type7"><input type="checkbox" id="item_type7"> 섬유/의류/피혁</label></li>
							<li><label for="item_type8"><input type="checkbox" id="item_type8"> 스포츠레져용품 </label></li>
							<li><label for="item_type9"><input type="checkbox" id="item_type9"> 가구/건축자재</label></li>
							<li><label for="item_type10"><input type="checkbox" id="item_type10"> 건강/의료기기</label></li>
							<li><label for="item_type11"><input type="checkbox" id="item_type11"> 전기/전자/통신</label></li>
							<li><label for="item_type12"><input type="checkbox" id="item_type12"> 금속/기계류</label></li>
							<li><label for="item_type13"><input type="checkbox" id="item_type13"> 게임/솔루션/SW등</label></li>
							<li><label for="item_type14"><input type="checkbox" id="item_type14"> 산업설비/엔지니어링</label></li>
							<li><label for="item_type15"><input type="checkbox" id="item_type15"> 기타</label></li>--%>
						</ul>
					</td>
				</tr>
				<tr>
					<th scope="row">학력</th>
					<td colspan="3">
						<textarea id="scholar" name="scholar" rows="3" class="form_textarea"><c:out value="${resultData.scholar}"/></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">자격증</th>
					<td colspan="3">
						<textarea id="license" name="license" rows="3" class="form_textarea"><c:out value="${resultData.license}"/></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">주요이력</th>
					<td colspan="3">
						<textarea id="career" name="career" rows="3" class="form_textarea"><c:out value="${resultData.career}"/></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">활동정지(벌점)</th>
					<td><c:out value="${resultData.qualificationGb}"/></td>
					<th scope="row">숨김여부</th>
					<td>
						<label for="hide"><input type="checkbox" class="form_checkbox" id="hide"> 숨김</label>
					</td>
				</tr>
				<tr>
					<th scope="row">활동정지(기간)</th>
					<td><c:out value="${resultData.stopOperationingDt}"/>-<c:out value="${resultData.startOperationingDt}"/></td>
					<th scope="row">소득구분</th>
					<td>
						<input type="radio" class="form_radio" id="income1" name="income_gb" value="1" <c:if test="${empty resultData.incomeGb or (!empty resultData.incomeGb and resultData.incomeGb eq '1')}">checked</c:if>> <label for="income1">기타소득</label>
						<input type="radio" class="form_radio" id="income2" name="income_gb" value="2" <c:if test="${!empty resultData.incomeGb and resultData.incomeGb eq '2'}">checked</c:if>> <label for="income2">사업소득</label>
					</td>
				</tr>
			</tbody>
		</table><!-- // 통번역 전문위원 상세 테이블-->
	</div> <!-- // .page_tradesos -->
</form>


<script type="text/javascript">

	$(document).ready(function()
	{							//IBSheet 호출
		f_Init_tblSheet();		// 헤더  Sheet 셋팅
		getList();	//목록 조회
	});

	function f_Init_tblSheet() {
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
			DeferredVScroll: 0,
			colresize: true,
			SelectionRowsMode: 1,
			SearchMode: 4,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Seq", Header: "번호"			, SaveName: "rnum"		, Align: "Center"	, Width: 70});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트 명"	, SaveName: "memberNm"	, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트 ID"	, SaveName: "memberId"	, Align: "Left"		, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "이메일"		, SaveName: "emailAddr"	, Align: "Center"	, Width: 100	, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "전화번호"		, SaveName: "handTel"	, Align: "Center"	, Width: 100	, Hidden:true});

		var sheetId = "tblSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		if($('#searchMemberNm').val() != '' && $('#searchMemberId').val() != ''){
			dataConsultList();
		}else{
			tblSheet.LoadSearchData({Data: ''});
		}

	}


	$("input:text[numberOnly]").on({
		keyup: function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		},
		focusout : function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		}
	});

	function expertTpChange(val){
		if (val != "C"){
			$('#expertTp').val('001');
		}else{
			$('#expertTp').val('004');
		}
	}



	function mySheet3_OnClick(Row,Col,Value){
		if(Row > 0){

			var rowData = mySheet3.GetRowData(Row);
			$('#name').val(rowData['memberNm']);
			$('#expertid').val(rowData['memberId']);
			$('#email').val(rowData['emailAddr']);
			$('#email1').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[0] : '');
			$('#email2').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[1] : '');
			if(rowData['handTel'] != ''){
				$('#tel').val(rowData['handTel']);
				if(rowData['handTel'].length = 10){
					$('#tel1').val(rowData['handTel'].substr(0,3));
					$('#tel2').val(rowData['handTel'].substr(3,4));
					$('#tel3').val(rowData['handTel'].substr(7,4));
				}else if(rowData['handTel'].length = 11){
					$('#tel1').val(rowData['handTel'].substr(0,3));
					$('#tel2').val(rowData['handTel'].substr(3,3));
					$('#tel3').val(rowData['handTel'].substr(6,4));
				}
			}

			closePop('searchPop');
		}
	}


</script>
