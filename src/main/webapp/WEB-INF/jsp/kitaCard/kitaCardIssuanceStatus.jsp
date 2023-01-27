<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(cardIssuanceStatusSheet, '카드_발급_통계', '');">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSearch" class="btn_sm btn_primary" onclick="getCardIssuanceList();">검색</button>
	</div>
</div>

<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:17%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>대상년도</th>
						<td>
							<select class="form_select" name="searchCardYear" id="searchCardYear">
								<option value="">전체</option>
								<c:forEach items="${yearList}" var="resultInfo" varStatus="status">
									<c:set var="yearNum" value="${resultInfo.year}" />
									<c:if test="${yearNum > '2009'}">
										<option value="<c:out value="${ resultInfo.year}" />" label="<c:out value="${ resultInfo.year}" />" />
									</c:if>
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
	<div>
		<div id="cardIssuanceStatusSheet" class="sheet"></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_cardIssuanceList();				// 카드 사용 실적 헤더
		getCardIssuanceList();							// 카드 사용 실적 조회
	});

	function setSheetHeader_cardIssuanceList() {	// 카드 사용 실적 헤더

		var	ibHeader = new IBHeader();


		ibHeader.addHeader({Header: '카드사'						, Type: 'Text'			, SaveName: 'cardName'			, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '0~1천만원 미만'				, Type: 'AutoSum'			, SaveName: 'regCnt01'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '1천만원 이상 ~ 2천만원 미만'		, Type: 'AutoSum'			, SaveName: 'regCnt02'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '2천만원 이상 ~ 3천만원 미만'		, Type: 'AutoSum'			, SaveName: 'regCnt03'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '3천만원 이상'					, Type: 'AutoSum'			, SaveName: 'regCnt04'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

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

		var container = $('#cardIssuanceStatusSheet')[0];
		createIBSheet2(container, 'cardIssuanceStatusSheet', '100%', '10%');
		ibHeader.initSheet('cardIssuanceStatusSheet');

		cardIssuanceStatusSheet.SetEllipsis(1); 				// 말줄임 표시여부
		cardIssuanceStatusSheet.SetSelectionMode(4);
	}

	function getCardIssuanceList() {	// 카드 사용 실적 조회

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectKitaCardIssuanceStatus.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				cardIssuanceStatusSheet.LoadSearchData({Data: (data.resultList || []) });

				cardIssuanceStatusSheet.SetSumText(0, '합계');

			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>