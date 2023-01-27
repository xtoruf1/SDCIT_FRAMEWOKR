<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">담당위원 검색</h2>

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch2();">검색</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<form id="expertSearchForm" name="expertSearchForm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />

<div class="popup_body">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col style="width:35%">
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">전문해외시장</th>
					<td>
						<select name="relCd" class="form_select w100p">
							<option value="" selected="">전체</option>
							<c:forEach var="data" items="${relCode}" varStatus="status">
								<option value="<c:out value="${data.relCode}"/>"><c:out value="${data.relName}"/></option>
							</c:forEach>
						</select>

					</td>
					<th scope="row">상담가능지역</th>
					<td>
						<select name="hopeCityCd" class="form_select w100p">
							<option value="" selected="">전체</option>
							<c:forEach var="data" items="${code012}" varStatus="status">
								<option value="<c:out value="${data.cdId}"/>"><c:out value="${data.cdNm}"/></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">취급품목</th>
					<td>
						<select id="mtiCd" class="form_select"  onchange="getMtiSelect(1, this.value)">

						</select>
						<select id="mtiCd2" name="mtiCode" class="form_select ml-8">
						</select>
					</td>
					<th scope="row">컨설턴트명</th>
					<td>
						<input type="text" id="expertNm" name="expertNm" onkeydown="onEnter(doSearch2);" class="form_text w100p" value="">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="w100p mt-20">
		<div id="expertSearchSheet" class="colPosi"></div>
	</div>
	<!-- .paging-->
	<div id="expertPaging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function () {

		f_Init_tblGridPopupSheet();

		getMtiSelect(0, ""); //취급품목 가져오기

		expertSearchSheet.LoadSearchData(''); //조회된 데이터가 없습니다. 띄우기

	});

	function f_Init_tblGridPopupSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "expertId", 	SaveName: "expertId",Hidden : true});
		ibHeader.addHeader({Type: "Text", Header: "컨설턴트명", 	SaveName: "expertNm", 	Align: "Center", 	Width: 60, Cursor: "Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "전문해외시장", SaveName: "ctrNm", 			Align: "Left", 		Width: 120});
		ibHeader.addHeader({Type: "Text", Header: "상담가능지역", SaveName: "hopeCityNm", Align: "Left",		Width: 120, Cursor: "Pointer"});
		ibHeader.addHeader({Type: "Text", Header: "취급품목", 		SaveName: "mtiNameKor", Align: "Left",		Width: 290, Cursor: "Pointer"});

		if (typeof expertSearchSheet !== 'undefined' && typeof expertSearchSheet.Index !== 'undefined') {
			expertSearchSheet.DisposeSheet();
		}

		var sheetId = "expertSearchSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
		// 편집모드 OFF
		tblGridSheet.SetEditable(0);

	};

	//그리드 클릭 시
	function expertSearchSheet_OnClick(Row,Col,Value){
		if(expertSearchSheet.ColSaveName(Col) == "expertNm" || expertSearchSheet.ColSaveName(Col) == "ctrNm" ||
				expertSearchSheet.ColSaveName(Col) == "hopeCityNm"|| expertSearchSheet.ColSaveName(Col) == "mtiNameKor"  && Row > 0) {
			var rowData = expertSearchSheet.GetRowData(Row);

			// 콜백
			layerPopupCallback(rowData);

			// 레이어 닫기
			closeLayerPopup();
		}

	}

	function doSearch2() {
		goPage2(1);
	}

	function goPage2(pageIndex) {
		document.expertSearchForm.pageIndex.value = pageIndex;
		getList2();
	}

	// 검색
	function getList2(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/com/layer/expertSearchLayerListAjax.do" />'
			, data : $('#expertSearchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				setPaging(
					'expertPaging'
					, goPage2
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				expertSearchSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	// 취급품목 선택
	function getMtiSelect(depth, mtiCode){
		if (depth > 0 && mtiCode == ''){
			$("#mtiCd2").children().remove();
			$("#mtiCd2").append("<option value=''>선택</option>");
		}else{

			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/popup/mtiCodeListAjax.do" />'
				, data : {"searchUnit" : depth, searchMtiCodePop : mtiCode}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					var optionList = data.resultList;
					if (depth == 0){
						$("#mtiCd").children().remove();
						$("#mtiCd").append("<option value=''>선택</option>");
						$("#mtiCd2").append("<option value=''>선택</option>");
						for(var i = 0 ; i < optionList.length; i++){
							$("#mtiCd").append("<option value='"+optionList[i].mtiCode+"'>"+optionList[i].mtiNameKor+"</option>");
						}
					}else{
						$("#mtiCd2").children().remove();
						$("#mtiCd2").append("<option value=''>선택</option>");
						for(var i = 0 ; i < optionList.length; i++){
							$("#mtiCd2").append("<option value='"+optionList[i].mtiCode+"'>"+optionList[i].mtiNameKor+"</option>");
						}
					}
				}
			});

		}
	}

</script>