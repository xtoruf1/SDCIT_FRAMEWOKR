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

<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
	<input type="hidden" name="searchExpertId" id="searchExpertId" value=""/>
	<input type="hidden" name="procType" id="procType" value=""/>

<!-- 컨설턴트/전문가 관리 - 무역현장자문위원 리스트 -->
<div class="page_tradesos">
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<!-- 검색 테이블 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_insert();">신규</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>

	</div>
	<table class="formTable">
		<colgroup>
			<col style="width:12%">
			<col>
			<col style="width:12%">
			<col>
			<col style="width:12%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">소재지</th>
				<td class="">
					<select name="searchRegion" id="searchRegion" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${regionList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq searchVO.searchItemType}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">전문품목</th>
				<td class="">
					<span class="form_search w100p">
						<input type="hidden" name="searchMtiCode" id="searchMtiCode" value="<c:out value="${searchVO.searchMtiCode}"/>"/>
						<input type="hidden" name="searchMtiUnit" id="searchMtiUnit" value="<c:out value="${searchVO.searchMtiUnit}"/>"/>
						<input class="form_text" type="text" id="searchMtiName" name="searchMtiName" value="<c:out value="${searchVO.searchMtiName}"/>">
						<button type="button" class="btn_icon btn_search" title="검색" onclick="openLayerItemPop();"></button>
					</span>
				</td>
				<th scope="row">주력시장</th>
				<td>
					<span class="form_search w100p">
						<input type="hidden" id="searchCtrCode" name="searchCtrCode" value="<c:out value="${searchVO.searchCtrCode}"/>">
						<input class="form_text" type="text" name="searchCtrName" id="searchCtrName" value="<c:out value="${searchVO.searchCtrName}"/>">
						<button type="button" class="btn_icon btn_search" title="검색" onclick="countryLayerOpen();"></button>
					</span>
				</td>
			</tr>
			<tr>
				<th scope="row">성명</th>
				<td>
					<input type="text" id="searchKeyword" name="searchKeyword" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.searchKeyword}"/>">
				</td>
				<th scope="row">활동구분</th>
				<td colspan="3">
					<select name="searchStYn" id="searchStYn" class="form_select w100p">
						<option value="">전체</option>
						<option value="N" <c:if test="${searchVO.searchStYn eq 'N'}">selected</c:if>>활동</option>
						<option value="Y" <c:if test="${searchVO.searchStYn eq 'Y'}">selected</c:if>>자리비움</option>
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
		<div id='consultSheet' class="colPosi"></div>
	</div>

	<!-- .paging-->
	<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
	<!-- //.paging-->

</div> <!-- // .page_tradesos -->
</form>

<script type="text/javascript">
	jQuery(document).ready(function(){
			f_Init_consultSheet();	// 리스트  Sheet 셋팅
			getList(1);
	});
		function f_Init_consultSheet() {
			// 세팅
			var	ibHeader	=	new	IBHeader();

			/** 리스트,헤더 옵션 */
			ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
			ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

			ibHeader.addHeader({Type: "Text", Header: "성명"		, SaveName: "name"		, Align: "Center"	, Width: 130	, Ellipsis:1, Cursor:"Pointer", FontBold:1});
			ibHeader.addHeader({Type: "Text", Header: "활동지역"	, SaveName: "regionNm"	, Align: "Left"		, Width: 130});
			ibHeader.addHeader({Type: "Text", Header: "전문품목"	, SaveName: "mtiName"	, Align: "Left"		, Width: 310	, Ellipsis:1 });
			ibHeader.addHeader({Type: "Text", Header: "주력시장"	, SaveName: "ctrName"	, Align: "Left"		, Width: 310	, Ellipsis:1 });
			ibHeader.addHeader({Type: "Text", Header: "활동구분"	, SaveName: "stYnNm"	, Align: "Center"	, Width: 100});
			ibHeader.addHeader({Type: "Text", Header: "활동기간"	, SaveName: "contractDt", Align: "Center"	, Width: 200});
			ibHeader.addHeader({Type: "Text", Header: "아이디"	, SaveName: "expertId"	, Align: "Center"	, Width: 0, Hidden: true});

			var sheetId = "consultSheet";
			var container = $("#"+sheetId)[0];
			createIBSheet2(container,sheetId, "100%", "100%");
			ibHeader.initSheet(sheetId);
		}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		getList(pageIndex);
	}

	function getList(pageIndex){
		var jsonListData = [];

		// if(pageIndex){
		// 	$('#pageIndex').val(pageIndex);
		// }

		global.ajax({
			type:"post",
			url:"/tradeSOS/com/consultantMemberListAjax.do",
			data:$('#searchForm').serializeArray(),
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
				consultSheet.LoadSearchData({Data: data.resultList});
				// consultSheet.SetColFontBold('name', 1);
			},
			error:function(request,status,error) {
				alert('무역현장자문위원 조회에 실패했습니다.');
			}
		});
	}

	// 상세
 	function consultSheet_OnClick(Row, Col, Value) {
		if(consultSheet.ColSaveName(Col) == "name" && Row > 0){
			fn_detail(consultSheet.GetCellValue(Row,"expertId"));
		}
	};

	// function tblSheet2_OnClick(Row,Col,Value){
	// 	if(Row == 0){
	// 		return false;
	// 	}
	// 	var rowData = tblSheet2.GetRowData(Row);
	// }

	function press(event) {
		if (event.keyCode==13) {
			dataList(1);
		}
	}
	function fn_detail(expertid) {
		document.searchForm.action = "/tradeSOS/com/consultantMemberDetail.do";
		document.searchForm.searchExpertId.value = expertid;
		document.searchForm.procType.value = "U";
		document.searchForm.submit();
	}

	function fn_insert(){
		document.searchForm.procType.value = "I";
		document.searchForm.action = "/tradeSOS/com/consultantMemberDetail.do";
		document.searchForm.submit();
	}

	/*계층형*/
	function openLayerItemPop(){
		//기본값 초기화
		$('#searchUnit').val('');
		$('#searchMtiCodePop').val('');
		$('#upperItem').data('unit','0');
		//품목별 초기화 추가
		$('#searchMtiNmPop').val('');
		// itemStepList(tblSheet);
		// itemKeyList(tblSheet2);
// 		$('#itemPop').show();

		global.openLayerPopup({
				popupUrl : '/tradeSOS/com/popup/professionalField.do'
			, callbackFunction : function(resultObj) {
				var appendCode = "";
				var appendName = "";
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
					}
					$('#searchMtiName').val(appendName);
					$('#searchMtiCode').val(appendCode);
				}

			}
		});

	}

	function countryLayerOpen(){																//주력시장팝업
		global.openLayerPopup({
			  popupUrl : '/tradeSOS/com/popup/countrySearch.do'
			, callbackFunction : function(resultObj) {
				var appendCode = "";
				var appendName = "";
				for(var i = 0; i < resultObj.ctrNameArray.length; i++)							//선택한 행의 갯수만큼
				{
					if(appendCode != "" && appendName != "")									//첫 추가 외 경우 ',' 추가
					{
						appendCode += ','+resultObj.ctrCodeArray[i];
						appendName += ','+resultObj.ctrNameArray[i];
					}
					if(appendCode == "" && appendName == "")									//처음은 값만 입력
					{
						appendCode += resultObj.ctrCodeArray[i];
						appendName += resultObj.ctrNameArray[i];
					}
					$('#searchCtrName').val(appendName);
					$('#searchCtrCode').val(appendCode);
				}
			}
		});

		$('#searchRelCodePop').val('');
		$('#searchPRelNmPop').val('');
	}




</script>