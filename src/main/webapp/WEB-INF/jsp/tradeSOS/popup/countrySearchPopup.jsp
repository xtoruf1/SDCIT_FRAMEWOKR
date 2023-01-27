<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 팝업 타이틀 -->

<div class="flex">
	<h2 class="popup_title">국가 찾기</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="countryList(tblSheet4);">조회</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<form id="countryForm" name="countryForm" method="post">
		<div class="layerWrap" style="width:700px;">
			<table class="formTable">
				<colgroup>
					<col style="width:20%">
					<col>
					<col style="width:20%">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<th>대륙구분</th>
					<td>
						<select name="searchRelCodePop" id="searchRelCodePop" class="form_select"></select>
					</td>
					<th>국가명</th>
					<td>
						<input type="text" id="searchPRelNmPop" name="searchPRelNmPop" class="form_text" onkeydown="javascript:if(event.keyCode == 13) countryList(tblSheet4);">
					</td>
				</tr>
				</tbody>
			</table>
			<div class="tbl_opt mt-20">
				<div id="countryCount" class="total_count"></div>
				<div class="ml-auto btn_group fr">
					<button type="button" class="btn_tbl" onclick="selectCountryArr();">선택</button>
				</div>
			</div>
			<div class="tbl_list">
				<div id="tblSheet4" class="colPosi"></div>
			</div>
		</div>
	</form>
</div>
<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

$(document).ready(function()
		{										//IBSheet 호출
			f_Init_tblSheet();
		});


	function f_Init_tblSheet() {				//국가 팝업
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
	    ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
	    ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		// 국가
		ibHeader.addHeader({Type: "CheckBox"	, Header: "선택"	 , SaveName: "sCheckBox"		, Align: "Center"	, Width: 30		,Edit: true});
		ibHeader.addHeader({Type: "Text"		, Header: "코드명", SaveName: "ctrCode"			, Align: "Center"	, Width: 30		,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "국가명", SaveName: "ctrName"			, Align: "Left"		, Width: 100	,Edit: false});

	    var sheetId = "tblSheet4";
		var container = $("#"+sheetId)[0];

		if (typeof tblSheet4 !== "undefined" && typeof tblSheet4.Index !== "undefined") {
			tblSheet4.DisposeSheet();
		}

		createIBSheet2(container,sheetId, "100%", "300px");
	    ibHeader.initSheet(sheetId);

		countryList(tblSheet4);
	}

function selectCountryArr(){															//확인 버튼
	var chkRowArray = tblSheet4.FindCheckedRow('sCheckBox',{ReturnArray:1});			//체크된 행 배열;
	var ctrCodeArray = new Array();														//선택 행의 ctiCode 값 담을 배열
	var ctrNameArray = new Array();														//선택 행의 ctiName 값 담을 배열


	if(1 > chkRowArray.length){															//국가 선택을 하지 않은 경우
		alert('국가를 선택해주세요');
		return false;
	}

	for(var i = 0; i < chkRowArray.length; i++)									 	//선택한 행의 갯수만큼
	{
		var chkRow = chkRowArray[i];												//선택 행 index

		var chkCtrCode = tblSheet4.GetCellValue(chkRow,'ctrCode');					//선택 행의 ctiCode 값
		ctrCodeArray.push(chkCtrCode);
		var chkCtrName = tblSheet4.GetCellValue(chkRow,'ctrName');					//선택 행의 ctiName 값
		ctrNameArray.push(chkCtrName);
	}

		var ctrArray = {															//선택 행 값 콜백
			 'ctrCodeArray': ctrCodeArray
			,'ctrNameArray': ctrNameArray
		};

		layerPopupCallback(ctrArray);

	closeLayerPopup();
}

</script>