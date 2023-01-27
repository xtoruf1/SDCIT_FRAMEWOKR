<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">만족도 평가 상세</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<form id="surveyDetail" name="surveyDetail">
	<input type="hidden" id="expertId" name="expertId" value="<c:out value="${searchVO.expertId}"/>"/>
	<input type="hidden" id="expertNm" name="expertNm" value="<c:out value="${searchVO.expertNm}"/>"/>
	<input type="hidden" id ="recDateFrom" name="recDateFrom" value="<c:out value="${searchVO.recDateFrom}"/>">
	<input type="hidden" id="recDateTo" name="recDateTo" value="<c:out value="${searchVO.recDateTo}"/>">
</form>
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />

<!-- 만족도 상세 팝업 -->
<div class="popup_body">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:20%">
				<col>
				<col style="width:20%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">자문위원</th>
					<td id="expertNmTxt"></td>
					<th scope="row">평가일자</th>
					<td id="searchDate"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="w100p mt-20">
		<div id="surveyDetailSheet" class="colPosi mt-20"></div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function() { //IBSheet 호출

		// 자문위원 & 평가일자 세팅
		$("#expertNmTxt").text($('#expertNm').val());
		$("#searchDate").text($('#recDateFrom').val() + ' ~ ' + $('#recDateTo').val());

		setSurveyDetailGrid();		// 헤더  Sheet 셋팅

	});

	function setSurveyDetailGrid() {

		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "Text", 	Header: "일자", 			SaveName: "regDate", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Text",	Header: "업체명", 		SaveName: "company", 	Align: "Center",	 Width: 200 });
		ibHeader.addHeader({Type: "Text",	Header: "상담채널", 		SaveName: "matchChannel", 	Align: "Center",	 Width: 120 });
		ibHeader.addHeader({Type: "Int",	Header: "전반적 만족도", 	SaveName: "survey02", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Int",	Header: "위원 전문성", 	SaveName: "survey03", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Int", 	Header: "위원 친절도", 	SaveName: "survey04", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Int", 	Header: "재상담 의향", 	SaveName: "survey05", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Int", 	Header: "추천 의향", 	SaveName: "survey06", 	Align: "Center", 	Width: 120 });
		ibHeader.addHeader({Type: "Float", 	Header: "합계", 			SaveName: "totalAvg", 	Align: "Center",Format : "#,###.##",	 Width: 120 });

		if (typeof surveyDetailSheet !== "undefined" && typeof surveyDetailSheet.Index !== "undefined") {
			surveyDetailSheet.DisposeSheet();
		}

		var sheetId = "surveyDetailSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container,sheetId, "100%", "250px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		surveyDetailSheet.SetEditable(0);
		getList();
	}

	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatSurveyDetailAjax.do" />'
			, data : $('#surveyDetail').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				surveyDetailSheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	// 상세 팝업 - 텍스트 컬러 변경
	function surveyDetailSheet_OnRowSearchEnd(Row) {
		if (surveyDetailSheet.GetCellValue(Row, 2) == "불일치" ){
			surveyDetailSheet.SetCellFontColor(Row, 2, "#FF0000");
		}
	};

</script>