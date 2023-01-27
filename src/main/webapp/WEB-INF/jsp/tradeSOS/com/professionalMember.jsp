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

<form name="searchForm" id="searchForm" action ="" method="post">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
	<input type="hidden" name="searchExpertId" id="searchExpertId" value=""/>
	<input type="hidden" name="procType" id="procType" value=""/>
<!-- 컨설턴트/전문가 관리 - 무역전문컨설턴트 리스트 -->
<div class="page_tradesos">
	<!-- 페이지 위치 -->
	<div class="location compact">
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 검색 테이블 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doInsert();">신규</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch(1);">검색</button>
		</div>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:15%">
			<col>
			<col style="width:15%">
			<col>
		</colgroup>
		<tbody>

			<tr>
				<th scope="row">상담분야</th>
				<td>
					<select name="searchCouncel" id="searchCouncel" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${counselingList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchCouncel}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">직함</th>
				<td>
					<select name="searchJob" id="searchJob" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${jobList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchJob}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">성명</th>
				<td>
					<input type="text" id="searchKeyword" name="searchKeyword" class="form_text w100p" maxlength="10" value="<c:out value="${searchVO.searchKeyword}"/>" onkeypress="press(event);">
				</td>
				<th scope="row">활동구분</th>
				<td>
					<select name="searchStYn" id="searchStYn" class="form_select w100p">
						<option value="">전체</option>
						<option value="N" <c:if test="${searchVO.searchStYn eq 'N'}">selected</c:if>>활동</option>
						<option value="Y" <c:if test="${searchVO.searchStYn eq 'Y'}">selected</c:if>>활동종료</option>
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
		<div id='tblSheet' class="colPosi"></div>
	</div>

	<!-- .paging-->
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	<!-- //.paging-->

</div> <!-- // .page_tradesos -->
</form>

<script type="text/javascript">

	$(document).ready(function()
	{							//IBSheet 호출
		f_Init_tblSheet();		// 리스트  Sheet 셋팅
		getList();				// 목록 조회
	});

	function f_Init_tblSheet()
	{

		// 세팅
		var	ibHeader	=	new	IBHeader();

		 /** 리스트,헤더 옵션 */
    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
    	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});


    	ibHeader.addHeader({Type: "Text", Header: "성명"		, SaveName: "name"				, Align: "Center"	, Width: 130	, Ellipsis:1, Cursor:"Pointer"});
    	ibHeader.addHeader({Type: "Text", Header: "직함"		, SaveName: "jobName"			, Align: "Center"	, Width: 80});
    	ibHeader.addHeader({Type: "Text", Header: "상담분야"	, SaveName: "counselingName"	, Align: "Left"		, Width: 300	, Ellipsis:1});
    	ibHeader.addHeader({Type: "Text", Header: "휴대전화"	, SaveName: "tel"				, Align: "Center"	, Width: 120	,Format:"PhoneNo"});
    	ibHeader.addHeader({Type: "Text", Header: "학력"		, SaveName: "scholar"			, Align: "Left"		, Width: 230});
    	ibHeader.addHeader({Type: "Text", Header: "경력"		, SaveName: "career"			, Align: "Left"		, Width: 230	, Ellipsis:1});
    	ibHeader.addHeader({Type: "Text", Header: "아이디"	, SaveName: "expertId"			, Align: "Center"	, Width: 0		, Hidden: true});

        var sheetId = "tblSheet";
		var container = $("#"+sheetId)[0];
        createIBSheet2(container,sheetId, "100%", "100%");
        ibHeader.initSheet(sheetId);
		/*loadSearchDataGrid('mySheet', [
			{"colA": "외환/환리스크, 해외인증", "colB": "유공영", "colC": "관세사", "colD": "010-0000-0000"}
			, {"colA": "외환/환리스크", "colB": "전효미", "colC": "변호사", "colD": "010-0000-0000"}
			, {"colA": "해외인증", "colB": "조영일", "colC": "변리사", "colD": "010-0000-0000"}
			, {"colA": "지역특화 엑스퍼트, 해외인증", "colB": "백우현", "colC": "인증전문가", "colD": "010-0000-0000"}
			, {"colA": "지재권/특허, 거래알선/바이어 찾기", "colB": "김형욱", "colC": "외환관리사", "colD": "010-0000-0000"}
			, {"colA": "거래알선/바이어찾기", "colB": "박명수", "colC": "회계사", "colD": "010-0000-0000"}
		]);*/
	};

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		var jsonParam = {
				pageIndex: pageIndex,
				authType: $('#authType').val(),
				noticeTypeCd: $('#noticeTypeCd').val(),
				searchType: $('#searchType').val(),
				title: $('#title').val()
			};
		global.ajax({
				url: '/tradeSOS/com/professionalMemberListAjax.do',
				dataType: 'json',
				type: 'POST',
			data: $('#searchForm').serialize(),
				success: function (data) {
					$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
						setPaging(
								'paging'
								, goPage
								, data.paginationInfo.currentPageNo
								, data.paginationInfo.totalRecordCount
								, data.paginationInfo.recordCountPerPage
								, data.paginationInfo.pageSize
							);

						tblSheet.LoadSearchData({Data: data.resultList});
						tblSheet.SetColFontBold('name', 1);
				},
				error:function(request,status,error) {
					alert('컨설턴트 조회에 실패했습니다.');
				}
			});
	}


	// 상세
 	function tblSheet_OnClick(Row, Col, Value) {
		if(tblSheet.ColSaveName(Col) == "name" && Row > 0){
			fn_detail(tblSheet.GetCellValue(Row,"expertId"));
		}
	};

	function press(event) {
		if (event.keyCode==13) {
			doSearch(1);
		}
	}
	function fn_detail(expertid) {
		document.searchForm.action = "/tradeSOS/com/professionalMemberDetail.do";
		document.searchForm.searchExpertId.value = expertid;
		document.searchForm.procType.value = "U";
		document.searchForm.submit();
	}

	function doInsert(){
		document.searchForm.procType.value = "I";
		document.searchForm.action = "/tradeSOS/com/professionalMemberDetail.do";
		document.searchForm.submit();
	}

</script>