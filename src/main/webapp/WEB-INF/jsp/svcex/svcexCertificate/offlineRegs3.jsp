<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />

<form id="viewForm" name="viewForm" method="post">
	<input type="hidden" name="event"				id="event" />
	<input type="hidden" name="memberId"			id="memberId"			value = "<c:out value="${ resultView.memberId}"/>"  >
	<input type="hidden" name="bsNo"				id="bsNo"				value = "<c:out value="${ resultView.bsNo}"/>"  />
	<input type="hidden" name="contractAttFileId"	id="contractAttFileId"	value = "<c:out value="${ resultView.contractAttFileId}"/>"/>
	<input type="hidden" name="currencyAttFileId"	id="currencyAttFileId"	value = "<c:out value="${ resultView.currencyAttFileId}"/>"/>
	<input type="hidden" name="etcAttFileId"		id="etcAttFileId"		value = "<c:out value="${ resultView.etcAttFileId}"/>"/>
	<input type="hidden" name="reqno"				id="reqno"				value = "<c:out value="${ resultView.reqno}"/>"  >
	<input type="hidden" name="stateCd"				id="stateCd"			value = "<c:out value="${ resultView.stateCd}"/>"/>
	<input type="hidden" name="expImpNm"			id="expImpNm"			value = "<c:out value="${ resultView.expImpNm}"/>"/>
	<input type="hidden" name="coHp"				id="coHp"				value = "<c:out value="${ resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>"/>
	<input type="hidden" name="coEmail"				id="coEmail"			value = "<c:out value="${ resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>"/>
	<input type="hidden" name="coUserNm"			id="coUserNm"			value = "<c:out value="${ resultView.wrkMembNm}"/>"/>
	<input type="hidden" name="transportServiceCd"	id="transportServiceCd"	value = "<c:out value="${ svcexVO.transportServiceCd}"/>"/>
	<input type="hidden" name="editYn"				id="editYn"				value = "<c:out value="${ editYn }"/>"/>
	<input type="hidden" name="fileId"				id="fileId"				value="">
	<input type="hidden" name="fileInputName"		id="fileInputName"		value="">
	<!-- 메일발송여부 구분 0:메일발송 1:메일발송 안함 -->
	<input type="hidden" name="updateType" value="0"/>

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<c:choose>
				<c:when test="${ editYn eq 'N' || resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave('3');">수정</button>
					<button type="button" class="btn_sm btn_secondary" onclick="doPrvDetailPage();">이전</button>
				</c:when>
				<c:otherwise>
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave('1');">임시저장</button>
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave('2');">다음</button>
					<button type="button" class="btn_sm btn_secondary" onclick="doPrvPage();">이전</button>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>회사명</th>
					<td><c:out value="${resultView.companyKor }"/></td>
					<th>무역업고유번호</th>
					<td><c:out value="${resultView.memberId }"/></td>
				</tr>

				<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
				<tr>
					<th>수출입실적 확인기간<strong class="point">*</strong></th>
					<td>
						<fmt:parseDate value="${resultView.amountSdate}" var="amountSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView.amountEdate}" var="amountEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${amountSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${amountEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" name="amountSdate" id="amountSdate" value="${resultView.amountSdate}"/>
						<input type="hidden" name="amountEdate" id="amountEdate" value="${resultView.amountEdate}"/>
					</td>
					<th>계약서상 계약일자</th>
					<td>
						<fmt:parseDate value="${resultView.settleDate}" var="settleDate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${settleDate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" name="settleDate" id="settleDate" value="${resultView.settleDate}" />
					</td>
				</tr>
				</c:if>

				<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
				<tr>
					<th>수출입실적 확인기간 <strong class="point">*</strong></th>
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView.amountSdate}" var="amountSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="amountSdate" id="amountSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${amountSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView.amountEdate}" var="amountEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="amountEdate" id="amountEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${amountEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					<th>계약서상 계약일자</th>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<fmt:parseDate value="${resultView.settleDate}" var="dateValue" pattern="yyyyMMdd"/>
								<input type="text" class="txt datepicker" name="settleDate" id="settleDate"  size="10" maxlength="8" value="<fmt:formatDate value="${dateValue}" pattern="yyyy-MM-dd"/>" desc="계약서상 계약일자" isrequired="true" >
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
						</div>
					</td>
				</tr>
				</c:if>

				<tr>
					<th>발급용도</th>
					<td colspan="3">
						<input type="text" class="form_text w100p" name="issueUse" id="issueUse"   maxlength="300" value="<c:out value="${resultView.issueUse }"/>" desc="발급용도" isrequired="true">
					</td>
				</tr>
				<tr>
					<th>수출입 계약서 <strong class="point">*</strong></th>
					<td colspan="3">
						<div class="form_row w100p">

						<c:if test="${!empty fileList1Row}" >
						    <div id="contractAttFileList" name="contractAttFileList" class="w100p">
							    <c:forEach var="fileList" items="${fileList1Row}" varStatus="status">
							    	<p class="file_list">
								    	<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
										<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
											<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
										</button>
							    	</p>
								</c:forEach>
						    </div>
						</c:if>
						<c:if test="${empty fileList1Row}" >
							<div id="contractAttFileList" name="contractAttFileList" class="w100p"></div>
						</c:if>
						<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
							<button class="btn_tbl" type="button" onclick="viewFiles('contractAttFileId');">찾아보기</button>
						</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th>은행이 발급한<br>외화매입 증명서류 <strong class="point">*</strong></th>
					<td colspan="3">
						<div class="form_row w100p">
						<c:if test="${!empty fileList2Row}" >
							<div id="currencyAttFileList" name="currencyAttFileList" class="w100p">
								<c:forEach var="fileList" items="${fileList2Row}" varStatus="status">
									<p>
										<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
										<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
											<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
										</button>
									</p>
								</c:forEach>
							</div>
						</c:if>
						<c:if test="${empty fileList2Row}" >
							<div id="currencyAttFileList" name="currencyAttFileList" class="w100p"></div>
						</c:if>
						<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
							<button class="btn_tbl" type="button" onclick="viewFiles('currencyAttFileId');">찾아보기</button>
						</c:if>
						</div>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<!-- 전체 게시글 -->
			<!-- <div id="totalCnt" class="total_count"></div> -->
			<fieldset class="ml-auto form_row">

			<c:if test="${editYn ne 'N' }">
				<div class="form_row">
					<span class="prepend">입금 건수 만큼 라인추가</span>
					<input type="text" class="form_text" name="addRowCnt" id="addRowCnt" maxlength="300" value="1" desc="추가 수" style="width:60px;">
				</div>
				<button class="btn_sm btn_primary ml-8" type="button" id="addDetailListRow" onclick="fn_addDetailListRow();">추가</button>
			</c:if>

				<!-- <button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(apllyListSheet,'한국무역협회 무역지원서비스','');">Excel</button> -->

				<%-- <select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select> --%>
			</fieldset>
		</div>

		<div id="detailList1" class="sheet"></div>
		<!-- <div id="paging" class="paging ibs"></div> -->
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<fieldset class="ml-auto">
			</fieldset>
		</div>

		<div id="detailList2" class="sheet"></div>
		<!-- <div id="paging" class="paging ibs"></div> -->
	</div>

</form>

<script type="text/javascript">
	var f;
	var	ibHeader1 = new IBHeader();
	var	ibHeader2 = new IBHeader();

	ibHeader1.addHeader({Header: '상태',			Type: 'Status',		SaveName: 'status',				Width: 4,	Align: 'Center', Hidden : true});
	ibHeader1.addHeader({Header: 'SEQ_NO',		Type: 'Text',		SaveName: 'seqNo',				Width: 4,	Align: 'Center', Hidden : true});
	ibHeader1.addHeader({Header: '삭제',			Type: 'DelCheck',	SaveName: 'delFlag',			Width: 4,	Align: 'Center', Edit:true });
	ibHeader1.addHeader({Header: '구분',			Type: 'Text',		SaveName: 'expImpNm',			Width: 4,	Align: 'Center', KeyField:true });
	ibHeader1.addHeader({Header: '품목코드(용역명)',	Type: 'Text',		SaveName: 'itemCd',				Width: 10,	Align: 'Center', KeyField:true, Hidden : true });
	ibHeader1.addHeader({Header: '품목명(용역명)',	Type: 'Popup',		SaveName: 'itemNm',				Width: 13,	Align: 'Center', PopupButton: true, KeyField:true });
	ibHeader1.addHeader({Header: '거래형태', 		Type: 'Combo',		SaveName: 'tradePatternCd',		Width: 15,	Align: 'Center', Edit:true, KeyField:true, ComboCode: "${tradePatternStr.detailcd}", ComboText: "${tradePatternStr.detailnm}" });
	ibHeader1.addHeader({Header: '확인금액($)', 	Type: 'AutoSum',	SaveName: 'checkAmount',		Width: 8,	Align: 'Center', EditLen:9, AcceptKeys: "N" ,Edit:true, KeyField:true });
	ibHeader1.addHeader({Header: '거래외국환은행',	Type: 'Combo',		SaveName: 'foreignBank',		Width: 8,	Align: 'Center', Edit:true, KeyField:true, ComboCode: "${foreignBankStr.detailcd}", ComboText: "${foreignBankStr.detailnm}" });
	ibHeader1.addHeader({Header: '거래번호',		Type: 'Text',		SaveName: 'businessNo',			Width: 8,	Align: 'Center', Edit:true, KeyField:true });
	ibHeader1.addHeader({Header: '대상국가코드',	Type: 'Text',		SaveName: 'targetCountryCd',	Width: 7,	Align: 'Center', KeyField:true, Hidden:true });
	ibHeader1.addHeader({Header: '대상국가',		Type: 'Popup',		SaveName: 'targetCountryNm',	Width: 13,	Align: 'Center', Edit:true, KeyField:true  });
	ibHeader1.addHeader({Header: '입금일자',		Type: 'Date',		SaveName: 'contractDate',		Width: 10,	Align: 'Center', Edit:true, KeyField:true, Format:"yyyy-MM-dd", EditLen:10 });
	ibHeader1.addHeader({Header: '거래업체명',		Type: 'Text',		SaveName: 'coNm',				Width: 8,	Align: 'Center', Edit:true, KeyField:true});

	ibHeader2.addHeader({Header: '수출입구분',		Type: 'Text',		SaveName: 'expImpNm',			Width: 6,	Align: 'Center'});
	ibHeader2.addHeader({Header: '품목명(용역명)',	Type: 'Text',		SaveName: 'itemNm',				Width: 13,	Align: 'Center'});
	ibHeader2.addHeader({Header: '거래형태',		Type: 'Text',		SaveName: 'tradePatternNm',		Width: 7,	Align: 'Center'});
	ibHeader2.addHeader({Header: '확인금액',		Type: 'AutoSum',	SaveName: 'checkAmount',		Width: 8,	Align: 'Center', EditLen:9 });
	ibHeader2.addHeader({Header: '거래외국환은행',	Type: 'Text',		SaveName: 'foreignBank',		Width: 8,	Align: 'Center'});
	ibHeader2.addHeader({Header: '거래번호',		Type: 'Text',		SaveName: 'businessNo',			Width: 8,	Align: 'Center'});
	ibHeader2.addHeader({Header: '대상국가',		Type: 'Text',		SaveName: 'targetCountryNm',	Width: 7,	Align: 'Center'});
	ibHeader2.addHeader({Header: '계약일자',		Type: 'Text',		SaveName: 'settleDate',			Width: 6,	Align: 'Center'});
	ibHeader2.addHeader({Header: '입금일자',		Type: 'Text',		SaveName: 'contractDate',		Width: 10,	Align: 'Center'});
	ibHeader2.addHeader({Header: '거래업체명',		Type: 'Text',		SaveName: 'coNm',				Width: 8,	Align: 'Center'});



	ibHeader1.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0 });
	ibHeader1.setHeaderMode({ Sort:0, ColMove:false, HeaderCheck:false, ColResize:false });

	ibHeader2.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0 });
	ibHeader2.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});


	$(document).ready(function(){
		f = document.viewForm;
		var container1 = $('#detailList1')[0];
		createIBSheet2(container1, 'detailList1', '100%', '100%');
		ibHeader1.initSheet('detailList1');

		var container2 = $('#detailList2')[0];
		createIBSheet2(container2, 'detailList2', '100%', '100%');
		ibHeader2.initSheet('detailList2');
		detailList2.SetVisible(false);

		selectDetailList1();
		selectDetailList2();

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			//f.contractAttFileList.style.backgroundColor = "#ffffff";
			//f.currencyAttFileList.style.backgroundColor = "#ffffff";
		}else{
			$("#contractAttFileList").next('button').attr("onclick","");
			$("#currencyAttFileList").next('button').attr("onclick","");
		}

	});

	function doNextPage(){
		f.event.value = "";
		f.action = "/svcex/svcexCertificate/offlineRegsView.do";
		f.target = "_self";
		f.submit();
	}
	function doPrvPage(){
		if(!confirm("이전 페이지로 이동 하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/offlineRegsProcessView.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if( data.resultView.chkCnt > 0 ){
					f.fileId.value = "";
					f.fileInputName.value = "";
					f.event.value = "";
					f.action = '<c:url value="/svcex/svcexCertificate/offlineRegs2View.do" />';
					f.target = '_self';
					f.submit();
				}

			}
		});
	}
	function doPrvDetailPage(){
		var pathname = window.location.pathname;

		if(!confirm("이전 페이지로 이동 하시겠습니까?")){
			return;
		}

		var url = "";
		if ( pathname.includes('selectUpdateDetail') ){
			url = "/svcex/svcexCertificate/applyList.do";
			f.event.value = "";
		}else if ( pathname.includes('applyDetailIssueCheckUpdate')) {
			url = "/svcex/svcexCertificate/issueCheckList.do";
			f.event.value = "";
		}else{
			url = "/svcex/svcexCertificate/applyDetailView.do"
			f.event.value= "SIMSA";
		}
		f.action = url
		f.target = "_self";
		f.submit();
	}
	function doCurrPage(){
		f.event.value = "";
		f.action = "/svcex/svcexCertificate/offlineRegs3View.do";
		f.target = "_self";
		f.submit();
	}

	function selectDetailList1() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/offlineRegs3Detail1DataList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				detailList1.LoadSearchData({Data: data.resultList}, {Wait: 0});
			}
		});
	}
	function selectDetailList2() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/offlineRegs3Detail1TermDataList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if( data.resultList.length > 0 ) {
					detailList2.SetVisible(true);
					detailList2.LoadSearchData({Data: data.resultList}, {Wait: 0});
				}
			}
		});
	}

	// 행 추가
	function fn_addDetailListRow() {
		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			var addCnt = f.addRowCnt.value;
			var expImpNm = f.expImpNm.value;
			var lastLow = detailList1.GetDataLastRow();

			for(var i=0; addCnt > i; i++){
				var index = detailList1.DataInsert(-1);
				if( lastLow > 0 ){
					var lastData = detailList1.GetRowData( detailList1.GetDataLastRow()-1 );
					detailList1.SetRowData( index, lastData );
				}else{
					detailList1.SetRowData( index, { expImpNm: expImpNm} );
				}
				// 편집을 할수 있도록 변경
//	 			detailList1.SetCellEditable(index, 'tradePatternNm', 1);
			}
		}
	}

	function detailList1_OnPopupClick(row,col) {
		if( detailList1.ColSaveName(col) == "itemNm" ) {
			viewPopup('Article', row, col);
		}else if( detailList1.ColSaveName(col) == "targetCountryNm" ) {
			viewPopup('Country', row, col);
		}
	}

	function viewPopup(gubun, row, col) {
		var popupUrl;
		if( gubun == "Article" ) {
			popupUrl = '<c:url value="/svcex/svcexCertificate/popup/searchArticleView.do" />';
		}else if( gubun == "Country" ) {
			popupUrl = '<c:url value="/svcex/svcexCertificate/popup/searchCountryView.do" />';
		}else{
			return;
		}

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : popupUrl
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if( gubun == "Article" ) {
					detailList1.SetCellValue(row, col-1, resultObj[0]);
					detailList1.SetCellValue(row, col, resultObj[1]);
				}else if( gubun == "Country" ) {
					detailList1.SetCellValue(row, col-1, resultObj[0]);
					detailList1.SetCellValue(row, col, resultObj[1]);
				}
// 				f.targetCountryCd.value = resultObj[0];
// 				f.targetCountryNm.value = resultObj[1];
			}
		});
	}

	// 수출입실적 확인기관 validation
	function doChangeVal(i,obj){
		var d1 = f.amountSdate; //수출입실적 확인기간
		var d2 = f.amountEdate; //수출입실적 확인기간
		if(!checkDate(obj)) {
			if(i == 1){
				d1.value = "";
			}else if(i == 2){
				d2.value = "";
			}
			return;
		}

		if(d1.value != "" && d2.value != ""){
			if(d1.value > d2.value){
				if(i == 1){
					alert("수출입실적 확인기간 시작일이 종료일보다 큽니다.");
					d1.value = "";
					return;
				}else if(i == 2){
					alert("수출입실적 확인기간 시작일이 종료일보다 큽니다.");
					d2.value = "";
					return;
				}
			}else{
// 				goPage2(1);
				selectDetailList2();
			}
		}
	}

	// 저장 프로세스 gubun 1: 임시저장 2: 승인 3: 수정
	function doSave(gubun){
		var d1 = f.amountSdate; //수출입실적 확인기간
		var d2 = f.amountEdate; //수출입실적 확인기간

		if (gubun == "3"){
			var issueUse = "${resultView.issueUse }";
			if ( $("#issueUse").val() == issueUse ){
				alert("수정 사항이 없습니다.");
				return false;
			}
			f.event.value = "TradeConfirmation3UpdateEnd";
			if(!confirm("수정하시겠습니까?")){ return; }

			var viewFormSO = $('#viewForm').serializeObject();

		}else{

			if( !isValid() ) { return; };
			if ( $("#amountSdate").val() =="" || $("#amountSdate").length == 0 ){
				alert("수출입실적 확인 시작일자를 입력하세요.");
				f.amountSdate.focus();
				return false;
			}
			if ( $("#amountEdate").val() =="" || $("#amountEdate").length == 0 ){
				alert("수출입실적 확인 종료일자를 입력하세요.");
				f.amountEdate.focus();
				return false;
			}
			//if( !checkDate(d1) ) { return; };
			//if( !checkDate(d2) ) { return; };
			var saveJson = detailList1.GetSaveJson();
			if (saveJson.Code == 'KeyFieldError') return false;
			if (saveJson.Code == 'InvalidInputError') return false;

			if( !detailListValueCheck(saveJson) ) { return; };

			if(gubun == "2" ){
				if(!confirm("승인 후엔 E-Mail과 알림톡이 발송 됩니다. \n계속 하시겠습니까?")){ return; }
			}else{
				if(!confirm("저장하시겠습니까?")){ return; }
			}

			if(gubun == "1" ){
				f.event.value = "TradeConfirmation3Update";
			}else if( gubun == "3" ){
				f.event.value = "TradeConfirmation3UpdateEnd";
			}else{
				f.stateCd.value = "E";
				f.event.value = "TradeConfirmation3UpdateNext";
			}

			var viewFormSO = $('#viewForm').serializeObject();
			if (saveJson.data.length) {
				var map = {};
				var list = [];
				$.each(saveJson, function(key1, value1) {
					map = {};
					$.each(value1, function(key2, value2) {
						if (key2 == "contractDate"){
							value2 = value2.contractDate.replace(/-/gi,'');
						}
						map = value2;
						list.push(map);
					});

					viewFormSO['dataList'] = list;
				});
			}
		}
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/insertOfflineReg3Save.do" />'
			, data : JSON.stringify(viewFormSO)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){
				var eventCode = f.event.value;
				if( eventCode == "TradeConfirmation3Update" ){
					//alert("임시저장 신청이 완료되었습니다.");
					doCurrPage();
				}else if( eventCode == "TradeConfirmation3UpdateEnd" ) {
					//alert("수정이 완료되었습니다.");
					doPrvDetailPage();
					//doCurrPage();
				}else if( eventCode = "TradeConfirmation3UpdateNext" ) {
					//alert("저장이 완료되었습니다.\n다음 페이지로 이동합니다.");
					doNextPage();
				}

			}
		});
	}

	function isValid() {
		var amountSdate =  parseInt($('#amountSdate').val().replace(/-/gi,''));
		var amountEdate =  parseInt($('#amountEdate').val().replace(/-/gi,''));
		var settleDate =   parseInt($('#settleDate').val().replace(/-/gi,''));

		if(amountSdate > amountEdate){
			alert("수출입실적 확인기간 날짜를 바르게 입력하십시요");
			f.amountSdate.focus();
			return false;
		}
		if (settleDate == 0) {
			alert("계약서상 계약일자를 입력하세요");
			f.settleDate.focus();
			return false;
		}
		if(settleDate > amountEdate){
			alert("계약서상 계약일자를 바르게 입력하십시오.");
			f.settleDate.focus();
			return false;
		}

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			if( $('#contractAttFileList').text() == ""){
				alert("'수출입 계약서'를 첨부 해야 합니다.");
				return false;
			}
			if( $('#currencyAttFileList').text() == ""){
				alert("'은행이 발급한 외화매입 증명서류'를 첨부 해야 합니다.");
				return false;
			}
		}

		var lastLow = detailList1.GetDataLastRow();
		if( lastLow < 1 ) {
			alert("입금내역을 입력해야 합니다.");
			return false;
		}

		return true;
	}

	function detailListValueCheck(array) {
		var tempArray = array;
		for( i=0; array.data.length > i; i++ ) {
			var businessNo = array.data[i].businessNo;
			var foreignBank = array.data[i].foreignBank;
			var expImpNm = array.data[i].expImpNm;
			var tradePatternCd = array.data[i].tradePatternCd;
			var contractDate = array.data[i].contractDate;
			var compDt =  parseInt(contractDate.replace(/-/gi,''));
			var amountSdate =  parseInt($('#amountSdate').val().replace(/-/gi,''));
			var amountEdate =  parseInt($('#amountEdate').val().replace(/-/gi,''));

			for( j=0; tempArray.data.length > j; j++ ) {
				if( j != i && businessNo == tempArray.data[j].businessNo ) {
					alert("거래번호 : " + businessNo + " 가 중복 되었습니다.");
					return false;
				}
			}

			if( !chkBusinessNo(foreignBank, businessNo, expImpNm, tradePatternCd) ) {
				alert("'거래번호' 형식을 다시 확인 하십시오.");
				return false;
			}

			if( amountSdate > compDt || amountEdate < compDt ) {
				alert("'입금일자'는 수출입 실적 기간 이내에 있어야 합니다.");
				return false;
			}
		}
		return true;
	}

	function chkBusinessNo(bank, no, expImpNm, pattern) {
		if(pattern == "TT" || pattern == "CD" || pattern == "WK") {
			if(bank != "035") {
				var regType1 =  /^[A-za-z0-9]*$/g;
				no = no.replace(/\/-/gi, "");
				if(!regType1.test(no)) {
					return false;
				}
			}

			//수출 타발, 수입 당발 타발 기준
			if("002" == bank) {

				if("1" == expImpNm){
					//수출
					if(no.length != 16)return false;
					if(isNumber(no.substr(0,1)))return false;
					if(isNumber(no.substr(1,1)))return false;
					if(!isNumber(no.substr(2,14)))return false;
				}else{
					//수입
					if(no.length != 16)return false;
					if(isNumber(no.substr(0,1)))return false;
					if(isNumber(no.substr(1,1)))return false;
				}
			}else if("008" == bank) {
				if(no.length == 14 || no.length == 15) {
					if(no.length == 14){
						//수입의경우 1,8,9자리가 문자임... 재확인 필요
						if(no.length != 14)return false;
						if(isNumber(no.substr(5,1)))return false;
						if(isNumber(no.substr(6,1)))return false;
						if(!isNumber(no.substr(0,5)))return false;
						if(!isNumber(no.substr(7,7)))return false;
					}else{
						//수입의경우 1,8,9자리가 문자임... 재확인 필요
						if(no.length != 15)return false;
						if(isNumber(no.substr(6,1)))return false;
						if(isNumber(no.substr(7,1)))return false;
						if(!isNumber(no.substr(0,6)))return false;
						if(!isNumber(no.substr(8,8)))return false;
					}
				} else {
					return false;
				}
			}else if("020" == bank) {
				if(no.length != 16)return false;
				if(isNumber(no.substr(0,1)))return false;
				if(isNumber(no.substr(1,1)))return false;
				if(isNumber(no.substr(8,1)))return false;
				if(!isNumber(no.substr(2,6)))return false;
				if(!isNumber(no.substr(9,7)))return false;
			}else if("019" == bank) {
				if(no.length != 14)return false;
			}else if("003" == bank) {
				if(no.length != 12)return false;
				if(!isNumber(no.substr(0,12)))return false;
			}else if("001" == bank){
				if(no.length != 16)return false;
				if(isNumber(no.substr(4,3)))return false;
				if(isNumber(no.substr(5,1)))return false;
				if(isNumber(no.substr(6,1)))return false;
				if(!isNumber(no.substr(0,4)))return false;
				if(!isNumber(no.substr(7,9)))return false;
			}else if("040" == bank) {
				if(no.length == 13 || no.length == 14) {
					if(no.length == 13){
						if(no.length != 13)return false;
						if(isNumber(no.substr(0,1)))return false;
						if(isNumber(no.substr(1,1)))return false;
						if(isNumber(no.substr(2,1)))return false;
						if(!isNumber(no.substr(3,10)))return false;
					}else{
						if(no.length != 14)return false;
						if(isNumber(no.substr(0,1)))return false;
						if(isNumber(no.substr(1,1)))return false;
						if(isNumber(no.substr(2,1)))return false;
						if(!isNumber(no.substr(3,10)))return false;
					}
				} else {
					return false;
				}
			}else if("138" == bank) {
				if(no.length != 17)return false;
				if(isNumber(no.substr(3,3)))return false;
				if(!isNumber(no.substr(0,3)))return false;
				if(!isNumber(no.substr(6,11)))return false;
			}else if("016" == bank) {
				if(no.length != 16)return false;
				if(isNumber(no.substr(0,1)))return false;
				if(isNumber(no.substr(1,1)))return false;
				if(isNumber(no.substr(2,1)))return false;
				if(!isNumber(no.substr(3,13)))return false;
			}else if("032" == bank) {
				if(no.length != 14)return false;
				if(isNumber(no.substr(3,1)))return false;
				if(isNumber(no.substr(4,1)))return false;
				if(isNumber(no.substr(5,1)))return false;
				if(!isNumber(no.substr(0,3)))return false;
				if(!isNumber(no.substr(6,8)))return false;
			}else if("139" == bank) {

			}else if("140" == bank) {
				if("1" == expImpNm) {
					if(no.length != 8)return false;
					if(isNumber(no.substr(0,1)))return false;
					if(isNumber(no.substr(1,1)))return false;
					if(!isNumber(no.substr(2,6)))return false;
				}else {
					if(no.length != 12)return false;
					if(isNumber(no.substr(0,1)))return false;
					if(isNumber(no.substr(1,1)))return false;
					if(isNumber(no.substr(5,1)))return false;
					if(!isNumber(no.substr(2,3)))return false;
					if(!isNumber(no.substr(6,6)))return false;
				}
			}else if("035" == bank) {
				//수출
				if("1" == expImpNm) {
					if(no.substr(0,3) == "377" || no.substr(0,3) == "311" || no.substr(0,3) == "ITT"  || no.substr(0,4) == "ITTC") {
					} else {
						return false;
					}
				}else{
					if(no.substr(0,3) == "378" || no.substr(0,3) == "OTT" ) {
					} else {
						return false;
					}
				}
				if(no.substr(0,3) == "377" || no.substr(0,3) == "378" || no.substr(0,3) == "311") {
					if(no.length == 10 || no.length == 12) {
						if(no.length == 10){
							if(no.length != 10)return false;
						}else{
							if(no.length != 12)return false;
		 					if(!isNumber(no.substr(0,10))){return false;}
		 					if(no.substr(10,1) != "/"){return false;}
		 					if(!isNumber(no.substr(11,1))){return false;}
						}
					} else {
						return false;
					}
				}else if(no.substr(0,3) == "ITT"){
					if(no.length != 12)return false;

					if(isNumber(no.substr(0,1)))return false;

					if(isNumber(no.substr(1,1)))return false;

					if(isNumber(no.substr(2,1)))return false;

				}else{
					if(no.length != 13)return false;
					if(isNumber(no.substr(0,1)))return false;
					if(isNumber(no.substr(1,1)))return false;
					if(isNumber(no.substr(2,1)))return false;
				}
			}else if("030" == bank){
				if(no.length == 13 ||  no.length == 12)
				{
					if(!isNumber(no.substr(0,3)))return false;
					if(isNumber(no.substr(3,1)))return false;
					if(isNumber(no.substr(4,1)))return false;
					if(isNumber(no.substr(5,1)))return false;
					if(!isNumber(no.substr(6,12)))return false;
				}else{
					return false;
				}
			}else if("025" == bank){

			}else if("022" == bank){
				if(no.length != 12)return false;
				if(!isNumber(no.substr(0,12)))return false;
			}else if("023" == bank){
				if(no.length != 15)return false;
				if(isNumber(no.substr(0,1)))return false;
				if(isNumber(no.substr(8,1)))return false;
				if(isNumber(no.substr(9,1)))return false;
				if(!isNumber(no.substr(1,7)))return false;
				if(!isNumber(no.substr(10,5)))return false;
			}else if("028" == bank){
				if(no.length != 14)return false;
				if(isNumber(no.substr(0,1)))return false;
				if(isNumber(no.substr(1,1)))return false;
				if(!isNumber(no.substr(2,12)))return false;
			}else if("026" == bank){
				if(no.length != 14)return false;
				if(!isNumber(no.substr(0,14)))return false;
			}


		}else if(pattern == "GO") {
			//기타유상
			if("002" == bank) {
				//국민은행
				if(no.length != 16)return false;
				if(isNumber(no.substr(0,2)))return false;
				if(!isNumber(no.substr(6,10)))return false;
			}
		}else if("041" == bank){//paypal 20170427 신규 추가 거래형태 없음
			if(no.length < 17 || no.length >= 18)return false;

		}else if(pattern =="FC"){
			if("020" == bank) {
				//농협
				if(no.length != 16)return false;
				if(isNumber(no.substr(0,2)))return false;
				if(no.substr(0,1) != "B")return false;
				if(no.substring(1,2) != "C" && no.substring(1,2) !="P")return false;

			}
		}

		return true;
	}

	function checkDate(obj){
		var sYear = Trim(obj.value.substring(0,4));
		var sMonth = Trim(obj.value.substring(4,6));
		var sDay = Trim(obj.value.substring(6,8));
		if(sYear.length<1||sYear.length!=4)  {
			alert("년도는 4자리입니다!");
			obj.focus();
			return false;
		}
		if(sMonth.length<1||sMonth.length!=2)  {
			alert("월은 2자리입니다!");
			obj.focus();
			return false;
		}
		if(sDay.length<1||sDay.length!=2)  {
			alert("날짜는 2자리입니다!");
			obj.focus();
			return false;
		}
		if(!isNumber(sYear))  {
			alert("년도는 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		if(!isNumber(sMonth))  {
			alert("월은 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		if(!isNumber(sDay))  {
			alert("날짜는 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		var days = lastDay(sYear + sMonth);
		if((sMonth == '00')||(sMonth >12))  {
			alert(sMonth+'월의 입력이 잘못 되었습니다!');
			obj.focus();
			return false;
		}
		if((sDay > days)||(sDay == '00'))  {
			alert(sDay+"일의 입력이 잘못되었습니다!");
			obj.focus();
			return false;
		}
		return true;
	}

	function isNumber(value) {
	    if (isNaN(value)) { // 값이 NaN 이면 숫자 아님.
	        return false;
	    }
	    return true;
	}

	function lastDay(sYM){
		if(sYM.length != 6){
			alert("정확한 년월을 입력하십시요.");
			return;
		}
		if(!isDateYM(sYM)){
			return;
		}
		daysArray = new makeArray(12);    // 배열을 생성한다.

		for (i=1; i<8; i++){
			daysArray[i] = 30 + (i%2);
		}
		for (i=8; i<13; i++){
			daysArray[i] = 31 - (i%2);
		}
		var sYear = sYM.substring(0, 4) * 1;
		var sMonth	= sYM.substring(4, 6) * 1;
		if (((sYear % 4 == 0) && (sYear % 100 != 0)) || (sYear % 400 == 0)){
			daysArray[2] = 29;
		}else{
			daysArray[2] = 28;
		}

		return daysArray[sMonth].toString();
	}

	function isDateYM(sYM){
		// 숫자 확인
		if(!isNumber(sYM)){
			alert('날짜는 숫자만 입력하십시오');
			return false;
		}
		// 길이 확인
		if(sYM.length != 6){
			alert('일자를 모두 입력하십시오');
			return false;
		}

		var iYear = parseInt(sYM.substring(0,4)); //년도값을 숫자로
		var iMonth = parseInt(trimZero(sYM.substring(4,6)));  //월을 숫자로

		if((iMonth < 1) ||(iMonth >12)){
			return false;
		}
		return true;
	}

	function Trim(sVal){
		return(LTrim(RTrim(sVal)));
	}
	function LTrim(sVal)	{
		var i;
		i = 0;
		while (sVal.substring(i,i+1) == ' '){
			i++;
		}
		return sVal.substring(i);
	}
	function RTrim(sVal)	{
		var i = sVal.length - 1;
		while (i >= 0 && sVal.substring(i,i+1) == ' ') {
			i--;
		}
		return sVal.substring(0,i+1);
	}
	function trimZero(sVal){
		if(sVal.charAt(0) == '0'){
			return sVal.substring(1,sVal.length);
		}else{
			return sVal;
		}
	}

	function viewFiles(fileId){
		var paramFileId = "";
		if( fileId == "contractAttFileId" ) {
			paramFileId = f.contractAttFileId.value;
		}else if( fileId == "currencyAttFileId" ) {
			paramFileId = f.currencyAttFileId.value;
		}

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			global.openLayerPopup({
				// 레이어 팝업 URL
				popupUrl : '<c:url value="/svcex/svcexCertificate/popup/offlineRegsFileList.do" />'
				// 레이어 팝업으로 넘기는 parameter 예시
				, params : {
					fileId : paramFileId
					, fileInputName : paramFileId
				}
				// 레이어 팝업 Callback Function
				, callbackFunction : function(resultObj){
					ReloadFileList( resultObj[0], fileId );
				}
			});
		}
	}

	function ReloadFileList(fileId, gubun) {
		if( gubun == "contractAttFileId" ) {
			f.contractAttFileId.value = fileId;
			f.fileId.value = fileId;
			f.fileInputName.value = fileId;
		}else if( gubun == "currencyAttFileId" ) {
			f.currencyAttFileId.value = fileId;
			f.fileId.value = fileId;
			f.fileInputName.value = fileId;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/fileList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if( gubun == "contractAttFileId" ) {
					$("#contractAttFileList").html(data.fileNm.replaceAll(',', '<br/>'));
				}else if( gubun == "currencyAttFileId" ) {
					$("#currencyAttFileList").html(data.fileNm.replaceAll(',', '<br/>'));
				}
			}
		});
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
