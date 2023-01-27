<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${reserveVO.pageIndex}' default='1' />" />
<input type="hidden" id="bizAppSeq" name="bizAppSeq" />
<input type="hidden" id="location" name="location" />
<input type="hidden" id="useYmd" name="useYmd" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doReg()" class="btn_sm btn_primary bnt_modify_auth">신규</button>
		<button type="button" onclick="doDelete()" class="btn_sm btn_secondary bnt_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doClear()" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch()" class="btn_sm btn_primary">검색</button>
	</div>
</div>

<div class="cont_block"></div>

<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">예약일</th>
				<td colspan="5">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchStartDt" name="searchStartDt" value="<c:out value="${reserveVO.searchStartDt}"/>" class="txt datepicker" placeholder="시작일자" title="시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>
							<!-- clear 버튼 -->
 							<button type="button" onclick="clearPickerValue('searchStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchEndDt" name="searchEndDt" value="<c:out value="${reserveVO.searchEndDt}"/>" class="txt datepicker" placeholder="종료일자" title="종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyEndDate" value="" />
							</span>

							<!-- clear 버튼 -->
 							<button type="button" onclick="clearPickerValue('searchEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>

            </tr>
			<tr>
				<th scope="row">상태</th>
				<td>
					<fieldset class="widget">
						<select id="searchStatus" name="searchStatus" class="form_select" >
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${biz0003}" varStatus="status">
							<c:if test="${item.code ne '3'}">
								<option value="<c:out value="${item.code}"/>" <c:if test="${item.code eq reserveVO.searchStatus}">selected="selected"</c:if>><c:out value="${item.codeNm}"/></option>
							</c:if>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">회의실</th>
				<td>
					<fieldset class="widget">
					<select name="searchRoomNum" id="searchRoomNum" class="form_select">
						<option value="" >::: 전체 :::</option>
						<c:forEach var="item" items="${bizRoomList}" varStatus="status">
							<option value="<c:out value="${item.roomNumber}"/>" <c:if test="${item.roomNumber eq reserveVO.searchRoomNum}">selected="selected"</c:if>><c:out value="${item.roomNumber}"/>호</option>
						</c:forEach>
					</select>
					</fieldset>
				</td>
				<th scope="row">이용시간</th>
				<td>
					<fieldset class="widget">
						<select id="searchTime" name="searchTime" class="form_select" >
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${biz0005}" varStatus="status">
								<option value="<c:out value="${item.code}"/>" <c:if test="${item.code eq reserveVO.searchTime}">selected="selected"</c:if>><c:out value="${item.codeNm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
			<tr>
				<th scope="row">업체명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCompanyNm" name="searchCompanyNm" value="<c:out value="${reserveVO.searchCompanyNm}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="업체명" maxlength="30" />
					</fieldset>
				</td>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchMemberId" name="searchMemberId" value="<c:out value="${reserveVO.searchMemberId}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호" maxlength="30" />
					</fieldset>
				</td>
				<th scope="row">신청자</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchUserNm" name="searchUserNm" value="<c:out value="${reserveVO.searchUserNm}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="신청자" maxlength="30" />
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
		<fieldset class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="doDownloadExcel();">엑셀 다운</button>
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="<c:out value="${item.code}"/>" <c:if test="${reserveVO.pageUnit eq item.code}">selected="selected"</c:if>> <c:out value="${item.codeNm}"/></option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;" >
		<div id="sheet1" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</form>

<script type="text/javascript">
	var f = document.form1;

	$(document).ready(function () {
		sheet1_init();
		// 시작일 선택 이벤트
		datepickerById('searchStartDt', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('searchEndDt', toDateSelectEvent);
		getList(); // 조회

	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDt').val());
		if ($('#searchEndDt').val() != '') {
			if (startymd > Date.parse($('#searchEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDt').val());

		if ($('#searchStartDt').val() != '') {
			if (endymd < Date.parse($('#searchStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDt').val('');

				return;
			}
		}
	}

	function sheet1_init() {
	    var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header:"삭제"	,		Type:"DelCheck",	Hidden:false,	Edit:true,	Width:30,	Align:"Center",	SaveName:"delCheck",	HeaderCheck:false,	Cursor:"Pointer" });
	    ibHeader.addHeader({Header:"Status",		Type:"Status",		Hidden:true,	Edit:false,	Width:10,	Align:"Center",	SaveName:"status",	Cursor:"Pointer"	});
	    ibHeader.addHeader({Header:"seq",		    Type:"Text",		Hidden:true,	Edit:false,	Width:10,	Align:"Center",	SaveName:"bizAppSeq",	Cursor:"Pointer"	});
 	    ibHeader.addHeader({Header:"예약일",		Type:"Date",		Hidden:false,	Edit:false,	Width:80,	Align:"Center",	SaveName:"useYmd",	Format:"yyyy-MM-dd" ,	Cursor:"Pointer"});
	    ibHeader.addHeader({Header:"이용시간",		Type:"Text",    	Hidden:false,	Edit:false,	Width:80,	Align:"Center",	SaveName:"useTime",	Wrap:true , MultiLineText:true  ,	Cursor:"Pointer"});
	    ibHeader.addHeader({Header:"회의실위치",	Type:"Text",    	Hidden:false,	Edit:false,	Width:80,	Align:"Center",	SaveName:"locationStr",	Cursor:"Pointer"	});
	    ibHeader.addHeader({Header:"회의실위치",	Type:"Text",    	Hidden:true,	Edit:false,	Width:10,	Align:"Center",	SaveName:"location",	Cursor:"Pointer"	});
	    ibHeader.addHeader({Header:"회의실",	    Type:"Text",    	Hidden:false,	Edit:false,	Width:50,	Align:"Center",	SaveName:"roomNumber"	,	Cursor:"Pointer"});
 	    ibHeader.addHeader({Header:"사무기기 이용",	Type:"Text",    	Hidden:false,	Edit:false,	Width:80,	Align:"Center",	SaveName:"useOa"	,	Cursor:"Pointer"});
	    ibHeader.addHeader({Header:"업체명",		Type:"Text",    	Hidden:false,	Edit:false,	Width:200,	Align:"Left",	SaveName:"corpName",	Cursor:"Pointer"});
	    ibHeader.addHeader({Header:"신청자",		Type:"Text",    	Hidden:false,	Edit:false,	Width:100,	Align:"Center",	SaveName:"userNm" ,	Cursor:"Pointer"	});
	    ibHeader.addHeader({Header:"휴대전화",		Type:"Text",    	Hidden:false,	Edit:false,	Width:90,	Align:"Center",	SaveName:"mobileNo",	Format:"###-####-####" ,	Cursor:"Pointer" });
	    ibHeader.addHeader({Header:"신청일",		Type:"Date",    	Hidden:false,	Edit:false,	Width:80,	Align:"Center",	SaveName:"appYmdhms",	Format:"yyyy-MM-dd"	,	Cursor:"Pointer" });
	    ibHeader.addHeader({Header:"상태",			Type:"Text",    	Hidden:false,	Edit:false,	Width:50,	Align:"Center",	SaveName:"useStatusStr"	,	Cursor:"Pointer"});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck:false});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/reservation/searchList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				var newList =  data.resultList;
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$("#searchStartDt").val(data.reserveVO.searchStartDt);
				$("#searchEndDt").val(data.reserveVO.searchEndDt);

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				if ( data.resultCnt > 0){
					for( var i=0; data.resultList.length > i; i++){
						var resultList =  data.resultList[i].useTime;
						var addcnt = 0;

  							for( var n = 0; data.biz0001.length > n; n++ ) {
								var biz0001 = data.biz0001[n].codeKey;
								if ( resultList == null || resultList == "" ){
									addcnt ++;
									newList[i].useTime = "-";
								}else{
									if ( resultList.includes(biz0001) ){
										addcnt ++;
										if ( addcnt == 1 ){
											newList[i].useTime = data.biz0001[n].codeText;
										}else{
											newList[i].useTime = newList[i].useTime + "\r\n" + data.biz0001[n].codeText;
										}
									}
								}
							} // n
					} // i
				}

				sheet1.LoadSearchData({Data: newList}, {Wait: 0});
			}
		});
	}

	function doItemCodeChange() {
		$("#searchRoomNum option").remove();
		$("#searchRoomNum").append("<option value=''>::: 전체 :::</option>");
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/reservation/searchRoomNum.do" />'
			, data : { 'searchLocation' : $("#searchLocation").val() }
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if ( data.bizRoomList != null && data.bizRoomList.length > 0 ){
					selectBoxOption(data.bizRoomList);
				}
			}
		});
	}

	function selectBoxOption(opt) {
		for( var i = 0; opt.length > i; i++ ) {
			$("#searchRoomNum").append("<option value="+opt[i].roomNumber+">"+opt[i].roomNumber+" 호</option>");
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {

			var url = "/bizCenter/reservation/view.do";
			var bizAppSeq = sheet1.GetCellValue(row, "bizAppSeq");
			var location = sheet1.GetCellValue(row, "location");
			var useYmd = sheet1.GetCellValue(row, "useYmd");

			f.location.value = location;
			f.bizAppSeq.value = bizAppSeq;
			f.useYmd.value = useYmd;
			f.action = url;
			f.target = '_self';
			f.submit();
		}
	}


	function doSearch() {
		fromDateSelectEvent();
		toDateSelectEvent();
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	function doClear() {
		f.searchStartDt.value = "";
		f.searchEndDt.value = "";
		f.searchTime.value = "";
		f.searchStatus.value = "";
		f.searchLocation.value = "";
		f.searchRoomNum.value = "";
		f.searchCompanyNm.value = "";
		f.searchMemberId.value = "";
		f.searchUserNm.value = "";
		doSearch();
	}

	function doReg() {
		goMenu('/bizCenter/reservation/write.do', '_self');
	}
	function doDelete() {

		var deleteCnt = sheet1.FindCheckedRow('delCheck');

		if(deleteCnt <= 0) {
			alert('선택한 항목이 없습니다.');
			return;
		}

		var deleteData = sheet1.GetSaveJson();

		global.ajax({
			type : 'POST'
			, url : "/bizCenter/reservation/deleteCheckList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(deleteData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				getList();
			}
		});
	}

	function doDownloadExcel() {
		//var f = document.form1;
		f.action = '<c:url value="/bizCenter/reservation/reservationDataExcelList.do" />';
		f.method = 'post';
		f.target = '_self';
		f.submit();
		f.method = 'get';
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDt').val());

		if ($('#searchEndDt').val() != '') {
			if (startymd > Date.parse($('#searchEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDt').val('');

				return false;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDt').val());

		if ($('#searchStartDt').val() != '') {
			if (endymd < Date.parse($('#searchStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDt').val('');

				return false;
			}
		}
	}

</script>
