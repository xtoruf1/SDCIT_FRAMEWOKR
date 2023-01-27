<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<form id="form1" name="form1" method="post"  onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" onclick="doAdd()"  class="btn_sm btn_primary bnt_modify_auth">신규</button>
		<button type="button" onclick="doSave()" class="btn_sm btn_primary bnt_modify_auth">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doClear()" class="btn_sm btn_secondary">초기화</button>
	</div>
</div>

<div class="cont_block">

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
	</div>
</div>

</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		getList();
	});


	function initIBSheet(){
        var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header:"삭제",				Type:"DelCheck",  Hidden:true, Width:30,   Align:"Left",   SaveName:"delCheck",	HeaderCheck:false });
        ibHeader.addHeader({Header:"Status",			Type:"Status",    Hidden:true, 	Width:30,   Align:"Left",   SaveName:"status", 		Edit:false });
        ibHeader.addHeader({Header:"seq",				Type:"Text",      Hidden:true,  Width:30,   Align:"Left",   SaveName:"bizCenterSeq", Edit:false });
        ibHeader.addHeader({Header:"*시설위치",			Type:"Combo",     Hidden:true, Width:50,   Align:"Left",   SaveName:"location", 	Edit:true,	ComboCode: "<c:out value="${biz0004.code}"/>", ComboText: "<c:out value="${biz0004.codeNm}"/>"  });
        ibHeader.addHeader({Header:"*회의실",			Type:"Text", 	  Hidden:false, Width:50,   Align:"Left",   SaveName:"roomNumber",	Edit:true	});
        ibHeader.addHeader({Header:"*회의실 규모",		Type:"Combo",     Hidden:false, Width:60,   Align:"Left",   SaveName:"persons",  	Edit:true,	ComboCode: "<c:out value="${biz0008.code}"/>", ComboText: "<c:out value="${biz0008.codeNm}"/>"  });
        ibHeader.addHeader({Header:"*사용 여부",		Type:"Combo",     Hidden:false, Width:60,   Align:"Left",   SaveName:"appYn",      	Edit:true,	ComboCode: "<c:out value="${biz0009.code}"/>", ComboText: "<c:out value="${biz0009.codeNm}"/>"  });
        ibHeader.addHeader({Header:"*신청가능 여부",	Type:"Combo",     Hidden:false, Width:60,   Align:"Left",   SaveName:"useYn",  		Edit:true,	ComboCode: "<c:out value="${biz0010.code}"/>", ComboText: "<c:out value="${biz0010.codeNm}"/>"  });
        ibHeader.addHeader({Header:"*사진등록",      	Type:"Html",      Hidden:false, Width:130,  Align:"Center",	SaveName:"fileId",     	Edit:true,	Cursor:"Pointer"});

        ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 0, SizeMode: 1, MouseHoverMode: 0, NoFocusMode: 0, Ellipsis: 1});
        ibHeader.setHeaderMode({ Sort:0, ColMove:false, HeaderCheck:false, ColResize:false });

		var container = $('#sheet1')[0];
		createIBSheet2(container, 'sheet1', '100%', '100%');
		ibHeader.initSheet('sheet1');
		//sheet1Sheet.SetSelectionMode(4);
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/management/meetingRoomList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 추가
	function doAdd() {
		var rowIndex = sheet1.DataInsert(-1);
		var html = sheet1.GetCellValue(rowIndex,'fileId');

		if(sheet1.GetCellValue(rowIndex, "status") == "I"){
			html = '<button class="btn_tbl disabled" onClick="insertAlert()" style="width:99%" >사진 등록</button>  ' +html;
			sheet1.SetCellValue(rowIndex, 'fileId', html);
		}
	}

	//저장
	function doSave() {
		var f = document.form1;
		var insertCount = 0;
		var updateCount = 0;
		var delCount = 0;

		var saveJson = sheet1.GetSaveJson({StdCol:"status"});
		var saveData = $('#form1').serializeObject();

		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "delCheck") == "1" ){
				delCount ++;
			}

			if(sheet1.GetCellValue(i, "status") == "I"){
				if(sheet1.GetCellValue(i, "roomNumber") == "" || sheet1.GetCellValue(i, "roomNumber") == null){
					alert("회의실을 입력하세요. ");
					sheet1.SelectCell(i, "roomNumber");
					return;
				}

				if(sheet1.GetCellValue(i, "status") == "I" ){
					insertCount++;
				}
			}

			if (sheet1.GetCellValue(i, "status") == "U"){
				updateCount++;
			}
		}

		if ( insertCount <= 0 && updateCount <= 0 && delCount <= 0 ){
			alert("내용이 없습니다. ");
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		var map = {};
		var list = [];
		$.each(saveJson, function(key1, value1) {
			map = {};
			$.each(value1, function(key2, value2) {
				value2.fileId = "";
				map = value2;
				list.push(map);
			});
			saveData['dataList'] = list;
		});

   		global.ajax({
			type : 'POST'
			, url : '<c:url value="/bizCenter/management/meetingRoomSave.do" />'
			, data : JSON.stringify(saveData)
			, contentType : 'application/json'
			, async: false
			, spinner : true
			, success : function(data){
				//alert('저장되었습니다.');
				getList();
			}
		});
	}

	//초기화
	function doClear(){
		getList();
	}

	// ibsheet 로딩중 이벤트
	function sheet1_OnLoadData(data) {
		var jsonData = $.parseJSON(data);
		var newObj = {};
		newObj = $.extend(newObj, jsonData);
		var rowdata = newObj.Data;

		rowdata.forEach(function(item, index){
			var seq = item.bizCenterSeq;
			var fileId = 0

			if ( item.fileId > 0 ){
				fileId = item.fileId;
			}

			var html =' <button class="btn_tbl_primary" style="cursor: pointer; width: 98%;" onClick="openCommonPopup('+seq+')">사진등록</button> ';
			newObj.Data[index].fileId = html;
		});
		return newObj;
	}

	// 사진 등록 불가 알림
 	function insertAlert() {
		alert("저장 후 등록 가능합니다.");
		return;
	}

	// ibsheet 검색 완료후 edit옵션별 cell색상 변경
 	function sheet1_OnRowSearchEnd(row) {
		notEditableCellColor('sheet1', row);
	}

	// 레이어 팝업
	function openCommonPopup(seq) {
		global.openLayerPopup({
			popupUrl : '<c:url value="/bizCenter/management/imagePopup.do" />'
			, params : {
				'bizCenterSeq' : seq
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if (resultObj.SUCCESS == false){
					alert(resultObj.MESSAGE);
				}
				closeLayerPopup();
				openCommonPopup(seq);
			}
		});
 	}
</script>