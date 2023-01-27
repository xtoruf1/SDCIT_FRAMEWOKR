<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />

<div id="loading_wrapper" class="loading_wrapper" style="display: none;">
	<img src="/images/common/loading.gif" class="loading_image">
</div>

<div class="flex">
	<h2 class="popup_title">첨부파일 목록</h2>
	<div class="ml-auto">
		<c:if test="${param.modifyYn eq 'Y'}">
			<button type="button" class="btn_sm btn_primary" onclick="AddFile();">추가</button>
			<button type="button" class="btn_sm btn_primary" onclick="DeleteFile();">삭제</button>
		</c:if>
		<button type="button" class="btn_sm btn_secondary" onclick="onClose();">닫기</button>
	</div>
</div>

<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
	<input type="hidden" name="seq"/>
	<input type="hidden" name="fileId" value="<c:out value="${param.fileId}"/>"/>
	<input type="hidden" name="fileInputName" value="<c:out value="${param.fileInputName}"/>"/>
	<div class="popup_body" style="width:500px">
		<c:if test="${param.modifyYn eq 'Y'}">
		<div class="form_file w100p ml-auto">
			<input type="text" name="fileTxt" id="fileTxt" class="form_text" readonly="readonly">
			<label class="file_btn">
				<input type="file" id="attachFile" name="attachFile" />
				<span class="btn_tbl">찾아보기</span>
			</label>
		</div>
		</c:if>
		<div class="mt-10">
			<div id="searchFileList" class="sheet"></div>
		</div>
	</div>
</form>

<form id="frmDown" name="frmDown" method="post" enctype="multipart/form-data" action="/common/util/tradefundFileDownload.do">
	<input type="hidden" id="fileId" name="fileId" value="<c:out value="${param.fileId}"/>"/>
	<input type="hidden" id="fileNo" name="fileNo"/>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		$(".loading_image").css({top: "-21%", left: "25%" });

		var fileForm = document.frmFile;
		jQuery.ajaxSetup({cache:false});

		$('#attachFile').on('click' , function(){
			$("#loading_wrapper").show();
			initialize();
		});

		$('#attachFile').change(function() {
			var fileName = $(this).val();
			fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
			$('#fileTxt').val(fileName);
			$("#loading_wrapper").hide();
		});

		selectFileList();
	});

	function initialize(event) {
	    document.body.onfocus = checkIt;
	}

	function checkIt() {
	   $("#loading_wrapper").hide();
	  document.body.onfocus = null;
	}

	function onClose() {
		var fileForm = document.frmFile;
		var returnObj = [];
		var rFileId = fileForm.fileId.value;
		if( rFileId ){
			returnObj.push(rFileId);
			layerPopupCallback(returnObj);
		}
		// 레이어 닫기
		closeLayerPopup();
	}

	function selectFileList() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/popup/selectFileList.do" />'
			, data : $('#frmFile').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				setFileGrid(data);
			}
		});
	}

	function setFileGrid(data) {

		if (typeof searchFileListSheet !== "undefined" && typeof searchFileListSheet.Index !== "undefined") {
			searchFileListSheet.DisposeSheet();
		}

		var	ibFileHeader = new IBHeader();
		ibFileHeader.addHeader({Header: '상태',				 SaveName: 'status',			Type: 'Status',		Width: 10, Align: 'Center', Hidden: true	});
		<c:if test="${param.modifyYn eq 'Y'}">
			ibFileHeader.addHeader({Header: '',					 SaveName: 'delFlag',			Type: 'DelCheck',	Width: 10, Align: 'Center', Hidden: false, Edit:true	});
		</c:if>
		ibFileHeader.addHeader({Header: 'fileNo',			 SaveName: 'fileNo',			Type: 'Text',		Width: 10, Align: 'Center', Hidden: true	});
		ibFileHeader.addHeader({Header: 'No',				 SaveName: 'rn',				Type: 'Text',		Width: 10, Align: 'Center', Hidden: false	});
		ibFileHeader.addHeader({Header: '파일 이름',			 SaveName: 'fileName',			Type: 'Text',		Width: 40, Align: 'Left', Hidden: false , Ellipsis: true, Cursor: 'Pointer'	});
		ibFileHeader.addHeader({Header: '파일 사이즈',			 SaveName: 'fileSize',			Type: 'Text',		Width: 20, Align: 'Center'	});
		ibFileHeader.addHeader({Header: '등록일',				 SaveName: 'creDate',			Type: 'Date',		Width: 20, Align: 'Center', Edit: false	});
		ibFileHeader.addHeader({Header: '미리보기',			 SaveName: 'viewBnt',			Type: 'Html',		Width: 20, Align: 'Center', Edit: true, Hidden: true	});
		ibFileHeader.addHeader({Header: 'encFilePath',		 SaveName: 'encFilePath',		Type: 'Text',		Width: 10, Align: 'Center', Hidden: true	});
		ibFileHeader.addHeader({Header: 'encFileName',		 SaveName: 'encFileName',		Type: 'Text',		Width: 10, Align: 'Center', Hidden: true	});
		ibFileHeader.addHeader({Header: 'encOriginFilename', SaveName: 'encOriginFilename',	Type: 'Text',		Width: 10, Align: 'Center', Hidden: true	});

		ibFileHeader.addHeader({Header: 'fileId', SaveName: 'fileId',	Type: 'Text',		Width: 10, Align: 'Center', Hidden: true	});


		ibFileHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, editable: false});
		ibFileHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#searchFileList')[0];
		createIBSheet2(container, 'searchFileListSheet', '100%', '100%');
		ibFileHeader.initSheet('searchFileListSheet');
		searchFileListSheet.LoadSearchData({Data: data.fileList});

		searchFileListSheet.SetColFontBold('fileName', 1);
	}

 	function searchFileListSheet_OnRowSearchEnd(row) {

	}

	function searchFileListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {

		if(searchFileListSheet.ColSaveName(col) == 'fileName' && row > 0) {
			var fileNo = searchFileListSheet.GetCellValue(row , "fileNo");
			doDownloadFile(fileNo);
		}

	}

	//첨부파일 다운로드
	function doDownloadFile(fileNo) {
		$('#frmDown #fileNo').val(fileNo);
		$('#frmDown').submit();
	}

	function AddFile() {
		var fileForm = document.frmFile;

		if( fileForm.attachFile.value == "" ) {
			alert("파일을 선택하세요.");
			return;
		}

		if (fileForm.fileInputName.value == "attFileId") {
			var lastLow = searchFileListSheet.GetDataLastRow();
			if( lastLow > 0 ) {
				alert("사업자등록증은 한장만 저장 가능합니다.");
				return;
			}
		}

/* 		var fileExt = fileForm.attachFile.value.substring(fileForm.attachFile.value.lastIndexOf(".")+1).toLowerCase();
		if(fileExt != "jpg" && fileExt != "gif" && fileExt != "png" && fileExt != "tif" && fileExt != "bmp" && fileExt != "jpeg" && fileExt != "pdf") {
			alert("사용할 수 있는 첨부파일 확장자는 pdf, 이미지파일(jpg, gif, bmp, jpeg, tif, png등) 입니다.");
			alert("첨부파일 허용가능한 확장자가 아닙니다.");
			return;
		} */

		if(confirm("저장 하시겠습니까?")) {
			global.ajaxSubmit($('#frmFile'), {
				type : 'POST'
				, url : '<c:url value="/svcex/svcexCertificate/popup/insertOfflineRegsFileSave.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					if (data.code == "Success"){
						fileForm.fileId.value = data.fileId;
						selectFileList();
					}else{
						alert(data.msg);
					}
		        }
			});
		}
	} // AddFile

	function DeleteFile() {
		var lastLow = searchFileListSheet.GetDataLastRow();
		var saveJson = searchFileListSheet.GetSaveJson();

		if (lastLow < 0) {
			alert("삭제할 파일이 없습니다.");
			return;
		}

		if (saveJson.data.length < 1) {
			alert("삭제할 파일을 선택하세요.");
			return;
		}

		var viewFormSO = $('#frmFile').serializeObject();

		if (confirm("삭제하시겠습니까?")) {
			var map = {};
			var list = [];
			$.each(saveJson, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				viewFormSO['dataList'] = list;
			});

			global.ajax({
				type : 'POST'
				, url : '<c:url value="/svcex/svcexCertificate/popup/offlineRegsFileDelete.do" />'
				, data : JSON.stringify(viewFormSO)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data) {
					selectFileList();
				}
			});
		}
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>