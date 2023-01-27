<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 외국어 통번역 - 언어별통계 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(tblGridSheet,'외국어통번역통계_서비스종류별통계','');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getList();">검색</button>
	</div>
</div>

<div class="cont_block">
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab"    onclick="page1();" title="평가통계">평가통계</button>
			<button class="tab"    onclick="page2();" title="언어별통계">언어별통계</button>
			<button class="tab on" onclick="page3();" title="서비스종류별통계">서비스종류별통계</button>
			<button class="tab"    onclick="page4();" title="지역별통계">지역별통계</button>
			<button class="tab"    onclick="page5();" title="컨설턴트별통계">컨설턴트별통계</button>
			<button class="tab"    onclick="page6();" title="업체별통계">업체별통계</button>
			<button class="tab"    onclick="page7();" title="품목군별통계">품목군별통계</button>
		</div>

		<div class="tab_body">
			<div class="tab_cont on">
				<form id="searchForm" name="searchForm" method="get">
					<input type="hidden" name="searchGubun" id="searchGubun"/>
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
									<th scope="row">서비스</th>
									<td>
										<label class="label_form">
											<input type="radio" class="form_radio" name="searchGubunTemp" id="radio2_1" value="" <c:if test="${searchVO.searchGubun eq '' or searchGubun eq null}">checked</c:if>>
											<span class="label">전체</span>
										</label>
										<label class="label_form">
											<input type="radio" class="form_radio" name="searchGubunTemp" id="radio2_2" value="T" <c:if test="${searchVO.searchGubun eq 'T'}">checked</c:if>>
											<span class="label">번역</span>
										</label>
										<label class="label_form">
											<input type="radio" class="form_radio" name="searchGubunTemp" id="radio2_3" value="I" <c:if test="${searchVO.searchGubun eq 'I'}">checked</c:if>>
											<span class="label">통역</span>
										</label>
										<label class="label_form">
											<input type="radio" class="form_radio" name="searchGubunTemp" id="radio2_4" value="C" <c:if test="${searchVO.searchGubun eq 'C'}">checked</c:if>>
											<span class="label">전화통역</span>
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
						<div id='tblGridSheet' class="colPosi"></div>
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
	});

	// 데이터 조회
	function getList(){

		var validate = true;

		$('#searchGubun').val($('input[name="searchGubunTemp"]:checked').val());

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


		var startYear = $("#searchFrDt").val();
		var endYear = $("#searchToDt").val();
		var da1 = new Date(startYear);
		var da2 = new Date(endYear);
		var dif = da2 - da1;
		var cDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
		var cMonth = cDay * 30;// 월 만듬
		var cYear = cMonth * 12; // 년 만듬
		if (startYear > endYear){
			alert("시작일은 종료일을 초과할 수 없습니다.");
			validate = false;
			return;
		}

		if (parseInt(dif/cMonth) > 60){
			alert("일자 검색은 5년을 초과할 수 없습니다.");
			validate = false;
			return;
		}

		if(validate){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/translation/serviceStatisticsAjax.do" />'
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

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction',  Page: 10, SearchMode: 4, editable: false, ColResize: true, statusColHidden: true, MergeSheet:msPrevColumnMerge + msHeaderOnly, NoFocusMode: 0, Ellipsis: 1, FrozenCol : 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", 		Header: "종류|종류", SaveName: "gubunNm", 	Align: "Left", Width: 70 , Wrap: 1, ColMerge: 0 });
		ibHeader.addHeader({Type: "Text", 		Header: "종류|종류", SaveName: "serviceNm", 	Align: "Left", Width: 300 , Wrap: 1, ColMerge: 0 });
		for(let i=0; i < searchVO.finalDateList.length; i++) {
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용건수", 				SaveName: "useCnt"+i, 	Align: "Right",	 Width: 110 ,Format: "#,##0", ColMerge: 0});
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용금액", 				SaveName: "useMoney"+i, 	Align: "Right", Width: 130 ,Format: "#,##0", ColMerge: 0});
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용건수\n(협회지원금)", 	SaveName: "tradeCnt"+i, 	Align: "Right", Width: 110 ,Format: "#,##0", ColMerge: 0});
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용금액\n(협회지원금)", 	SaveName: "tradeMoney"+i, 	Align: "Right", Width: 130 ,Format: "#,##0", ColMerge: 0});
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용건수\n(협회지원금2)", 	SaveName: "tradeSupportmoneySubCnt"+i, 	Align: "Right", Width: 110 ,Format: "#,##0", ColMerge: 0});
			ibHeader.addHeader({Type: "AutoSum", Header: searchVO.finalDateList[i]+"년"+ "|이용금액\n(협회지원금2)",	SaveName: "tradeSupportmoneySubMoney"+i, 	Align: "Right", Width: 130 ,Format: "#,##0", ColMerge: 0});
		}

		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용건수", 			    SaveName: "useCntSum",                  	Align: "Right",	Width: 110  , Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용금액", 			    SaveName: "useMoneySum", 	                Align: "Right", Width: 115  , Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용건수\n(협회지원금)", 	SaveName: "tradeCntSum", 	                Align: "Right", Width: 110  , Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용금액\n(협회지원금)", 	SaveName: "tradeMoneySum", 	                Align: "Right", Width: 115  , Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용건수\n(협회지원금2)", 	SaveName: "tradeSupportmoneySubCntSum", 	Align: "Right", Width: 110  , Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "AutoSum", Header: "합계|이용금액\n(협회지원금2)",	SaveName: "tradeSupportmoneySubSum", 	    Align: "Right", Width: 115  , Format: "#,##0", ColMerge: 0});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "490px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetEditable(0);

		tblGridSheet.LoadSearchData({Data: resultList}); // 그리드 데이터 삽입

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

	// 하단 합계
	function tblGridSheet_OnSearchEnd(Row) {
	    var sumRow = Number(tblGridSheet.FindSumRow());
		tblGridSheet.SetMergeCell(sumRow, 0, 1, 2);      // 0~2 셀 머지
		tblGridSheet.SetSumValue(0, 0, "합계");          // 합계 텍스트
		tblGridSheet.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
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