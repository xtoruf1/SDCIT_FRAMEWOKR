<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="prizeForm" name="prizeForm" method="get" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doRowAdd();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcelDownload();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">포상코드</th>
				<td>
					<input type="text" id="searchPrizeNo" name="searchPrizeNo" value="${param.searchPrizeNo}" onkeydown="onEnter(doSearch);" class="form_text w100p" maxlength="150" title="포상코드" />
				</td>
				<th scope="row">포상명</th>
				<td>
					<input type="text" id="searchPrizeName" name="searchPrizeName" value="${param.searchPrizeName}" onkeydown="onEnter(doSearch);" class="form_text w100p" maxlength="150" title="포상명" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="prizeList" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		initIBSheet();
	});

	// Sheet의 초기화 작업
	function initIBSheet() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', Hidden: false, Width: 60, Align: 'Center', SaveName: 'delChk', HeaderCheck: false });
		ibHeader.addHeader({Header: '상태', Type: 'Status', Hidden: true, Width: 60, Align: 'Center', SaveName: 'status' });
		ibHeader.addHeader({Header: '포상코드', Type: 'Text', Hidden: false,  Width: 100, Align: 'Center', SaveName: 'prizeCd', KeyField:1, CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 1, EditLen: 10, BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '포상구분', Type: 'Combo', Hidden: false, Width: 120, Align: 'Center', SaveName: 'prizeClass', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 20, ComboCode: '${saAWD018.detailcd}', ComboText: '${saAWD018.detailnm}' });
		ibHeader.addHeader({Header: '포상명', Type: 'Text', Hidden: false, Width: 200, Align: 'Left', SaveName: 'prizeName', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 100 });
		ibHeader.addHeader({Header: '포상약어', Type: 'Text', Hidden: false, Width: 150, Align: 'Left', SaveName: 'prizeShortNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 50 });
		ibHeader.addHeader({Header: '포상영문명', Type: 'Text', Hidden: false, Width: 250, Align: 'Left', SaveName: 'prizeEname', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 150 });
		// ibHeader.addHeader({Header: '맵핑코드', Type: 'Combo', Hidden: false, Width: 120, Align: 'Center', SaveName: 'mappingCd', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 10 });
		ibHeader.addHeader({Header: '맵핑코드', Type: 'Text', Hidden: false, Width: 120, Align: 'Center', SaveName: 'mappingCd', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 10 });
		ibHeader.addHeader({Header: '탑기준금액', Type: 'Int', Hidden: false, Width: 170, Align: 'Right', SaveName: 'checkValue', CalcLogic: '', Format: 'NullInteger', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 30 });
		ibHeader.addHeader({Header: '사용여부', Type: 'CheckBox', Hidden: false, Width: 80, Align: 'Center', SaveName: 'useYn', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 30, HeaderCheck: false, TrueValue: 'Y', FalseValue: 'N' });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 5, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = 'prizeList';
		var container = $('#' + sheetId)[0];
		if (typeof prizeListSheet !== 'undefined' && typeof prizeListSheet.Index !== 'undefined') {
			prizeListSheet.DisposeSheet();
		}

		createIBSheet2(container, 'prizeListSheet', '100%', '600px');
		ibHeader.initSheet('prizeListSheet');

		prizeListSheet.SetEditable(true);

		getList();
	}

	function prizeListSheet_OnSort(col, order) {
		prizeListSheet.SetScrollTop(0);
	}

	// 조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/ajc/selectAwardCodeManagementList.do" />'
			, data : $('#prizeForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				prizeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function doExcelDownload() {
		downloadIbSheetExcel(prizeListSheet, '포상코드관리_리스트', '');
	}

	function doRowAdd() {
		prizeListSheet.DataInsert();
	}

	function doSave() {
		if (confirm('포상코드 정보를 저장하시겠습니까?')) {
			var saveJson = prizeListSheet.GetSaveJson();

			// 대상목록의 정보
			if (saveJson.Message == 'KeyFieldError') {
				return false;
			}

			if (saveJson.Message == 'InvalidInputError') {
				return false;
			}

			if (saveJson.data.length) {
				var pf = $('#prizeForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});

					pf['codeList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/tdms/ajc/saveAwardCodeManagementList.do" />'
					, data : JSON.stringify(pf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						// alert('포상코드 정보를 저장 하였습니다.');

						getList();
					}
				});
			}
		}
	}
</script>