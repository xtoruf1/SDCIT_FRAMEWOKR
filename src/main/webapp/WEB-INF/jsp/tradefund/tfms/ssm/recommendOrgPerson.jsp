<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="frm" name="frm" method="get" onsubmit="return false;">
<input type="hidden" id="sOrgCd" name="sOrgCd" value="<c:out value="${sOrgCd}" />"/>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="openExcelUploadPopup();">엑셀업로드</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doRowAdd();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
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
			<col style="width:35%" />
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
<form id="downForm" method="post">
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', 			Type: 'Status', 	SaveName: 'status', 			Align: 'Center', Hidden: true });
	ibHeader.addHeader({Header: 'personId',		Type: 'Text', 		SaveName: 'personId', 			Hidden: true });
	ibHeader.addHeader({Header: '삭제', 			Type: 'DelCheck', 	SaveName: 'delFlag', 			Width: 40, 	Align: 'Center',	Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: 'svrId',    	Type: 'Text',     	SaveName: 'svrId', 				Width:0,  	Align: 'Left',		UpdateEdit: false, KeyField: 1,  InsertEdit: false,	Hidden: true });
	ibHeader.addHeader({Header: '추천기관',    	Type: 'Combo',     	SaveName: 'orgCd', 				Width:200,  Align: 'Left',		UpdateEdit: false, KeyField: 1,  InsertEdit: false,	ComboCode: "|<c:out value="${sheetComboSPE001.detailnm}"/>", ComboText: "선택|<c:out value="${sheetComboSPE001.detailnm}"/>", Hidden: true });
	ibHeader.addHeader({Header: '부문',    		Type: 'Combo',     	SaveName: 'recommendSector', 	Width:200,  Align: 'Left',		UpdateEdit: true, KeyField: 1,  InsertEdit: true,	ComboCode: "|<c:out value="${sheetComboSPE000.detailcd}"/>", ComboText: "선택|<c:out value="${sheetComboSPE000.detailnm}"/>"  });
	ibHeader.addHeader({Header: '순위',   		Type: 'Int',     	SaveName: 'sortNo', 			Width:100,  Align: 'Center',	UpdateEdit: true, KeyField: 1, InsertEdit: true, EditLen:2});
	ibHeader.addHeader({Header: '추천인명',   		Type: 'Text',     	SaveName: 'recommendName', 		Width:100,  Align: 'Center',	UpdateEdit: true, KeyField: 1, InsertEdit: true, EditLen:10});
	ibHeader.addHeader({Header: '주민(여권)번호',	Type: 'Text',     	SaveName: 'recommendJuminNo', 	Width:100,  Align: 'Center',	UpdateEdit: false, KeyField: 1, InsertEdit: true, EditLen:13,  AcceptKeys:"N|E" });
	ibHeader.addHeader({Header: '소속',   		Type: 'Text',     	SaveName: 'companyName', 		Width:150,  Align: 'Left',		UpdateEdit: true, KeyField: 1, InsertEdit: true, EditLen:20 });
	ibHeader.addHeader({Header: '직위',   		Type: 'Text',     	SaveName: 'position', 			Width:100,  Align: 'Center',	UpdateEdit: true, KeyField: 1, InsertEdit: true, EditLen:20 });
	ibHeader.addHeader({Header: '휴대폰',   		Type: 'Text',     	SaveName: 'phone', 				Width:120,  Align: 'Center',	UpdateEdit: true, KeyField: 1, InsertEdit: true, EditLen:13, Format: 'PhoneNo' });
	ibHeader.addHeader({Header: '이메일',   		Type: 'Text',     	SaveName: 'email', 				Width:150,  Align: 'Left',		UpdateEdit: true,  InsertEdit: true, EditLen:50 });
	ibHeader.addHeader({Header: '상태',   		Type: 'Text',     	SaveName: 'statusCd', 			Width:100,  Align: 'Center',	UpdateEdit: false,  InsertEdit: false });

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'listSheet', '100%', '100%');
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

	function doRowAdd() {
		var index = listSheet.DataInsert(-1);
		listSheet.SetCellBackColor(index, 'recommendJuminNo', '#ffffff');
		listSheet.SetCellValue(index,'svrId',$('#sSvrId').val());
		listSheet.SetCellValue(index,'orgCd',$('#sOrgCd').val());
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

		if( listSheet.ColValueDup('recommendJuminNo',{'IncludeDelRow': 0}) > -1 ){
			alert(listSheet.ColValueDup('recommendJuminNo',{'IncludeDelRow': 0})+'번째행 [주민등록번호 : '+listSheet.GetCellValue(listSheet.ColValueDup('recommendJuminNo',{'IncludeDelRow': 0}),'recommendJuminNo')+'] 중복됩니다.');
			listSheet.SelectCell(listSheet.ColValueDup('recommendJuminNo',{'IncludeDelRow': 0}), 'recommendJuminNo');
			return false;
		}

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tfms/ssm/saveRecommendPerson.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					if( data.message != '' ){
						alert(data.message);
					}else {
						getList();
					}
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	function openExcelUploadPopup() {

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/tfms/ssm/popup/recommendOrgExcelUpload.do'
			, callbackFunction : function(resultObj){}
		});

	}

	function listSheet_OnLoadExcel(result, code, msg) {

		var svrId = $('#sSvrId').val();
		var orgCd = $('#sOrgCd').val();

	    for( var i = 1; i <= listSheet.RowCount(); i++ ){
	    	if( listSheet.GetCellValue(i,'svrId') == '' ){
	    		listSheet.SetCellValue(i,'svrId',svrId);
	    		listSheet.SetCellValue(i,'orgCd',orgCd);
	    	}
	    	if(listSheet.GetCellValue(i,'status') == 'I') {
	    		listSheet.SetCellBackColor(i, 'recommendJuminNo', '#ffffff');
	    	}
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

	function doExcel() {
		var today = new Date();
		var year = today.getFullYear();			// 년도
		var month = today.getMonth() + 1;		// 월
		var date = today.getDate();				// 날짜
		var todayStr = year + '-' + (month > 9 ? month : '0' + month) + '-' + (date > 9 ? date : '0' + date);

		params = {
			'FileName' : '추천인명단_' + todayStr + '.xlsx'
			, 'SheetName' : 'Sheet1'
			, 'SheetDesign' : 1
			, 'Merge' : 1
			, 'CheckBoxOnValue' : 'Y'
			, 'CheckBoxOffValue' : 'N'
			, 'HiddenColumn' : 1
			, 'Mode' : 1

		};
		listSheet.Down2Excel(params);
	}

</script>