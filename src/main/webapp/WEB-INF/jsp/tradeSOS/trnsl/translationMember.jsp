<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : topMenu.jsp
  * @Description : 대메뉴 목록화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2016.04.28	이인오		최초 생성
  *
  * @author 이인오
  * @since 2016.04.28
  * @version 1.0
  * @see
  *
  */
%>
<script type="text/javascript" src="/js/tradeSosComm.js"></script>

<form name="searchForm" id="searchForm" method="get">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
	<input type="hidden" name="searchExpertId" id="searchExpertId" value=""/>
	<input type="hidden" name="procType" id="procType" value=""/>
<!-- 컨설턴트/전문가 관리 - 통번역 전문위원 리스트 -->

<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>

</div>

<div class="page_tradesos">
	<table class="formTable">
		<colgroup>
			<col style="width:10%">
			<col>
			<col style="width:10%">
			<col>
			<col style="width:10%">
			<col>
			<col style="width:10%">
			<col>
		</colgroup>
		<tbody>

			<tr>
				<th scope="row">언어</th>
				<td>
					<select name="searchLanguage" id="searchLanguage" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${languageList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchLanguage}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">소재지</th>
				<td>
					<select name="searchRegion" id="searchRegion" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${regionList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchRegion}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">선호문서</th>
				<td>
					<select name="searchFavorDoc" id="searchFavorDoc" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${favorDocList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchFavorDoc}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">전문분야</th>
				<td>
					<select name="searchTransGubun" id="searchTransGubun" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${transGubunList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchTransGubun}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">성명</th>
				<td>
					<input type="text" id="searchKeyword" name="searchKeyword" class="form_text w100p" maxlength="10" onkeypress="press(event);" value="<c:out value="${searchVO.searchKeyword}"/>" onkeypress="press(event);">
				</td>
				<th scope="row">품목군</th>
				<td>
					<select name="searchItemType" id="searchItemType" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${itemTypeList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchItemType}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">활동구분</th>
				<td>
					<select name="searchStYn" id="searchStYn" class="form_select w100p">
						<option value="">전체</option>
						<option value="N" <c:if test="${searchVO.searchStYn eq 'N'}">selected</c:if>>활동</option>
						<option value="Y" <c:if test="${searchVO.searchStYn eq 'Y'}">selected</c:if>>자리비움</option>
					</select>
				</td>
				<th scope="row">기수</th>
				<td>
					<select name="searchOrderNo" id="searchOrderNo" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${orderNoList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchOrderNo}">selected</c:if>><c:out value="${item.cdNm}"/></option>
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

	<!-- 리스트 테이블 -->
	<div class="tbl_list">
		<div id='translationSheet' class="colPosi"></div>
	</div>

	<!-- .paging-->
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	<!-- //.paging-->

</div> <!-- // .page_tradesos -->
</form>

<script type="text/javascript">


	$(document).ready(function()
		{							//IBSheet 호출
			f_Init_translationSheet();		// 헤더  Sheet 셋팅
		    getList();	//목록 조회
	});

	function f_Init_translationSheet() {
		// 세팅
		var	ibHeader	=	new	IBHeader();

		 /** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text"	, Header: "언어"		, SaveName: "langName"	, Align: "Center"	, Width: 130});
		ibHeader.addHeader({Type: "Text"	, Header: "성명"		, SaveName: "name"		, Align: "Center"	, Width: 150	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text"	, Header: "소재지"	, SaveName: "regionNm"	, Align: "Center"		, Width: 120});
		ibHeader.addHeader({Type: "Text"	, Header: "휴대전화"	, SaveName: "tel"		, Align: "Center"	, Width: 120});
		ibHeader.addHeader({Type: "Text"	, Header: "활동구분"	, SaveName: "stYnNm"	, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text"	, Header: "기수"		, SaveName: "orderNo"	, Align: "Center"	, Width: 100});
		ibHeader.addHeader({Type: "Text"	, Header: "학력"		, SaveName: "scholar"	, Align: "Left"		, Width: 240	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text"	, Header: "경력"		, SaveName: "career"	, Align: "Left"		, Width: 240	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text"	, Header: "아이디"	, SaveName: "expertId"	, Align: "Center"	, Width: 0		, Hidden: true});

	    var sheetId = "translationSheet";
		var container = $("#"+sheetId)[0];
	    createIBSheet2(container,sheetId, "100%", "100%");
	    ibHeader.initSheet(sheetId);

	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList(pageIndex){
		var jsonListData = [];

		if(pageIndex){
			$('#pageIndex').val(pageIndex);
		}

		global.ajax({
			type:"get",
			url:"/tradeSOS/com/translationMemberListAjax.do",
			data:$('#searchForm').serializeArray(),
			async:false,
			success:function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);
				translationSheet.LoadSearchData({Data: data.resultList});
				translationSheet.SetColFontBold('name', 1);
			}
		});
	}

	// 상세
	function translationSheet_OnClick(Row, Col, Value) {
		if(translationSheet.ColSaveName(Col) == "name" && Row > 0){
			fn_detail(translationSheet.GetCellValue(Row,"expertId"));
		}
	};

	function press(event) {
		if (event.keyCode==13) {
			getList();
		}
	}

	function fn_detail(expertid) {
		document.searchForm.action = "/tradeSOS/com/translationMemberDetail.do";
		document.searchForm.searchExpertId.value = expertid;
		document.searchForm.procType.value = "U";
		document.searchForm.submit();
	}

</script>