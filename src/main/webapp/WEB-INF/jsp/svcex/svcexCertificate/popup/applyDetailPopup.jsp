<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form name="frmApplyPopup"	id="frmApplyPopup"	method="post" >
	<input type="hidden"	name="event"				id="event" />
	<input type="hidden"	name="popupBsNo"			id="popupBsNo"				value="<c:out value="${svcexVO.popupBsNo}"/>" />
	<input type="hidden"	name="popupReqno"			id="popupReqno"				value="<c:out value="${svcexVO.popupReqno}"/>" />
	<input type="hidden"	name="pageIndexPopup1"		id="pageIndexPopup1"		value="<c:out value='${param.pageIndexPopup1}' default='1' />" />
	<input type="hidden"	name="sumCheckAmountPopup"	id="sumCheckAmountPopup"	value="" />

	<div class="flex">
		<h2 class="popup_title">신청내역</h2>
		<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<div class="popup_body">
		<div class="cont_block">
			<table class="formTable">
				<colgroup>
					<col style="width:18%;">
					<col>
					<col style="width:18%;">
					<col>
				</colgroup>

				<c:if test="${not empty returnResultViewPopup }">
						<c:forEach items="${returnResultViewPopup }" var="list" varStatus="status">
							<tr>
								<th>
									<c:choose>
										<c:when test="${svcexVO.stateCd eq 'D' && (fn:length(returnResultViewPopup) == (status.index+1)) }">
											<strong>
												<c:out value="${(status.index+1) }"/> 반려사유<br/>[<c:out value="${list.returnDate }"/>]
											</strong>
										</c:when>
										<c:otherwise>
											<c:out value="${(status.index+1) }"/> 반려사유<br/>[<c:out value="${list.returnDate }"/>]
										</c:otherwise>
									</c:choose>
								</th>
								<td colspan="3">
									<c:choose>
										<c:when test="${not empty list.returnNo }">
											<a href="goReturnView('<c:out value="${list.returnNo}"/>')" class="link">
												<c:out value="${list.returnReason }"/>
											</a>
										</c:when>
										<c:otherwise>
											<c:out value="${list.returnReason }"/>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<tr>
						<th>회사명</th>
						<td><c:out value="${resultViewPopup.companyKor }"/></td>
						<th>대표자명</th>
						<td><c:out value="${resultViewPopup.presidentKor }"/></td>
					</tr>
					<tr>
						<th>사업자등록번호</th>
						<td><c:out value="${resultViewPopup.bsNo1 }"/>-<c:out value="${resultViewPopup.bsNo2 }"/>-<c:out value="${resultViewPopup.bsNo3 }"/></td>
						<th>무역업고유번호</th>
						<td><c:out value="${resultViewPopup.bsNo }"/></td>
					</tr>
					<tr>
						<th>사업장 전화번호</th>
						<td colspan="3"><c:out value="${resultViewPopup.telEtc }"/></td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3"><c:out value="${resultViewPopup.korAddr1 }"/> <c:out value="${resultViewPopup.korAddr2 }"/></td>
					</tr>
					<tr>
						<th>사업자등록증</th>
						<td colspan="3">
						<input type="hidden" name="attFileId" id="attFileId" value="<c:out value="${resultViewPopup.attFileId }"/>">
						<c:forEach var="fileList" items="${fileListPopup}" varStatus="status">
							<c:out value="${(status.index+1) }"/> :  <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</c:forEach>
						</td>
					</tr>
					<tr>
						<th>담당자명</th>
						<td><c:out value="${resultViewPopup.wrkMembNm }"/></td>
						<th>핸드폰</th>
						<td>
							<c:choose>
								<c:when test="${not empty resultViewPopup.coHp1}">
									<c:out value="${resultViewPopup.coHp1}"/>-<c:out value="${resultViewPopup.coHp2}"/>-<c:out value="${resultViewPopup.coHp3}"/>
								</c:when>
								<c:otherwise>
									<c:out value="${resultViewPopup.coHpOld }"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>E-Mail</th>
						<td>
							<c:choose>
								<c:when test="${not empty resultViewPopup.coEmail1}">
									<c:out value="${resultViewPopup.coEmail1}"/>@<c:out value="${resultViewPopup.coEmail3}"/>
								</c:when>
								<c:otherwise>
									<c:out value="${resultViewPopup.coEmailOld }"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th>발급상태</th>
						<td><c:out value="${resultViewPopup.issueCd }"/></td>
					</tr>
					<tr>
						<th>수출입실적 확인기간</th>
						<td><date><c:out value="${resultViewPopup.amountSdate }"/></date> ~ <date><c:out value="${resultViewPopup.amountEdate }"/></date></td>
						<th>기존실적 포함 출력 여부</th>
						<td><c:out value="${resultViewPopup.oriDataYn }"/></td>
					</tr>
					<tr>
						<th>수출입계약서</th>
						<td colspan="3">
							<input name="contractAttFileId" id="contractAttFileId" type="hidden" value="<c:out value="${resultViewPopup.contractAttFileId }"/>">
							<c:forEach var="fileList" items="${contractFileListPopup}" varStatus="status">
								<p>
									<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
									<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</p>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th>은행이 발급한<br>외화매입 증명서류</th>
						<td colspan="3">
							<input name="currencyAttFileId" id="currencyAttFileId" type="hidden" value="<c:out value="${resultViewPopup.currencyAttFileId }"/>">
							<c:forEach var="fileList" items="${currencyFileListPopup}" varStatus="status">
								<p>
									<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
									<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</p>
							</c:forEach>
						</td>
					</tr>
				</tbody>
			</table><!-- //formTable -->
		</div>

		<div class="cont_block">
			<div class="tbl_opt">
				<!-- 전체 게시글 -->
				<div id="totalCntPopup" class="total_count"></div>

				<fieldset class="ml-auto">

					<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(apllyListSheet,'신청내역 상세조회(팝업)','');">엑셀 다운</button>

					<select id="pageUnitPopup1" name="pageUnitPopup1" onchange="doSearch();" title="목록수" class="form_select ml-8">
						<c:forEach var="item" items="${pageUnitList}" varStatus="status">
							<option value="${item.code}" <c:if test="${param.pageUnitPopup1 eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
						</c:forEach>
					</select>

				</fieldset>
			</div>

			<div id="apllyDetailPopupList" class="sheet"></div>
			<div id="pagingPopup" class="paging ibs"></div>
		</div>
	</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initPopupGrid();
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function initPopupGrid(){
		if (typeof apllyDetailPopupListSheet !== "undefined" && typeof apllyDetailPopupListSheet.Index !== "undefined") {
			apllyDetailPopupListSheet.DisposeSheet();
		}

		var	ibApplyPopupHeader = new IBHeader();
		ibApplyPopupHeader.addHeader({Header: '수출입구분',		Type: 'Text', 		SaveName: 'expImpNm',			Width: 6,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '품목명(용역명)',	Type: 'Text', 		SaveName: 'itemNm',				Width: 13,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '거래형태',		Type: 'Text', 		SaveName: 'tradePatternNm',		Width: 7,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '확인금액',		Type: 'Int',		SaveName: 'checkAmount',		Width: 8,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '거래외국환은행',	Type: 'Text',		SaveName: 'foreignBank',		Width: 8,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '거래번호',		Type: 'Text',		SaveName: 'businessNo',			Width: 8,	Align: 'Center'	});
		ibApplyPopupHeader.addHeader({Header: '대상국가',		Type: 'Text',		SaveName: 'targetCountryNm',	Width: 8,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '계약일자',		Type: 'Text',		SaveName: 'settleDate',			Width: 5,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '입금일자',		Type: 'Text',		SaveName: 'contractDate',		Width: 5,	Align: 'Center'});
		ibApplyPopupHeader.addHeader({Header: '거래업체명',		Type: 'Text',		SaveName: 'coNm',				Width: 8,	Align: 'Center'});

		ibApplyPopupHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: , NoFocusMode : 0 });
		ibApplyPopupHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#apllyDetailPopupList')[0];
		createIBSheet2(container, 'apllyDetailPopupListSheet', '100%', '100%');
		ibApplyPopupHeader.initSheet('apllyDetailPopupListSheet');
		apllyDetailPopupListSheet.SetSelectionMode(4);
		selectApplyDetailPopupList();
	}

	function goPage(pageIndex) {
		var frmApplyPopup = document.frmApplyPopup;
		frmApplyPopup.pageIndexPopup1.value = pageIndex;
		selectApplyDetailPopupList();
	}

	function selectApplyDetailPopupList() {
		var frmApplyPopup = document.frmApplyPopup;
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/popup/applyDetailPopupDataList.do" />'
			, data : $('#frmApplyPopup').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCntPopup').html('총 ' + global.formatCurrency(data.resultCntPopup) + ' 건');
				frmApplyPopup.sumCheckAmountPopup.value = data.sumCheckAmountPopup;
				setPaging(
						'pagingPopup'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
				);

				apllyDetailPopupListSheet.LoadSearchData({Data: data.resultListPopup});
			}
		});
	}

	function apllyDetailPopupListSheet_OnSearchEnd(code, msg, stCode, stMsg, responseText) {
		var frmApplyPopup = document.frmApplyPopup;
		var lastLow = apllyDetailPopupListSheet.GetDataLastRow();
		var transNumber = frmApplyPopup.sumCheckAmountPopup.value;

		if( lastLow > 0 ) {
			transNumber = transNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			apllyDetailPopupListSheet.ShowFooterRow([ {} ]);
			apllyDetailPopupListSheet.SetCellText(lastLow+1, 0, "합계");
			apllyDetailPopupListSheet.SetCellText(lastLow+1, 3, transNumber);
		}
	}

	function doDownloadFile(fileId, fileNo) {
		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","get");
		newForm.attr("action","/supves/supvesFileDownload.do");
		newForm.attr("target","_blank");
		newForm.append($('<input/>', {type: 'hidden', name: 'fileId', value: fileId }));
		newForm.append($('<input/>', {type: 'hidden', name: 'fileNo', value: fileNo }));
		newForm.appendTo('body');
		newForm.submit();
	}
</script>