<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="detailForm" name="detailForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchExpertIdPop" id="searchExpertIdPop" value="<c:out value="${searchExpertIdPop}"/>">

<!-- 팝업 타이틀 -->

<div class="flex">
	<h2 class="popup_title">위원평가통계상세</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="getPopupExcelDown();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_primary" onclick="popupDetail();">검색</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div class="popup_body">
	<!--검색 시작 -->
	<div class="cont_block">
		<div class="search">
			<table class="formTable">
				<colgroup>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">일자</th>
						<td class="pick_area">
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchFrDtPop" name="searchFrDtPop" value='<c:out value="${searchFrDtPop}"/>' class="txt datepicker" placeholder="시작일" title="게재기간 시작일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
								</div>
								<div class="spacing">~</div>
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchToDtPop" name="searchToDtPop" value='<c:out value="${searchToDtPop}"/>' class="txt datepicker" placeholder="종료일" title="게재기간 종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<%--<div class="tableTopTxt st2 step total_count">
				<strong>총 건수</strong>
			</div>--%>
			<div id="totalCnt2" class="total_count"></div>
		</div>
		<div class="tbl_list">
			<div id="tblGridPopupSheet" class="colPosi"></div>
		</div>
		<!-- .paging-->
		<div id="paging" class="paging ibs"></div>
	</div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	var f;
	$(document).ready(function () {
		f = document.detailForm;

		f_Init_tblGridPopupSheet();

		popupDetail();
	});


	function f_Init_tblGridPopupSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10,  SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "업체명", 				    SaveName: "companyKor", Align: "Center", 	Width: 120, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "무역업고유번호", 		    SaveName: "companyId", Align: "Center", 	Width: 110});
		ibHeader.addHeader({Type: "Text", Header: "발생사안", 				SaveName: "content", Align: "Center", 	Width: 270, 	Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "벌점",					SaveName: "score", Align: "Center", 	Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "접수일\n(해당건 업체\n접수일)", 	SaveName: "regDate", Align: "Center", 	Width: 90});
		ibHeader.addHeader({Type: "Text", Header: "최초\n벌점\n부여일",        SaveName: "insertDate", Align: "Center", 	Width: 90});
		ibHeader.addHeader({Type: "Text", Header: "최종\n벌점\n확정일",        SaveName: "updateDate", Align: "Center", 	Width: 90});

		if (typeof tblGridPopupSheet !== 'undefined' && typeof tblGridPopupSheet.Index !== 'undefined') {
			tblGridPopupSheet.DisposeSheet();
		}

		var sheetId = "tblGridPopupSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridPopupSheet.SetEditable(0);
	};

	function popupDetail(){

		var validate = true;
		if($('#searchFrDtPop').val() == ""){
			alert('조회시작일자를 선택해주세요');
			$('#searchFrDtPop').focus();
			validate = false;
		}

		if($('#searchToDtPop').val() == ""){
			alert('조회종료일자를 선택해주세요');
			$('#searchToDtPop').focus();
			validate = false;
		}

		if(validate){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/translation/evaluationPopupDetail.do" />'
				, data : $('#detailForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					console.log(data.totalCount);
					$('#totalCnt2').html('총 <span style="color: orange;">' + global.formatCurrency(data.totalCount) + '</span> 건');

					tblGridPopupSheet.LoadSearchData({Data: data.returnList});
				}
			});
		}
	}

	// 엑셀전환 다운로드 (외국어통번역통계_평가통계_팝업)
	function getPopupExcelDown() {
		f.action = '<c:url value="/tradeSOS/translation/evaluationPopupExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function closePopup() {
		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = '공통 팝업1 ID : modalLayerPopup' + config.timestamp;
		config.callbackFunction(returnObj);

		// 레이어 닫기
		closeLayerPopup();
	}

</script>