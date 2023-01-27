<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : areaSuggestList.jsp
  * @Description : 분야별 전문가 자문 리스트 화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2021.10.06	양지환		최초 생성
  *
  * @author 양지환
  * @since 2021.10.06
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

	function doDetail(reqId) {
		$("#reqId").val(reqId);
		$("#searchForm").attr("action","/consultant/area/areaSuggestListDetail.do");
		$("#searchForm").submit();

	}

	function goWrite(){
		$("#searchForm").attr("action","/consultant/area/areaSuggestListRegist.do");
		$("#searchForm").submit();
	}
	$(document).ready(function(){

	})

	</script>



	<!-- 분야별전문가 자문 - 리스트 -->
	<div class="page_tradesos">
		<!-- 페이지 위치 -->
		<div class="location compact">
			<!-- 네비게이션 -->
			<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
			<!-- 네비게이션 -->
			<div class="ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="goWrite();">신규</button>
			</div>
			<div class="ml-15">
				<button type="button" class="btn_sm btn_secondary" onclick="doReset();">초기화</button>
				<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
			</div>
		</div>
		<form name="searchForm" id="searchForm" action ="" method="get">
			<input type="hidden" name="pageIndex" id="pageIndex" value="<c:out value="${searchVO.pageIndex}"/>"/>
			<input type="hidden" name="reqId" id="reqId" value="0"/>
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
					<th scope="row">상담분야</th>
					<td>
						<select name="reqTp" id="reqTp" class="form_select w100p">
							<option value="000">전체</option>
							<c:forEach var="data" items="${code026}" varStatus="status">
								<option value="<c:out value="${data.cdId}"/>" <c:out value="${searchVO.reqTp eq data.cdId ? 'selected' : ''}"/>><c:out value="${data.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">접수채널</th>
					<td>
						<select name="chnnelTp" id="chnnelTp" class="form_select w100p">
							<c:forEach var="data" items="${code135}" varStatus="status">
								<option value="<c:out value="${data.cdId}"/>" <c:out value="${searchVO.chnnelTp eq data.cdId ? 'selected' : ''}"/>><c:out value="${data.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">진행상태</th>
					<td>
						<select name="req_status" id="reqㄴtatus" class="form_select w100p">
							<c:forEach var="data" items="${code136}" varStatus="status">
								<option value="<c:out value="${data.cdId}"/>" <c:out value="${searchVO.reqStatus eq data.cdId ? 'selected' : ''}"/>><c:out value="${data.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">무역업번호</th>
					<td>
						<input type="text" id="tradeNo" name="tradeNo" class="form_text w100p" value="<c:out value="${searchVO.tradeNo}"/>">
					</td>
					<th scope="row">제목</th>
					<td>
						<input type="text" id="reqTitle" name="reqTitle" class="form_text w100p" value="<c:out value="${searchVO.reqTitle}"/>">
					</td>
					<th scope="row">답변 내용</th>
					<td>
						<input type="text" id="resultQ" name="resultQ" class="form_text w100p" value="<c:out value="${searchVO.resultQ}"/>">
					</td>
				</tr>
				<tr>
					<th scope="row">공개여부</th>
					<td>
						<select name="openFg" id="openFg" class="form_select w100p">
							<option value="">전체</option>
							<option value="Y" <c:if test="${searchVO.openFg eq 'Y'}">selected</c:if>>공개</option>
							<option value="N" <c:if test="${searchVO.openFg eq 'N'}">selected</c:if>>비공개</option>
						</select>
					</td>

					<th scope="row">등록일</th>
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="frDt" name="frDt" value="<c:out value="${searchVO.frDt}"/>" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartDate" value="" />
						</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('frDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="toDt" name="toDt" value="<c:out value="${searchVO.toDt}"/>" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyEndDate" value="" />
						</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('toDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
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
			<div id='areSuggestListSheet' class="colPosi"></div>
		</div>
		</form>

		<!-- .paging-->
		<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
		<!-- //.paging-->

	</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function() {

		// 시작일 선택 이벤트
		datepickerById('frDt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('toDt', toDateSelectEvent);


		f_Init_areSuggestListSheet();		// 리스트  Sheet 셋팅
		getList();				// 목록 조회
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#frDt').val());

		if ($('#toDt').val() != '') {
			if (startymd > Date.parse($('#toDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#frDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#toDt').val());

		if ($('#frDt').val() != '') {
			if (endymd < Date.parse($('#frDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#toDt').val('');

				return;
			}
		}
	}

	function f_Init_areSuggestListSheet() {
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

			ibHeader.addHeader({Type: "Text", Header: "고유키"	, SaveName: "reqId"			, Align: "Center"	, Width: 50, Hidden: true});
			ibHeader.addHeader({Type: "Text", Header: "번호"		, SaveName: "rm"			, Align: "Center"	, Width: 50});
			ibHeader.addHeader({Type: "Text", Header: "제목"		, SaveName: "reqTitle"		, Align: "Left"		, Width: 250	, Ellipsis:1, Cursor: "Pointer"});
			ibHeader.addHeader({Type: "Text", Header: "업체명"	, SaveName: "companyNm"		, Align: "Left"		, Width: 100	, Ellipsis:1});
			ibHeader.addHeader({Type: "Text", Header: "상담분야"	, SaveName: "reqTpNm"		, Align: "Left"		, Width: 100});
			ibHeader.addHeader({Type: "Text", Header: "접수채널"	, SaveName: "chnnelTpNm"	, Align: "Center"	, Width: 70});
			ibHeader.addHeader({Type: "Text", Header: "상태"		, SaveName: "reqStatusNm"	, Align: "Center"	, Width: 70});
			ibHeader.addHeader({Type: "Text", Header: "신청자명"	, SaveName: "caerNm"		, Align: "Center"	, Width: 70});
			ibHeader.addHeader({Type: "Text", Header: "등록일"	, SaveName: "questionDt"	, Align: "Center"	, Width: 70});

		var sheetId = "areSuggestListSheet";
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
			url: '/consultant/area/areaSuggestListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#searchForm').serialize(),
			success: function (data) {
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.paginationInfo.totalRecordCount) + '</span> 건');
				setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				areSuggestListSheet.LoadSearchData({Data: data.resultList});
				areSuggestListSheet.SetColFontBold('reqTitle', 1);

			},
			error:function(request,status,error) {
				alert('무역실무 신청내역 조회에 실패했습니다.');
			}
		});
	}



	$( "#searchForm input" ).keypress(function( event ) {
		if ( event.which == 13 ) {
			getList();
			event.preventDefault();

		}
	});

	// 상세 페이지 & 팝업
	function areSuggestListSheet_OnClick(Row, Col) {
		if(areSuggestListSheet.ColSaveName(Col) == "reqTitle" && Row > 0) {
			var reqId = areSuggestListSheet.GetCellValue(Row, "reqId");
			doDetail(reqId);
		}
	};

	//초기화
	function doReset() {

	}

</script>