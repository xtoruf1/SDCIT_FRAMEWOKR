<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="listPage"	id="listPage"	value="<c:out value="/svcex/svcexStat/countryStatistics3List.do"/>"/>
	<input type="hidden" name="itemCd"		id="itemCd"		value=""/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectListSheet,'한국무역협회 무역지원서비스 국가별수출입(국가의뭄목별)','');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>
	<div class="tab_header">
		<button class="tab" onclick="location.href='/svcex/svcexStat/countryStatistics1List.do'">국가</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/countryStatistics2List.do'">국가(월)</button>
		<button class="tab on" onclick="location.href='/svcex/svcexStat/countryStatistics3List.do'">국가의품목</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/countryStatistics4List.do'">국가의품목(월)</button>
	</div>
	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>국가</th>
					<td>
						<div class="field_set">
							<span class="form_search">
								<input name="targetCountryCd" id="targetCountryCd" type="hidden" value="<c:out value="${not empty svcexVO.targetCountryCd ? svcexVO.targetCountryCd : svcexVO.countryCd  }"/>">
			               		<input name="targetCountryNm" id="targetCountryNm" type="text" readonly="" class="form_text" value="<c:out value="${not empty svcexVO.targetCountryNm ? svcexVO.targetCountryNm : svcexVO.countryNm  }"/>" desc="국가명">
			               		<button type="button" class="btn_icon btn_search" onclick="viewPopup()" title="국가검색"></button>
		               		</span>
		               		<button type="button" class="ml-8" onclick="mtiClearDate('targetCountryCd','targetCountryNm');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
	               		</div>
					</td>
					<th>분류</th>
					<td>
						<select name="searchGroupCd" id="searchGroupCdId" class="form_select">
							<c:forEach var="list" items="${svc007}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchGroupCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
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
					<th>수출입</th>
					<td>
						<select name="searchExpImpCd" id="searchExpImpCdId" class="form_select">
							<c:forEach var="list" items="${com002}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchExpImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
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
			, url : '<c:url value="/svcex/svcexStat/countryStatistics3DataList.do" />'
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
		ibHeader.addHeader({Header: '품목코드', Type: 'Text', SaveName: 'detailcd', Width: 5, Align: 'Center', ColMerge: 0, Hidden: false, Edit:false});
		ibHeader.addHeader({Header: '품목명', Type: 'Text', SaveName: 'detailnm', Width: 30, Align: 'Left', ColMerge: 0, Cursor:"Pointer", Edit:false});
		ibHeader.addHeader({Header: svcexVO.lastYear + '년 금액($)', Type: 'AutoSum', SaveName: 'checkAmount1', Width: 30, Align: 'Right', Edit:false});
		ibHeader.addHeader({Header: svcexVO.searchYear + '년 금액($)', Type: 'AutoSum', SaveName: 'checkAmount2', Width: 30, Align: 'Right', Edit:false});
		ibHeader.addHeader({Header: '증감율(%)', Type: 'Text', SaveName: 'per', Width: 10, Align: 'Right', Edit:false});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, editable: false, MergeSheet :5, VScrollMode: 0, NoFocusMode : 0 });
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#selectList')[0];
		createIBSheet2(container, 'selectListSheet', '100%', '560px');
		ibHeader.initSheet('selectListSheet');
		selectListSheet.SetCellAlign(selectListSheet.LastRow(), 'detailcd', "Center");
		selectListSheet.SetSumText('detailcd', "합계");
		selectListSheet.SetMergeCell(selectListSheet.LastRow(), 0, 1, 2 );
		selectListSheet.SetSelectionMode(4);
		selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
	}

	function selectListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {

		}else{
			// 볼드 처리
			selectListSheet.SetColFontBold('detailnm', 1);
		}
	}

	function selectListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if( selectListSheet.ColSaveName(col) == "detailnm" ) {
				var url = "/svcex/svcexStat/countryStatistics4List.do";
				var detailcd = selectListSheet.GetCellValue(row, "detailcd");

				f.itemCd.value = detailcd;
				f.action = url;
				f.target = '_self';
				f.submit();
			}
		}
	}

	function viewPopup() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/svcex/svcexCertificate/popup/searchCountryView.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				document.viewForm.targetCountryCd.value = resultObj[0];
				document.viewForm.targetCountryNm.value = resultObj[1];
			}
		});
	}
	function mtiClearDate( target1,target2  ){
		$("#"+target1).val("");
		$("#"+target2).val("");
	}
 	function selectListSheet_OnRowSearchEnd(row) {
		notEditableCellColor('selectListSheet', row);

		if (row > 0){
		}
	}
</script>
