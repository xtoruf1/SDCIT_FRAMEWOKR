<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="frm" name="frm" method="get" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(statSheet, '진행상황_통계', '');">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">연도</th>
				<td>
					<select id="searchYear" name="searchYear" class="form_select">
						<c:forEach var="list" items="${yearList}" varStatus="status">
						<option value="${list.yyyy}" <c:if test="${param.searchYear eq list.yyyy}">selected="selected"</c:if>>${list.yyyy}</option>
						</c:forEach>
					</select>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="sheetDiv" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'No',				Type: 'Text', 		SaveName: 'rn', 			Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '개최일',			Type: 'Text', 		SaveName: 'cfrcStartDate', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '상담회명',			Type: 'Text', 		SaveName: 'cfrcName', 		Width: 300, Align: 'Left'});
	ibHeader.addHeader({Header: '협력기관',			Type: 'Text', 		SaveName: 'partner', 		Width: 150, Align: 'Left'});
	ibHeader.addHeader({Header: '신청',				Type: 'AutoSum', 	SaveName: 'applCnt',		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '확정',				Type: 'AutoSum', 	SaveName: 'confirmCnt', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '상담완료',			Type: 'AutoSum', 	SaveName: 'finishCnt', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '후속상담',			Type: 'AutoSum', 	SaveName: 'nextCnt', 		Width: 100, Align: 'Center'});
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'statSheet', '100%', '100%');
		ibHeader.initSheet('statSheet');
		statSheet.SetSelectionMode(4);
    	// 편집모드 OFF
        statSheet.SetEditable(0);
		//목록조회 호출
		getList();
	});

	//시트가 조회된 후 실행
	function statSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('statSheet_OnSearchEnd : ', msg);

    	} else {
			var sumRow = Number(statSheet.FindSumRow());
			statSheet.SetMergeCell(sumRow, 0, 1, 4);      // 0~2 셀 머지
			statSheet.SetSumValue(0, 0, "합계");          // 합계 텍스트
			statSheet.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬

    	}
    }

	//시트 조회 완료 후 하나하나의 행마다 실행
	function statSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('statSheet', row);
	}

	//검색
	function doSearch() {
		getList();
	}

	//목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/technicalConsulting/stat/selectProgressStatList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + data.resultList.length + '</span> 건');

				statSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}


</script>