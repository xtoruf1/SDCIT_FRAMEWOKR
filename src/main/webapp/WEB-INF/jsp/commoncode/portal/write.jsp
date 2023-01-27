<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchClCode" value="${param.searchClCode}" />
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
			<c:when test="${empty resultView.codeId}">
				<button type="button" onclick="doInsert();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="doUpdate();" class="btn_sm btn_primary btn_modify_auth">저장</button>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="ml-15">
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
			<th>공통분류코드 <strong class="point">*</strong></th>
			<td>
				<select id="clCode" name="clCode" class="form_select" style="width: 270px;">
					<option value="" <c:if test="${empty resultView.clCode or resultView.clCode eq ''}">selected="selected"</c:if>>선택</option>
					<c:forEach var="item" items="${classCodeList}" varStatus="status">
						<option value="${item.clCode}" <c:if test="${resultView.clCode eq item.clCode}">selected="selected"</c:if>>${item.clCodeNm}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>공통코드 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="codeId" name="codeId" value="${resultView.codeId}" class="form_text" maxlength="6" title="공통코드" <c:if test="${not empty resultView.codeId}">readonly="readonly"</c:if> />
			</td>
		</tr>
		<tr>
			<th>공통코드명 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="codeIdNm" name="codeIdNm" value="${resultView.codeIdNm}" class="form_text" maxlength="100" title="공통코드명" />
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td>
				<input type="text" id="codeIdDc" name="codeIdDc" value="${resultView.codeIdDc}" class="form_text w100p" maxlength="100" title="비고" />
			</td>
		</tr>
		<tr>
			<th>사용여부 <strong class="point">*</strong></th>
			<td>
				<select id="useAt" name="useAt" class="form_select" title="사용여부">
					<option value="Y" <c:if test="${resultView.useAt eq 'Y'}">selected="selected"</c:if>>사용</option>
					<option value="N" <c:if test="${resultView.useAt eq 'N'}">selected="selected"</c:if>>미사용</option>
				</select>
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
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '새행삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 30, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '코드', Type: 'Text', SaveName: 'code', Width: 60, Align: 'Center', Edit: 0, EditLen: 15});
	ibHeader.addHeader({Header: '코드명', Type: 'Text', SaveName: 'codeNm', Width: 80, Align: 'Left', EditLen: 20});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'codeDc', Width: 160, Align: 'Left', EditLen: 60});
	ibHeader.addHeader({Header: '사용여부', Type: 'Combo', SaveName: 'useAt', Width: 40, Align: 'Center', ComboCode: 'Y|N', ComboText: '사용|미사용'});
	
	ibHeader.addHeader({Header: '코드아이디', Type: 'Text', SaveName: 'codeId', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MergeSheet: 5, ChildPage: 10, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.commonCodeForm;
		lf = document.listForm;
		<c:if test="${empty resultView.codeId}">
			f.codeId.focus();
		</c:if>
		
		var container = $('#codeList')[0];
		createIBSheet2(container, 'codeListSheet', '100%', '100%');
		ibHeader.initSheet('codeListSheet');
		
		getCodeList();
	});
	
	// 상세 코드목록 가져오기
	function getCodeList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/commonCode/portal/detailList.do" />'
			, data : {
				codeId : $('#codeId').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				codeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	function codeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	}
    }
	
	function codeListSheet_OnRowSearchEnd(row) {
		codeListSheet.SetCellEditable(row, 'delFlag', 0);
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('codeListSheet', row);
	}
	
	function isValid() {
		var clCode = $('select[name="clCode"] option:selected');
		
		if (isStringEmpty(clCode.val())) {
			alert('공통분류코드를 선택해 주세요.');
			clCode.focus();
			
			return false;
		}
		
		if (isStringEmpty(f.codeId.value)) {
			alert('공통코드를 입력해 주세요.');
			f.codeId.focus();
			
			return false;
		}
		
		if (isStringEmpty(f.codeIdNm.value)) {
			alert('공통코드명을 입력해 주세요.');
			f.codeIdNm.focus();
			
			return false;
		}
		
		var useAt = $('select[name="useAt"] option:selected');
		
		if (isStringEmpty(useAt.val())) {
			alert('사용여부를 선택해 주세요.');
			useAt.focus();
			
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
						
						if (isStringEmpty(value2.codeNm)) {
							isNameValid = false;
						}
					}
					
					duplicate.push(value2.code);
				});
			});
			
			for (var i = 0; i < duplicate.length - 1; i++) {
				var dupCheck = jQuery.inArray(duplicate[i], duplicate, i + 1);
				
				if (dupCheck >= 0) {
					alert('중복된 코드가 존재합니다. 다시 입력해 주세요.');
					
					return false;
				}
			}
		}
		
		if (!isCodeValid) {
			alert('코드를 입력해 주세요.');
			
			return false;
		}
		
		if (!isNameValid) {
			alert('코드명을 입력해 주세요.');
			
			return false;
		}
		
		return true;
	}
	
	function doInsert() {
		if (isValid()) {
			if (confirm('저장 하시겠습니까?')) {
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
					, url : '<c:url value="/commonCode/portal/insert.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
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
			if (confirm('저장 하시겠습니까?')) {
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
					, url : '<c:url value="/commonCode/portal/update.do" />'
					, data : JSON.stringify(ccf)
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
		lf.action = '<c:url value="/commonCode/portal/list.do" />';
		lf.target = '_self';
		lf.submit();
	}
	
	// 코드 목록에 행 추가
	function doRowAdd() {
		var index = codeListSheet.DataInsert(-1);
		// 편집을 할수 있도록 변경
		codeListSheet.SetCellEditable(index, 'code', 1);
		// 편집시 컬럼 색깔 변경
		codeListSheet.SetCellBackColor(index, 'code', '#ffffff');
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