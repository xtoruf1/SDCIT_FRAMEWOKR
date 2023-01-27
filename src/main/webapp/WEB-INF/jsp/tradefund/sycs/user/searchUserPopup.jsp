<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="searchUserPopupForm" name="searchUserPopupForm" method="get" onsubmit="return false;">
<input type="hidden" id="searchExpertIdPop" name="searchExpertIdPop" value="<c:out value="${searchExpertIdPop}" />" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value="${param.pageIndex}" default="1" />" />
<input type="hidden" id="resultCnt" name="resultCnt" value="0" />
<input type="hidden" id="fundGb" name="fundGb" value="<c:out value="${param.fundGb}" />" />
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">사용자 찾기</h2>
	<div class="ml-auto">
		<button type="button" onclick="doUserPopupSearch();" class="btn_sm btn_primary">검색</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div class="popup_body" style="max-width: 800px;">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col style="width: 30%;" />
				<col style="width: 20%;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">성명</th>
					<td>
						<input type="text" id="userName" name="userName" value="${param.userName}" onkeydown="onEnter(doUserPopupSearch);" class="form_text w100p" title="검색어" size="17" />
					</td>
					<th scope="row">KITANET 아이디</th>
					<td>
						<div class="form_row w100p">
							<input type="text" id="userSabun" name="userSabun" value="${param.userSabun}" onkeydown="onEnter(doUserPopupSearch);" class="form_text" title="검색어" size="17" />
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="tbl_opt mt-20">
		<!-- 전체 게시글 -->
		<div id="searchUserPopupExpertTotalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doUserPopupSearch();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div class="w100p">
		<div id="searchUserPopupSheet" class="sheet"></div>
	</div>
	<div id="searchUserPopupExpertPaging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function () {
		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});

		initUserPopupSheet();
		goUserPopupPage(1);
	});

	// Sheet의 초기화 작업
	function initUserPopupSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10,  SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, NoFocusMode : 0, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"No.",				Type:"Int",			Hidden:false,	Width:30,	Align:"Center",		SaveName:"rn"			});
		ibHeader.addHeader({Header:"No.",				Type:"Seq",			Hidden:true,	Width:30,	Align:"Center",		SaveName:"no"			});
		ibHeader.addHeader({Header:"Status",			Type:"Status",		Hidden:true,	Width:80,	Align:"Center",		SaveName:"status"		});
		ibHeader.addHeader({Header:"KITANET 아이디",		Type:"Text",		Hidden:false,	Width:80,	Align:"Left",		SaveName:"memberId"		});
		ibHeader.addHeader({Header:"성명",				Type:"Text",		Hidden:false,	Width:80,	Align:"Left",		SaveName:"memberNm"		});
		ibHeader.addHeader({Header:"부서코드",				Type:"Text",		Hidden:true,	Width:60,	Align:"Center",		SaveName:"deptCd"		});
		ibHeader.addHeader({Header:"부서명",				Type:"Text",		Hidden:false,	Width:100,	Align:"Left",		SaveName:"deptNm"		});
		ibHeader.addHeader({Header:"전화번호",				Type:"Text",		Hidden:false,	Width:80,	Align:"Left",		SaveName:"telNo"		});
		ibHeader.addHeader({Header:"팩스번호",				Type:"Text",		Hidden:true,	Width:0,	Align:"Center",		SaveName:"faxNo"		});

		var sheetId = "searchUserPopupSheet";
		var container = $("#" + sheetId)[0];
		if (typeof searchUserPopupSheet !== 'undefined' && typeof searchUserPopupSheet.Index !== 'undefined') {
			searchUserPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
		searchUserPopupSheet.SetSelectionMode(4);

		searchUserPopupSheet.SetDataLinkMouse("no", true);
		searchUserPopupSheet.SetDataLinkMouse("memberId", true);
		searchUserPopupSheet.SetDataLinkMouse("memberNm", true);
		searchUserPopupSheet.SetDataLinkMouse("deptNm", true);
		searchUserPopupSheet.SetDataLinkMouse("telNo", true);
	};

	// 조회
	function doUserPopupSearch() {
		goUserPopupPage(1);
	}

	// 페이징 조회
	function goUserPopupPage(pageIndex) {
		var form = document.searchUserPopupForm;
		form.pageIndex.value = pageIndex;
		getUserPopupList();
	}

	// 검색
	function getUserPopupList(pageIndex) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/user/searchUserPopupList.do" />'
			, data : $('#searchUserPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#searchUserPopupExpertTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);

				setPaging(
					'searchUserPopupExpertPaging'
					, goUserPopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				searchUserPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function searchUserPopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rowData = searchUserPopupSheet.GetRowData(Row);

		console.log(rowData);

		// 콜백
		layerPopupCallback(rowData);

		// 레이어 닫기
		closeLayerPopup();
	 }

	function searchUserPopupSheet_OnRowSearchEnd(row) {
		if (row > 0) {
			var index = searchUserPopupSheet.GetCellValue(row, "no");
			var resultCnt = $('#resultCnt').val();
			searchUserPopupSheet.SetCellValue(row, "rn", parseInt(resultCnt - index) + 1);
		}
	}
</script>