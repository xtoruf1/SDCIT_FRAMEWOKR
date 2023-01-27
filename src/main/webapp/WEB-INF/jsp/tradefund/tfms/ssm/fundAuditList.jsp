<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="systemMenuId" 	name="systemMenuId" value="0" />
<input type="hidden" id="authId" 		name="authId" 		value="0" />

<input type="hidden" id="statusChk"  	name="statusChk"	value="" />
<input type="hidden" id="svrId"     	name="svrId"		value="" />
<input type="hidden" id="parentListPage" 	name="parentListPage"   value="/tfms/ssm/fundAuditList.do"/>

<input type="hidden" id="acctTypeId"    name="acctTypeId"	value="<c:out value="${user.fundAuthType}"/>" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
		<a href="javascript:downLoadExcel();" 	class="btn_sm btn_primary">엑셀다운</a>
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
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
						<input type="text" id="searchTitle" name="searchTitle" value="<c:out value="${param.searchTitle}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="기금융자명" />
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

		ibHeader.addHeader({Header:"No",            Type:"Seq",       Hidden:false,  Width:50,   Align:"Center",  SaveName:"no"               });
        ibHeader.addHeader({Header:"CHK",           Type:"Text",      Hidden:true,   Width:20,   Align:"Center",  SaveName:"chk"              });
        ibHeader.addHeader({Header:"기금융자코드",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"svrId",          CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"년도",           	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"bsnYear",        CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"☞기금융자명",     	Type:"Text",      Hidden:false,  Width:350,  Align:"Left",    SaveName:"title",          CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true , Ellipsis:true  });
        ibHeader.addHeader({Header:"융자세부내역",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bodyDesc",       CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"접수기간",        	Type:"Date",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"bsnDt",          CalcLogic:"",   Format:"yyyy-MM-dd",   PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"접수기간시작",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnStartDt",     CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"접수기간종료",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnEndDt",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"사업기간",        	Type:"Text",      Hidden:false,  Width:170,  Align:"Center",  SaveName:"bsnAplDt",       CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"사업기간_시작",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnAplStartDt",  CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"사업기간_종료",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnAplEndDt",    CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"업무시작예정일",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"procInitDt",     CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"KITANET 아이디",       	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regEmpId",       CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자성명",       	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"regEmpNm",       CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자부서코드",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regDeptCd",      CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자부서명",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regDeptNm",      CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자전화번호",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regTel",         CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자팩스번호",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regFax",         CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"담당자이메일",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"regEmail",       CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"첨부파일ID",      	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"attFileId",      CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"첨부파일건수",     	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fileCnt",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"융자1차지급월",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund1Mm",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"융자1차지급일",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund1Dd",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"융자2차지급월",    	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund2Mm",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"융자2차지급",      	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"fund2Dd",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"추천유효기간월",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"validMm",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"추천유효기간일",  	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"validDd",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"접수",           	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"svrCnt",         CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"선정",          	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"selectCnt",      CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"탈락",           	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"dropCnt",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"추천",           	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"sendCnt",        CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"진행상태",        	Type:"Combo",     Hidden:false,  Width:100,  Align:"Center",  SaveName:"st",             CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true , ComboCode: "<c:out value="${saLMS001.detailcd}"/>", ComboText: "<c:out value="${saLMS001.detailnm}"/>"   });
        ibHeader.addHeader({Header:"☞선정현황",       	Type:"Html",      Hidden:false,  Width:120,  Align:"Center",  SaveName:"rowView",        CalcLogic:"",   Format:"",          	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });
        ibHeader.addHeader({Header:"특별유공여부",     	Type:"Text",      Hidden:true,   Width:50,   Align:"Center",  SaveName:"speChk",         CalcLogic:"",   Format:"",            	PointCount:0,   UpdateEdit:false,   InsertEdit:true  });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);


// 		sheet1.SetColFontColor("title", "0000ff");

		sheet1.SetColFontBold("title", true);
		sheet1.SetColFontBold("rowView", true);

		sheet1.SetDataLinkMouse("title", true);
		sheet1.SetDataLinkMouse("rowView", true);

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
			, url : '<c:url value="/tfms/ssm/selectFundAuditList.do" />'
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


	//무역진흥자금 융자 상세 조회 팝업
	function goRegisteDetail(row){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundRegisteDetailPopup.do" />'	//tfms/lms/FundRegisteDetail.screen
			, params : {
				 svrId : sheet1.GetCellValue(row, "svrId")
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	//선정현황
	//신청업체선정-신청업체 화면 이동
	function goApplicationSelectList(Row){
	    var f = document.form1;
	    f.svrId.value = sheet1.GetCellValue(Row, "svrId");
		var url = '<c:url value="/fundAuditList/tfms/ssm/applicationSelectionList.do" />';

		f.action = url;
		f.target = "_self";
		f.method = "post";
		f.submit();
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);
		if(colNm == 'title'){
			goRegisteDetail(Row);
		}else if(colNm == 'rowView'){
// 			goDeadLineSet(Row);
			if(sheet1.GetCellValue(Row, "speChk") == "SP"){
				if($('#acctTypeId').val() == "ADMIN"){
					goApplicationSelectList(Row);
				}else{
					alert("특별융자는 확인 할 수 없습니다.");
				}
			}else{
				goApplicationSelectList(Row);
			}


		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			var html = sheet1.GetCellValue(i,'rowView');

			if(sheet1.GetCellValue(i, "rowView") == "View"){
				html = '<img src="<c:url value="/images/btn_delete.png" />" alt="" />  ' +html;
				sheet1.SetCellFontColor(i,"rowView",'#0000ff');
			}else{
				html = '<img src="<c:url value="/images/favicon.png" />" alt="" />  ' +html;
				sheet1.SetCellFontColor(i,"rowView",'#ff0000');
			}

			sheet1.SetCellValue(i, 'rowView', html);
		}
    }

</script>