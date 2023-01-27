<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="page_voucher">
	<form id="frm" name="frm">
	<input type="hidden" id="pageIndex" name="pageIndex" value="1">
	<input type="hidden" id="insId" name="insId"/>
		<div class="cont_block">
			<div class="tbl_opt">
				<div id="totalCnt" class="total_count"></div>

				<select name="pageUnit" class="form_select ml-auto" onchange="chgPageCnt();">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}">${item.codeNm}</option>
					</c:forEach>
				</select>

				<div class="ml-15">
					<button type="button" id="btnAdd" class="btn_sm btn_primary btn_modify_auth" onclick="addInsurance();">추가</button>
					<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="saveInsurance();">저장</button>
				</div>
			</div>

			<div>
				<div id="insuranceRegistListSheet" class="sheet"></div>
			</div>
			<div id="paging" class="paging ibs"></div>
		</div>

		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">수출단체보험 사업정보</h3>
				<div class="btnGroup ml-auto">
					<button type="button" id="btnDel" class="btn_sm btn_secondary btn_modify_auth" onclick="deleteInsurance();">삭제</button>
				</div>
			</div>


			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col/>
					<col style="width:15%;" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th>대상년도 <strong class="point">*</strong></th>
						<td colspan="3">
							<input type="text" class="form_text wAuto" name="baseYear" id="baseYear" maxlength="4" />
						</td>
					</tr>
					<tr>
						<th>사업명 <strong class="point">*</strong></th>
						<td colspan="3">
							<input type="text" class="form_text w100p" name="insTitle" id="insTitle" value="" maxlength="60"/>
						</td>
					</tr>
					<tr>
						<th>접수시작일 <strong class="point">*</strong></th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="reqStartDate" id="reqStartDate" class="txt datepicker" title="접수시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('reqStartDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</td>
						<th>접수종료일 <strong class="point">*</strong></th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="reqEndDate" id="reqEndDate" class="txt datepicker" title="접수종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('reqEndDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</td>
					</tr>
					<tr>
						<th>사업시작일 <strong class="point">*</strong></th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="insStartDate" id="insStartDate" class="txt datepicker" title="사업시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('insStartDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</td>
						<th>사업종료일 <strong class="point">*</strong></th>
						<td>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="insEndDate" id="insEndDate" class="txt datepicker" title="사업종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('insEndDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</td>
					</tr>
					<tr>
						<th>사업예산</th>
						<td>
							<div class="flex align_center">
								<input type="text" class="form_text w100p" style="text-align: right"; name="budgetAmt" id="budgetAmt" placeholder="사업예산 금액" onblur="numFormat();" style="padding-right: 5px;" maxlength="15" />
								<input type="text" class="form_text w100p ml-8" name="budgetName" id="budgetName" placeholder="사업예산 지원처"  maxlength="30"/>
							</div>
						</td>
						<th>등급정보</th>
						<td>로얄(21년), 골드(11년), 실버(1년)</td>
					</tr>
					<tr>
						<th>특이사항</th>
						<td colspan="3">
							<textarea id="dscr" name="dscr" rows="5" class="form_textarea" maxlength="1000"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">보험정보</h3>
			</div>

			<div>
				<div id="insuranceList" class="sheet"></div>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	var addChk = "";

	$(document).ready(function(){
		setSheetHeader_insuranceRegistList();		// 사업 리스트 헤더
		setSheetHeader_insuranceList();				// 보험 리스트 헤더
		getInsuranceRegistList();					// 사업 리스트 조회

		// 시작일 선택 이벤트
		datepickerById('reqStartDate', fromDateSelectEvent1);

		// 종료일 선택 이벤트
		datepickerById('reqEndDate', toDateSelectEvent1);

		// 시작일 선택 이벤트
		datepickerById('insStartDate', fromDateSelectEvent2);

		// 종료일 선택 이벤트
		datepickerById('insEndDate', toDateSelectEvent2);
	});

	function fromDateSelectEvent1() {
		var startymd = Date.parse($('#reqStartDate').val());

		if ($('#reqEndDate').val() != '') {
			if (startymd > Date.parse($('#reqEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#reqStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent1() {
		var endymd = Date.parse($('#reqEndDate').val());

		if ($('#reqStartDate').val() != '') {
			if (endymd < Date.parse($('#reqStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#reqEndDate').val('');

				return;
			}
		}
	}


	function fromDateSelectEvent2() {
		var startymd = Date.parse($('#insStartDate').val());

		if ($('#insEndDate').val() != '') {
			if (startymd > Date.parse($('#insEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#insStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent2() {
		var endymd = Date.parse($('#insEndDate').val());

		if ($('#insStartDate').val() != '') {
			if (endymd < Date.parse($('#insStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#insEndDate').val('');

				return;
			}
		}
	}

	function setSheetHeader_insuranceRegistList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '단체보험ID'	, Type: 'Text', SaveName: 'insId'		, Edit: false	, Width: 10		, Hidden: true});
		ibHeader.addHeader({Header: '사업년도'		, Type: 'Text', SaveName: 'baseYear'	, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'		, Type: 'Text', SaveName: 'insTitle'	, Edit: false	, Width: 80		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '접수기간'		, Type: 'Text', SaveName: 'insDate'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업기간'		, Type: 'Text', SaveName: 'reqDate'		, Edit: false	, Width: 40		, Align: 'Center'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#insuranceRegistListSheet')[0];
		createIBSheet2(container, 'insuranceRegistListSheet', '100%', '100%');
		ibHeader.initSheet('insuranceRegistListSheet');

		insuranceRegistListSheet.SetEllipsis(1); 			// 말줄임 표시여부
		insuranceRegistListSheet.SetSelectionMode(4);		// 셀 선택 모드 설정

	}

	function setSheetHeader_insuranceList() {	// 보험 서비스 리스트 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '구분|구분'			, Type: 'Text'		, SaveName: 'insName'			, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '수출실적(USD)|'		, Type: 'Int'		, SaveName: 'minExpAmt'			, Edit: true	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '수출실적(USD)|~'		, Type: 'Text'		, SaveName: ''					, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '수출실적(USD)|'		, Type: 'Int'		, SaveName: 'maxExpAmt'			, Edit: true	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '업체부답금(원)|로얄'		, Type: 'Int'		, SaveName: 'selfCostRoyal'		, Edit: true	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '업체부답금(원)|골드'		, Type: 'Int'		, SaveName: 'selfCostGold'		, Edit: true	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '업체부답금(원)|실버'		, Type: 'Int'		, SaveName: 'selfCostSilver'	, Edit: true	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '상태'				, Type: 'Status'	, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '보험ID'				, Type: 'Text'		, SaveName: 'insCode'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#insuranceList')[0];
		createIBSheet2(container, 'insuranceList', '100%', '100%');
		ibHeader.initSheet('insuranceList');

		insuranceList.SetEllipsis(1); 			// 말줄임 표시여부

	}

	function insuranceRegistListSheet_OnSearchEnd() {
		// 사업명에 볼드 처리
		insuranceRegistListSheet.SetColFontBold('insTitle', 1);
	}

	function insuranceList_OnRowSearchEnd(row) {
		notEditableCellColor('insuranceList', row);
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getVoucherList();
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getInsuranceRegistList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function insuranceRegistListSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) { // 사업 리스트 포커스 이동시

		if(oldRow == newRow){ // 이전 클릭 행이 새로 클릭한 행과 같으면
			return;
		}

		if(newCol == 2) {
			var insId = insuranceRegistListSheet.GetCellValue(newRow,'insId');	// 현재 선택된 사업 insId 세팅

			getInsuranceInfo(insId);	// 보험 상세정보 조회

			$('#insId').val(insId);
		}
	}

	function getInsuranceRegistList() {	// 사업정보 조회

		var frm = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/insurance/selectInsuranceRegistList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(frm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCnt) + '</span> 건');

				insuranceRegistListSheet.LoadSearchData({Data: data.resultList}, {	// 조회한 데이터 시트에 적용
					Sync: 1
				});

				insuranceRegistListSheet.SelectCell(1,'insTitle');	// 리스트 최상단 데이터 선택
				addChk = "";
			}
		});
	}

	function getInsuranceInfo(insId) {	// 보험 상세정보 조회

		global.ajax({
			type : 'POST'
			, url : '/insurance/selectInsuranceRegistInfo.do'
			, data : {'insId' : insId}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				insuranceList.LoadSearchData({Data: data.insuranceTypeList});	// 보험 정보 조회

				var key1 = Object.keys(data.resultInfo);

				for(var i = 0; i < key1.length; i++) {

					if(key1[i] == 'paginationInfo'){
						continue;
					} else if(key1[i] == 'insId'){
						continue;
					} else {
						var value = data.resultInfo[key1[i]];
					}

					$('#'+key1[i]).val(value);
				}

				numFormat();
				addChk = "";
				$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);
			}
		});
	}

	function saveValid(){	// 보험 상세정보 validation

		var numChk = /[^0-9]/;

		if($("#baseYear").val() == ""){
			alert("대상년도는 필수입니다.");
			$("#baseYear").focus();
			return false;
		} else {
			if(numChk.test($('#baseYear').val())) {
				alert('숫자만 입력해 주세요.');
				$('#baseYear').focus();
				return false;
			}
		}

		if($("#insTitle").val() == ""){
			alert("사업명은 필수입니다.");
			$("#insTitle").focus();
			return false;
		}

		if($("#reqStartDate").val() == ""){
			alert("접수시작일은 필수입니다.");
			$("#reqStartDate").focus();
			return false;
		}

		if($("#reqEndDate").val() == ""){
			alert("접수종료일은 필수입니다.");
			$("#reqEndDate").focus();
			return false;
		}

		if($("#reqStartDate").val() > $("#reqEndDate").val()){
			alert("접수종료일이 접수시작일보다 빠릅니다.");
			$("#reqEndDate").focus();
			return false;
		}


		if($("#insStartDate").val() == ""){
			alert("사업시작일은 필수입니다.");
			$("#insStartDate").focus();
			return false;
		}

		if($("#insEndDate").val() == ""){
			alert("사업종료일은 필수입니다.");
			$("#insEndDate").focus();
			return false;
		}

		if($("#insStartDate").val() > $("#insEndDate").val()){
			alert("사업종료일이 사업시작일보다 빠릅니다.");
			$("#insEndDate").focus();
			return false;
		}

		if($("#budgetAmt").val() == ""){
			alert("사업예산은 필수입니다.");
			$("#budgetAmt").val(0);
			$("#budgetAmt").focus();
			return false;
		}
		return true;
	}

	function saveInsurance() {	// 보험 정보 신규등록

		if(!saveValid()){	// 보험 상세정보 validation
			return false;
		}

		var headerCnt = insuranceList.HeaderRows();		// 헤더row 갯수

		var firstIdx = insuranceList.GetDataFirstRow();	// 데이터행 첫번째 row

		var sInsCnt = insuranceList.RowCount();			// 시트 데이터row 총 갯수

		if(sInsCnt <= 0) {
			return;
		}

		for(var i = firstIdx; i < sInsCnt+headerCnt; i++) {	// 보헙정보 수출실적 공백체크

			if(insuranceList.GetCellValue(i,'minExpAmt') === '') {
				var insNm = insuranceList.GetCellValue(i,'insName');
				alert('['+insNm+']'+' 최소 수출실적을 입력하세요.');
				return;
			}

			if(insuranceList.GetCellValue(i,'maxExpAmt') === '') {
				var insNm = insuranceList.GetCellValue(i,'insName');
				alert('['+insNm+']'+' 최대 수출실적을 입력하세요.');
				return;
			}
		}

		if(!confirm('저장하시겠습니까?')) {
			return;
		}

		var pParamData = $('#frm').serializeObject();

		var insTypeList = insuranceList.ExportData({
			'Type' : 'json'
		});

		var params = {};
		params.param = pParamData;
		params.list = insTypeList.data;


		global.ajax({
			type : 'POST'
			, url : "/insurance/saveInsuranceInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(params)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if(addChk == "Y") {
					getInsuranceRegistList();
					addChk = "";
				} else {
					var nowRow = insuranceRegistListSheet.GetSelectRow();
					var insId = insuranceRegistListSheet.GetCellValue(nowRow,'insId');
					getInsuranceInfo(insId);
				}
			}
		});
	}

	function numFormat() {	// 값 초기화시 포맷적용

		var targetVal = '';

		if($('#budgetAmt').val() != ''){

			var rePlNum = onlyNum($('#budgetAmt').val());

			if(rePlNum != '') {
				targetVal = parseInt(rePlNum);
			}

			$('#budgetAmt').val(global.formatCurrency(targetVal));
		}
	}

	function addInsurance() {	// 보험 추가

		addChk = "Y";

		global.ajax({
			type : 'POST'
			, url : '/insurance/selectInsurancePrevInsType.do'
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				insuranceList.LoadSearchData({Data: data.insuranceTypeList});	// 보험 정보 조회

				$('#frm')[0].reset();
				$('#budgetAmt').val(0);
				$('#insId').val('');
				$('#baseYear').focus();
				$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);
			}
		});

	}

	function deleteInsurance() {	// 사업 삭제

		if($('#insId').val() == '') {
			alert('삭제할 항목을 선택하세요.');
			return;
		}

		if(!confirm('삭제하시겠습니까? 모든 데이터가 삭제됩니다.')) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '/insurance/deleteInsurance.do'
			, data : {'insId' : $('#insId').val()}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getInsuranceRegistList();
			}
		});
	}

</script>