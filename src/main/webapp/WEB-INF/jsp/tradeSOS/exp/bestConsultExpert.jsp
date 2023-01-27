<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="bestExpertSave" onclick="openBestExpertPopup();" class="btn_sm btn_primary btn_modify_auth disabled" disabled="disabled">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcelIBSheetDownload();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col style="width: 45%;" />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">평가기준기간</th>
				<td>
					<select id="searchEvaluation" name="searchEvaluation" onchange="showDatepicker(this);" class="form_select" title="평가기준기간">
						<c:forEach var="item" items="${lastQuarterList}" varStatus="status">
							<option value="${status.count}" <c:if test="${beforeQuarter eq status.count}">selected="selected"</c:if>>${item.quarterNm}</option>
						</c:forEach>
						<option value="">전체</option>
						<option value="999">사용자지정</option>
					</select>
					<div id="divDatepicker"	style="margin-left: 5px;display: none;">
						<div class="group_datepicker">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchFromDate" name="searchFromDate" value="" class="txt datepicker" style="width: 100px;" placeholder="평가시작일자" title="평가시작일자" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
								<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
							<div class="spacing">~</div>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchToDate" name="searchToDate" value="" class="txt datepicker" style="width: 100px;" placeholder="평가종료일자" title="평가종료일자" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
								<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</div>
				</td>
				<th scope="row">전문가</th>
				<td>
					<select id="searchExpertId" name="searchExpertId" class="form_select" title="전문가">
						<option value="">전체</option>
						<c:forEach var="item" items="${expertList}" varStatus="status">
							<option value="${item.expertId}">${item.expertNm}</option>
						</c:forEach>
					</select>
				</td>
            </tr>
            <tr>
            	<th rowspan="2" scope="row">상담분야</th>
				<td colspan="3">
					<c:forEach var="item" items="${consultTypeList}" varStatus="status">
						<label class="label_form list">
							<input type="checkbox" name="searchConsultTypeCd" value="${item.consultTypeCd}" class="form_checkbox" title="${item.consultTypeNm}" />
							<span class="label">${item.consultTypeNm}</span>
						</label>
					</c:forEach>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="expertList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '전문가|전문가', Type: 'Text', SaveName: 'expertNm', Width: 120, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '상담분야|상담분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 180, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: '1:1상담|전체\n건수', Type: 'Int', SaveName: 'totalPrvtCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '1:1상담|전문가\n취소', Type: 'Int', SaveName: 'expertCancelCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '1:1상담|전문가\nNoShow', Type: 'Int', SaveName: 'expertNoshowCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '1:1상담|평균\n평점', Type: 'Int', SaveName: 'avgPrvtScore', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '1:1상담|최소\n평점', Type: 'Int', SaveName: 'minPrvtScore', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '오픈상담|전체\n건수', Type: 'Int', SaveName: 'totalPblcCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '오픈상담|채택\n건수', Type: 'Int', SaveName: 'chooseConsultCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '오픈상담|평균\n평점', Type: 'Int', SaveName: 'avgPblcScore', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '오픈상담|최소\n평점', Type: 'Int', SaveName: 'minPblcScore', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: 'BEST 선정 이력|상담\n사례', Type: 'Int', SaveName: 'bestCaseChooseCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: 'BEST 선정 이력|상담\n위원', Type: 'Int', SaveName: 'bestExpertChooseCnt', Width: 90, Align: 'Right', Format: '#,##0', Edit: false,  ZeroToReplaceChar: ''});
	ibHeader.addHeader({Header: '최근 BEST 위원\n선정 기간|최근 BEST 위원\n선정 기간', Type: 'Text', SaveName: 'lastBestExpertQuarter', Width: 120, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '선정 여부|선정 여부', Type: 'CheckBox', SaveName: 'chooseYn', Width: 130, Align: 'Center', ItemCode: 'Y|N', ItemText: 'Y|N', MaxCheck: 1, RadioIcon: 1, Edit: true});

	ibHeader.addHeader({Header: '전문가아이디', Type: 'Text', SaveName: 'expertId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '상담분야코드', Type: 'Text', SaveName: 'consultTypeCd', Width: 0, Align: 'Center', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, MergeSheet: 5, NoFocusMode: 0, Ellipsis: 1, HeaderSort: 1, SortEventMode: 0, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 1, ColMove: true});

	$(document).ready(function(){
		var container = $('#expertList')[0];
		createIBSheet2(container, 'expertListSheet', '100%', '580px');
		ibHeader.initSheet('expertListSheet');
		expertListSheet.SetSelectionMode(4);

		getList();
	});

	function getChooseCnt() {
		var now = new Date();				// 현재 날짜 및 시간
		var month = now.getMonth() + 1;		// 월

		// 1, 4, 7, 10월만 저장을 할 수 있다.(분기별 첫번재 달)
		// if (month == 1 || month == 4 || month == 7 || month == 10) {
			// 시트의 모든 데이터를 json 객체로 추출
			var jsonData = expertListSheet.ExportData({
				'Type' : 'json'
			});

			// 선정여부에서 선정된 건수를 체크한다.
			var chooseData = (jsonData.data || []).filter(function(element){
				return element.chooseYn == 'Y:1|N:0';
			});

			if (chooseData.length == 3) {
				$('#bestExpertSave').removeClass('disabled');
				$('#bestExpertSave').attr('disabled', false);
			} else {
				$('#bestExpertSave').addClass('disabled');
				$('#bestExpertSave').attr('disabled', true);
			}
		// }
	}

	function doSearch() {
		getList();
	}

	var sortCol = '';
	var sortDirection = '';

	function getList() {
		var searchFromDate = $('#searchFromDate').val().replace(/-/gi, '');
		var searchToDate = $('#searchToDate').val().replace(/-/gi, '');

		var consultTypeArray = [];
		for (var i = 0; i < $('input[name="searchConsultTypeCd"]').length; i++) {
			if ($('input[name="searchConsultTypeCd"]').eq(i).is(':checked')) {
				consultTypeArray.push($('input[name="searchConsultTypeCd"]').eq(i).val());
			}
		}

		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectBestExpertList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchEvaluation : $('#searchEvaluation').val()
				, searchFromDate : searchFromDate
				, searchToDate : searchToDate
				, searchExpertId : $('#searchExpertId').val()
				, consultTypeCdList : consultTypeArray
				, sortCol : sortCol
				, sortDirection : sortDirection
			}
			, async : true
			, spinner : true
			, success : function(data){
				expertListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function expertListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('expertListSheet', row);
	}

	function expertListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('expertListSheet_OnSearchEnd : ', msg);
		} else {
			getChooseCnt();
		}
	}

	function expertListSheet_OnSort(col, sortOrder) {
		sortCol = expertListSheet.ColSaveName(0, col);
		sortDirection = sortOrder;

		getList();
	}

	function expertListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (expertListSheet.ColSaveName(Col) == 'chooseYn') {
				var chooseYn = expertListSheet.GetCellValue(Row, 'chooseYn');

				getChooseCnt();
			}
		}
	}

	function openBestExpertPopup() {
		// 시트의 모든 데이터를 json 객체로 추출
		var jsonData = expertListSheet.ExportData({
			'Type' : 'json'
		});

		// 선정여부가 Y인 데이터만 가져온다.
		var chooseData = (jsonData.data || []).filter(function(element){
			return element.chooseYn == 'Y:1|N:0';
		});

		var paramList = [];
		if (chooseData.length > 0) {
			chooseData.forEach(function(item){
				paramList.push({
					expertId : item.expertId
					, expertNm : item.expertNm
					, consultTypeCd : item.consultTypeCd
					, consultTypeNm : item.consultTypeNm
					, selectQ : '${currentQuarter}'
				});
			});
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/quarterBestExpertPopup.do" />'
			, params : {
				expertList : paramList
			}
			, callbackFunction : function(resultObj){
				doSave(paramList);
			}
		});
	}

	function doSave(obj) {
		if (confirm('BEST 상담 위원으로 선정 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/saveQuarterBestExpert.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					selectQ : '${currentQuarter}'
					, expertList : obj
				}
				, async : true
				, spinner : true
				, success : function(data){
					// 레이어 닫기
					closeLayerPopup();

					getList();
				}
			});
		}
	}

	function showDatepicker(objId) {
		if (objId.value == '999') {
			$('#divDatepicker').css('display', 'inline-flex');
		} else {
			$('#divDatepicker').css('display', 'none');
		}
	}

	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}

	function doExcelIBSheetDownload() {
		downloadIbSheetExcel(expertListSheet, 'BEST상담위원', '');
	}
</script>