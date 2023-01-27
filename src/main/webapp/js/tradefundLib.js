/*
	[포상]
	첨부파일 공통 목록 (시트목록)
	sheeObj : Sheet Object 변수
	Row : 해당 Row
	saveName : Sheet col savename
*/
function commonViewFileSheet(sheetObj, Row, saveName, modifyYn) {

	var fileId = sheetObj.GetCellValue(Row, saveName);

	global.openLayerPopup({
		popupUrl : '/tdms/popup/fileListPopup.do',
		params : {
			fileId:fileId,
			fileInputName:'attFileId',
			modifyYn:modifyYn
		},
		callbackFunction : function(resultObj) {
			return false;
		}
	});

}

/**
	MTI CODE 목록
*/
function commonGetMtiCodeList(obj) {

	var mtiCodeList;

	if(obj == null) {
		obj = {
			event:''
		}
	}

	global.ajax({
		type : 'POST',
		url : '/tradefund/comm/selectMtiCodeList.do',
		contentType : 'application/json',
		data : JSON.stringify(obj),
		dataType : 'json',
		async : false,
		spinner : true,
		success : function(data){
			mtiCodeList = data
		},
		error : function(request, status, error) {
			mtiCodeList = '';
		}
	});

	return mtiCodeList;

}

function commonSetMtiCodeComboBox(comboId, obj) {

	$('#'+comboId).empty();
	var html = '<option value="">전체</option>';
	$(obj).each(function() {
		html += '<option value="' + this.mtCd + '">' + this.korName + '</option>';
	});
	$('#'+comboId).append(html);

}
