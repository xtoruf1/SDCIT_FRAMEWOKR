<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : cpSearchLayer.jsp
	 * @Description : 무역업체 검색 레이어
	 * @Modification Information
	 * @consultantMemberDetail
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2021.10.13	양지환		최초 생성
	 *
	 * @author 양지환
	 * @since 2021.10.13
	 * @version 1.0
	 * @see
	 *
	 */
%>

<!-- 직원검색 레이어팝업 -->
<div class="flex">
	<h2 class="popup_title">무역 협회 직원검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch2();">검색</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<form id="manageSearchForm" name="manageSearchForm" method="get" onsubmit="return false;">
	<input type="hidden" name="pageIndex" id="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<div class="popup_body">
		<div class="search" style="width: 600px;">
			<table class="formTable">
				<colgroup>
					<col style="width:15%">
					<col>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">부서</th>
						<td>
							<input type="text" name="deptNm" onkeydown="onEnter(doSearch2);" class="form_text w100p">
						</td>
						<th scope="row">성명</th>
						<td>
							<div class="flex align_center">
								<span class="form_search w100p">
									<input type="text" name="empKorNm" onkeydown="onEnter(doSearch2);" class="form_text w100p">
									<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="doEmpSearch()"></button>
								</span>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="w100p mt-20">
			<div id="employeeSearch" class="colPosi"></div>
		</div>
		<!-- .paging-->
		<div id="empPaging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	</div>
	<div class="overlay"></div>
</form>

<script type="text/javascript">

	$(document).ready(function()
	{									//IBSheet 호출
		f_Init_employeeSearch();		// 헤더  Sheet 셋팅
		getEmpList();
	});

	// 레이어팝업 외 영역 클릭 시 레이어팝업 닫기
	// 이벤트가 겹치는 관계로 잠깐 주석처리
	/*
 	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
	*/

	function f_Init_employeeSearch() {

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text", Header: "부서"		, SaveName: "deptNm"	, Align: "Center"	, Width: 70 });
		ibHeader.addHeader({Type: "Text", Header: "이름"		, SaveName: "empKorNm"	, Align: "Left"		, Width: 100	, Ellipsis:1	, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "연락처"	, SaveName: "cpTelno"	, Align: "Left"		, Width: 100	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "이메일"	, SaveName: "email"		, Align: "Left"		, Width: 100	, Ellipsis:1});

		if (typeof employeeSearch !== "undefined" && typeof employeeSearch.Index !== "undefined") {
			employeeSearch.DisposeSheet();
		}

		var sheetId = "employeeSearch";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

	}

	function doSearch2() {
		goPage2(1);
	}

	function goPage2(pageIndex) {
		document.manageSearchForm.pageIndex.value = pageIndex;
		getEmpList();
	}

	function getEmpList(){							//담당자 목록 조회
		global.ajax({
			type:"post",
			url:"/tradeSOS/problem/selectEmpListAjax.do",
			data:$('#manageSearchForm').serializeArray(),
			success:function(data){
				//$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCount) + '</span> 건');
				setPaging(
						'empPaging'
						, goPage2
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				employeeSearch.LoadSearchData({Data: (data.resultList || [] ) });
			}
		});
	}

	function employeeSearch_OnClick(Row, Col, Value)
	{
		if(employeeSearch.ColSaveName(Col) == "empKorNm" && Row > 0) {
			var param = {
				'empKorNm'	: employeeSearch.GetCellValue(Row,'empKorNm')
				,'deptNm'	: employeeSearch.GetCellValue(Row,'deptNm')
				,'cpTelno'	: employeeSearch.GetCellValue(Row,'cpTelno')
				,'email'	: employeeSearch.GetCellValue(Row,'email')
						}
			layerPopupCallback(param);
			closeLayerPopup();
		}
	}

</script>