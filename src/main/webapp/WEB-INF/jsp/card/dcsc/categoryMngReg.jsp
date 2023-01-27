<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_primary" onclick="goList();">목록</button>
	</div>
</div>

<div class="cont_block">
	<form id="categoryForm" method="post">
		<div class="search">
			<input type="hidden" id="searchCategoryName" name="searchCategoryName" value="<c:out value="${params.searchCategoryName}"/>"/>
			<input type="hidden" id="categoryId" name="categoryId" value="<c:out value="${categoryInfo.categoryId}"/>"/>
			<input type="text" style="display: none;" />
			<table class="formTable">
				<colgroup>
					<col style="width:17%" />
				</colgroup>
				<tbody>
					<tr>
						<th>카테고리명</th>
						<td>
							<input type="text" class="form_text" id="categoryName" name="categoryName" value="<c:out value="${categoryInfo.categoryName}"/>" maxlength="30" />
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td>
							<label class="label_form">
								<input type="radio" class="form_radio" name="fileYn" value="Y" <c:out value="${categoryInfo.fileYn eq 'Y' ? 'checked': empty categoryInfo ? 'checked':''}"/>>
								<span class="label">사용</span>
							</label>

							<label class="label_form">
								<input type="radio" class="form_radio" name="fileYn" value="N" <c:out value="${categoryInfo.fileYn eq 'N' ? 'checked':''}"/>>
								<span class="label">미사용</span>
							</label>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">선택항목 관리</h3>
		<div class="btnGroup ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doRowAdd();">추가</button>
		</div>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="categorySheet" class="sheet"></div>
	</div>
</div>

<form>
	<input type="hidden" id="searchCategoryName" name="searchCategoryName" value="<c:out value="${params.categoryName}"/>"/>
</form>
<script type="text/javascript">

	$(document).ready(function(){
		setSheetHeader_dcscCategorySheet();
		getCategoryMngList();
	});

	function setSheetHeader_dcscCategorySheet() {

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '상태'		, Type: 'Status'	, SaveName: 'status'	, Width: 20	, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '시퀀스'		, Type: 'Text'		, SaveName: 'seq'		, Width: 20	, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '삭제'		, Type: 'DelCheck'	, SaveName: 'delFlag'	, Width: 20	, Align: 'Center'	, Edit: 1	, HeaderCheck: 0});
		ibHeader.addHeader({Header: '선택항목'		, Type: 'Text'		, SaveName: 'optionName', Width: 40	, Align: 'Left'		, Edit: 1	, Cursor: 'Pointer', EditLen: 30});
		ibHeader.addHeader({Header: '사용유무'		, Type: 'Combo'		, SaveName: 'useYn'		, Width: 30	, Align: 'Center'	, ComboText: '사용|미사용'	, ComboCode: 'Y|N'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#categorySheet')[0];
		createIBSheet2(container, 'categorySheet', '100%', '10%');
		ibHeader.initSheet('categorySheet');

		categorySheet.SetEllipsis(1); 				// 말줄임 표시여부

	}

	function goList() {
		//location.href = '/card/dcsc/categoryMngList.do';
		$('#categoryForm').attr('action', "/card/dcsc/categoryMngList.do");
		$('#categoryForm').submit();
	}

	function doRowAdd() {
		var index = categorySheet.DataInsert(-1);
	}

	function doSave() {

		if(isValid()) {

			if(confirm('저장하시겠습니까?')) {

				var jsonParam = $('#categoryForm').serializeObject();
				var saveJson = categorySheet.GetSaveJson();
				jsonParam.categoryDetList = saveJson.data;

				global.ajax({
					type : 'POST'
					, url : '/card/dcsc/saveDcscCategory.do'
					, data : JSON.stringify(jsonParam)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						goList();
					}
					, error: function (request, status, error) {
						console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});
			}

		}
	}

	/*
	function doUpdate() {
		if (isValid()) {
			if (confirm('해당 공통코드를 수정하시겠습니까?')) {
				var ccf = $('#commonCodeForm').serializeObject();

				var saveJson = categorySheet.GetSaveJson();

				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});

						ccf['codeList'] = list;
					});
				}

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/commonCode/counsel/update.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('공통코드를 수정하였습니다.');
						goList();
					}
				});
			}
		}
	}
	*/
	function isValid() {
		var categoryName = $('#categoryName').val();
		if (isStringEmpty(categoryName)) {
			alert('카테고리명을 입력해 주세요.');
			$('#categoryName').focus();

			return false;
		}

		if (categoryName.length > 30) {
			alert('카테고리명은 30자를 초과할 수 없습니다.');
			$('#categoryName').focus();

			return false;
		}

		var saveJson = categorySheet.GetSaveJson();

		if(saveJson.data.length <= 0) {
			alert('선택항목을 추가하세요.');
			return false;
		}

		var isOptionNameValid = true;
		var isOptionLength = true;

		if (saveJson.data.length) {

			var duplicate = new Array();

			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.optionName)) {
							isOptionNameValid = false;
						}
						if (value2.optionName.length > 30) {
							isOptionLength = false;
						}
					}
					duplicate.push(value2.optionName);
				});
			});

		}

		if (!isOptionNameValid) {
			alert('선택항목을 입력해 주세요.');
			return false;
		}

		if (!isOptionLength) {
			alert('선택항목은 30자 이하로 입력해 주세요.');
			return false;
		}

		return true;
	}

	//카테고리 관리 목록
	function getCategoryMngList() {
		var jsonParam = $('#categoryForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/card/dcsc/selectDcscCategoryDet.do"
			, contentType : 'application/json'
			, data : JSON.stringify(jsonParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				console.log(data);
				categorySheet.LoadSearchData({Data: (data.detList || []) }, {	// 조회한 데이터 시트에 적용
					Sync: 1
				});

				categorySheet.SelectCell(1,0);	// 리스트 최상단 데이터 선택
			}
		});
	}

</script>