<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="programForm" name="programForm" method="get" onsubmit="return false;">
<input type="hidden" name="pgmId" value="0" />
<div class="modal-content">
	<div class="popContinent">
		<h2 style="margin: 0px;">프로그램 목록</h2>
		<!--검색 시작 -->
		<div class="search" style="margin: 15px;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
				<colgroup>
					<col width="10%" />
					<col width="40%" />
					<col width="10%" />
					<col width="40%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">프로그램명 / URL</th>
						<td>
							<fieldset class="widget">
								<input type="text" name="searchPgmName" value="" onkeydown="onEnter(doProgramSearch);" class="textType" style="width: 70%;" title="프로그램명 / URL" />
							</fieldset>					
						</td>
						<th scope="row">비고</th>
						<td>
							<fieldset class="widget">
								<input type="text" name="searchDscr" value="" onkeydown="onEnter(doProgramSearch);" class="textType" style="width: 70%;" title="URL" />
							</fieldset>					
						</td>
		            </tr>
				</tbody>
			</table>
		</div>
		<!--검색 끝 -->
		<section class="scroll mCustomScrollbar _mCS_16 mCS-autoHide">
			<div id="mCSB_16" class="mCustomScrollBox mCS-minimal mCSB_vertical mCSB_outside" style="width: 100%;height: 700px;">
				<div id="programList" class="mCSB_container sheet" style="margin: 15px;"></div>
			</div>
		</section>
	</div>
	<button type="button" onclick="closePopup();" class="btnClose" style="border: 0px;">닫기</button>
</div>
<div class="overlay"></div>
</form>
<script type="text/javascript">
	var	ibProgramHeader = new IBHeader();
	ibProgramHeader.addHeader({Header: '번호', Type: 'Text', SaveName: 'pageSeq', Width: 30, Align: 'Center'});
	ibProgramHeader.addHeader({Header: '프로그램명', Type: 'Text', SaveName: 'pgmName', Width: 80, Align: 'Left', FontColor: 'blue'});
	ibProgramHeader.addHeader({Header: 'URL', Type: 'Text', SaveName: 'url', Width: 130, Align: 'Left'});
	ibProgramHeader.addHeader({Header: '비고', Type: 'Text', SaveName: 'dscr', Width: 180, Align: 'Left'});
	ibProgramHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'creDate', Width: 60, Align: 'Center'});
	
	ibProgramHeader.addHeader({Header: '프로그램 시퀀스', Type: 'Text', SaveName: 'pgmId', Hidden: true});
	
	ibProgramHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibProgramHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var pf;
	$(document).ready(function(){
		pf = document.programForm;
		
		// 셀렉트 박스 값을 갱신
		$('.jquerySelectbox').selectmenu().selectmenu('refresh');
		
		var programContainer = $('#programList')[0];
		if (typeof programListSheet !== 'undefined' && typeof programListSheet.Index !== 'undefined') {
			programListSheet.DisposeSheet();
		}
		createIBSheet2(programContainer, 'programListSheet', '1300px', '200px');
		ibProgramHeader.initSheet('programListSheet');
		
		getProgramList();
	});
	
	function programListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('programListSheet_OnSearchEnd : ', msg);
    	} else {
    		programListSheet.SetEllipsis(1);
    		programListSheet.SetDataBackColor('#ffffff');
    		programListSheet.SetMouseHoverMode(0);
    		programListSheet.SetMousePointer('hand');
    	}
    }
	
	function programListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (programListSheet.ColSaveName(col) == 'programNm') {
				var programSeq = programListSheet.GetCellValue(row, 'programSeq');
				
				doProgramAdd(programSeq);
		    }	
		}
	}
	
	function doProgramSearch() {
		getProgramList();
	}
	
	// 목록 가져오기
	function getProgramList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/menu/popup/program/selectList.do" />'
			, data : $('#programForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				programListSheet.LoadSearchData({Data: data.resultList});
				
				$('#mCSB_16').mCustomScrollbar();
			}
		});
	}
	
	function doProgramAdd(programSeq) {
		if (confirm('선택한 프록그램을 추가 하시겠습니까?')) {
			// 콜백펑션을 위한 변수
			if (paramCallbackFunction && typeof paramCallbackFunction == 'function') {
				paramCallbackFunction($('input[name="popupCountryCd"]:checked'));
			}
		}
	}
	
	function closePopup() {
		$('#${param.targetPopup}').children().remove();
		$('#${param.targetPopup}').removeClass('open');
	}
</script>