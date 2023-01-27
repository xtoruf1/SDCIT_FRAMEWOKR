<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="listPagePre" 			id="listPagePre"			value="<c:out value="${svcexVO.listPage }"/>"/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectListSheet,'한국무역협회 무역지원서비스 기업형태별통계','');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
			<button type="button" class="btn_sm btn_secondary" onclick="goList();">이전</button>
		</div>
	</div>
	<div class="tab_header">
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump1List.do'">총괄</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump2List.do'">국가별</button>
		<button class="tab on" onclick="location.href='/svcex/svcexStat/tradeLump3List.do'">기업형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump4List.do'">거래형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump5List.do'">은행</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump6List.do'">시도</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump7List.do'">발급실적</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump8List.do'">발급건수</button>
	</div>
	<div class="cont_block">
		<c:choose>
			<c:when test="${svcexVO.searchMonQuarter eq '1' }">
				<c:set var="text" value="월"/>
			</c:when>
			<c:otherwise>
				<c:set var="text" value="분기"/>
			</c:otherwise>
		</c:choose>
		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody>

				<tr>
					<th>기업형태</th>
					<td colspan="3">
						<select name="searchTypeBusinessCd" id="searchTypeBusinessCdId" class="form_select">
							<c:forEach var="list" items="${svc006}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchTypeBusinessCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>용역/전자적형태의무체물</th>
					<td>
						<select name="searchSerSwCd" id="searchSerSwCdId" class="form_select">
							<c:forEach var="list" items="${com010}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchSerSwCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>

				<tr>
					<th>년도</th>
					<td>
						<select name="searchYear" id="searchYearId" class="form_select">
							<c:forEach var="list" items="${yearList}" varStatus="status">
								<option value="${list.searchYear}"<c:if test="${svcexVO.searchYear == list.searchYear}"> selected</c:if>>${list.searchYear}</option>
							</c:forEach>
						</select>
					</td>
					<th>월/분기별</th>
					<td>
						<select name="searchMonQuarter" id="searchMonQuarterId" class="form_select">
							<c:forEach var="list" items="${svc005}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchMonQuarter == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>수출입</th>
					<td>
						<select name="searchExpImpCd" id="searchExpImpCd" class="form_select">
							<c:forEach var="list" items="${com002}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchExpImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable - 기업형태별통계 상세 -->
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<div><c:out value="${nowDate }"/> 현재</div>
		</div>
		<div id="selectList" class="sheet"></div>
		<!-- <div id="paging" class="paging ibs"></div> -->
	</div>

</form>

<script type="text/javascript">
	var f = document.viewForm;

	$(document).ready(function(){
		selectList();
	});

	function doSearch() {
		selectList();
	}

	function selectList() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexStat/tradeLump3DetailDataList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
// 				selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
				setGrid(data);
			}
		});
	}

	function setGrid(data){

		if (typeof selectListSheet !== "undefined" && typeof selectListSheet.Index !== "undefined") {
			selectListSheet.DisposeSheet();
		}

		var	ibHeader = new IBHeader();
		var svcexVO = data.svcexVO;

		var stbCd = svcexVO.searchTypeBusinessCd;
		var setText1 = "";
		var setText2 = "";

		if( stbCd == "B" ) {
			setText1 = "대기업";
			setText2 = "중소기업";
		}else if( stbCd == "C" ) {
			setText1 = "상장";
			setText2 = "비상장";
		}else if( stbCd == "D" ) {
			setText1 = "전업";
			setText2 = "겸엄";
		}else{
			setText1 = "법인";
			setText2 = "개인";
		}

		ibHeader.addHeader({Header: '월|월', Type: 'Text', SaveName: 'detailnm', Width: 5, Align: 'Center', ColMerge: 0, Edit:false});
		ibHeader.addHeader({Header: svcexVO.lastYear + '년|' + setText1, Type: 'AutoSum', SaveName: 'checkAmount1A1', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.lastYear + '년|' + setText2, Type: 'AutoSum', SaveName: 'checkAmount2A1', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.lastYear + '년|합계', Type: 'AutoSum', SaveName: 'totAmountA1', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.searchYear + '년|' + setText1, Type: 'AutoSum', SaveName: 'checkAmount1A2', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.searchYear + '년|' + setText2, Type: 'AutoSum', SaveName: 'checkAmount2A2', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.searchYear + '년|합계', Type: 'AutoSum', SaveName: 'totAmountA2', Width: 14, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: '증감율(%)|증감율(%)', Type: 'Text', SaveName: 'per', Width: 10, Align: 'right', Edit:false});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, editable: false, MergeSheet :5, NoFocusMode : 0 });
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#selectList')[0];
		createIBSheet2(container, 'selectListSheet', '100%', '100%');
		ibHeader.initSheet('selectListSheet');
		selectListSheet.SetCellAlign(selectListSheet.LastRow(), 'detailnm', "Center");
		selectListSheet.SetSumText('detailnm', "합계");
		selectListSheet.SetSelectionMode(4);
		selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});

		if ( $("#searchMonQuarterId").val() == "1" ){
			selectListSheet.SetCellValue(0, 'detailnm', "월별");
		}else{
			selectListSheet.SetCellValue(0, 'detailnm', "분기");
		}
	}

	function goList(){
		var url = f.listPagePre.value;
		f.action = url;
		f.target = "_self";
		f.submit();
	}

 	function selectListSheet_OnRowSearchEnd(row) {
		notEditableCellColor('selectListSheet', row);

		if (row > 0){
		}
	}
</script>
