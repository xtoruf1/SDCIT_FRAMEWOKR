<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="event"				id="event"     			value="">
	<input type="hidden" name="statusChk"			id="statusChk"			value="">
	<input type="hidden" name="bsNo"				id="bsNo"				value=""/>
	<input type="hidden" name="transportServiceCd"	id="transportServiceCd"	value=""/>
	<input type="hidden" name="stateCd"				id="stateCd"			value=""/>
	<input type="hidden" name="reqno"				id="reqno"				value=""/>
	<input type="hidden" name="manCreYn"			id="manCreYn"			value=""/>
	<input type="hidden" name="searchYear"			id="searchYear"			value=""/>
	<input type="hidden" name="listPage"			id="listPage"			value="<c:out value="/svcex/svcexStat/tradeLump1List.do"/>"/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectListSheet,'한국무역협회 무역지원서비스 총괄','');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
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
		<!-- <div style="display: flex;">
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump1List.do');">총괄 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump2List.do');">국가별통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump3List.do');">기업형태별통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump4List.do');">거래형태별통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump5List.do');">은행별통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump6List.do');">시도별통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump7List.do');">발급실적통계 | </a>
			</li>
			<li style="padding-left:5px;">
				<a style="font-size: 15px;" href="javascript:goMenu('/svcex/svcexStat/tradeLump8List.do');">발급건수통계 | </a>
			</li>
		</div> -->

		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>용역/전자적형태의무체물</th>
					<td>
						<select name="searchSerSwCd" class="form_select" id="searchSerSwCdId" >
							<c:forEach var="list" items="${com010}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${svcexVO.searchSerSwCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable - 총괄 -->
	</div><!-- //cont_block -->

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<!-- <div id="totalCnt" class="total_count"></div> -->
			<div><c:out value="${nowDate }"/> 현재</div>
		</div>
		<div id="selectList" class="sheet"></div>
		<!-- <div id="paging" class="paging ibs"></div> -->
	</div>

</form>
<script type="text/javascript">
	var f = document.viewForm;

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '년도|년도', Type: 'Text', SaveName: 'contractDate', Width: 5, Align: 'Center', ColMerge: 0, Ellipsis: true, Cursor:"Pointer", Edit:false});
	ibHeader.addHeader({Header: '수출|금액($)', Type: 'AutoSum', SaveName: 'export', Width: 22.5, Align: 'right', ColMerge: 0, Edit:false});
	ibHeader.addHeader({Header: '수출|증가율(%)', Type: 'Text', SaveName: 'exportPer', Width: 22.5, Align: 'right', ColMerge: 0, Edit:false});
	ibHeader.addHeader({Header: '수입|금액($)', Type: 'AutoSum', SaveName: 'import', Width: 22.5, Align: 'right', ColMerge: 0, Edit:false});
	ibHeader.addHeader({Header: '수입|증감율(%)', Type: 'Text', SaveName: 'importPer', Width: 22.5, Align: 'right', ColMerge: 0, Edit:false});
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, editable: false, MergeSheet :5, VScrollMode: 0, NoFocusMode : 0 });
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#selectList')[0];
		createIBSheet2(container, 'selectListSheet', '100%', '600px');
		ibHeader.initSheet('selectListSheet');
		selectListSheet.SetSelectionMode(4);
		selectList();
	});

	function selectList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexStat/tradeLump1DataList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
			}
		});
	}

	function doSearch() {
		selectList();
	}

	function selectListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
		}else{
			// 볼드 처리
			selectListSheet.SetColFontBold('contractDate', 1);
			selectListSheet.SetCellAlign(selectListSheet.LastRow(), 'contractDate', "Center");
			selectListSheet.SetSumText('contractDate', "합계");

		}
	}

	function selectListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if ( (row > 0) && (selectListSheet.LastRow() != row) ) {
			if( selectListSheet.ColSaveName(col) == "contractDate" ) {
				var url = "/svcex/svcexStat/tradeLump1DetailList.do";
				var contractDate = selectListSheet.GetCellValue(row, "contractDate");
				f.searchYear.value = contractDate;
				f.action = url;
				f.target = '_self';
				f.submit();
			}
		}
	}

 	function selectListSheet_OnRowSearchEnd(row) {
		notEditableCellColor('selectListSheet', row);

		if (row > 0){
		}
	}
</script>
