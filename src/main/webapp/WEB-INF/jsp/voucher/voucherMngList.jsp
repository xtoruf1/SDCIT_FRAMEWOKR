<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="page_voucher">
	<form id="voucherForm" name="voucherForm">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1">
		<div class="cont_block">
			<div class="tabGroup">
				<div class="tab_header">
					<button type="button" id="vouTab" class="tab on">사업등록</button>
					<button type="button" id="vouSerTab" class="tab">바우처서비스</button>
				</div>
				<div class="tab_body">
					<div id="vouTabCnt" class="tab_cont on">
						<input type="hidden" id="vmstSeq" name="vmstSeq"/>
						<div class="cont_block">
							<table class="formTable">
								<colgroup>
									<col style="width:15%;" />
									<col/>
									<col style="width:15%;" />
									<col/>
								</colgroup>
								<tbody>
									<tr>
										<th>대상년도 <strong class="point">*</strong></th>
										<td>
											<input type="text" class="form_text" name="baseYear" id="baseYear" maxlength="4" />
										</td>
										<th>게시일 <strong class="point">*</strong></th>
										<td>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" name="viewDt" id="viewDt" class="txt datepicker" title="게시일" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />

												</span>

												<!-- clear 버튼 -->
												<button class="dateClear" type="button" onclick="clearPickerValue('viewDt')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
											</div>
										</td>
									</tr>
									<tr>
										<th>제목 <strong class="point">*</strong></th>
										<td colspan="3">
											<input type="text" class="form_text w100p" name="voucherTitle" id="voucherTitle" maxlength="60"/>
										</td>
									</tr>
									<tr>
										<th>오픈여부</th>
										<td>
											<select class="form_select" name="openYn" id="openYn">
												<option value="Y" label="오픈"  selected/>
												<option value="N" label="마감"  />
											</select>
										</td>
										<th>추가사업</th>
										<td>
											<select class="form_select" name="secondYn" id="secondYn">
												<option value="Y" label="Y"  />
												<option value="N" label="N"  selected/>
											</select>
										</td>
									</tr>
									<tr>
										<th>접수시작일 <strong class="point">*</strong></th>
										<td>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" name="receStdt" id="receStdt" class="txt datepicker" title="접수시작일" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												</span>

												<!-- clear 버튼 -->
												<button class="dateClear" type="button" onclick="clearPickerValue('receStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
											</div>
										</td>
										<th>접수종료일 <strong class="point">*</strong></th>
										<td>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" name="receEddt" id="receEddt" class="txt datepicker" title="접수시작일자입력" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												</span>

												<!-- clear 버튼 -->
												<button class="dateClear" type="button" onclick="clearPickerValue('receEddt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
											</div>
										</td>
									</tr>
									<tr>
										<th>사업시작일 <strong class="point">*</strong></th>
										<td>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" name="voucherStdt" id="voucherStdt" class="txt datepicker" title="접수시작일자입력" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												</span>

												<!-- clear 버튼 -->
												<button class="dateClear" type="button" onclick="clearPickerValue('voucherStdt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
											</div>
										</td>
										<th>사업종료일 <strong class="point">*</strong></th>
										<td>
											<div class="datepicker_box">
												<span class="form_datepicker">
													<input type="text" name="voucherEddt" id="voucherEddt" class="txt datepicker" title="접수시작일자입력" readonly="readonly" />
													<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												</span>

												<!-- clear 버튼 -->
												<button class="dateClear" type="button" onclick="clearPickerValue('voucherEddt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
											</div>
										</td>
									</tr>
									<tr>
										<th>사업예산</th>
										<td colspan="3">
											<div class="flex align_center">
												<input type="text" class="form_text w100p" style="text-align: right"; name="budgetAmt1" id="budgetAmt1" onkeyup="calcLevSumsuppAmt('budget', 'budget');" placeholder="사업예산 금액" style="padding-right: 5px;" maxlength="15" />
												<input type="text" class="form_text w100p ml-8" name="budgetSuppNm1" id="budgetSuppNm1" placeholder="사업예산 지원처"  maxlength="60"/>
												<input type="text" class="form_text w100p ml-8" style="text-align: right"; name="budgetAmt2" id="budgetAmt2" onkeyup="calcLevSumsuppAmt('budget', 'budget');" placeholder="사업예산 금액" style="padding-right: 5px;"  maxlength="15"/>
												<input type="text" class="form_text w100p ml-8" name="budgetSuppNm2" id="budgetSuppNm2"  placeholder="사업예산 지원처" maxlength="60"/>
											</div>
										</td>
									</tr>
									<tr>
										<th>특이사항</th>
										<td colspan="3">
											<textarea id="remark" name="remark" rows="5" class="form_textarea"></textarea>
										</td>
									</tr>

								</tbody>
							</table>
						</div>

						<div class="cont_block">
							<table class="formTable">
								<colgroup>
									<col style="width:7.5%">
									<col style="width:7.5%">
								</colgroup>
								<thead>
									<tr>
										<th colspan="2" class="align_ctr">구분</th>
										<th class="align_ctr">로얄 <strong class="point">*</strong></th>
										<th class="align_ctr">골드 <strong class="point">*</strong></th>
										<th class="align_ctr">실버 <strong class="point">*</strong></th>
										<th class="align_ctr">방방곡곡</th>
										<th class="align_ctr">점프업</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th colspan="2" class="align_ctr">선정기준</th>
										<td>
											<label class="group_item">
												<input type="text" class="form_text align_r mr-8" style="width: 60px !important;" name="royalLevYear" id="royalLevYear" maxlength="2" />
												<span class="label"> 년 이상</span>
											</label>
										</td>
										<td>
											<label class="group_item">
												<input type="text" class="form_text align_r mr-8" style="width: 60px !important;" name="goldLevYear" id="goldLevYear" maxlength="2"/>
												<span class="label"> 년 이상</span>
											</label>
										</td>
										<td>
											<label class="group_item">
												<input type="text" class="form_text align_r mr-8" style="width: 60px !important;" name="silverLevYear" id="silverLevYear" maxlength="2"/>
												<span class="label"> 년 이상</span>
											</label>
										</td>
										<td>
											관리자 선정
										</td>
										<td>
											관리자 선정
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="3">지원내역</th>
										<th scope="row" class="align_ctr">&#9312;기본</th>
										<td>
											<input type="text" class="form_text align_r w100p" name="royalLevSupAmt" id="royalLevSupAmt" onkeyup="calcLevSumsuppAmt('royal', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="goldLevSupAmt" id="goldLevSupAmt" onkeyup="calcLevSumsuppAmt('gold', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="silverLevSupAmt" id="silverLevSupAmt" onkeyup="calcLevSumsuppAmt('silver', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="bangLevSupAmt" id="bangLevSupAmt" onkeyup="calcLevSumsuppAmt('bang', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="jumpupLevSupAmt" id="jumpupLevSupAmt" onkeyup="calcLevSumsuppAmt('jumpup', 'lev');" maxlength="15"/>
										</td>
									</tr>
									<tr>
										<th class="align_ctr">&#9313;추가</th>
										<td>
											<input type="text" class="form_text align_r w100p" name="royalLevAddsuppAmt" id="royalLevAddsuppAmt" onkeyup="calcLevSumsuppAmt('royal', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="goldLevAddsuppAmt" id="goldLevAddsuppAmt" onkeyup="calcLevSumsuppAmt('gold', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="silverLevAddsuppAmt" id="silverLevAddsuppAmt" onkeyup="calcLevSumsuppAmt('silver', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="bangLevAddsuppAmt" id="bangLevAddsuppAmt" onkeyup="calcLevSumsuppAmt('bang', 'lev');" maxlength="15"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="jumpupLevAddsuppAmt" id="jumpupLevAddsuppAmt" onkeyup="calcLevSumsuppAmt('jumpup', 'lev');" maxlength="15"/>
										</td>
									</tr>
									<tr>
										<th class="align_ctr">합계(&#9312;+&#9313;)</th>
										<td>
											<input type="text" class="form_text align_r w100p" name="royalLevSumsuppAmt" id="royalLevSumsuppAmt" maxlength="15" readonly="readonly"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="goldLevSumsuppAmt" id="goldLevSumsuppAmt" maxlength="15" readonly="readonly"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="silverLevSumsuppAmt" id="silverLevSumsuppAmt" maxlength="15" readonly="readonly"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="bangLevSumsuppAmt" id="bangLevSumsuppAmt" maxlength="15" readonly="readonly"/>
										</td>
										<td>
											<input type="text" class="form_text align_r w100p" name="jumpupLevSumsuppAmt" id="jumpupLevSumsuppAmt"  maxlength="15" readonly="readonly"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div id="tabSerCnt" class="tab_cont">
						<div class="tit_bar">
							<div class="btnGroup ml-auto">
								<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doInsertVoucherService();">추가</button>
								<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="saveVoucherService();">저장</button>
							</div>
						</div>
						<div id="tabService">
							<div id="voucherService" class="sheet"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="cont_block">
			<div class="tbl_opt">
				<div id="totalCnt" class="total_count"></div>

				<select name="pageUnit" class="form_select ml-auto" onchange="chgPageCnt();">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}">${item.codeNm}</option>
					</c:forEach>
				</select>

				<div class="ml-15">
					<button type="button" id="btnAdd" class="btn_sm btn_primary btn_modify_auth" onclick="addVoucher();">추가</button>
					<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="saveVoucher();">저장</button>
				</div>
			</div>
			<div>
				<div id="voucherListSheet" class="sheet"></div>
			</div>
			<div id="paging" class="paging ibs"></div>

		</div>
	</form>
</div>

<script type="text/javascript">

	var addChk = "";

	$(document).ready(function(){

		setSheetHeader_voucherList();		// 사업 리스트 헤더
		setSheetHeader_voucherService();	// 바우처 서비스 리스트 헤더
		getVoucherList();					// 사업 리스트 조회

	});

	function setSheetHeader_voucherList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '사업년도'		, Type: 'Text', SaveName: 'baseYear'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'		, Type: 'Text', SaveName: 'voucherTitle'	, Edit: false	, Width: 130	, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '게시일'		, Type: 'Text', SaveName: 'viewDt'			, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업기간'		, Type: 'Text', SaveName: 'voucherDt'		, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '접수기간'		, Type: 'Text', SaveName: 'receDt'			, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '상태'		, Type: 'Text', SaveName: 'voucherSt'		, Edit: false	, Width: 30		, Align: 'Center'});
		ibHeader.addHeader({Header: '바우처시퀀스'	, Type: 'Text', SaveName: 'vmstSeq'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherListSheet')[0];
		createIBSheet2(container, 'voucherListSheet', '100%', '100%');
		ibHeader.initSheet('voucherListSheet');

		voucherListSheet.SetEllipsis(1); // 말줄임 표시여부
		voucherListSheet.SetSelectionMode(4);			// 셀 선택 모드 설정

	}

	function setSheetHeader_voucherService() {	// 바우처 서비스 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'		, Type: 'Status'	, SaveName: 'status'	, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'	, Type: 'Text'		, SaveName: 'vmstSeq'	, Hidden: true});
		ibHeader.addHeader({Header: '삭제'		, Type: 'DelCheck'	, SaveName: 'DelCheck'							, Width: 10		, Align: 'Center'	, HeaderCheck : 0});
		ibHeader.addHeader({Header: '순번'		, Type: 'Int'		, SaveName: 'vouSeq'			, Edit: true	, Width: 15		, Align: 'Center'	, KeyField : true	, AcceptKeys: "N"});
		ibHeader.addHeader({Header: '서비스코드'	, Type: 'Text'		, SaveName: 'voucherCd'			, Edit: false	, Width: 30		, Align: 'Left'		, KeyField : true});
		ibHeader.addHeader({Header: '서비스 분류명'	, Type: 'Text'		, SaveName: 'voucherGrpNm'		, Edit: true	, Width: 50		, Align: 'Left'		, KeyField : true});
		ibHeader.addHeader({Header: '서비스명'		, Type: 'Text'		, SaveName: 'voucherName'		, Edit: true	, Width: 50		, Align: 'Left'		, KeyField : true});
		ibHeader.addHeader({Header: '사용유무'		, Type: 'Combo'		, SaveName: 'useYn'								, Width: 30		, Align: 'Center'	, ComboText: '사용|미사용'	, ComboCode: 'Y|N'});
		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherService')[0];
		createIBSheet2(container, 'voucherService', '100%', '100%');
		ibHeader.initSheet('voucherService');

	}

	function voucherService_OnRowSearchEnd(row) {
		notEditableCellColor('voucherService', row);
	}


	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getVoucherList();
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getVoucherList();
	}

	function chgPageCnt() {
		doSearch();
	}


	function voucherListSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) { // 사업 리스트 포커스 이동시

		if(oldRow == newRow){ // 이전 클릭 행이 새로 클릭한 행과 같으면
			return;
		}

		if(newCol == 1) {
			var vmstSeq = voucherListSheet.GetCellValue(newRow,'vmstSeq');	// 현재 선택된 사업 vmstSeq 세팅

			getVoucherInfo(vmstSeq);	// 바우처 상세정보 조회
		}
	}

	function voucherListSheet_OnSearchEnd() {
		// 제목에 볼드 처리
		voucherListSheet.SetColFontBold('voucherTitle', 1);
	}


	function getVoucherList() {	// 사업정보 조회

		var voucherForm = $('#voucherForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(voucherForm)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setPaging(	// 페이징
					'paging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				voucherListSheet.LoadSearchData({Data: (data.resultList || []) }, {	// 조회한 데이터 시트에 적용
					Sync: 1
				});

				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.totalCnt) + '</span> 건');

				voucherListSheet.SelectCell(1,'voucherTitle');	// 리스트 최상단 데이터 선택
			}
		});
	}

	function getVoucherInfo(vmstSeq) {	// 바우처 상세정보 조회

		global.ajax({
			type : 'POST'
			, url : '/voucher/selectVoucherFormInfo.do'
			, data : {'vmstSeq' : vmstSeq}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherService.LoadSearchData({Data: (data.voucherService || []) });	// 바우처 서비스 정보 조회

				var key1 = Object.keys(data.voucherInfo);

				for(var i = 0; i < key1.length; i++) {

					if(key1[i] == 'paginationInfo' || key1[i] == 'pageIndex'){
						continue;
					} else {
						var value = data.voucherInfo[key1[i]];
					}

					$('#'+key1[i]).val(value);
				}

				numFormat();
				//$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);
			}
		});
	}

	function doInsertVoucherService(){	// 바우처 서비스 추가

		var vouSeq = voucherService.GetCellValue(1,'vmstSeq');
		var maxSeq = voucherService.GetColMaxValue('vouSeq');
		var nextCode = '';
		var maxCode = 0;
		for( var i = 1; i <= voucherService.RowCount(); i++){
			if( parseInt(voucherService.GetCellValue(i,'voucherCd').replace(/[^0-9]/g, "")) > maxCode){
				maxCode = parseInt(voucherService.GetCellValue(i,'voucherCd').replace(/[^0-9]/g, ""));
			}
		}
		maxCode++;

		if( maxCode < 10){
			nextCode = 'BIZ00'+maxCode;
		}else if( maxCode < 100){
			nextCode = 'BIZ0'+maxCode;
		}else if( maxCode < 100){
			nextCode = 'BIZ'+maxCode;
		}

		var data = {vmstSeq: vouSeq, vouSeq: maxSeq+1, voucherCd: nextCode};
		var idx = voucherService.DataInsert(-1);

		voucherService.SetCellEditable(idx,'voucherCd',1);
		voucherService.SetRowData(idx, data);

		voucherService.SetCellBackColor(idx, 'voucherCd', '#FFFFFF');

		//$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);

	}

	function saveValid(){	// 바우처 상세정보 validation

		var numChk = /[^0-9]/;

		if($("#baseYear").val() == ""){
			alert("대상년도는 필수입니다.");
			$("#baseYear").focus();
			return false;
		} else {
			if(numChk.test($('#baseYear').val())) {
				alert('숫자만 입력해 주세요.');
				$('#baseYear').focus();
				return false;
			}
		}

		if($("#viewDt").val() == ""){
			alert("게시일은 필수입니다.");
			$("#viewDt").focus();
			return false;
		}

		if($("#voucherTitle").val() == ""){
			alert("제목은 필수입니다.");
			$("#voucherTitle").focus();
			return false;
		}

		if($("#receStdt").val() == ""){
			alert("접수시작일은 필수입니다.");
			$("#receStdt").focus();
			return false;
		}

		if($("#receEddt").val() == ""){
			alert("접수종료일은 필수입니다.");
			$("#receEddt").focus();
			return false;
		}

		if($("#receStdt").val() > $("#receEddt").val()){
			alert("접수종료일이 접수시작일보다 빠릅니다.");
			$("#receEddt").focus();
			return false;
		}


		if($("#voucherStdt").val() == ""){
			alert("사업시작일은 필수입니다.");
			$("#voucherStdt").focus();
			return false;
		}

		if($("#voucherEddt").val() == ""){
			alert("사업종료일은 필수입니다.");
			$("#voucherEddt").focus();
			return false;
		}

		if($("#voucherStdt").val() > $("#voucherEddt").val()){
			alert("사업종료일이 사업시작일보다 빠릅니다.");
			$("#voucherEddt").focus();
			return false;
		}

		if($("#royalLevYear").val() == ""){
			alert("[로얄]선정기준은 필수입니다.");
			$("#royalLevYear").focus();
			return false;
		} else {
			if(numChk.test($('#royalLevYear').val())) {
				alert('로얄]선정기준은 숫자만 입력해 주세요.');
				$('#royalLevYear').focus();
				return false;
			}
		}

		if($("#royalLevSupAmt").val() == ""){
			alert("[로얄]지원내역[기본]은 필수입니다.");
			$("#royalLevSupAmt").val(0);
			$("#royalLevSupAmt").focus();
			return false;
		}

		if($("#royalLevAddsuppAmt").val() == ""){
			alert("[로얄]지원내역[추가]는 필수입니다.");
			$("#royalLevAddsuppAmt").val(0);
			$("#royalLevAddsuppAmt").focus();
			return false;
		}


		if($("#goldLevYear").val() == ""){
			alert("[골드]선정기준은 필수입니다.");
			$("#goldLevYear").focus();
			return false;
		} else {
			if(numChk.test($('#goldLevYear').val())) {
				alert('[골드]선정기준은 숫자만 입력해 주세요.');
				$('#goldLevYear').focus();
				return false;
			}
		}

		if($("#goldLevSupAmt").val() == ""){
			alert("[골드]지원내역[기본]은 필수입니다.");
			$("#goldLevSupAmt").val(0);
			$("#goldLevSupAmt").focus();
			return false;
		}

		if($("#goldLevAddsuppAmt").val() == ""){
			alert("[골드]지원내역[추가]는 필수입니다.");
			$("#goldLevAddsuppAmt").val(0);
			$("#goldLevAddsuppAmt").focus();
			return false;
		}

		if($("#silverLevYear").val() == ""){
			alert("[실버]선정기준은 필수입니다.");
			$("#silverLevYear").focus();
			return false;
		} else {
			if(numChk.test($('#silverLevYear').val())) {
				alert('[실버]선정기준은 숫자만 입력해 주세요.');
				$('#silverLevYear').focus();
				return false;
			}
		}

		if($("#silverLevSupAmt").val() == ""){
			alert("[실버]지원내역[기본]은 필수입니다.");
			$("#silverLevSupAmt").val(0);
			$("#silverLevSupAmt").focus();
			return false;
		}

		if($("#silverLevAddsuppAmt").val() == ""){
			alert("[실버]지원내역[추가]는 필수입니다.");
			$("#silverLevAddsuppAmt").val(0);
			$("#silverLevAddsuppAmt").focus();
			return false;
		}

		if($("#bangLevSupAmt").val() == ""){
			alert("[방방곡곡]지원내역[기본]은 필수입니다.");
			$("#bangLevSupAmt").val(0);
			$("#bangLevSupAmt").focus();
			return false;
		}

		if($("#bangLevAddsuppAmt").val() == ""){
			alert("[방방곡곡]지원내역[추가]는 필수입니다.");
			$("#bangLevAddsuppAmt").val(0);
			$("#bangLevAddsuppAmt").focus();
			return false;
		}

		if($("#jumpupLevSumsuppAmt").val() == ""){
			alert("[점프업]지원내역[기본]은 필수입니다.");
			$("#bangLevSumsuppAmt").val(0);
			$("#bangLevSumsuppAmt").focus();
			return false;
		}

		if($("#jumpupLevAddsuppAmt").val() == ""){
			alert("[점프업]지원내역[추가]는 필수입니다.");
			$("#jumpupLevAddsuppAmt").val(0);
			$("#jumpupLevAddsuppAmt").focus();
			return false;
		}

		if(!$("#remark").val() == ""){

			var form = document.voucherForm;

			if(global.chkByte(form.remark, 1300, "특이사항") == false){
				return;
			}
		}


		return true;

	}

	function saveVoucherService() {	// 바우처 서비스 등록

		if(addChk == "Y") {
			alert("작성중인 바우처가 존재합니다. \n바우처를 먼저 저장해주세요.");
			return;
		}

		var pPramData = voucherService.GetSaveJson();

		if(pPramData.Code == 'IBS010' || pPramData.Code == 'IBS020') {
			return;
		}

		if(pPramData.Code == 'IBS000') {
			alert("작업할 데이터가 없습니다.");
			return;
		}

		if(!confirm('저장 하시겠습니까?')) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : "/voucher/saveVoucherService.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pPramData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				var nowRow = voucherListSheet.GetSelectRow();
				var vmstSeq = voucherListSheet.GetCellValue(nowRow ,'vmstSeq');
				getVoucherInfo(vmstSeq);
			}
		});
	}

	function saveVoucher() {	// 바우처 정보 신규등록

		if(!confirm('저장 하시겠습니까?')) {
			return;
		}

		if(!saveValid()){	// 바우처 상세정보 validation
			return false;
		}

		if(addChk == 'Y') {	// 신규 사업일때

			for(var i = 0; i < voucherService.RowCount()+1; i++) {
				voucherService.SetCellValue(i, 'status', 'I');
			}

			var vchServiceList = voucherService.ExportData({
				'Type' : 'json'
			});


		} else {	// 수정일때

			var vchServiceList = voucherService.GetSaveJson();
		}


		var pParamData = $('#voucherForm').serializeObject();

		for(var i = 0; i < voucherService.RowCount(); i++) {

			if(voucherService.GetCellValue(i+1,'vouSeq') == ''){
				alert(i+2+'번째 순번을 입력하세요.');
				vouServiceTabClick();
				return;
			}

			if(voucherService.GetCellValue(i+1,'voucherCd') == ''){
				alert(i+2+'번째 서비스코드를 입력하세요.');
				vouServiceTabClick();
				return;
			}

			if(voucherService.GetCellValue(i+1,'voucherGrpNm') == ''){
				alert(i+2+'번째 서비스 분류명을 입력하세요.');
				vouServiceTabClick();
				return;
			}

			if(voucherService.GetCellValue(i+1,'voucherName') == ''){
				alert(i+2+'번째 서비스명 입력하세요.');
				vouServiceTabClick();
				return;
			}
		}

		if(vchServiceList.data.length <= 0 ) {
			vchServiceList.data = [];
		}

		var params = {};
		params.param = pParamData;
		params.list = vchServiceList.data;

		global.ajax({
			type : 'POST'
			, url : "/voucher/saveVoucherInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(params)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if(addChk == "Y") {
					addChk = "";
					location.reload();
				} else {
					var nowRow = voucherListSheet.GetSelectRow();
					var vmstSeq = voucherListSheet.GetCellValue(nowRow,'vmstSeq');
					getVoucherList();
				}
			}
		});
	}

	function numFormat() {	// 값 초기화시 포맷적용

		var val = ['jumpup','bang','silver','gold','royal'];

		for(var i = 0; i < val.length; i++) {
			var lev_sup_amt = onlyNum($("#"+val[i]+"LevSupAmt").val());
			var lev_addsupp_amt = onlyNum($("#"+val[i]+"LevAddsuppAmt").val());
			var lev_sumsupp_amt = parseInt(lev_sup_amt) + parseInt(lev_addsupp_amt);

			$("#"+val[i]+"LevSumsuppAmt").val(global.formatCurrency(lev_sumsupp_amt));
			$("#"+val[i]+"LevSupAmt").val(global.formatCurrency(lev_sup_amt));
			$("#"+val[i]+"LevAddsuppAmt").val(global.formatCurrency(lev_addsupp_amt));
		}

		var budget_amt1 = onlyNum($("#budgetAmt1").val());
		var budget_amt2 = onlyNum($("#budgetAmt2").val());

		if(budget_amt1 != "") {
			$("#budgetAmt1").val(global.formatCurrency(budget_amt1));
		}
		if(budget_amt2 != "") {
			$("#budgetAmt2").val(global.formatCurrency(budget_amt2));
		}

	}

	function calcLevSumsuppAmt(lev, gubun) {	// 값 수정시 포맷적용

		if(gubun == "lev") {
			var lev_sup_amt = onlyNum($("#"+lev+"LevSupAmt").val());
			var lev_addsupp_amt = onlyNum($("#"+lev+"LevAddsuppAmt").val());
			var lev_sumsupp_amt = parseInt(lev_sup_amt) + parseInt(lev_addsupp_amt);
			$("#"+lev+"LevSumsuppAmt").val(global.formatCurrency(lev_sumsupp_amt));
			$("#"+lev+"LevSupAmt").val(global.formatCurrency(lev_sup_amt));
			$("#"+lev+"LevAddsuppAmt").val(global.formatCurrency(lev_addsupp_amt));
		} else if(gubun == "budget"){
			var budget_amt1 = onlyNum($("#"+lev+"Amt1").val());
			var budget_amt2 = onlyNum($("#"+lev+"Amt2").val());

			if(budget_amt1 != "") {
				$("#"+lev+"Amt1").val(global.formatCurrency(budget_amt1));
			}
			if(budget_amt2 != "") {
				$("#"+lev+"Amt2").val(global.formatCurrency(budget_amt2));
			}
		}
	}

	function vouServiceTabClick() {

		$('#vouTab').attr('class', 'tab');
		$('#vouTabCnt').attr('class', 'tab_cont');
		$('#vouSerTab').attr('class', 'tab on');
		$('#tabSerCnt').attr('class', 'tab_cont on');
		//$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);
	}

	function addVoucher() {	// 바우처 추가

		addChk = "Y";

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherPrevInfo.do"
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherService.LoadSearchData({Data: data.voucherService});

				$('#voucherForm')[0].reset();

				var info = data.voucherInfo;

				var key1 = Object.keys(data.voucherInfo);

				for(var i = 0; i < key1.length; i++) {	// 바우처 상세정보 값세팅

					if(key1[i] == 'paginationInfo'){
						continue;
					} else if(key1[i].match('jumpup') || key1[i].match('bang') || key1[i].match('silver') || key1[i].match('gold') || key1[i].match('royal') ){
						var value = data.voucherInfo[key1[i]];
					}

					$('#'+key1[i]).val(value);
				}

				numFormat();	// 숫자포맷 적용

				// 추가시 강제 바우처 등록탭으로 변경
				$('#vouTab').attr('class', 'tab on');
				$('#vouTabCnt').attr('class', 'tab_cont on');
				$('#vouSerTab').attr('class', 'tab');
				$('#tabSerCnt').attr('class', 'tab_cont');


				$('#secondYn').val("N");
				$('#openYn').val("Y");
				$('#baseYear').focus();
				//$('.body_inner_scroll').animate({scrollTop : $('.body_inner_scroll').height()}, 0);
			}
		});
	}

</script>