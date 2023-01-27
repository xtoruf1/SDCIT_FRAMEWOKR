<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundPopupForm" name="fundPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchExpertIdPop" 	id="searchExpertIdPop" 	value="<c:out value="${searchExpertIdPop}"/> /">
<input type="hidden" name="pageIndex"			id="pageIndex"  		value="<c:out value='${param.pageIndex}' 	default='1' />" />

<input type="hidden" name="speChk" 	id="speChk" 	value="<c:out value="${speChk}"/>">
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />

<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">기금융자 찾기</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_primary" 	 onclick="doFundPopupSearch();">검색</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col style="width:35%">
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">융자코드</th>
					<td>
						<input type="text" id="searchSvrId" name="searchSvrId" value="<c:out value="${param.searchSvrId}"/>" onkeydown="onEnter(doFundPopupSearch);" class="form_text w100p"  size="17" placeholder="기금융자코드" title="기금융자코드"  maxlength="30" />
					</td>
					<th scope="row">융자명</th>
					<td>
						<div class="form_row w100p">
							<input type="text" id="searchTitle" name="searchTitle" value="<c:out value="${param.searchTitle}"/>" onkeydown="onEnter(doFundPopupSearch);" class="form_text" title="검색어" size="17" placeholder="기금융자명" title="기금융자명" maxlength="150" />
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->

	<div class="tbl_opt mt-20">
		<!-- 전체 게시글 -->
		<div id="fundPopupSheetTotalCnt" class="total_count"></div>

		<fieldset class="ml-auto">
			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select" onchange="doFundPopupSearch();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</fieldset>
	</div>

	<div class="w100p">
		<div id="fundPopupSheet" class="sheet"></div>
	</div>
	<!-- .paging-->
	<div id="fundPopupSheetPaging" class="paging ibs""></div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript">

	$(document).ready(function () {

		  $(".modal").on("click", function(e){
			   if(!$(e.target).is($(".modal-content, .modal-content *"))){
			    closeLayerPopup();
			   }
			  });

		initFundPopupSheet();
		goFundPopupPage(1);
	});

	// Sheet의 초기화 작업
	function initFundPopupSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10,  SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, NoFocusMode : 0, ColResize: true, statusColHidden: true, MergeSheet :5});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Header:"No.",      	Type:"Int",      Hidden:false,  Width:50,   Align:"Center",  SaveName:"rn"         });
        ibHeader.addHeader({Header:"No.",      	Type:"Seq",      Hidden:true,  Width:50,   Align:"Center",  SaveName:"no"         });
        ibHeader.addHeader({Header:"Status",   	Type:"Status",   Hidden:true,   Width:80,   Align:"Center",  SaveName:"status"     });
        ibHeader.addHeader({Header:"기금융자코드", 	Type:"Text",     Hidden:false,  Width:100,  Align:"Center",  SaveName:"svrId"      });
        ibHeader.addHeader({Header:"기금융자명",  	Type:"Text",     Hidden:false,  Width:300,  Align:"Left",    SaveName:"title"      });
        ibHeader.addHeader({Header:"접수기간",   	Type:"Text",     Hidden:true,   Width:120,  Align:"Center",  SaveName:"bsnStartDt" });
        ibHeader.addHeader({Header:"상태",       	Type:"Text",     Hidden:true,   Width:60,   Align:"Center",  SaveName:"st"         });
        ibHeader.addHeader({Header:"상태",       	Type:"Text",     Hidden:false,  Width:60,   Align:"Center",  SaveName:"stNm"       });
        ibHeader.addHeader({Header:"지부상태",    	Type:"Text",     Hidden:true,  	Width:60,   Align:"Center",  SaveName:"deadineSt"  });
        ibHeader.addHeader({Header:"지부상태명",   	Type:"Text",     Hidden:true, 	Width:60,   Align:"Center",  SaveName:"deadineStNm"});

		var sheetId = "fundPopupSheet";
		var container = $("#"+sheetId)[0];
		if (typeof fundPopupSheet !== 'undefined' && typeof fundPopupSheet.Index !== 'undefined') {
			fundPopupSheet.DisposeSheet();
		}
		createIBSheet2(container, sheetId, "100%", "300px");
		ibHeader.initSheet(sheetId);
		fundPopupSheet.SetSelectionMode(4);

		fundPopupSheet.SetEditable(0);
		fundPopupSheet.SetDataLinkMouse("no",true);
		fundPopupSheet.SetDataLinkMouse("svrId",true);
		fundPopupSheet.SetDataLinkMouse("title",true);
		fundPopupSheet.SetDataLinkMouse("stNm",true);
	};

	//조회
	function doFundPopupSearch() {
		goFundPopupPage(1);
// 		getList();
	}

	//페이징 조회
	function goFundPopupPage(pageIndex) {
		var form = document.fundPopupForm;
		form.pageIndex.value = pageIndex;
		geFundPopuptList();
	}

	// 검색
	function geFundPopuptList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/lms/fundPopupList.do" />'
			, data : $('#fundPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#fundPopupSheetTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);

				setPaging(
					'fundPopupSheetPaging'
					, goFundPopupPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				fundPopupSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function fundPopupSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if (Row == 0) return;

		var rowData = fundPopupSheet.GetRowData(Row);
		// 콜백
		layerPopupCallback(rowData);
		// 레이어 닫기
		closeLayerPopup();
	 }

	function fundPopupSheet_OnRowSearchEnd(row) {
		if ( row > 0) {
		var index = fundPopupSheet.GetCellValue(row, "no");
		var resultCnt = $('#resultCnt').val();
		fundPopupSheet.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	}
</script>