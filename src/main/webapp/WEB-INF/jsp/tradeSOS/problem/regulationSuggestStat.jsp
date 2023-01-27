<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	/**
	 * @Class Name : problSuggestStat.jsp
	 * @Description : 에로사항 건의 통계화면
	 * @Modification Information
	 * @
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2021.09.29	양지환		최초 생성
	 *
	 * @author 양지환
	 * @since 2021.09.29
	 * @version 1.0
	 * @see
	 *
	 */
%>

<script type="text/javascript">

	// 탭메뉴
	jQuery().ready(function(){
		$('.tab_cont').hide();
		$('.tabGroup .tab').click(function(e){
			e.preventDefault();
			$('.tab_cont').hide();
			$('.tabGroup .tab').removeClass('selected');
			$(this).addClass('on');
			$($('.tab_cont')[$(this).index()]).show();
			if ($(this).index() == 0){
				getFieldList();
			}else if ($(this).index() == 1){
				getRouteList();
			}else if ($(this).index() == 2){
				getAreaList();
			}else if ($(this).index() == 3){
				getCompanyList();
			}
		}).first().trigger('click');
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDate').val());

		if ($('#searchEndDate').val() != '') {
			if (startymd > Date.parse($('#searchEndDate').val())) {
				alert('시작월은 종료월 이전이어야 합니다.');
				$('#searchStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDate').val());

		if ($('#searchStartDate').val() != '') {
			if (endymd < Date.parse($('#searchStartDate').val())) {
				alert('종료월은 시작월 이후여야 합니다.');
				$('#searchEndDate').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent1() {
		var startymd = Date.parse($('#searchStartDate1').val());

		if ($('#searchEndDate1').val() != '') {
			if (startymd > Date.parse($('#searchEndDate1').val())) {
				alert('시작월은 종료월 이전이어야 합니다.');
				$('#searchStartDate1').val('');

				return;
			}
		}
	}

	function toDateSelectEvent1() {
		var endymd = Date.parse($('#searchEndDate1').val());

		if ($('#searchStartDate1').val() != '') {
			if (endymd < Date.parse($('#searchStartDate1').val())) {
				alert('종료월은 시작월 이후여야 합니다.');
				$('#searchEndDate1').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent2() {
		var startymd = Date.parse($('#searchStartDate2').val());

		if ($('#searchEndDate2').val() != '') {
			if (startymd > Date.parse($('#searchEndDate2').val())) {
				alert('시작월은 종료월 이전이어야 합니다.');
				$('#searchStartDate2').val('');

				return;
			}
		}
	}

	function toDateSelectEvent2() {
		var endymd = Date.parse($('#searchEndDate2').val());

		if ($('#searchStartDate2').val() != '') {
			if (endymd < Date.parse($('#searchStartDate2').val())) {
				alert('종료월은 시작월 이후여야 합니다.');
				$('#searchEndDate2').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent3() {
		var startymd = Date.parse($('#searchStartDate3').val());

		if ($('#searchEndDate3').val() != '') {
			if (startymd > Date.parse($('#searchEndDate3').val())) {
				alert('시작월은 종료월 이전이어야 합니다.');
				$('#searchStartDate3').val('');

				return;
			}
		}
	}

	function toDateSelectEvent3() {
		var endymd = Date.parse($('#searchEndDate3').val());

		if ($('#searchStartDate3').val() != '') {
			if (endymd < Date.parse($('#searchStartDate3').val())) {
				alert('종료월은 시작월 이후여야 합니다.');
				$('#searchEndDate3').val('');

				return;
			}
		}
	}
</script>
<!-- 무역애로사항 건의 - 통계 -->
<div class="page_tradesos">
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->

		<div class="btnGroup ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload()">엑셀 다운</button>
			<button type="button" class="btn_sm btn_secondary" onclick="location.reload();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch()">검색</button>
		</div>
	</div>
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab on"  value="field">분야별</button>
			<button class="tab" 	value="route">경로별</button>
			<button class="tab" 	value="area">지역별</button>
			<button class="tab" 	value="company">업체별</button>
		</div>
		<div class="tab_body">
			<div class="tab_cont on">
				<form id="fieldSearchForm" name="fieldSearchForm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchStartDate" name="searchStartDate" data-start-year="2010" value="<c:out value="${vo.rec_date_from_year}-${vo.rec_date_from_month}"/>" onchange="fromDateSelectEvent();" class="txt monthpicker" placeholder="시작월" title="시작월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchStartDate');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_from_year" name="rec_date_from_year"/>
										<input type="hidden" id="rec_date_from_month" name="rec_date_from_month"/>
									</div>

									<div class="spacing">~</div>

									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchEndDate" name="searchEndDate" data-start-year="2010" value="<c:out value="${vo.rec_date_to_year}-${vo.rec_date_to_month}"/>" onchange="toDateSelectEvent();" class="txt monthpicker" placeholder="종료월" title="종료월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchEndDate');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_to_year" name="rec_date_to_year"/>
										<input type="hidden" id="rec_date_to_month" name="rec_date_to_month"/>
									</div>
								</div>
							</td>
							<th scope="row">분야</th>
							<td>

								<select name="req_cat_hight" id="req_cat_hight" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="data" items="${codeRgf}" varStatus="status">
										<option value="<c:out value="${data.cdId}"/>"><c:out value="${data.cdNm}"/></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div class="tbl_scrollx">
					<div id='fieldTblSheet' class="colPosi mt-20" style="width: 100%; height: 590px; display: block;"></div>
				</div>
				<!-- <div id='tblGrid' class="colPosi"></div> -->
			</div> <!-- // 분야별 통계 -->
			<div class="tab_cont">
				<form id="routeSearchForm" name="routeSearchForm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchStartDate1" name="searchStartDate" data-start-year="2010" value="<c:out value="${vo.rec_date_from_year}-${vo.rec_date_from_month}"/>" onchange="fromDateSelectEvent1();" class="txt monthpicker" placeholder="시작월" title="시작월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchStartDate1');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_from_year1" name="rec_date_from_year"/>
										<input type="hidden" id="rec_date_from_month1" name="rec_date_from_month"/>
									</div>

									<div class="spacing">~</div>

									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchEndDate1" name="searchEndDate" data-start-year="2010" value="<c:out value="${vo.rec_date_to_year}-${vo.rec_date_to_month}"/>" onchange="toDateSelectEvent1();" class="txt monthpicker" placeholder="종료월" title="종료월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchEndDate1');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_to_year1" name="rec_date_to_year"/>
										<input type="hidden" id="rec_date_to_month1" name="rec_date_to_month"/>
									</div>
								</div>
							</td>
							<th scope="row">경로</th>
							<td>
								<select name="req_channel" id="req_channel" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="data" items="${code110}" varStatus="status">
										<option value="<c:out value="${data.cdId}"/>"><c:out value="${data.cdNm}"/></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div class="tbl_scrollx">
					<div id='routeTblSheet' class="colPosi mt-20" style="width: 100%; height: 590px; display: block;"></div>
				</div>
			</div><!-- // 경로별 통계 -->
			<div class="tab_cont">
				<form id="areaSearchForm" name="areaSearchForm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchStartDate2" name="searchStartDate" data-start-year="2010" value="<c:out value="${vo.rec_date_from_year}-${vo.rec_date_from_month}"/>" onchange="fromDateSelectEvent2();" class="txt monthpicker" placeholder="시작월" title="시작월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchStartDate2');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_from_year2" name="rec_date_from_year"/>
										<input type="hidden" id="rec_date_from_month2" name="rec_date_from_month"/>
									</div>

									<div class="spacing">~</div>

									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchEndDate2" name="searchEndDate" data-start-year="2010" value="<c:out value="${vo.rec_date_to_year}-${vo.rec_date_to_month}"/>" onchange="toDateSelectEvent2();" class="txt monthpicker" placeholder="종료월" title="종료월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchEndDate2');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_to_year2" name="rec_date_to_year"/>
										<input type="hidden" id="rec_date_to_month2" name="rec_date_to_month"/>
									</div>
								</div>
							</td>
							<th scope="row">지역</th>
							<td>
								<select name="req_area" id="req_area" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="data" items="${code120}" varStatus="status">
										<option value="<c:out value="${data.cdId}"/>"><c:out value="${data.cdNm}"/></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div class="tbl_scrollx">
					<div id='areaTblSheet' class="colPosi mt-20" style="width: 100%; height: 590px; display: block;"></div>
				</div>
			</div><!-- // 지역별 통계 -->
			<div class="tab_cont">
				<form id="companySearchForm" name="companySearchForm" onsubmit="return false;">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchStartDate3" name="searchStartDate" data-start-year="2010" value="<c:out value="${vo.rec_date_from_year}-${vo.rec_date_from_month}"/>" onchange="fromDateSelectEvent3();" class="txt monthpicker" placeholder="시작월" title="시작월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchStartDate3');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_from_year3" name="rec_date_from_year"/>
										<input type="hidden" id="rec_date_from_month3" name="rec_date_from_month"/>
									</div>

									<div class="spacing">~</div>

									<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="searchEndDate3" name="searchEndDate" data-start-year="2010" value="<c:out value="${vo.rec_date_to_year}-${vo.rec_date_to_month}"/>" onchange="toDateSelectEvent3();" class="txt monthpicker" placeholder="종료월" title="종료월" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchEndDate3');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
											</span>
										<input type="hidden" id="rec_date_to_year3" name="rec_date_to_year"/>
										<input type="hidden" id="rec_date_to_month3" name="rec_date_to_month"/>
									</div>
								</div>
							</td>
							<th scope="row">업체명</th>
							<td>
								<input type="text" id="compny_nm" name="compny_nm" class="form_text w100p">
							</td>
						</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div id='companyTblSheet' class="colPosi mt-20" style="width: 100%; height: 590px; display: block;"></div>
			</div><!-- // 업체별 통계 -->
		</div>
	</div>
</div>

<script type="text/javascript">
	// $(document).ready(function()
	// {
	// 	// 시작일 선택 이벤트
	// 	datepickerById('searchStartDate', searchStartDateSelectEvent);
	//
	// 	// 종료일 선택 이벤트
	// 	datepickerById('searchEndDate', searchEndDateSelectEvent);
	// });
	//
	// function searchStartDateSelectEvent() {
	// 	var startymd = Date.parse($('input[name=searchStartDate]').val());
	//
	// 	if ($('input[name=searchEndDate]').val() != '') {
	// 		if (startymd > Date.parse($('input[name=searchEndDate]').val())) {
	// 			alert('시작일은 종료일 이전이어야 합니다.');
	// 			return;
	// 		}
	// 	}
	// }
	//
	// function searchEndDateSelectEvent() {
	// 	var endymd = Date.parse($('input[name=searchEndDate]').val());
	//
	// 	if ($('input[name=searchStartDate]').val() != '') {
	// 		if (endymd < Date.parse($('input[name=searchStartDate]').val())) {
	// 			alert('종료일은 시작일 이후여야 합니다.');
	// 			return;
	// 		}
	// 	}
	// }

	//선택 탭의 따른 검색
	function doSearch(){
		var gubun = $('[class*="tab on"]').val();   //선택한 탭의 값
		if (gubun == 'field'){
			getFieldList();
		}else if (gubun == 'route'){
			getRouteList();
		}else if (gubun == 'area'){
			getAreaList();
		}else if (gubun == 'company'){
			getCompanyList();
		}
	}

	// /**
	//  * 날짜 세팅 함수
	//  */
	//  function setDate(){
	// 	var startDate = $('#searchStartDate').val();
	// 	var endDate = $('#searchEndDate').val();
	//
	// 	var startArr = startDate.split("-");
	// 	var endArr = endDate.split("-");
	//
	// 	$('#rec_date_from_year').val(startArr[0]);
	// 	$('#rec_date_from_month').val(startArr[1]);
	// 	$('#rec_date_to_year').val(endArr[0]);
	// 	$('#rec_date_to_month').val(endArr[1]);
	//  }

	/**
	 * 분야별 통계 리스트 가져오기
	 */
	function getFieldList(){
		var startDate = $('#searchStartDate').val();
		var endDate = $('#searchEndDate').val();

		var startArr = startDate.split("-");
		var endArr = endDate.split("-");

		$('#rec_date_from_year').val(startArr[0]);
		$('#rec_date_from_month').val(startArr[1]);
		$('#rec_date_to_year').val(endArr[0]);
		$('#rec_date_to_month').val(endArr[1]);

		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/regulationFreeSuggestStatFieldListAjax.do",
			data:$('#fieldSearchForm').serializeArray(),
			async:false,
			success:function(data){
				setFiledGrid(data)

			}
		});
	}

	/**
	 * 분야별 통계 그리드 생성
	 * @param data
	 */
	function setFiledGrid(data){
		var resultList = data.result.resultList;
		var yearCnt = data.result.yearCnt;
		var rec_date_from_year = data.result.rec_date_from_year;
		var rec_date_from_month = data.result.rec_date_from_month;
		var rec_date_to_year = data.result.rec_date_to_year;
		var rec_date_to_month = data.result.rec_date_to_month;

		if (typeof fieldTblSheet !== "undefined" && typeof fieldTblSheet.Index !== "undefined") {
			fieldTblSheet.DisposeSheet();
		}

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',ColResize: true,SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, MergeSheet:5});
		ibHeader.setHeaderMode({Sort: 0, ColMove: true});

		ibHeader.addHeader({Type: "Text"	, Header: "No|No", SaveName: "rnum", 	Align: "Center", 	Width: 65, 	Edit: false });
		ibHeader.addHeader({Type: "Text"	, Header: "분야|분야", SaveName: "REQ_CHANNEL", 	Align: "Center", 	Width: 120, 	Edit: false });


		var headerData = '';
		for (var i = 0 ; i <yearCnt; i++){
			if (yearCnt == 1){
				headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_to_year+"."+rec_date_to_month;
			}else if (yearCnt == 2){
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else{
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}
			}else{
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else if(i == yearCnt-1){
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}else{
					headerData = (parseInt(rec_date_from_year)+i)+".01 ~ "+(parseInt(rec_date_from_year)+i)+".12";
				}
			}
			// width 재설정
			var sWidth = Math.floor(200/yearCnt);
			if (sWidth < 100 ) {
				sWidth = 100;
			}

			ibHeader.addHeader({Type: "Text", Header: headerData+"|대정부건의"			 ,  SaveName: "cnt0"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|지자체 / \n 유관기관건의", 	SaveName: "cnt1"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|미건의"				 ,	SaveName: "cnt2"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|전체"					 ,	SaveName: "cnt3"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|비중%"				 , 	SaveName: "cnt4"+i, 	Align: "Center", Width: sWidth });
		}

		var sheetId = "fieldTblSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "590px");
		ibHeader.initSheet(sheetId);

		fieldTblSheet.LoadSearchData({Data: data.result.resultList});
	}

	// 하단 합계
	function fieldTblSheet_OnSearchEnd(Row, Col, Rows, Cols, Align) {
		var yearCnt = parseInt($("#fieldSearchForm input[name=rec_date_to_year]").val())-parseInt($("#fieldSearchForm input[name=rec_date_from_year]").val());
		var sumData = fieldTblSheet.GetRowData(fieldTblSheet.GetDataLastRow());
		var totalData = new Object();
		totalData.rnum = "합계";
		var cnt0Per = 0;
		var cnt1Per = 0;
		var cnt2Per = 0;
		for (var i = 0 ; i <= yearCnt; i++){
			cnt0Per =setRound(getNum((parseInt(sumData["cnt0"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt1Per =setRound(getNum((parseInt(sumData["cnt1"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt2Per =setRound(getNum((parseInt(sumData["cnt2"+i])/parseInt(sumData["cnt3"+i])) * 100));

			totalData["cnt0"+i] = sumData["cnt0"+i]+" ("+cnt0Per+"%)";
			totalData["cnt1"+i] = sumData["cnt1"+i]+" ("+cnt1Per+"%)";
			totalData["cnt2"+i] = sumData["cnt2"+i]+" ("+cnt2Per+"%)";
			totalData["cnt3"+i] = sumData["cnt3"+i];

			if( sumData["cnt4"+i] == '0%' ) {
				totalData["cnt4"+i] = '0%';
			}else {
				totalData["cnt4"+i] = '100%';
			}

		}

		fieldTblSheet.SetDataFontColor("black");
		fieldTblSheet.SetRowBackColor(fieldTblSheet.GetDataLastRow(), '#DCDCDC');
		fieldTblSheet.SetRowData(fieldTblSheet.GetDataLastRow(), totalData);

		// 합계 Merge
		fieldTblSheet.SetMergeCell(fieldTblSheet.GetDataLastRow(), 0, 1, 2); 		// 합계 Merge (Row Index, Column Index, Row 개수, 머지할 셀의 Col 개수)
		fieldTblSheet.SetCellAlign(fieldTblSheet.GetDataLastRow(), 1, "Center");	// 합계 Align (Row Index, Column Index, 정렬값)

		//합계행 Bold
		var sumRow = fieldTblSheet.GetDataLastRow();
		fieldTblSheet.SetCellFont('FontBold', sumRow,0,sumRow,fieldTblSheet.LastCol(),1);
	};


	/**
	 * 경로별 통계 리스트 가져오기
	 */
	function getRouteList(){
		var startDate = $('#searchStartDate1').val();
		var endDate = $('#searchEndDate1').val();

		var startArr = startDate.split("-");
		var endArr = endDate.split("-");

		$('#rec_date_from_year1').val(startArr[0]);
		$('#rec_date_from_month1').val(startArr[1]);
		$('#rec_date_to_year1').val(endArr[0]);
		$('#rec_date_to_month1').val(endArr[1]);

		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/regulationFreeSuggestStatRouteListAjax.do",
			data:$('#routeSearchForm').serializeArray(),
			async:false,
			success:function(data){
				setRouteGrid(data)
			}
		});
	}

	/**
	 * 경로별 통계 그리드 생성
	 * @param data
	 */
	function setRouteGrid(data){
		if (typeof routeTblSheet !== "undefined" && typeof routeTblSheet.Index !== "undefined") {
			routeTblSheet.DisposeSheet();
		}
		var resultList = data.result.resultList;
		var yearCnt = data.result.yearCnt;
		var rec_date_from_year = data.result.rec_date_from_year;
		var rec_date_from_month = data.result.rec_date_from_month;
		var rec_date_to_year = data.result.rec_date_to_year;
		var rec_date_to_month = data.result.rec_date_to_month;

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',ColResize: true,SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, MergeSheet:5});
		ibHeader.setHeaderMode({Sort: 0, ColMove: true});

		ibHeader.addHeader({Type: "Text"	, Header: "번호|번호", SaveName: "rnum", 	Align: "Center", 	Width: 80, 	Edit: false });
		ibHeader.addHeader({Type: "Text"	, Header: "경로|경로", SaveName: "REQ_CHANNEL", 	Align: "Center", 	Width: 200, 	Edit: false });


		var headerData = '';
		for (var i = 0 ; i <yearCnt; i++){
			if (yearCnt == 1){
				headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_to_year+"."+rec_date_to_month;
			}else if (yearCnt == 2){
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else{
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}
			}else{
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else if(i == yearCnt-1){
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}else{
					headerData = (parseInt(rec_date_from_year)+i)+".01 ~ "+(parseInt(rec_date_from_year)+i)+".12";
				}
			}
			// width 재설정
			var sWidth = Math.floor(180/yearCnt);
			if (sWidth < 100 ) {
				sWidth = 100;
			}

			ibHeader.addHeader({Type: "Text", Header: headerData+"|대정부건의"			 ,  SaveName: "cnt0"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|지자체 / \n 유관기관건의", 	SaveName: "cnt1"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|미건의"				 ,	SaveName: "cnt2"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|전체"					 ,	SaveName: "cnt3"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|비중%"				 , 	SaveName: "cnt4"+i, 	Align: "Center", Width: sWidth });
		}

		var sheetId = "routeTblSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		routeTblSheet.LoadSearchData({Data: data.result.resultList});



	}
	// 하단 합계
	function routeTblSheet_OnSearchEnd(Row, Col, Rows, Cols, Align) {
		var yearCnt = parseInt($("#routeSearchForm input[name=rec_date_to_year]").val())-parseInt($("#routeSearchForm input[name=rec_date_from_year]").val());
		var sumData = routeTblSheet.GetRowData(routeTblSheet.GetDataLastRow());
		var totalData = new Object();
		totalData.rnum = "합계";
		var cnt0Per = 0;
		var cnt1Per = 0;
		var cnt2Per = 0;
		for (var i = 0 ; i <= yearCnt; i++){
			cnt0Per =setRound(getNum((parseInt(sumData["cnt0"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt1Per =setRound(getNum((parseInt(sumData["cnt1"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt2Per =setRound(getNum((parseInt(sumData["cnt2"+i])/parseInt(sumData["cnt3"+i])) * 100));


			totalData["cnt0"+i] = sumData["cnt0"+i]+" ("+cnt0Per+"%)";
			totalData["cnt1"+i] = sumData["cnt1"+i]+" ("+cnt1Per+"%)";
			totalData["cnt2"+i] = sumData["cnt2"+i]+" ("+cnt2Per+"%)";
			totalData["cnt3"+i] = sumData["cnt3"+i];
			totalData["cnt4"+i] = sumData["cnt4"+i];
		}


		routeTblSheet.SetDataFontColor("#000");
		routeTblSheet.SetRowBackColor(routeTblSheet.GetDataLastRow(), '#DCDCDC');
		routeTblSheet.SetRowData(routeTblSheet.GetDataLastRow(), totalData);

		// 합계 Merge
		routeTblSheet.SetMergeCell(routeTblSheet.GetDataLastRow(), 0, 1, 2); 		// 합계 Merge (Row Index, Column Index, Row 개수, 머지할 셀의 Col 개수)
		routeTblSheet.SetCellAlign(routeTblSheet.GetDataLastRow(), 1, "Center");	// 합계 Align (Row Index, Column Index, 정렬값)

		//합계행 Bold
		var sumRow = routeTblSheet.GetDataLastRow();
		routeTblSheet.SetCellFont('FontBold', sumRow,0,sumRow,routeTblSheet.LastCol(),1);
	};
	/**
	 * 지역별 통계 리스트 가져오기
	 */
	function getAreaList(){
		var startDate = $('#searchStartDate2').val();
		var endDate = $('#searchEndDate2').val();

		var startArr = startDate.split("-");
		var endArr = endDate.split("-");

		$('#rec_date_from_year2').val(startArr[0]);
		$('#rec_date_from_month2').val(startArr[1]);
		$('#rec_date_to_year2').val(endArr[0]);
		$('#rec_date_to_month2').val(endArr[1]);
		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/regulationFreeSuggestStatAreaListAjax.do",
			data:$('#areaSearchForm').serializeArray(),
			async:false,
			success:function(data){
				setAreaGrid(data)

			}
		});
	}

	/**
	 * 지역별 통계 그리드 생성
	 * @param data
	 */
	function setAreaGrid(data){
		if (typeof areaTblSheet !== "undefined" && typeof areaTblSheet.Index !== "undefined") {
			areaTblSheet.DisposeSheet();
		}
		var resultList = data.result.resultList;
		var yearCnt = data.result.yearCnt;
		var rec_date_from_year = data.result.rec_date_from_year;
		var rec_date_from_month = data.result.rec_date_from_month;
		var rec_date_to_year = data.result.rec_date_to_year;
		var rec_date_to_month = data.result.rec_date_to_month;

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',ColResize: true,SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, MergeSheet:5});
		ibHeader.setHeaderMode({Sort: 0, ColMove: true});

		ibHeader.addHeader({Type: "Text"	, Header: "번호|번호", SaveName: "rnum", 	Align: "Center", 	Width: 60, 	Edit: false });
		ibHeader.addHeader({Type: "Text"	, Header: "지역|지역", SaveName: "REQ_CHANNEL", 	Align: "Center", 	Width: 120, 	Edit: false });


		var headerData = '';
		for (var i = 0 ; i <yearCnt; i++){
			if (yearCnt == 1){
				headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_to_year+"."+rec_date_to_month;
			}else if (yearCnt == 2){
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else{
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}
			}else{
				if (i == 0){
					headerData = rec_date_from_year+"."+rec_date_from_month+" ~ "+rec_date_from_year+".12";
				}else if(i == yearCnt-1){
					headerData = rec_date_to_year+".01 ~ "+rec_date_to_year+"."+rec_date_to_month;
				}else{
					headerData = (parseInt(rec_date_from_year)+i)+".01 ~ "+(parseInt(rec_date_from_year)+i)+".12";
				}
			}
			// width 재설정
			var sWidth = Math.floor(200/yearCnt);
			if (sWidth < 100 ) {
				sWidth = 100;
			}

			ibHeader.addHeader({Type: "Text", Header: headerData+"|대정부건의"			 ,  SaveName: "cnt0"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|지자체 / \n 유관기관건의", 	SaveName: "cnt1"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|미건의"				 ,	SaveName: "cnt2"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|전체"					 ,	SaveName: "cnt3"+i, 	Align: "Center", Width: sWidth });
			ibHeader.addHeader({Type: "Text", Header: headerData+"|비중%"				 , 	SaveName: "cnt4"+i, 	Align: "Center", Width: sWidth });
		}

		var sheetId = "areaTblSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		areaTblSheet.LoadSearchData({Data: data.result.resultList});
	}

	// 하단 합계
	function areaTblSheet_OnSearchEnd(Row) {
		var yearCnt = parseInt($("#areaSearchForm input[name=rec_date_to_year]").val())-parseInt($("#areaSearchForm input[name=rec_date_from_year]").val());

		var sumData = areaTblSheet.GetRowData(areaTblSheet.GetDataLastRow());
		var totalData = new Object();
		totalData.rnum = "합계";
		var cnt0Per = 0;
		var cnt1Per = 0;
		var cnt2Per = 0;
		for (var i = 0 ; i <= yearCnt; i++){
			cnt0Per =setRound(getNum((parseInt(sumData["cnt0"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt1Per =setRound(getNum((parseInt(sumData["cnt1"+i])/parseInt(sumData["cnt3"+i])) * 100));
			cnt2Per =setRound(getNum((parseInt(sumData["cnt2"+i])/parseInt(sumData["cnt3"+i])) * 100));


			totalData["cnt0"+i] = sumData["cnt0"+i]+" ("+cnt0Per+"%)";
			totalData["cnt1"+i] = sumData["cnt1"+i]+" ("+cnt1Per+"%)";
			totalData["cnt2"+i] = sumData["cnt2"+i]+" ("+cnt2Per+"%)";
			totalData["cnt3"+i] = sumData["cnt3"+i];
			totalData["cnt4"+i] = sumData["cnt4"+i];
		}


		areaTblSheet.SetDataFontColor("black");
		areaTblSheet.SetRowBackColor(areaTblSheet.GetDataLastRow(), '#DCDCDC');
		areaTblSheet.SetRowData(areaTblSheet.GetDataLastRow(), totalData);

		// 합계 Merge
		areaTblSheet.SetMergeCell(areaTblSheet.GetDataLastRow(), 0, 1, 2); 		// 합계 Merge (Row Index, Column Index, Row 개수, 머지할 셀의 Col 개수)
		areaTblSheet.SetCellAlign(areaTblSheet.GetDataLastRow(), 1, "Center");	// 합계 Align (Row Index, Column Index, 정렬값)

		//합계행 Bold
		var sumRow = areaTblSheet.GetDataLastRow();
		areaTblSheet.SetCellFont('FontBold', sumRow,0,sumRow,areaTblSheet.LastCol(),1);
	};

	/**
	 * 업체별 통계 리스트 가져오기
	 */
	function getCompanyList(){
		var startDate = $('#searchStartDate3').val();
		var endDate = $('#searchEndDate3').val();

		var startArr = startDate.split("-");
		var endArr = endDate.split("-");

		$('#rec_date_from_year3').val(startArr[0]);
		$('#rec_date_from_month3').val(startArr[1]);
		$('#rec_date_to_year3').val(endArr[0]);
		$('#rec_date_to_month3').val(endArr[1]);

		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/problSuggestStatCompanyListAjax.do",
			data:$('#companySearchForm').serializeArray(),
			async:false,
			success:function(data){
				setCompanyGrid(data)

			}
		});
	}

	/**
	 * 업체별 통계 그리드 생성
	 * @param data
	 */
	function setCompanyGrid(data){
		if (typeof companyTblSheet !== "undefined" && typeof companyTblSheet.Index !== "undefined") {
			companyTblSheet.DisposeSheet();
		}
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',ColResize: true,SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, MergeSheet:5});
		ibHeader.setHeaderMode({Sort: 0, ColMove: true});


		// 업체별 통계
		ibHeader.addHeader({Type: "Text", Header: "번호"				, SaveName: "rnum"		 ,  Align: "Center", Width: 50 });
		ibHeader.addHeader({Type: "Text", Header: "업체명"			, SaveName: "COMPNY_NM"  , 	Align: "Left"  , Width: 100 , Wrap: 1});
		ibHeader.addHeader({Type: "Text", Header: "무역업고유번호"		, SaveName: "TRADE_NUM"  , 	Align: "Center", Width: 100 });
		ibHeader.addHeader({Type: "Text", Header: "대정부건의"		, SaveName: "REQTYPECD1" , 	Align: "Center", Width: 100 });
		ibHeader.addHeader({Type: "Text", Header: "지자체/유관기관건의", SaveName: "REQTYPECD2" , 	Align: "Center", Width: 100 });
		ibHeader.addHeader({Type: "Text", Header: "미건의"			, SaveName: "REQTYPECD3" , 	Align: "Center", Width: 100 });
		ibHeader.addHeader({Type: "Text", Header: "전체"				, SaveName: "CNT"		 , 	Align: "Center", Width: 80 });

		var sheetId = "companyTblSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		companyTblSheet.LoadSearchData({Data: data.data});
	}




	// 하단 합계
	function companyTblSheet_OnSearchEnd(Row) {
		var sumData = companyTblSheet.GetRowData(companyTblSheet.GetDataLastRow());
		var totalData = new Object();
		totalData.rnum = "합계";
		var cnt0Per = 0;
		var cnt1Per = 0;
		var cnt2Per = 0;
		cnt0Per =setRound(getNum((parseInt(sumData["REQTYPECD1"])/parseInt(sumData["CNT"])) * 100));
		cnt1Per =setRound(getNum((parseInt(sumData["REQTYPECD2"])/parseInt(sumData["CNT"])) * 100));
		cnt2Per =setRound(getNum((parseInt(sumData["REQTYPECD3"])/parseInt(sumData["CNT"])) * 100));


		totalData["REQTYPECD1"] = sumData["REQTYPECD1"]+" ("+cnt0Per+"%)";
		totalData["REQTYPECD2"] = sumData["REQTYPECD2"]+" ("+cnt1Per+"%)";
		totalData["REQTYPECD3"] = sumData["REQTYPECD3"]+" ("+cnt2Per+"%)";
		totalData["CNT"] = sumData["CNT"];


		companyTblSheet.SetDataFontColor("black");
		companyTblSheet.SetRowBackColor(companyTblSheet.GetDataLastRow(), '#DCDCDC');
		companyTblSheet.SetRowData(companyTblSheet.GetDataLastRow(), totalData);

		// 합계 Merge
		companyTblSheet.SetMergeCell(companyTblSheet.GetDataLastRow(), 0, 1, 2); 		// 합계 Merge (Row Index, Column Index, Row 개수, 머지할 셀의 Col 개수)
		companyTblSheet.SetCellAlign(companyTblSheet.GetDataLastRow(), 1, "Center");	// 합계 Align (Row Index, Column Index, 정렬값)

		//합계행 Bold
		var sumRow = companyTblSheet.GetDataLastRow();
		companyTblSheet.SetCellFont('FontBold', sumRow,0,sumRow,companyTblSheet.LastCol(),1);
	};

	// 엑셀 다운받기 (분야,경로,지역,업체별)
	function doExcelDownload() {
		var selectTab = $('[class*="tab on"]').val();
		var sheetName = '';
		var exlName = '';

		if(selectTab == 'field')
		{
			sheetName = fieldTblSheet;
			exlName = '규제프리365_분야별통계';
		}

		if(selectTab == 'route')
		{
			sheetName = routeTblSheet;
			exlName = '규제프리365_경로별통계';
		}

		if(selectTab == 'area')
		{
			sheetName = areaTblSheet;
			exlName = '규제프리365_지역별통계';
		}

		if(selectTab == 'company')
		{
			sheetName = companyTblSheet;
			exlName = '규제프리365_업체별통계';
		}

		// 해당 Sheet Header 의 SaveName 을 가져와 문자열 추가
		var dwCols = sheetName.ColSaveName(0);
		// sheetName.ColSaveName();
		var lastIndex = sheetName.LastCol();			//Sheet의 마지막 index

		for(var i = 1; i <= lastIndex; i++)				//Sheet의 SaveName 가져와 문자열 추가
		{
			var saveNm = sheetName.ColSaveName(i);
			dwCols += "|"+saveNm
		}

		var params = {
			'FileName' : exlName+'.xlsx'
			, 'SheetName' : 'Sheet1'
			, 'SheetDesign' : 1
			, 'Merge' : 1
			, 'CheckBoxOnValue' : 'Y'
			, 'CheckBoxOffValue' : 'N'
			, 'AutoSizeColumn' : 1
			, 'DownCols' : dwCols
		};
		downloadIbSheetExcel(sheetName, '', params);
	}

	function getNum(val){
		if (isNaN(val)) {
			return 0;
		}
		return val;
	}
	function setRound(val){
		return Math.round(val*10)/10;
	}
</script>