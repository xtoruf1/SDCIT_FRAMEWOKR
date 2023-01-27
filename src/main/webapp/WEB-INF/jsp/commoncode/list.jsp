<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="commonCodeForm" name="commonCodeForm" method="get" onsubmit="return false;">
<h2>공통코드관리</h2>
<!--검색 시작 -->
<div class="search">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
		<colgroup>
			<col width="10%" />
			<col width="90%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">검색</th>
				<td colspan="3">
					<fieldset class="widget">
						<select id="searchCondition" name="searchCondition" class="jquerySelectbox" style="width: 30%;">
							<option value="" <c:if test="${empty param.searchCondition or param.searchCondition eq ''}">selected="selected"</c:if>>::: 전체 :::</option>
							<option value="codeId" <c:if test="${param.searchCondition eq 'codeId'}">selected="selected"</c:if>>그룹코드</option>
							<option value="codeNm" <c:if test="${param.searchCondition eq 'codeNm'}">selected="selected"</c:if>>그룹코드명</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="textType" style="width: 200px;" title="검색어" />
						<a href="javascript:doSearch();" class="ui-button ui-widget ui-corner-all">검색</a>
						<a href="javascript:doInit();" class="ui-button ui-widget ui-corner-all">초기화</a>
					</fieldset>					
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div style="display: flex;justify-content: space-between;">
	<div style="width: 22%;height: 100%;">
		<div>▶ 공통코드그룹</div>
		<div style="margin-top: -6px;">
			<div id="totalCnt" style="text-align: right;margin-bottom: 5px;font-size: 13px;font-weight: bold;"></div>
			<div id="codeGroupList" class="sheet" style="margin-top: 10px;"></div>
		</div>
	</div>
	<div style="width: 77%;height: 100%;">
		<div style="display: flex;flex-direction: column;">
			<div>▶ 코드그룹</div>
			<div class="widget btn right" style="margin-top: -17px;">
				<a href="javascript:goWrite();" class="ui-button ui-widget ui-corner-all">추가</a>
				<a href="javascript:doSave();" class="ui-button ui-widget ui-corner-all">저장</a>
				<a href="javascript:doDelete();" class="ui-button ui-widget ui-corner-all">삭제</a>
				<a href="javascript:doCacheInit();" class="ui-button ui-widget ui-corner-all">캐시 초기화</a>
			</div>
			<div style="height: 30%;margin-top: 10px;border: 1px solid #ccc;">
				<div id="codeView" style="margin: 10px;">
					<div><font color="red"><b>◎</b></font> 는 필수 입력입니다.</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="boardwrite">
						<caption>등록/수정화면</caption>
						<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 그룹코드</th>
								<td>
									<input type="text" id="codeId" name="codeId" value="" class="textType" style="width: 50%;" />
								</td>
								<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 그룹코드명</th>
								<td>
									<input type="text" id="codeNm" name="codeNm" value="" class="textType" style="width: 50%;" />
								</td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 코드그룹</th>
								<td>
									<select id="groupId" name="groupId" class="jquerySelectbox">
										<option value="">::: 선택 :::</option>
										<c:forEach var="item" items="${group}" varStatus="status">
											<option value="${item.groupId}">${item.groupNm}</option>
										</c:forEach>
									</select>
								</td>
								<th scope="row" style="text-align: left;padding-left: 20px;"><font color="red">◎</font> 사용여부</th>
								<td>
									<select id="useYn" name="useYn" class="jquerySelectbox">
										<option value="">::: 선택 :::</option>
										<option value="Y">사용</option>
										<option value="N">사용 안함</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row" style="text-align: left;padding-left: 20px;">코드설명</th>
								<td colspan="3">
									<textarea id="codeDesc" name="codeDesc" rows="5"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div style="margin-top: 10px;">▶ 상세코드</div>
			<div class="widget btn right" style="margin-top: -17px;">
				<a href="javascript:doRowAdd();" class="ui-button ui-widget ui-corner-all">추가</a>
			</div>
			<div style="min-height: 400px;margin-top: 10px;border: 1px solid #ccc;">
				<div id="codeList" style="margin: 10px;"></div>
			</div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	var	ibGroupHeader = new IBHeader();
	ibGroupHeader.addHeader({Header: '그룹코드', Type: 'Text', SaveName: 'codeId', Align: 'Left', MinWidth: 110, Edit: 0});
	ibGroupHeader.addHeader({Header: '그룹코드명', Type: 'Text', SaveName: 'codeNm', Align: 'Left', MinWidth: 130, Edit: 0});
	
	ibGroupHeader.addHeader({Header: '코드그룹', Type: 'Text', SaveName: 'groupId', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '상세코드', Type: 'Text', SaveName: 'code', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '코드설명', Type: 'Text', SaveName: 'codeDesc', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '사용여부', Type: 'Text', SaveName: 'useYn', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '정렬순서', Type: 'Text', SaveName: 'codeSort', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '속성1', Type: 'Text', SaveName: 'attr1', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '속성2', Type: 'Text', SaveName: 'attr2', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '속성3', Type: 'Text', SaveName: 'attr3', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '속성4', Type: 'Text', SaveName: 'attr4', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '속성5', Type: 'Text', SaveName: 'attr5', Align: 'Center', Hidden : true});
	ibGroupHeader.addHeader({Header: '뎁스', Type: 'Text', SaveName: 'level', Align: 'Center', Hidden : true});
	
	ibGroupHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 4, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibGroupHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
	
	var	ibCodeHeader = new IBHeader();
	ibCodeHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 30, Align: 'Center', Hidden : true});
	ibCodeHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 30, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '코드', Type: 'Text', SaveName: 'code', Width: 90, Align: 'Center', Edit: 0});
	ibCodeHeader.addHeader({Header: '코드명', Type: 'Text', SaveName: 'codeNm', Width: 90, Align: 'Left'});
	ibCodeHeader.addHeader({Header: '코드설명', Type: 'Text', SaveName: 'codeDesc', Width: 120, Align: 'Left'});
	ibCodeHeader.addHeader({Header: '사용여부', Type: 'Combo', SaveName: 'useYn', Width: 50, Align: 'Center', ComboCode: 'Y|N', ComboText: '사용|사용 안함'});
	ibCodeHeader.addHeader({Header: '정렬순서', Type: 'Text', SaveName: 'codeSort', Width: 50, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '속성1', Type: 'Text', SaveName: 'attr1', Width: 50, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '속성2', Type: 'Text', SaveName: 'attr2', Width: 50, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '속성3', Type: 'Text', SaveName: 'attr3', Width: 50, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '속성4', Type: 'Text', SaveName: 'attr4', Width: 50, Align: 'Center'});
	ibCodeHeader.addHeader({Header: '속성5', Type: 'Text', SaveName: 'attr5', Width: 50, Align: 'Center'});
	
	ibCodeHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibCodeHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
		
	var f;
	var treeObj;
	$(document).ready(function(){
		f = document.commonCodeForm;
		
		var codeGroupContainer = $('#codeGroupList')[0];
        createIBSheet2(codeGroupContainer, 'codeGroupListSheet', '100%', '750px');
        ibGroupHeader.initSheet('codeGroupListSheet');
        codeGroupListSheet.SetWaitImageVisible(0);
		
		// 그룹코드 목록 가져오기
		getGroupList();
        
        var codeContainer = $('#codeList')[0];
		createIBSheet2(codeContainer, 'codeListSheet', '98%', '100%');
		ibCodeHeader.initSheet('codeListSheet');
		codeListSheet.SetWaitImageVisible(0);
		codeListSheet.SetVisible(0);
	});
	
	// 검색
	function doSearch() {
		getGroupList();
	}
	
	// 초기화
	function doInit() {
		$('select[name="searchCondition"] option:selected').val('')
		$('#searchKeyword').val('');
		
		getGroupList();
		goWrite();
	}
	
	// 그룹코드 목록 가져오기
	function getGroupList() {
		codeGroupListSheet.DoSearch('<c:url value="/commonCode/selectGroupList.do" />', {
			searchCondition: $('select[name="searchCondition"] option:selected').val()
			, searchKeyword: f.searchKeyword.value
		});
	}
	
	function codeGroupListSheet_OnLoadData(data) {
		var jsonData = treeObj = $.parseJSON(data);
		
		var newObj = {};
		
		// 객체에 새로 할당뒤 레벨 1단계만 필터링
		newObj = Object.assign(newObj, jsonData);
		newObj.data = newObj.data.filter(function(element){ 
			return element.level == 1;
		});
		
		$('#totalCnt').html('총 <span style="color: orange;">' + global.formatCurrency(newObj.data.length) + '</span> 건');
		
		return newObj;
    }
	
	function codeGroupListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('codeGroupListSheet_OnSearchEnd : ', msg);
		} else {
			$('#codeGroupList').height('100%');
			codeGroupListSheet.SetDataBackColor('#ffffff');
			codeGroupListSheet.SetMouseHoverMode(2);
			codeGroupListSheet.SetMousePointer('hand');
		}
	}
	
	function codeGroupListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (
			codeGroupListSheet.ColSaveName(col) == 'codeId'
			|| codeGroupListSheet.ColSaveName(col) == 'codeNm'
		) {
			getGroupView(row);
		}
   	}
	
	// 코드 보기
	function getGroupView(data) {
		if (data) {
			var codeId = codeGroupListSheet.GetCellValue(data, 'codeId');
			var codeNm = codeGroupListSheet.GetCellValue(data, 'codeNm');
			var groupId = codeGroupListSheet.GetCellValue(data, 'groupId');
			var useYn = codeGroupListSheet.GetCellValue(data, 'useYn');
			var codeDesc = codeGroupListSheet.GetCellValue(data, 'codeDesc');
			
			$('#codeId').val(codeId);
			$('#codeId').attr('readonly', true);
			
			$('#codeNm').val(codeNm);
			
			$('#groupId').val(groupId).attr('selected', 'selected');
			$('#useYn').val(useYn).attr('selected', 'selected');
			// 셀렉트 박스 값을 갱신
			$('.jquerySelectbox').selectmenu('refresh');
			
			$('#codeDesc').val(codeDesc);
			
			// 상세코드 목록
			getCodeList(codeId);
		}
	}
	
	function getCodeList(codeId) {
		if (treeObj) {
			var newObj = {};
			
			// 객체에 새로 할당뒤 해당 그룹코드의 레벨 2단계만 필터링
			newObj = Object.assign(newObj, treeObj);
			newObj.data = newObj.data.filter(function(element){ 
				return element.codeId == codeId && element.level == 2; 
			});
			
			codeListSheet.LoadSearchData(newObj);
			codeListSheet.SetDataBackColor('#ffffff');
			codeListSheet.SetMouseHoverMode(2);
			codeListSheet.SetClipPasteMode(2);
			codeListSheet.SetVisible(1);
		}
	}
	
	function goWrite() {
		$('#codeId').val('');
		$('#codeId').attr('readonly', false);
		
		$('#codeNm').val('');
		
		$('#groupId').val('').attr('selected', 'selected');
		$('#useYn').val('').attr('selected', 'selected');
		// 셀렉트 박스 값을 갱신
		$('.jquerySelectbox').selectmenu('refresh');
		
		$('#codeDesc').val('');
		
		codeListSheet.SetVisible(0);
	}
	
	function isValid() {
		if (isStringEmpty(f.codeId.value)) {
			alert('그룹코드를 입력해 주세요.');
			f.codeId.focus();
			
			return false;
		}
	
		if (isStringEmpty(f.codeNm.value)) {
			alert('그룹코드명를 입력해 주세요.');
			f.codeNm.focus();
			
			return false;
		}
		
		var groupId = $('select[name="groupId"] option:selected');
		
		if (isStringEmpty(groupId.val())) {
			alert('코드그룹을 선택해 주세요.');
			groupId.focus();
			
			return false;
		}
		
		var useYn = $('select[name="useYn"] option:selected');
		
		if (isStringEmpty(useYn.val())) {
			alert('사용여부를 선택해 주세요.');
			useYn.focus();
			
			return false;
		}
		
		var saveJson = codeListSheet.GetSaveJson();
		
		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}
		
		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}
		
		var isCodeValid = true;
		var isNmValid = true;
		var isSortValid = true;
		
		if (saveJson.data.length) {
			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.code)) {
							isCodeValid = false;
						}
						
						if (isStringEmpty(value2.codeNm)) {
							isNmValid = false;
						}
						
						if (isStringEmpty(value2.codeSort)) {
							isSortValid = false;
						}
					}
				});
			});
		}
		
		if (!isCodeValid) {
			alert('코드를 입력해 주세요.');
			
			return false;
		}
		
		if (!isNmValid) {
			alert('코드명을 입력해 주세요.');
			
			return false;
		}
		
		if (!isSortValid) {
			alert('정렬순서를 입력해 주세요.');
			
			return false;
		}
		
		return true;
	}
	
	function doSave() {
		if (isValid()) {
			if (confirm('코드 정보를 저장하시겠습니까?')) {
				var ccf = $('#commonCodeForm').serializeObject();
				
				var saveJson = codeListSheet.GetSaveJson();
				
				if (saveJson.data.length) {
					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});
						
						ccf['codeList'] = list;
					});
				}
				
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/commonCode/saveGroupCode.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('코드 정보를 저장하였습니다.');
						doInit();
					}
				});
			}
		}
	}
	
	function doDelete() {
		if (codeListSheet.GetVisible()) {
			if (confirm('그룹코드 정보를 삭제하시겠습니까? (※ 코드정보까지 삭제됩니다.)')) {
				global.ajax({
					type : 'POST'
					, url : '<c:url value="/commonCode/deleteGroupCode.do" />'
					, data : {
						codeId : f.codeId.value
					}
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){
						alert('코드 정보를 삭제하였습니다.');
						doInit();
					}
				});
			}	
		} else {
			alert('삭제할 그룹코드를 선택해 주세요.');
		}
	}
	
	// 코드 목록에 행 추가
	function doRowAdd() {
		var index = codeListSheet.DataInsert(-1);
		// 편집을 할수 있도록 변경
		codeListSheet.SetCellEditable(index, 'code', 1);
	}
	
	function doCacheInit() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/commonCode/initCommonCodeList.do" />'
			, data : {}
			, dataType : 'json'
			, async : true
			, success : function(data) {
				alert('초기화 하였습니다.');
			}
		});
	}
</script>