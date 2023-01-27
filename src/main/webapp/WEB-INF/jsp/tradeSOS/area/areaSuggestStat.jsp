<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
 /**
  * @Class Name : sceneSuggestStat.jsp
  * @Description : 무역현장컨설팅 통계화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2021.09.29	양지환		최초 생성
  *
  * @author 양지환
  * @since 2021.09.29
  * @version 1.0
  * @see
  *
  */
%>
<%--<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>--%>
<!-- 무역애로사항 건의 - 통계 -->
<div class="page_tradesos">

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="doExcelDownload();" >엑셀 다운</button>
			<button type="button" class="btn_sm btn_secondary" onclick="doReset();">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>
	<form id="searchFrm" name="searchFrm">
		<input type="hidden" name="searchYear" id="searchYear" value="<c:out value="${year}"/>"/>
		<input type="hidden" name="searchMonth" id="searchMonth" value="<fmt:formatNumber minIntegerDigits="2" value="${month}" type="number"/>"/>
		<table class="formTable">
			<colgroup>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">등록일</th>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="dateFrom" name="dateFrom" value='' class="txt monthpicker" placeholder="검색월" title="검색월" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('dateFrom');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
							</span>
						</div>
					</td>
				</tr>
			</tbody>
		</table><!-- // 검색 테이블-->
	</form>
	<!-- 리스트 테이블 -->
	<div class="tbl_scrollx mt-20">
		<div id='areaSuggestStatSheet' class="colPosi"></div>
	</div>
</div> <!-- // page_tradesos -->


<script type="text/javascript">
	var bExcel = false; // 엑셀다운로드 가능(조회 후 가능)

	$(document).ready(function()
	{
		getList();				// 목록 조회
	});

	function f_Init_areaSuggestStatSheet(data)
	{
		if (typeof areaSuggestStatSheet !== "undefined" && typeof areaSuggestStatSheet.Index !== "undefined") {
			areaSuggestStatSheet.DisposeSheet();
		}

		var searchYear =  parseInt($("#searchYear").val());
		var searchMonth = parseInt($("#searchMonth").val());

		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, MergeSheet:5, FrozenCol:1});
		//SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet:msPrevColumnMerge + msHeaderOnly});
		ibHeader.setHeaderMode({Sort: 0, ColMove: true});

		ibHeader.addHeader({Type: "Text"	, Header: "상담분야|상담분야|상담분야", SaveName: "CODENM", 	Align: "Center", 	Width: 200, 	Edit: false });

			var minusYear = 3;
			for (var i = 1 ; i < 5 ; i++){
						ibHeader.addHeader({Type: "Int"		, Header: (searchYear-minusYear)+'|'+searchMonth+"월"+'|'+"건수" 			, SaveName: "cnt0"+i 	 , Align: "Right", 	Width: 100, 	Edit: false,  ZeroToReplaceChar: ''});
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+searchMonth+"월"+'|'+"비중(%)"		, SaveName: "per0"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+searchMonth+"월"+'|'+"증감률(%)"		, SaveName: "upPer0"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
						ibHeader.addHeader({Type: "Int"		, Header: (searchYear-minusYear)+'|'+searchMonth+"월 누계"+'|'+"건수"		, SaveName: "cnt1"+i 	 , Align: "Right", 	Width: 100, 	Edit: false,  ZeroToReplaceChar: ''});
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+searchMonth+"월 누계"+'|'+"비중(%)"	, SaveName: "per1"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+searchMonth+"월 누계"+'|'+"증감률(%)"	, SaveName: "upPer1"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
						ibHeader.addHeader({Type: "Int"		, Header: (searchYear-minusYear)+'|'+"소계"+'|'+"건수"						, SaveName: "cnt2"+i 	 , Align: "Right", 	Width: 100, 	Edit: false,  ZeroToReplaceChar: ''});
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+"소계"+'|'+"비중(%)"					, SaveName: "per2"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
						ibHeader.addHeader({Type: "Text"	, Header: (searchYear-minusYear)+'|'+"소계"+'|'+"증감률(%)"					, SaveName: "upPer2"+i 	 , Align: "Right", 	Width: 100, 	Edit: false });
				minusYear--;
			}



		var sheetId = "areaSuggestStatSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		areaSuggestStatSheet.LoadSearchData({Data: data.result.resultList});
	};

	function doSearch() {
		getList();
	}

	/**
	 * 무역실무 통계 리스트 가져오기
	 */
	function getList() {
		var dateFromVal = $('#dateFrom').val();
		if(dateFromVal == '')									//첫 조회시 이번달 날짜 값 설정
		{
			var pYear = $("#searchYear").val();
			var pMonth = $("#searchMonth").val();
			$('#dateFrom').val(pYear+'-'+pMonth);
		}
		if(dateFromVal != '')									//첫 조회가 아닌 경우 선택한 날짜 값 설정
		{
			var year = $("#dateFrom").val().split("-")[0];
			var month = $("#dateFrom").val().split("-")[1];

			$("#searchYear").val(year);
			$("#searchMonth").val(month);
		}


		$.ajax({
			url: '/tradeSOS/area/areaSuggestStatListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#searchFrm').serialize(),
			success: function (data) {
				bExcel = true;
				f_Init_areaSuggestStatSheet(data);
			},
			error:function(request,status,error) {
				alert('무역실무 상담 통계 조회에 실패했습니다.');
			}
		});
	}

	function getNum(val){
		if (isNaN(val) || val == "") {
			return 0;
		}
		return val;
	}

	// 엑셀 다운받기
	function doExcelDownload() {
		if(!bExcel) {
			alert('조회 후 다운로드 가능합니다.');
			return;
		}
		var searchMonth = $('#searchMonth').val();
		var minusYear = 3;
		var dwCols = '';
		for (var i = 1 ; i < 5 ; i++){
				dwCols += "|cnt0"+i
			    dwCols += "|per0"+i
				dwCols += "|upPer0"+i
				dwCols += "|cnt1"+i
				dwCols += "|per1"+i
				dwCols += "|upPer1"+i
				dwCols += "|cnt2"+i
				dwCols += "|per2"+i
				dwCols += "|upPer2"+i
			minusYear--;
		}
		var params = {
			'FileName' : '무역실무통계_'+searchMonth+'월'+'.xlsx'
			, 'SheetName' : 'Sheet1'
			, 'SheetDesign' : 1
			, 'Merge' : 1
			, 'CheckBoxOnValue' : 'Y'
			, 'CheckBoxOffValue' : 'N'
			, 'AutoSizeColumn' : 1
			, 'DownCols' : "CODENM"+dwCols
		};
			downloadIbSheetExcel(areaSuggestStatSheet, '', params);
	}




	function doReset() {																					//초기화
		$('#searchYear').val(<c:out value="${year}"/>);
		$('#searchMonth').val(<c:out value="${month}"/>);
		var nowMonth = $('#searchMonth').val();
		var nowYear = $('#searchYear').val();
		$('#dateFrom').val(nowYear+'-'+nowMonth);
		doSearch();
	}
</script>