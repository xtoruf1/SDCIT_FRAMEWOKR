<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="registForm" name="registForm" method="post" onsubmit="return false;">
<input type="hidden" id="svrId" name="svrId" value="" />
<input type="hidden" id="statusChk" name="statusChk" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doNew();" class="btn_sm btn_primary btn_modify_auth">신규</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!-- 검색 시작 -->
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
				<th scope="row">포상년도</th>
				<td>
					<fieldset class="widget">
						<select id="searchYear" name="searchYear" class="form_select" style="width: 150px;" title="포상년도">
							<option value="">전체</option>
							<c:forEach var="item" items="${yearList}" varStatus="status">
								<option value="<c:out value="${item.searchYear}"/>" <c:if test="${param.searchYear eq item.searchYear}">selected="selected"</c:if>>${item.searchYear}</option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">포상명</th>
				<td>
					<input type="text" id="searchTitle" name="searchTitle" value="${param.searchTitle}" onkeydown="onEnter(doSearch);" class="form_text w100p" maxlength="150" title="포상명" />
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!-- 검색 끝 -->
<div class="fund_reg mt-20">
	<div class="left" style="width: 45%;">
		<div class="cont_block">
			<div class="tbl_opt">
				<div id="totalCnt" class="total_count"></div>
			</div>
			<div style="width: 100%;">
				<div id="registList" class="sheet"></div>
			</div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		initIBSheet();
	});

	// Sheet의 초기화 작업
	function initIBSheet() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: 'No', Type: 'Seq', Hidden: false, Width: 60, Align: 'Center', SaveName: 'no' });
		ibHeader.addHeader({Header: '포상명', Type: 'Text', Hidden: false, Width: 450, Align: 'Left', SaveName: 'bsnNm', KeyField: 1, CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Cursor: 'Pointer' });
		ibHeader.addHeader({Header: '신청서접수기간', Type: 'Text', Hidden: false, Width: 180, Align: 'Center', SaveName: 'bsnDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청현황', Type: 'Int', Hidden: false, Width: 90, Align: 'Center', SaveName: 'bsnCnt', CalcLogic: '', Format: '#,##0', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '진행상태', Type: 'Combo', Hidden: false, Width: 90, Align: 'Center', SaveName: 'state', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, ComboCode: '${saAWD000.detailcd}', ComboText: '${saAWD000.detailnm}' });

		ibHeader.addHeader({Header: '삭제', Type: 'Text', Hidden: true, Width: 50, Align: 'Center', SaveName: '' });
		ibHeader.addHeader({Header: '포상코드', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'svrId', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청서접수시작', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'bsnAplStartDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청서접수종료', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'bsnAplEndDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청서배부_시작', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'applDtbStartDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청서배부_종료', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'applDtbEndDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '신청서배부및접수위치', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'applDtbPlace', KeyField: 1, CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '업무시작예정일', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'procInitDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '포상년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'praYear', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '포상일', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'priDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정시작_당년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expNowyearStartDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정종료_당년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expNowyearEndDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정시작_전년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expBefyearStartDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정종료_전년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expBefyearEndDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정종료_전전년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expTwoyearStartDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '수출실적인정종료_전전년도', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'expTwoyearEndDt', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '기타상세내역', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'ref', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자아이디', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkMembId', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자명', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkMembNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자부서', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkDeptId', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자부서명', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkDeptNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자전화', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkMembPhone', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '담당자팩스', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkMembFax', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen :30 });
		ibHeader.addHeader({Header: '담당자이메일', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'wrkMembEmail', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '파일정보아이디', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'attFileId', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '파일리스트', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'bsnSeq', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });
		ibHeader.addHeader({Header: '회차', Type: 'Text', Hidden: true, Width: 120, Align: 'Center', SaveName: 'attFileList', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, SizeMode: 4, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 0, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = 'registList';
		var container = $('#' + sheetId)[0];
		if (typeof registListSheet !== 'undefined' && typeof registListSheet.Index !== 'undefined') {
			registListSheet.DisposeSheet();
		}

		createIBSheet2(container, 'registListSheet', '100%', '597px');
		ibHeader.initSheet('registListSheet');
		registListSheet.SetSelectionMode(4);

		registListSheet.SetEditable(true);

		getList();
	}

	function registListSheet_OnSort(col, order) {
		registListSheet.SetScrollTop(0);
	}

	// 조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectTradeDayRegisteList.do" />'
			, data : $('#registForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				registListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function registListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('registListSheet_OnSearchEnd : ', msg);
    	} else {
    		registListSheet.SetColFontBold('bsnNm', 1);
    		registListSheet.ReNumberSeq('desc');
    	}
    }

	function registListSheet_OnClick(row, col, value) {
		if (row > 0) {
			if (registListSheet.ColSaveName(col) == 'bsnNm') {
				var svrId = registListSheet.GetCellValue(row, 'svrId');

				goView(svrId);
			}
		}
	}

	function goView(svrId) {
		var f = document.registForm;
		f.action = '<c:url value="/tdms/tdm/tradeDayRegisteDetail.do" />';
		f.svrId.value = svrId;
		f.statusChk.value = 'U';
		f.target = '_self';
		f.submit();
	}

	function doNew() {
		var f = document.registForm;
		f.action = '<c:url value="/tdms/tdm/tradeDayRegisteDetail.do" />';
		f.svrId.value = '';
		f.statusChk.value = 'I';
		f.target = '_self';
		f.submit();
	}
</script>