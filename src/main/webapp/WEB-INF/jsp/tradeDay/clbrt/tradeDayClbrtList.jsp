<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(tblGridSheet,'무역의 날 기념식 관리_', '');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<!-- 무역현장 컨설팅 리스트 -->
<div class="page_tradesos">

	<form name="searchForm" id="searchForm" action ="" method="get">
		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
		<input type="hidden" name="svrId" id="svrId" value=""/>
		<input type="hidden" id="totalCount" name="totalCount" value="0" default='0'>
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:10%">
					<col>
					<col style="width:10%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">연도</th>
						<td>
							<div class="form_row w50p">
								<select id="praYear" name="praYear" class="form_select">
									<option value="">전체</option>
									<c:forEach var="i" begin="${yearFrom}" end="${yearTo}" step="1">
										<option value="${yearTo - i + yearFrom}" <c:if test="${searchVO.praYear eq yearTo - i + yearFrom}">selected="selected"</c:if>>
												${yearTo - i + yearFrom }
										</option>
									</c:forEach>
								</select>
							</div>
						</td>
						<th scope="row">상태</th>
						<td>
							<select name="reqSendYn" class="form_select w50p">
								<option value="">전체</option>
								<c:forEach var="data" items="${SSM001}" varStatus="status">
									<option value="<c:out value="${data.detailcd}"/>" <c:if test="${searchVO.reqSendYn eq data.detailcd}">selected="selected"</c:if>><c:out value="${data.detailnm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table><!-- // 검색 테이블-->
		</div>

		<div class="cont_block mt-20">
			<div class="tbl_opt">
				<!-- 무역의 날 기념식 관리 -->
				<div id="totalCnt" class="total_count"></div>

				<fieldset class="ml-auto">
					<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
						<c:forEach var="item" items="${pageUnitList}" varStatus="status">
							<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
						</c:forEach>
					</select>
				</fieldset>
			</div>
			<!-- 리스트 테이블 -->
			<div style="width: 100%;height: 100%;">
				<div id='tblGridSheet' class="colPosi"></div>
			</div>
			<!-- .paging-->
			<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
			<!-- //.paging-->
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function () {

		f_Init_tblGridSheet();  //상담내역조회 Sheet

		getList(); // 조회

	});

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "포상아이디",      SaveName: "svrId",         Align: "Center", Width: 70,Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "연도",           SaveName: "praYear",       Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "무역의날기념식",   SaveName: "tradeDayTitle", Align: "Center", Ellipsis:1, Width: 200, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "제한인원",        SaveName: "limitMax",      Align: "Center",  Ellipsis:1, Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "신청가능포상",     SaveName: "enterTypeNm",   Align: "Center", Width: 200, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "동행인",          SaveName: "companionMax", Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "대리참가",        SaveName: "delegatorYn",   Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "포상신청",        SaveName: "reqCnt",        Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "포상수상",        SaveName: "awardCnt",      Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "모집대상",        SaveName: "baseCnt",      Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "신청",            SaveName: "expctAtendCnt", Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "확정",            SaveName: "cnfAtnCnt",     Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "참석",            SaveName: "attendCnt",     Align: "Center", Width: 80, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "모집발송",         SaveName: "reqSendYn",     Align: "Center", Width: 80, Cursor:"Pointer"});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		tblGridSheet.SetSelectionMode(4);

        // 편집모드 OFF
		tblGridSheet.SetEditable(0);

	};

	function tblGridSheet_OnRowSearchEnd(row) {
 	  // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('tblGridSheet', row);
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	// 검색
	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/tradeDayClbrtListAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				$("#totalCount").val(data.resultCnt); // 총 갯수 저장
				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	// 상세
 	function tblGridSheet_OnClick(Row, Col, Value) {
		if( Row > 0) {
			var svrId = tblGridSheet.GetCellValue(Row, "svrId");
			fn_detail(svrId);
		}

	};

	// 무역의날 기념식 관리 상세
	function fn_detail( svrId) {
		$("#svrId").val( svrId);

		document.searchForm.action = '<c:url value="/tradeDay/clbrt/tradeDayClbrtDetail.do" />';
		document.searchForm.target = '_self';
		document.searchForm.submit();
	}

</script>
