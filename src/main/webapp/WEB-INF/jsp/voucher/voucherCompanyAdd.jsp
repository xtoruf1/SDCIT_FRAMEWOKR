<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
</div>

<form id="searchForm" method="post">
	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">바우처 대상업체 등록</h3>
			<div class="btnGroup ml-auto">
				<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="saveVoucherCompanyAdd();">저장</button>
				<button type="button" class="btn_sm btn_primary" onclick="doSearch();">조회</button>
				<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
			</div>
		</div>

		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="vmstSeq" name="vmstSeq" value="${listParams.vmstSeq}"/>
		<input type="hidden" id="voucherPageIndex" name="voucherPageIndex" value="${listParams.voucherPageIndex}"/>
		<input type="hidden" id="companyPageIndex" name="companyPageIndex" value="${listParams.companyPageIndex}"/>
		<input type="hidden" id="voucherPageUnit" name="voucherPageUnit" value="${listParams.voucherPageUnit}"/>
		<input type="hidden" id="companyPageUnit" name="companyPageUnit" value="${listParams.companyPageUnit}"/>
			<table class="formTable">
				<colgroup>
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">무역업번호</th>
						<td>
							<input type="text" id="searchTradeNo" name="searchTradeNo" class="form_text w100p" title="검색어" />
						</td>
						<th scope="row">사업자번호</th>
						<td>
							<input type="text" id="searchCorpRegNo" name="searchCorpRegNo" class="form_text w100p" title="검색어" />
						</td>
						<th scope="row">업체명</th>
						<td>
							<input type="text" id="searchCorpName" name="searchCorpName" class="form_text w100p" title="검색어" />
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>

			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" >${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div id="companyListSheet" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_companyList();		// 사업 리스트 헤더
		getCompanyList();					// 사업 리스트 조회

	});

	function setSheetHeader_companyList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'		, Hidden: true});
		ibHeader.addHeader({Header: ''				, Type: 'CheckBox'		, SaveName: 'check'			, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '무역고유번호'		, Type: 'Text'			, SaveName: 'tradeNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체명(한글)'		, Type: 'Text'			, SaveName: 'corpNameKr'	, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '업체명(영문)'		, Type: 'Text'			, SaveName: 'corpNameEn'	, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '대표자'			, Type: 'Text'			, SaveName: 'ceoName'		, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '회비납부여부'		, Type: 'Text'			, SaveName: 'payYn'			, Edit: false	, Width: 40		, Align: 'Center'});

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

		var container = $('#companyListSheet')[0];
		createIBSheet2(container, 'companyListSheet', '100%', '100%');
		ibHeader.initSheet('companyListSheet');

		companyListSheet.SetEllipsis(1); // 말줄임 표시여부
		companyListSheet.SetSelectionMode(4);			// 셀 선택 모드 설정

	}

	function doSearch() {
		$('#pageIndex').val(1);
		getCompanyList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getCompanyList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function goList() {

		$('#searchForm').attr('action', '/voucher/voucherObjectList.do');
		$('#searchForm').submit();
	}

	function getCompanyList() {	// 사업정보 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherCompanyList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
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

				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				companyListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function saveVoucherCompanyAdd() {	// 바우처 서비스 등록

		var pPramData = companyListSheet.GetSaveJson();

		var vmstSeq = $('#vmstSeq').val();

		if(pPramData.Code == 'IBS000') {
			alert("선택된 항목이 없습니다.");
			return;
		}

		if(!confirm("추가하시겠습니까?")){
			return false;
		}

		for(var i = 0; i < pPramData.data.length; i++) {

			pPramData.data[i].vmstSeq = vmstSeq;
		}

		global.ajax({
			type : 'POST'
			, url : "/voucher/saveVoucherCompany.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pPramData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#searchForm').attr('action','/voucher/voucherObjectList.do');
				$('#searchForm').submit();
			}
		});
	}

</script>