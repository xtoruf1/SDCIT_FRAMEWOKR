<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<style type="text/css">
	#popupExpertList .btn_standard {margin: 0 20px;min-width: 40px;height: 38px;background-color: #2c3e50;}
	#popupExpertList .btn_standard > span {display: block;width: 100%; height: 100%;}
	#popupExpertList .btn_standard .prev {background: url(../../images/icon/icon_progress_left.png) no-repeat center center;}
	#popupExpertList .btn_standard .next {background: url(../../images/icon/icon_progress_right.png) no-repeat center center;}
</style>
<div  id="popupExpertList" style="width: 600px;height: 475px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">상담분야 선택</h2>
		<div class="ml-auto">
			<button type="button" onclick="setSelectConsultType();" class="btn_sm btn_primary">선택</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<div class="cont_block mt-20">
			<div style="display: flex;justify-content: space-between;min-height: 250px;">
				<div style="width: 45%;">
					<div id="sourceConsultList" class="sheet"></div>
				</div>
				<div style="display: inline-flex;flex-direction: column;justify-content: center;align-items: center;vertical-align: top;">
					<button type="button" id="consultTypeAdd" onclick="selectRowData('sourceConsultList');" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
					&nbsp;
					<button type="button" id="consultTypeRemove" onclick="selectRowData('targetConsultList');" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
				</div>
				<div style="width: 45%;">
					<div id="targetConsultList" class="sheet"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	// 상담분야 검색
	var	ibSourceHeader = new IBHeader();
	ibSourceHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibSourceHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Cursor: 'Pointer', Edit: 0, Ellipsis: 1});
	
	ibSourceHeader.addHeader({Header: '상담분야코드', Type: 'Text', SaveName: 'consultTypeCd', Hidden: true});
	
	ibSourceHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, MergeSheet: 5, MaxSort: 1});
	ibSourceHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var	ibTargetHeader = new IBHeader();
	ibTargetHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibTargetHeader.addHeader({Header: '상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Cursor: 'Pointer', Edit: 0, Ellipsis: 1});
	
	ibTargetHeader.addHeader({Header: '상담분야코드', Type: 'Text', SaveName: 'consultTypeCd', Hidden: true});
	
	ibTargetHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, MergeSheet: 5, MaxSort: 1});
	ibTargetHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
	
	var parentConsultCd = [];
	$(document).ready(function(){
		var sourceContainer = $('#sourceConsultList')[0];
		if (typeof sourceConsultList !== 'undefined' && typeof sourceConsultList.Index !== 'undefined') {
			sourceConsultList.DisposeSheet();
		}
		createIBSheet2(sourceContainer, 'sourceConsultList', '100%', '400px');
		ibSourceHeader.initSheet('sourceConsultList');
		sourceConsultList.SetSelectionMode(4);
	
		sourceConsultList.LoadSearchData([]);  
		
		var targetContainer = $('#targetConsultList')[0];
		if (typeof targetConsultList !== 'undefined' && typeof targetConsultList.Index !== 'undefined') {
			targetConsultList.DisposeSheet();
		}
		createIBSheet2(targetContainer, 'targetConsultList', '100%', '400px');
		ibTargetHeader.initSheet('targetConsultList');
		targetConsultList.SetSelectionMode(4);
		
		targetConsultList.LoadSearchData([]);
		
		<c:if test="${not empty param.consultTypeCds}">
			<c:set var="consultCdList" value="${fn:split(param.consultTypeCds, ',')}" />
			<c:forEach var="item" items="${consultCdList}" varStatus="status">
				parentConsultCd.push('${item}');
			</c:forEach>
		</c:if>
		
		getConsultList();
	});
	
	// 상담분야 조회
	function getConsultList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/exp/selectConsultType.do" />'
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if (data != null && Array.isArray(data['resultList'])) {
					var resultList = data['resultList'];
					var sourceList = resultList.filter(function(item){
						return !parentConsultCd.includes(item['consultTypeCd']);
					});
					var targetList = resultList.filter(function(item){
						return parentConsultCd.includes(item['consultTypeCd']);
					});
					
					sourceConsultList.LoadSearchData({Data: sourceList});
					
					if (targetList) {
						targetConsultList.LoadSearchData({Data: targetList});	
					}
				}
			}
		});
	}
	
	function sourceConsultList_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('sourceConsultList', row);
	}
	
	function targetConsultList_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('targetConsultList', row);
	}
	
	// 버튼 클릭시 데이터 이동
	function selectRowData(sheetId, Row, Col, Value) {
		var rowData = getSelectRowData(sheetId);
		
		// 상담분야 선택 
		if(sheetId == 'sourceConsultList') {
			// 선택 데이터 추가
			dataInsertGrid('targetConsultList', -1, rowData[0]);
			rowDeleteGrid('sourceConsultList', null, true);
		} else if(sheetId == 'targetConsultList') {
			// 선택 데이터 삭제
			dataInsertGrid('sourceConsultList', -1, rowData[0]);
			rowDeleteGrid('targetConsultList', null, true);
		}
	}
	
	function sourceConsultList_OnDblClick(Row, Col, Value) {
		var rowData = getRowDataGrid('sourceConsultList', Row);
		
		dataInsertGrid('targetConsultList', -1, rowData);
		rowDeleteGrid('sourceConsultList', null, true);
	}

	function targetConsultList_OnDblClick(Row, Col, Value) {
		var rowData = getRowDataGrid('targetConsultList', Row);
		
		dataInsertGrid('sourceConsultList', -1, rowData);
		rowDeleteGrid('targetConsultList', null, true);
	}
	
	// 상담분야 선택 - 드레그 앤 드롭 
	function sourceConsultList_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow) {
		// 같은 시트 데이터이동 안됨.
		if (FromSheet == ToSheet) {
			return;
		}
		
		// 드레그 한 행의 데이터를 json형태로 얻음
		var rowjson = FromSheet.GetRowData(FromRow);
		
		// 행 데이터 복사(트리임으로 레벨을 고려할 것)
		ToSheet.SetRowData(ToRow + 1, rowjson, {
			'Add' : 1
		});
		
		// 원본 데이터 삭제
		FromSheet.RowDelete(FromRow);
	};

	function targetConsultList_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow) {
		// 같은 시트 데이터이동 안됨.
		if (FromSheet == ToSheet) {
			return;
		}
		
		// 드레그 한 행의 데이터를 json형태로 얻음
		var rowjson = FromSheet.GetRowData(FromRow), posRow = FromRow;
		
		// 행 데이터 복사(트리임으로 레벨을 고려할 것)
		ToSheet.SetRowData(ToRow + 1, rowjson, {
			'Add' : 1
		});
		
		// 원본 데이터 삭제
		FromSheet.RowDelete(posRow);
	};
	
	function setSelectConsultType() {
		var selectConsultType = [];
		var consultTypeNm = [];
				
		var rowData = targetConsultList.ExportData({
			'Type' : 'json'
		});
		
		rowData.data.forEach(function(item){
			selectConsultType.push(item);
			consultTypeNm.push(item['consultTypeNm']);
		});
		
		var expertObj = {};
		expertObj['selectConsultType'] = selectConsultType;
		expertObj['consultTypeNm'] = consultTypeNm;
		
		// 콜백
		layerPopupCallback(expertObj);
		
		closeLayerPopup();
	}
</script>