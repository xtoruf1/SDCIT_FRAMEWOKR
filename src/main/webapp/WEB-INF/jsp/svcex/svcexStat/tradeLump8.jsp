<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="viewForm" id="viewForm" method="post" onsubmit="return false;">
	<input type="hidden" name="creStartDtTmp"		id="creStartDtTmp"		value=""/>
	<input type="hidden" name="creEndDtTmp"			id="creEndDtTmp"		value=""/>
	<input type="hidden" name="listPage"	id="listPage"	value="<c:out value="/svcex/svcexStat/tradeLump6List.do"/>"/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectListSheet,'한국무역협회 무역지원서비스 발급건수통계','');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>
	<div class="tab_header">
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump1List.do'">총괄</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump2List.do'">국가별</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump3List.do'">기업형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump4List.do'">거래형태</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump5List.do'">은행</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump6List.do'">시도</button>
		<button class="tab" onclick="location.href='/svcex/svcexStat/tradeLump7List.do'">발급실적</button>
		<button class="tab on" onclick="location.href='/svcex/svcexStat/tradeLump8List.do'">발급건수</button>
	</div>
	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>승인일자</th>
					<td>
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="creStartDt" id="creStartDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.creStartDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('creStartDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="creEndDt" id="creEndDt" readonly size="10" maxlength="50" isrequired="true" value="<c:out value="${svcexVO.creEndDt }"/>">
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('creEndDt');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
	</div><!-- //cont_block -->

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

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No', Type: 'Text', SaveName: 'rownum', Width: 50, MinWidth: 10, Align: 'Center', Hidden: true, Edit:false});
	ibHeader.addHeader({Header: '지역', Type: 'Text', SaveName: 'detailnm', Width: 80, MinWidth: 30, Align: 'Left', Edit:false});
	ibHeader.addHeader({Header: '발급건수', Type: 'AutoSum', SaveName: 'issueCnt', Width: 80, MinWidth: 20, Align: 'Right', Edit:false});
	ibHeader.addHeader({Header: '승인건수', Type: 'AutoSum', SaveName: 'clearCnt', Width: 80, MinWidth: 20, Align: 'Right', Edit:false});
	ibHeader.addHeader({Header: '반려건수', Type: 'AutoSum', SaveName: 'returnCnt', Width: 80, MinWidth: 20, Align: 'Right', Edit:false});

	ibHeader.setConfig({AutoFitColWidth: 'init|search', SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, editable: false, MergeSheet :5, VScrollMode: 0, NoFocusMode : 0 });
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		var container = $('#selectList')[0];
		createIBSheet2(container, 'selectListSheet', '100%', '600px');
		ibHeader.initSheet('selectListSheet');
		selectListSheet.SetSelectionMode(4);
		$('#creStartDt').datepicker({ dateFormat: 'yy-mm-dd', altField : "#creStartDtTmp", altFormat : "yymmdd" });
		$('#creEndDt').datepicker({ dateFormat: 'yy-mm-dd', altField : "#creEndDtTmp", altFormat : "yymmdd" });
		selectListSheet.SetCellAlign(selectListSheet.LastRow(), 'detailnm', "Center");
		selectListSheet.SetSumText('detailnm', "합계");
		// 시작일 선택 이벤트
		datepickerById('creStartDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('creEndDt', toDateSelectEvent);
		selectList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#creStartDt').val());
		if ($('#creEndDt').val() != '') {
			if (startymd > Date.parse($('#creEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#creStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#creEndDt').val());

		if ($('#creStartDt').val() != '') {
			if (endymd < Date.parse($('#creStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#creEndDt').val('');

				return;
			}
		}
	}

	function doSearch() {
		selectList();
	}

	// 페이징 처리
	function selectListSheet_OnVScroll(vpos, oldvpos, isTop, isBottom) {
		if( isTop == true ) {
			selectListSheet.GoToPrevPage();
		}else if( isBottom == true ) {
	    	selectListSheet.GoToNextPage();
	    }
	}

	function selectList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexStat/tradeLump8DataList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				selectListSheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
// 				setGrid(data);
			}
		});
	}

 	function selectListSheet_OnRowSearchEnd(row) {
		notEditableCellColor('selectListSheet', row);

		if (row > 0){
		}
	}
</script>
