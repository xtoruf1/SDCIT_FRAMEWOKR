<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="frm" name="frm" method="get" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="indvdVipQRSend();">QR발급</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doRowAdd();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="location.reload();" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col />
			<col style="width:10%" />
			<col style="width:20%" />
			<col style="width:10%" />
			<col style="width:20%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">행사명</th>
				<td>
					<select id="sSvrId" name="sSvrId" class="form_select w100p" onchange="doSearch();">
						<c:forEach var="list" items="${tradeDayList}" varStatus="status">
						<option value="${list.svrId}">${list.tradeDayTitle}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">회사명</th>
				<td>
					<input type="text" id="sCompanyName" name="sCompanyName" value="" onkeydown="onEnter(doSearch);" class="form_text w100p" title="회사명" />
				</td>
				<th scope="row">VIP명</th>
				<td>
					<input type="text" id="sVipName" name="sVipName" value="" onkeydown="onEnter(doSearch);" class="form_text w100p" title="VIP명" />
				</td>
            </tr>
			<tr>
				<th scope="row">참석여부</th>
				<td>
					<label class="label_form">
						<input type="radio" class="form_radio" name="sAttendYn" id="radio1_1" value="" checked>
						<span class="label">전체</span>
					</label>
					<label class="label_form">
						<input type="radio" class="form_radio" name="sAttendYn" id="radio1_2" value="Y">
						<span class="label">참석</span>
					</label>
					<label class="label_form">
						<input type="radio" class="form_radio" name="sAttendYn" id="radio1_3" value="N">
						<span class="label">불참</span>
					</label>
				</td>
				<th scope="row">발송여부</th>
				<td colspan="3">
					<label class="label_form">
						<input type="radio" class="form_radio" name="sSendYn" id="radio2_1" value="" checked>
						<span class="label">전체</span>
					</label>
					<label class="label_form">
						<input type="radio" class="form_radio" name="sSendYn" id="radio2_2" value="Y">
						<span class="label">발송</span>
					</label>
					<label class="label_form">
						<input type="radio" class="form_radio" name="sSendYn" id="radio2_3" value="N">
						<span class="label">미발송</span>
					</label>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
		<fieldset class="ml-auto">
		</fieldset>
	</div>
	<div class="w100p mt-20">
		<div id="sheetDiv" class="colPosi mt-20" style="height:560px"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>
</form>
<script type="text/javascript">


	var f;
	$(document).ready(function(){
		f = document.frm;

		fn_InitSetting();

		//목록조회 호출
		getList();
	});

	function fn_InitSetting() {
		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태', 			Type: 'Status', 	SaveName: 'status', Hidden: true});
		ibHeader.addHeader({Header: 'svrId',		Type: 'Text', 		SaveName: 'svrId', 	Hidden: true});
		ibHeader.addHeader({Header: 'vipId',		Type: 'Text', 		SaveName: 'vipId', 	Hidden: true});
		ibHeader.addHeader({Header: 'qrId',		    Type: 'Text', 		SaveName: 'qrId', 	Hidden: true});
		ibHeader.addHeader({Header: '삭제', 			Type: 'DelCheck', 	SaveName: 'delFlag', 			Width: 40, 	Align: 'Center',	Edit: 1, HeaderCheck: 0});
		ibHeader.addHeader({Header: '선택',          Type: 'CheckBox',   SaveName: 'check',              Width: 40, HeaderCheck : 1});
		ibHeader.addHeader({Header: '회사명',    	Type: 'Text',     	SaveName: 'companyName',		Width:200,  Align: 'Left',		KeyField: 1, 	UpdateEdit: true,   InsertEdit: true });
		ibHeader.addHeader({Header: 'VIP명',    	Type: 'Text',     	SaveName: 'vipName', 			Width:100,  Align: 'Center',	KeyField: 1, 	UpdateEdit: true,  	InsertEdit: true });
		ibHeader.addHeader({Header: '주민등록번호',   Type: 'Text',     	SaveName: 'vipJuminNo', 		Width:100,  Align: 'Center',	KeyField: 0, 	UpdateEdit: true,   InsertEdit: true, 	EditLen:20 });
		ibHeader.addHeader({Header: '휴대폰',   		Type: 'Text',     	SaveName: 'vipPhone', 			Width:100,  Align: 'Center',	KeyField: 0, 	UpdateEdit: true,   InsertEdit: true, 	EditLen:20 });
		ibHeader.addHeader({Header: '이메일',   		Type: 'Text',     	SaveName: 'vipEmail', 			Width:100,  Align: 'Center',	KeyField: 0, 	UpdateEdit: true,   InsertEdit: true, 	EditLen:30 });
		ibHeader.addHeader({Header: '발송',   		Type: 'Text',     	SaveName: 'sendYn', 			Width:50,  	Align: 'Center',	KeyField: 0, 	UpdateEdit: false,  InsertEdit: false, 	EditLen:30, BackColor: '#F6F6F6'});
		ibHeader.addHeader({Header: '참석여부',   	Type: 'Text',     	SaveName: 'attendYn', 			Width:50,  	Align: 'Center',	KeyField: 0, 	UpdateEdit: false,  InsertEdit: false, 	EditLen:30, BackColor: '#F6F6F6'});

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, NoFocusMode: 0});
		ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

		var sheetId = "sheetDiv";
		var container = $("#"+sheetId)[0];
		var div_heigth = $('#sheetDiv')[0].style.height;

		createIBSheet2(container,sheetId, "100%", div_heigth);
		ibHeader.initSheet(sheetId);
		sheetDiv.SetSelectionMode(2);

	}

	//시트가 조회된 후 실행
	function sheetDiv_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('sheetDiv_OnSearchEnd : ', msg);
    	} else {
    	}
    }

	//시트 클릭 이벤트
	function sheetDiv_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
		}
	}

	//검색
	function doSearch() {
		goPage(1);
	}

	//페이징 검색
	function goPage(pageIndex) {
		getList();
	}

	//목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/selectTradeDayVipList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheetDiv.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function doRowAdd() {
		var index = sheetDiv.DataInsert(-1);
		sheetDiv.SetCellValue(index,'svrId',$('#sSvrId').val());

	}

	function doSave() {
		var jsonParam = {};
		var saveJson = sheetDiv.GetSaveJson();
		jsonParam.sheetDataList = saveJson.data;

		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'NoTargetRows') {
			alert('저장할 데이터가 없습니다.');
			return false;
		}

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tradeDay/clbrt/saveTradeDayVip.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	 /**
	 * VIP QR코드 발송
	 */
	function indvdVipQRSend() {

		var chkRow = sheetDiv.FindCheckedRow('check');

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return false;
		}

		var saveData = sheetDiv.GetSaveJson();
		$('#loading_image').show(); // 로딩이미지 시작
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/tradeDayQrCodeSend.do" />'
			, contentType : 'application/json'
			, data : JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#loading_image').hide(); // 로딩이미지 종료
				alert(data.MESSAGE);
			}
		});

	}

</script>