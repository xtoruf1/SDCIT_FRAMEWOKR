<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
.modal-outer{width:100%;}
.modal-content{padding:0;}
.popContinent{height:100%; max-height:100%;}
</style>

<!-- 팝업 타이틀 -->
<div class="flex m_hidden">
	<h2 class="popup_title">수상자 검색</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">조회</button>
		<button class="btn_sm btn_secondary" onclick="closePopup();">닫기</button>
	</div>
</div>
<div class="tradeDay_header pc_hidden">
	<div class="inner">
		<h1 class="logo">
			<a href="/main.do">
				<img src="/images/common/logo_tradeday.png" alt="무역지원서비스">
			</a>
		</h1>
		<span class="pc_hidden">무역의 날 기념식 수상자 확인</span>
	</div>
</div>
<!--수상자 조회 -->
<div class="popup_body">
	<div class="tradeDay_tbl">
		<!--검색 시작 -->
		<div class="search">
			<form id="awardSearchForm" name="awardSearchForm">
				<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
				<input type="hidden" name="svrId" value="<c:out value='${svrId}'/>"/>
				<input type="hidden" id="totalCnt" name="totalCnt" value="0" default='0'>
				<input type="hidden" id="qrYn" name="qrYn" value="Y">
				<table class="formTable tradeDay_search">
					<colgroup>
						<col>
						<col>
					</colgroup>
					<tbody>
						<tr class="pc_hidden">
							<th scope="row">검색어</th>
							<td>
								<span class="form_row w100p">
									<input type="text" id="searchKeyword" name="searchKeyword" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${searchKeyword}' />" placeholder="참석자명 또는 전화번호를 입력해주세요."/>
									<button type="button" class="btn_sm btn_primary btn_search" onclick="doSearch();">조회</button>
								</span>
							</td>
						</tr>
						<tr class="m_hidden">
							<th scope="row">회사명</th>
							<td>
								<input type="text" id="companyName" name="companyName" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${companyName}' />"/>
							</td>
							<th scope="row">포상구분</th>
							<td>
								<select name="awardTypeCd" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="item" items="${AWD045}" varStatus="status">
										<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="m_hidden">
							<th scope="row">수상자명</th>
							<td>
								<input type="text" id="laureateName" name="laureateName" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${laureateName}' />"/>
							</td>
							<th scope="row">수상자연락처</th>
							<td>
								<input type="text" id="laureatePhone" name="laureatePhone" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${laureatePhone}' />"/>
							</td>
						</tr>
						<tr class="m_hidden">
							<th scope="row">참석자명</th>
							<td>
								<input type="text" id="attendName" name="attendName" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${attendName}' />"/>
							</td>
							<th scope="row">참석자연락처</th>
							<td>
								<input type="text" id="attendPhone" name="attendPhone" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value='${attendPhone}' />"/>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<!--검색 끝 -->
		<div class="m_hidden">
			<div class="w100p mt-20">
				<div id="awardPrcsnSearch" class="colPosi mt-20" style="height:420px"></div>
			</div>
		</div>
		<div class="pc_hidden attendee_list">
			<div id='boardList' class="">
			</div>
		</div>
	</div>
	<div class="qrCode_btn pc_hidden">
		<button type="button" class="btn" onclick="closeLayerPopup();">취소</button>
	</div>
</div>
<!--//수상자 조회 -->
<div class="overlay"></div>

<script type="text/javascript">

	$(document).ready(function() {
		f_Init_tradeSearch();		// 헤더  Sheet 셋팅

	});

	function f_Init_tradeSearch() {

		// 세팅
		var	ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 300, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: 'Status', Header: '상태'           , SaveName: 'status'        , Hidden: true});
		ibHeader.addHeader({Type: "Text",   Header: "포상코드"	    , SaveName: "svrId"		    , Align: "Center"	, Width: 50	,Edit : false, Hidden: true});
		ibHeader.addHeader({Type: "Text",   Header: "참석자아이디"	, SaveName: "attendId"	    , Align: "Center"	, Width: 50	,Edit : false, Hidden: true});
		ibHeader.addHeader({Type: "Text",   Header: "회사명"		    , SaveName: "companyName"   , Align: "Left"		, Width: 180	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "사업자번호"      , SaveName: "businessNo"	, Align: "Center"	, Width: 120	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "대표자"		    , SaveName: "ceoNm"	        , Align: "Center"	, Width: 120	,Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "포상구분"	 	, SaveName: "awardTypeNm"	, Align: "Center"	, Width: 150	, Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "포상명" 	 	, SaveName: "prizeName"  	, Align: "Center"	, Width: 150	, Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "수상코드"	 	, SaveName: "awardTypeCd"	, Align: "Center"	, Width: 150	, Edit : false	, Ellipsis:1, Cursor:"Pointer", Hidden: true});
		ibHeader.addHeader({Type: "Text",   Header: "수상자명"		, SaveName: "laureateName"	, Align: "Center"	, Width: 100	, Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "대리인명"		, SaveName: "delegateName"	, Align: "Center"	, Width: 100	, Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",	Header: "대리인주민번호"   , SaveName: "delegateJuminNo",		Align: "Center", 	Width: 140, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",	Header: "대리인여권번호"   , SaveName: "delegatePassportNo",	Align: "Center", 	Width: 120, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "대리인연락처"	, SaveName: "delegatePhone"	, Align: "Center"	, Width: 120	, Edit : false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",   Header: "수령여부"		, SaveName: "pickupBtnNm"	, Align: "Center"	, Width: 100	, Edit : true	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Button", Header: "수출의탑 수령처리", SaveName: "topPickupBtnYn", Align: "Center"	, Width: 140	, Edit : true	, Ellipsis:1, Cursor:"Pointer", HeaderHtml: "<input type='button' value='수령확인'/>"});
		ibHeader.addHeader({Type: "Button", Header: "개인포상 수령처리", SaveName: "pickupBtnYn"	, Align: "Center"	, Width: 140	, Edit : true	, Ellipsis:1, Cursor:"Pointer", HeaderHtml: "<input type='button' value='수령확인'/>"});
		ibHeader.addHeader({Type: "Text",   Header: "수령YN"		    , SaveName: "pickupYn"	    , Align: "Center"	, Width: 100	, Edit : true	, Ellipsis:1, Cursor:"Pointer", Hidden: true});



		if (typeof awardPrcsnSearch !== "undefined" && typeof awardPrcsnSearch.Index !== "undefined") {
			awardPrcsnSearch.DisposeSheet();
		}

		var sheetId = "awardPrcsnSearch";
		var container = $("#"+sheetId)[0];
		var div_heigth = $('#awardPrcsnSearch')[0].style.height;

		createIBSheet2(container,sheetId, "100%", div_heigth);
		ibHeader.initSheet(sheetId);

	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		document.awardSearchForm.pageIndex.value = pageIndex;
		getList();
	}

	/**
	 * 수상자 검색
	 */
	function getList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/mnlatPrcsnPopupList.do" />'
			, data : $('#awardSearchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				awardPrcsnSearch.LoadSearchData({Data: data.resultList});

				// 모바일
				var list = '';
				if(data.resultList.length == 0) {

					list += '<tr>';
					list += '	<td colspan="2" style="text-align: center; height: 100px">등록된 데이터가 없습니다.</td>';
					list += '</tr>';
				} else {
						list += '<table class="tradeDay_formTable">';
						list += '<colgroup>';
						list += '	<col style="width: 30%">';
						list += '	<col style="width: 30%">';
						list += '	<col style="width: 40%">';
						list += '</colgroup>';
						list += '<tboody>';
					for (var i = 0; i < data.resultList.length; i++) {
						list += ' <tr>';
						list += ' 	<td>';
						list +=     	data.resultList[i].companyName +'<br>' + data.resultList[i].businessNo;
						list += ' 	</td>';
						list += ' 	<td>';
						/*list +=  		data.resultList[i].awardTypeNm +'( '+ data.resultList[i].prizeName + ' )' +'<br>' + data.resultList[i].laureateName;*/
						list +=  		data.resultList[i].prizeName +'<br>' + data.resultList[i].laureateName;
						list += ' 	</td>';
						list += ' 	<td rowspan="2" class="align_r">';

					/* 수출의탑 포상 */
					if( data.resultList[i].topPickupBtnYn == "N" || data.resultList[i].topPickupBtnYn == "C") {
						list += ' 	    <button class="btn_tbl_primary" onclick="awardInfoPopup(\'' + (i+1) + '\', \'T\');">수령확인(탑)</button>';
					} else if( data.resultList[i].topPickupBtnYn == "D") {
						list += ' 	    <span class="attend">수령불가</span>';
					} else if(  data.resultList[i].topPickupBtnYn == "Y" || data.resultList[i].topPickupBtnYn == "T") {
						list += ' 	    <button class="btn_tbl_primary" style="background-color:#EF3E33" onclick="awardInfoPopup(\'' + (i+1) + '\', \'T\');">수령취소(탑)</button>';
					}

					/* 개인포상 */
					if( data.resultList[i].pickupBtnYn == "N") {
						list += ' 	    <button class="btn_tbl_primary" onclick="awardInfoPopup(\'' + (i+1) + '\', \'P\');">수령확인(개인)</button>';
					} else if(  data.resultList[i].pickupBtnYn == "T") {
						list += ' 	    <button class="btn_tbl_primary" onclick="awardInfoPopup(\'' + (i+1) + '\', \'T\');">수령확인(개인)</button>';
					} else if( data.resultList[i].pickupBtnYn == "D") {
						list += ' 	    <span class="attend">수령불가</span>';
					} else if(  data.resultList[i].pickupBtnYn == "Y" || data.resultList[i].pickupBtnYn == "C") {
						list += ' 	    <button class="btn_tbl_primary" style="background-color:#EF3E33" onclick="awardInfoPopup(\'' + (i+1) + '\', \'P\');">수령취소(개인)</button>';
					}
						list += ' 	</td>';
						list += ' </tr>';
					if( data.resultList[i].laureateName != data.resultList[i].delegateName) {
						list += ' <tr class="border">';
						list += ' 	<td>';
						list +=     	data.resultList[i].delegateTypeNm;
						list += ' 	</td>';
						list += ' 	<td>';
						list +=     	data.resultList[i].delegateName +'<br>' + data.resultList[i].delegatePhone;
						list += ' 	</td>';
						list += ' </tr>';
					}
						list += ' <tr class="border"><td colspan="3">.</td></tr>';
					}
					list += '</tboody>';
					list += '</table>';

				}
				$('#boardList').html(list);
			}
		});

	}

	/**
	 * 상세 페이지 & 팝업
	 * @param Row
	 * @param Col
	 * @param Value
	 */
	function awardPrcsnSearch_OnClick(Row, Col, Value) {

		var awardType = "";

		//수출의탑 수령처리
		if(awardPrcsnSearch.ColSaveName(Col) == "topPickupBtnYn" && Row > 0) {
			var rowData = awardPrcsnSearch.GetRowData(Row);

			awardType = "T";
			awardInfoPopup(Row, awardType);

		}

		// 개인포상 수령 처리
		if(awardPrcsnSearch.ColSaveName(Col) == "pickupBtnYn" && Row > 0) {
			var rowData = awardPrcsnSearch.GetRowData(Row);

			if( awardPrcsnSearch.GetCellValue(Row, "awardTypeCd") == '50' ) {
				awardType = "T";
			} else {
				awardType = "P";
			}

			awardInfoPopup(Row, awardType);

		}


	};

	/**
	 * 수령확인 레이어팝업
	 * @param rowData
	 * @param row
	 */
	function awardInfoPopup(row, pAwardType) {

		var pickupChk = awardPrcsnSearch.GetCellValue(row, "pickupBtnYn");
		var topPickupChk = awardPrcsnSearch.GetCellValue(row, "topPickupBtnYn");
		var awardTypeCdChk = awardPrcsnSearch.GetCellValue(row, "awardTypeCd");

		if( pAwardType == 'T') {
			if( awardTypeCdChk != 50) {
				if( topPickupChk == '수령불가') {
					return false;
				}
			}

		} else if( pAwardType == 'P') {
			if( awardTypeCdChk != 50) {
				if( pickupChk == '수령불가') {
					return false;
				}
			}
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeDay/clbrt/awardInfoPopup.do" />'
			, params : {
				 svrId : awardPrcsnSearch.GetCellValue(row, "svrId")
			   , attendId : awardPrcsnSearch.GetCellValue(row, "attendId")
			   , pickupYn : awardPrcsnSearch.GetCellValue(row, "pickupYn")
			   , awardTypeCd : awardPrcsnSearch.GetCellValue(row, "awardTypeCd")
			   , qrCheckYn : 'N'
			   , awardType : pAwardType
			}
			, callbackFunction : function(resultObj){
				doSearch();
			}
		});

	}

	function awardPrcsnSearch_OnSearchEnd(row) {

		// 참석 변경
		for( var i = 1 ; i <= awardPrcsnSearch.RowCount(); i++){
			var button = awardPrcsnSearch.GetCellValue(i,'pickupBtnYn');
			var topButton = awardPrcsnSearch.GetCellValue(i,'topPickupBtnYn');
			var awardTypeCd = awardPrcsnSearch.GetCellValue(i,'awardTypeCd');

			// 수출의탑 수령 처리
			if( topButton == "Y" || topButton == "T") {
				topButton = "수령취소"
				//awardPrcsnSearch.InitCellProperty(i, 'pickupBtnYn', {Type: "Text"}); // 버튼 -> 텍스트로 변경
				awardPrcsnSearch.SetCellValue(i, 'topPickupBtnYn', topButton); // 값 변경
				awardPrcsnSearch.SetCellFontColor(i, 'topPickupBtnYn', '#ff0000');
				//awardPrcsnSearch.SetCellEditable(i, 'pickupBtnYn', 0); // 편집 불가

			} else if( topButton == "D") {
				topButton = "수령불가"
				awardPrcsnSearch.InitCellProperty(i, 'topPickupBtnYn', {Type: "Text"}); // 버튼 -> 텍스트로 변경
				awardPrcsnSearch.SetCellValue(i, 'topPickupBtnYn', topButton); // 값 변경
				awardPrcsnSearch.SetCellEditable(i, 'topPickupBtnYn', 0); // 편집 불가

			} else if(topButton == "N" || topButton == 'C') {
				topButton = "수령확인"
				awardPrcsnSearch.SetCellValue(i, 'topPickupBtnYn', topButton);
			}

			// 개인포상 수령 처리
			if( button == "Y" || button == "C") {
				button = "수령취소"
				//awardPrcsnSearch.InitCellProperty(i, 'pickupBtnYn', {Type: "Text"}); // 버튼 -> 텍스트로 변경
				awardPrcsnSearch.SetCellValue(i, 'pickupBtnYn', button); // 값 변경
				awardPrcsnSearch.SetCellFontColor(i, 'pickupBtnYn', '#ff0000');
				//awardPrcsnSearch.SetCellEditable(i, 'pickupBtnYn', 0); // 편집 불가

			} else if( button == "D") {
				button = "수령불가"
				awardPrcsnSearch.InitCellProperty(i, 'pickupBtnYn', {Type: "Text"}); // 버튼 -> 텍스트로 변경
				awardPrcsnSearch.SetCellValue(i, 'pickupBtnYn', button); // 값 변경
				awardPrcsnSearch.SetCellEditable(i, 'pickupBtnYn', 0); // 편집 불가

			} else if(button == "N" || button == "T") {
				button = "수령확인"
				awardPrcsnSearch.SetCellValue(i, 'pickupBtnYn', button);
			}


		}
    }

	/**
	 * 수령처리 버튼 컬러 변경
	 * @param data
	 * @returns {*|jQuery}
	 */
	function awardPrcsnSearch_OnLoadData(data) {
		var jsonData = $.parseJSON(data);

	 	for(var i of jsonData.Data) {

			//개인포상 수령
			if(i["pickupBtnYn"] == "Y") {
				i["pickupBtnYn#ClassName"] = 'cell_btn_red';
			} else if( i["pickupBtnYn"] == "C") {
				i["pickupBtnYn#ClassName"] = 'cell_btn_red';
			}

			//수출의탑 수령
			if( i["topPickupBtnYn"] == "Y") {
				i["topPickupBtnYn#ClassName"] = 'cell_btn_red';
			} else if( i["topPickupBtnYn"] == "T") {
				i["topPickupBtnYn#ClassName"] = 'cell_btn_red';
			}
	 	}

	 	return jsonData;
	}

	function closePopup() {
		$('body').removeClass('hiddenScroll');
		// timestamp로 내림차순 중 첫번째 요소를 가져온다.(shift는 원본 요소에서 사라지기 때문에 레이어 팝업 닫기에 사용했다.)
		var config = popupConfig.sort(function(a, b){
			return b['timestamp'] - a['timestamp'];
		}).shift();

		if (config) {
			// 레이어 정보를 삭제한다.
			$('#modalLayerPopup' + config.timestamp).remove();
		}

		window.location.reload(true);

		$('#scanner').val("");
		$('#scanner').focus();
	}
</script>