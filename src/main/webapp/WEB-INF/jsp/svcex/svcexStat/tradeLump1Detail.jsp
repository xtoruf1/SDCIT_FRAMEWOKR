<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="event"				id="event"     	value="">
	<input type="hidden" name="statusChk"			id="statusChk"	value="">
	<input type="hidden" name="bsNo"				id="bsNo"				value=""/>
	<input type="hidden" name="transportServiceCd"	id="transportServiceCd"	value=""/>
	<input type="hidden" name="stateCd"				id="stateCd"			value=""/>
	<input type="hidden" name="reqno"				id="reqno"				value=""/>
	<input type="hidden" name="manCreYn"			id="manCreYn"			value=""/>
	<input type="hidden" name="searchSerSwCd"		id="searchSerSwCd"		value="<c:out value="${svcexVO.searchSerSwCd }"/>"/>
	<input type="hidden" name="listPagePre" 		id="listPagePre"		value="<c:out value="${svcexVO.listPage }"/>"/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectListSheet,'한국무역협회 무역지원서비스 총괄','');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
			<button type="button" class="btn_sm btn_secondary" onclick="goList();">이전</button>
		</div>
	</div>
	<div class="tab_header">
		<button class="tab on" onclick="location.href='/svcex/svcexStat/tradeLump1List.do'">총괄</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump2List.do'">국가별</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump3List.do'">기업형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump4List.do'">거래형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump5List.do'">은행</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump6List.do'">시도</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump7List.do'">발급실적</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump8List.do'">발급건수</button>
	</div>
	<div class="cont_block">
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
						<select name="searchMonQuarter" class="form_select" id="searchMonQuarterId">
							<c:forEach var="list" items="${svc005}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchMonQuarter == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>수출입</th>
					<td>
						<select name="searchExpImpCd" class="form_select" id="searchExpImpCd">
							<c:forEach var="list" items="${com002}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchExpImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
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
			, url : '<c:url value="/svcex/svcexStat/tradeLump1DetailDataList.do" />'
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

		ibHeader.addHeader({Header: '월/분기별', Type: 'Text', SaveName: 'detailnm', Width: 7.5, Align: 'Center', Edit:false});
		ibHeader.addHeader({Header: svcexVO.lastYear + '년 금액($)', Type: 'AutoSum', SaveName: 'year1', Width: 35, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.searchYear + '년 년 금액($)', Type: 'AutoSum', SaveName: 'year2', Width: 35, Align: 'right', Edit:false});
		ibHeader.addHeader({Header: '증감율(%)', Type: 'Text', SaveName: 'per', Width: 15, Align: 'right', Edit:false});

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
