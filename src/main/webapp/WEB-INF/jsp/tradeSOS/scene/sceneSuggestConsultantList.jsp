<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_detail(0)">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<!-- 무역현장 컨설팅 리스트 -->
<div class="cont_block">
	<form name="searchForm" id="searchForm" action ="" method="post">
		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
		<input type="hidden" name="no" id="no" value="0"/>
		<div class="foldingTable fold">
			<div class="foldingTable_inner">
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
					<%--			<div class="flex align_center">
									<select name="searchCnd" class="form_select">
										<option value="">전체</option>
										<option value="company" <c:if test="${searchVO.searchCondition eq 'company'}">selected</c:if>>업체명</option>
										<option value="companyNo" <c:if test="${searchVO.searchCondition eq 'companyNo'}">selected</c:if>>사업자번호</option>
									</select>
									<input type="text" name="searchKeyword" class="form_text w100p" value="<c:out value="${searchVO.searchKeyword}"/>">
								</div>--%>
								<input type="text" name="company" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.company}"/>">
							</td>
							<th scope="row">사업자번호</th>
							<td>
								<input type="text" name="companyNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.companyNo}"/>">
							</td>
							<th scope="row">무역업번호</th>
							<td>
								<input type="text" name="tradeNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.tradeNo}"/>">
							</td>
							<!--
							<th scope="row">답변 내용</th>
							<td>
								<input type="text" name="content" class="form_text w100p" value="<c:out value="${searchVO.content}"/>">
							</td>
							 -->
						</tr>
						<tr>
							<th scope="row">신청자</th>
							<td>
								<input type="text" name="applyName" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.applyName}"/>">
							</td>
							<th scope="row">담당위원</th>
							<td>
								<div class="field_set flex align_center">
									<span class="form_search w100p">
										<input class="form_text w100p" type="text" onkeydown="onEnter(doSearch);" id="expertNm" name="expertNm" value="<c:out value="${searchVO.expertNm}"/>"/>
										<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="fnExpertSearch();" title="검색"></button>
									</span>
									<button type="button" class="ml-8" onclick="mtiClearDate('expertNm');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</td>
							<th scope="row">상태</th>
							<td>
								<select name="status" class="form_select w100p">
									<option value="">전체</option>
									<option value="N" <c:if test="${searchVO.status eq 'N'}">selected</c:if>>신청</option>
									<option value="S" <c:if test="${searchVO.status eq 'S'}">selected</c:if>>배정</option>
									<option value="Y" <c:if test="${searchVO.status eq 'Y'}">selected</c:if>>완료</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">자문 분야</th>
							<td>
								<select name="sect" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="data" items="${code029}" varStatus="status">
										<option value="<c:out value="${data.cdId}"/>" <c:if test="${searchVO.sect eq data.cdId}">selected</c:if>><c:out value="${data.cdNm}"/></option>
									</c:forEach>
								</select>
							</td>
							<th scope="row">취급품목</th>
							<td>
								<div class="field_set flex align_center">
									<span class="form_search w100p">
										<input class="form_text w100p" type="text" id="item" name="item" value="<c:out value="${searchVO.item}"/>" readonly>
										<input type="hidden" id="mtiCode" name="mtiCode" value="<c:out value="${searchVO.mtiCode}"/>">
										<input type="hidden" id="mtiUnit" name="mtiUnit" value="<c:out value="${searchVO.mtiUnit}"/>"  default='0'>
										<button type="button" class="btn_icon btn_search" onclick="openLayerItemPop();" title="검색"></button>
									</span>
									<button type="button" class="ml-8" onclick="mtiClearDate('mtiCode');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</td>
							<th scope="row">제목</th>
							<td>
								<input type="text" name="title" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.title}"/>">
							</td>
						</tr>
						<tr>
							<th scope="row">접수경로</th>
							<td colspan="1" class="blindCheckbox">
								<label class="label_form" style="padding-right: 15px;">
									<input type="checkbox" name="searchKeyword"  value="" class="form_checkbox uniqueCheck" onchange="blindCheck(this)" <c:out value="${searchVO.searchKeyword eq '999' ? 'checked' : ''}"/>>
									<span class="label">전체</span>
								</label>
								<label class="label_form" style="padding-right: 15px;">
									<input type="checkbox" name="searchKeyword"  value="4" class="form_checkbox normalCheck" onchange="blindCheck(this)" <c:out value="${searchVO.searchKeyword eq '4' ? 'checked' : ''}"/>>
									<span class="label">온라인</span>
								</label>
								<label class="label_form" style="padding-right: 15px;">
									<input type="checkbox" name="searchKeyword"  value="1" class="form_checkbox normalCheck" onchange="blindCheck(this)" <c:out value="${searchVO.searchKeyword eq '1' ? 'checked' : ''}"/>>
									<span class="label">자문위원</span>
								</label>
							</td>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<!-- datepicker -->
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sStartDate" name="frDt" value="${searchVO.frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											<input type="hidden" id="dummyStartDate" value="" />
										</span>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="mtiClearDate('sStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>

									<div class="spacing">~</div>

									<!-- datepicker -->
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="sEndDate" name="toDt" value="${searchVO.toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											<input type="hidden" id="dummyEndDate" value="" />
										</span>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="mtiClearDate('sEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</div>
							</td>
							<th scope="row">답변 내용</th>
							<td>
								<input type="text" name="content" class="form_text w100p" value="<c:out value="${searchVO.content}"/>">
							</td>
						</tr>
					</tbody>
				</table><!-- // 검색 테이블-->
			</div>
			<button type="button" class="btn_folding" id="btnFolding" title="테이블접기"></button>
		</div>
		<div class="cont_block mt-20">
			<div class="tbl_opt">
				<!-- 상담내역조회 -->
				<div id="totalCnt" class="total_count"></div>

				<fieldset class="ml-auto">
					<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
						<c:forEach var="item" items="${pageUnitList}" varStatus="status">
							<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
						</c:forEach>
					</select>
				</fieldset>
			</div>
			<!-- 리스트 테이블 -->
			<div style="width: 100%;height: 100%;">
				<div id='tblGridSheet' class="colPosi"></div>
			</div>
			<!-- .paging-->
			<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
			<!-- //.paging-->
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	var f;
	$(document).ready(function () {
		f = document.searchForm;

		$("#sStartDate").on("change",function(){
			var startymd = Date.parse($(this).val());
			if($("#sEndDate").val()!=""){
				if(startymd> Date.parse($("#sEndDate").val())){
					alert("시작일은 종료일보다 클 수 없습니다");
					$(this).val("");
					return;
				}
			}
		});

		$("#sEndDate").on("change",function(){
			var endymd = Date.parse($(this).val());
			if($("#sStartDate").val()!=""){
				if(endymd < Date.parse($("#sStartDate").val())){
					alert("종료일은 시작일보다 작을 수 없습니다");
					$(this).val("");
					return;
				}
			}
		});
		$( "#searchForm input" ).keypress(function( event ) {
			if ( event.which == 13 ) {
				dataList(1);
				event.preventDefault();

			}
		});


		// 대쉬보드에서 값 넘어올떄
		if($("#searchKeyword").val() != "" && $("#sStartDate").val() != "") {
			document.getElementById('btnFolding').click();
		}

		// 시작일 선택 이벤트
		datepickerById('sStartDate', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('sEndDate', toDateSelectEvent);

		f_Init_tblGridSheet();  //상담내역조회 Sheet

		getList(); // 조회
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStartDate').val());

		if ($('#sEndDate').val() != '') {
			if (startymd > Date.parse($('#sEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEndDate').val());

		if ($('#sStartDate').val() != '') {
			if (endymd < Date.parse($('#sStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEndDate').val('');

				return;
			}
		}
	}

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "no", SaveName: "no", Align: "Center", Width: 70,Hidden:true});
		ibHeader.addHeader({Type: "Text", Header: "번호", SaveName: "vnum", Align: "Center", Width: 50});
		ibHeader.addHeader({Type: "Text", Header: "제목", SaveName: "title", Align: "Left", Ellipsis:1, Width: 260, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "업체명", SaveName: "company", Align: "Left",  Ellipsis:1, Width: 150});
		ibHeader.addHeader({Type: "Text", Header: "신청자", SaveName: "applyName", Align: "Center", Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "자문분야", SaveName: "sectNm", Align: "Center", Width: 150});
		ibHeader.addHeader({Type: "Text", Header: "취급품목", SaveName: "itemNm", Align: "Center", Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "등록일", SaveName: "regstDt", Align: "Center", Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "담당위원", SaveName: "expertNm", Align: "Center", Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "상태", SaveName: "statusNm", Align: "Center", Width: 80});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "400px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetEditable(0);

	};

	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('tblGridSheet_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblGridSheet.SetColFontBold('title', 1);
		}
	}

	function tblGridSheet_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('tblGridSheet', row);
	}

	// 담당위원
	function fnExpertSearch() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/popup/expertSearchLayer.do" />'
			, callbackFunction : function(resultObj){

				console.log(resultObj);
				$("input[name=expertNm]").val(resultObj.expertNm);
			}
		});
	}

	// 취급품목
	function openLayerItemPop(){
		//기본값 초기화
		$('#searchUnit').val('');
		$('#mtiCode').val('');
		$('#item').data('unit','0');

		//품목별 초기화 추가
		$('#searchMtiNmPop').val('');

		global.openLayerPopup({
				popupUrl : '/tradeSOS/com/popup/professionalField.do'
			, callbackFunction : function(resultObj) {
				var appendCode = "";
				var appendName = "";
				var appendUnit = "";
				for(var i = 0; i < resultObj.mtiKorArray.length; i++)							//선택한 행의 갯수만큼
				{
					if(appendCode != "" && appendName != "")									//첫 추가 외 경우 ',' 추가
					{
						appendCode += ','+resultObj.mtiCodeArray[i];
						appendName += ','+resultObj.mtiKorArray[i];
					}
					if(appendCode == "" && appendName == "")									//처음은 값만 입력
					{
						appendCode += resultObj.mtiCodeArray[i];
						appendName += resultObj.mtiKorArray[i];
						appendUnit += resultObj.mtiUnitArray[i];
					}
					$('#item').val(appendName);
					$('#mtiCode').val(appendCode);
					$('#mtiUnit').val(appendUnit);
				}

			}
		});

	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	// 검색
	function getList(pageIndex){

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestConsultantListAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	// 상세
 	function tblGridSheet_OnClick(Row, Col, Value) {
		if(tblGridSheet.ColSaveName(Col) == "title" && Row > 0) {
			var no = tblGridSheet.GetCellValue(Row, "no");
			fn_detail(no);
		}

	};

	// 상담내역 조회 상세
	function fn_detail( no) {
		if (no > 0){
			$("#no").val(no);
			f.action = '<c:url value="/tradeSOS/scene/sceneSuggestConsultantListDetail.do" />';
			f.method = 'POST'
			f.target = '_self';
			f.submit();
		}else{
			f.action = '<c:url value="/tradeSOS/scene/sceneSuggestConsultantListRegist.do" />';
			f.method = 'POST'
			f.target = '_self';
			f.submit();
		}

	}

	function mtiClearDate( targetId){
		if (targetId == 'mtiCode'){
			//기본값 초기화
			$('#searchUnit').val('');
			$('#mtiCode').val('');
			$('#item').val('');
			$("#mtiCodeArr").val("");
			$("#mtiUnit").val(0);

			//품목별 초기화 추가
			$('#searchMtiNmPop').val('');
		}else{
			$("#"+targetId).val("");
		}
	}

	function press(event) {
		if (event.keyCode==13) {

		}
	}
</script>
