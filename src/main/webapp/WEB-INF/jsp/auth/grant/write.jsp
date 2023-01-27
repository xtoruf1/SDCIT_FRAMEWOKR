<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchNameId" value="${param.searchNameId}" />
<input type="hidden" name="searchAuthName" value="${param.searchAuthName}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="authForm" name="authForm" method="get" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="showAuthList();" class="btn_sm btn_primary btn_modify_auth">추가</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="tbl_opt">
	<span>
		<strong class="point">*</strong> 는 필수 입력입니다.<br />
		<strong class="point">*</strong> 개인정보 조회가 불가능으로 설정이 되어있으면 모든 권한에서 저장버튼이 비활성화 됩니다.
	</span>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">사용자 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="userNmId" value="" class="textType form_text" title="사용자" readonly="readonly" />
					<input type="hidden" id="userId" name="userId" value="${resultView.userId}" />
					<input type="hidden" id="userNm" name="userNm" value="${resultView.userNm}" />
					<c:if test="${empty resultView.userId}">
						<button type="button" onclick="showUserList();" class="btn_tbl btn_modify_auth">추가</button>
					</c:if>
				</td>
				<th scope="row">개인정보 조회 <strong class="point">*</strong></th>
				<td>
					<label class="label_form">
						<input type="radio" name="infoCheckYn" value="Y" class="form_radio" title="개인정보 조회"
							<c:if test="${empty resultView.infoCheckYn or resultView.infoCheckYn eq '' or resultView.infoCheckYn eq 'Y'}">checked="checked"</c:if>
						/>
						<span class="label">가능</span>
					</label>
					<label class="label_form">
						<input type="radio" name="infoCheckYn" value="N" class="form_radio" title="개인정보 조회"
							<c:if test="${resultView.infoCheckYn eq 'N'}">checked="checked"</c:if>
						/>
						<span class="label">불가능</span>
					</label>
				</td>
            </tr>
			<tr>
				<th scope="row">기금 부서 </th>
				<td>
					<select id="fundDeptCd" name="fundDeptCd" class="form_select" >
						<option value="">선택</option>
						<c:forEach var="item" items="${COM005}" varStatus="status">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq resultView.fundDeptCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">포상 부서 </th>
				<td>
					<select id="awardDeptCd" name="awardDeptCd" class="form_select" >
						<option value="">선택</option>
						<c:forEach var="item" items="${COM005}" varStatus="status">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq resultView.awardDeptCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
						</c:forEach>
					</select>
				</td>
            </tr>
			<tr>
				<th scope="row">전화번호</th>
				<td>
					<input type="text" id="telNo" name="telNo" value="${resultView.telNo}" maxlength="20" class="textType form_text" title="전화번호" onkeyup="this.value=this.value.replace(/[^0-9]/g, '');" />
				</td>
				<th scope="row">팩스번호</th>
				<td>
					<input type="text" id="faxNo" name="faxNo" value="${resultView.faxNo}" maxlength="20" class="textType form_text" title="팩스번호" onkeyup="this.value=this.value.replace(/[^0-9]/g, '');" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="authList" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden : true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 20, Align: 'Center', Edit: 1, HeaderCheck: 0});
	ibHeader.addHeader({Header: '시스템', Type: 'Text', SaveName: 'systemMenuName', Width: 100, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '권한명', Type: 'Text', SaveName: 'authName', Width: 100, Align: 'Left', Edit: 0});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 50, Align: 'Center', Edit: 0});

	ibHeader.addHeader({Header: '시스템 메뉴아이디', Type: 'Text', SaveName: 'systemMenuId', Hidden: true});
	ibHeader.addHeader({Header: '권한아이디', Type: 'Text', SaveName: 'authId', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	var fundAuthCnt = 0;
	var awardAuthCnt = 0;
	$(document).ready(function(){
		f = document.authForm;
		lf = document.listForm;

		<c:if test="${not empty resultView.userId}">
			$('#userNmId').val('${resultView.maskUserNm} (${resultView.userId})');
		</c:if>

		var container = $('#authList')[0];
		createIBSheet2(container, 'authListSheet', '100%', '530px');
		ibHeader.initSheet('authListSheet');
		authListSheet.SetSelectionMode(4);

		getList();
	});

	function authListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('authListSheet_OnSearchEnd : ', msg);
    	}
    }

	function getUserInfo() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/grant/getUserInfo.do" />'
			, data : $('#authForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('input[name=infoCheckYn][value='+data.resultView.infoCheckYn+']').prop('checked',true);
				$('#fundDeptCd').val(data.resultView.fundDeptCd);
				$('#awardDeptCd').val(data.resultView.awardDeptCd);
				$('#telNo').val(data.resultView.telNo);
				$('#faxNo').val(data.resultView.faxNo);
				getList();

			}
		});
	}
	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/authority/grant/authList.do" />'
			, data : $('#authForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				authListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function authListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('authListSheet', row);
	}

	// 사용자 선택 팝업
	function showUserList() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/authority/popup/userList.do" />'
			, callbackFunction : function(resultObj){
				$('#userNmId').val(resultObj.maskUserNm + ' (' + resultObj.userId + ')');
				$('#userId').val(resultObj.userId);
				$('#userNm').val(resultObj.userNm);
				getUserInfo();
			}
		});
	}

	// 권한 선택 팝업
	function showAuthList() {
		// 시트의 모든 데이터를 json 객체로 추출
		var jsonData = authListSheet.ExportData({
			'Type' : 'json'
		});

		var exceptIds = jsonData.data.map(function(item){
			return item.authId;
		});

		global.openLayerPopup({
			popupUrl : '<c:url value="/authority/popup/authList.do" />'
			, params : {
				exceptIds : exceptIds ? exceptIds.join(',') : ''
			}
			, callbackFunction : function(returnArray){
				for (var i = 0; i < returnArray.length; i++) {
					// 목록에 없는 권한만 등록시킨다.
					if (
						authListSheet.FindText('systemMenuId', returnArray[i].systemMenuId, 0) == -1
						|| authListSheet.FindText('authId', returnArray[i].authId, 0) == -1
					) {
						// 선택한 권한을 마지막에 입력
						authListSheet.SetRowData(authListSheet.LastRow() + 1, returnArray[i], {Add: 1});
					}
				}
			}
		});
	}

	function isValid() {
		if (isStringEmpty(f.userNm.value)) {
			alert('사용자를 선택해 주세요.');
			f.userNm.focus();

			return false;
		}

		if (isStringEmpty($('input:radio[name="infoCheckYn"]:checked').val())) {
			alert('개인정보 조회 여부를 선택해 주세요.');
			$('input:radio[name="infoCheckYn"]').focus();

			return false;
		}



		for( var i = 1; i <= authListSheet.RowCount(); i++ ){
			if( authListSheet.GetCellValue(i,'status') != 'D' && authListSheet.GetCellValue(i,'systemMenuId') == '86' ){
				fundAuthCnt++;
			}
			if( authListSheet.GetCellValue(i,'status') != 'D' && authListSheet.GetCellValue(i,'systemMenuId') == '87' ){
				awardAuthCnt++;
			}
		}

		if( fundAuthCnt > 0 && $('#fundDeptCd').val() == '' ){
			alert('기금 권한이 있는사용자는 부서정보가 필수입니다.');
			$('#fundDeptCd').focus();
			return false;
		}

		if( awardAuthCnt > 0 && $('#awardDeptCd').val() == '' ){
			alert('포상 권한이 있는사용자는 부서정보가 필수입니다.');
			$('#awardDeptCd').focus();
			return false;
		}

		return true;
	}

	function doSave() {
		if (isValid()) {
			if (confirm('저장 하시겠습니까?')) {

				if( fundAuthCnt == 0 ){
					$('#fundDeptCd').val('');
				}
				if( awardAuthCnt == 0 ){
					$('#awardDeptCd').val('');
				}

				var af = $('#authForm').serializeObject();

				var saveJson = authListSheet.GetSaveJson();



				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});

						af['authList'] = list;
					});
				}

				global.ajax({
					type : 'POST'
					, url : '<c:url value="/authority/grant/saveAuthInfo.do" />'
					, data : JSON.stringify(af)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						goList();
					}
				});
			}
		}
	}

	function goList() {
		lf.action = '<c:url value="/authority/grant/list.do" />';
		lf.target = '_self';
		lf.submit();
	}

</script>