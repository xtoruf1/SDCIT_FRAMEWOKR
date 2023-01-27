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
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
		<!--검색 시작 -->
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
						<th scope="row">발송일자</th>
						<td colspan="3">
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchSendDmStart" name="searchSendDmStart" value="${todayDt}" class="txt datepicker"  title="발송일자 시작일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>

									<!-- clear 버튼 -->
		<%-- 							<button type="button" onclick="clearPickerValue('searchSendDmStart');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button> --%>
								</div>
								<div class="spacing">~</div>
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchSendDmEnd" name="searchSendDmEnd" value="${todayDt}" class="txt datepicker"  title="발송일자 종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>

									<!-- clear 버튼 -->
		<%-- 							<button type="button" onclick="clearPickerValue('searchLoanEd');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button> --%>
								</div>
							</div>
						</td>
						<th scope="row">발신자</th>
						<td >
							<fieldset class="widget">
								<input type="text" id="searchSendUserName" name="searchSendUserName" value="<c:out value="${param.searchSendUserName}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="발신자" maxlength="50" />
							</fieldset>
						</td>
		            </tr>
		            <tr>
						<th scope="row">전송분류</th>
						<td colspan="3">
							<select id="sendComCd" name="sendComCd"  class="form_select" style="width:30%; max-width: 100px;" required="required" title="구분" onchange="doCodeComSearch()"  >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${COM000}" varStatus="status">
									<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.sSendComCd}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
								</c:forEach>
							</select>
							<select id="msgGb" name="msgGb"  class="form_select" style="width:50%;" required="required" title="진행상태"  >
								<option value="" >::: 전체 :::</option>
							</select>

						</td>
						<th scope="row">수신자</th>
						<td >
							<fieldset class="widget">
								<input type="text" id="searchReceiveUserName" name="searchReceiveUserName" value="<c:out value="${param.searchReceiveUserName}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="수신자" maxlength="50" />
							</fieldset>
						</td>
		            </tr>
		            <tr>
						<th scope="row">무역업번호</th>
						<td>
							<fieldset class="widget">
								<input type="text" id="searchMemberId" name="searchMemberId" value="<c:out value="${param.searchMemberId}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호" maxlength="30" />
							</fieldset>
						</td>
						<th scope="row">업체명</th>
						<td>
							<fieldset class="widget">
								<input type="text" id="searchCompanyKor" name="searchCompanyKor" value="<c:out value="${param.searchCompanyKor}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="업체명" maxlength="100" />
							</fieldset>
						</td>
						<th scope="row">제목</th>
						<td >
							<fieldset class="widget">
								<input type="text" id="searchSendTitl" name="searchSendTitl" value="<c:out value="${param.searchSendTitl}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="제목"  maxlength="200" />
							</fieldset>
						</td>
		            </tr>
		            <tr>
						<th scope="row">발신구분</th>
						<td>
							<fieldset class="widget">
								<select id="searchSendType" name="searchSendType" class="form_select" style="max-width: 100px;" >
									<option value="" <c:if test="${'' eq param.searchSendType}">selected="selected"</c:if>>::: 전체 :::</option>
									<OPTION value='ALIMTALK'  <c:if test="${'ALIMTALK' eq param.searchSendType}">selected="selected"</c:if>>ALIMTALK</OPTION>
							     	<OPTION value='SMS'  <c:if test="${'SMS' eq param.searchSendType}">selected="selected"</c:if>>SMS</OPTION>
							     	<OPTION value='MMS'  <c:if test="${'MMS' eq param.searchSendType}">selected="selected"</c:if>>MMS</OPTION>
							     	<OPTION value='EMAIL' <c:if test="${'EMAIL' eq param.searchSendType}">selected="selected"</c:if>>EMAIL</OPTION>
								</select>
							</fieldset>
						</td>
						<th scope="row">지역본부</th>
						<td colspan="3">
							<fieldset class="widget">
								<select id="searchTradeDept" name="searchTradeDept" class="form_select"  <c:if test='${user.fundAuthType ne "ADMIN"}'>disabled="disabled"</c:if>  >
									<c:if test='${user.fundAuthType eq "ADMIN"}'>
									<option value="" >::: 전체 :::</option>
									</c:if>

									<c:forEach var="item" items="${COM001}" varStatus="status">
									<c:if test='${user.fundAuthType ne "ADMIN"}'>
										<c:if test="${item.chgCode01 eq user.fundDeptCd}">
											<option value="<c:out value="${item.chgCode01}"/>"<c:if test="${item.chgCode01 eq searchTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
										</c:if>
									</c:if>
									<c:if test='${user.fundAuthType eq "ADMIN"}'>
										<option value="<c:out value="${item.chgCode01}"/>"<c:if test="${item.chgCode01 eq searchTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
									</c:if>
									</c:forEach>
								</select>
							</fieldset>
						</td>
		            </tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>
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
<!-- 	<div id="paging" class="paging ibs"></div> -->
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

		ibHeader.addHeader({Header:"전송분류",    	Type:"Text",      Hidden:false,  Width:150,   Align:"Left",    ColMerge:1,   SaveName:"msgGb",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"발신구분",    	Type:"Text",      Hidden:false,  Width:80,    Align:"Center",  ColMerge:1,   SaveName:"sendType",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업번호",  	Type:"Text",      Hidden:false,  Width:130,   Align:"Left",    ColMerge:1,   SaveName:"memberId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:150,   Align:"Left",    ColMerge:1,   SaveName:"coNm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"제목",      	Type:"Text",      Hidden:false,  Width:250,   Align:"Left",    ColMerge:1,   SaveName:"sendTitl",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"수신자",     	Type:"Text",      Hidden:false,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"receiveUserName",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"수신자전화번호",Type:"Text",      Hidden:false,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"receiveUserTelNo", CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"수신자이메일", 	Type:"Text",      Hidden:false,  Width:200,   Align:"Left",    ColMerge:1,   SaveName:"receiveUserEmail", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"발신자",     	Type:"Text",      Hidden:false,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"sendUserName",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"발신자전화번호",Type:"Text",      Hidden:false,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"sendUserTelNo",    CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"발신자이메일", 	Type:"Text",      Hidden:false,  Width:200,   Align:"Left",    ColMerge:1,   SaveName:"sendUserEmail",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"발신일자",    	Type:"Text",      Hidden:false,  Width:200,   Align:"Center",  ColMerge:1,   SaveName:"creDate",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });
		ibHeader.addHeader({Header:"SEND_SEQ", 		Type:"Text",      Hidden:true,   Width:120,   Align:"Left",    ColMerge:1,   SaveName:"sendSeq",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:5, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "464px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정
		sheet1.SetColFontBold("sendTitl", true);
		sheet1.SetDataLinkMouse("sendTitl", true);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;

		f.searchSendDmStart.value = "<c:out value="${todayDt}"/>";
		f.searchSendDmEnd.value = "<c:out value="${todayDt}"/>";
		f.searchReceiveUserName.value = "";
		f.searchSendUserName.value = "";

		f.searchMemberId.value = "";
		f.searchCompanyKor.value = "";
		f.searchSendTitl.value = "";


		$('#msgGb').children().remove();
		var msgGbOption = '<option value="" >::: 전체 :::</option>';
		$("#msgGb").append(msgGbOption);

		setSelect(f.sendComCd, "");
		setSelect(f.searchSendType, "");
		$("#searchTradeDept option:eq(0)").prop("selected", true);
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/selectSendLogSearch.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//전송분류 : 구분 선택하면 진행상태 셀렉트 박스 값 가져오기
	function doCodeComSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendMsgPopupSearchComCode.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#msgGb').children().remove();

				var msgGbOption = "";

				msgGbOption = '<option value="" >::: 전체 :::</option>';
				for(var k in data.resultList){
					var obj = data.resultList[k];
					var detailcd = obj.detailcd;
					var detailnm = obj.detailnm;

					msgGbOption += "<option value='" + detailcd + "'>" + detailnm + "</option>";

				}
				$("#msgGb").append(msgGbOption);

			}
		});
	}

	//메일 제목 본문 확인
	function selectMailCont(val){
		var f = document.form1;

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/arm/applicationEmailSendDetailPopup.do" />'
			, params : {
				sendSeq : val
			}
			, callbackFunction : function(resultObj){
			}
		});

	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var colNm = sheet1.ColSaveName(Col);

	 	if( colNm == 'sendTitl' ){
	 		selectMailCont(sheet1.GetCellValue(Row, "sendSeq"));
	 	}

	}

</script>