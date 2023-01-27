<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="zipCodePopupForm" name="zipCodePopupForm" method="get" onsubmit="return false;">
<input type="hidden" id="searchExpertIdPop" name="searchExpertIdPop" value="<c:out value="${searchExpertIdPop}"/>" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value="${param.pageIndex}" default="1" />" />
<div style="max-width: 900px; max-height: 700px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">우편번호 검색</h2>
		<div class="ml-auto">
			<button type="button" onclick="doZipCodePopupSearch();" class="btn_sm btn_primary">검색</button>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<div class="popup_body" >
		<!--검색 시작 -->
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width: 15%" />
					<col />
					<col style="width: 15%" />
					<col />
					<col style="width: 15%" />
					<col style="width: 25%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">검색조건</th>
						<td>
							<select id="addressGb" name="addressGb" class="form_select" style="width: 100px;">
								<option value="20">새주소</option>
								<option value="10">기존주소</option>
							</select>
						</td>
						<th scope="row">지번/도로명</th>
						<td>
							<input type="text" id="eubDong" name="eubDong" value="<c:out value="${param.eubDong}"/>"  maxlength="20" onkeydown="onEnter(doZipCodePopupSearch);" class="form_text w100p" title="지번/도로명" />
						</td>
						<th scope="row">번지</th>
						<td>
							<div class="form_row w100p">
								<input type="text" id="searchBldg1" name="searchBldg1" value="<c:out value="${param.searchBldg1}"/>" maxlength="4" onkeydown="onEnter(doZipCodePopupSearch);" class="form_text" title="번지" />
								<input type="text" id="searchBldg2" name="searchBldg2" value="<c:out value="${param.searchBldg2}"/>" maxlength="4" onkeydown="onEnter(doZipCodePopupSearch);" class="form_text" title="번지" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--검색 끝 -->
		<div class="tbl_opt mt-20">
			<!-- 전체 게시글 -->
			<div id="zipCodePopupSheetTotalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doZipCodePopupSearch();">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
		<div class="w100p">
			<div id="zipCodePopupSheet" class="sheet"></div>
		</div>
		<!-- .paging-->
		<div id="zipCodePopupSheetPaging" class="paging ibs""></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function () {
		initZipCodePopupSheet();
	});

	// SHEET의 초기화 작업
	function initZipCodePopupSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10,  SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, editable: true, ColResize: true, statusColHidden: true, MergeSheet :5 , NoFocusMode : 0});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

        ibHeader.addHeader({Header:"No",      		Type:"Seq",      Hidden:false,  Width:30,   Align:"Center",  SaveName:"no"         		});
        ibHeader.addHeader({Header:"우편번호", 		Type:"Text",     Hidden:false,  Width:50,   Align:"Center",  SaveName:"zipNo"      		});
        ibHeader.addHeader({Header:"예전주소",   		Type:"Text",     Hidden:false,  Width:200,  Align:"Left",  	 SaveName:"jibunAddr" 		, Ellipsis:true});
        ibHeader.addHeader({Header:"새주소",   		Type:"Text",     Hidden:false,  Width:200,  Align:"Left",  	 SaveName:"roadAddr" 		, Ellipsis:true});

        ibHeader.addHeader({Header:"jusoNum",      Type:"Text",     Hidden:true,   Width:60,   Align:"Center",  SaveName:"roadAddrPart1"    });
        ibHeader.addHeader({Header:"jusoNum",      Type:"Text",     Hidden:true,   Width:60,   Align:"Center",  SaveName:"roadAddrPart2"    });
        ibHeader.addHeader({Header:"zipCd1",       Type:"Text",     Hidden:true,   Width:60,   Align:"Center",  SaveName:"engAddr"       	});

		var sheetId = "zipCodePopupSheet";
		var container = $("#" + sheetId)[0];
		if (typeof zipCodePopupSheet !== 'undefined' && typeof zipCodePopupSheet.Index !== 'undefined') {
			zipCodePopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
		zipCodePopupSheet.SetSelectionMode(4);

		zipCodePopupSheet.SetDataLinkMouse("no", true);
		zipCodePopupSheet.SetDataLinkMouse("zipNo", true);
		zipCodePopupSheet.SetDataLinkMouse("jibunAddr", true);
		zipCodePopupSheet.SetDataLinkMouse("roadAddr", true);
	};

	// 조회
	function doZipCodePopupSearch() {
		var form1 = document.zipCodePopupForm;
		if (isStringEmpty(form1.eubDong.value)){
			alert('지번/도로명을 입력해 주세요.');

			return;
		}

		goZipCodePopupPage(1);
	}

	// 페이징 조회
	function goZipCodePopupPage(pageIndex) {
		var form = document.zipCodePopupForm;
		form.pageIndex.value = pageIndex;

		geZipCodePopuptList();
	}

	// 검색
	function geZipCodePopuptList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/zipCodePopupList.do" />'
			, data : $('#zipCodePopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#zipCodePopupSheetTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'zipCodePopupSheetPaging'
					, goZipCodePopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				zipCodePopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function zipCodePopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0) {
			var rowData = zipCodePopupSheet.GetRowData(Row);

			// 콜백
			layerPopupCallback(rowData);

			// 레이어 닫기
			closeLayerPopup();
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>