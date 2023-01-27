
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="topMenuId" value="" />
<input type="hidden" name="searchYearMonth" id="searchYearMonth" value="${searchVO.searchYearMonth}"/>
<input type="hidden" name="searchYear" id="searchYear" value="<c:out value="${curYear}"/>">
<input type="hidden" name="searchMonth" id="searchMonth" value="<c:out value="${curMonth}"/>">
<input type="hidden" name="searchGubun" id="searchGubun"/>
<input type="hidden" name="searchExpertId" id="searchExpertId">
<fmt:formatNumber value="${curYear }" type="number" var="curYear" />
<fmt:formatNumber value="${curMonth }" type="number" var="curMonth" />

<!-- 외국어 통번역 - 지급내역현황 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="getExcelDown();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="fn_init('Y');">검색</button>
	</div>
</div>

<!-- 검색 테이블 -->
<div class="cont_block">
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col>
				<col style="width:10%">
				<col style="width:30%">
				<col style="width:10%">
				<col style="width:15%">
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">완료일자</th>
				<td>
					<div class="flex align_center">
						<select name="searchYearTemp" id="searchYearTemp" class="form_select">
							<c:forEach items="${yearList}" var="item" varStatus="status">
								<c:if test="${curYear >= item.cdNm}">
									<option value="<c:out value="${item.cdNm}"/>" <c:if test="${'2021' eq item.cdNm}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:if>
							</c:forEach>
						</select>
						<select name="searchMonthTemp" id="searchMonthTemp" class="form_select ml-8">
							<option value="01" <c:if test="${searchVO.searchMonth eq '01' or searchVO.searchMonth eq null}">selected</c:if>> 1월 </option>
							<option value="02" <c:if test="${searchVO.searchMonth eq '02'}">selected</c:if>>2월</option>
							<option value="03" <c:if test="${searchVO.searchMonth eq '03'}">selected</c:if>>3월</option>
							<option value="04" <c:if test="${searchVO.searchMonth eq '04'}">selected</c:if>>4월</option>
							<option value="05" <c:if test="${searchVO.searchMonth eq '05'}">selected</c:if>>5월</option>
							<option value="06" <c:if test="${searchVO.searchMonth eq '06'}">selected</c:if>>6월</option>
							<option value="07" <c:if test="${searchVO.searchMonth eq '07'}">selected</c:if>>7월</option>
							<option value="08" <c:if test="${searchVO.searchMonth eq '08'}">selected</c:if>>8월</option>
							<option value="09" <c:if test="${searchVO.searchMonth eq '09'}">selected</c:if>>9월</option>
							<option value="10" <c:if test="${searchVO.searchMonth eq '10'}">selected</c:if>>10월</option>
							<option value="11" <c:if test="${searchVO.searchMonth eq '11'}">selected</c:if>>11월</option>
							<option value="12" <c:if test="${searchVO.searchMonth eq '12'}">selected</c:if>>12월</option>
						</select>
					</div>
				</td>
				<th scope="row">서비스</th>
				<td>
					<label class="label_form">
						<input type="radio" class="form_radio" name="searchGubunTemp" id="searchGubunTemp" value="000"
						   <c:if test="${searchVO.searchGubun eq ''}">checked="checked"</c:if>>
						<span class="label">전체</span>
					</label>
					<c:forEach items="${gubunList}" var="item" varStatus="status">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchGubunTemp" id="searchGubunTemp${status.count}" value="<c:out value="${item.cdId}"/>"
								   <c:if test="${searchVO.searchGubun eq item.cdId }">checked="checked"</c:if>>
							<span class="label"><c:out value="${item.cdNm}"/></span>
						</label>
					</c:forEach>
				</td>
				<th scope="row">소득구분</th>
				<td>
					<select name="searchIncomeGb" id="searchIncomeGb" class="form_select w100p">
						<option value=""
								<c:if test="${searchVO.searchIncomeGb eq '' or searchVO.searchIncomeGb eq null}">selected</c:if>>
							전체
						</option>
						<option value="1" <c:if test="${searchVO.searchIncomeGb eq '1'}">selected</c:if>>기타소득</option>
						<option value="2" <c:if test="${searchVO.searchIncomeGb eq '2'}">selected</c:if>>사업소득</option>
					</select>
				</td>
			</tr>
			</tbody>
		</table><!-- // 검색 테이블-->
	</div>

</div>

<!-- 리스트 테이블 -->
<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
	</div>
	<div class="tbl_btn">
		<div class="tbl_scrolly">
			<div id='tblGridSheet' class="colPosi"></div>
		</div>
	</div>
</div>
<!-- 리스트 테이블 -->
<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">컨설턴트별 지급현황</h3>

		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="getTranslExcelDown();">엑셀 다운</button>
		</div>
	</div>
	<div class="tbl_btn">
		<div class="tbl_scrolly">
			<div id='tblGrid2Sheet' class="colPosi"></div>
		</div>
	</div>
</div>
<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">컨설턴트별 상세 지급현황</h3>

		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="fn_detail('all')">전체보기</button>
			<button type="button" class="btn_sm btn_primary" onclick="getTranslDetailExcelDown();">엑셀 다운</button>
		</div>
	</div>
	<div class="tbl_btn">
		<div class="tbl_scrolly">
			<div id='tblGrid3Sheet' class="colPosi"></div>
		</div>
	</div>
</div>
</form>

<script type="text/javascript">
	var f;
	$(document).ready(function () {
		f = document.searchForm;

		f_Init_tblGridSheet();  //지급현황 Sheet

		f_Init_tblGrid2Sheet(); //컨설턴트별 지급현황 Sheet

		f_Init_tblGrid3Sheet(); //컨설턴ㅂ트별 상세 지급현황 Sheet

		fn_init("N"); // 조회
	});

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Int", Header: "지급금액(지원금)|총액",               SaveName: "money",     Align: "Center", Width: 160 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "지급금액(지원금)|필요경비",           SaveName: "nMoney", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "지급금액(지원금)|소득금액",           SaveName: "inMoney", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "공제금액(지원금)|총공제액",           SaveName: "toutMoney", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "공제금액(지원금)|소득세",             SaveName: "texMoney1", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "공제금액(지원금)|주민세",             SaveName: "texMoney2", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "실지급액\n(지원금)|실지급액\n(지원금)",SaveName: "totalMoney", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "업체부담금|업체부담금",               SaveName: "sMoney", Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });
		ibHeader.addHeader({Type: "Int", Header: "총건수|총건수",                     SaveName: "cnt",     Align: "Center", Width: 130 ,Format: "#,##0", ColMerge: 0 });

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "200px");
		ibHeader.initSheet(sheetId);

	};

	function f_Init_tblGrid2Sheet() {
		var ibHeader = new IBHeader();

	 /** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "컨설턴트|컨설턴트",                 SaveName: "expertNm", Align: "Center", Width: 105 , Ellipsis:1, Cursor:"Pointer", ColMerge: 0});
		ibHeader.addHeader({Type: "Text", Header: "소득구분|소득구분",                 SaveName: "incomeGb", Align: "Center", Width: 105, ColMerge: 0 });
		ibHeader.addHeader({Type: "Int",  Header: "지급금액(지원금)|총액",             SaveName: "money", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "지급금액(지원금)|필요경비",          SaveName: "nMoney", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "지급금액(지원금)|소득금액",          SaveName: "inMoney", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "공제금액(지원금)|총공제액",          SaveName: "toutMoney", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "공제금액(지원금)|소득세",            SaveName: "texMoney1", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "공제금액(지원금)|주민세",            SaveName: "texMoney2", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "실지급액\n(지원금)|실지급액\n(지원금)",SaveName: "totalMoney", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "업체부담금|업체부담금",              SaveName: "sMoney", Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Int",  Header: "총건수|총건수",                     SaveName: "cnt",     Align: "Center", Width: 110 ,Format: "#,##0", ColMerge: 0});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트G",                        SaveName: "expertId", Align: "Center", Width: 110,Hidden:true, ColMerge: 0});
		ibHeader.addHeader({Type: "Text", Header: "번호",                            SaveName: "colLink",    Align: "Left",   Width: 0, Hidden:1, ColMerge: 0});

		var sheetId = "tblGrid2Sheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "210px");
		ibHeader.initSheet(sheetId);

	};

	function f_Init_tblGrid3Sheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "컨설턴트", SaveName: "expertNm",      Align: "Center", Width: 150 });
		ibHeader.addHeader({Type: "Text", Header: "서비스", SaveName: "gubunNm",         Align: "Center", Width: 110 });
		ibHeader.addHeader({Type: "Text", Header: "회원사", SaveName: "companyNm",       Align: "Center", Width: 120 });
		ibHeader.addHeader({Type: "Text", Header: "신청자", SaveName: "memberName",      Align: "Center", Width: 120 });
		ibHeader.addHeader({Type: "Text", Header: "언어", SaveName: "languageNm",        Align: "Center", Width: 120 });
		ibHeader.addHeader({Type: "Text", Header: "번역구분", SaveName: "transgubunNm",   Align: "Center", Width: 120 });
		ibHeader.addHeader({Type: "Float", Header: "분량", SaveName: "transCon",         Align: "Center", Width: 100 , Format: "#,##0.0"});
		ibHeader.addHeader({Type: "Text", Header: "신청일", SaveName: "regDt",           Align: "Center", Width: 120 , Format:"####-##-##"});
		ibHeader.addHeader({Type: "Text", Header: "완료일", SaveName: "finalDt",          Align: "Center", Width: 120 , Format:"####-##-##"});
		ibHeader.addHeader({Type: "Int", Header: "지급금액", SaveName: "supportMoney",    Align: "Center", Width: 120 ,Format: "#,##0"});
		ibHeader.addHeader({Type: "Text", Header: "번호", SaveName: "colLink",           Align: "Left", Width: 0, Hidden:1});

		var sheetId = "tblGrid3Sheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "135px");
		ibHeader.initSheet(sheetId);

	};

	function tblGrid2Sheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblGrid2Sheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblGrid2Sheet.SetColFontBold('expertNm', 1);
		}
	}

	// 엑셀 다운로드
	function getExcelDown() {
		f.action = '<c:url value="/tradeSOS/translation/translProvisionTopExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	// 정산처리 엑셀 다운로드
	function getTranslExcelDown() {
		f.action = '<c:url value="/tradeSOS/translation/translProvisionExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	// 컨설턴트별 상세 엑셀 다운로드
	function getTranslDetailExcelDown() {
		f.action = '<c:url value="/tradeSOS/translation/translProvisionDetailExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function fn_init(flag) {
		if (flag == "Y") { // search 셋팅
			$('#searchYear').val($('#searchYearTemp').val());
			$('#searchMonth').val($('#searchMonthTemp').val());
		}

		$('#searchYearMonth').val($('#searchYear').val() + $('#searchMonth').val());
		$('#searchGubun').val($('input[name="searchGubunTemp"]:checked').val());

		global.ajax({
			  type: 'POST'
			, url: '<c:url value="/tradeSOS/translation/translProvisionAjax.do" />'
			, data: $('#searchForm').serialize()
			, dataType: 'json'
			, async: false
			, spinner: true
			, success: function (data) {
				 console.log(data.topList);
				if( data.topList != null) {
					tblGridSheet.LoadSearchData({Data: data.topList});
				} else {
					tblGridSheet.LoadSearchData({Data : ""});
				}

				tblGrid2Sheet.LoadSearchData({Data: data.middelList});

				tblGrid3Sheet.LoadSearchData({Data : ""});

			},
			error: function (request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});

	}

	function tblGrid2Sheet_OnClick(Row, Col, Value) {
		if (tblGrid2Sheet.ColSaveName(Col) == "expertNm" && Row > 0) {
			fn_detail(tblGrid2Sheet.GetCellValue(Row, "expertId"));
		}
	}

	function fn_detail(expertId) {
		if (expertId != 'all') {
			$('#searchExpertId').val(expertId)
		} else {
			$('#searchExpertId').val('');
		}

		global.ajax({
			  type: 'POST'
			, url: '<c:url value="/tradeSOS/translation/translProvisionDetailAjax.do" />'
			, data: $('#searchForm').serialize()
			, dataType: 'json'
			, async: true
			, spinner: true
			, success: function (data) {

				if (data.bottomList.length > 0) {
					tblGrid3Sheet.LoadSearchData({Data: data.bottomList});
				} else {
					tblGrid3Sheet.LoadSearchData({Data : ""});
				}
			},
			error: function (request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
			}
		});
	}

</script>