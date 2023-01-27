<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="ratingForm" name="ratingForm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="showTypeB" onclick="setShowType(this, 'B');" class="btn_sm btn_primary btn_modify_auth">키워드 픽</button>
		<button type="button" id="showTypeA" onclick="setShowType(this, 'A');" class="btn_sm btn_primary btn_modify_auth">별점</button>
		<button type="button" id="replyFilterN" onclick="setReplyFilterYn(this, 'N');" class="btn_sm btn_primary btn_modify_auth">클린리뷰 ON</button>
		<button type="button" id="replyFilterY" onclick="setReplyFilterYn(this, 'Y');" class="btn_sm btn_primary btn_modify_auth">클린리뷰 OFF</button>
		<button type="button" onclick="doUpdateRatingAllOpenYn();" class="btn_sm btn_primary btn_modify_auth">대기 리뷰 일괄 허용</button>
		<button type="button" onclick="doUpdateRatingOpenYn();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doDownloadExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상담구분</th>
				<td>
					<select id="searchRatingType" name="searchRatingType" class="form_select" title="상담구분">
						<option value="">전체</option>
						<option value="1">1 : 1상담</option>
						<option value="2">오픈상담</option>
					</select>
				</td>
				<th scope="row">전문가</th>
				<td>
					<input type="text" id="searchExpertNm" name="searchExpertNm" value="" onkeydown="onEnter(doSearch);" class="form_text" />
				</td>
				<th scope="row">허용여부</th>
				<td>
					<select id="searchOpenYn" name="searchOpenYn" class="form_select" title="허용여부">
						<option value="">전체</option>
						<option value="Y">허용</option>
						<option value="B">블라인드</option>
						<option value="N">대기</option>
					</select>
				</td>
            </tr>
            <tr>
				<th scope="row">작성자아이디</th>
				<td>
					<input type="text" id="searchCreBy" name="searchCreBy" value="" onkeydown="onEnter(doSearch);" class="form_text" />
				</td>
				<th scope="row">작성일자</th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchFromDate" name="searchFromDate" value="${firstDate}" class="txt datepicker" placeholder="작성시작일자" title="작성시작일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchFromDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="searchToDate" name="searchToDate" value="${sysDate}" class="txt datepicker" placeholder="작성종료일자" title="작성종료일자" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('searchToDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
            </tr>
             <tr>
				<th scope="row">별점</th>
				<td colspan="5">
					<label class="label_form">
						<input type="checkbox" id="score1" name="score" value="1" class="form_checkbox" title="1개" checked="checked" /> 
						<span class="label">1개</span>
					</label>
					<label class="label_form">
						<input type="checkbox" id="score2" name="score" value="2" class="form_checkbox" title="2개" checked="checked" />
						<span class="label">2개</span>
					</label>
					<label class="label_form">
						<input type="checkbox" id="score3" name="score" value="3" class="form_checkbox" title="3개" checked="checked" />
						<span class="label">3개</span>
					</label>
					<label class="label_form">
						<input type="checkbox" id="score4" name="score" value="4" class="form_checkbox" title="4개" checked="checked" />
						<span class="label">4개</span>
					</label>
					<label class="label_form">
						<input type="checkbox" id="score5" name="score" value="5" class="form_checkbox" title="5개" checked="checked" />
						<span class="label">5개</span>
					</label>
					<input type="hidden" id="reply" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
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
	<div style="width: 100%;height: 100%;">
		<div id="ratingList" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<form id="aiConsultForm" action="<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />" method="post" target="_blank">
<input type="hidden" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" />
</form>
<form id="excelForm" name="excelForm" method="post">
<input type="hidden" name="searchRatingType" />
<input type="hidden" name="searchExpertNm" />
<input type="hidden" name="searchOpenYn" />
<input type="hidden" name="searchCreBy" />
<input type="hidden" name="searchFromDate" />
<input type="hidden" name="searchToDate" />
<input type="hidden" name="scoreArray" />
<input type="hidden" name="reply" />
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '평점', Type: 'Image', SaveName: 'starImg', Width: 80, Align: 'Center', ImgWidth: 100});
	ibHeader.addHeader({Header: '평가', Type: 'Text', SaveName: 'reply', Width: 200, Align: 'Left', Edit: false});
	ibHeader.addHeader({Header: '상담구분', Type: 'Text', SaveName: 'ratingType', Width: 70, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '전문가', Type: 'Text', SaveName: 'expertNm', Width: 60, Align: 'Center', Edit: false, Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '작성자', Type: 'Text', SaveName: 'reqNm', Width: 60, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '작성자아이디', Type: 'Text', SaveName: 'creBy', Width: 60, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '작성일자', Type: 'Text', SaveName: 'creDate', Width: 80, Align: 'Center', Format: 'yyyy-MM-dd HH:mm', Edit: false});
	ibHeader.addHeader({Header: '허용여부', Type: 'CheckBox', SaveName: 'openYn', Width: 110, Align: 'Center', ItemCode: 'Y|B|N', ItemText: '허용|블라인드|대기', MaxCheck: 1, RadioIcon: 1, Edit: true});
	
	ibHeader.addHeader({Header: '평가아이디', Type: 'Text', SaveName: 'ratingId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '상담아이디', Type: 'Text', SaveName: 'prvtConsultId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '오픈상담아이디', Type: 'Text', SaveName: 'pblcConsultId', Width: 0, Align: 'Center', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#ratingList')[0];
		createIBSheet2(container, 'ratingListSheet', '100%', '100%');
		ibHeader.initSheet('ratingListSheet');
		ratingListSheet.SetSelectionMode(4);
		
		if ('${showType}' == 'A') {
			$('#showTypeA').html('별점 ON');
			$('#showTypeB').removeClass('btn_primary');
			$('#showTypeB').addClass('btn_secondary');
			$('#showTypeB').html('키워드 픽 OFF');
		} else {
			$('#showTypeB').html('키워드 픽 ON');
			$('#showTypeA').removeClass('btn_primary');
			$('#showTypeA').addClass('btn_secondary');
			$('#showTypeA').html('별점 OFF');
		}
		
		if ('${replyFilterYn}' == 'Y') {
			$('#replyFilterN').removeClass('btn_primary');
			$('#replyFilterN').addClass('btn_secondary');
		} else {
			$('#replyFilterY').removeClass('btn_primary');
			$('#replyFilterY').addClass('btn_secondary');
		}
		
		// 시작일 선택 이벤트
		datepickerById('searchFromDate', fromDateSelectEvent);
		
		// 종료일 선택 이벤트
		datepickerById('searchToDate', toDateSelectEvent);
		
		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchFromDate').val());
		
		if ($('#searchToDate').val() != '') {
			if (startymd > Date.parse($('#searchToDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchFromDate').val('');
				
				return;
			}
		}
	}
	
	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchToDate').val());
		
		if ($('#searchFromDate').val() != '') {
			if (endymd < Date.parse($('#searchFromDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchToDate').val('');
				
				return;
			}
		}
	}
	
	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.ratingForm.pageIndex.value = pageIndex;
		getList();
	}
	
	function getList() {
		var searchFromDate = $('#searchFromDate').val().replace(/-/gi, '');
		var searchToDate = $('#searchToDate').val().replace(/-/gi, '');
		
		var scoreArray = [];
		for (var i = 0; i < $('input[name="score"]').length; i++) {
			if ($('input[name="score"]').eq(i).is(':checked')) {
				scoreArray.push($('input[name="score"]').eq(i).val());
			}
		}
		
		if (!scoreArray.length) {
			alert('별점을 최소 한개 이상 선택해 주세요.');
			
			return;
		}
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/selectExpertConsultRatingList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchRatingType : $('#searchRatingType').val()
				, searchExpertNm : $('#searchExpertNm').val()
				, searchOpenYn : $('#searchOpenYn').val()
				, searchCreBy : $('#searchCreBy').val()
				, searchFromDate : searchFromDate
				, searchToDate : searchToDate
				, scoreList : scoreArray
				, reply : $('#reply').val()
				, pageIndex : $('#pageIndex').val()
				, pageUnit : $('select[name="pageUnit"] option:selected').val()
			}
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				
				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);
				
				ratingListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function ratingListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('ratingListSheet', row);
	}
	
	function ratingListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('ratingListSheet_OnSearchEnd : ', msg);
		} else {
			// 성명 링크에 볼드 처리
			ratingListSheet.SetColFontBold('expertNm', 1);
		}
	}
	
	// 상세 화면
 	function ratingListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (ratingListSheet.ColSaveName(Col) == 'expertNm') {
				if (Value != '') {
					var rowData = ratingListSheet.GetRowData(Row);
					
					goView(rowData);	
				}
			}	
		}
	}
	
	function goView(ratingObj) {
		if (ratingObj.prvtConsultId != null && ratingObj.prvtConsultId != '') {
			// 1:1 상담
			openPrvtPopup(ratingObj.prvtConsultId);
		} else {
			// 오픈 상담
			openPblcPopup(ratingObj.pblcConsultId);
		}
	}
	
	function openPrvtPopup(prvtConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPrvtConsultRatingPopup.do" />'
			, params : {
				prvtConsultId : prvtConsultId
			}
		});
    }
	
	function openPblcPopup(pblcConsultId) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertPblcConsultRatingPopup.do" />'
			, params : {
				pblcConsultId : pblcConsultId
			}
		});
    }
	
	function setShowType(obj, showType) {
		// 현재 활성화 되어 있으면 return
		if ($(obj).hasClass('btn_primary')) {
			return;
		}
		
		var msg = '';
		if (showType == 'A') {
			msg = '별점 조회로 설정합니다.';
		} else {
			msg = '키워드 픽 조회로 설정합니다.';
		}
		
		if (confirm(msg + ' 진행 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/updateShowType.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					showType : showType
				}
				, async : true
				, spinner : true
				, success : function(data){
					if (showType == 'A') {
						$('#showTypeA').removeClass('btn_secondary');
						$('#showTypeA').addClass('btn_primary');
						$('#showTypeA').html('별점 ON');
						$('#showTypeB').removeClass('btn_primary');
						$('#showTypeB').addClass('btn_secondary');
						$('#showTypeB').html('키워드 픽 OFF');
					} else {
						$('#showTypeA').removeClass('btn_primary');
						$('#showTypeA').addClass('btn_secondary');
						$('#showTypeA').html('별점 OFF');
						$('#showTypeB').removeClass('btn_secondary');
						$('#showTypeB').addClass('btn_primary');
						$('#showTypeB').html('키워드 픽 ON');
					}
				}
			});
		}
	}
	
	function setReplyFilterYn(obj, replyFilterYn) {
		// 현재 활성화 되어 있으면 return
		if ($(obj).hasClass('btn_primary')) {
			return;
		}

		var msg = '클린리뷰를 ';
		if (replyFilterYn == 'Y') {
			msg += 'OFF 합니다.';
		} else {
			msg += 'ON 합니다.';
		}
		
		if (confirm(msg + ' 진행 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/updateReplyFilterYn.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					replyFilterYn : replyFilterYn
				}
				, async : true
				, spinner : true
				, success : function(data){
					if (replyFilterYn == 'Y') {
						$('#replyFilterY').removeClass('btn_secondary');
						$('#replyFilterY').addClass('btn_primary');
						$('#replyFilterN').removeClass('btn_primary');
						$('#replyFilterN').addClass('btn_secondary');
					} else {
						$('#replyFilterY').removeClass('btn_primary');
						$('#replyFilterY').addClass('btn_secondary');
						$('#replyFilterN').removeClass('btn_secondary');
						$('#replyFilterN').addClass('btn_primary');
					}
				}
			});
		}
	}
	
	// 대기 리뷰 일괄 허용
	function doUpdateRatingAllOpenYn() {
		if (confirm('대기중인 모든 평가를 허용으로 변경합니다. 진행 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/updateExpertConsultRatingAllOpenYn.do" />'
				, dataType : 'json'
				, type : 'POST'
				, async : true
				, spinner : true
				, success : function(data){
					getList();
				}
			});
		}
	}

	// 허용여부 수정한 항목 업데이트
	function doUpdateRatingOpenYn() {
		var result = ratingListSheet.GetSaveJson();
		var ratingList = result['data'];
		
		var paramList = [];
		if (ratingList.length > 0) {
			ratingList.forEach(function(item){
				var openYnItems = item['openYn'].split('|');
				openYnItems.forEach(function(openYnItem){
					if (openYnItem.split(':')[1] == 1) {
						paramList.push({
							ratingId : item['ratingId']
							, openYn : openYnItem.split(':')[0]
						});
						
						return false;
					}
				});
			});
		}
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/updateExpertConsultRatingListOpenYn.do" />'
			, dataType : 'json'
			, contentType : 'application/json'
			, type : 'POST'
			, data : JSON.stringify({
				ratingList : paramList
			})
			, async : true
			, spinner : true
			, success : function(data){
				alert('허용여부를 수정하였습니다.');
				
				getList();
			}
		});
	}
	
	function doSearchAiConsult(reqContents) {
		$('#reqContents').val(reqContents);
		$('#aiConsultForm').submit();
	}
	
	// 엑셀다운로드
	function doDownloadExcel() {
		var searchFromDate = $('#searchFromDate').val().replace(/-/gi, '');
		var searchToDate = $('#searchToDate').val().replace(/-/gi, '');
		
		var scoreArray = [];
		for (var i = 0; i < $('input[name="score"]').length; i++) {
			if ($('input[name="score"]').eq(i).is(':checked')) {
				scoreArray.push($('input[name="score"]').eq(i).val());
			}
		}
		
		var f = document.excelForm;
		f.action = '<c:url value="/tradeSOS/exp/expertConsultRatingExcelList.do" />';
		f.searchRatingType.value = $('#searchRatingType').val();
		f.searchExpertNm.value = $('#searchExpertNm').val();
		f.searchOpenYn.value = $('#searchOpenYn').val();
		f.searchCreBy.value = $('#searchCreBy').val();
		f.searchFromDate.value = searchFromDate;
		f.searchToDate.value = searchToDate;
		f.scoreArray.value = scoreArray.join(',');
		f.reply.value = $('#reply').val();
		f.target = '_self';
		f.submit();
	}
	
	// 달력 초기화
	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}
</script>