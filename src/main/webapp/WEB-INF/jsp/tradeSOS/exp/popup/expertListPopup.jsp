<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div style="width: 800px;height: 520px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">전문가 선택</h2>
		<div class="ml-auto">
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
			<div id="expertList" class="sheet"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var	ibExpertHeader = new IBHeader();
	ibExpertHeader.addHeader({Header: '전문분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 100, Align: 'Left', Cursor: 'Pointer', Edit: 0});
	ibExpertHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'expertNm', Width: 50, Align: 'Center', Cursor: 'Pointer', Edit: 0});
	
	ibExpertHeader.addHeader({Header: '아이디', Type: 'Text', SaveName: 'expertId', Hidden: true});
	
	ibExpertHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, MaxSort: 1});
	ibExpertHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	$(document).ready(function(){
		// 셀렉트 박스 값을 갱신
		$('.jquerySelectbox').selectmenu().selectmenu('refresh');
		
		var expertContainer = $('#expertList')[0];
		if (typeof expertListSheet !== 'undefined' && typeof expertListSheet.Index !== 'undefined') {
			expertListSheet.DisposeSheet();
		}
		createIBSheet2(expertContainer, 'expertListSheet', '100%', '400px');
		ibExpertHeader.initSheet('expertListSheet');
		expertListSheet.SetSelectionMode(4);
		
		expertListSheet.LoadSearchData([]);
	});
	
	function expertListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('expertListSheet_OnSearchEnd : ', msg);
    	}
    }
	
	function expertListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (
				expertListSheet.ColSaveName(col) == 'consultTypeNm'
				|| expertListSheet.ColSaveName(col) == 'expertNm'
			) {
				var expertId = expertListSheet.GetCellValue(row, 'expertId');
				var expertNm = expertListSheet.GetCellValue(row, 'expertNm');
				
				setSelectExpert(expertId, expertNm);
		    }	
		}
	}
	
	function doExpertSearch() {
		getExpertList();
	}
	
	// 목록 가져오기
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
				expertListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function expertListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('expertListSheet', row);
	}
	
	function setSelectExpert(expertId, expertNm) {
		var expertObj = {
			expertId : expertId
			, expertNm : expertNm
		}
		
		// 콜백
		layerPopupCallback(expertObj);
		
		closeLayerPopup();
	}
</script>