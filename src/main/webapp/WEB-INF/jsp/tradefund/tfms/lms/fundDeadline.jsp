<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" 	name="systemMenuId" value="0" />
<input type="hidden" id="authId" 		name="authId" 		value="0" />

<input type="hidden" id="statusChk"  		name="statusChk"		value="" />
<input type="hidden" id="searchSvrId"     	name="searchSvrId"			value="" />
<input type="hidden" id=searchKeyword   	name="searchKeyword"			value="" />
<input type="hidden" id="parentListPage" 	name="parentListPage"   value="/tfms/lms/fundDeadline.do"/>
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 	class="btn_sm btn_primary">엑셀 다운</a>
	</div>
	<div class="ml-15">
		<a href="javascript:doClear();" 	class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 	class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

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
				<th scope="row">기금융자년도</th>
				<td>
					<fieldset class="widget">
						<select id="searchYear" name="searchYear" class="form_select" title="기금융자년도" style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="yearList" items="${YEAR_LIST}" varStatus="status">
								<option value="<c:out value="${yearList.searchYear}"/>" <c:if test="${yearList.searchYear eq param.searchYear}">selected="selected"</c:if>><c:out value="${yearList.searchYear}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">기금융자명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchTitle" name="searchTitle" value="<c:out value="${param.searchTitle}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="기금융자명" maxlength="150" />
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
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">


	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",         	Type:"Int",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"rn"              });
		ibHeader.addHeader({Header:"No",         	Type:"Seq",       Hidden:true,  Width:60,   Align:"Center",  SaveName:"no"              });
		ibHeader.addHeader({Header:"CHK",           Type:"Text",      Hidden:true,   Width:20,   Align:"Center",  SaveName:"chk"             });
		ibHeader.addHeader({Header:"기금융자코드",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"svrId",          CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"년도",           	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"bsnYear",        CalcLogic:"",   Format:"",   			PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"☞기금융자명",    	Type:"Text",      Hidden:false,  Width:300,  Align:"Left",    SaveName:"title",          CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"융자세부내역",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bodyDesc",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간",        	Type:"Date",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"bsnDt",          CalcLogic:"",   Format:"yyyy-MM-dd",   PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간시작",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnStartDt",     CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수기간종료",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnEndDt",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업기간",        	Type:"Text",      Hidden:false,  Width:200,  Align:"Center",  SaveName:"bsnAplDt",       CalcLogic:"",   Format:"",   			PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업기간_시작",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnAplStartDt",  CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업기간_종료",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnAplEndDt",    CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"업무시작예정일",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"procInitDt",     CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"KITANET 아이디",    Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regEmpId",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자성명",      	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"regEmpNm",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자부서코드",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regDeptCd",      CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자부서명",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regDeptNm",      CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자전화번호",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regTel",         CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자팩스번호",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regFax",         CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자이메일",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regEmail",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"첨부파일ID",      	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"attFileId",      CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"첨부파일건수",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fileCnt",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자1차지급월",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund1Mm",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자1차지급일",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund1Dd",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자2차지급월",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund2Mm",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자2차지급",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund2Dd",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천유효기간월",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"validMm",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"☞신청현황",      	Type:"Int",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"svrCnt",         CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"진행상태",        	Type:"Combo",     Hidden:false,  Width:100,  Align:"Center",  SaveName:"st",             CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saLMS001.detailcd}"/>", ComboText: "<c:out value="${saLMS001.detailnm}"/>"  });
		ibHeader.addHeader({Header:"☞마감현황",      	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"rowView",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"파일리스트",      	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"attFileList",    CalcLogic:"",   Format:"",        	 	PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4,MouseHoverMode: 2, NoFocusMode : 0, UseHeaderSortCancel: 1, MaxSort: 1 });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		if (typeof sheet1 !== 'undefined' && typeof sheet1.Index !== 'undefined') {
			sheet1.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

		sheet1.SetColFontBold("title", true);
		sheet1.SetColFontBold("svrCnt", true);
		sheet1.SetColFontBold("rowView", true);

		sheet1.SetDataLinkMouse("title", true);
		sheet1.SetDataLinkMouse("svrCnt", true);
		sheet1.SetDataLinkMouse("rowView", true);

	}
	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
		sheet1.SetScrollTop(0);
		}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchTitle.value = "";
		f.searchYear.options[0].selected = true;
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/lms/selectFundDeadlineList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}


	//무역진흥자금 융자 상세 조회 팝업
	function goRegisteDetail(row){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundRegisteDetailPopup.do" />'
			, params : {
				 svrId : sheet1.GetCellValue(row, "svrId")
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	//신청업체선정-신청업체 화면 이동
	function goApplicationSelectList(Row){
	    var f = document.form1;
	    f.searchSvrId.value = sheet1.GetCellValue(Row, "svrId");
	    f.searchKeyword.value = "pass";

		var url = '<c:url value="/tfms/ssm/applicationSelectionList.do" />';

		f.action = url;
		f.target = "_self";
		f.method = "post";
		f.submit();
	}

	//KITA무역진흥자금 융자 접수 마감
	function goDeadLineSet(row){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundDeadlineSetPopup.do" />'
			, params : {
				 svrId : sheet1.GetCellValue(row, "svrId")
			   , title : sheet1.GetCellValue(row, "title")
			}
			, callbackFunction : function(resultObj){
				if ( resultObj == "close"){
					goMenu('/tfms/lms/fundDeadline.do', '_self');
				}
			}
		});
	}


	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, "기금융자마감_리스트", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }

	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(col);
		if(colNm == 'title'){			//기금융자명
			goRegisteDetail(row);
		}else if(colNm == 'svrCnt'){	//신청현황
			goApplicationSelectList(row);
		}else if(colNm == 'rowView'){	//마감현황
			goDeadLineSet(row);
		}
	}

 	function sheet1_OnRowSearchEnd(row) {
 		if ( row > 0) {
 			var index = sheet1.GetCellValue(row, "no");
 			var resultCnt = $('#resultCnt').val();
 			sheet1.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
 		}
	}

	function sheet1_OnSearchEnd(code, msg) {

		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			var html = sheet1.GetCellValue(i,'rowView');
		}
    }

</script>