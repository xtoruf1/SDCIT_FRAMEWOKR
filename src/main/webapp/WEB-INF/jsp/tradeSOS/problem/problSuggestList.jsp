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


	function openLayerPopup(seq) {								//상세보기 레이어 팝업
		var url = '';
		if (seq > 0){
			url = "/tradeSOS/problem/popup/problSuggestListDetailPop.do?sosSeq="+seq;
		}else{
			url = "/tradeSOS/problem/popup/problSuggestListRegPop.do";
		}
			global.openLayerPopup({
				popupUrl : url
			});
	}

	function goWrite() {										//등록페이지 이동
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/problSuggestListRegPop.do'
		});
	}

</script>

<!-- 무역애로사항 건의 - 애로건의 현황 리스트 -->
<div class="page_tradesos">

	<!-- 검색 테이블 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(probleSuggestListSheet, '무역애로건의형황', '');">엑셀 다운</button>
			<button type="button" class="btn_sm btn_secondary" onclick="location.reload();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
<%--		(사용하지 않는 메뉴라 신규등록 주석처리됨.)	<button type="button" class="btn_sm btn_primary" onclick="goWrite();">신규</button>--%>
		</div>
	</div>

	<form name="searchForm" id="searchForm" method="get" onsubmit="return false;">
		<input type="hidden" name="pageIndex" id="pageIndex" value="<c:out value='${pageIndex}' default='1' />"/>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col>
				<col style="width:10%">
				<col style="width:21%">
				<col style="width:10%">
				<col style="width:21%">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">업체명</th>
					<td>
						<input type="text" id="compnyNm" name="compnyNm" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
					<th scope="row">무역업번호</th>
					<td>
						<input type="text" id="tradeNum" name="tradeNum" class="form_text w100p" onkeydown="onEnter(doSearch);">
					</td>
					<th scope="row">건의구분</th>
					<td>
						<select id="reqTypeCd" name="reqTypeCd" class="form_select w100p">
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
								<option value="<c:out value="${reslutData.cdId}"/>"><c:out value="${reslutData.cdNm}"/></option>
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
						<select name="reqCatHight" id="reqCatHight" class="form_select w100p">
							<option value="">전체</option>
							<c:forEach var="reslutData" items="${codeCat}" varStatus="status">
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
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="recDateFrom" name="recDateFrom" value="" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('recDateFrom');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
							<div class="spacing">~</div>
							<!-- datepicker -->
							<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="recDateTo" name="recDateTo" value="" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('recDateTo');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
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
	<!-- 리스트 테이블 -->
	<div class="tbl_list">
		<div id='probleSuggestListSheet' class="colPosi"></div>
	</div>

	</form>
	<!-- .paging-->
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	<!-- //.paging-->
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

		ibHeader.addHeader({Type: "Text", Hidden: true			, SaveName: "sosSeq"		, Align: "Center"	, Width: 0		, Header: "seq"});
		ibHeader.addHeader({Type: "Text", Header: "No"			, SaveName: "contentNum"	, Align: "Center"	, Width: 50});
		ibHeader.addHeader({Type: "Text", Header: "제목"			, SaveName: "reqTitle"		, Align: "Left"		, Width: 460	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "업체명"		, SaveName: "compnyNm"		, Align: "Left"		, Width: 150});
		ibHeader.addHeader({Type: "Text", Header: "담당자"		, SaveName: "conName"		, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text", Header: "분야"			, SaveName: "reqCatHight"	, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "신청채널" 	, SaveName: "reqChannel"	, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "등록일"		, SaveName: "reqDate"		, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "상태"			, SaveName: "proStateNm"	, Align: "Center"	, Width: 80});
		var sheetId = "probleSuggestListSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	};

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {

		global.ajax({
			type: "post",
			url: "/tradeSOS/problem/problSuggestListAjax.do",
			data: $('#searchForm').serializeArray(),
			async:false,
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

				probleSuggestListSheet.LoadSearchData({Data: data.resultList});
				probleSuggestListSheet.SetColFontBold('reqTitle', 1);
			},
			error:function(request,status,error) {
				alert('애로건의 현황 조회에 실패했습니다.');
			}
		});
	}

		$("#recDateFrom").on("change",function(){
			var startymd = Date.parse($(this).val());
			if($("#recDateTo").val()!=""){
				if(startymd> Date.parse($("#recDateTo").val())){
					alert("시작일은 종료일 이전이어야 합니다.");
					$(this).val("");
					return;
				}
			}
		});

		$("#recDateTo").on("change",function(){
			var endymd = Date.parse($(this).val());
			if($("#recDateFrom").val()!=""){
				if(endymd < Date.parse($("#recDateFrom").val())){
					alert("종료일은 시작일 이후여야 합니다.");
					$(this).val("");
					return;
				}
			}
		});

	// 상세 페이지 & 팝업
	function probleSuggestListSheet_OnClick(Row, Col) {
		if(probleSuggestListSheet.ColSaveName(Col) == "reqTitle" && Row > 0) {
			var sos_Seq = probleSuggestListSheet.GetCellValue(Row, "sosSeq");
			openLayerPopup(sos_Seq);
		}
	};


</script>