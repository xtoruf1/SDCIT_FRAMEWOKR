<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form name="searchForm" id="searchForm" >
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<input type="hidden" name="searchState" id="searchState" />
	<input type="hidden" name="searchExpertRight" id="searchExpertRight" />
	<input type="hidden" name="searchLanguageRight" id="searchLanguageRight" />

	<%-- 첨부파일 --%>
	<input type="hidden" name="attachDocumId" value="<c:out value="${resultData.attachDocumId}"/>"/>
	<input type="hidden" name="attachSeqNo" value=""/>
	<input type="hidden" name="attachDocumFg" value=""/>
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<div class="page_tradesos">
	<!-- 검색 테이블 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col >
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">컨설턴트</th>
					<td>
						<input type="text" id="searchExpertId" name="searchExpertId" class="form_text w100p" value="<c:out value="${searchVO.searchExpertId}"/>" onkeypress="press(event);">
					</td>
					<th scope="row">언어</th>
					<td>
						<select id="searchLanguage" name="searchLanguage" class="form_select w100p">
							<option value="" selected="">선택하세요.</option>
							<c:forEach items="${languageList}" var="item" varStatus="status">
								<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchLanguage}">selected</c:if>><c:out value="${item.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- // 검색 테이블-->
	</div>
	<!-- 리스트 테이블 -->
	<div style="display: flex;justify-content: space-between;">
		<div style="width: 49%;" >
			<div id='tblGridSheet' style="padding-top: 10px;"></div>
		</div>
		<div style="width: 50%;">
		<div id='tblGrid2Sheet' style="padding-top: 10px;"></div>
		</div>
	</div>
</div> <!-- // .page_tradesos -->
</form>

<!-- 샘플 레이어 영역 -->
<div id="tongPopup" class="modal modal-pop"></div>
<div id="bunPopup" class="modal modal-pop"></div>

<form id="layerPopForm" name="layerPopForm" method="post">
	<input type="hidden" name="orderSeq"  value=""/>
	<input type="hidden" name="gubun" value=""/>
	<input type="hidden" name="companyId" value=""/>
	<input type="hidden" name="state" value=""/>
	<input type="hidden" name="tableGubun" value="A"/>
</form>

<script type="text/javascript">
	var f;
	$(document).ready(function(){
		f = document.searchForm;
		f_Init_tblGridSheet();
		f_Init_tblGrid2Sheet();

		getList();
	});

	// 컨설턴트 진행현황 목록
	function f_Init_tblGridSheet() {
		var	ibHeader = new IBHeader();

		 /** 리스트,헤더 옵션 */
    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 200, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, NoFocusMode: 0, Ellipsis: 1});
    	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 55, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트", 	SaveName: "expertNm", 		Align: "Left", 		Width: 190});
		ibHeader.addHeader({Type: "Text", Header: "배정중", 	    SaveName: "statecnt1", 		Align: "Center", 	Width: 80, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "진행중", 	    SaveName: "statecnt2", 		Align: "Center", 	Width: 80, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "확인요청", 	SaveName: "statecnt3", 		Align: "Center", 	Width: 80, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "수정중", 	    SaveName: "statecnt4", 		Align: "Center", 	Width: 80, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트ID", 	SaveName: "expertId",       Align: "Left",      Width: 0, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "번호", 		SaveName: "colLink",        Align: "Left",      Width: 0, Hidden:1});

        var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
        createIBSheet2(container, sheetId, "100%", "680px");
        ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetEditable(0);
	};

	// 컨설턴트 진행현황 상세 목록
	function f_Init_tblGrid2Sheet() {
		var	ibHeader = new IBHeader();

		 /** 리스트,헤더 옵션 */
    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, editable: false, ColResize: true, statusColHidden: true, NoFocusMode: 0, Ellipsis: 1});
    	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 55, Edit: false});
		ibHeader.addHeader({Type: "Text", Header: "업체명",    SaveName: "companyKor", Align: "Center", Width: 156 , Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "상담자",    SaveName: "memberNm", Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "서비스",    SaveName: "gubunNm", Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "언어", 	  SaveName: "languageNm", Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "상태", 	  SaveName: "stateNm", Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "신청일", 	  SaveName: "regstDt", Align: "Center", Width: 80,Format:"####-##-##"});
		ibHeader.addHeader({Type: "Text", Header: "orderseq", SaveName: "orderSeq", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트ID", SaveName: "expertId", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "업체ID",    SaveName: "companyId", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "서비스G",   SaveName: "gubun", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "언어G",     SaveName: "language", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "상태G", 	  SaveName: "state", Align: "Center", Width: 80, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "orderseq", SaveName: "orderSeq", Align: "Center", Width: 100, Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "번호",      SaveName: "colLink", Align: "Left", Width: 0, Hidden:1});

        var sheetId = "tblGrid2Sheet";
		var container = $("#"+sheetId)[0];
        createIBSheet2(container,sheetId, "100%", "680px");
        ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGrid2Sheet.SetEditable(0);

	};

	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblGridSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblGridSheet.SetColFontBold('statecnt1', 1);
			tblGridSheet.SetColFontBold('statecnt2', 1);
			tblGridSheet.SetColFontBold('statecnt3', 1);
			tblGridSheet.SetColFontBold('statecnt4', 1);
		}
	}

	function press(event) {
		if (event.keyCode==13) {
			getList(1);
		}
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	function getList(pageIndex){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/translation/translProgressAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet.LoadSearchData({Data: data.resultList});
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	function tblGridSheet_OnClick(Row, Col, Value) {

		var rowData = tblGridSheet.GetRowData( Row);
		console.log(rowData);
		$('#searchForm > #searchExpertRight').val(rowData['expertId']);

		console.log(Row + ":::::::::::::::" + Col);
		if(Row > 0 && Col >= 2){
			if(Col == "2"){ //배정중
				$('#searchForm > #searchState').val('B');
			}else if(Col == "3"){
				$('#searchForm > #searchState').val('C');
			}else if(Col == "4"){
				$('#searchForm > #searchState').val('D');
			}else if(Col == "5"){
				$('#searchForm > #searchState').val('X');
			}
			right_detail();
		}

	};

	// 진행현황 우측 상세
	function right_detail(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/translation/translProgressRightAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGrid2Sheet.SetColFontBold('companyKor', 1);
				tblGrid2Sheet.LoadSearchData({Data: data.rightResultList});
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	// 상세
	function tblGrid2Sheet_OnClick(Row, Col, Value) {
		var orderSeq = tblGrid2Sheet.GetCellValue(Row,"orderSeq");
		var gubun = tblGrid2Sheet.GetCellValue(Row, "gubun");
		var regstDt = tblGrid2Sheet.GetCellValue(Row, "regstDt");
		var state = tblGrid2Sheet.GetCellValue(Row, "state");
		var companyId = tblGrid2Sheet.GetCellValue(Row,"companyId");
		//var rowData = tblGrid2Sheet.GetRowData(Row);
		if(Row > 0 && Col == 1){
			if(gubun == "I"){ //통역
				tongDetail(orderSeq, gubun, state, companyId);
			}else{ //전화통역,번역
				bunDetail(orderSeq, gubun, regstDt, state, companyId);
			}
		}
	};

	function tblGridSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) {
		tblGrid2Sheet.SetFilterValue("colLink", tblGridSheet.GetCellValue(tblGridSheet.GetSelectRow(), "colLink"), 1);
	};
	function tblGrid2Sheet_OnSearchEnd(code) {
		tblGrid2Sheet.ShowFilterRow();
		tblGrid2Sheet.SetRowHidden(1, 1);
		tblGrid2Sheet.SetFilterValue("colLink", tblGridSheet.GetCellValue(tblGridSheet.GetSelectRow(), "colLink"), 1);
	};

	// 통역 레이어 팝업
	function tongDetail(orderSeq, gubun, state, companyId) {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/tradeSOS/translation/tongPopup.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
						targetPopup : 'tongPopup'
					  , orderSeq : orderSeq
					  , gubun : gubun
					  , state : state
				      , companyId : companyId
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
			}
		});
	}

	function bunDetail(orderSeq, gubun, regstDt, state, companyId) {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/tradeSOS/translation/bunPopup.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
						targetPopup : 'bunPopup'
					  , orderSeq : orderSeq
					  , gubun : gubun
					  , state : state
					  , regstDt : regstDt
				      , companyId : companyId
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
			}
		});
	}

	//첨부파일 다운로드
	function directFileDown(filePath, saveName, fileName) {
		document.searchForm.action = "/tradeSOS/com/fileDownload.do?filePath="+filePath+"&encSaveName="+saveName+"&encOrgName="+fileName;
		document.searchForm.target = "_self";
		document.searchForm.submit();
	}

</script>