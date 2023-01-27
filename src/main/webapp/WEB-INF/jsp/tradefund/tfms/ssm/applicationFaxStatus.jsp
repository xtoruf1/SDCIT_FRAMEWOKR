<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">

		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운</a>
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
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
				<th scope="row">기금융자 명</th>
				<td >
					<div class="field_set flex align_center">
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${svrMaxVo.svrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${svrMaxVo.title}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCoNmKor" name="searchCeoNmKor" value="<c:out value="${param.searchCoNmKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명" maxlength="200"  />
					</fieldset>
				</td>
            </tr>
            <tr>
				<th scope="row">발송 요청일자</th>
				<td>

					<div class="group_datepicker">
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchSendSt" name="searchSendSt" value="<c:out value="${searchSendSt}"/>" class="txt datepicker" placeholder="발송 요청일자 시작일" title="발송 요청일자 시작일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" onclick="clearPickerValue('searchSendSt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>

						<div class="spacing">~</div>

						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchSendEd" name="searchSendEd" value="<c:out value="${searchSendEd}"/>" class="txt datepicker" placeholder="발송 요청일자 종료일" title="발송 요청일자 종료일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyEndDate" value="" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" onclick="clearPickerValue('searchSendEd');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>


				</td>
				<th scope="row">발송상태</th>
				<td>
					<fieldset class="widget">
						<select id="searchSendStatus" name="searchSendStatus" class="form_select"  style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${COM006}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchSendStatus}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
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

		// 시작일 선택 이벤트
		datepickerById('searchSendSt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchSendEd', toDateSelectEvent);

		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchSendSt').val());

		if ($('#searchSendEd').val() != '') {
			if (startymd > Date.parse($('#searchSendEd').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchSendSt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchSendEd').val());

		if ($('#searchSendSt').val() != '') {
			if (endymd < Date.parse($('#searchSendSt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchSendEd').val('');

				return;
			}
		}
	}

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",        Type:"Seq",       Hidden:false,  Width:60,   Align:"Center",  SaveName:"no"           });
		ibHeader.addHeader({Header:"",         	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  SaveName:"chk"          });
		ibHeader.addHeader({Header:"번호",      	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"sendSeq",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"시스템키1",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"useAtt1",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"시스템키2",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"useAtt2",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"시스템키3",   	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"useAtt3",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업명",     	Type:"Text",      Hidden:false,  Width:250,  Align:"Left",    SaveName:"title",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    SaveName:"coNmKor",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"무역업번호",  	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"bsNo",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"구분",      	Type:"Combo",     Hidden:false,  Width:80,   Align:"Center",  SaveName:"sysType",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM010.detailcd}"/>", ComboText: "<c:out value="${saCOM010.detailnm}"/>" });
		ibHeader.addHeader({Header:"발송자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  SaveName:"sendUser",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"팩스번호",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  SaveName:"faxnum",      CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"순번",      	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"clientUid",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"개별여부",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"txType",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"전송타입",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"sendType",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"요청시간",    	Type:"Date",      Hidden:false,  Width:150,  Align:"Center",  SaveName:"sdate",       CalcLogic:"",   Format:"yyyy-MM-dd HH:mm:ss",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"도착시간",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"rdate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"완료시간",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"edate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"요청숫자",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"dcount",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"완료숫자",    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  SaveName:"ccount",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"발송상태",    	Type:"Combo",     Hidden:false,  Width:100,  Align:"Center",  SaveName:"procStatus",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM006.detailcd}"/>", ComboText: "<c:out value="${saCOM006.detailnm}"/>" });
		ibHeader.addHeader({Header:"오류내용",    	Type:"Combo",     Hidden:false,  Width:150,  Align:"Center",  SaveName:"errorCode",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM007.detailcd}"/>", ComboText: "<c:out value="${saCOM007.detailnm}"/>" });
		ibHeader.addHeader({Header:"문서번호",    	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  SaveName:"applyId",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"문서번호_암호",	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  SaveName:"applyIdPw",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "548px");
		ibHeader.initSheet(sheetId);

		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정

		sheet1.SetColFontBold("coNmKor", true);
		sheet1.SetDataLinkMouse("coNmKor", true);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;

		f.searchSvrId.value = "";
		f.searchTitle.value = "";

		f.searchCoNmKor.value = "";

		f.searchSendSt.value = "<c:out value="${searchSendSt}"/>";
		f.searchSendEd.value = "<c:out value="${searchSendEd}"/>";

		setSelect(f.searchSendStatus, "");
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectApplicationFaxStatusList.do" />'
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

	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				getList();
			}
		});
	}

	//추천서 팝업
	function goSendFax(Row){
	    var f = document.form1;

		var resultYn = 'N';
		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 780;
		nHeight = 550;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "/tfms/ssm/fundFaxSendPopup.do?";
		strUrl +=	 "&svrId="+sheet1.GetCellValue(Row, "useAtt1");
		strUrl +=	 "&applyId="+sheet1.GetCellValue(Row, "applyIdPw");

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');
	}

	//엑셀다운
	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, "팩스발송현황", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);
		if( colNm  == 'coNmKor'){
			goSendFax(Row);			//추천서 팝업
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		sheet1.ReNumberSeq("desc");
    }

</script>