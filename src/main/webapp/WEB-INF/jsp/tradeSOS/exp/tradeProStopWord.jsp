<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="frm" name="frm" method="get" onsubmit="return false;">
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="btnAprv" class="btn_sm btn_primary btn_modify_auth" onclick="addStopword();">추가</button>
		<button type="button" id="btnAprvCancel" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">키워드</th>
				<td>
					<input type="text" id="sKeyWord" name="sKeyWord" value="${param.sKeyWord}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="키워드" />
				</td>
				<th scope="row">사용여부</th>
				<td>
					<select id="sUseYn" name="sUseYn" class="form_select">
						<option value="">::: 전체 :::</option>
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</td>
            </tr>
			<tr>
				<th scope="row">등록자</th>
				<td>
					<input type="text" id="sCratNm" name="sCratNm" value="${param.sCratNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="등록자" />
				</td>
				<th scope="row">수정자</th>
				<td>
					<input type="text" id="sChngNm" name="sChngNm" value="${param.sChngNm}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="수정자" />
				</td>
            </tr>
			<tr>
				<th scope="row">일자</th>
				<td colspan="3">
					<div class="flex align_center">
						<select name="sPeriodType" id="sPeriodType" class="form_select wAuto">
							<option value="CRAT">등록일자</option>
							<option value="CHNG">수정일자</option>
						</select>
						<div class="group_datepicker ml-8">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" class="txt datepicker" name="sStDate" id="sStDate" readonly size="10" maxlength="50" value=""/>
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('sStDate');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text"  class="txt datepicker" name="sEdDate" id="sEdDate" readonly size="10" maxlength="50" value=""/>
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('sEdDate');" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</div>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>
	<div style="width: 100%;height: 100%;">
		<div id="sheetDiv" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', 			Type: 'Status', 	SaveName: 'status', 	Hidden: true});
	ibHeader.addHeader({Header: 'No',			Type: 'Text', 		SaveName: 'idx', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '키워드',			Type: 'Text', 		SaveName: 'stopword', 	Width: 300, Align: 'Left'});
	ibHeader.addHeader({Header: '등록일자',		Type: 'Text', 		SaveName: 'cratDt', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '등록자',			Type: 'Text', 		SaveName: 'cratNm', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '수정일자',		Type: 'Text', 		SaveName: 'chngDt', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '수정자',			Type: 'Text', 		SaveName: 'chngNm', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '사용여부',		Type: 'CheckBox', 	SaveName: 'useYn', 		Width: 100, Align: 'Center', ItemText: '사용|미사용', ItemCode: 'Y|N', MaxCheck: 1, RadioIcon: 1});
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'stopwordSheet', '100%', '100%');
		ibHeader.initSheet('stopwordSheet');
		stopwordSheet.SetSelectionMode(4);

		// 시작일 선택 이벤트
		datepickerById('sStDate', fromDateSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('sEdDate', toDateSelectEvent);

		//목록조회 호출
		getList();
	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#sStDate').val());

		if ($('#sEdDate').val() != '') {
			if (startymd > Date.parse($('#sEdDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#sStDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#sEdDate').val());

		if ($('#sStDate').val() != '') {
			if (endymd < Date.parse($('#sStDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#sEdDate').val('');

				return;
			}
		}
	}

	//시트가 조회된 후 실행
	function stopwordSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('stopwordSheet_OnSearchEnd : ', msg);
    	} else {
    	}
    }

	//시트 조회 완료 후 하나하나의 행마다 실행
	function stopwordSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('stopwordSheet', row);
	}

	//검색
	function doSearch() {
		goPage(1);
	}

	//페이징 검색
	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	//달력 초기화
	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}

	//목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradePro/stopword/selectTradeProStopWordList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
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

				stopwordSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function doSave(){
		if (confirm('저장 하시겠습니까?')) {
			var af = $('#frm').serializeObject();

			var saveJson = stopwordSheet.GetSaveJson();
			if (saveJson.data.length) {
				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					$.each(value1, function(key2, value2) {
						map = {};

						map.status = value2.status;
						map.stopword = value2.stopword;
						map.useYn = value2.useYn=='Y:1|N:0'?'Y':'N';

						list.push(map);
					});

					af['stopwordList'] = list;
				});
			}

			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradePro/stopword/updateTradeProStopWord.do" />'
				, data : JSON.stringify(af)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					doSearch();
				}
			});
		}
	}

	function addStopword(){

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/tradePro/stopword/popup/tradeProStopWordAddPop.do'
			, params : {}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				getList();
			}
		});
	}

</script>