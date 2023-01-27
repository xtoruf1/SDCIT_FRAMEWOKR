<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" id="btnSearchReset" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" id="btnSearch" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<table class="formTable">
		<colgroup>
			<col style="width:14%" />
			<col style="" />
			<col style="width:14%" />
			<col style="" />
		</colgroup>
		<tbody>
			<tr>
				<th>대상년도</th>
				<td>
					<select name="searchBaseYear" id="searchBaseYear" class="form_select">
						<c:forEach items="${yearList}" var="resultInfo" varStatus="status">
							<option value="<c:out value="${ resultInfo.baseYear}" />" label="<c:out value="${ resultInfo.baseYear}" />" <c:out value="${ searchVO.s_base_year eq resultInfo.baseYear ? 'selected' : '' }" /> />
						</c:forEach>
					</select>
				</td>
				<th>표시항목</th>
				<td>
					<label class="label_form">
						<input type="radio" name="sheetType" class="form_radio" value="TYPE" checked="checked">
						<span class="label">보험종류별</span>
					</label>
					<label class="label_form">
						<input type="radio" name="sheetType" class="form_radio" value="GRADE">
						<span class="label">회원등급별</span>
					</label>
					<label class="label_form">
						<input type="radio" name="sheetType" class="form_radio" value="ROUND">
						<span class="label">회차별</span>
					</label>
				</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="cont_block" >
	<div id="sheetDiv"></div>
</div>
</form>

<script type="text/javascript">

	var headerCnt = 0;

	$(document).ready(function(){

		setSheetHeader('TYPE');

		$("input[name='sheetType']:radio").change(function () {	// 표시항목 선택시

	        var gubun = this.value;

	        if(gubun == 'TYPE') {

	        	setSheetHeader(gubun);

	        } else if(gubun == 'GRADE') {

	        	setSheetHeader(gubun);

	        } else if(gubun == 'ROUND') {

	        	setSheetHeader(gubun);
	        }
		});

	});

	function setSheetHeader(val) {	// 시트 해더

		if(val == 'TYPE') {

			$('#sheetDiv').empty();
			$('#sheetDiv').append('<div id="insuranceTypeStatusSheet" class="sheet"></div>');

			if (typeof container !== 'undefined' && typeof insuranceTypeStatusSheet.Index !== 'undefined') {
				insuranceTypeStatusSheet.DisposeSheet();
			}

			getStatusInfo(val);
		}

		if(val == 'GRADE') {

			$('#sheetDiv').empty();
        	$('#sheetDiv').append('<div id="insuranceGradeStatusSheet" class="sheet"></div>');

        	if (typeof container !== 'undefined' && typeof insuranceGradeStatusSheet.Index !== 'undefined') {
    			insuranceGradeStatusSheet.DisposeSheet();
    		}

        	getStatusInfo(val);
		}

		if(val == 'ROUND') {

			$('#sheetDiv').empty();
        	$('#sheetDiv').append('<div id="insuranceRoundStatusSheet" class="sheet"></div>');

        	if (typeof container !== 'undefined' && typeof insuranceRoundStatusSheet.Index !== 'undefined') {
    			insuranceRoundStatusSheet.DisposeSheet();
    		}

        	getStatusInfo(val);
		}
	}

	function getStatusInfo(val) {	// 시트 데이터 조회

		global.ajax({
			type : 'POST'
			, url : "/insurance/selectInsuranceStatus.do"
			, data : {'searchBaseYear' : $('#searchBaseYear').val(),
					  'sheetType' : val
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				if(val == 'TYPE') {
					var headerList = data.insResult.insTypeList;

					headerCnt = headerList.length;

					setSheetHeader_insuranceType(headerList);
					insuranceTypeStatusSheet.LoadSearchData({Data: (data.insResult.resultList || []) });

				}

				if(val == 'GRADE') {
					var headerList = data.insResult.insTypeList;

					headerCnt = headerList.length;

					setSheetHeader_insuranceGrade(headerList);
					insuranceGradeStatusSheet.LoadSearchData({Data: (data.insResult.resultList || []) });

				}

				if(val == 'ROUND') {
					setSheetHeader_insuranceRound();
					insuranceRoundStatusSheet.LoadSearchData({Data: (data.insResult.resultList || []) });
					insuranceRoundStatusSheet.SetSumText(0, '합계');
				}
			}
		});
	}

	function setSheetHeader_insuranceType(list) {	// 보험별 가입 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '회차|회차'			, Type: 'Text'			, SaveName: 'seq'		, Edit: false	, Width: 40		, Align: 'Center'});

		for(var i = 0; i < list.length; i++) {
			ibHeader.addHeader({Header: list[i].codeNm+'|신청수'		, Type: 'AutoSum'			, SaveName: 'cnt'+list[i].code			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|보험료'		, Type: 'AutoSum'			, SaveName: 'amt'+list[i].code			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		}

		ibHeader.addHeader({Header: '소계|신청수'			, Type: 'AutoSum'			, SaveName: 'cntAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '소계|보험료'			, Type: 'AutoSum'			, SaveName: 'amtAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

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

		var container = $('#insuranceTypeStatusSheet')[0];
		createIBSheet2(container, 'insuranceTypeStatusSheet', '100%', '100%');
		ibHeader.initSheet('insuranceTypeStatusSheet');
		insuranceTypeStatusSheet.SetSelectionMode(4);
	}

	function setSheetHeader_insuranceGrade(list) {	// 회원등급별 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '회차|회차'			, Type: 'Text'			, SaveName: 'seq'		, Edit: false	, Width: 80		, Align: 'Center'});

		for(var i = 0; i < list.length; i++) {
			ibHeader.addHeader({Header: list[i].codeNm+'|실버'		, Type: 'AutoSum'			, SaveName: 'silver'+list[i].code		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|골드'		, Type: 'AutoSum'			, SaveName: 'gold'+list[i].code			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|로얄'		, Type: 'AutoSum'			, SaveName: 'royal'+list[i].code		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
			ibHeader.addHeader({Header: list[i].codeNm+'|계'			, Type: 'AutoSum'			, SaveName: 'all'+list[i].code			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		}

		ibHeader.addHeader({Header: '종합|실버'			, Type: 'AutoSum'			, SaveName: 'silverAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '종합|골드'			, Type: 'AutoSum'			, SaveName: 'goldAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '종합|로얄'			, Type: 'AutoSum'			, SaveName: 'royalAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '종합|계'				, Type: 'AutoSum'			, SaveName: 'cntAll'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});


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

		var container = $('#insuranceGradeStatusSheet')[0];
		createIBSheet2(container, 'insuranceGradeStatusSheet', '100%', '100%');
		ibHeader.initSheet('insuranceGradeStatusSheet');
		insuranceGradeStatusSheet.SetSelectionMode(4);

	}

	function setSheetHeader_insuranceRound() {	// 회차별 가입 현황 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '회차'			, Type: 'Text'			, SaveName: 'seq'			, Edit: false	, Width: 40		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청업체'			, Type: 'AutoSum'		, SaveName: 'reqCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '가입완료'			, Type: 'AutoSum'		, SaveName: 'finCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '가입보류(미납)'	, Type: 'AutoSum'		, SaveName: 'nonpayCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '가입대기'			, Type: 'AutoSum'		, SaveName: 'delayCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '가입불가'			, Type: 'AutoSum'		, SaveName: 'rejectCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '환불'			, Type: 'AutoSum'		, SaveName: 'returnCnt'		, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

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

		var container = $('#insuranceRoundStatusSheet')[0];
		createIBSheet2(container, 'insuranceRoundStatusSheet', '100%', '100%');
		ibHeader.initSheet('insuranceRoundStatusSheet');
		insuranceRoundStatusSheet.SetSelectionMode(4);

	}

	function insuranceTypeStatusSheet_OnSearchEnd() {
		var sumRow = Number(insuranceTypeStatusSheet.FindSumRow());
		insuranceTypeStatusSheet.SetSumValue(0, 0, "합계");          // 합계 텍스트
		insuranceTypeStatusSheet.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
	}

	function insuranceGradeStatusSheet_OnSearchEnd() {
		var sumRow = Number(insuranceGradeStatusSheet.FindSumRow());
		insuranceGradeStatusSheet.SetSumValue(0, 0, "합계");          // 합계 텍스트
		insuranceGradeStatusSheet.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
	}

	function doSearch() {	// 조회

		var nowSheet = $("input[name='sheetType']:radio").val();
		setSheetHeader(nowSheet);

	}

	function doExcelDownload() {	// 엑살다운로드

		$('#searchForm').attr('action', '/insurance/insuranceStatusExcelDown.do');
		$('#searchForm').submit();

	}

	function doClear() {	// 초기화
		location.reload();
	}

</script>