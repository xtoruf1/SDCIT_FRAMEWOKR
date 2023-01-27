<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 외국어 통번역 - 컨설턴트별통계 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(tblGridSheet,'외국어통번역통계_컨설턴트별통계','');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getList();">검색</button>
	</div>
</div>

<div class="cont_block">
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab"    onclick="page1();" title="평가통계">평가통계</button>
			<button class="tab"    onclick="page2();" title="언어별통계">언어별통계</button>
			<button class="tab"    onclick="page3();" title="서비스종류별통계">서비스종류별통계</button>
			<button class="tab"    onclick="page4();" title="지역별통계">지역별통계</button>
			<button class="tab on" onclick="page5();" title="컨설턴트별통계">컨설턴트별통계</button>
			<button class="tab"    onclick="page6();" title="업체별통계">업체별통계</button>
			<button class="tab"    onclick="page7();" title="품목군별통계">품목군별통계</button>
		</div>

		<div class="tab_body">
			<div class="tab_cont on">
				<form id="searchForm" name="searchForm" method="get">
					<input type="hidden" name="etcComment" id="etcComment"/>
					<div class="search">
						<table class="formTable">
							<colgroup>
								<col style="width:12%">
								<col>
								<col style="width:12%">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">컨설턴트명</th>
									<td>
										<input type="text" id="searchExpertId" name="searchExpertId" class="form_text" value="<c:out value="${searchVO.searchExpertId}"/>" onkeypress="press(event);">
										<label class="label_form" style="margin-top: 5px; margin-left: 5px;">
											<input type="checkbox" id="etcCommentTemp" name="etcCommentTemp" class="form_checkbox" value="Y" <c:if test="${searchVO.etcComment eq 'Y'}">checked</c:if>>
										<span class="label">기타의견 보기</span>
									</label>
									</td>
									<th scope="row">일자</th>
									<td class="pick_area">
										<div class="group_datepicker">
											<!-- datepicker -->
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" id="searchFrDt" name="searchFrDt" value='<c:out value="${searchVO.searchFrDt}"/>' class="txt datepicker" placeholder="시작일" title="게재기간 시작일" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
													<input type="hidden" id="dummyStartDate" value="" />
												</span>
											</div>
											<div class="spacing">~</div>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" id="searchToDt" name="searchToDt" value='<c:out value="${searchVO.searchToDt}"/>' class="txt datepicker" placeholder="종료일" title="게재기간 종료일" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
													<input type="hidden" id="dummyEndDate" value="" />
												</span>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table><!-- // 검색 테이블-->
					</div>
				</form>
				<div class="cont_block mt-20">
					<div class="tbl_opt">
						<!-- 상담내역조회 -->
						<div id="totalCnt" class="total_count"></div>
					</div>
					<!-- 리스트 테이블 -->
					<div style="width: 100%;height: 100%;">
						<div id='tblGrid' class="colPosi"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div> <!-- // .page_tradesos -->
<script type="text/javascript">
	var f;
	$(document).ready(function () {
		f = document.searchForm;

		getList();

		// 시작일 선택 이벤트
		datepickerById('searchFrDt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchToDt', toDateSelectEvent);
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchFrDt').val());

		if ($('#searchToDt').val() != '') {
			if (startymd > Date.parse($('#searchToDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchFrDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchToDt').val());

		if ($('#searchFrDt').val() != '') {
			if (endymd < Date.parse($('#searchFrDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchToDt').val('');

				return;
			}
		}
	}

	// 데이터 조회
	function getList(){

		var validate = true;
		if($('#searchFrDt').val() == ""){
			alert('조회시작일자를 선택해주세요');
			$('#searchFrDt').focus();
			validate = false;
		}

		if($('#searchToDt').val() == ""){
			alert('조회종료일자를 선택해주세요');
			$('#searchToDt').focus();
			validate = false;
		}

		if(!$('#etcCommentTemp').is(":checked")){
			$('#etcComment').val('N');
		}else{
			$('#etcComment').val('Y');
		}

		if(validate){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/translation/consultantStatisticsAjax.do" />'
				, data : $('#searchForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#totalCnt').html('총 <span style="color: orange;">' + global.formatCurrency(data.totalCount) + '</span> 건');

					$('#searchFrDt').val(data.searchVO.searchFrDt);
					$('#searchToDt').val(data.searchVO.searchToDt);

					setGrid(data);
				}
			});
		}
	}

	function setGrid(data) {

		var resultList = data.returnList;
		var searchVO = data.searchVO;
		var serviceList = data.serviceList;

		if (typeof tblGridSheet !== "undefined" && typeof tblGridSheet.Index !== "undefined") {
			tblGridSheet.DisposeSheet();
		}
		if (typeof etcGridSheet !== "undefined" && typeof etcGridSheet.Index !== "undefined") {
			etcGridSheet.DisposeSheet();
		}

		var ibHeader = new IBHeader();
		var ibHeader2 = new IBHeader();

		if(searchVO.etcComment == "N") { // 기타의견 체크 X
			/** 리스트,헤더 옵션 */
			ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 200, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 0, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
			ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, SizeMode:3});

			ibHeader.addHeader({Type: "Text", Header: "언어", SaveName: "languageNm", Align: "Center",  Width: 132});
			ibHeader.addHeader({Type: "Text", Header: "이름", SaveName: "name",        Align: "Center", 	Width: 132 });

			// width 재설정
			var nServiceList = serviceList.length +1;
			var sWidth = Math.floor(920/nServiceList);
			if (sWidth < 100 ) {
				sWidth = 100;
			}

			for( var i=0; i < serviceList.length; i++) {
				ibHeader.addHeader({Type: "AutoSum", 	Header: serviceList[i].service, 		SaveName: "sumcount"+i, Align: "Right", 	Width: sWidth ,Format: "#,##0"});
			}

			ibHeader.addHeader({Type: "AutoSum", 	Header: "통번역수당", 	SaveName: "supportMoney", Align: "Right", 	Width: sWidth ,Format: "#,##0"});

			var sheetId = "tblGridSheet";
			createIBSheet2('tblGrid', sheetId, "100%", "550px");
			ibHeader.initSheet(sheetId);

			// 편집모드 OFF
			tblGridSheet.SetEditable(0);

			tblGridSheet.LoadSearchData({Data: resultList}); // 그리드 데이터 삽입

		} else {  // 기타의견 체크 O
			/** 리스트,헤더 옵션 */
			ibHeader2.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',Page: 200, SearchMode: 4, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
			ibHeader2.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, SizeMode:1});
			ibHeader2.addHeader({Type: "Text", 			Header: "신청언어", 			SaveName: "languageNm", Align: "Center", Width: 115});
			ibHeader2.addHeader({Type: "Text", 			Header: "컨설턴트", 			SaveName: "expertNm", Align: "Center", 	Width: 115 });
			ibHeader2.addHeader({Type: "Text", 			Header: "신청회원사", 		SaveName: "companyNm", Align: "Center", 	Width: 130 });
			ibHeader2.addHeader({Type: "Text", 			Header: "서비스", 			SaveName: "gubunNm", Align: "Center", 	Width: 115 });
			ibHeader2.addHeader({Type: "Text", 			Header: "상담자", 			SaveName: "memberName", Align: "Center", 	Width: 115 });
			ibHeader2.addHeader({Type: "Text", 			Header: "상담일", 			SaveName: "finalDate", Align: "Center", 	Width: 115 });
			ibHeader2.addHeader({Type: "Text", 			Header: "기타의견", 			SaveName: "etcView", Align: "Center", 	Width: 400 });

			var sheetId = "etcGridSheet";
			createIBSheet2('tblGrid', sheetId, "100%", "550px");
			ibHeader2.initSheet(sheetId);

			etcGridSheet.LoadSearchData({Data: resultList}); // 그리드 데이터 삽입
		}
	};

	// 하단 합계
	function tblGridSheet_OnSearchEnd(Row) {
		var sumRow = Number(tblGridSheet.FindSumRow());
		tblGridSheet.SetMergeCell(sumRow, 0, 1, 2);      // 0~2 셀 머지
		tblGridSheet.SetSumValue(0, 0, "합계");          // 합계 텍스트
		tblGridSheet.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
/*		var sumData = tblGridSheet.GetRowData(tblGridSheet.GetDataLastRow());

		sumData.languageNm = "합계";
		tblGridSheet.SetRowBackColor(tblGridSheet.GetDataLastRow(), '#ddd');
		tblGridSheet.SetRowData(tblGridSheet.GetDataLastRow(), sumData);

		// 합계 Merge
		tblGridSheet.SetMergeCell(tblGridSheet.GetDataLastRow(), 1, 1, 2); 		// 합계 Merge (Row Index, Column Index, Row 개수, 머지할 셀의 Col 개수)
		tblGridSheet.SetCellAlign(tblGridSheet.GetDataLastRow(), 1, "Center");	// 합계 Align (Row Index, Column Index, 정렬값)*/

	};


			// 평가통계
	function page1() {
		location.href = '<c:url value="/tradeSOS/translation/evaluationStatistics.do" />';
	}

	// 언어별통계
	function page2() {
		location.href = '<c:url value="/tradeSOS/translation/languageStatistics.do" />';
	}
	// 서비스종류별통계
	function page3() {
		location.href = '<c:url value="/tradeSOS/translation/serviceStatistics.do" />';
	}
	// 지역별통계
	function page4() {
		location.href = '<c:url value="/tradeSOS/translation/regionStatistics.do" />';
	}
	// 컨설턴트별통계
	function page5() {
		location.href = '<c:url value="/tradeSOS/translation/consultantStatistics.do" />';
	}
	// 업체별통계
	function page6() {
		location.href = '<c:url value="/tradeSOS/translation/companyStatistics.do" />';
	}
	// 품목군별통계
	function page7() {
		location.href = '<c:url value="/tradeSOS/translation/itemStatistics.do" />';
	}

	function press(event) {
		if (event.keyCode==13) {
			getList();
		}
	}
</script>