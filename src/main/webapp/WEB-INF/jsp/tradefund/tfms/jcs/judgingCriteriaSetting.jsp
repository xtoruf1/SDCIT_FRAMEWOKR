<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="searchBaseMonth" name="searchBaseMonth" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="simsaYm" onclick="doYmInit();"      class="btn_sm btn_primary btn_modify_auth">심사기준일선택</button>
		<button type="button" id="btn_save" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</a>
	</div>

	<div class="ml-15">
		<button type="button" onclick="doClear();" 	class="btn_sm btn_secondary">초기화</a>
		<button type="button" id="btn_search" onclick="doSearch();"	class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기준년월</th>
				<td id="gijun">
					<fieldset class="widget">
						<select id="searchPriGbn" name="searchPriGbn" class="form_select" title="기금융자년도" style="width: 100px;">
							<c:forEach var="yymmList" items="${yymmList}" varStatus="status">
								<option value="<c:out value="${yymmList.searchPriGbn}"/>" <c:if test="${yymmList.searchPriGbn eq param.searchPriGbn}">selected="selected"</c:if>><c:out value="${yymmList.searchPriGbn}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
<!-- 		<div id="totalCnt" class="total_count"></div> -->
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">

	//조회 체크
	var loadchk = true;

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	$(document).on('change', '.changeCalender', function(e, a) {
		var changeDate = $(this).val();

		var year = changeDate.substring(0, 4);
		var month = changeDate.substring(5, 7);

		$('#searchBaseMonth').val(year + '-' + month + '-01');
		$('#selDate').val(year + '-' + month);

	});

	function setNowTime() {
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();

		if (month < 10) {
			month = '0' + month;
		}

		if (day < 10) {
			day = '0' + day;
		}

		$('#searchBaseMonth').val(year + '-' + month + '-' + day);
		$('#selDate').val(year + '-' + month);
	}
	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",           	Type:"Text",      Hidden:true,   Width:40,   Align:"Center",  ColMerge:1,   			SaveName:"no",           Wrap:1 });
		ibHeader.addHeader({Header:"상태",           	Type:"Status",    Hidden:true,   Width:20,   Align:"Center",  ColMerge:1,   			SaveName:"status",       Wrap:1 });
		ibHeader.addHeader({Header:"기준년월",       	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:1,   			SaveName:"priGbn",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"항목구분",       	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:1,   			SaveName:"scoreType",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"구분명",         	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:1,   			SaveName:"priNm",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"심사항목명",     	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:1,   			SaveName:"priGbnNm",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"심사세부항목명", 	Type:"Text",      Hidden:false,  Width:340,  Align:"Left",    ColMerge:1,   			SaveName:"scoreTypeNm",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:130,   Wrap:1 });
		ibHeader.addHeader({Header:"최대점수",       	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:0,  RowMerge: 0, SaveName:"maxScore",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"순번",           	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:0,  RowMerge: 0, SaveName:"seqNo",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"최소",           	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:0,   			SaveName:"basisStart",                 CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:9,     Wrap:1 });
		ibHeader.addHeader({Header:"최대",           	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:0,   			SaveName:"basisEnd",                   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,    Wrap:1 });
		ibHeader.addHeader({Header:"기준점수",       	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:0,  RowMerge: 0, SaveName:"basisScore",   KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:9,     Wrap:1 });
		ibHeader.addHeader({Header:"추가",           	Type:"Text",      Hidden:false,  Width:30,   Align:"Center",  ColMerge:0,   			SaveName:"addChk",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"삭제",           	Type:"Text",      Hidden:false,  Width:30,   Align:"Center",  ColMerge:0,   			SaveName:"delChk",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30,    Wrap:1 });
		ibHeader.addHeader({Header:"가중치",         	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:0,   			SaveName:"weightScore",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30,    Wrap:1 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		if (typeof sheet1 !== 'undefined' && typeof sheet1.Index !== 'undefined') {
			sheet1.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);

		sheet1.SetEditable(true);
	}

	function doSave(){
		var f = document.form1;
		var sheetObj = document.all.sheet1;

		var saveJson = sheet1.GetSaveJson();
		var ccf = getSaveDataSheetList('form1' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('수정된 데이타가 존재하지 않습니다.');
			return ;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/jcs/saveJudgingCriteriaSettingList.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				alert('저장되었습니다.');
				doSearch();
			}
		});

	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		loadchk =  true;

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/jcs/selectJudgingCriteriaSettingList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}


	/*셀변형*/
	function initCellType(){
		var sheetObj = sheet1;
		var rcnt = sheetObj.RowCount();

		var info = {};
		for(var i =1; i<=rcnt; i++){
			if(sheetObj.GetCellValue(i, "scoreType") == "351010"){
				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisEnd", info);
				info = {"ComboCode":"<c:out value="${saJCS001.detailcd}"/>","ComboText":"<c:out value="${saJCS001.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisEnd",     info);
				sheetObj.SetCellValue(i, "basisEnd", sheetObj.GetCellValue(i, "basisStart") ) ;

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisStart", info);
				info = {"ComboCode":"<c:out value="${saJCS001.detailcd}"/>","ComboText":"<c:out value="${saJCS001.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisStart",   info);
				sheetObj.SetCellValue(i, "basisStart", sheetObj.GetCellValue(i, "basisEnd") );

				sheetObj.SetRowMerge(i, true);

			}
			else if(sheetObj.GetCellValue(i, "scoreType") == "353020"){

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisEnd", info);

				info = {"ComboCode":"<c:out value="${saJCS002.detailcd}"/>","ComboText":"<c:out value="${saJCS002.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisEnd",     info);
				sheetObj.SetCellValue(i, "basisEnd", sheetObj.GetCellValue(i, "basisStart") );

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisStart", info);
				info = {"ComboCode":"<c:out value="${saJCS002.detailcd}"/>","ComboText":"<c:out value="${saJCS002.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisStart",     info);
				sheetObj.SetCellValue(i, "basisStart", sheetObj.GetCellValue(i, "basisEnd"));

				sheetObj.SetRowMerge(i, true);
			}
			else if(sheetObj.GetCellValue(i, "scoreType") == "901010"){

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisEnd", info);
				info = {"ComboCode":"<c:out value="${saJCS004.detailcd}"/>","ComboText":"<c:out value="${saJCS004.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisEnd",     info);
				sheetObj.SetCellValue(i, "basisEnd", sheetObj.GetCellValue(i, "basisStart"));

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisStart", info);
				info = {"ComboCode":"<c:out value="${saJCS004.detailcd}"/>","ComboText":"<c:out value="${saJCS004.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisStart",     info);
				sheetObj.SetCellValue(i, "basisStart", sheetObj.GetCellValue(i, "basisEnd"));

				sheetObj.SetRowMerge(i, true);
			}
			else if(sheetObj.GetCellValue(i, "scoreType") == "204010"){

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisEnd", info);
				info = {"ComboCode":"<c:out value="${saJCS005.detailcd}"/>","ComboText":"<c:out value="${saJCS005.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisEnd",     info);
				sheetObj.SetCellValue(i, "basisEnd", sheetObj.GetCellValue(i, "basisStart"));

				info = {Type:"Combo",Align:"Center", Format:"", PointCount:0, EditLen:30};
				sheetObj.InitCellProperty(i, "basisStart", info);
				info = {"ComboCode":"<c:out value="${saJCS005.detailcd}"/>","ComboText":"<c:out value="${saJCS005.detailnm}"/>"};
				sheetObj.CellComboItem(i, "basisStart",     info);
				sheetObj.SetCellValue(i, "basisStart", sheetObj.GetCellValue(i, "basisEnd"));

				sheetObj.SetRowMerge(i, true);
			}
		}
		loadchk = false;

		sheetObj.SetDataMerge(0); //데이터 영역에 대해서 셀 병합 처리를 한다, 기존 병합 정보를 지울지 여부
	}

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		var colNm = sheet1.ColSaveName(Col);
		if(colNm == 'basisStart' && !loadchk && sheet1.GetCellValue(Row, "basisStart") != sheet1.GetCellValue(Row, "basisEnd")){
			sheet1.SetCellValue(Row, "basisEnd", Value);
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(col);
		if(colNm == 'addChk'){			//

			var new_Row = sheet1.DataInsert();
			sheet1.SetCellValue(new_Row, "priGbn"		, sheet1.GetCellValue(row, "priGbn"));
			sheet1.SetCellValue(new_Row, "scoreType"	, sheet1.GetCellValue(row, "scoreType"));
			sheet1.SetCellValue(new_Row, "priNm"		, sheet1.GetCellValue(row, "priNm")) ;
			sheet1.SetCellValue(new_Row, "priGbnNm"		, sheet1.GetCellValue(row, "priGbnNm")) ;
			sheet1.SetCellValue(new_Row, "scoreTypeNm"	, sheet1.GetCellValue(row, "scoreTypeNm")) ;
			sheet1.SetCellValue(new_Row, "maxScore"		, sheet1.GetCellValue(row, "maxScore")) ;
			sheet1.SetCellValue(new_Row, "addChk"		, '+');
			sheet1.SetCellValue(new_Row, "delChk"		, '-');

			initCellType();

		}else if(colNm == 'delChk'){	//
			sheet1.SetRowHidden(row, true);
			sheet1.SetCellValue(row, "status", 'D');
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		initCellType();

		for(var i =1; i<=sheet1.RowCount(); i++){
			sheet1.SetCellValue(i, "status", '');
		}

    }

	function sheet1_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('sheet1', row);
	   // 편집시 컬럼 색깔 변경
	}

	//초기화
	function doClear(){
		var f = document.form1;
		$("#simsaYm").attr("onclick", "doYmInit()");
		$("#simsaYm").text("심사기준일선택");
		$("#btn_search").show();
		$("#btn_save").show();
		$("#gijun").show();
		$("#tmpDate").remove();
		f.searchPriGbn.options[0].selected = true;
	}

	function doYmInit(){
	var tmpStr =  ' <td id="tmpDate">';
		tmpStr += '		<div class="datepicker_box">'
		tmpStr += '			<span class="form_datepicker">'
		tmpStr += '				<input type="text" id="selDate" value="" class="txt monthpicker" title="수출실적기준" readonly="readonly" />';
		tmpStr += '				<img src="/images/icon_calender.png" onclick="showMonthpicker(\'selDate\');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />'
		tmpStr += '			</span>'
		tmpStr += '		<button type="button" onclick="clearPickerValue(\'selDate\');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>'
		tmpStr += '		</div>'
		tmpStr += '	</td> ';

		$("#simsaYm").attr("onclick", "doMake()");
		$("#simsaYm").text("심사기준생성");
		$("#btn_search").hide();
		$("#btn_save").hide();
		$(".formTable tbody tr").append(tmpStr);
		setNowTime();
		$("#gijun").hide();

// 이전 심사기준 항목을 중복 없이 모두 가져온다.
/* 		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/jcs/makeCheckboxSetting.do" />'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				if ( data.resultCnt > 0 ){

					for (var i = 0; i < data.resultCnt; i++) {
						var itemScoreType = data.resultList[i].scoreType;
						var itemPriNm = data.resultList[i].priNm;
						var itemScoreTypeNm = data.resultList[i].scoreTypeNm;
						var tmpInput = '<label for="'+itemScoreType+'"><input type="checkbox" id="'+itemScoreType+'" name="item" data1="'+itemPriNm+'" data2="'+itemScoreTypeNm+'"> '+itemPriNm+' - '+itemScoreTypeNm+' </label>'
						var tmpStr = '<tr id="add_'+i+'"></tr>'
						$("#tmpDate").append(tmpStr);
						$("#add_"+i).append(tmpInput);
					}
				}
			}
		}); */

		changeSelectDate();
	}

	function changeSelectDate() {
		$('#searchBaseMonth').val($('#selDate').val());

		$('.monthpicker').datepicker('destroy');
		$('.monthpicker').monthpicker({
			pattern: 'yyyy-mm'
			, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
		});

	}

	function doMake() {

		if (confirm('선택한 기준년월에 대한 심사기준을 생성하시겠습니까?\n\n 마지막 심사기준에 해당하는 심사기준을 생성 합니다.')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tfms/jcs/saveJudgingCriteriaSettingMake.do" />'
				, dataType : 'json'
				, data :  { "searchPriGbn" : $("#selDate").val() }
				, async: true
				, spinner : true
				, success : function(data){
					if (data.result) {
						alert('새로운 심사기준을 생성하였습니다.');
						window.location.reload(true);

					} else {
						alert(data.message);

						return false;
					}
				}
			});
		}
	}

	function doDelete() {
		if (confirm('해당 심사기준년월 데이터를 삭제 합니다.')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tfms/jcs/deleteJudgingCriteriaSetting.do" />'
				, dataType : 'json'
				, data :  { searchPriGbn : $("#searchPriGbn").val() }
				, async: true
				, spinner : true
				, success : function(data){
					if (data.result) {
						window.location.reload(true);
					} else {
						alert(data.message);
						return false;
					}
				}
			});
		}
	}
</script>