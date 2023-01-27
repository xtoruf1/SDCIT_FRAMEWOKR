<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="commonCodeForm" name="commonCodeForm" method="post" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doRowAdd();" class="btn_sm btn_primary btn_modify_auth">코드추가</button>
		<c:choose>
			<c:when test="${empty resultView.cls}">
				<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doUpdate();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:otherwise>
		</c:choose>
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="contents">
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tr>
			<th>공통코드 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="cls" name="cls" value="${resultView.cls}" class="form_text" maxlength="6" title="공통코드" <c:if test="${not empty resultView.cls}">readonly="readonly"</c:if> />
			</td>
		</tr>
		<tr>
			<th>공통코드명 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="name" name="name" value="${resultView.name}" class="form_text" maxlength="100" title="공통코드명" />
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td>
				<input type="text" id="note" name="note" value="${resultView.note}" class="form_text w100p" maxlength="100" title="비고" />
			</td>
		</tr>
		<tr>
			<th>코드</th>
			<td>
				<div id="codeList" class="sheet"></div>
			</td>
		</tr>
	 </table>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, MinWidth: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 50, MinWidth: 50, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '상세코드', Type: 'Text', SaveName: 'code', Width: 120, MinWidth: 120, Align: 'Center'});
	ibHeader.addHeader({Header: '상세코드명', Type: 'Text', SaveName: 'name', Width: 160, MinWidth: 160, Align: 'Left'});
	ibHeader.addHeader({Header: '단축코드명', Type: 'Text', SaveName: 'abbr', Width: 160, MinWidth: 160, Align: 'Left'});
	ibHeader.addHeader({Header: '순서', Type: 'Text', SaveName: 'ord', Width: 80, MinWidth: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '영문명', Type: 'Text', SaveName: 'eng', Width: 160, MinWidth: 160, Align: 'Left'});
	ibHeader.addHeader({Header: '그룹', Type: 'Text', SaveName: 'grp', Width: 100, MinWidth: 100, Align: 'Left'});
	ibHeader.addHeader({Header: '상태', Type: 'Combo', SaveName: 'codeStatus', Width: 100, MinWidth: 100, Align: 'Center', ComboCode: 'Y|N', ComboText: 'Y|N'});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'note', Width: 385, MinWidth: 385, Align: 'Left'});
	
	ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', ColResize: true, statusColHidden: true, Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.commonCodeForm;
		lf = document.listForm;
		<c:if test="${empty resultView.cls}">
			f.cls.focus();
		</c:if>
		
		var container = $('#codeList')[0];
		createIBSheet2(container, 'codeListSheet', '100%', '100%');
		ibHeader.initSheet('codeListSheet');
		
		getCodeList();
	});
	
	function codeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	}
    }
	
	// 상세 코드목록 가져오기
	function getCodeList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/commonCode/support/detailList.do" />'
			, data : {
				cls : $('#cls').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				codeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function isValid() {
		if (isStringEmpty(f.cls.value)) {
			alert('공통코드를 입력해 주세요.');
			f.cls.focus();
			
			return false;
		}
		
		if (isStringEmpty(f.name.value)) {
			alert('공통코드명을 입력해 주세요.');
			f.name.focus();
			
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
		var isNameValid = true;
		
		if (saveJson.data.length) {
			var duplicate = new Array();
			
			$.each(saveJson, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					// 삭제는 삭제 대상이기 때문에 유효성을 체크하지 않는다.
					if (value2.status == 'I' || value2.status == 'U') {
						if (isStringEmpty(value2.code)) {
							isCodeValid = false;
						}
						
						if (isStringEmpty(value2.name)) {
							isNameValid = false;
						}
					}
					
					duplicate.push(value2.code);
				});
			});
			
			for (var i = 0; i < duplicate.length - 1; i++) {
				var dupCheck = jQuery.inArray(duplicate[i], duplicate, i + 1);
				
				if (dupCheck >= 0) {
					alert('중복된 공통코드가 존재합니다. 다시 입력해 주세요.');
					
					return false;
				}
			}
		}
		
		if (!isCodeValid) {
			alert('상세코드를 입력해 주세요.');
			
			return false;
		}
		
		if (!isNameValid) {
			alert('상세코드명을 입력해 주세요.');
			
			return false;
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('해당 공통코드를 등록하시겠습니까?')) {
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
					, url : '<c:url value="/commonCode/support/insert.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							alert('공통코드를 등록하였습니다.');
							goList();	
						} else {
							alert(data.message);
						}
					}
				});
			}
		}
	}
	
	function doUpdate() {
		if (isValid()) {
			if (confirm('해당 공통코드를 수정하시겠습니까?')) {
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
					, url : '<c:url value="/commonCode/support/update.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						alert('공통코드를 수정하였습니다.');
						goList();
					}
				});
			}
		}					
	}
	
	function goList() {
		lf.action = '<c:url value="/commonCode/support/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
	
	// 코드 목록에 행 추가
	function doRowAdd() {
		var index = codeListSheet.DataInsert(-1);
	}
	
	function goPortalPage() {
		location.href = '<c:url value="/commonCode/portal/list.do" />';
	}
	
	function goServicePage() {
		location.href = '<c:url value="/commonCode/service/list.do" />';
	}
	
	function goSupportPage() {
		location.href = '<c:url value="/commonCode/support/list.do" />';
	}
	
	function goCounselPage() {
		location.href = '<c:url value="/commonCode/counsel/list.do" />';
	}
</script>