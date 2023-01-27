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
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doRowAdd();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col style="width:13%" />
			<col style="width:10%" />
			<col style="width:13%" />
			<col style="width:10%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">추천기관</th>
				<td>
					<select id="sOrgCd" name="sOrgCd" class="form_select">
						<option value="">::: 전체 :::</option>
						<c:forEach var="list" items="${SPE001}" varStatus="status">
						<option value="${list.detailnm}">${list.detailnm}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">담당자명</th>
				<td>
					<input type="text" id="sChargeName" name="sChargeName" value="" onkeydown="onEnter(doSearch);" class="form_text w100p" title="담당자명" />
				</td>
				<th scope="row">사용여부</th>
				<td>
					<select id="sUseYn" name="sUseYn" class="form_select">
						<option value="">::: 전체 :::</option>
						<option value="Y">사용</option>
						<option value="N">미사용</option>
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
	ibHeader.addHeader({Header: '상태', 			Type: 'Status', 	SaveName: 'status', Hidden: true});
	ibHeader.addHeader({Header: 'orgId',		Type: 'Text', 		SaveName: 'orgId', 	Hidden: true});
	ibHeader.addHeader({Header: '삭제', 			Type: 'DelCheck', 	SaveName: 'delFlag', 			Width: 40, 	Align: 'Center',	Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '추천기관',    	Type: 'Combo',     	SaveName: 'orgCd', 				Width:200,  Align: 'Left',		KeyField: 1,	UpdateEdit: false,   InsertEdit: true,	ComboCode: "|<c:out value="${sheetComboSPE001.detailnm}"/>", ComboText: "선택|<c:out value="${sheetComboSPE001.detailnm}"/>", BackColor: '#F6F6F6' });
	ibHeader.addHeader({Header: '담당자ID',    	Type: 'Popup',     	SaveName: 'chargeId', 			Width:100,  Align: 'Left',		KeyField: 1,	UpdateEdit: false,  InsertEdit: true, PopupButton: true, BackColor: '#F6F6F6' });
	ibHeader.addHeader({Header: '담당자명',    	Type: 'Text',     	SaveName: 'chargeName', 		Width:100,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false, BackColor: '#F6F6F6' });
	ibHeader.addHeader({Header: '담당자 연락처',   	Type: 'Text',     	SaveName: 'chargePhone', 		Width:100,  Align: 'Center',	UpdateEdit: true,   InsertEdit: true, 	EditLen:20 });
	ibHeader.addHeader({Header: '담당자 이메일',   	Type: 'Text',     	SaveName: 'chargeEmail', 		Width:100,  Align: 'Left',		UpdateEdit: true,   InsertEdit: true, 	EditLen:30 });
	ibHeader.addHeader({Header: '권한부여 시작일',  Type: 'Date',     	SaveName: 'authStartDate', 		Width:100,  Align: 'Center',	KeyField: 1,	UpdateEdit: true,   InsertEdit: true, 	Format:"yyyy-MM-dd"});
	ibHeader.addHeader({Header: '권한부여 종료일',  Type: 'Date',     	SaveName: 'authEndDate', 		Width:100,  Align: 'Center',	KeyField: 1,	UpdateEdit: true,   InsertEdit: true, 	Format:"yyyy-MM-dd"});
	ibHeader.addHeader({Header: '사용여부',   		Type: 'Combo',     	SaveName: 'useYn', 				Width:100,  Align: 'Center',	KeyField: 1,	UpdateEdit: true,   InsertEdit: true, 	ComboCode: 'Y|N', ComboText : '사용|미사용' });

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'listSheet', '100%', '560px');
		ibHeader.initSheet('listSheet');
		listSheet.SetSelectionMode(4);

		//목록조회 호출
		getList();
	});

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

	function listSheet_OnPopupClick(row,col) {
		if( listSheet.ColSaveName(col) == "chargeId" ) {
			viewPopup(row, col);
		}
	}

	function viewPopup(row, col) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/authority/popup/userList.do" />'
			, callbackFunction : function(resultObj){
				listSheet.SetCellValue(row,'chargeId',resultObj.userId);
				listSheet.SetCellValue(row,'chargeName',resultObj.userNm);
				listSheet.SetCellValue(row,'chargePhone',resultObj.userCpTelno);
				listSheet.SetCellValue(row,'chargeEmail',resultObj.userEmail);
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
			, url : '<c:url value="/tfms/ssm/selectRecommendOrgList.do" />'
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

		if( listSheet.ColValueDup('chargeId',{'IncludeDelRow': 0}) > -1 ){
			alert(listSheet.ColValueDup('chargeId',{'IncludeDelRow': 0})+'번째행 [담당자ID : '+listSheet.GetCellValue(listSheet.ColValueDup('chargeId',{'IncludeDelRow': 0}),'chargeId')+'] 중복됩니다.');
			return false;

		}

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tfms/ssm/saveRecommendOrg.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					if( data.dupCheck != '' ){
						alert(data.dupCheck+' 중복되어 제외하고 저장하였습니다.');
					}
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

</script>