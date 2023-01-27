<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<form id="frm" name="frm" method="post">
<!-- 리스트 조회조건 파라미터 세팅 Start -->
<input type="hidden" name="sCompanyName" id="sCompanyName" value="<c:out value='${param.sCompanyName}'/>"/>
<input type="hidden" name="sBusinessNo" id="sBusinessNo" value="<c:out value='${param.sBusinessNo}'/>"/>
<input type="hidden" name="sTradeNo" id="sTradeNo" value="<c:out value='${param.sTradeNo}'/>"/>
<input type="hidden" name="sCeoName" id="sCeoName" value="<c:out value='${param.sCeoName}'/>"/>
<input type="hidden" name="sStatusCd" id="sStatusCd" value="<c:out value='${param.sStatusCd}'/>"/>
<input type="hidden" name="sPrintYn" id="sPrintYn" value="<c:out value='${param.sPrintYn}'/>"/>
<input type="hidden" name="sStartDate" id="sStartDate" value="<c:out value='${param.sStartDate}'/>"/>
<input type="hidden" name="sEndDate" id="sEndDate" value="<c:out value='${param.sEndDate}'/>"/>
<!-- 리스트 조회조건 파라미터 세팅 End -->

<input type="hidden" name="foreignReceiptId" id="foreignReceiptId" value="<c:out value="${result.foreignReceiptId}"/>"/>
<input type="hidden" name="certMngId" id="certMngId" value="<c:out value="${result.certMngId}"/>"/>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<c:if test="${result.statusCd eq '20' or result.statusCd eq '30' or result.statusCd eq '40'}">
			<button type="button" id="btnApply" class="btn_sm btn_primary btn_modify_auth" onclick="callApplyPopup();">승인</button>
		</c:if>
		<c:if test="${result.statusCd eq '20' or result.statusCd eq '30'}">
			<button type="button" id="btnReject" class="btn_sm btn_secondary btn_modify_auth" onclick="callRejectPopup();">반려</button>
		</c:if>
		<c:if test="${result.printYn eq 'Y'}">
			<button type="button" id="btnResetPrint" class="btn_sm btn_primary btn_modify_auth" onclick="doResetPrint();">출력초기화</button>
		</c:if>
	</div>
	<div class="ml-15">
		<button type="button" id="btnList" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">신청 정보</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col style="width:40%" />
			<col style="width:10%" />
			<col style="width:40%" />
			<col />
		</colgroup>
		<tr>
			<th>업체명</th>
			<td><c:out value="${result.companyName}"/></td>
			<th>사업자번호</th>
			<td><c:out value="${result.businessNo}"/></td>
		</tr>
		<tr>
			<th>대표자</th>
			<td><c:out value="${result.ceoName}"/></td>
			<th>무역업고유번호</th>
			<td><c:out value="${result.tradeNo}"/></td>
		</tr>
		<tr>
			<th>기업구분</th>
			<td><c:out value="${result.personCorpTypeNm}"/></td>
			<th>전화번호</th>
			<td><c:out value="${result.tel}"/></td>
		</tr>
		<tr>
			<th>기업규모</th>
			<td><c:out value="${result.companyScaleNm}"/></td>
			<th>상장여부</th>
			<td><c:out value="${result.listedYnNm}"/></td>
		</tr>
		<tr>
			<th>주소</th>
			<td colspan="3"><c:out value="${result.address}"/></td>
		</tr>
		<tr>
			<th>담당자 명</th>
			<td colspan="3"><c:out value="${result.chargeName}"/></td>
		</tr>
		<tr>
			<th>담당자 이메일</th>
			<td><c:out value="${result.chargeEmail}"/></td>
			<th>담당자 휴대폰</th>
			<td><c:out value="${result.chargePhone}"/></td>
		</tr>
		<tr>
			<th>신청일</th>
			<td><c:out value="${result.reqDate}"/></td>
			<th>상태</th>
			<td><c:out value="${result.statusNm}"/></td>
		</tr>
		<tr>
			<th>첨부문서</th>
			<td colspan="3">
				<c:if test="${not empty fileList}">
					<c:forEach var="result" items="${fileList}" varStatus="status">
						<p>
							<span class="attr_list">
								<c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${result.groupId}"/>', '<c:out value="${result.attachSeq}"/>', '<c:out value="${result.fileSeq}"/>');"><c:out value="${result.fileNm}"/> ( <c:out value="${result.fileSize}"/> )</a>
							</span>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/common/fileDownload.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}','<c:out value="${result.fileNm}"/>', '<c:out value="${serverName}_foreignCurrency_${result.groupId}_${result.attachSeq}_${result.fileSeq}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</p>
					</c:forEach>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>확인일</th>
			<td><c:out value="${result.appDate}"/></td>
			<th>발급번호</th>
			<td><c:out value="${result.appNo}"/></td>
		</tr>
		<c:if test="${result.statusCd eq '40'}">
			<!-- 반려상태일때만 반려 사유 표시 -->
			<tr>
				<th>반려사유</th>
				<td colspan="3"><c:out value="${fn:replace(result.rejectDscr, newLineChar, '<br/>')}" escapeXml="false" /></td>
			</tr>
		</c:if>
	</table>
	<div class="cont_block mt-40">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">수출입 확인 사항</h3>
		</div>
		<div id='sheetDiv' class="colPosi"></div>
	</div>
</div>

</form>

<script type="text/javascript">

	var	ibHeader = new IBHeader();
	ibHeader.addHeader({Header: '상태', 				Type: 'Status', SaveName: 'status', 		Hidden: true});
	ibHeader.addHeader({Header: 'No',				Type: 'Text', 	SaveName: 'rn', 			Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '수출입구분',			Type: 'Text', 	SaveName: 'tradeTypeNm', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '품목명',				Type: 'Text', 	SaveName: 'itemName', 		Width: 300, Align: 'Left'});
	ibHeader.addHeader({Header: '거래형태\nL/C, T/T',	Type: 'Text', 	SaveName: 'tranTypeNm', 	Width: 200, Align: 'Left'});
	ibHeader.addHeader({Header: '확인금액 USD',		Type: 'Int', 	SaveName: 'amt',			Width: 100, Align: 'Right'});
	ibHeader.addHeader({Header: '거래번호',			Type: 'Text', 	SaveName: 'tranNo', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '입금일자',			Type: 'Text', 	SaveName: 'depositDate', 	Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '대상국가',			Type: 'Text', 	SaveName: 'countryNm', 		Width: 100, Align: 'Center'});
	ibHeader.addHeader({Header: '거래외국환은행',		Type: 'Text', 	SaveName: 'bankNm', 		Width: 100, Align: 'Left'});
	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var f;
	$(document).ready(function(){
		f = document.frm;

		//시트 초기화
		var container = $('#sheetDiv')[0];
		createIBSheet2(container, 'tblGridSheet', '100%', '100%');
		ibHeader.initSheet('tblGridSheet');
		tblGridSheet.SetSelectionMode(4);

		//목록조회 호출
		getItemList();
	});

	function getItemList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/issue/cert/foreignCurrencyItemList.do" />'
			, data : $('#frm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//시트가 조회된 후 실행
	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGridSheet_OnSearchEnd : ', msg);
    	} else {
    		// 업체명에 볼드 처리
			tblGridSheet.SetColFontBold('companyName', 1);
    	}
    }

	//시트 조회 완료 후 하나하나의 행마다 실행
	function tblGridSheet_OnRowSearchEnd(row) {
		// 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
		notEditableCellColor('tblGridSheet', row);
	}

	/*목록 이동*/
	function goList() {

		$('#frm').attr('action', '/issue/cert/foreignCurrencyList.do');
		$('#frm').submit();

	}

	//파일다운로드
	function doDownloadFile(groupId, attachSeq, fileSeq){
		$('#frm').attr('action', '<c:url value="/common/fileDownload.do" />?groupId='+groupId+'&attachSeq='+attachSeq+'&fileSeq='+fileSeq);
		$('#frm').submit();
	}

	//승인팝업
	function callApplyPopup(){

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/issue/cert/popup/foreignCurrencyApply.do'
			, params : { foreignReceiptId : $('#foreignReceiptId').val()
						,certMngId : $('#certMngId').val()
				}
			, callbackFunction : function(resultObj){
				goList();
			}
		});
	}

	//반려팝업
	function callRejectPopup(){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/issue/cert/popup/foreignCurrencyReject.do'
			, params : { foreignReceiptId : $('#foreignReceiptId').val()
						,certMngId : $('#certMngId').val()
				}
			, callbackFunction : function(resultObj){
				goList();
			}
		});
	}

	//출력초기화
	function doResetPrint() {

		if(!confirm("출력을 초기화 하시겠습니까?")){
			return false;
		}
		global.ajax({
			url : '<c:url value="/issue/cert/resetPrintForeignCurrency.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				certMngId : '${result.certMngId}'
			}
			, async : true
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}


</script>