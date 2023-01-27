<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundDeadlineSetPopupForm" name="fundDeadlineSetPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchExpertIdPop" 	id="searchExpertIdPop" 	value="<c:out value="${searchExpertIdPop}"/> /">
<input type="hidden" name="pageIndex"			id="pageIndex"  		value="<c:out value='${param.pageIndex}' 	default='1' />" />

<input type="hidden" name="statusChk"   value="" />
<input type="hidden" name="svrId"     	value="<c:out value="${param.svrId}"/>"  />
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />


<div style="max-width: 800px; max-height: 700px;" class="fixed_pop_tit">

<!-- 팝업 타이틀 -->
<div class="flex popup_top">
	<h2 class="popup_title">KITA무역진흥자금 융자 접수 마감</h2>

	<div class="ml-auto " id="btn_group">
		<button class="btn_sm btn_primary " 		onclick="doFundDeadlineSetPopupExcel()">엑셀다운</button>
		<button class="btn_sm btn_primary " 		onclick="doFundDeadlineSetPopupPrint()">인쇄</button>
		<button class="btn_sm btn_primary btn_modify_auth" 		onclick="doFundDeadlineSetPopupSave()">저장</button>
	</div>
	<div class="ml-15">
		<button class="btn_sm btn_secondary" 	onclick="doClose();">닫기</button>
	</div>
</div>


<div class="popup_body" id="printTable" >
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">무역기금융자명</th>
					<td>
						<div class="form_row w100p">
							<c:out value="${param.title}"/>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->

	<div class="tbl_opt mt-20">
		<!-- 전체 게시글 -->
		<div id="fundDeadlineSetPopupTotalCnt" class="total_count"></div>

	</div>

	<div class="w100p">
		<div id="fundDeadlineSetPopupSheet" class="sheet"></div>
	</div>
</div>
<div class="overlay"></div>
</div>
</form>

<script type="text/javascript">
// 레이어 팝업에서 셀렉트 박스 z-index 조정.
$("#modalLayerPopup").css('z-index', 100 );

	$(document).ready(function () {
		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});

		initFundDeadlineSetPopupSheet();
		getFundDeadlineSetList()
	});

	// Sheet의 초기화 작업
	function initFundDeadlineSetPopupSheet() {
		var ibHeader = new IBHeader();
		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1,  MouseHoverMode: 2, NoFocusMode : 0});

		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"No",            	Type:"Int",       Hidden:false,  Width:40,   Align:"Center",  SaveName:"rn", 		BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header:'상태', 				Type:'Status',    Hidden:true,   Width:20,   Align:'Center',  SaveName:'status', 	BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header:"No",            	Type:"Seq",       Hidden:true,  Width:40,   Align:"Center",  SaveName:"no" , 		BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header:"CHK",           	Type:"Text",      Hidden:true,   Width:20,   Align:"Center",  SaveName:"chk" , 		BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header:"기금융자코드",   	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"svrId", 	BackColor: '#F6F6F6',   	CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"본부코드",       	Type:"Text",      Hidden:true,   Width:120,  Align:"Center",  SaveName:"tradeDept", 	BackColor: '#F6F6F6',	CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"본부명",         	Type:"Text",      Hidden:false,  Width:140,  Align:"Left",    SaveName:"tradeDeptNm", 	BackColor: '#F6F6F6',  	CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"전체신청건수",   	Type:"AutoSum",   Hidden:false,  Width:110,  Align:"Center",  SaveName:"allCnt", 		BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"선정",           	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"selectCnt", 	BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"접수",          	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"applCnt", 		   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"탈락",          	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"dropCnt", 		BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"불능",           	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"inabCnt", 		BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"포기",           	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"abanCnt", 		BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"추천",           	Type:"AutoSum",   Hidden:false,  Width:70,   Align:"Center",  SaveName:"sendCnt", 		BackColor: '#F6F6F6',   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:false,     EditLen:30 });
		ibHeader.addHeader({Header:"마감여부",       	Type:"Combo",     Hidden:false,  Width:90,   Align:"Center",  SaveName:"st",           KeyField:true,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:true,      EditLen:30 , ComboCode: "<c:out value="${saLMS002.detailcd}"/>", ComboText: "<c:out value="${saLMS002.detailnm}"/>"  });

		var sheetId = "fundDeadlineSetPopupSheet";
		var container = $("#"+sheetId)[0];
		if (typeof fundDeadlineSetPopupSheet !== 'undefined' && typeof fundDeadlineSetPopupSheet.Index !== 'undefined') {
			fundDeadlineSetPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
	};

	// 검색
	function getFundDeadlineSetList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/lms/fundDeadlineSetPopupList.do" />'
			, data : $('#fundDeadlineSetPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#fundDeadlineSetPopupTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				fundDeadlineSetPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}


	function doFundDeadlineSetPopupSave(){

// 		if (confirm('수정하시겠습니까?')) {
			var saveJson = fundDeadlineSetPopupSheet.GetSaveJson();
			var ccf = getSaveDataSheetList('fundDeadlineSetPopupForm' , saveJson);

			if( saveJson.data.length == 0 ){
				alert('수정된 데이타가 존재하지 않습니다.');
				return ;
			}


			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tfms/lms/updatefundDeadlineSetPopup.do" />'
				, data : JSON.stringify(ccf)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					alert('생성하였습니다.');
					getFundDeadlineSetList();
				}
			});
// 		}

	}

	function doFundDeadlineSetPopupPrint(){

        // var initBody;
        var _nbody = null;
        var _body = document.body; //innerHtml 이 아닌 실제 HTML요소를 따로 보관.
        var printDiv = document.createElement("div"); //프린트 할 영역의 DIV 생성(DIV높이 너비 등 설정 편하게 하기 위한 방법)


        window.onbeforeprint = function(){

             $('#btn_group').hide();
//              document.getElementById("printTable").style.height = "60%";
//              document.getElementById("printTable").style.maxWidth = "100%";

            // 굳이 클래스네임은 선언하지 않아도 됩니다.
            printDiv.className = "IBSheet_PrintDiv";
            var val = document.getElementById('printTable').innerHTML;
            document.body = _nbody = document.createElement("body");
            _nbody.appendChild(printDiv);
            printDiv.innerHTML = val; //프린트 할 DIV에 필요한 내용 삽입.
        };
        window.onafterprint = function(){
            // 프린트 후 printDiv 삭제.
            _nbody.removeChild(printDiv);
            // body영역 복원
            document.body = _body;
            //이젠 필요없으니 삭제.
            _nbody = null;
            // 아까 위에서 숨겼던 버튼들 복원.
             $('#btn_group').show();
        };
        window.print();
    }


	function doFundDeadlineSetPopupExcel(){

        var f = document.fundDeadlineSetPopupForm;
        var rowSkip = fundDeadlineSetPopupSheet.LastRow();
        var colSkip = "chk|no|st";

        if(fundDeadlineSetPopupSheet.RowCount() > 0){
        	//fnIbsheetExcelDown(fundDeadlineSetPopupSheet, "2", "KITA무역진흥자금 융자 접수 마감", "1", "A4", colSkip, rowSkip.toString(),1, false);
        	downloadIbSheetExcel(fundDeadlineSetPopupSheet, "KITA무역진흥자금 융자 접수 마감", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}


	function doClose(){

		// 콜백
		layerPopupCallback("close");

		// 레이어 닫기
		closeLayerPopup();
	}

	function fundDeadlineSetPopupSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
			var index = fundDeadlineSetPopupSheet.GetCellValue(row, "no");
			var resultCnt = $('#resultCnt').val();
			fundDeadlineSetPopupSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
		notEditableCellColor('fundDeadlineSetPopupSheet', row);
	}

	// ibsheet 클릭 이벤트
	function fundDeadlineSetPopupSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

	}

</script>