<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="menuForm" name="menuForm" method="get" onsubmit="return false;">
<input type="hidden" id="menuSeq" name="menuSeq" value="${param.menuSeq}" />
<input type="hidden" id="depth" name="depth" value="${param.depth}" />
<h2>메뉴순서 변경</h2>
<div class="widget btn right" style="margin-top: 0px;">
	<a href="javascript:doSave();" class="ui-button ui-widget ui-corner-all">저장</a>
	<a href="javascript:doClose();" class="ui-button ui-widget ui-corner-all">닫기</a>
</div>
<br />
<div style="width: 100%;height: 100%;border-top: 1px solid #8b8ba2;">
	<div style="width: 530px;height: 300px;border: 1px solid #ddd;background-color: #eee;padding: 10px;position: relative;">
		<select id="menuSort" name="menuSort" size="10" style="width: 400px;height: 100%;font-size: 14px;">
			<c:forEach var="item" items="${resultList}" varStatus="status">
				<option value="${item.menuSeq}">${item.menuNm}</option>
			</c:forEach>
		</select>
		<div style="position: absolute;top: 110px;right: 43px;">
			<button type="button" onclick="doMenuSortUp();" style="margin-bottom: 5px;width: 32px;height: 32px;border: 1px solid #bbb;border-radius: 2px;background: url(<c:url value="/images/icon/icon_uparrow.png" />) no-repeat center;background-color: #fff;"></button>
			<br />
			<button type="button" onclick="doMenuSortDown();" style="width: 32px;height: 32px;border: 1px solid #bbb;border-radius: 2px;background: url(<c:url value="/images/icon/icon_downarrow.png" />) no-repeat center;background-color: #fff;"></button>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	var f;
	$(document).ready(function(){
		f = document.menuForm;		
		$('#column_popup').css('min-height', '300px');
	});
	
	// 메뉴를 위로 이동
	function doMenuSortUp() {
		moveUpOption(f.menuSort);
	}
	
	// 메뉴를 아래로 이동
	function doMenuSortDown() {
		moveDownOption(f.menuSort);
	}
	
	function doSave() {
		if (confirm('메뉴 정렬순서를 변경하시겠습니까?')) {
			var obj = f.menuSort;
			
			var sortList = [];
			if (obj.options.length == null) {
				sortList.push(obj.options.value);
			} else {
				for (var i = 0; i < obj.options.length; i++) {
					sortList.push(obj.options[i].value);
				}
			}
			
			var mf = $('#menuForm').serializeObject();
			
			mf['menuSeqList'] = sortList;
			
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/menu/updateMenuSort.do" />'
				, data : JSON.stringify(mf)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					alert('메뉴 정렬순서를 변경하였습니다.');
					window.close();
					
					opener.getList();
				}
			});
		}
	}
	
	// 팝업창 닫기
	function doClose() {
		window.close();
	}
</script>