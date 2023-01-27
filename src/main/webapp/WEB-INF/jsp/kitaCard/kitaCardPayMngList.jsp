<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnExcelUpload" class="btn_sm btn_primary btn_modify_auth" onclick="excelUpload();">엑셀 업로드</button>
	</div>
	<div class="ml-15">
		<button type="button" id="btnExcelDown" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSearch" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
	<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
	<input type="hidden" id="pTradeNo" name="tradeNo"  value=""/>
		<table class="formTable">
			<colgroup>
				<col width="15%"/>
				<col width="18%" />
				<col width="15%"/>
				<col width="18%" />
				<col width="15%"/>
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>업체명</th>
					<td><input type="text" class="form_text w100p" name="searchCorpNameKr" onkeydown="onEnter(doSearch);" id="searchCorpNameKr" /></td>
					<th>사업자번호</th>
					<td><input type="text" class="form_text w100p" name="searchCorpRegNo" onkeydown="onEnter(doSearch);" id="searchCorpRegNo" /></td>
					<th>무역업번호</th>
					<td><input type="text" class="form_text w100p" name="searchTradeNo" onkeydown="onEnter(doSearch);" id="searchTradeNo" /></td>
				</tr>
				<tr>
					<th>실적연도</th>
					<td>
						<select class="form_select w100p" name="searchCardYear" id="searchCardYear">
							<option value="">전체</option>
							<c:forEach items="${yearList}" var="resultInfo" varStatus="status">
								<c:set var="yearNum" value="${resultInfo.year}" />
								<c:if test="${yearNum > '2011'}">
									<option value="<c:out value="${ resultInfo.year}" />" label="<c:out value="${ resultInfo.year}" />" />
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th>대납연도</th>
					<td>
						<select class="form_select w100p" name="searchPayYear" id="searchPayYear">
							<option value="">전체</option>
							<c:forEach items="${yearList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.year}" />" label="<c:out value="${ resultInfo.year}" />" />
							</c:forEach>
						</select>
					</td>
					<th>카드종류</th>
					<td>
						<select class="form_select w100p" name="searchCardCode" id="searchCardCode" >
							<option value="">전체</option>
							<c:forEach items="${cardList}" var="vo" varStatus="status">
							<option value="<c:out value="${ vo.cardCode}" />" label="<c:out value="${ vo.cardName}" />" />
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>대납금</th>
					<td colspan="5">
						<select class="form_select w20p" name="searchFundAmt" id="searchFundAmt" >
							<option value="">전체</option>
							<c:forEach items="${getFundAmt}" var="vo" varStatus="status">
							<option value="<c:out value="${ vo.fundAmt}" />" > <fmt:formatNumber value='${vo.fundAmt}' /> </option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}">${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div>
		<div id="cardPaySheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_cardPayList();		// 대납 리스트 헤더
		getCardPayList();					// 대납 리스트 조회

	});

	function setSheetHeader_cardPayList() {	// 대납 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: 'No'			, Type: 'Text'			, SaveName: 'no'			, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'corpNameKr'	, Edit: false	, Width: 60		, Align: 'Left'});
		ibHeader.addHeader({Header: '사업자등록번호'		, Type: 'Text'			, SaveName: 'corpRegNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '무역업번호'		, Type: 'Text'			, SaveName: 'tradeNo'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '실적연도'			, Type: 'Text'			, SaveName: 'cardYear'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드종류'			, Type: 'Text'			, SaveName: 'cardName'		, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '이용실적'			, Type: 'Int'			, SaveName: 'useAmt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '대납금'			, Type: 'Int'			, SaveName: 'fundAmt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
// 		ibHeader.addHeader({Header: '대납구분'			, Type: 'Text'			, SaveName: 'payType'		, Edit: false	, Width: 20		, Align: 'Center'});

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

		var container = $('#cardPaySheet')[0];
		createIBSheet2(container, 'cardPaySheet', '100%', '100%');
		ibHeader.initSheet('cardPaySheet');

		cardPaySheet.SetEllipsis(1); 				// 말줄임 표시여부
		cardPaySheet.SetSelectionMode(4);
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getCardPayList();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getCardPayList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function getCardPayList() {	// 사업정보 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectCardUseResultList.do"
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

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				cardPaySheet.LoadSearchData({Data:(data.resultList || []) });
			}
		});
	}

	function doExcelDownload() {
		$('#searchForm').attr('action','/kitaCard/kitaCardPayMngExcelDown.do');
		$('#searchForm').submit();
	}

	function excelUpload() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/kitaCard/popup/kitaCardExcelUpload.do'
			, params : { uploadType : 'payMng'}
			, callbackFunction : function(resultObj){
				if(resultObj == 'true') {
					getCardPayList();
				} else {
					return;
				}
			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>