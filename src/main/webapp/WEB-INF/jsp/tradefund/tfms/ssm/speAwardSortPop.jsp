<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="submitForm" name="submitForm" method="post">
<input type="hidden" id="svrId" name="svrId" value="<c:out value="${param.svrId}" />" />
<div style="width: 1170px;height: 650px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">추천부문 기관별 순위등록</h2>
		<div class="ml-auto">
			<button type="button" onclick="saveSort();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		</div>
		<div class="ml-15">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div style="display: flex; justify-content: space-between;">
				<div style="width: 49%;" >
					<div id='tblGridSheet' style="padding-top: 10px;"></div>
				</div>
				<div style="width: 50%;">
					<div id='tblGrid2Sheet' style="padding-top: 10px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){

		f_Init_tblGridSheet();
		f_Init_tblGrid2Sheet();

		getGradeList();
	});

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 0, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type:"Status",	Header:"상태",			SaveName:"status",			Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"svrId",			SaveName:"svrId",			Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"spRecKind",		SaveName:"spRecKind",		Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"추천부문",			SaveName:"spRecKindNm",		Align:"Left",		Width:150,	Edit:false});
		ibHeader.addHeader({Type:"Int",		Header:"등급",			SaveName:"gradeCd",			Align:"Center",		Width:50,	EditLen:3});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];

		if (typeof container !== 'undefined' && typeof tblGridSheet.Index !== 'undefined') {
			tblGridSheet.DisposeSheet();
		}

		createIBSheet2(container, sheetId, "100%", "550px");

		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetSelectionMode(2);
	};

	function f_Init_tblGrid2Sheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 0, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
		ibHeader.addHeader({Type:"Status",	Header:"상태",			SaveName:"status",			Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"svrId",			SaveName:"svrId",			Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"spRecKind",		SaveName:"spRecKind",		Align:"Center",		Width:50, 	Hidden:true});
		ibHeader.addHeader({Type:"Text",	Header:"추천기관",			SaveName:"spRecOrg",		Align:"Left",		Width:150,	Edit:false});
		ibHeader.addHeader({Type:"Int",		Header:"등급",			SaveName:"rankNo",			Align:"Center",		Width:50,	EditLen:3});

		var sheetId = "tblGrid2Sheet";
		var container = $("#"+sheetId)[0];
		if (typeof container !== 'undefined' && typeof tblGrid2Sheet.Index !== 'undefined') {
			tblGrid2Sheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "550px");

		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGrid2Sheet.ShowFilterRow();    //필터
        tblGrid2Sheet.SetRowHidden(1, 1); // 마스터 키 에따른 히든
		tblGrid2Sheet.SetSelectionMode(2);
	};

	function getGradeList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectSpeKindGradeList.do" />'
			, data : $('#submitForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function getRankList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectSpeOrgRankList.do" />'
			, data : $('#submitForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGrid2Sheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function tblGridSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete){
		tblGrid2Sheet.SetFilterValue("spRecKind", tblGridSheet.GetCellValue(tblGridSheet.GetSelectRow(), "spRecKind"), 1);
	}

	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGridSheet_OnSearchEnd : ', msg);
    	} else {
    		getRankList();
			//tblGridSheet.SelectCell(1,1);

    	}
    }

	function tblGrid2Sheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGridSheet_OnSearchEnd : ', msg);
    	} else {
			tblGridSheet.SelectCell(1,1);

    	}
    }

	function saveSort() {
		var jsonParam = {};
		var sheet1 = tblGridSheet.GetSaveJson({AllSave: 1});
		var sheet2 = tblGrid2Sheet.GetSaveJson({AllSave: 1});
		jsonParam.svrId = $('#submitForm #svrId').val();
		jsonParam.sheet1Data = sheet1.data;
		jsonParam.sheet2Data = sheet2.data;

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
					layerPopupCallback();
					closeLayerPopup();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>