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
<div  id="popupExpertList" style="width: 900px;height: 520px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">전문가 선택</h2>
		<div class="ml-auto">
			<button type="button" onclick="setSelectExpert();" class="btn_sm btn_primary">선택</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="doExpertSearch();" class="btn_sm btn_primary">검색</button>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<!--검색 시작 -->
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:20%;" />
					<col style="width:30%;" />
					<col style="width:20%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">전문분야</th>
						<td>
							<select id="popupConsultTypeCd" class="form_select w100p">
								<option value="">전체</option>
								<c:forEach var="item" items="${consultType}" varStatus="status">
									<option value="${item.consultTypeCd}">${item.consultTypeNm}</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">성명</th>
						<td>
							<input type="text" id="popupMemberNm" value="" onkeydown="onEnter(doExpertSearch);" class="form_text w100p" title="성명" />
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
		<!--검색 끝 -->
		<div class="cont_block mt-20">
			<div style="display: flex;justify-content: space-between;min-height: 300px;">
				<div style="width: 45%;">
					<div id="sourceExpertList" class="sheet"></div>
				</div>
				<div style="display: inline-flex;flex-direction: column;justify-content: center;align-items: center;vertical-align: top;">
					<button type="button" id="expertAdd" onclick="selectRowData('sourceExpertList');" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
					&nbsp;
					<button type="button" id="expertRemove" onclick="selectRowData('targetExpertList');" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
				</div>
				<div style="width: 45%;">
					<div id="targetExpertList" class="sheet"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	// 전문가 검색
	var	ibSourceHeader = new IBHeader();
	ibSourceHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibSourceHeader.addHeader({Header: '전문분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Cursor: 'Pointer', Edit: 0, Ellipsis: 1});
	ibSourceHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'expertNm', Width: 70, Align: 'Center', Cursor: 'Pointer', Edit: 0});
	
	ibSourceHeader.addHeader({Header: '아이디', Type: 'Text', SaveName: 'expertId', Hidden: true});
	
	ibSourceHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, MergeSheet: 5, MaxSort: 1});
	ibSourceHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var	ibTargetHeader = new IBHeader();
	ibTargetHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibTargetHeader.addHeader({Header: '전문분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Cursor: 'Pointer', Edit: 0, Ellipsis: 1});
	ibTargetHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'expertNm', Width: 70, Align: 'Center', Cursor: 'Pointer', Edit: 0});
	
	ibTargetHeader.addHeader({Header: '아이디', Type: 'Text', SaveName: 'expertId', Hidden: true});
	
	ibTargetHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, MergeSheet: 5, MaxSort: 1});
	ibTargetHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
	
	var parentExpertId = [];
	$(document).ready(function(){
		var sourceContainer = $('#sourceExpertList')[0];
		if (typeof sourceExpertList !== 'undefined' && typeof sourceExpertList.Index !== 'undefined') {
			sourceExpertList.DisposeSheet();
		}
		createIBSheet2(sourceContainer, 'sourceExpertList', '100%', '400px');
		ibSourceHeader.initSheet('sourceExpertList');
		sourceExpertList.SetSelectionMode(4);
	
		sourceExpertList.LoadSearchData([]);
		
		var targetContainer = $('#targetExpertList')[0];
		if (typeof targetExpertList !== 'undefined' && typeof targetExpertList.Index !== 'undefined') {
			targetExpertList.DisposeSheet();
		}
		createIBSheet2(targetContainer, 'targetExpertList', '100%', '400px');
		ibTargetHeader.initSheet('targetExpertList');
		targetExpertList.SetSelectionMode(4);
		
		targetExpertList.LoadSearchData([]);
		
		<c:if test="${not empty param.expertIds}">
			<c:set var="expertIdList" value="${fn:split(param.expertIds, ',')}" />
			<c:forEach var="item" items="${expertIdList}" varStatus="status">
				parentExpertId.push('${item}');
			</c:forEach>
			
			getExpertRightList();
		</c:if>
	});
	
	function doExpertSearch() {
		getExpertList();
	}
	
	// 전문가 조회
	function getExpertList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/exp/selectExpert.do" />'
			, data : {
				searchConsultTypeCd : $('#popupConsultTypeCd').val()
				, searchMemberNm : $('#popupMemberNm').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if (data != null && Array.isArray(data['resultList'])) {
                    var expertList = [];
                    data['resultList'].forEach(function(item){
                        if (targetExpertList.FindText('expertId', item['expertId']) < 0) {
                            expertList.push(item);
                        }
                    });
                    
					// 기존 선택된 전문가는 제외
    				sourceExpertList.LoadSearchData({Data: expertList});  
				}
			}
		});
	}
	
	function sourceExpertList_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('sourceExpertList', row);
	}
	
	// 전문가 조회(오른쪽)
	function getExpertRightList() {
		console.log(parentExpertId);
		
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/exp/selectExpert.do" />'
			, data : {
				expertIdList : parentExpertId
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if (data != null && Array.isArray(data['resultList'])) {
					targetExpertList.LoadSearchData({Data: data['resultList']});  
				}
			}
		});
	}
	
	function targetExpertList_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('targetExpertList', row);
	}
	
	// 버튼 클릭시 데이터 이동
	function selectRowData(sheetId, Row, Col, Value) {
		var rowData = getSelectRowData(sheetId);
		
		// 전문가 선택
		if (sheetId == 'sourceExpertList') {
			// 선택 데이터 추가
			dataInsertGrid('targetExpertList', -1, rowData[0]);
			rowDeleteGrid('sourceExpertList', null, true);
		} else if (sheetId == 'targetExpertList') {
			// 선택 데이터 삭제
			dataInsertGrid('sourceExpertList', -1, rowData[0]);
			rowDeleteGrid('targetExpertList', null, true);
		}
	}
	
	function sourceExpertList_OnDblClick(Row, Col, Value) {
		var rowData = getRowDataGrid('sourceExpertList', Row);
		
		dataInsertGrid('targetExpertList', -1, rowData);
		rowDeleteGrid('sourceExpertList', null, true);
	}

	function targetExpertList_OnDblClick(Row, Col, Value) {
		var rowData = getRowDataGrid('targetExpertList', Row);
		
		dataInsertGrid('sourceExpertList', -1, rowData);
		rowDeleteGrid('targetExpertList', null, true);
	}
	
	// 전문가 선택 - 드레그 앤 드롭 
	function sourceExpertList_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow) {
		// 같은 시트 데이터이동 안됨
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

	function targetExpertList_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow) {
		// 같은 시트 데이터이동 안됨
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
	
	function setSelectExpert() {
		var selectExpertId = [];
		var expertNm = [];
		
		var rowData = targetExpertList.ExportData({
			'Type' : 'json'
		});
		
		rowData.data.forEach(function(item){
			selectExpertId.push(item);
			expertNm.push(item['expertNm']);
		});
		
		var expertObj = {};
		expertObj['selectExpertId'] = selectExpertId;
		expertObj['expertNm'] = expertNm;
		
		// 콜백
		layerPopupCallback(expertObj);
		
		closeLayerPopup();
	}
</script>