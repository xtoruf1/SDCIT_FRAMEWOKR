<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="popupUserForm" name="popupUserForm" method="get" onsubmit="return false;">
<div style="width: 800px;height: 720px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">사용자 선택</h2>
		<div class="ml-auto">
			<button type="button" onclick="doUserSearch();" class="btn_sm btn_primary">검색</button>
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<!--검색 시작 -->
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:20%;" />
					<col />
					<col style="width:20%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">아이디</th>
						<td>
							<input type="text" name="searchUserId" value="" onkeydown="onEnter(doUserSearch);" class="form_text" title="아이디 / 성명" />
						</td>
						<th scope="row">성명</th>
						<td>
							<input type="text" name="searchUserName" value="" onkeydown="onEnter(doUserSearch);" class="form_text" title="아이디 / 성명" />
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
		<!--검색 끝 -->
		<div class="cont_block mt-20">
			<div id="popupUserList" class="sheet"></div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibUserHeader = new IBHeader();
	ibUserHeader.addHeader({Header: '아이디', Type: 'Text', SaveName: 'userId', Width: 80, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibUserHeader.addHeader({Header: '성명', Type: 'Text', SaveName: 'maskUserNm', Width: 80, Align: 'Center', Edit: 0, Cursor: 'Pointer'});
	ibUserHeader.addHeader({Header: '이메일', Type: 'Text', SaveName: 'userEmail', Width: 130, Align: 'Left', Edit: 0, Cursor: 'Pointer'});
	ibUserHeader.addHeader({Header: '핸드폰', Type: 'Text', SaveName: 'maskUserCpTelno', Width: 130, Align: 'Left', Edit: 0, Cursor: 'Pointer'});

	ibUserHeader.addHeader({Header: '사용자시퀀스', Type: 'Text', SaveName: 'userNm', Hidden: true});
	ibUserHeader.addHeader({Header: '사용자시퀀스', Type: 'Text', SaveName: 'userCpTelno', Hidden: true});

	ibUserHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: 1, DragRowSelection: 1, MergeSheet: 5, MaxSort: 1});
	ibUserHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var pmf;
	$(document).ready(function(){
		pmf = document.popupUserForm;

		pmf.searchUserId.focus();

		var popupUserContainer = $('#popupUserList')[0];
		if (typeof popupUserListSheet !== 'undefined' && typeof popupUserListSheet.Index !== 'undefined') {
			popupUserListSheet.DisposeSheet();
		}
		createIBSheet2(popupUserContainer, 'popupUserListSheet', '100%', '600px');
		ibUserHeader.initSheet('popupUserListSheet');
		popupUserListSheet.SetSelectionMode(4);

		// 편집모드 OFF
		popupUserListSheet.SetEditable(0);

		popupUserListSheet.LoadSearchData({Data : []});
	});

	function popupUserListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('popupUserListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 아이디에 볼드 처리
			popupUserListSheet.SetColFontBold('userId', 1);
			// 성명에 볼드 처리
			popupUserListSheet.SetColFontBold('maskUserNm', 1);
			// 이메일에 볼드 처리
			popupUserListSheet.SetColFontBold('userEmail', 1);
			// 핸드폰에 볼드 처리
			popupUserListSheet.SetColFontBold('maskUserCpTelno', 1);
    	}
    }

	function doUserSearch() {
		if (isStringEmpty(pmf.searchUserId.value) && isStringEmpty(pmf.searchUserName.value)) {
			alert('아이디나 성명으로 조회해 주세요.');

			if (isStringEmpty(pmf.searchUserId.value)) {
				pmf.searchUserId.focus();
			} else if (isStringEmpty(pmf.searchUserName.value)) {
				pmf.searchUserName.focus();
			}

			return;
		}

		getUserList();
	}

	// 목록 가져오기
	function getUserList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/popup/selectUserList.do" />'
			, data : $('#popupUserForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				popupUserListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function popupUserListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('popupUserListSheet', row);
	}

	function popupUserListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (
				popupUserListSheet.ColSaveName(col) == 'userId'
				|| popupUserListSheet.ColSaveName(col) == 'maskUserNm'
				|| popupUserListSheet.ColSaveName(col) == 'userEmail'
				|| popupUserListSheet.ColSaveName(col) == 'maskUserCpTelno'
			) {
				var userId = popupUserListSheet.GetCellValue(row, 'userId');
				var userNm = popupUserListSheet.GetCellValue(row, 'userNm');
				var maskUserNm = popupUserListSheet.GetCellValue(row, 'maskUserNm');
				var userEmail = popupUserListSheet.GetCellValue(row, 'userEmail');
				var userCpTelno = popupUserListSheet.GetCellValue(row, 'userCpTelno');

				doSelectUserId(userId, userNm, maskUserNm, userEmail, userCpTelno);
		    }
		}
	}

	// 사용자를 선택하여 콜백
	function doSelectUserId(userId, userNm, maskUserNm, userEmail, userCpTelno) {
		var returnObj = {
			 userId : userId
			, userNm : userNm
			, maskUserNm : maskUserNm
			, userEmail : userEmail
			, userCpTelno : userCpTelno
		}

		// 콜백
		layerPopupCallback(returnObj);

		// 레이어 닫기
		closeLayerPopup();
	}
</script>