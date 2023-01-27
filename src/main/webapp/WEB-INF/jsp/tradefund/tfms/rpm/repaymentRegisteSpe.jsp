<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<%-- <input type="hidden" name="pageIndex"			id="pageIndex"  		value="<c:out value='${param.pageIndex}' 	default='1' />" /> --%>

<input type="hidden" name="hFndDt" value="" />
<input type="hidden" name="hFndYdt1" value="" />
<input type="hidden" name="hFndYdt2" value="" />
<input type="hidden" name="hFndYdt3" value="" />
<input type="hidden" name="hFndYdt4" value="" />

<input type="hidden" id="fndDay1" name="fndDay1" value="" />
<input type="hidden" id="fndDay2" name="fndDay2" value="" />
<input type="hidden" id="fndDay3" name="fndDay3" value="" />
<input type="hidden" id="fndDay4" name="fndDay4" value="" />


<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doSave();" 		class="btn_sm btn_primary">자료 생성</a>
		<a href="javascript:doDelete();" 	class="btn_sm btn_secondary">삭제</a>
	</div>

	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<a href="javascript:doSearch();" 	class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" rowspan="2">융자년월</th>
				<td rowspan="2">
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="searchYyyymm" name="searchYyyymm" value="" class="txt monthpicker" placeholder="융자년월" title="융자년월" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchYyyymm');" class="ui-monthpicker-trigger" alt="융자년월" title="융자년월" />
						</span>
						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('searchYyyymm');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
				<th scope="row">1차상환일</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="fndYdt1" name="fndYdt1"  class="txt datepicker" placeholder="1차상환일" title="1차상환일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartAloneDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('fndYdt1');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
				<th scope="row">2차상환일</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="fndYdt2" name="fndYdt2"  class="txt datepicker" placeholder="2차상환일" title="2차상환일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartAloneDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('fndYdt2');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
            </tr>
			<tr>
				<th scope="row">3차상환일</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="fndYdt3" name="fndYdt3"  class="txt datepicker" placeholder="3차상환일" title="3차상환일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartAloneDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('fndYdt3');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
				<th scope="row">4차상환일</th>
				<td>
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="fndYdt4" name="fndYdt4"  class="txt datepicker" placeholder="4차상환일" title="4차상환일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartAloneDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('fndYdt4');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
            </tr>

		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
	<%-- 	<div id="totalCnt" class="total_count"></div>

		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doSearch();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset> --%>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
<!-- 	<div id="paging" class="paging ibs"></div> -->
</div>

</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		//getList();

		$('#searchYyyymm').attr("onchange", 'changeSelectDate(this.value)');

		$('.datepicker').datepicker('destroy');

		$('.datepicker').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString, inst) {
				var inputId = inst.id;
				var num = inputId.slice(-1);

				var fndWeekYdt = new Date(dateString).getDay();

				$('#fndDay'+num).val(fndWeekYdt);

				if(fndWeekYdt == '6') {
					$('#fndYdt'+num).css('color','#0000FF');
				} else if(fndWeekYdt == '0') {
					$('#fndYdt'+num).css('color','#FF0000');
				} else {
					$('#fndYdt'+num).css('color','#595A5A');
				}

			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});
	});

	function changeSelectDate(val) {

		var sVal = val;

		var date = new Date(sVal);

		var dateYear = date.getFullYear();

		var dateBungi = Math.ceil((date.getMonth()+ 1)/3);

		if(dateBungi == 1) {
			var fndYdt1 = dateYear+2 + '-' + '04-25';
			var fndYdt2 = dateYear+2 + '-' + '07-25';
			var fndYdt3 = dateYear+2 + '-' + '10-25';
			var fndYdt4 = dateYear+3 + '-' + '01-25';
		}

		if(dateBungi == 2) {
			var fndYdt1 = dateYear+2 + '-' + '07-25';
			var fndYdt2 = dateYear+2 + '-' + '10-25';
			var fndYdt3 = dateYear+3 + '-' + '01-25';
			var fndYdt4 = dateYear+3 + '-' + '04-25';
		}

		if(dateBungi == 3) {
			var fndYdt1 = dateYear+2 + '-' + '10-25';
			var fndYdt2 = dateYear+3 + '-' + '01-25';
			var fndYdt3 = dateYear+3 + '-' + '04-25';
			var fndYdt4 = dateYear+3 + '-' + '07-25';
		}

		if(dateBungi == 4) {
			var fndYdt1 = dateYear+3 + '-' + '01-25';
			var fndYdt2 = dateYear+3 + '-' + '04-25';
			var fndYdt3 = dateYear+3 + '-' + '07-25';
			var fndYdt4 = dateYear+3 + '-' + '10-25';
		}

		$('#fndYdt1').val(fndYdt1);
		$('#fndYdt2').val(fndYdt2);
		$('#fndYdt3').val(fndYdt3);
		$('#fndYdt4').val(fndYdt4);

		var fndWeekYdt1 = new Date(fndYdt1).getDay();
		var fndWeekYdt2 = new Date(fndYdt2).getDay();
		var fndWeekYdt3 = new Date(fndYdt3).getDay();
		var fndWeekYdt4 = new Date(fndYdt4).getDay();

		$('#fndDay1').val(fndWeekYdt1);
		$('#fndDay2').val(fndWeekYdt2);
		$('#fndDay3').val(fndWeekYdt3);
		$('#fndDay4').val(fndWeekYdt4);

		if(fndWeekYdt1 == '6') {
			$('#fndYdt1').css('color','#0000FF');
		} else if(fndWeekYdt1 == '0') {
			$('#fndYdt1').css('color','#FF0000');
		} else {
			$('#fndYdt1').css('color','#595A5A');
		}

		if(fndWeekYdt2 == '6') {
			$('#fndYdt2').css('color','#0000FF');
		} else if(fndWeekYdt2 == '0') {
			$('#fndYdt2').css('color','#FF0000');
		} else {
			$('#fndYdt2').css('color','#595A5A');
		}

		if(fndWeekYdt3 == '6') {
			$('#fndYdt3').css('color','#0000FF');
		} else if(fndWeekYdt3 == '0') {
			$('#fndYdt3').css('color','#FF0000');
		} else {
			$('#fndYdt3').css('color','#595A5A');
		}

		if(fndWeekYdt4 == '6') {
			$('#fndYdt4').css('color','#0000FF');
		} else if(fndWeekYdt4 == '0') {
			$('#fndYdt4').css('color','#FF0000');
		} else {
			$('#fndYdt4').css('color','#595A5A');
		}

		doSearch();
	}

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"선택|선택",               	Type:"CheckBox",  Hidden:false,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"delCheck"           });
        ibHeader.addHeader({Header:"Status|Status",        	Type:"Status",    Hidden:true,   Width:80,   Align:"Center",  ColMerge:1,   SaveName:"status"             });
        ibHeader.addHeader({Header:"지역본부|지역본부",         	Type:"Text",      Hidden:false,  Width:120,  Align:"Left",    ColMerge:1,   SaveName:"tradeDeptNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호|무역업번호",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Left",    ColMerge:1,   SaveName:"bsNo",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30});
        ibHeader.addHeader({Header:"회사명|회사명",             Type:"Text",      Hidden:false,  Width:180,  Align:"Left",    ColMerge:1,   SaveName:"coNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"사업자번호|사업자번호",     	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"industryNoNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"신청액|신청액",             Type:"Float",     Hidden:false,  Width:120,  Align:"Right",   ColMerge:1,   SaveName:"necessAmount",      CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천|추천일",             	Type:"Text",      Hidden:false,  Width:145,   Align:"Center",                SaveName:"recdDate",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"추천|추천액",             	Type:"Float",     Hidden:false,  Width:145,   Align:"Right",                 SaveName:"recdAmount",        CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|융자일",             	Type:"Text",      Hidden:false,  Width:145,   Align:"Center",                SaveName:"recdDt",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|융자금",             	Type:"AutoSum",   Hidden:false,  Width:145,   Align:"Right",                 SaveName:"defntAmount",       CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|2차융자일",            Type:"Text",      Hidden:true,   Width:80,   Align:"Center",                SaveName:"recdDt2",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|2차융자금",            Type:"Text",      Hidden:true,   Width:90,   Align:"Right",                 SaveName:"defntAmount2",      CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|3차융자일",            Type:"Text",      Hidden:true,   Width:80,   Align:"Center",                SaveName:"recdDt3",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자|3차융자금",            Type:"Text",      Hidden:true,   Width:90,   Align:"Right",                 SaveName:"defntAmount3",      CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자은행|융자은행",         	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"mainBankNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
        ibHeader.addHeader({Header:"융자지점명|융자지점명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"mainBankBranchNm",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30});
        ibHeader.addHeader({Header:"생성여부|생성여부",         	Type:"Text",      Hidden:false,  Width:88,   Align:"Center",  ColMerge:1,   SaveName:"cnt",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"융자은행코드|융자은행코드", 	Type:"Text",      Hidden:true,   Width:80,   Align:"Left",    ColMerge:1,   SaveName:"mainBankCd",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"은행변경|은행변경",         	Type:"Text",      Hidden:true,   Width:80,   Align:"Left",    ColMerge:1,   SaveName:"bankYn",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
        ibHeader.addHeader({Header:"중도상환|중도상환",         	Type:"Text",      Hidden:true,   Width:80,   Align:"Left",    ColMerge:1,   SaveName:"fndYn",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0,  FrozenCol:7, statusColHidden: true,MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//조회
	function doSearch() {
		getList();
	}

	//페이징 조회
	/* function goPage(pageIndex) {
		var form = document.form1;
		form.pageIndex.value = pageIndex;
		getList();
	} */

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/selectRepaymentRegisteSpeList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				/* setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					); */

				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//저장 처리
	function doSave() {

		var f = document.form1;

		if(f.searchYyyymm.value == "" || f.searchYyyymm.value == null){
			alert("융자년월을 선택해주세요.");
			return;
		}

		/*
		if(parseFloat(f.hFndYdt1.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt1.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			f.fndYdt1.focus();
			return;

		}

		if(parseFloat(f.hFndYdt2.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt2.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			f.fndYdt2.focus();
			return;

		}

		if(parseFloat(f.hFndYdt3.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt3.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			f.fndYdt3.focus();
			return;

		}

		if(parseFloat(f.hFndYdt4.value.replace(/-/gi ,"").substring(0, 6)) != parseFloat(f.fndYdt4.value.replace(/-/gi ,"").substring(0, 6))){

			alert("일 까지만 바꿀수 있습니다.");
			f.fndYdt4.focus();
			return;

		}
		*/

		if(f.searchYyyymm.value.replace(/-/gi ,"").substring(0, 4) > '2012'){

			if(f.fndDay1.value == "0" || f.fndDay1.value == "6"){
				alert("1차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
				f.fndYdt1.focus();
				return;
			}

			if(f.fndDay2.value == "0" || f.fndDay2.value == "6"){
				alert("2차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
				f.fndYdt2.focus();
				return;
			}

			if(f.fndDay3.value == "0" || f.fndDay3.value == "6"){
				alert("3차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
				f.fndYdt3.focus();
				return;
			}

			if(f.fndDay4.value == "0" || f.fndDay4.value == "6"){
				alert("4차 상환일이 공휴일입니다. 상환일자를 변경해 주세요.");
				f.fndYdt4.focus();
				return;
			}

		}

		var sheetObj = sheet1;
		var checkCount = 0;

		if(sheetObj.RowCount() <= 0){
			alert("생성할 상환자료가 없습니다.");
			return;
		}

		for(var i = 2; sheetObj.LastRow() >= i; i++){

			if(sheetObj.GetCellValue(i, "delCheck") == "1" && sheetObj.GetCellValue(i , "cnt") == "생성"){
				alert("이미 생성된 상환자료가 있습니다.");
				return;
			}

			if(sheetObj.GetCellValue(i, "delCheck") == "1"){
				checkCount++;
			}

		}

		if(checkCount <= 0){
			alert("선택된 자료가 없습니다.");
			return;
		}

		if(!confirm("생성하시겠습니까?")){
			return;
		}

		var saveJson = sheet1.GetSaveJson();
		var ccf = getSaveDataSheetList('form1' , saveJson);

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/saveRepaymentRegisteSpeList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('생성하였습니다.');
				getList();
			}
		});
	}

	//삭제 처리
	function doDelete(){

		var f = document.form1;

		var delMsg = "";

		var delCom = "";

		var delFnd = "";
		var delBank = "";

		if(f.searchYyyymm.value == "" || f.searchYyyymm.value == null){
			alert("융자년월을 선택해주세요.");
			return;
		}

		var sheetObj = sheet1;
		var checkCount = 0;

		if(sheetObj.RowCount() <= 0){
			alert("삭제할 상환자료가 없습니다.");
			return;
		}

		for(var i = 2; sheetObj.LastRow() >= i; i++){
			if(sheetObj.GetCellValue(i, "delCheck") == "1" && sheetObj.GetCellValue(i , "cnt") == "미생성"){
				alert("삭제할 상환자료가 없습니다.");
				return;
			}

			if(sheetObj.GetCellValue(i, "delCheck") == "1"){
				checkCount++;
			}

			if(sheetObj.GetCellValue(i, "delCheck") == "1" && sheetObj.GetCellValue(i, "bankYn") == 'Y'){
				delCom = sheetObj.GetCellValue(i, "coNmKor");
				delBank += delCom + " ";
			}

			if(sheetObj.GetCellValue(i, "delCheck") == "1" && sheetObj.GetCellValue(i, "fndYn") == 'Y'){
				delCom = sheetObj.GetCellValue(i, "coNmKor");
				delFnd += delCom + " ";
			}
		}

		if(delFnd != "") delFnd += " 상환내역에 중도상환 내역이 있습니다. ";
		if(delBank != "") delBank += " 상환내역에 은행변경 내역이 있습니다. ";

		delMsg += delFnd + "\n" + delBank + "\n 삭제하시겠습니까?";

		if(checkCount <= 0){
			alert("선택된 자료가 없습니다.");
			return;
		}

		if(!confirm(delMsg)){
			return;
		}

		var saveJson = sheet1.GetSaveJson();
		var ccf = getSaveDataSheetList('form1' , saveJson);

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/rpm/deleteRepaymentRegisteSpeList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('삭제되었습니다.');
				getList();
			}
		});
	}

	function gResizeFrame() {
		if(typeof window.parent.window.uiInitIframe == 'function') {
			window.parent.window.uiInitIframe(null);
		}
	}

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		var sName = sheet1.ColSaveName(Col);
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		with(sheet1) {
			for(var i=1; i<=LastRow(); i++){

				if(GetCellValue(i, "cnt") == "미생성"){
					SetCellFontColor(i, "cnt",'#0000ff');
				}
			}
		}
    }


</script>