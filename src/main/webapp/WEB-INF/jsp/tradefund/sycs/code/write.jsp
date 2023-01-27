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
<input type="hidden" name="acctTypeId" value="${param.acctTypeId}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="commonCodeForm" name="commonCodeForm" method="post" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doRowAdd();" class="btn_sm btn_primary btn_modify_auth">코드추가</button>
		<c:choose>
			<c:when test="${empty resultView.basecd}">
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
			<col style="width: 10%;" />
			<col />
			<col style="width: 10%;" />
			<col />
			<col style="width: 10%;" />
			<col />
		</colgroup>
		<tr>
			<th>코드구분 <strong class="point">*</strong></th>
			<td>
				<select name="acctTypeId" class="form_select" id="acctTypeId">
					<c:forEach var="list" items="${com000}" varStatus="status">
						<option value="${list.code}"<c:if test="${resultView.acctTypeId == list.code}"> selected</c:if>>${list.codenm}</option>
					</c:forEach>
				</select>
			</td>
			<th>코드 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="basecd" name="basecd" value="${resultView.basecd}" class="form_text" maxlength="6" title="코드" <c:if test="${not empty resultView.basecd}">readonly="readonly"</c:if> />
			</td>
			<th>코드명 <strong class="point">*</strong></th>
			<td>
				<input type="text" id="basenm" name="basenm" value="${resultView.basenm}" class="form_text" maxlength="100" title="코드명" />
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td  colspan="5">
				<input type="text" id="remark" name="remark" value="${resultView.remark}" class="form_text w100p" maxlength="100" title="비고" />
			</td>
		</tr>
		<tr>
			<th>상세코드</th>
			<td colspan="5">
				<div id="codeList" class="sheet"></div>
			</td>
		</tr>
	 </table>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, MinWidth: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '새행삭제', Type: 'DelCheck', SaveName: 'delFlag', Width: 70, MinWidth: 70, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '번호', Type: 'Text', SaveName: 'sortNo', Width: 80, MinWidth: 80, Align: 'Center', Edit: 0});
	ibHeader.addHeader({Header: '상세코드', Type: 'Text', SaveName: 'detailcd', Width: 120, MinWidth: 120, Align: 'Left', Edit: 0, EditLen: 10});
	ibHeader.addHeader({Header: '상세코드명', Type: 'Text', SaveName: 'detailnm', Width: 120, MinWidth: 120, Align: 'Left', EditLen: 30});
	ibHeader.addHeader({Header: '단축코드명', Type: 'Text', SaveName: 'detailsortnm', Width: 120, MinWidth: 120, Align: 'Left', EditLen: 10});
	ibHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'remark', Width: 200, MinWidth: 200, Align: 'Left', EditLen: 100});

	for (var i = 1; i <= 20; i++) {
		var index = i > 9 ? i : '0' + i;
		ibHeader.addHeader({Header: 'Changed Code' + index, Type: 'Text', SaveName: 'chgCode' + index, Width: 150, MinWidth: 150, Align: 'Left', EditLen: 10});
	}

	ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', ColResize: true, statusColHidden: true, Page: 10, SearchMode: 2, UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false, FrozenCol: 0, DeferredVScroll: true, ToolTip: true, Ellipsis: true, SizeMode: 1, NoFocusMode: 0, Alternate: 0, HeaderCheckSync: 1, DragMode: -1, MaxSort: 1});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	var lf;
	$(document).ready(function(){
		f = document.commonCodeForm;
		lf = document.listForm;
		<c:if test="${empty resultView.basecd}">
			f.basecd.focus();
		</c:if>

		var container = $('#codeList')[0];
		createIBSheet2(container, 'codeListSheet', '100%', '100%');
		ibHeader.initSheet('codeListSheet');
		codeListSheet.SetFrozenCol(5);

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
			, url : '<c:url value="/tmscommon/code/detailList.do" />'
			, data : {
				basecd : $('#basecd').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				codeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function codeListSheet_OnRowSearchEnd(row) {
		codeListSheet.SetCellEditable(row, 'delFlag', 0);
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('codeListSheet', row);
	}

	function isValid() {
		if (isStringEmpty(f.basecd.value)) {
			alert('공통코드를 입력해 주세요.');
			f.basecd.focus();

			return false;
		}

		if (isStringEmpty(f.basenm.value)) {
			alert('공통코드명을 입력해 주세요.');
			f.basenm.focus();

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
						if (isStringEmpty(value2.detailcd)) {
							isCodeValid = false;
						}

						if (isStringEmpty(value2.detailnm)) {
							isNameValid = false;
						}
					}

					duplicate.push(value2.detailcd);
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
					, url : '<c:url value="/tmscommon/code/insert.do" />'
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
					, url : '<c:url value="/tmscommon/code/update.do" />'
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
		lf.action = '<c:url value="/tmscommon/code/list.do" />';
		lf.target = '_self';
		lf.submit();
	}

	// 코드 목록에 행 추가
    function doRowAdd() {
		var index = codeListSheet.DataInsert(-1);
		// 편집을 할수 있도록 변경
		codeListSheet.SetCellEditable(index, 'sortNo', 1);
		// 편집시 컬럼 색깔 변경
		codeListSheet.SetCellBackColor(index, 'sortNo', '#ffffff');
		// 편집을 할수 있도록 변경
		codeListSheet.SetCellEditable(index, 'detailcd', 1);
		// 편집시 컬럼 색깔 변경
		codeListSheet.SetCellBackColor(index, 'detailcd', '#ffffff');
   }
</script>