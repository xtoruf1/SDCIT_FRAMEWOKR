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
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="sortMng();">부문/기관별 순위관리</button>
	</div>
	<div class="ml-15">
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
				<th scope="row">포상명</th>
				<td>
					<span class="form_search">
						<input type="text" id="sBsnNm" name="sBsnNm" class="form_text w100p" value="<c:out value="${svrInfo.bsnNm}"/>" style="font-size: 14px;" readonly="readonly" />
						<input type="hidden" id="sSvrId" name="sSvrId" value="<c:out value="${svrInfo.svrId}" />" />
						<button type="button" class="btn_icon btn_search" onclick="openLayerDlgSearchAwardPop();" title="포상검색"></button>
					</span>
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
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', 			Type: 'Status', 	SaveName: 'status', 		Hidden: true});
	ibHeader.addHeader({Header: 'svrId',		Type: 'Text', 		SaveName: 'svrId', 			Hidden: true});
	ibHeader.addHeader({Header: 'applySeq',		Type: 'Text', 		SaveName: 'applySeq', 		Hidden: true});
	ibHeader.addHeader({Header: 'spRecKind',	Type: 'Text',     	SaveName: 'spRecKind', 		Hidden: true});
	ibHeader.addHeader({Header: '등급',    		Type: 'Text',     	SaveName: 'gradeCd', 		Width:60,	Align: 'Center'});
	ibHeader.addHeader({Header: '추천부문',    	Type: 'Text',     	SaveName: 'spRecKindNm', 	Width:100,	Align: 'Left'});
	ibHeader.addHeader({Header: '기관순위',    	Type: 'Text',     	SaveName: 'rankNo', 		Width:60,	Align: 'Center'});
	ibHeader.addHeader({Header: '추천기관',    	Type: 'Text',     	SaveName: 'spRecOrg', 		Width:150,	Align: 'Left'});
	ibHeader.addHeader({Header: '추천순위',    	Type: 'Text',     	SaveName: 'sortNo', 		Width:60,	Align: 'Center'});
	ibHeader.addHeader({Header: '한글명',    		Type: 'Text',     	SaveName: 'userNmKor', 		Width:80,	Align: 'Center'});
	ibHeader.addHeader({Header: '한자/영문',    	Type: 'Text',     	SaveName: 'userNmOther', 	Width:80,	Align: 'Center'});
	ibHeader.addHeader({Header: '소속업체',    	Type: 'Text',     	SaveName: 'companyName',	Width:120,	Align: 'Left'});
	ibHeader.addHeader({Header: '직위',    		Type: 'Text',     	SaveName: 'pos', 			Width:80,	Align: 'Center'});
	ibHeader.addHeader({Header: '주민등록번호',    	Type: 'Text',     	SaveName: 'juminNo', 		Width:80,	Align: 'Center'});
	ibHeader.addHeader({Header: '수공기간',    	Type: 'Text',     	SaveName: 'wrkTermYy', 		Width:60,	Align: 'Center'});
	ibHeader.addHeader({Header: '사업자주소',    	Type: 'Text',     	SaveName: 'bsNo', 			Width:80,	Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '법인번호',    	Type: 'Text',     	SaveName: 'corpoNo', 		Width:80,	Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1, UseHeaderSortCancel: 1, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 1, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '597px');
		ibHeader.initSheet('listSheet');
		listSheet.SetSelectionMode(4);
		listSheet.SetEditable(0);

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

	//시트 클릭 이벤트
	function listSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (listSheet.ColSaveName(col) == 'companyName') {

		    }
		}
	}

	function sortMng(){
		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/ssm/speAwardSortPop.do"/>'
			, params : {
				svrId : $('#sSvrId').val()
			}
			, callbackFunction : function(resultObj) {
				getList();
			}
		});
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
			, url : '<c:url value="/tfms/ssm/selectSpeAwardSortList.do" />'
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

	function doRowAdd() {
		var index = listSheet.DataInsert(-1);
	}

	function doSave() {
		var jsonParam = {};
		var saveJson = listSheet.GetSaveJson();
		jsonParam.sheetDataList = saveJson.data;

		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'NoTargetRows') {
			alert('저장할 데이터가 없습니다.');
			return false;
		}

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tfms/ssm/saveSpeAwardSort.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	function openLayerDlgSearchAwardPop() {
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