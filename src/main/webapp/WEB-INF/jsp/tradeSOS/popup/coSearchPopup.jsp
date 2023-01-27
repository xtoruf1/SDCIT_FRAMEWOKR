<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 무역업체 검색 팝업 -->
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">무역업체 검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>

</div>

<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:950px;">
			<div class="box">
				<form id="coSearchForm" name="coSearchForm">
					<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
					<table class="boardwrite formTable">
						<colgroup>
							<col style="width:20%">
							<col>
							<col style="width:20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">업체명</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="companyKor" name="companyKor" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
									</span>
								</td>
								<th scope="row">사업자 번호</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="enterRegNo" name="enterRegNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">대표자</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="presidentKor" name="presidentKor" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
									</span>
								</td>
								<th scope="row">무역업 번호</th>
								<td>
									<span class="form_search w100p">
										<input type="text" id="memberId" name="memberId" class="form_text w100p" onkeydown="onEnter(doSearch);" value="">
									</span>
								</td>
							</tr>
						</tbody>
					</table>
				</form>

				<div id='tradeSearch' class="colPosi mt-20"></div>

				<!-- .paging-->
				<div id="tradePaging" class="paging ibs"></div>
				<!-- //.paging-->
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter"></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function() { //IBSheet 호출
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

	});

	function f_Init_tradeSearch() {

		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text", Header: "무역업 번호"	, SaveName: "memberId"		, Align: "Center"	, Width: 100	,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회사명"		, SaveName: "companyKor"	, Align: "Left"		, Width: 180	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "대표자"		, SaveName: "presidentKor"	, Align: "Center"	, Width: 90		,Edit : false	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "사업자번호"	, SaveName: "enterRegNo"	, Align: "Center"	, Width: 120	,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회원사"		, SaveName: "memberGubun"	, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회비납부"		, SaveName: "feeChk"		, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "회원등급"		, SaveName: "memberGrade"	, Align: "Center"	, Width: 80		,Edit : false});
		ibHeader.addHeader({Type: "Text", Header: "바우처사용현황"	, SaveName: "vouYear"		, Align: "Center"	, Width: 100		,Edit : false});
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
		createIBSheet2(container,sheetId, "100%", "200px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tradeSearch.SetEditable(0);

	}

/*	// 무역업체 검색
	function fnCompanySearch(){
		$("input[name=searchKeyword]").val("");
		$("input[name=searchKeyword2]").val("");
		$("select[name=searchCnd]").val("");

		var searchType = '<c:out value="${searchVO.searchCondition}"/>';
		var searchWord = '<c:out value="${searchVO.searchKeyword}"/>';
		var searchWord2 = '<c:out value="${searchVO.searchKeyword2}"/>';

		if (searchType == "name"){
			$("input[name=searchKeyword2]").val(searchWord2);
		}else{
			$("select[name=searchCnd]").val(searchType);
			$("input[name=searchKeyword]").val(searchWord);
		}
		//companyDataList(1);
	}*/

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.coSearchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList(){	 //무역업체 목록 조회

		if ($("input[name=companyKor]").val().trim() == "" && $("input[name=enterRegNo]").val().trim() == "" && $("input[name=presidentKor]").val().trim() == ""
		 && $("input[name=memberId]").val().trim() == ""){
			alert("검색조건을 입력해주세요.");
			$("input[name=companyKor]").focus();
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/com/layer/companySearchListAjax.do" />'
			, data : $('#coSearchForm').serialize()
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
			}
		});

	}

	function companySearch() {										//회사명 검색
		var companyNm = $('#company').val();
		$('#companyKor').val(companyNm);
		if( companyNm != null && companyNm != ""){
			getList();
		}

	}

	function tradeNoSearch() {										//무역업고유번호 검색
		var tradeNum = $('#tradeNo').val();						//상세보기에 입력된 고유번호로 팝업창에 입력
		$('#memberId').val(tradeNum);
		if( tradeNum != null && tradeNum != ""){
			getList();
		}
		//$("#searchCnd").val('memberId').prop("selected",true);		//무역업 번호 선택 (select)
	}

	function businessNoSearch() {									//사업자등록번호 검색
		var regNo = $('#companyNo').val();								//상세보기에 입력된 사업자번호로 팝업창에 입력
		$('#enterRegNo').val(regNo);
		if( regNo != null && regNo != ""){
			getList();
		}
		//$("#searchCnd").val('enterRegNo').prop("selected",true);	//사업자 번호 선택 (select)
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