<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 외국어 통번역 - 평가통계 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(tblGridSheet,'외국어통번역통계_평가통계','');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getList();">검색</button>
	</div>
</div>

<div class="cont_block">
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab on" onclick="page1();" title="평가통계">평가통계</button>
			<button class="tab"    onclick="page2();" title="언어별통계">언어별통계</button>
			<button class="tab"    onclick="page3();" title="서비스종류별통계">서비스종류별통계</button>
			<button class="tab"    onclick="page4();" title="지역별통계">지역별통계</button>
			<button class="tab"    onclick="page5();" title="컨설턴트별통계">컨설턴트별통계</button>
			<button class="tab"    onclick="page6();" title="업체별통계">업체별통계</button>
			<button class="tab"    onclick="page7();" title="품목군별통계">품목군별통계</button>
		</div>

		<div class="tab_body">
			<div class="tab_cont on">
				<form id="searchForm" name="searchForm" method="get">
					<div class="search">
						<table class="formTable">
							<colgroup>
								<col style="width:15%">
								<col>
								<col style="width:15%">
								<col>
							</colgroup>
							<tbody>
								<tr>
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
									<th scope="row">컨설턴트명</th>
									<td>
										<input type="text" id="searchExpertId" name="searchExpertId" class="form_text" value="<c:out value="${searchVO.searchExpertId}"/>" onkeypress="press(event);">
									</td>
								</tr>
							</tbody>
						</table><!-- // 검색 테이블-->
					</div>
				</form>
				<!-- 발생시안 테이블 -->
				<div class="cont_block mt-20">
					<div class="tbl_opt">
					<table class="formTable dataTable">
						<colgroup>
							<col style="width: 15%">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th scope="col" colspan="2">발생시안</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${caseList}" var="item" varStatus="status">
								<tr>
									<th>발생시안<c:out value="${status.count}"/></th>
									<td class="align_l"><c:out value="${item.explain}"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					</div>
				</div>
				<div class="cont_block mt-20">
					<div class="tbl_opt">
						<!-- 상담내역조회 -->
						<div id="totalCnt" class="total_count"></div>
					</div>
					<!-- 리스트 테이블 -->
					<div style="width: 100%;height: 100%;">
						<div id='tblGridSheet' class="colPosi"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
	var f;
	$(document).ready(function () {
		f = document.searchForm;

		f_Init_tblGridSheet();  //지급현황 Sheet

		getList();
	});

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize',Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", 		Header: "컨설턴트명",     SaveName: "name", Align: "Center", 	Width: 180, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안1", 	SaveName: "case1", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안2", 	SaveName: "case2", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안3",	    SaveName: "case3", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안4", 	SaveName: "case4", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안5", 	SaveName: "case5", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안6", 	SaveName: "case6", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "발생사안7", 	SaveName: "case7", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "총점", 		    SaveName: "total", Align: "Center", 	Width: 100 });
		ibHeader.addHeader({Type: "Text", 		Header: "최초채점일",     SaveName: "firstDt",  Align: "Center", 	Width: 110 });
		ibHeader.addHeader({Type: "Text", 		Header: "최종채점일",     SaveName: "lastDt",   Align: "Center", 	Width: 110});
		ibHeader.addHeader({Type: "Text", 		Header: "컨설턴트ID",     SaveName: "expertId", Align: "Center", 	Width: 110, Hidden:true});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetEditable(0);

		// 시작일 선택 이벤트
		datepickerById('searchFrDt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchToDt', toDateSelectEvent);
	};

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

	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblGridSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblGridSheet.SetColFontBold('name', 1);
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

		if(validate){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/translation/evaluationStatisticsAjax.do" />'
				, data : $('#searchForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#totalCnt').html('총 <span style="color: orange;">' + global.formatCurrency(data.totalCount) + '</span> 건');

					$('#searchFrDt').val(data.searchVO.searchFrDt);
					$('#searchToDt').val(data.searchVO.searchToDt);

					tblGridSheet.LoadSearchData({Data: data.returnList});
				}
			});
		}
	}

	// 평가 통계 상세 팝업 호출
	function tblGridSheet_OnClick(Row, Col, Value) {
		var expertId = tblGridSheet.GetCellValue(Row, "expertId");

		if(tblGridSheet.ColSaveName(Col) == "name" && Row > 0) {
			evaluationPopup(expertId)
		}
	};

	// 통역 레이어 팝업
	function evaluationPopup(expertId) {
		var searchFrDtPop = $('#searchFrDt').val();
		var searchToDtPop = $('#searchToDt').val();
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/tradeSOS/translation/evaluationPopup.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
					    searchExpertIdPop : expertId
				      , searchFrDtPop : searchFrDtPop
				      , searchToDtPop : searchToDtPop
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
			}
		});
	}

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