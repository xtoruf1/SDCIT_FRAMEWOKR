<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
</div>
<div class="cont_block mt-20">
	<div style="width: 100%;height: 100%;">
		<div id="recruitList" class="sheet"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '분야', Type: 'Text', SaveName: 'consultTypeNm', Width: 500, Align: 'Center', Edit: false});
	ibHeader.addHeader({Header: '모집여부', Type: 'CheckBox', SaveName: 'useYn', Width: 200, Align: 'Center', ItemCode: 'Y|N', ItemText: '모집중|모집안함', MaxCheck: 1, RadioIcon: 1, Edit: true});

	ibHeader.addHeader({Header: '분야코드', Type: 'Text', SaveName: 'consultTypeCd', Width: 500, Align: 'Left', Hidden: true});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		var container = $('#recruitList')[0];
		createIBSheet2(container, 'recruitListSheet', '100%', '100%');
		ibHeader.initSheet('recruitListSheet');
		recruitListSheet.SetSelectionMode(4);

		getList();
	});

	function getList() {
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/expertsRecruitmentAjax.do" />'
			, dataType : 'json'
			, type : 'POST'
			, async : true
			, spinner : true
			, success : function(data){
				recruitListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function recruitListSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('recruitListSheet', row);
	}

	function doSave() {
		var result = recruitListSheet.GetSaveJson();
		var recruitList = result['data'];

		var paramList = [];
		if (recruitList.length > 0) {
			recruitList.forEach(function(item){
				var useYnItems = item['useYn'].split('|');
				useYnItems.forEach(function(useYnItem){
					if (useYnItem.split(':')[1] == 1) {
						paramList.push({
							consultTypeCd : item['consultTypeCd']
							, useYn : useYnItem.split(':')[0]
						});

						return false;
					}
				});
			});
		}

		if (confirm('수정 하시겠습니까?')) {
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/expertsRecruitmentProc.do" />'
				, dataType : 'json'
				, contentType : 'application/json'
				, type : 'POST'
				, data : JSON.stringify({
					expertList : paramList
				})
				, async : true
				, spinner : true
				, success : function(data){
					getList();
				}
			});
		}
	}
</script>