<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="memberForm" name="memberForm" method="get" onsubmit="return false;">
<input type="hidden" id="memberSeq" name="memberSeq" value="0" />
<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<h2>사용자관리</h2>
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
							<option value="memberNm" <c:if test="${param.searchCondition eq 'memberNm'}">selected="selected"</c:if>>이름</option>
							<option value="loginId" <c:if test="${param.searchCondition eq 'loginId'}">selected="selected"</c:if>>아이디</option>
						</select>
						<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="textType" style="width: 200px;" title="검색어" />
						<a href="javascript:doSearch();" class="ui-button ui-widget ui-corner-all">검색</a>
					</fieldset>					
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<hr />
<div id="totalCnt" style="text-align: right;margin-bottom: 5px;font-size: 13px;font-weight: bold;"></div>
<div style="width: 100%;height: 100%;">
	<div id="memberList" class="sheet"></div>
</div>
<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
<div class="widget btn right" style="margin-top: 0px;">
	<a href="javascript:goWrite();" class="ui-button ui-widget ui-corner-all">등록</a>
</div>
</form>
<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '번호', Type: 'Text', SaveName: 'pageSeq', Width: 20, Align: 'Center'});
	ibHeader.addHeader({Header: '아이디', Type: 'Text', SaveName: 'loginId', Width: 65, Align: 'Center', FontColor: 'blue'});
	ibHeader.addHeader({Header: '이름', Type: 'Text', SaveName: 'memberNm', Width: 65, Align: 'Center'});
	ibHeader.addHeader({Header: '타입', Type: 'Text', SaveName: 'memberType', Width: 40, Align: 'Center'});
	ibHeader.addHeader({Header: '이메일', Type: 'Text', SaveName: 'email', Width: 75, Align: 'Left'});
	ibHeader.addHeader({Header: '휴대폰', Type: 'Text', SaveName: 'hpTel', Width: 75, Align: 'Center'});
	ibHeader.addHeader({Header: '부서명', Type: 'Text', SaveName: 'deptNm', Width: 70, Align: 'Center'});
	ibHeader.addHeader({Header: '로그인 일시', Type: 'Text', SaveName: 'loginDate', Width: 70, Align: 'Center'});
	ibHeader.addHeader({Header: '등록일', Type: 'Text', SaveName: 'regDate', Width: 70, Align: 'Center'});
	
	ibHeader.addHeader({Header: '사용자시퀀스', Type: 'Text', SaveName: 'memberSeq', Hidden: true});
	
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.memberForm;
		
		var container = $('#memberList')[0];
		createIBSheet2(container, 'memberListSheet', '100%', '100%');
		ibHeader.initSheet('memberListSheet');
		
		getList();
	});
	
	function memberListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('memberListSheet_OnSearchEnd : ', msg);
    	} else {
    		memberListSheet.SetEllipsis(1);
    		memberListSheet.SetDataBackColor('#ffffff');
    		memberListSheet.SetMouseHoverMode(0);
    		memberListSheet.SetMousePointer('hand');
    	}
    }
	
	function memberListSheet_OnRowSearchEnd(row) {
		var memberType = memberListSheet.GetCellValue(row, 'memberType');
		memberListSheet.SetCellValue(row , 'memberType', memberType == 'A' ? '슈퍼관리자' : '일반사용자');
	}
	
	function memberListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (memberListSheet.ColSaveName(col) == 'loginId') {
				var memberSeq = memberListSheet.GetCellValue(row, 'memberSeq');
				
				goView(memberSeq);
		    }	
		}
	}
	
	function doSearch() {
		goPage(1);
	}
	
	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}
	
	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/member/selectList.do" />'
			, data : $('#memberForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span style="color: orange;">' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				memberListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}
	
	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/member/write.do" />';
		f.memberSeq.value = '0';
		f.target = '_self';
		f.submit();
	}
	
	// 조회화면
	function goView(memberSeq) {
		f.action = '<c:url value="/member/write.do" />';
		f.memberSeq.value = memberSeq;
		f.target = '_self';
		f.submit();
	}
</script>