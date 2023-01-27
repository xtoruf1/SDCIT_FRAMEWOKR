<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">전문분야 찾기</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<form id="itemForm" name="itemForm" method="post">
		<input type="hidden" name="searchUnit" id="searchUnit"/>
		<input type="hidden" name="searchMtiCodePop" id="searchMtiCodePop"/>
		<!-- 전문분야 찾기 레이어팝업 -->
		<div id="itemPop" class="layerPopUpWrap">
			<div class="layerPopUp">
				<div class="layerWrap" style="width:700px;">
					<div class="tabGroup">
						<div class="tab_header">
								<a href="#" class="tab on">계층형</a>
								<a href="#" class="tab">키워드</a>
						</div>
						<div class="tab_body">
							<!-- 계층형 -->
							<div class="tab_cont on" style="height:450px; margin-top: 15px;">
								<div class="tbl_opt">
									<div class="tableTopTxt st2 step total_count">
										<strong>총</strong>
									</div>
									<div class="ml-auto btn_group fr">
										<button type="button" class="btn_tbl" onclick="selectArr();">선택</button>
										<button type="button" class="btn_tbl" id="upperItem" data-unit="0" onclick="goUp();">상위</button>
									</div>
								</div>
								<!-- 리스트 테이블 -->
								<div class="tbl_list">
									<div id='tblSheet' class="colPosi"></div>
								</div>
							</div>

							<!-- 키워드 -->
							<div class="tab_cont">
								<table class="formTable">
									<colgroup>
										<col style="width:20%">
										<col>
									</colgroup>
									<tbody>
									<tr>
										<th>품목명</th>
										<td>
											<input type="text" id="searchMtiNmPop" name="searchMtiNmPop" class="form_text w50p" onkeydown="onEnter(itemKeyList, tblSheet2);">
											<button type="button" class="btn_tbl" onclick="itemKeyList(tblSheet2);">검색</button>
										</td>
									</tr>
									</tbody>
								</table>

								<div class="tbl_opt mt-20">
									<div class="tableTopTxt st2 allItem total_count">
										<strong>총 건수</strong> : 1,569 건
									</div>
									<div class="ml-auto btn_group fr">
										<button type="button" class="btn_tbl" onclick="selectAllArr();">선택</button>
									</div>
								</div>

								<!-- 리스트 테이블 -->
								<div class="tbl_list">
									<div id='tblSheet2' class="colPosi"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="layerFilter"></div>
			</div>
		</div>
	</form>
</div>

<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
			f_Init_tblSheet();		// 헤더  Sheet 셋팅
			itemStepList(tblSheet);	//목록 조회
			f_Init_tblSheet2();
			itemKeyList(tblSheet2);	// 목록 조회
	});

	//전문분야 (계층형)
	function f_Init_tblSheet() {

		// 세팅
		var	ibHeader = new IBHeader();

		 /** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "CheckBox"	, Header: "선택"		, SaveName: "sCheckBox"		, Align: "Center"	, Width: 50		,Edit: true});
		ibHeader.addHeader({Type: "Text"		, Header: "코드명"	, SaveName: "mtiCode"		, Align: "Center"	, Width: 50		,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명"	, SaveName: "mtiNameKor"	, Align: "Left"		, Width: 200	,Edit: false	, Ellipsis:1, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text"		, Header: "레벨"		, SaveName: "mtiUnit"		, Align: "Center"	, Width: 50		,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "하위계층"	, SaveName: "lowerCd"		, Align: "Center"	, Width: 115	,Edit: false	, Hidden:true});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명2"	, SaveName: "mti2NameKor"	, Align: "Left"		, Width: 200	,Edit: false	, Hidden:true});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명3"	, SaveName: "mti3NameKor"	, Align: "Left"		, Width: 200	,Edit: false	, Hidden:true});

		if (typeof tblSheet !== "undefined" && typeof tblSheet.Index !== "undefined") {
			tblSheet.DisposeSheet();
		}

	    var sheetId = "tblSheet";
		var container = $("#"+sheetId)[0];
	    createIBSheet2(container,sheetId, "100%", "450px");
	    ibHeader.initSheet(sheetId);

	}

	function f_Init_tblSheet2() {					//전문분야 (키워드)

		// 세팅
		var	ibHeader	=	new	IBHeader();

		 /** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true, HeaderCheck: 0});

		ibHeader.addHeader({Type: "CheckBox"	, Header: "선택"		, SaveName: "sCheckBox"		, Align: "Center"	, Width: 50		,Edit: true});
		ibHeader.addHeader({Type: "Text"		, Header: "코드명"	, SaveName: "mtiCode"		, Align: "Center"	, Width: 50		,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명"	, SaveName: "mtiNameKor"	, Align: "Left"		, Width: 200	,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "레벨"		, SaveName: "mtiUnit"		, Align: "Center"	, Width: 50		,Edit: false});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명2"	, SaveName: "mti2NameKor"	, Align: "Left"		, Width: 200	,Edit: false	, Hidden:true});
		ibHeader.addHeader({Type: "Text"		, Header: "품목명3"	, SaveName: "mti3NameKor"	, Align: "Left"		, Width: 200	,Edit: false	, Hidden:true});

		if (typeof tblSheet2 !== "undefined" && typeof tblSheet2.Index !== "undefined") {
			tblSheet2.DisposeSheet();
		}

		var sheetId = "tblSheet2";
		var container = $("#"+sheetId)[0];
	    createIBSheet2(container,sheetId, "100%", "425px");
	    ibHeader.initSheet(sheetId);

	}

	function tblSheet_OnClick(Row,Col,Value){
		if(tblSheet.ColSaveName(Col) == "mtiNameKor" && Row > 0){
			var rowData = tblSheet.GetRowData(Row);
			if(Col != 0){
				if(rowData['mtiUnit'] == "2"){
					alert('2그룹 까지 선택가능합니다.');
					return false;
				}
				$('#searchUnit').val(rowData['mtiUnit']);
				console.log($('#searchUnit').val());
				$('#searchMtiCodePop').val(rowData['mtiCode']);
				$('#upperItem').data('unit',rowData['mtiUnit']);
				itemStepList(tblSheet);
			}
		}
	}

	function tblSheet2_OnClick(Row,Col,Value){
		if(Row == 0){
			return false;
		}
		var rowData = tblSheet2.GetRowData(Row);
	}

	/* 계층형 / 키워드 선택별 숨김 여부 */
	var $btnTab = $('.tab');
	$btnTab.on('click', function(){
		var $this = $(this);

		if(!$this.hasClass('on')){
			var $tabGroup = $this.parents('.tabGroup');
			var idx = $this.index();

			$this.siblings('.tab').removeClass('on');
			$this.addClass('on');

			$tabGroup.find('.tab_cont').removeClass('on');
			$tabGroup.find('.tab_cont').eq(idx).addClass('on');
		}
	})

/*																				// 계층형 / 키워드 선택별 숨김 여부
	jQuery().ready(function(){
		$('.tab_cont').hide();
		$('.tabBtn li').click(function(e){
			e.preventDefault();
			$('.tab_cont').hide();
			$('.tabBtn li').removeClass('selected');
			$(this).addClass('selected');
			$($('.tab_cont')[$(this).index()]).show();
		}).first().trigger('click');
	});
*/

	function selectArr()																//계층형 선택 버튼
	{
		var chkRowArray = tblSheet.FindCheckedRow('sCheckBox',{ReturnArray:1});			//체크된 행 배열
		var mtiCodeArray = new Array();													//선택 행의 mtiCode 값
		var mtiKorArray = new Array();													//선택 행의 mtiCodeKor 값
		var mtiUnitArray = new Array();													//선택 행의 mtiCodeKor 값

		if(1 > chkRowArray.length)														//선택한 전문분야가 없는 경우
		{
			alert("전문분야를 선택해주세요.");
			return false;
		}

		if(chkRowArray.length >= 100)													//전문분야 100개 이상 선택한 경우
		{
			alert("100개 이상 등록이 불가능합니다.");
			return false;
		}

		for(var i = 0; i < chkRowArray.length; i++)									 	//선택한 행의 갯수만큼
		{
			var chkRow = chkRowArray[i];												//선택 행 index

			var chkMtiCode = tblSheet.GetCellValue(chkRow,'mtiCode');					//선택 행의 mtiCode 값
			mtiCodeArray.push(chkMtiCode);
			var chkMtiNameKor = tblSheet.GetCellValue(chkRow,'mtiNameKor');				//선택 행의 mtiNameKor 값
			mtiKorArray.push(chkMtiNameKor);
			var chkMtiUnit = tblSheet.GetCellValue(chkRow,'mtiUnit');				    //선택 행의 mtiUnit 값
			mtiUnitArray.push(chkMtiUnit);

// 			for(var j=0; j< $('#mti_code_list option').length; j++){					//중복제거
// 				if(chkMtiCode == $('#mti_code_list option:eq('+j+')').val()){
// 					alert(chkMtiNameKor + "[" + chkMtiCode + "] 코드는 존재합니다.");
// 					return false;
// 				}
// 			}

// 			appendHtml += '<option value="'+chkMtiCode+'">';							//선택한 품목 추가
// 			appendHtml += chkMtiNameKor;
// 			appendHtml += '</option>';
		}

		var mtiArray = {															//선택 행 값 콜백
			'mtiCodeArray': mtiCodeArray
			,'mtiKorArray': mtiKorArray
			,'mtiUnitArray': mtiUnitArray
		};

		layerPopupCallback(mtiArray);												//체크된 행의 mtiCode,mtiNameKor 값 callback

		closeLayerPopup();

	}

	function goUp(){
		var unit = $('#upperItem').data('unit');
		if(unit == '' || unit == 0){
			alert('최상위 그룹입니다.');
			return false;
		}

		if(unit==6){
			$('#searchMtiCodePop').val(String($('#searchMtiCodePop').val().substring(0,parseInt(unit)-2)));
			$('#searchUnit').val(String(parseInt(unit)-2));
		}else{
			$('#searchMtiCodePop').val(String($('#searchMtiCodePop').val().substring(0,parseInt(unit)-1)));
			$('#searchUnit').val(String(parseInt(unit)-1));
		}
		//initGrid('tblGrid','mySheet',650,250);
		itemStepList(tblSheet);
	}



	function selectAllArr()																						//키워드 선택 버튼
	{
		var chkRowArray = tblSheet2.FindCheckedRow('sCheckBox',{ReturnArray:1});			//체크된 행 배열
		var mtiCodeArray = new Array();													//선택 행의 mtiCode 값
		var mtiKorArray = new Array();													//선택 행의 mtiCodeKor 값
		var mtiUnitArray = new Array();

		if(1 > chkRowArray.length)														//선택한 전문분야가 없는 경우
		{
			alert("전문분야를 선택해주세요.");
			return false;
		}

		if(chkRowArray.length >= 100)													//전문분야 100개 이상 선택한 경우
		{
			alert("100개 이상 등록이 불가능합니다.");
			return false;
		}

		for(var i = 0; i < chkRowArray.length; i++)									 	//선택한 행의 갯수만큼
		{
			var chkRow = chkRowArray[i];												//선택 행 index

			var chkMtiCode = tblSheet2.GetCellValue(chkRow,'mtiCode');					//선택 행의 mtiCode 값
			mtiCodeArray.push(chkMtiCode);
			var chkMtiNameKor = tblSheet2.GetCellValue(chkRow,'mtiNameKor');				//선택 행의 mtiNameKor 값
			mtiKorArray.push(chkMtiNameKor);
			var chkMtiUnit = tblSheet2.GetCellValue(chkRow,'mtiUnit');				    //선택 행의 mtiUnit 값
			mtiUnitArray.push(chkMtiUnit);
		}

		if (layerPopupCallback && typeof layerPopupCallback == 'function')		//콜백함수 리턴
		{
			var mtiArray = {															//선택 행 값 콜백
							'mtiCodeArray': mtiCodeArray
						   ,'mtiKorArray': mtiKorArray
						   ,'mtiUnitArray': mtiUnitArray
						   };

			//체크된 행의 mtiCode,mtiNameKor 값
			layerPopupCallback(mtiArray);
		}

		closeLayerPopup();
	}

</script>