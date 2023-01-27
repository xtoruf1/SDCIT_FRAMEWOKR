<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
			<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(voucherTrandByServiceSheet, '바우처_이용서비스별_추이', '');">엑셀 다운</button>
			<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
			<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="getStatusInfo();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="vmstSeq" name="vmstSeq" value="0"/>
		<input type="hidden" id="tradeNo" name="tradeNo" value="${tradeNo}"/>
			<table class="formTable">
				<colgroup>
					<col style="width:17%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>사업명</th>
						<td>
							<select name="searchVmstSeq" id="searchVmstSeq" class="form_select wAuto">
								<c:forEach items="${vouList}" var="resultInfo" varStatus="status">
									<option value="<c:out value="${ resultInfo.vmstSeq}" />" label="<c:out value="${ resultInfo.voucherTitle}" /> "/>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="cont_block">

	<div class="tbl_opt">
		총 금액 : <span id="totAmt" class="ml-8"></span>
	</div>
	<div id="sheetDiv"></div>
</div>

<script type="text/javascript">

	var headerCnt = 0;

	$(document).ready(function(){

		getStatusInfo();
	});

	function getStatusInfo() {	// 시트 데이터 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherTrandByServiceStatus.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#sheetDiv').empty();
				$('#sheetDiv').append('<div id="voucherTrandByServiceSheet" class="sheet"></div>');

				if (typeof container !== 'undefined' && typeof voucherTrandByServiceSheet.Index !== 'undefined') {
					voucherTrandByServiceSheet.DisposeSheet();
				}

				var totAmt = global.formatCurrency(Number(data.resultInfo.totAmt));

				$('#totAmt').text(totAmt);

				var headerList = data.resultInfo.statusHeader;

				headerCnt = headerList.length;

				setSheetHeader_voucherTrandByService(headerList);
				voucherTrandByServiceSheet.LoadSearchData({Data: (data.resultInfo.resultList || []) });

				var headerSize = headerList.length;

				if(headerSize < 5) {
					voucherTrandByServiceSheet.FitColWidth();
				}
			}
		});
	}

	function setSheetHeader_voucherTrandByService(list) {	// 바우처 사용 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '기간|기간'		, Type: 'Text'			, SaveName: 'BASE_DATE'		, Edit: false	, Width: 150		, Align: 'Center'});

		for(var i = 0; i < list.length; i++) {
			ibHeader.addHeader({Header: list[i].codeNm+'|금액'	, Type: 'Int'	, SaveName: 'AMT_'+list[i].code			, Edit: false	, Width: 120	, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|업체수'	, Type: 'Int'	, SaveName: 'COMP_CNT_'+list[i].code	, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|건수'	, Type: 'Int'	, SaveName: 'CNT_'+list[i].code			, Edit: false	, Width: 80		, Align: 'Right'	, Format: 'Integer'});
		}

		ibHeader.addHeader({Header: '소계|소계'			, Type: 'Int'			, SaveName: 'AMT_ALL'		, Edit: false	, Width: 120		, Align: 'Right'	, Format: 'Integer'});

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
            DeferredVScroll: 1,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            SizeMode: 4,
            FrozenCol: 1,
            MergeSheet: msHeaderOnly+msPrevColumnMerge
            });
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherTrandByServiceSheet')[0];
		createIBSheet2(container, 'voucherTrandByServiceSheet', '100%', '600px');
		ibHeader.initSheet('voucherTrandByServiceSheet');

		voucherTrandByServiceSheet.SetSelectionMode(4);
	}

	function voucherTrandByServiceSheet_OnSearchEnd() {

		var lastRow = voucherTrandByServiceSheet.RowCount()+1;	// 마지막 로우

		voucherTrandByServiceSheet.SetRowBackColor(lastRow,'#DCDCDC');

		for( var i = 0; i <= voucherTrandByServiceSheet.LastCol(); i++ ){
			voucherTrandByServiceSheet.SetCellFontBold(lastRow, i, 1);
		}

	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>