<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doRowAdd();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getDcscAffiliateList();">검색</button>
	</div>
</div>
<div class="cont_block">
	<form id="searchForm" method="post">
		<div class="search">
			<input type="text" style="display: none;" />
			<table class="formTable">
				<colgroup>
					<col style="width: 17%;" />
				</colgroup>
				<tbody>
					<tr>
						<th>카테고리</th>
						<td>
							<select id="searchCategoryId" name="searchCategoryId" class="form_select">
								<option value="">전체</option>
								<c:forEach var="list" items="${categoryList}" varStatus="status">
									<option value="${list.categoryId}">${list.categoryName}</option>
								</c:forEach>
							</select>
						</td>
						<th>업체명</th>
						<td>
							<input type="text" id="searchAffiliateName" name="searchAffiliateName" class="form_text" onkeydown="onEnter(getDcscAffiliateList);" maxlength="30" />
						</td>
						<th>담당자명</th>
						<td>
							<input type="text" id="searchChargeName" name="searchChargeName" class="form_text" onkeydown="onEnter(getDcscAffiliateList);" maxlength="30" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<span id="totalCnt" class="total_count"></span>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="affiliateSheet" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_dcscAffiliateSheet();
		getDcscAffiliateList();
	});

	function setSheetHeader_dcscAffiliateSheet() {
		var	ibHeader = new IBHeader();

		//ibHeader.addHeader({Header: '삭제'			, Type: 'DelCheck'		, SaveName: 'delFlag'			, Width: 15		, Align: 'Center'	, Edit: 1	, HeaderCheck: 0});
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Width: 20		, Align: 'Center'	, Hidden: true});
		//ibHeader.addHeader({Header: '카테고리 ID'		, Type: 'Text'			, SaveName: 'categoryId'		, Edit: false	, Width: 40		, Align: 'Left'	, Hidden: true});
		ibHeader.addHeader({Header: '카테고리'			, Type: 'Combo'			, SaveName: 'categoryId'		, InsertEdit: 1	, UpdateEdit: 0		, Edit: 1	, Width: 40		, Align: 'Center'	, ComboCode: '${categoryComboList.code}' , ComboText: '${categoryComboList.codeNm}', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '제휴 업체 ID'		, Type: 'Text'			, SaveName: 'affiliateId'		, Edit: 0	, Width: 40		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '제휴 업체명'		, Type: 'Text'			, SaveName: 'affiliateName'		, Edit: 1	, Width: 40		, Align: 'Center'	, EditLen: 30});
		ibHeader.addHeader({Header: '담당자명'			, Type: 'Text'			, SaveName: 'chargeName'		, Edit: 1	, Width: 20		, Align: 'Center'	, EditLen: 30});
		ibHeader.addHeader({Header: '담당자 휴대폰'		, Type: 'Text'			, SaveName: 'chargePhone'		, Edit: 1	, Width: 30		, Align: 'Center'	, Format: 'PhoneNo'});
		ibHeader.addHeader({Header: '담당자 이메일'		, Type: 'Text'			, SaveName: 'chargeEmail'		, Edit: 1	, Width: 50		, Align: 'Center'});
		ibHeader.addHeader({Header: '로그인 아이디'		, Type: 'Text'			, SaveName: 'asisId'			, Width: 30		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '로그인 아이디'		, Type: 'Text'			, SaveName: 'chargeId'			, Width: 30		, Align: 'Center'	, EditLen: 20, AcceptKeys: 'N|E|[_]'});
		ibHeader.addHeader({Header: '사용유무'			, Type: 'Combo'			, SaveName: 'useYn'				, Width: 25		, Align: 'Center'	, ComboText: '사용|미사용'	, ComboCode: 'Y|N'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 1,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 2,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#affiliateSheet')[0];
		createIBSheet2(container, 'affiliateSheet', '100%', '480px');
		ibHeader.initSheet('affiliateSheet');

		affiliateSheet.SetEllipsis(1); 				// 말줄임 표시여부
	}

	// 카테고리 목록 조회
	function getDcscAffiliateList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectDcscAffiliateList.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.affiliateList.length) + '</span> 건');
				affiliateSheet.LoadSearchData({Data: (data.affiliateList || []) });
			}
		});
	}

	function goCategoryReg() {
		location.href = '/card/dcsc/categoryMngReg.do';
	}

	function affiliateSheet_OnAfterEdit(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		// 로그인 아이디 유효성검사 1,2,3
		if (affiliateSheet.ColSaveName(Col) == 'chargeId') {
			var chargeId = affiliateSheet.GetCellValue(Row, 'chargeId');
			// 수정전 저장되어있던 ID
			var asisId = affiliateSheet.GetCellValue(Row, 'asisId');

			if (asisId != chargeId) {
				// 1.사용자정보에 아이디가 존재하지않으면 진입
				if ($.trim(chargeId) != '' && selectCheckUserId(chargeId)) {
					alert('입력하신 로그인 아이디가 유효하지 않습니다.');
					affiliateSheet.SetCellValue(Row, 'chargeId', '');
				}

				// 2.제휴업체정보에 아이디가 존재하지않는 경우 && 저장되어있던 id와 변경하려는 id가 동일하지 않은 경우(아이디를 변경 취소 한 경우)
				if (selectHasUserId(chargeId)) {
					alert('이미 목록에 존재하는 아이디입니다.');
					affiliateSheet.SetCellValue(Row, 'chargeId', '');
				}
			}

			// 3.새로 추가하는 다중 로우 중에 아이디 중복 체크
			var cnt = 0;
			var saveJson = affiliateSheet.GetSaveJson();
			if(saveJson.data.length) {
				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					$.each(value1, function(key2, value2) {
						if($.trim(chargeId) != '' && chargeId == value2.chargeId) {
							cnt++;
						}
					});
				});
			}

			if (cnt > 1) {
				alert('등록하는 로그인 아이디가 중복이 있습니다.');
				affiliateSheet.SetCellValue(Row, 'chargeId', '');
			}

		}
		// 로그인 아이디 유효성검사

		// 이메일 유효성검사
		if (affiliateSheet.ColSaveName(Col) == 'chargeEmail') {
			var chargeEmail = affiliateSheet.GetCellValue(Row, 'chargeEmail');
			if ($.trim(chargeEmail) != '') {
				if (!checkEmail(chargeEmail)) {
					alert('이메일 형식이 올바르지 않습니다.');
					affiliateSheet.SetCellValue(Row, 'chargeEmail', '');
				}
			}
		}
	}

	function affiliateSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (rowType == 'HeaderRow'){
			return;
		}
	}

	function doRowAdd() {
		var index = affiliateSheet.DataInsert(-1);
		// 편집시 컬럼 색깔 변경
		affiliateSheet.SetCellBackColor(index, 'categoryId', '#ffffff');
	}

	function doSave() {
		if (isValid()) {
			if (confirm('저장하시겠습니까?')) {
				var jsonParam = {};
				var saveJson = affiliateSheet.GetSaveJson();
				jsonParam.affiliateList = saveJson.data;

				global.ajax({
					type : 'POST'
					, url : '/card/dcsc/saveDcscAffiliate.do'
					, data : JSON.stringify(jsonParam)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						getDcscAffiliateList();
					}
					, error: function (request, status, error) {
						console.log('code:' + request.status + '\n' + 'message:' + request.responseText + '\n' + 'error:' + error);
					}
				});
			}
		}
	}

	function isValid() {
		var saveJson = affiliateSheet.GetSaveJson();

		var isAffiliateNameValid = true;
		var isChargeNameValid = true;
		var isChargePhoneValid = true;
		var isChargeEmailValid = true;
		var isChargeIdValid = true;

		if (saveJson.data.length) {
			var duplicate = new Array();

			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.affiliateName)) {
							isAffiliateNameValid = false;
						}

						if (isStringEmpty(value2.chargeName)) {
							isChargeNameValid = false;
						}

						if (isStringEmpty(value2.chargePhone)) {
							isChargePhoneValid = false;
						}

						if (isStringEmpty(value2.chargeEmail)) {
							isChargeEmailValid = false;
						}

						if (isStringEmpty(value2.chargeId)) {
							isChargeIdValid = false;
						}
					}

					// duplicate.push(value2.optionName);
				});
			});
		}

		if (!isAffiliateNameValid) {
			alert('제휴 업체명을 입력해 주세요.');
			return false;
		}

		if (!isChargeNameValid) {
			alert('담당자명을 입력해 주세요.');
			return false;
		}

		if (!isChargePhoneValid) {
			alert('담당자 휴대폰을 입력해 주세요.');
			return false;
		}

		if (!isChargeEmailValid) {
			alert('담당자 이메일을 입력해 주세요.');
			return false;
		}

		if (!isChargeIdValid) {
			alert('로그인 아이디를 입력해 주세요.');
			return false;
		}

		return true;
	}

	$('#searchCategoryId').on('change', function() {
		getDcscAffiliateList();
	});

	// 사용자정보에 해당아이디 존재여부 체크
	function selectCheckUserId(chargeId) {
		var check = true;
		var searchParams = {
			chargeId:chargeId
		}
		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectCheckUserId.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//존재해야 사용가능
				if(data.hasYn == 'Y') {
					check = false;
				}
			}
		});

		return check;
	}

	// 제휴업제정보에 해당아이디 존재여부 체크
	function selectHasUserId(chargeId) {
		var check = true;
		var searchParams = {
			chargeId : chargeId
		}

		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectHasUserId.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				// 존재하면 사용불가
				if (data.hasYn == 'N') {
					check = false;
				}
			}
		});

		return check;
	}
</script>