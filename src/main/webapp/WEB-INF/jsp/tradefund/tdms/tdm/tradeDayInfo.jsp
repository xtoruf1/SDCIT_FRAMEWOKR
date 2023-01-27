<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="infoForm" name="infoForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="statusChk" name="statusChk" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doNew();" class="btn_sm btn_primary btn_modify_auth">추가</button>
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doPreview();" class="btn_sm btn_primary">미리보기</button>
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
		<!--
		<button type="button" onclick="showApplicationTest();" class="btn_sm btn_primary">신청서 작성(샘플)</button>
		<button type="button" onclick="showSelectionTest();" class="btn_sm btn_primary">신청서 평가(샘플)</button>
		<button type="button" onclick="showViewTest();" class="btn_sm btn_primary">포상신청정보(샘플)</button>
		<button type="button" onclick="showReceiptReportTest();" class="btn_sm btn_primary">인수증 출력(샘플)</button>
		-->
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>
					<input type="text" id="searchTitle" name="searchTitle" value="${param.searchTitle}" onkeydown="onEnter(doSearch);" class="form_text w100p" maxlength="150" title="제목" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="fund_reg mt-20">
	<div class="left" style="width: 45%;">
		<div class="cont_block">
			<div class="tbl_opt">
				<div id="totalCnt" class="total_count"></div>
			</div>
			<div style="width: 100%;">
				<div id="infoList" class="sheet"></div>
			</div>
		</div>
	</div>
	<div class="right" style="width: 55%;">
		<div class="cont_block">
			<div class="tbl_opt">
				<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tr>
					<th>No</th>
					<td>
						<input type="text" id="no" name="no" value="" maxlength="200" class="form_text w100p" title="번호" readonly="readonly" />
						<input type="hidden" id="infoSeq" name="infoSeq" value="" />
					</td>
				</tr>
				<tr>
					<th>제목 <strong class="point">*</strong></th>
					<td>
						<input type="text" id="title" name="title" value="" maxlength="200" class="form_text w100p" title="제목" required="required" />
					</td>
				</tr>
				<tr>
					<th rowspan="2">내용 <strong class="point">*</strong></th>
					<td>
						<textarea id="content" name="content" rows="40" onkeyup="checkTextarea(this);" style="width: 100%;line-height: 18px;font-size: 14px;padding: 5px;" title="내용" required="required"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						(<span id="textareaCnt"></span>) / 4,000 Byte
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td>
						<input type="hidden" id="attFileId" name="attFileId" />
						<input type="hidden" id="fileId" name="fileId" />
						<input type="hidden" id="fileNo" name="fileNo" />
						<div id="attachFieldList"></div>
						<div class="form_group">
							<div id="attachDiv" class="form_file">
								<p class="file_name">첨부파일을 선택하세요</p>
								<label class="file_btn">
									<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
									<input type="hidden" name="attachFileSeq" value="1" />
									<span class="btn_tbl">찾아보기</span>
								</label>
							</div>
							<button type="button" onclick="doAddAttachField();" class="btn_tbl_border btn_modify_auth">추가</button>
						</div>
						<div id="attachFieldEdit"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		initIBSheet();
	});

	// Sheet의 초기화 작업
	function initIBSheet() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: 'No', Type: 'Text', Hidden: false, Width: 50, Align: 'Center', SaveName: 'no', Cursor: 'Pointer' });
		ibHeader.addHeader({Header: '제목', Type: 'Text', Hidden: false, Width: 170, Align: 'Left', SaveName: 'title', KeyField: 1, CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Cursor: 'Pointer' });
		ibHeader.addHeader({Header: '작성자', Type: 'Text', Hidden: false, Width: 100, Align: 'Center', SaveName: 'creName', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Cursor: 'Pointer' });
		ibHeader.addHeader({Header: '작성일자', Type: 'Text', Hidden: false, Width: 130, Align: 'Center', SaveName: 'creDate', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Cursor: 'Pointer' });

		ibHeader.addHeader({Header: '삭제', Type: 'Text', Hidden: true, Width: 50, Align: 'Center', SaveName: '' });
		ibHeader.addHeader({Header: '포상안내번호', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'infoSeq', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '본문', Type: 'Text', Hidden: true, Width: 180, Align: 'Center', SaveName: 'content', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '타입', Type: 'Text', Hidden: true, Width: 80, Align: 'Center', SaveName: 'type', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '작성자아이디', Type: 'Text', Hidden: true, Width: 80, Align: 'Center', SaveName: 'creBy', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수정자', Type: 'Text', Hidden: true, Width: 80, Align: 'Center', SaveName: 'updBy', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수정일자', Type: 'Text', Hidden: true, Width: 80, Align: 'Center', SaveName: 'updDate', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '파일아이디', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'attFileId', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		// ibHeader.addHeader({Header: '파일목록', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'attFileList', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 5, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = 'infoList';
		var container = $('#' + sheetId)[0];
		if (typeof infoListSheet !== 'undefined' && typeof infoListSheet.Index !== 'undefined') {
			infoListSheet.DisposeSheet();
		}

		createIBSheet2(container, 'infoListSheet', '100%', '600px');
		ibHeader.initSheet('infoListSheet');
		infoListSheet.SetSelectionMode(4);

		infoListSheet.SetEditable(true);

		getList();
	}

	function infoListSheet_OnSort(col, order) {
		infoListSheet.SetScrollTop(0);
	}

	// 조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectTradeDayInfoList.do" />'
			, data : $('#infoForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				infoListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function infoListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('infoListSheet_OnSearchEnd : ', msg);
    	} else {
    		infoListSheet.SetSelectRow(infoListSheet.GetDataFirstRow());
    		infoListSheet.ReNumberSeq('desc');
    		getListValue(infoListSheet.GetDataFirstRow());
    	}
		// infoListSheet.SetColFontBold('title', 1);	// 성명 링크에 볼드 처리
    }

	function getListValue(row) {
		var formObj = document.infoForm;
		var sheetObj = infoListSheet;

		setFormFromSheet(formObj, sheetObj, row);

		$('#attachFieldList').empty();
		$('#attachFieldEdit').empty();

		var attFileId = sheetObj.GetCellValue(row, 'attFileId');

		if (attFileId) {
			getAttachList(attFileId);
		}

		$('#statusChk').val('U');
		$('#content').trigger('keyup');
	}

	function checkTextarea(obj) {
		var textareaLength = doValidLength(obj.value);

	    $('#textareaCnt').text(global.formatCurrency(textareaLength));

		if (textareaLength > 4000) {
	    	alert('4,000 Byte 이상 입력 하실 수 없습니다.');
	    	obj.value = obj.value.substring(0, obj.value.length - 1);

	    	return false;
	    }

	    return true;
	}

	function infoListSheet_OnClick(row, col, value) {
		if (row > 0) {
			// if (infoListSheet.ColSaveName(col) == 'title') {
				getListValue(row);
			// }
		}
	}

	function doNew() {
		var f = document.infoForm;

		f.statusChk.value = 'I';
		f.no.value = '';
	    f.title.value = '';
	    f.content.value = '';
	    f.attFileId.value = '';
	    f.fileId.value = '';
	    f.fileNo.value = '';

	    checkTextarea(f.content);

	    $('#attachFieldList').empty();
		$('#attachFieldEdit').empty();
	}

	// 첨부파일 목록 가져오기
	function getAttachList(attFileId) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectInfoAttachList.do" />'
			, data : {
				fileId : attFileId
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#attachFieldList').empty();
				$('#attachFieldEdit').empty();

				if (data.attachList.length) {
					var attachList = data.attachList;

					for (var i = 0 ; i < attachList.length; i++) {
						var fileNo = attachList[i].fileNo;
						var fileName = attachList[i].fileName;

						if (fileNo != '') {
							var html = '';
							html += '<div id="fileNo_' + fileNo + '" class="addedFile">';
							html += '	<a href="javascript:void(0);" onclick="doDownloadFile(\'' + fileNo + '\');" class="filename">' + fileName + '</a>';
							html += '	<a href="javascript:void(0);" onclick="doDeleteFile(\'' + fileNo + '\');" class="btn_del">';
							html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
							html += '	</a>';
							html += '</div>';

							$('#attachFieldList').append(html);
							$('#attachFieldList').css('padding-bottom', '20px');
						}
					}
				}
			}
		});
	}

	// 첨부파일 필드 추가
	function doAddAttachField() {
		var attachCnt = 0;
		$('input[name="attachFileSeq"]').each(function(){
			attachCnt = $(this).val();
		});

		var attachFileSeq = parseInt(attachCnt) + 1;

		var html = '';
		html += '<div id="field' + attachFileSeq + '" class="mb5px flex mt-5">';
		html += '	<div class="form_file">';
		html += '		<p class="file_name">첨부파일을 선택하세요</p>';
		html += '		<label class="file_btn">';
		html += '			<input type="file" name="attachFile" class="txt" title="첨부파일" />';
		html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
		html += '			<span class="btn_tbl">찾아보기</span>';
		html += '		</label>';
		html += '	</div>';
		html += '	<button type="button" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border btn_modify_auth">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
	}

	// 첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var f = document.infoForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = f.attFileId.value;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	// 첨부파일 삭제
	function doDeleteFile(fileNo) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundFileDelete.do" />'
				, data : {
					fileId : $('#attFileId').val()
					, fileNo : fileNo
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#fileNo_' + fileNo).hide();
				}
			});
		}
	}

	function doPreview() {
		window.open('<c:url value="/tdms/tdm/tradeDayInfoPreviewPopup.do" />', 'popupForm', 'width=750px,height=600px,scrollbars=yes');
	}

	function validationForm() {
		var f = document.infoForm;

		if (!checkTextarea(f.content)) {
			return false;
		}

		return true;
	}

	// 저장
	function doSave() {
		var f = document.infoForm;

		if (!doValidFormRequired(f)) {
			return;
		}

		if (!validationForm()) {
			return;
		}

		if (confirm('포상안내를 저장하시겠습니까?')) {
			global.ajaxSubmit($('#infoForm'), {
				type : 'POST'
				, url : '<c:url value="/tdms/tdm/saveTradeDayInfo.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					// alert('포상안내를 저장하였습니다.');

					getList();

					$('#attachDiv').empty();

					var html = '';
					html += '<p class="file_name">첨부파일을 선택하세요</p>';
					html += '<label class="file_btn">';
					html += '	<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />';
					html += '	<input type="hidden" name="attachFileSeq" value="1" />';
					html += '	<span class="btn_tbl">찾아보기</span>';
					html += '</label>';

					$('#attachDiv').html(html);
		        }
			});
		}
	}

	function doDelete() {
		if (confirm('포상안내를 삭제하시겠습니까?')) {
			var f = document.infoForm;
			f.statusChk.value = 'D';

			global.ajaxSubmit($('#infoForm'), {
				type : 'POST'
				, url : '<c:url value="/tdms/tdm/deleteTradeDayInfo.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					// alert('포상안내를 삭제하였습니다.');

					getList();
		        }
			});
		}
	}

	function showApplicationTest() {
		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplicationPopup.do" />'
			, params : {
				/*
				svrId : 'H202207001'
				, applySeq : '33849'
				, memberId : '13141312'
			    , priType : 'A'
			    , appEditYn : 'Y'
				, proxyYn : 'N'
				*/
				/*
				svrId : 'H202207001'
				, applySeq : '33847'
				, memberId : '10334151'
			    , priType : 'T'
			    , appEditYn : 'N'
				, proxyYn : 'Y'
				*/
				/* 특수유공 */
				/*
				svrId : 'H202106001'
				, applySeq : '31285'
				, memberId : '731324'
			    , priType : 'S'
			    , appEditYn : 'Y'
				, proxyYn : 'Y'
				*/
				/*
				svrId : 'H202106001'
				, applySeq : '31295'
				, memberId : '11820318'
			    , priType : 'A'
			    , editYn : 'N'
				, proxyYn : 'N'
				*/
				/*
				svrId : 'H202106001'
				, applySeq : '31299'
				, memberId : '11140340'
			    , priType : 'S'
			    , editYn : 'N'
				, proxyYn : 'N'
				*/
				svrId : 'H201707001'
				, applySeq : '24739'
				, memberId : '30766747'
			    , priType : 'S'
			    , editYn : 'N'
				, proxyYn : 'Y'
			}
			, callbackFunction : function(resultObj){
				var event = resultObj.event;

				// 업체수정 처리
				if (event == 'tradeDayApplicationTempUpdate') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 삭제 처리
				} else if (event == 'tradeDayApplicationDelete') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();
				// 신청구분 변경
				} else if (event == 'tradeDayApplicationChangePriType') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 저장
				} else if (event == 'tradeDayApplicationSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 임시저장
				} else if (event == 'tradeDayApplicationTempSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				}
			}
		});
	}

	function showSelectionTest() {
		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDaySelectionPopup.do" />'
			, params : {
				/*
				svrId : 'H202207001'
				, applySeq : '33849'
				, memberId : '13141312'
			    , priType : 'A'
			    , editYn : 'Y'
				, proxyYn : 'N'
				*/
				/*
				svrId : 'H202207001'
				, applySeq : '33847'
				, memberId : '10334151'
			    , priType : 'T'
			    , editYn : 'Y'
				, proxyYn : 'Y'
				*/
				/* 특수유공 */
				/*
				svrId : 'H202106001'
				, applySeq : '31295'
				, memberId : '11820318'
			    , priType : 'A'
			    , editYn : 'N'
				, proxyYn : 'N'
				*/
				svrId : 'H202007001'
				, applySeq : '28716'
				, memberId : '09086129'
			    , priType : 'T'
			    , editYn : 'N'
				, proxyYn : 'N'
			}
			, callbackFunction : function(resultObj){
				var event = resultObj.event;

				// 평가 저장
				if (event == 'tradeDaySelectionSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					showSelectionTest();
				}
			}
		});
	}

	function showViewTest() {
		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayViewPopup.do" />'
			, params : {
				/*
				svrId : 'H202207001'
				, applySeq : '33847'
				, memberId : '10334151'
			    , priType : 'T'
			    , appEditYn : 'N'
				, proxyYn : 'Y'
				*/
				/*
				svrId : 'H202106001'
				, applySeq : '31295'
				, memberId : '11820318'
			    , priType : 'A'
			    , editYn : 'N'
				, proxyYn : 'N'
				*/
				svrId : 'H202007001'
				, applySeq : '28716'
				, memberId : '09086129'
			    , priType : 'T'
			    , editYn : 'N'
				, proxyYn : 'N'
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	function showReceiptReportTest() {
		var url = '<c:url value="/tdas/report/tradeDayReceiptPrint.do" />?svrId=H202207001&applySeq=35987';

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}
	}
</script>