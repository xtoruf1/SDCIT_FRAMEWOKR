<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
</div>

<form id="vmstForm" method="post">
	<input type="hidden" id="voucherPageIndex" name="voucherPageIndex" value="<c:out value="${detailParams.voucherPageIndex}" />"/>
	<input type="hidden" id="companyPageIndex" name="companyPageIndex" value="<c:out value="${detailParams.companyPageIndex}" />"/>
	<input type="hidden" id="vmstSeq" name="vmstSeq" value="<c:out value="${detailParams.vmstSeq}"/>"/>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">바우처 대상업체 관리</h3>
		</div>

		<div class="tbl_opt">
			<div id="voucherTotalCnt" class="total_count"></div>

			<select name="voucherPageUnit" class="form_select ml-auto" onchange="chgVouPageCnt();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${detailParams.voucherPageUnit eq item.code}">selected="selected"</c:if> >${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>

		<div>
			<div id="voucherListSheet" class="sheet"></div>
		</div>
		<div id="voucherPaging" class="paging ibs"></div>
	</div>
	
	<div class="cont_block">
		<div class="tbl_opt">
			<div id="companyTotalCnt" class="total_count"></div>
	
			<select name="companyPageUnit" class="form_select ml-auto" onchange="chgComPageCnt();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${detailParams.companyPageUnit eq item.code}">selected="selected"</c:if> >${item.codeNm}</option>
				</c:forEach>
			</select>
			<div class="btnGroup ml-15">
				<button type="button" id="btnAdd" class="btn_sm btn_primary btn_modify_auth" onclick="addCompany();">추가(상세)</button>
				<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="deleteCompany();">저장</button>
			</div>
		</div>

		<div id="tabService" >
			<div id="voucherNewCompanyList" class="sheet"></div>
		</div>
		<div id="newCompanyPaging" class="paging ibs"></div>
	</div>
</form>


<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_voucherList();		// 사업 리스트 헤더
		setSheetHeader_newCompanyList();	// 바우처에 등록된 회사 리스트 헤더
		getVoucherList();					// 사업 리스트 조회

	});

	function setSheetHeader_voucherList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '바우처시퀀스'	, Type: 'Text', SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '사업년도'		, Type: 'Text', SaveName: 'baseYear'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'		, Type: 'Text', SaveName: 'voucherTitle'	, Edit: false	, Width: 150	, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '게시일'		, Type: 'Text', SaveName: 'viewDt'			, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업기간'		, Type: 'Text', SaveName: 'voucherDt'		, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '접수기간'		, Type: 'Text', SaveName: 'receDt'			, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'		, Type: 'Text', SaveName: 'voucherSt'		, Edit: false	, Width: 30		, Align: 'Center'});

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

		var container = $('#voucherListSheet')[0];
		createIBSheet2(container, 'voucherListSheet', '100%', '100%');
		ibHeader.initSheet('voucherListSheet');

		voucherListSheet.SetEllipsis(1); // 말줄임 표시여부
		voucherListSheet.SetSelectionMode(4);			// 셀 선택 모드 설정

	}

	function setSheetHeader_newCompanyList() {	//	바우처에 등록된 회사 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'	, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'		, SaveName: 'vmstSeq'		, Hidden: true});
		ibHeader.addHeader({Header: ''				, Type: 'DelCheck'	, SaveName: 'DelCheck'						, Width: 5		, Align: 'Center'});
		ibHeader.addHeader({Header: '무역업고유번호'		, Type: 'Text'		, SaveName: 'tradeNo'		, Edit: false	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'		, SaveName: 'corpRegNo'		, Edit: false	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '회사명'			, Type: 'Text'		, SaveName: 'corpName'		, Edit: false	, Width: 30		, Align: 'Left'});
		ibHeader.addHeader({Header: '등록일'			, Type: 'Text'		, SaveName: 'creDate'		, Edit: false	, Width: 15		, Align: 'Center'});
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

		var container = $('#voucherNewCompanyList')[0];
		createIBSheet2(container, 'voucherNewCompanyList', '100%', '100%');
		ibHeader.initSheet('voucherNewCompanyList');

	}

	function goVoucherPage(pageIndex) {	// 페이징 함수
		$('#voucherPageIndex').val(pageIndex);
		getVoucherList();
	}

	function goCompanyPage(pageIndex) {	// 페이징 함수
		$('#companyPageIndex').val(pageIndex);
		getVoucherNewCompanyList();
	}

	function chgVouPageCnt() {
		goVoucherPage(1);
	}

	function chgComPageCnt() {
		goCompanyPage(1);
	}

	function addCompany() {
		$('#vmstForm').attr('action','/voucher/voucherCompanyAdd.do');
		$('#vmstForm').submit();
	}

	function voucherListSheet_OnSearchEnd() {
		// 제목에 볼드 처리
		voucherListSheet.SetColFontBold('voucherTitle', 1);
	}

	function voucherListSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) { // 사업 리스트 포커스 이동시

		if(oldRow == newRow){ // 이전 클릭 행이 새로 클릭한 행과 같으면
			return;
		}

		var oldVmstSeq = $('#vmstSeq').val();

		var vmstSeq = voucherListSheet.GetCellValue(newRow,'vmstSeq');	// 현재 선택된 사업 vmstSeq 세팅

		if(oldVmstSeq != vmstSeq) {
			$('#companyPageIndex').val(1);
		}

		$('#vmstSeq').val(vmstSeq);
		if($('#companyPageIndex').val() != '1'){
			getVoucherNewCompanyList();	// 바우처 등록된 회사 목록 조회
		} else {
			getVoucherNewCompanyList();	// 바우처 등록된 회사 목록 조회
		}
	}

	function getVoucherList() {	// 사업정보 조회

		var vmstForm = $('#vmstForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherObjectList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(vmstForm)
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
						'voucherPaging'
						, goVoucherPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				voucherListSheet.LoadSearchData({Data: (data.resultList || []) }, {	// 조회한 데이터 시트에 적용
					Sync: 1
				});

				$('#voucherTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				if($('#vmstSeq').val() == ''){
					voucherListSheet.SelectCell(1,0);	// 리스트 최상단 데이터 선택
				} else {
					var vRow = voucherListSheet.FindText(0,$('#vmstSeq').val());
					voucherListSheet.SelectCell(vRow,0);
				}

			}
		});
	}

	function getVoucherNewCompanyList() {	// 바우처 등록된 회사 목록 조회

		var vmstForm = $('#vmstForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/voucher/selectVoucherNewCompanyList.do'
			, contentType : 'application/json'
			, data : JSON.stringify(vmstForm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
						'newCompanyPaging'
						, goCompanyPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#companyTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				voucherNewCompanyList.LoadSearchData({Data: (data.resultList || []) });	// 바우처 서비스 정보 조회
			}
		});
	}

	function deleteCompany() {	// 바우처 서비스 등록

		var pPramData = voucherNewCompanyList.GetSaveJson();

		var vmstSeq = $('#vmstSeq').val();

		if(pPramData.Code == 'IBS000') {
			alert("선택된 항목이 없습니다.");
			return;
		}

		if(!confirm("선택한 항목을 삭제하시겠습니까?")){
			return false;
		}

		for(var i = 0; i < pPramData.data.length; i++) {

			pPramData.data[i].vmstSeq = vmstSeq;
		}

		global.ajax({
			type : 'POST'
			, url : "/voucher/deleteVoucherCompany.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pPramData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("정상적으로 처리되었습니다.");
				getVoucherNewCompanyList();
			}
		});
	}

</script>