<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doAdd();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
</div>

<form id="frm" method="post">
	<div class="cont_block">
		<div>
			<div id="cardListSheet" class="sheet"></div>
		</div>
	</div>
</form>

<script type="text/javascript">

	var addFileSeq = new Array();

	$(document).ready(function(){

		setSheetHeader_cardList();		// 부정확 업체정보 목록 헤더
		getCardList();					// 부정확 업체정보 목록

	});

	function setSheetHeader_cardList() {	// 부정확 업체정보 목록 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'		, Hidden: true});
		ibHeader.addHeader({Header: '카드코드'			, Type: 'Text'			, SaveName: 'cardCode'		, Edit: false	, Width: 15		, Align: 'Center'	, KeyField : true	, EditLen:16});
		ibHeader.addHeader({Header: '카드사'			, Type: 'Text'			, SaveName: 'cardCorp'		, Edit: true	, Width: 20		, Align: 'Left'		, KeyField : true	, EditLen:30});
		ibHeader.addHeader({Header: '카드명'			, Type: 'Text'			, SaveName: 'cardName'		, Edit: true	, Width: 50		, Align: 'Left'		, KeyField : true	, EditLen:30});
		ibHeader.addHeader({Header: '이미지'			, Type: 'Html'			, SaveName: 'img'			, Edit: true	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '이미지변경'		, Type: 'Html'			, SaveName: 'addFile'		, Edit: true	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '카드attseq'		, Type: 'Text'			, SaveName: 'fileAttachSeq'	, Hidden: true	, Width: 10		});
		ibHeader.addHeader({Header: '파일순번'			, Type: 'Text'			, SaveName: 'fileSeq'		, Hidden: true	, Width: 10		});
		ibHeader.addHeader({Header: '카드사링크'		, Type: 'Text'			, SaveName: 'siteLink'		, Edit: true	, Width: 60		, Align: 'Left'		, KeyField : true	, EditLen:500});
		ibHeader.addHeader({Header: '사용여부'			, Type: 'Combo'			, SaveName: 'cardUseYn'		, Edit: true	, Width: 15		, Align: 'Center'	, ComboText: '사용|미사용'	, ComboCode: 'Y|N'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1,
            ToolTip: false});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#cardListSheet')[0];
		createIBSheet2(container, 'cardListSheet', '100%', '100%');
		ibHeader.initSheet('cardListSheet');

		cardListSheet.SetEllipsis(1); 			// 말줄임 표시여부
	}

	function cardListSheet_OnRowSearchEnd(row) {

		var fileAttachSeq = cardListSheet.GetCellValue(row, 'fileAttachSeq');
		var fileSeq = cardListSheet.GetCellValue(row, 'fileSeq');

		cardListSheet.SetCellValue(row, 'addFile', '<div class="form_file"><label class="file_btn"><input type="file" id=file'+row+' name="photoFile" title="파일첨부" onchange="fileUpload(this.id);"/><span class="btn_tbl">찾아보기</span></label></div>');
		notEditableCellColor('cardListSheet', row);

		if(fileAttachSeq != '') {
			cardListSheet.SetCellValue(row, 'img', '<img alt="" style="width: 85px; height: 27px;" src="/kitaCard/kitaCardImage.do?fileAttachSeq='+fileAttachSeq+'&fileSeq=1">');
		} else {
			cardListSheet.SetCellValue(row, 'img', '<input type="hidden" name="newRow'+row+'" />');
		}

		cardListSheet.SetCellValue(row, 'status', '');

	}

	function fileUpload(obj) {
		var idx = obj.replace('file', '');

		global.ajaxSubmit($('#frm'), {
			type : 'POST'
			, url : '/kitaCard/saveKitaCardPhoto.do'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.result == 'false') {
					alert(data.message);
				} else {
					cardListSheet.SetCellValue(idx, 'fileAttachSeq', data.fileAttachSeq);
					cardListSheet.SetCellValue(idx, 'status', 'U');
					$('#obj').val('');
				}
	        }
		});
	}

	function getCardList() {	// 카드조회

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/selectKitaCardMngList.do"
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				cardListSheet.LoadSearchData({Data: (data.resultList || []) });
				$('#fileAttachSeq').val(data.resultList[0].fileAttachSeq);
			}
		});
	}

	function doAdd() {	// 추가

		var idx = cardListSheet.DataInsert(-1);

		var fileAttachSeq = cardListSheet.GetCellValue(1, 'fileAttachSeq');

		cardListSheet.SetCellEditable(idx,'cardCode',1);

		cardListSheet.SetCellValue(idx, 'addFile', '<div class="form_file"><label class="file_btn"><input type="file" id=file'+idx+' name="photoFile" title="파일첨부" onchange="fileUpload(this.id);"/><span class="btn_tbl">찾아보기</span></label></div>');
		cardListSheet.SetCellValue(idx, 'img', '<input type="hidden" name="newRow'+idx+'" />');

		cardListSheet.SetCellBackColor(idx, 'cardCode', '#FFFFFF');

		addFileSeq.push(idx);
	}

	function isValid() {

		var chk = true;

		var firstRow = cardListSheet.GetDataFirstRow();
		var rowCnt = cardListSheet.RowCount();
		for(var i = firstRow; i <= rowCnt; i++) {
			if(cardListSheet.GetCellValue(i, 'cardCode') == '') {
				alert(i+'번째 카드코드를 입력해주세요.');
				return false;
			}

			if(cardListSheet.GetCellValue(i, 'cardCorp') == '') {
				alert(i+'번째 카드사를 입력해주세요.');
				return false;
			}

			if(cardListSheet.GetCellValue(i, 'cardName') == '') {
				alert(i+'번째 카드명을 입력해주세요.');
				return false;
			}

			if(cardListSheet.GetCellValue(i, 'siteLink') == '') {
				alert(i+'번째 카드사링크를 입력해주세요.');
				return false;
			}
		}

		var codeChk = cardListSheet.ColValueDup('cardCode');	// 카드코드 중복체크

		if(codeChk > 0) {
			alert(codeChk+'번째 카드코드는 중복입니다.');
			return false;
		}

// 		for(var i = 0; i < addFileSeq.length; i++) {
// 			var chk = $('#file'+addFileSeq[i]).val();
// 			if(!chk) {
// 				chk = false;
// 				alert(addFileSeq[i]+'번째 카드 이미지를 등록해주세요.');
// 				return false;
// 			}
// 		}

		return chk;
	}

	function doSave() {

		if(!isValid()) {
			return;
		}

		var pPramData = cardListSheet.GetSaveJson();

		if(pPramData.Code == 'IBS010' || pPramData.Code == 'IBS020') {
			return;
		}

		if(pPramData.Code == 'IBS000') {
			alert("작업할 데이터가 없습니다.");
			return;
		}

		if(!confirm("저장 하시겠습니까?")){
			return false;
		}

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/saveKitaCardInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pPramData.data)
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}

</script>