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

<div class="flex">
	<h2 class="popup_title">무역업체 검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<!-- 무역업체 검색 팝업 -->
<div id="coSearchPop" class="layerPopUpWrap popup_body" style="width: 950px; height: 500px;">
	<div class="layerPopUp">
		<div class="layerWrap">
			<div class="box">
				<form id="tradeForm" name="tradeForm">
					<input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
					<table class="boardwrite formTable">
						<colgroup>
							<col style="width:15%">
							<col >
							<col style="width:15%">
							<col >
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">무역업/사업자 번호</th>
								<td>
									<div class="flex align_center">
										<select id="searchCnd" name="searchCnd" onchange="doTradeSearch();" class="form_select">
											<option value="" selected="">전체</option>
											<option value="memberId">무역업 번호</option>
											<option value="enterRegNo">사업자 번호</option>
										</select>
										<input type="text" id="searchKeyword" name="searchKeyword" class="form_text w100p ml-8" value="<c:out value="${searchVO.searchKeyword}"/>" onkeydown="onEnter(doSearch);">
									</div>
								</td>
								<th scope="row">업체명</th>
								<td>
									<div class="flex align_center">
										<span class="form_search w100p">
											<input type="text" id="searchKeyword2" name="searchKeyword2" class="form_text w100p" value="" onkeydown="onEnter(doSearch);">
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				<div id='tradeSearch' class="colPosi mt-20"></div>
				<!-- .paging-->
				<div id="tradePaging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
				<!-- //.paging-->
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter""></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function()
	{							//IBSheet 호출
		f_Init_tradeSearch();		// 헤더  Sheet 셋팅

		<c:if test="${param.searchKeyword eq '1'}">			//회사명 검색 팝업인 경우
			companySearch();
		</c:if>

		<c:if test="${param.searchKeyword eq '2'}">			//무역업 고유번호 검색 팝업인 경우
			tradeNoSearch();
		</c:if>

		<c:if test="${param.searchKeyword eq '3'}">			//사업자등록번호 검색 팝업인 경우
			businessNoSearch();
		</c:if>
		tradeSearch.LoadSearchData(''); //조회된 데이터가 없습니다. 띄우기
	});

	function f_Init_tradeSearch() {

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text", Header: "무역업 번호"	, SaveName: "memberId"		, Align: "Center"	, Width: 100	,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회사명"		, SaveName: "companyKor"	, Align: "Left"		, Width: 180	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "대표자"		, SaveName: "presidentKor"	, Align: "Center"	, Width: 90		,Edit : false	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "사업자번호"	, SaveName: "enterRegNo"	, Align: "Center"	, Width: 120	,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회원사"		, SaveName: "memberGubun"	, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회비납부"		, SaveName: "feeChk"		, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "kor_addr1"	, SaveName: "korAddr1"		, Hidden : true});
		ibHeader.addHeader({Type: "Text", Header: "kor_addr2"	, SaveName: "korAddr2"		, Hidden : true});
		ibHeader.addHeader({Type: "Text", Header: "tel_etc"		, SaveName: "telEtc"		, Hidden : true});
		ibHeader.addHeader({Type: "Text", Header: "fax_etc"		, SaveName: "faxEtc"		, Hidden : true});
		ibHeader.addHeader({Type: "Text", Header: "city_cd"		, SaveName: "cityCd"		, Hidden : true});

		if (typeof tradeSearch !== "undefined" && typeof tradeSearch.Index !== "undefined") {
			tradeSearch.DisposeSheet();
		}

		var sheetId = "tradeSearch";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "400px");
		ibHeader.initSheet(sheetId);

	}

	<%--// 무역업체 검색--%>
	<%--function fnCompanySearch(){--%>
	<%--	$("input[name=searchWrd]").val("");--%>
	<%--	$("input[name=searchWrd2]").val("");--%>
	<%--	$("select[name=searchCnd]").val("");--%>
	<%--	let searchType = '<c:out value="${searchVO.searchCnd}"/>';--%>
	<%--	let searchWord = '<c:out value="${searchVO.searchWrd}"/>';--%>

	<%--	if (searchType == "name"){--%>
	<%--		$("input[name=searchWrd2]").val(searchWord);--%>
	<%--	}else{--%>
	<%--		$("select[name=searchCnd]").val(searchType);--%>
	<%--		$("input[name=searchWrd]").val(searchWord);--%>
	<%--	}--%>
	<%--	companyDataList(tblSheet);	//목록 조회--%>
	<%--}--%>


	//tblSheet.SetMessageText("NoDataRow", "변경할 메시지") ;

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.tradeForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList(){	 											//무역업체 목록 조회
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/com/layer/companySearchListAjax.do" />'
			, data : $('#tradeForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(
						'tradePaging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				tradeSearch.LoadSearchData({Data: data.resultList});
				tradeSearch.SetColFontBold('companyKor', 1);

			}
		});

	}

	function companySearch() {										//회사명 검색
		<c:if test="${not empty param.companyNm}">					//수정에서 검색한 경우
		$('#searchKeyword2').val('<c:out value="${param.companyNm}"/>');
		</c:if>
	}

	function tradeNoSearch() {										//무역업고유번호 검색
		<c:if test="${not empty param.tradeNum}">					//수정에서 검색한 경우
		$('#searchKeyword').val('<c:out value="${param.tradeNum}"/>');
		</c:if>
		$("#searchCnd").val('memberId').prop("selected",true);		//무역업 번호 선택 (select)
	}

	function businessNoSearch() {									//사업자등록번호 검색
		<c:if test="${not empty param.regNo}">						//수정에서 검색한 경우
		$('#searchKeyword').val('<c:out value="${param.regNo}"/>');
		</c:if>
		$("#searchCnd").val('enterRegNo').prop("selected",true);	//사업자 번호 선택 (select)
	}

	// 상세 페이지 & 팝업
	function tradeSearch_OnClick(Row, Col, Value) {
		if(tradeSearch.ColSaveName(Col) == "companyKor" && Row > 0) {
			var rowData = tradeSearch.GetRowData(Row);
			layerPopupCallback(rowData);
			closeLayerPopup();
		}
	};
</script>