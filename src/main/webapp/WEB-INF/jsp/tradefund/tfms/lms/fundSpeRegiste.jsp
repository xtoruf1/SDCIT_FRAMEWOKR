<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" enctype="multipart/form-data"  onsubmit="return false;">
<input type="hidden" id="systemMenuId" 	name="systemMenuId" value="0" />
<input type="hidden" id="authId" 		name="authId" 		value="0" />

<input type="hidden" id="statusChk"  	name="statusChk"	value="" />
<input type="hidden" id="svrId"     	name="svrId"		value="" />
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doNew();" 		class="btn_sm btn_primary bnt_modify_auth">추가</a>
		<a href="javascript:doSave();" 		class="btn_sm btn_primary bnt_modify_auth">저장</a>
		<a href="javascript:doDelete();" 	class="btn_sm btn_secondary bnt_modify_auth">삭제</a>
	</div>
	<div class="ml-15">
		<a href="javascript:doClear();" 	class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 	class="btn_sm btn_primary">검색</a>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기금융자년도</th>
				<td>
					<fieldset class="widget">
						<select id="searchYear" name="searchYear" class="form_select" style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="yearList" items="${YEAR_LIST}" varStatus="status">
								<option value="<c:out value="${yearList.searchYear}"/>" <c:if test="${yearList.searchYear eq param.searchYear}">selected="selected"</c:if>><c:out value="${yearList.searchYear}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">기금융자명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchTitle" name="searchTitle" value="<c:out value="${param.search_title}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="기금융자명" maxlength="150" />
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="fund_reg mt-20">
	<div class="left">
		<div class="cont_block" >
			<div class="tbl_opt">
				<!-- 전체 게시글 -->
				<div id="totalCnt" class="total_count"></div>
			</div>
			<div >
				<div id="sheet1" class="sheet"></div>
			</div>
			<div id="paging" class="paging ibs"></div>
		</div>
	</div>
	<div class="right">
		<div class="cont_block">
			<div class="tbl_opt">
				<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
			</div>

			<table class="formTable" id="subTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:20%;">
					<col>
				</colgroup>
				<tr>
					<th colspan="2">무역기금 융자명 <strong class="point">*</strong></th>
					<td >
						<input type="text" class="form_text" placeholder="무역기금융자명" title="무역기금융자명" id="title" name="title" style="width: 99%" maxlength="150" required="required" />
					</td>
				</tr>
				<tr>
					<th rowspan="7">담당자</th>
					<th>이름 <strong class="point">*</strong></th>
					<td>
						<span class="form_search" style="width: 200px;">
							<input type="hidden" id="regEmpId" name="regEmpId" />
							<input type="text" class="form_text" placeholder="담당자 이름" title="담당자 이름" id="regEmpNm" name="regEmpNm" maxlength="100" readonly="readonly" required="required" />
							<button type="button" class="btn_icon btn_search" title="KITANET 아이디검색" onclick="searchUserPopup();"></button>
						</span>
					</td>

				</tr>
				<tr>
					<th>전화 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text" placeholder="담당자전화" title="담당자전화" id="regTel" name="regTel"  maxlength="15" required="required" onkeypress="doKeyPressEvent(this, 'TEL', event)" />
					</td>
				<tr>
					<th>팩스 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text" placeholder="담당자팩스" title="담당자팩스" id="regFax" name="regFax" " maxlength="15" required="required" onkeypress="doKeyPressEvent(this, 'TEL', event)" />
					</td>
				</tr>
				<tr>
					<th>부서 <strong class="point">*</strong></th>
					<td>
						<input type="hidden" id="regDeptCd" name="regDeptCd" />
						<input type="text" class="form_text" placeholder="담당자부서" title="담당자부서" id="regDeptNm" name="regDeptNm"  maxlength="50" readonly="readonly" required="required" />
					</td>
				</tr>
				<tr>
					<th>E-Mail <strong class="point">*</strong></th>
					<td >
						<input type="text" class="form_text" placeholder="이메일" title="이메일" id="regEmail" name="regEmail"  maxlength="150" required="required" />
					</td>
				</tr>
				<tr>
					<th>접수기간 <strong class="point">*</strong></th>
					<td >
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="bsnStartDt" name="bsnStartDt" class="txt datepicker-compare" placeholder="접수기간 시작" title="접수기간 시작" readonly="readonly" required="required" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
							<div class="spacing">~</div>
							<span class="form_datepicker">
								<input type="text" id="bsnEndDt" name="bsnEndDt" class="txt datepicker-compare" placeholder="접수기간 종료" title="접수기간 종료" readonly="readonly" required="required" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger-compare" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>

						</div>
					</td>
				</tr>
				<tr>
					<th>사업기간 <strong class="point">*</strong></th>
					<td >
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="bsnAplStartDt" name="bsnAplStartDt" class="txt datepicker-compare" placeholder="사업기간 시작" title="사업기간 시작" readonly="readonly" required="required" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
							<div class="spacing">~</div>
							<span class="form_datepicker">
								<input type="text" id="bsnAplEndDt" name="bsnAplEndDt" class="txt datepicker-compare" placeholder="사업기간 종료" title="사업기간 종료" readonly="readonly" required="required" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>

						</div>
					</td>
				<tr>
					<th rowspan="3">융자 </th>
					<th>발급일자 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="발급일자 월" id="fund0Mm" name="fund0Mm" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
								<span class="append">월</span>
							</div>
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="발급일자 일" id="fund0Dd" name="fund0Dd" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
								<span class="append">일</span>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>지급일 <strong class="point">*</strong></th>
					<td>
						<div class="flex align_center">
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="융자 지급월" id="fund1Mm" name="fund1Mm" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
								<span class="append">월</span>
							</div>
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="융자 지급일" id="fund1Dd" name="fund1Dd" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
								<span class="append">일</span>
							</div>
						</div>
					</td>
				</tr>

				<tr>
					<th>추천 유효기간 <strong class="point">*</strong></th>
					<td >
						<div class="flex align_center">
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="추천 유효기간 월" id="validMm" name="validMm" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />							</span>
								<span class="append">월</span>
							</div>
							<div class="form_row" style="min-width:100px;">
								<input type="text" class="form_text align_ctr" title="추천 유효기간 일" id="validDd" name="validDd" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" />
								<span class="append">일</span>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th colspan="2">상태</th>
					<td >
						<select id="st" name="st"  class="form_select" style="width:100px; ">
							<c:forEach var="item" items="${LMS001}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>"><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th colspan="2">첨부파일</th>
					<td >
						<input type="hidden" id="attFileId" 	name="attFileId" />
						<input type="hidden" id="fileId" 		name="fileId" />
						<input type="hidden" id="fileNo" 		name="fileNo" />
						<div id="attachFieldList"></div>
						<div class="form_group">
							<div class="form_file flex-1">
								<p class="file_name">첨부파일을 선택하세요</p>
								<label class="file_btn">
									<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
									<input type="hidden" name="attachFileSeq" value="1" />
									<span class="btn_tbl">찾아보기</span>
								</label>
							</div>
							<button type="button btn_modify_auth" onclick="doAddAttachField();" class="btn_tbl_border">추가</button>
						</div>
						<div id="attachFieldEdit"></div>
					</td>
				</tr>
			 </table>
		</div>
	</div>
</div>
</form>

<script type="text/javascript">
	$(document).ready(function(){
		setExpPhoneNumber(['#regTel', '#regFax'], 'W');
		// DATE PICKER
		compareSEDatepicker('datepicker-compare');
		$('.ui-datepicker-trigger-compare').on('click', function(){
			$(this).datepicker('show');
		});

		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",           	Type:"Int",       Hidden:false, Width:30,   Align:"Center",  SaveName:"rn"             });
		ibHeader.addHeader({Header:"No",           	Type:"Seq",       Hidden:true, Width:30,   Align:"Center",  SaveName:"no"             });
		ibHeader.addHeader({Header:"",             	Type:"Text",      Hidden:true,  Width:20,   Align:"Center",  SaveName:"chk"            });
		ibHeader.addHeader({Header:"기금융자코드",      Type:"Text",      Hidden:true,  Width:120,  Align:"Center",  SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"기금융자명",      	Type:"Text",      Hidden:false, Width:260,  Align:"Left",    SaveName:"title",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"융자세부내역",      Type:"Text",      Hidden:true,  Width:120,  Align:"Center",  SaveName:"bodyDesc",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간",        	Type:"Text",      Hidden:true,  Width:120,  Align:"Center",  SaveName:"bsnDt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간시작",      Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"bsnStartDt",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간종료",      Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"bsnEndDt",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업기간_시작",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"bsnAplStartDt", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업기간_종료",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"bsnAplEndDt",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"업무시작예정일",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"procInitDt",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"KITANET 아이디",       	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regEmpId",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자",         	Type:"Text",      Hidden:true,  Width:60,   Align:"Center",  SaveName:"regEmpNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자부서코드",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regDeptCd",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자부서명",      Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regDeptNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자전화번호",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regTel",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자팩스번호",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regFax",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자이메일",      Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"regEmail",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"첨부파일ID",      	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"attFileId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"첨부파일건수",      Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fileCnt",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"발급일자",        	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund0Mm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"발급일자",        	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund0Dd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자1차지급월",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund1Mm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자1차지급일",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund1Dd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자2차지급월",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund2Mm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자2차지급",      	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund2Dd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천유효기간월",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"validMm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천유효기간일",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"validDd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"신청",           	Type:"Int",      Hidden:false, Width:50,   Align:"Center",  SaveName:"svrCnt",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"상태",           	Type:"Combo",     Hidden:false, Width:50,   Align:"Center",  SaveName:"st",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saLMS001.detailcd}"/>", ComboText: "<c:out value="${saLMS001.detailnm}"/>"  });
		ibHeader.addHeader({Header:"파일리스트",       	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund3Mm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자3차지급월",     Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"fund3Dd",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자3차지급일",    	Type:"Text",      Hidden:true,  Width:100,  Align:"Center",  SaveName:"attFileList",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, UseHeaderSortCancel: 1, MaxSort: 1 });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "570px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

		sheet1.SetDataLinkMouse("no", true);
		sheet1.SetDataLinkMouse("title", true);
		sheet1.SetDataLinkMouse("svrCnt", true);
		sheet1.SetDataLinkMouse("st", true);

	}
	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
		sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchTitle.value = "";
		f.searchYear.options[0].selected = true;
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/lms/selectFundSpeRegisteList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//추가
	function doNew(){
	    var f = document.form1;
	    var sheetObj = sheet1;

	    f.statusChk.value = 'I';
	    f.svrId.value = "";
	    f.title.value = "";
	    f.bsnStartDt.value = "";
	    f.bsnEndDt.value = "";
	    f.bsnAplStartDt.value = "";
	    f.bsnAplEndDt.value = "";
 	    f.attFileId.value = "";
	    f.fund0Mm.value = "";
	    f.fund0Dd.value = "";
	    f.fund1Mm.value = "";
	    f.fund1Dd.value = "";
	    f.validMm.value = "";
	    f.validDd.value = "";
	    f.st.value = "01";

	    f.regEmpId.value = '<c:out value="${user.memberId}"/>';
	    f.regEmpNm.value = '<c:out value="${user.memberNm}"/>';
		f.regDeptCd.value = '<c:out value="${user.fundDeptCd}"/>';
		f.regDeptNm.value = '<c:out value="${user.fundDeptNm}"/>';
	    f.regTel.value = '<c:out value="${user.telNo}"/>';
	    f.regEmail.value = '<c:out value="${user.email}"/>';
	    f.regFax.value = '<c:out value="${user.faxNo}"/>';

		$('#attachFieldList').empty();
		$('#attachFieldEdit').empty();
	}

	//등록
	function doSave(){
		var f = document.form1;
		var flag = true;

		if(!doValidFormRequired(f)) return;
		if(!validation_form1()) return;

		$('input[name=attachFile]').each(function (index, item) {
			var fileVal = $(item).val();
			if (isStringEmpty(fileVal)) {
	        	$(item).prop('disabled', true);
	        } else {

	        	var fileChk = fileVal.substring(fileVal.lastIndexOf(".")+1);
	        	if(fileChk.toLowerCase() == "jpg" || fileChk.toLowerCase() == "gif" || fileChk.toLowerCase() == "png"
	        		|| fileChk.toLowerCase() == "bmp" || fileChk.toLowerCase() == "jpeg"){
	        	}else{
	        		alert("이미지 파일만 올려주세요.");
	        		flag = false;
	        	}
	        }
		});

		if (flag){
			global.ajaxSubmit($('#form1'), {
				type : 'POST'
				, url : '<c:url value="/tfms/lms/saveFundSpeRegiste.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					alert('융자등록을 저장하였습니다.');
					getList();
		        }
			});
		}
	}

	//삭제
	function doDelete(){
		var f = document.form1;

		if(f.st.value == '02'){
			alert("심사중인 융자건입니다. 삭제 하실수 없습니다.");
			return;
		}
		if(f.st.value == '03'){
			alert("완료된 융자건은 삭제 하실수 없습니다.");
			return;
		}

		if(!confirm("삭제하시겠습니까?"))
			return;

		f.statusChk.value = 'D';

		global.ajaxSubmit($('#form1'), {
			type : 'POST'
			, url : '<c:url value="/tfms/lms/deleteFundSpeRegiste.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				alert('융자를 삭제 하였습니다.');
				$("#svrId").val("");
				getList();
	        }
		});
	}

	//유효성 검사
	function validation_form1(){
		var f = document.form1;

		if(f.fund0Mm.value > 12){
			alert("1~12 사이 월을 입력 바랍니다.");
			f.fund0Mm.focus();
			return false;
		}
		if(f.fund1Mm.value > 12){
			alert("1~12 사이 월을 입력 바랍니다.");
			f.fund1Mm.focus();
			return false;
		}

		if(f.validMm.value > 12){
			alert("1~12 사이 월을 입력 바랍니다.");
			f.validMm.focus();
			return false;
		}

		if(f.fund0Dd.value > 31){
			alert("1~31 사이 일을 입력 바랍니다.");
			f.fund0Dd.focus();
			return false;
		}
		if(f.fund1Dd.value > 31){
			alert("1~31 사이 일을 입력 바랍니다.");
			f.fund1Dd.focus();
			return false;
		}

		if(f.validDd.value > 31){
			alert("1~31 사이 일을 입력 바랍니다.");
			f.validDd.focus();
			return false;
		}
		return true;
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
				var OtherDayName = '';
				var cpDayName = '';
				var isStart = true;
				if( thisDayName == 'bsnStartDt'){
					OtherDayName = 'bsnEndDt';
					cpDayName = 'bsnAplStartDt';
					isStart = true;
				} if ( thisDayName == 'bsnEndDt'){
					OtherDayName = 'bsnStartDt';
					cpDayName = 'bsnAplEndDt';
					isStart = false;
				} if ( thisDayName == 'bsnAplStartDt'){
					OtherDayName = 'bsnAplEndDt';
					cpDayName = 'bsnStartDt';
					isStart = true;
				} if ( thisDayName == 'bsnAplEndDt'){
					OtherDayName = 'bsnAplStartDt';
					cpDayName = 'bsnEndDt';
					isStart = false;
				}

				if( $('#' + cpDayName)  ) {
					$('#' + cpDayName).val(dateString);
				}

				if($('#' + thisDayName).val() != "" && $('#' + OtherDayName).val() != ""){
					if(isStart){
						var dArrayS = $('#' + thisDayName).val().split("-");
						var dArrayE = $('#' + OtherDayName).val().split("-");
					}else{
						var dArrayS = $('#' + OtherDayName).val().split("-");
						var dArrayE = $('#' + thisDayName).val().split("-");
					}
					var Sday=new Date(dArrayS[0],dArrayS[1],dArrayS[2]);
					var Eday=new Date(dArrayE[0],dArrayE[1],dArrayE[2]);
					if(Sday>Eday){
						alert("사업기간 일자를 확인 바랍니다.");
						$('#' + thisDayName).val('');
						$('#' + cpDayName).val('');
					}
				}
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});
	}

	//행 선택 이벤트 ( From 값 매핑)
	function getValue(row){
		var formObj = document.form1;
		var sheetObj = sheet1;
		setFormFromSheet(formObj, sheetObj, row);

		formObj.statusChk.value = 'U';

		$('#attachFieldList').empty();
		$('#attachFieldEdit').empty();

		var attFileList = sheet1.GetCellValue(row, "attFileList");

		if ( attFileList != "-1" ) {
			var fileList = attFileList.split('@');
			var fileNoArr = fileList[0].split('^');
			var fileNameArr = fileList[1].split('^');

			for( var i = 0 ; i < fileNoArr.length ; i++ ){
				var fileNo = fileNoArr[i];
				var fileName = fileNameArr[i];
				if( fileNo != ''){
					var html = '';
					html += '<div class="addedFile" id="fileNo_'+fileNo+'" >';
					html += '	<a href="javascript:doDownloadFile(\''+fileNo+'\');" class="filename">' +fileName;
					html += '	</a> ';
					html += '	<a href="javascript:doDeleteFile(\''+fileNo+'\');" class="btn_del">';
					html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
					html += '	</a>';
					html += '</div>';

					$('#attachFieldList').append(html);
				}
			}
		}
		setExpPhoneNumber(['#regTel', '#regFax'], 'W');
		$('#attachFile').prop('disabled', false);
		$('#attachFile').val('');
		$('.file_name').text('첨부파일을 선택하세요');
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
	}

	// 첨부파일 필드 추가
	function doAddAttachField() {
		var attachCnt = 0;
		$('input[name="attachFileSeq"]').each(function(){
			attachCnt = $(this).val();
		});

		var attachFileSeq = parseInt(attachCnt) + 1;

		var html = '';
		html += '<div id="field' + attachFileSeq + '" class="mb5px flex mt-5">';
		html += '	<div class="form_file flex-1">';
		html += '		<p class="file_name">첨부파일을 선택하세요</p>';
		html += '		<label class="file_btn">';
		html += '			<input type="file" name="attachFile" class="txt" title="첨부파일" />';
		html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
		html += '			<span class="btn_tbl">찾아보기</span>';
		html += '		</label>';
		html += '	</div>';
		html += '	<button type="button btn_modify_auth" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	//첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var form = document.form1;
		form.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		form.fileNo.value = fileNo;
		form.fileId.value = form.attFileId.value;
		form.target = '_self';
		form.submit();
	}

	//첨부파일 삭제
	function doDeleteFile(fileNo) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundFileDelete.do" />'
				, data : {
					fileId : $('#attFileId').val()
					, fileNo : fileNo
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 파일을 삭제하였습니다.');
					$('#fileNo_' + fileNo).hide();
				}
			});
		}
	}

	//담당자 팝업
	function searchUserPopup(){
	var userEmail = '<c:out value="${user.email}" />';

		global.openLayerPopup({
			popupUrl : '<c:url value="/sycs/user/searchUserPopup.do" />'
			, params : {
				fundGb : 'F'
			}
			, callbackFunction : function(resultObj){
				if (resultObj != null) {
					$("input[name=regEmpId]").val(resultObj.memberId);	//KITANET 아이디
					$("input[name=regEmpNm]").val(resultObj.memberNm);	//성명
					$("input[name=regDeptCd]").val(resultObj.deptCd);	//부서코드
					$("input[name=regDeptNm]").val(resultObj.deptNm);	//부서명
					$("input[name=regTel]").val(resultObj.telNo);		//전화번호
					$("input[name=regFax]").val(resultObj.faxNo);		//팩스번호
					$("input[name=regEmail]").val(userEmail);		//E-MAIL
			    }
			}
		});
	}


	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			getValue(row);
		}
	}

 	function sheet1_OnRowSearchEnd(row) {
 		if ( row > 0) {
 	 		var index = sheet1.GetCellValue(row, "no");
 	 		var resultCnt = $('#resultCnt').val();
 	 		sheet1.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
 	 	}
	}

	function sheet1_OnSearchEnd(code, msg) {
		if (code != 0) {
    	} else {
    		var f = document.form1;
    		if(f.svrId.value != ''){
    			var rowNum = sheet1.FindText('svrId', f.svrId.value);
    			sheet1.SetSelectRow(rowNum, 'svrId', false, false);
	    		getValue(rowNum);
     	 	}else{
       			sheet1.SetSelectRow(sheet1.GetDataFirstRow());
   	    		getValue(sheet1.GetDataFirstRow());
    		}
    	}
    }

</script>