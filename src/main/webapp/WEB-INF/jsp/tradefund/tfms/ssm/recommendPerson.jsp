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
		<button type="button" onclick="downloadIbSheetExcel(listSheet, '추천인명단', '');" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col/>
			<col style="width:10%" />
			<col style="width:23%" />
			<col style="width:10%" />
			<col style="width:23%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">포상명</th>
				<td>
					<span class="form_search">
						<input type="text" id="sBsnNm" name="sBsnNm" class="form_text w100p" value="<c:out value="${svrInfo.bsnNm}"/>" style="font-size: 14px;" readonly="readonly" />
						<input type="hidden" id="sSvrId" name="sSvrId" value="<c:out value="${svrInfo.svrId}" />" />
						<button type="button" class="btn_icon btn_search" onclick="openLayerDlgSearchAwardPop();" title="포상검색"></button>
					</span>
				</td>
				<th scope="row">추천기관</th>
				<td>
					<select id="sOrgCd" name="sOrgCd" class="form_select">
						<option value="">::: 전체 :::</option>
						<c:forEach var="list" items="${SPE001}" varStatus="status">
						<option value="${list.detailnm}">${list.detailnm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">신청여부</th>
				<td>
					<select id="sStatus" name="sStatus" class="form_select">
						<option value="">::: 전체 :::</option>
						<option value="Y">신청</option>
						<option value="N">미신청</option>
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
		<fieldset class="ml-auto">
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="sheetDiv" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: 'status', 		Type: 'Status', 	SaveName: 'status', 			Hidden: true });
	ibHeader.addHeader({Header: 'personId',		Type: 'Text', 		SaveName: 'personId', 			Hidden: true });
	ibHeader.addHeader({Header: '삭제', 			Type: 'DelCheck', 	SaveName: 'delFlag', 			Width: 40, 	Align: 'Center',	Edit: 1, HeaderCheck: 0,	Hidden: true});
	ibHeader.addHeader({Header: '추천기관',    	Type: 'Combo',     	SaveName: 'orgCd', 				Width:200,  Align: 'Left',		UpdateEdit: false,   InsertEdit: false,	ComboCode: "|<c:out value="${sheetComboSPE001.detailnm}"/>", ComboText: "선택|<c:out value="${sheetComboSPE001.detailnm}"/>"  });
	ibHeader.addHeader({Header: '부문',    		Type: 'Combo',     	SaveName: 'recommendSector', 	Width:200,  Align: 'Left',		UpdateEdit: false,   InsertEdit: false,	ComboCode: "|<c:out value="${sheetComboSPE000.detailcd}"/>", ComboText: "선택|<c:out value="${sheetComboSPE000.detailnm}"/>"  });
	ibHeader.addHeader({Header: '추천인명',   		Type: 'Text',     	SaveName: 'recommendName', 		Width:100,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false });
	ibHeader.addHeader({Header: '주민(여권)번호',	Type: 'Text',     	SaveName: 'recommendJuminNo', 	Width:100,  Align: 'Center',	UpdateEdit: false, InsertEdit: false, Format: 'IdNo'});
	ibHeader.addHeader({Header: '소속',   		Type: 'Text',     	SaveName: 'companyName', 		Width:150,  Align: 'Left',		UpdateEdit: false,  InsertEdit: false });
	ibHeader.addHeader({Header: '직위',   		Type: 'Text',     	SaveName: 'position', 			Width:100,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false });
	ibHeader.addHeader({Header: '휴대폰',   		Type: 'Text',     	SaveName: 'phone', 				Width:120,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false });
	ibHeader.addHeader({Header: '이메일',   		Type: 'Text',     	SaveName: 'email', 				Width:150,  Align: 'Left',		UpdateEdit: false,  InsertEdit: false });
	ibHeader.addHeader({Header: '상태',   		Type: 'Text',     	SaveName: 'statusCd', 			Width:100,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false });

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1, UseHeaderSortCancel: 1 , MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 1, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'listSheet', '100%', '525px');
		ibHeader.initSheet('listSheet');
		listSheet.SetSelectionMode(4);

		//목록조회 호출
		getList();
	});

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	//시트가 조회된 후 실행
	function listSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('listSheet_OnSearchEnd : ', msg);
    	} else {
    	}
    }

	//시트 조회 완료 후 하나하나의 행마다 실행
	function listSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('listSheet', row);
	}

	//시트 클릭 이벤트
	function listSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (listSheet.ColSaveName(col) == 'companyName') {
		    }
		}
	}

	//검색
	function doSearch() {
		goPage(1);
	}

	//페이징 검색
	function goPage(pageIndex) {
		getList();
	}

	//목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectRecommendPersonList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function openLayerDlgSearchAwardPop(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'

			, callbackFunction : function(resultObj) {
				$('#sSvrId').val(resultObj.svrId);
				$('#sBsnNm').val(resultObj.bsnNm);
				getList();
			}
		});

	}

</script>