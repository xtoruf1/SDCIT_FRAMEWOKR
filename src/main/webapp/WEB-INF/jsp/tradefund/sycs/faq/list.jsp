<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form id="viewForm" name="viewForm" method="get" onsubmit="return false;">
	<input type="hidden" id="faqSeq" name="faqSeq" value="" />
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<!-- 페이지 위치 -->
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" onclick="doSearch()" class="btn_sm btn_primary">조회</button>
			<button type="button" onclick="fn_Reset()" class="btn_sm btn_primary ">초기화</button>
			<button type="button" onclick="goWrite()" class="btn_sm btn_primary btn_modify_auth">등록</button>
		</div>
	</div>
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width: 10%;" />
				<col />
				<col style="width: 10%;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>질문</th>
					<td>
						<div>
							<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="form_text w100p" title="검색어" />
						</div>
					</td>
					<th>게시판구분</th>
					<td>
						<select name="searchFaqGb" id="searchFaqGb" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${com010}" varStatus="status">
								<option value="${list.code}"<c:if test="${param.searchFaqGb == list.code}"> selected</c:if>>${list.codenm}</option>
							</c:forEach>
						</select>
					</td>
	            </tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
			<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select ml-auto" title="목록수">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id="dataList" class="sheet"></div>
		</div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">
	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '시퀀스', Type: 'Text', SaveName: 'faqSeq', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '사용여부', Type: 'Text', SaveName: 'faqYn', Width: 20, Align: 'Center', Hidden: true});
	ibHeader.addHeader({Header: '구분', Type: 'Text', SaveName: 'faqGb', Width: 80, Align: 'Center', Hidden: false});
	ibHeader.addHeader({Header: '분류번호', Type: 'Text', SaveName: 'faqClassNo', Width: 30, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '분류구분', Type: 'Text', SaveName: 'faqClassCd', Width: 50, Align: 'Center', HeaderCheck: 0});
	ibHeader.addHeader({Header: '중요도', Type: 'Text', SaveName: 'faqLevelNm', Width: 30, Align: 'Center', Cursor: 'Pointer'});
	ibHeader.addHeader({Header: '제목', Type: 'Text', SaveName: 'faqQ', Width: 400, Align: 'Left', Ellipsis: true, Cursor:"Pointer"});
	ibHeader.addHeader({Header: '등록자', Type: 'Text', SaveName: 'faqInuser', Width: 50, Align: 'Left'});
	ibHeader.addHeader({Header: '등록일시', Type: 'Text', SaveName: 'faqIndate', Width: 80, Align: 'Center'});
	ibHeader.addHeader({Header: '조회수', Type: 'Text', SaveName: 'faqCount', Width: 30, Align: 'Left'});

	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	var f;
	$(document).ready(function(){
		f = document.viewForm;

		var container = $('#dataList')[0];
		if (typeof dataListSheet !== 'undefined' && typeof dataListSheet.Index !== 'undefined') {
			dataListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'dataListSheet', '100%', '100%');
		ibHeader.initSheet('dataListSheet');

		getList();
	});

	function dataListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('dataListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 공통코드에 볼드 처리
			dataListSheet.SetColFontBold('faqQ', 1);
    	}
    }

	function dataListSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if (row > 0) {
			if (dataListSheet.ColSaveName(col) == 'faqQ') {
				var faqSeq = dataListSheet.GetCellValue(row, 'faqSeq');

				goView(faqSeq);
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
			, url : '<c:url value="/sycs/faq/faqList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				dataListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/sycs/faq/regist.do" />';
		f.faqSeq.value = '';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(faqSeq) {
		f.action = '<c:url value="/sycs/faq/modify.do" />';
		f.faqSeq.value = faqSeq;
		f.target = '_self';
		f.submit();
	}

	// 검색조건 초기화 함수
	function fn_Reset() {
		f.searchKeyword.value = "";
		f.searchFaqGb.value = "";
	}

	// 삭제
	function doDelete() {
		var saveJson = dataListSheet.GetSaveJson();

		// 대상목록의 정보
		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson.Message == 'InvalidInputError') {
			return false;
		}

		if (saveJson.data.length) {
			if (confirm('선택한 공통코드 정보를 삭제하시겠습니까?')) {
				var ccf = $('#viewForm').serializeObject();

				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						map = value2;
						list.push(map);
					});

					ccf['deletedataList'] = list;
				});

				global.ajax({
					type : 'POST'
					, url : '<c:url value="//sycs/deleteList.do" />'
					, data : JSON.stringify(ccf)
					, contentType : 'application/json'
					, dataType : 'json'
					, async: false
					, spinner : true
					, success : function(data){
						if (data.result) {
							// alert('공통코드 정보를 삭제하였습니다.');
							location.href = '<c:url value="/sysInputStandardAwardCode/sycs/list.do" />';
						} else {
							alert(data.message);
						}
					}
				});
			}
		} else {
			alert('삭제할 공통코드 정보를 선택해 주세요.');
		}
	}

</script>