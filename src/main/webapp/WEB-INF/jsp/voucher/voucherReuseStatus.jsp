<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doexcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSave" class="btn_sm btn_primary" onclick="getVoucherUsing();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:15%" />
				</colgroup>
				<tbody>
					<tr>
						<th>대상년도</th>
						<td>
							<div class="group_item" style="width: 400px;">
								<select name="searchFirstBaseYear" id="searchFirstBaseYear" class="form_select">
									<c:forEach items="${firstBaseYearList}" var="resultInfo" varStatus="status">
										<option value="<c:out value="${ resultInfo.baseYear}" />" label="<c:out value="${ resultInfo.baseYear}" /> "/>
									</c:forEach>
								</select>

								<div class="spacing">~</div>

								<select name="searchLastBaseYear" id="searchLastBaseYear" class="form_select" style="width: ">
									<c:forEach items="${lastBaseYearList}" var="resultInfo" varStatus="status">
										<option value="<c:out value="${ resultInfo.baseYear}" />" label="<c:out value="${ resultInfo.baseYear}" /> "/>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">바우처 서비스 이용횟수 현황</h3>
		<p class="ml-auto" id="statusInfo"></p>
	</div>

	<div>
		<div id="voucherUesingSheet" class="sheet"></div>
	</div>
</div>


<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">바우처 서비스 재이용율 현황</h3>
	</div>
	<div>
		<div id="voucherReuseingSheet" class="sheet"></div>
		<p class="mt-10">* 재이용업체 = 당해연도 이용업체 중 전년도 이용업체</p>
	</div>
</div>



<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_voucherUseing();				// 바우처 사용 현황 헤더
		setSheetHeader_voucherReuseing();		// 바우처 사용 서비스별 현황 헤더
		getVoucherUsing();							// 바우처 사용 현황 조회
	});

	function setSheetHeader_voucherUseing() {	// 바우처 사용 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '이용횟수'			, Type: 'Text'			, SaveName: 'useCnt'		, Edit: false	, Width: 25		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체 수'			, Type: 'AutoSum'			, SaveName: 'corpCnt'		, Edit: false	, Width: 37		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '비율(%)'			, Type: 'AutoSum'			, SaveName: 'reCnt'			, Edit: false	, Width: 38		, Align: 'Right'});

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

		var container = $('#voucherUesingSheet')[0];
		createIBSheet2(container, 'voucherUesingSheet', '100%', '10%');
		ibHeader.initSheet('voucherUesingSheet');

		voucherUesingSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherUesingSheet.SetSelectionMode(4);

	}

	function setSheetHeader_voucherReuseing() {	// 서비스별 사용 현황 헤더

		var	ibHeader = new IBHeader();


		ibHeader.addHeader({Header: '기준년도'			, Type: 'Text'			, SaveName: 'baseYear'			, Edit: false	, Width: 25		, Align: 'Center'});
		ibHeader.addHeader({Header: '이용업체 수'		, Type: 'Int'			, SaveName: 'useCnt'			, Edit: false	, Width: 25		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '재이용업체 수*'	, Type: 'Int'			, SaveName: 'reUseCnt'			, Edit: false	, Width: 25		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '재이용률(%)'		, Type: 'Float'			, SaveName: 'reUsePctg'			, Edit: false	, Width: 25		, Align: 'Right'	});


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

		var container = $('#voucherReuseingSheet')[0];
		createIBSheet2(container, 'voucherReuseingSheet', '100%', '10%');
		ibHeader.initSheet('voucherReuseingSheet');

		voucherReuseingSheet.SetEllipsis(1); 				// 말줄임 표시여부
		voucherReuseingSheet.SetSelectionMode(4);

	}

	function getVoucherUsing() {	// 현황 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherReuseStatus.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherUesingSheet.LoadSearchData({Data: (data.resulUsedtList || []) });
				voucherReuseingSheet.LoadSearchData({Data: (data.resulReUsedtList || []) });

				voucherUesingSheet.SetSumText(0, '합계');

				var first = $('#searchFirstBaseYear').val();
				var last = $('#searchLastBaseYear').val();

				first = first.substr(2,3);
				last = last.substr(2,3);

				$('#statusInfo').text('(' + first + '년 ~ ' + last + '년 상반기 이용업체)');

			}
		});
	}

	function doexcelDownload() {	// 엑셀다운로드

		$('#searchForm').attr('action', '/voucher/voucherReuseStatusExcelDown.do');
		$('#searchForm').submit();

	}

	function doClear() {	// 초기화
		location.reload();
	}


</script>