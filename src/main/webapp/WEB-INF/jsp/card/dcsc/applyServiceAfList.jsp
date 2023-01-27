<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="exceluploadPopup();">엑셀 업로드</button>
	</div>
	<div class="ml-15">
		<button type="button" id="btnExcelDown" class="btn_sm btn_primary btn_modify_auth" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getDcscApplyAfList();">검색</button>
	</div>
</div>
<form id="searchForm" method="post">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />"  />
	<div class="cont_block">
		<div class="search">
			<input type="text" style="display: none;" />
			<table class="formTable">
				<colgroup>
					<col style="width: 17%;" />
				</colgroup>
				<tbody>
					<tr>
						<th>업체명</th>
						<td>
							<input type="text" id="searchCompanyName" name="searchCompanyName" class="form_text" onkeydown="onEnter(getDcscApplyAfList);" maxlength="70" />
						</td>
						<th>사업자 번호</th>
						<td>
							<input type="text" id="searchBusinessNo" name="searchBusinessNo" class="form_text" onkeydown="onEnter(getDcscApplyAfList);return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" />
						</td>
						<th>상태</th>
						<td>
							<select id="searchStatusCd" name="searchStatusCd" class="form_select">
								<option value="">전체</option>
								<c:forEach var="list" items="${cardStatusComboList}" varStatus="status">
									<option value="${list.code}">${list.codeNm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>신청자</th>
						<td>
							<input type="text" id="searchApplyName" name="searchApplyName" class="form_text" onkeydown="onEnter(getDcscApplyAfList);" maxlength="30" />
						</td>
						<th>신청일</th>
						<td colspan="3">
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchStartDate" name="searchStartDate" value="${param.searchStartDate}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" onclick="clearPickerValue('searchStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
								<div class="spacing">~</div>
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" onclick="clearPickerValue('searchEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="cont_block">
		<div class="tbl_opt">
			<span id="totalCnt" class="total_count"></span>
			<div class="btnGroup ml-auto">
				<!-- 한 페이지 갯수 -->
				<!-- <a href="javascript:doExcelDownload();" class="ui-button ui-widget ui-corner-all">엑셀 다운</a> -->
				<!-- <a href="javascript:doExcelIBSheetDownload();" class="ui-button ui-widget ui-corner-all">엑셀 다운</a> -->
				<select id="pageUnit" name="pageUnit" onchange="getDcscApplyAfList();" class="form_select ml-auto" title="목록수">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.basicPageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="applySheet" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_dcscApplySheet();
		getDcscApplyAfList();
	});

	function setSheetHeader_dcscApplySheet() {
		var	ibHeader = new IBHeader();

		/* ibHeader.addHeader({Header: '삭제'			, Type: 'DelCheck'		, SaveName: 'delFlag'			, Width: 15		, Align: 'Center'	, Edit: 1	, HeaderCheck: 0}); */
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Width: 20		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '카테고리 ID'		, Type: 'Text'			, SaveName: 'categoryId'		, Edit: 1	, Width: 40		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '선택항목 SEQ'		, Type: 'Text'			, SaveName: 'categoryDetSeq'	, Edit: 1	, Width: 40		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '제휴 업체 ID'		, Type: 'Text'			, SaveName: 'affiliateId'		, Edit: 0	, Width: 40		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '업체명'			, Type: 'Text'			, SaveName: 'companyName'		, UpdateEdit: 0	, Width: 50		, Align: 'Center', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '사업자 번호'		, Type: 'Text'			, SaveName: 'businessNo'		, UpdateEdit: 0	, Width: 40		, Align: 'Center'	, Format: 'SaupNo' , AcceptKeys: 'N', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '무역업 번호'		, Type: 'Text'			, SaveName: 'tradeNo'			, UpdateEdit: 0	, Width: 40		, Align: 'Center', EditLen: 8, AcceptKeys: 'N', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '회원등급'			, Type: 'Text'			, SaveName: 'memberGrade'		, UpdateEdit: 0	, Width: 30		, Align: 'Center', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '신청자 ID'		, Type: 'Text'			, SaveName: 'applyId'			, Edit: 0	, Width: 40		, Align: 'Center'	, Hidden: true});
		ibHeader.addHeader({Header: '신청자'			, Type: 'Text'			, SaveName: 'applyName'			, UpdateEdit: 0	, Width: 40		, Align: 'Center', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '휴대폰'			, Type: 'Text'			, SaveName: 'applyPhone'		, UpdateEdit: 0	, Width: 40		, Align: 'Center'	, Format: 'PhoneNo', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '이메일'			, Type: 'Text'			, SaveName: 'applyEmail'		, UpdateEdit: 0	, Width: 50		, Align: 'Center', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '신청일'			, Type: 'Text'			, SaveName: 'applyDate'			, UpdateEdit: 0	, Width: 40		, Align: 'Center', BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '이용금액'			, Type: 'Int'			, SaveName: 'useAmt'			, Edit: 1	, Width: 40		, Align: 'Center', AcceptKeys: 'N'});
		ibHeader.addHeader({Header: '할인금액'			, Type: 'Int'			, SaveName: 'discountAmt'		, Edit: 1	, Width: 40		, Align: 'Center', AcceptKeys: 'N'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Combo'			, SaveName: 'statusCd'			, Edit: 1	, Width: 30		, Align: 'Center', ComboCode: '${cardStatusSheetComboList.code}' , ComboText: '${cardStatusSheetComboList.codeNm}'});
		ibHeader.addHeader({Header: '신청내역'			, Type: 'Html'			, SaveName: 'detailBtn'			, Width: 25		, Align: 'Center', ToolTip: false});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 2,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            MergeSheet: msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#applySheet')[0];
		createIBSheet2(container, 'applySheet', '100%', '10%');
		ibHeader.initSheet('applySheet');

		applySheet.SetEllipsis(1); 				// 말줄임 표시여부

		// 시작일 선택 이벤트
		datepickerById('searchStartDate', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchEndDate', toDateSelectEvent);
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDate').val());

		if ($('#searchEndDate').val() != '') {
			if (startymd > Date.parse($('#searchEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDate').val());

		if ($('#searchStartDate').val() != '') {
			if (endymd < Date.parse($('#searchStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDate').val('');

				return;
			}
		}
	}

	// INPUT 길이체크
	function checkInputLength(val, maxLen, str) {
		if (val.length > maxLen) {
			alert(str);

			return true;
		}
	}

	function getDcscApplyAfList() {
		if (checkInputLength($('#searchCompanyName').val(), 70, '업체명은 70자 이하로 입력해 주세요.')) {
			return false;
		}
		if (checkInputLength($('#searchApplyName').val(), 30, '신청자는 30자 이하로 입력해 주세요.')) {
			return false;
		}
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectDcscApplyAfList.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				console.log(data);
				setPaging(	// 페이징
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.paginationInfo.totalRecordCount) + '</span> 건');
				applySheet.LoadSearchData({Data: (data.applyList || []) });
			}
		});
	}

	function doExcelDownload() {
		downloadIbSheetExcel(applySheet, '할인서비스_신청현황', '');
	}

	function goPage(pageIndex) {
		$('#searchForm #pageIndex').val(pageIndex);
		getDcscApplyAfList();
	}

	function goCategoryReg() {
		location.href = '/card/dcsc/categoryMngReg.do';
	}

	function applySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (rowType == 'HeaderRow') {
			return;
		}
	}

	function doRowAdd() {
		var index = applySheet.DataInsert(-1);
	}

	function doSave() {
		if(confirm('저장하시겠습니까?')) {
			var jsonParam = {};
			var saveJson = applySheet.GetSaveJson();
			jsonParam.applyList = saveJson.data;

			global.ajax({
				type : 'POST'
				, url : '/card/dcsc/saveDcscApply.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					getDcscApplyAfList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	$('#searchCategoryId').on('change', function() {
		selectAffiliateComboList();
	});

	function selectAffiliateComboList() {
		var searchCategoryId = $('#searchCategoryId').val();
		var searchParams = {
			searchCategoryId : searchCategoryId
		};

		global.ajax({
			type : 'POST'
			, url : '/card/dcsc/selectAffiliateComboList.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, success : function(data){
				$('#searchAffiliateId').empty();

				var content = '';
				content += '<option value="">전체</option>';
				$(data.affiliateComboList).each(function(){
					content += '<option value="' + this.code + '">' + this.codeNm + '</option>';
				});

				$('#searchAffiliateId').append(content);
			}
		});
	}

	function applySheet_OnLoadData(data) {
		var jsonData = $.parseJSON(data);
		var newObj = {};

		// 객체에 값을 새로 할당
		newObj = Object.assign(newObj, jsonData);

		var rowdata = newObj.Data;
		var topMenuId;
		rowdata.forEach(function(item, index){
			var applyId = item.applyId;

			var html = '<button type="button" class="btn_tbl_primary" style="cursor: pointer; width: 90%;" onclick="openApplyAfDetailPopup(' + applyId + ')">상세</button>';
			newObj.Data[index].detailBtn = html;
		});

		return newObj;
	}

	function openApplyAfDetailPopup(applyId) {
		global.openLayerPopup({
			popupUrl : '/card/dcsc/applyServiceAfDetailPopup.do?applyId=' + applyId
		});
	}

	// 업로드
	function exceluploadPopup() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/card/dcsc/applyExcelUpload.do'
			, callbackFunction : function(resultObj){
				getDcscApplyAfList();
			}
		});
	}
</script>