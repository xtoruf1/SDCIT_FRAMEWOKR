<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : problSuggestList.jsp
  * @Description : 에로사항 건의 목록화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2021.09.15	양지환		최초 생성
  *
  * @author 양지환
  * @since 2021.09.15
  * @version 1.0
  * @see
  *
  */
%>
<script type="text/javascript">
	function press(event) {
		if (event.keyCode==13) {

		}
	}

	function clearDate(targetId){
		$("#"+targetId).val("");
	}

	function fn_detail(seq) {

		var url = "";

		if (seq > 0){
			url = "/tradeSOS/problem/popup/regulationFreeSuggestListDetailPop.do?sosSeq="+seq;
		}else{
			url = "/tradeSOS/problem/popup/regulationFreeSuggestListRegPop.do";
		}

		global.openLayerPopup({
			popupUrl : url
		});

	}


</script>

<!-- 무역애로사항 건의 - 애로건의 현황 리스트 -->
<div class="page_tradesos">
	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_detail(0)">신규</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(regulationSuggestListSheet, '민관합동_수출상황실_현황', '');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_secondary" onclick="location.reload();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>

	<form name="searchForm" id="searchForm" method="get" onsubmit="return false;">
		<input type="hidden" name="pageIndex" id="pageIndex" value="<c:out value='${pageIndex}' default='1' />" />
		<table class="formTable">
			<colgroup>
				<col style="width:9%">
				<col>
				<col style="width:9%">
				<col>
				<col style="width:9%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">업체명</th>
					<td>
						<input type="text" id="compny_nm" name="compnyNm" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
					<th scope="row">무역업번호</th>
					<td>
						<input type="text" id="trade_num" name="tradeNum" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
					<th scope="row">건의구분</th>
					<td>
						<select name="reqTypeCd" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${code133}" varStatus="status">
								<option value="<c:out value="${reslutData.cdId}"/>"><c:out value="${reslutData.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">진행상태</th>
					<td>
						<select name="proState" id="proState" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${code146}" varStatus="status">
								<option value="<c:out value="${reslutData.cdId}"/>" <c:if test="${param.proState eq reslutData.cdId}">selected="selected"</c:if>><c:out value="${reslutData.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">신청채널</th>
					<td>
						<select name="reqChannel" id="reqChannel" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${code110}" varStatus="status">
								<option value="<c:out value="${reslutData.cdId}"/>"><c:out value="${reslutData.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">분야</th>
					<td>
						<select name="reqRgfHight" id="reqRgfHight" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${codeRgf}" varStatus="status">
								<option value="<c:out value="${reslutData.cdId}"/>"><c:out value="${reslutData.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td>
						<input type="text" id="reqTitle" name="reqTitle" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
					<th scope="row">등록일</th>
					<td>
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="recDateFrom" name="recDateFrom" value="${param.recDateFrom}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="clearPickerValue('recDateFrom');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="recDateTo" name="recDateTo" value="${param.recDateTo}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="clearPickerValue('recDateTo');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>
						</div>
					</td>
					<th scope="row">지역</th>
					<td>
						<select name="reqArea" id="reqArea" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${code120}" varStatus="status">
								<option value="<c:out value="${reslutData.cdId}"/>"><c:out value="${reslutData.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- // 검색 테이블-->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select" title="목록수">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
	</div>
	</form>
	<!-- 리스트 테이블 -->
	<div class="tbl_list">
		<div id='regulationSuggestListSheet' class="colPosi"></div>
	</div>

	<!-- .paging-->
	<div class="paging" id="paging">
	</div><!-- //.paging-->
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function() {
		// 시작일 선택 이벤트
		datepickerById('recDateFrom', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('recDateTo', toDateSelectEvent);

		//IBSheet 호출
		f_Init_probleSuggestListSheet();		// 리스트  Sheet 셋팅
		getList();				// 목록 조회
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#recDateFrom').val());

		if ($('#recDateTo').val() != '') {
			if (startymd > Date.parse($('#recDateTo').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#recDateFrom').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#recDateTo').val());

		if ($('#recDateFrom').val() != '') {
			if (endymd < Date.parse($('#recDateFrom').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#recDateTo').val('');

				return;
			}
		}
	}

	function f_Init_probleSuggestListSheet()
	{
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "seq"		, SaveName: "sosSeq"		, Align: "Center"	, Width: 0, Hidden: true});
		ibHeader.addHeader({Type: "Text", Header: "No"		, SaveName: "contentNum"	, Align: "Center"	, Width: 50});
		ibHeader.addHeader({Type: "Text", Header: "제목"		, SaveName: "reqTitle"		, Align: "left"		, Width: 440, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "업체명"	, SaveName: "compnyNm"		, Align: "left"	, Width: 200});
		ibHeader.addHeader({Type: "Text", Header: "담당자"	, SaveName: "conName"		, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "분야"		, SaveName: "reqRgfHight"	, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "신청채널"	, SaveName: "reqChannel"	, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "지역"		, SaveName: "reqAreaNm"	    , Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "등록일"	, SaveName: "reqDate"		, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "공개여부"	, SaveName: "openYn"		, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "상태"		, SaveName: "proStateNm"	, Align: "Center"	, Width: 80});

		var sheetId = "regulationSuggestListSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	};

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		//$('#pageIndex').val(pageIndex);
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {

		global.ajax({
			url: '/tradeSOS/problem/regulationFreeSuggestListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#searchForm').serialize(),
			success: function (data) {
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCount) + '</span> 건');
				setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				regulationSuggestListSheet.LoadSearchData({Data: data.resultList});
				regulationSuggestListSheet.SetColFontBold('reqTitle', 1);

			},
			error:function(request,status,error) {
				alert('수출입 규제프리365 현황 조회에 실패했습니다.');
			}
		});
	}

	// 상세 페이지 & 팝업
	function regulationSuggestListSheet_OnClick(Row, Col) {
		if(regulationSuggestListSheet.ColSaveName(Col) == "reqTitle" && Row > 0) {
			var sos_Seq = regulationSuggestListSheet.GetCellValue(Row, "sosSeq");
			fn_detail(sos_Seq);
		}
	};

</script>