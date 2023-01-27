<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />

<form id="form1" name="form1" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="event" />
	<input type="hidden" name="bsNo"			id="bsNo"			value="<c:out value="${resultView.bsNo }"/>"/>
	<input type="hidden" name="reqno"			id="reqno"			value="<c:out value="${resultView.reqno }"/>"/>
	<input type="hidden" name="reqstUuid"		id="reqstUuid"		value="<c:out value="${resultView.reqstUuid }"/>"/>
	<input type="hidden" name="coHp"			id="coHp"			value="<c:out value="${resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>"/>
	<input type="hidden" name="coEmail"			id="coEmail"		value="<c:out value="${resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>"/>
	<input type="hidden" name="coUserNm"		id="coUserNm"		value="<c:out value="${resultView.wrkMembNm }"/>"/>
	<input type="hidden" name="creBy"			id="creBy"			value="<c:out value="${resultView.creBy }"/>"/>
	<input type="hidden" name="returnReason"	id="returnReason"	value=""/>
	<input type="hidden" name="ldadngUuid"		id="ldadngUuid"		value=""/>
	<input type="hidden" name="resultChk"		id="resultChk"		value="<c:out value="${resultView.resultChk }"/>"/>
	<input type="hidden" name="listPagePre"		id="listPagePre"	value="/supves/supCertificateList.do"/>
	<input type="hidden" name="pageIndex"		id="pageIndex"		value="<c:out value='${param.pageIndex}' default='1' />" />
	<input type="hidden" name="pageIndex1"		id="pageIndex1"		value="<c:out value='${param.pageIndex1}' default='1' />" />
	<input type="hidden" name="pageIndex2"		id="pageIndex2"		value="<c:out value='${param.pageIndex2}' default='1' />" />
	<input type="hidden" name="sumCheckAmount"	id="sumCheckAmount"		value="" />
	<input type="hidden" name="sumCheckAmount1"	id="sumCheckAmount1"	value="" />
	<input type="hidden" name="sumCheckAmount2"	id="sumCheckAmount2"	value="" />

	<div class="cont_block">
		<!-- 페이지 위치 -->
		<div class="location compact">
			<!-- 네비게이션 -->
			<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
			<!-- 네비게이션 -->
			<div class="ml-auto">
				<c:if test="${(svcexVO.stateCd eq 'B' || svcexVO.stateCd eq 'C') && viewYn}">
	            	<button type="button" class="btn_sm btn_primary bnt_modify_auth" onclick="doApprove();">승인</button>
	            	<button type="button" class="btn_sm btn_primary bnt_modify_auth" onclick="doReturn();">반려</button>
	            	<button type="button" class="btn_sm btn_primary bnt_modify_auth" onclick="doDel();">삭제</button>
	            </c:if>
	            <c:if test="${(svcexVO.manCreYn eq 'Y' && svcexVO.stateCd eq 'A') && viewYn}">
	            	<button type="button" class="btn_sm btn_primary bnt_modify_auth" onclick="doDel();">삭제</button>
	            </c:if>
	            <c:if test="${(svcexVO.stateCd eq 'E' || svcexVO.stateCd eq 'F')}">
					<c:if test="${resultView.issueNo ne '' && viewYn}">
						<button type="button" class="btn_sm btn_primary" onclick="doPrint();">인쇄</button>
						<button type="button" class="btn_sm btn_primary" onclick="doDtlPrint();">상세인쇄</button>
					</c:if>
				</c:if>
			</div>
				<div class="ml-15">
					<button type="button" class="btn_sm btn_secondary" onclick="doList();">목록</button>
				</div>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:15%;" />
				<col style="width:35%;" />
				<col style="width:15%;" />
				<col />
			</colgroup>
			<tbody>
				<c:if test="${not empty returnDataList }">
					<c:forEach items="${returnDataList }" var="list" varStatus="status">
						<tr>
							<th>
								<c:choose>
									<c:when test="${svcexVO.stateCd eq 'D' && (fn:length(returnDataList) == (status.index+1)) }">
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
								<c:out value="${list.returnReason }"/>
							</td>
						</tr>
					</c:forEach>
					<tr><td colspan="4"></td></tr>
				</c:if>
				<tr>
					<th>회사명</th>
					<td><c:out value="${resultView.companyNm}"/></td>
					<th>대표자명</th>
					<td><c:out value="${resultView.presidentNm }"/></td>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td><c:out value="${fn:substring(resultView.enterRegNo,0,3)}"/>-<c:out value="${fn:substring(resultView.enterRegNo,3,5)}"/>-<c:out value="${fn:substring(resultView.enterRegNo,5,10)}"/></td>
					<th>무역업고유번호</th>
					<td><c:out value="${resultView.bsNo}"/></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3">(<c:out value="${resultView.zipCd }"/>) <c:out value="${resultView.addr1 }"/> <c:out value="${resultView.addr2 }"/></td>
				</tr>
				<tr>
					<th>사업자등록증</th>
					<td colspan="3">
						<input type="hidden" name="attFileId" id="attFileId" value="<c:out value="${resultView.attFileId }"/>">
						<c:forEach var="fileList" items="${fileListRow}" varStatus="status">
							<c:out value="${(status.index+1) }"/> :  <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="supves_${fileList.fileId}_${fileList.fileNo}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</c:forEach>
					</td>
				</tr>
				<tr><td colspan="4"></td></tr>
				<tr>
					<th>담당자명</th>
					<td><c:out value="${resultView.wrkMembNm }"/></td>
					<th>핸드폰</th>
					<td>
						<c:choose>
							<c:when test="${not empty resultView.coHp1}">
								<c:out value="${resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${resultView.coHpOld }"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td>
						<c:out value="${resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>
					</td>
					<th>발급상태</th>
					<td><c:out value="${resultView.issueNm }"/></td>
				</tr>
				<tr><td colspan="4"></td></tr>
				<tr>
					<th>적재허가서</th>
					<td><date><c:out value="${resultView.amountSdate }"/></date> ~ <date><c:out value="${resultView.amountEdate }"/></date></td>
					<th>기존실적 포함 출력 여부</th>
					<td><c:out value="${resultView.oriDataNm }"/></td>
				</tr>
				<tr>
					<th>수출입계약서</th>
					<td colspan="3">
						<input name="loadingPermitAttFileId" id="loadingPermitAttFileId" type="hidden" value="<c:out value="${resultView.loadingPermitAttFileId }"/>">
						<c:forEach var="fileList" items="${loadingPermitAttFileListRow}" varStatus="status">
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
					<th>달러화 인보이스</th>
					<td colspan="3">
						<input name="invoiceAttFileId" id="invoiceAttFileId" type="hidden" value="<c:out value="${resultView.invoiceAttFileId }"/>">
						<c:forEach var="fileList" items="${invoiceAttFileListRow}" varStatus="status">
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
		</table>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="totalCnt" class="total_count"></div>

			<fieldset class="ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectList1Sheet,'선용품 신청내역 상세조회 적재1','');">엑셀 다운</button>

				<select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>

			</fieldset>
		</div>

		<div id="selectList1" class="sheet"></div>
		<div id="paging" class="paging ibs"></div>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="totalCnt1" class="total_count"></div>

			<fieldset class="ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectList2Sheet,'선용품 신청내역 상세조회 적재2','');">엑셀 다운</button>

				<select id="pageUnit1" name="pageUnit1" onchange="doSearch1();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit1 eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>

			</fieldset>
		</div>

		<div id="selectList2" class="sheet"></div>
		<div id="paging1" class="paging ibs"></div>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<div id="totalCnt2" class="total_count"></div>

			<fieldset class="ml-auto">
				<button type="button" id="btnExcel3" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(selectList3Sheet,'선용품 신청내역 상세조회 적재3','');">엑셀 다운</button>

				<select id="pageUnit2" name="pageUnit2" onchange="doSearch2();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit2 eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>

			</fieldset>
		</div>

		<div id="selectList3" class="sheet"></div>
		<div id="paging2" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">
	var f = document.form1;

	$(document).ready(function(){
		selectList1();
		selectList2();
// 		var oriDataYn = "${resultView.oriDataYn}";
		var oriDataYn = '<c:out value="${resultView.oriDataYn}"/>';
		if( oriDataYn == "Y" ) {
			selectList3();
		}else{
			$("#btnExcel3").hide();
			$("#pageUnit2").hide();
		}
	});

	function doSearch() { goPage(1); }
	function doSearch1() { goPage1(1); }
	function doSearch2() { goPage2(1); }

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		selectList1();
	}

	function goPage1(pageIndex) {
		f.pageIndex1.value = pageIndex;
		selectList2();
	}

	function goPage2(pageIndex) {
		f.pageIndex2.value = pageIndex;
		selectList3();
	}

	function selectList1() {
		var sumNum = 0;
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/supves/selectCrtfLdadngList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				f.sumCheckAmount.value = data.sumCheckAmount;

				setPaging(
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

// 				apllyDetailViewList1.LoadSearchData({Data: data.resultList}, {Wait: 0});
				setGrid1(data);
			}
		});
	}
	function setGrid1(data){

		if (typeof selectList1Sheet !== "undefined" && typeof selectList1Sheet.Index !== "undefined") {
			selectList1Sheet.DisposeSheet();
		}
// 		var svcexVO = data.svcexVO;
		var	ibHeader1 = new IBHeader();
		ibHeader1.addHeader({Header: '적재신청번호',	SaveName: 'ldadngNo',			Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader1.addHeader({Header: '선명',			SaveName: 'shipNm',				Type: 'Text',	Width: 13,	Align: 'Center', Cursor:"Pointer"});
		ibHeader1.addHeader({Header: '목적항',		SaveName: 'destinationPort',	Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader1.addHeader({Header: '국적',			SaveName: 'nationalty',			Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader1.addHeader({Header: '금액($)',		SaveName: 'amount',				   Type: 'Int',	Width: 12,	Align: 'Center'});
		ibHeader1.addHeader({Header: 'landingUid',		SaveName: 'ldadngUuid',			Type: 'Text',	Width: 12,	Align: 'Center', Hidden: true });

		ibHeader1.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0 });
		ibHeader1.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container1 = $('#selectList1')[0];
		createIBSheet2(container1, 'selectList1Sheet', '100%', '100%');
		ibHeader1.initSheet('selectList1Sheet');
		selectList1Sheet.SetSelectionMode(4);
		selectList1Sheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
	}

	function selectList2() {
		var sumNum = 0;
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/supves/selectCheckItemList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt1').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				f.sumCheckAmount1.value = data.sumCheckAmount;

				setPaging(
					'paging1'
					, goPage1
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				setGrid2(data);
			}
		});
	}
	function setGrid2(data){

		if (typeof selectList2Sheet !== "undefined" && typeof selectList2Sheet.Index !== "undefined") {
			selectList2Sheet.DisposeSheet();
		}
		var	ibHeader2 = new IBHeader();
		ibHeader2.addHeader({Header: '적재신청번호',	SaveName: 'ldadngNo',			Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader2.addHeader({Header: '품목번호',		SaveName: 'itemId',				Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader2.addHeader({Header: '허가일자',		SaveName: 'permissionDate',		Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader2.addHeader({Header: '수량',			SaveName: 'quantity',			Type: 'Text',	Width: 13,	Align: 'Center'});
		ibHeader2.addHeader({Header: '금액($)',		SaveName: 'amount',				Type: 'Int',	Width: 12,	Align: 'Center'});
		ibHeader2.addHeader({Header: 'HS 부호(4단위)',	SaveName: 'hsNm',				Type: 'Text',	Width: 7,	Align: 'Center'});

		ibHeader2.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0 });
		ibHeader2.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container2 = $('#selectList2')[0];
		createIBSheet2(container2, 'selectList2Sheet', '100%', '100%');
		ibHeader2.initSheet('selectList2Sheet');
		selectList2Sheet.SetSelectionMode(4);
		selectList2Sheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
	}

	function selectList3() {
		var sumNum = 0;
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/supves/selectOriDataList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt2').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');
				f.sumCheckAmount2.value = data.sumCheckAmount;

				setPaging(
					'paging2'
					, goPage2
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				setGrid3(data);
			}
		});
	}
	function setGrid3(data){

		if (typeof selectList3Sheet !== "undefined" && typeof selectList3Sheet.Index !== "undefined") {
			selectList3Sheet.DisposeSheet();
		}
		var	ibHeader3 = new IBHeader();
		ibHeader3.addHeader({Header: '적재허가신청번호',	SaveName: 'ldadngNo',			Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader3.addHeader({Header: '품목번호',		SaveName: 'itemId',				Type: 'Text',	Width: 13,	Align: 'Center'});
		ibHeader3.addHeader({Header: '수량',			SaveName: 'quantity',			Type: 'Text',	Width: 14,	Align: 'Center'});
		ibHeader3.addHeader({Header: '대상국가(선명)',	SaveName: 'nationaltyShipNm',	Type: 'Text',	Width: 8,	Align: 'Center'});
		ibHeader3.addHeader({Header: '금액($)',		SaveName: 'amount',				Type: 'Int',	Width: 12,	Align: 'Center'});
		ibHeader3.addHeader({Header: 'HS 부호',		SaveName: 'hsCd',				Type: 'Text',	Width: 7,	Align: 'Center'});

		ibHeader3.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode : 0 });
		ibHeader3.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container3 = $('#selectList3')[0];
		createIBSheet2(container3, 'selectList3Sheet', '100%', '100%');
		ibHeader3.initSheet('selectList3Sheet');
		selectList3Sheet.SetSelectionMode(4);
		selectList3Sheet.LoadSearchData({Data: data.resultList}, {Wait: 0});
	}

	function selectList1Sheet_OnSearchEnd(code, msg, stCode, stMsg, responseText) {
		var lastLow = selectList1Sheet.GetDataLastRow();
		var transNumber = f.sumCheckAmount.value;

		if (code != 0) {
		}else{
			// 볼드 처리
			selectList1Sheet.SetColFontBold('shipNm', 1);
		}
		if( lastLow > 0 ) {
			transNumber = transNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			selectList1Sheet.ShowFooterRow([ {} ]);
			selectList1Sheet.SetCellText(lastLow+1, 0, "합계");
			selectList1Sheet.SetCellText(lastLow+1, 4, transNumber);
		}
	}

	function selectList2Sheet_OnSearchEnd(code, msg, stCode, stMsg, responseText) {
		var lastLow = selectList2Sheet.GetDataLastRow();
		var transNumber = f.sumCheckAmount1.value;

		if( lastLow > 0 ) {
			transNumber = transNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			selectList2Sheet.ShowFooterRow([ {} ]);
			selectList2Sheet.SetCellText(lastLow+1, 0, "합계");
			selectList2Sheet.SetCellText(lastLow+1, 4, transNumber);
		}
	}

	function selectList3Sheet_OnSearchEnd(code, msg, stCode, stMsg, responseText) {
		var lastLow = selectList3Sheet.GetDataLastRow();
		var transNumber = f.sumCheckAmount2.value;

		if( lastLow > 0 ) {
			transNumber = transNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			selectList3Sheet.ShowFooterRow([ {} ]);
			selectList3Sheet.SetCellText(lastLow+1, 0, "합계");
			selectList3Sheet.SetCellText(lastLow+1, 4, transNumber);
		}
	}
	function selectList1Sheet_OnClick(row, col, value, cellX, cellY, cellW, cellH) {
		if( row > 0 ) {
			if( selectList1Sheet.ColSaveName(col) == "shipNm" ) {
				f.ldadngUuid.value = selectList1Sheet.GetCellValue(row , 'ldadngUuid');
				selectList2();
			}
		}
	}
	// 목록
	function doList() {
		var url = f.listPagePre.value;
		f.action = url;
		f.target = "_self";
		f.submit();
	}

	// 승인
	function doApprove() {
		var chkForm = document.form1;

		if(!confirm("승인 후엔 E-Mail과 알림톡이 발송 됩니다. \n계속 하시겠습니까?")) { return; }
		chkForm.event.value = "APPROVE";

		global.ajaxSubmit($('#form1'), {
			type : 'POST'
			, url : '<c:url value="/supves/insertApplyListSave.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//alert("승인 처리가 완료되었습니다.");
				doList();
	        }
		});
	}

	// 반려
	function doReturn() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/svcex/svcexCertificate/popup/applyReturnView.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if( resultObj ) {
					doReturnSave(resultObj);
				}
			}
		});
	}
	function doReturnSave(result) {
		f.returnReason.value = result;
		f.event.value = "RETURN";

		global.ajaxSubmit($('#form1'), {
			type : 'POST'
			, url : '<c:url value="/supves/insertReturnDetail.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//alert("반려 처리가 완료되었습니다.");
				doList();
	        }
		});
	}

	// 삭제
	function doDel() {
		if(!confirm("삭제하시겠습니까?")) { return; }
		f.event.value = "DELETE";

		global.ajaxSubmit($('#form1'), {
			type : 'POST'
			, url : '<c:url value="/supves/insertApplyListSave.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//alert("삭제 처리가 완료되었습니다.");
				doList();
	        }
		});
	}

	//인쇄
	function doPrint(){
		if( !confirm( "인쇄 하시겠습니까?" ) ){
			return;
		}

		var reqstUuid = f.reqstUuid.value;
		var reqno = f.reqno.value;
		var oriDataYn = '<c:out value="${resultView.oriDataYn}"/>';

		if(oriDataYn == '포함') {
			oriDataYn = 'Y';
		} else {
			oriDataYn = 'N';
		}

		var resultYn = 'N';
		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 780;
		nHeight = 550;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "https://membership.kita.net/supvesPrint.do?ONLYVIEW=N";
		strUrl +=	 "&REQST_UUID="+reqstUuid;
		strUrl +=	 "&REQNO="+reqno;
		strUrl +=	 "&USER=ADMIN" ;
		strUrl +=	 "&P_CNT=3";
		strUrl +=	 "&CERT_PERIOD=201301201312";
		strUrl +=	 "&CTR_CD=&HS_CD=&MT_CD=";
		strUrl +=	 "&IE_SUB_CODE=1000";

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no');
	}
	function doDtlPrint() {
		if( !confirm( "인쇄 하시겠습니까?" ) ) {
			return;
		}

		var reqstUuid = f.reqstUuid.value;
		var reqno = f.reqno.value;
		var oriDataYn = '<c:out value="${resultView.oriDataYn}"/>';

		if(oriDataYn == '포함') {
			oriDataYn = 'Y';
		} else {
			oriDataYn = 'N';
		}

		var resultYn = 'N';

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 780;
		nHeight = 550;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "https://membership.kita.net/supvesDtlPrint.do?ONLYVIEW=N";
		strUrl +=	 "&REQST_UUID="+reqstUuid;
		strUrl +=	 "&REQNO="+reqno;
		strUrl +=	 "&USER=ADMIN" ;
		strUrl +=	 "&P_CNT=3";
		strUrl +=	 "&CERT_PERIOD=201301201312";
		strUrl +=	 "&CTR_CD=&HS_CD=&MT_CD=";
		strUrl +=	 "&IE_SUB_CODE=1000";

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no');
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
