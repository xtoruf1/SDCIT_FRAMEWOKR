<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
	function fn_list() {
		$("#searchForm").attr("action","/technicalConsulting/conferenceManagement.do");
		$("#searchForm").submit();
	}
</script>

<!-- 페이지 위치 -->
<div class="location compact" style="margin-bottom: -10px;">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnSubmit();">저장</button>
	<c:if test="${newAdd eq 'N'}">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnQrCode();" id="qrCode" name="qrCode">QR발급</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnPromotion();" name="qrCode">홍보 알림톡 발송</button>
	</c:if>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
	</div>
</div>

<!-- 무역현장 컨설팅 상세 -->
<div class="page_tradesos">
	<form name="submitForm" id="submitForm" method="post">
		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar">
			</div>
			<input type="hidden" id="devCfrcId" name="devCfrcId" value="<c:out value="${resultData.devCfrcId}"/>"/>
			<input type="hidden" id="questionId" name="questionId" value=""/>
			<input type="hidden" name="cnfCnt" value="<c:out value="${resultData.cnfCnt}"/>"/>       <%-- 참가_확정_수 --%>
			<input type="hidden" name="qrYn" value="<c:out value="${resultData.qrYn}"/>"/>           <%-- QR코드 전송 여부 --%>
			<input type="hidden" id="guide" name="guide" value=""/>
			<input type="hidden" id="newAdd" name="newAdd" value="<c:out value="${newAdd}"/>" />
			<input type="hidden" id="eventStus" name="eventStus" value=""/>

				<table class="boardwrite formTable">
					<colgroup>
						<col style="width:20%">
						<col>
						<col style="width:20%">
						<col>
					</colgroup>
					<tbody>
					<tr>
						<th scope="row"><strong class="point">*</strong> 상담회 명</th>
							<td>
								<input class="input form_text w100p" type="text" name="cfrcName" id="cfrcName" maxlength="200" value="<c:out value="${resultData.cfrcName}"/>">
							</td>
						</th>
						<th scope="row"><strong class="point">*</strong> 협력기관</th>
							<td>
								<select name="partner" class="form_select w100p">
								<c:forEach items="${TC001}" var="code">
									<option value="<c:out value="${code.code }"/>"  <c:if test="${resultData.partner eq code.code}">selected="selected"</c:if> ><c:out value="${code.codeNm }"/></option>
								</c:forEach>
								</select>
							</td>
						</th>
					</tr>
					<tr>
						<th scope="row"><strong class="point">*</strong> 장소</th>
						<td>
							<input class="input form_text w100p" type="text" name="cfrcPlace" id="cfrcPlace" maxlength="200" value="<c:out value="${resultData.cfrcPlace}"/>">
						</td>
						<th scope="row"><strong class="point">*</strong> 개최일</th>
						<td>
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="cfrcStartDate" name="cfrcStartDate" value="${resultData.cfrcStartDate}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('cfrcStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="cfrcEndDate" name="cfrcEndDate" value="${resultData.cfrcEndDate}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('cfrcEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><strong class="point">*</strong> 공개여부</th>
						<td>
							<label class="label_form">
								<input type="radio" class="form_radio" name="openYn" id="radio2_1" value="Y" <c:out value="${resultData.openYn eq 'Y' ? 'checked' : '' }"/> checked>
								<span class="label">공개</span>
							</label>
							<label class="label_form">
								<input type="radio" class="form_radio" name="openYn" id="radio2_2" value="N" <c:out value="${resultData.openYn eq 'N' ? 'checked' : '' }"/>>
								<span class="label">비공개</span>
							</label>
						</td>
						<th scope="row"><strong class="point">*</strong> 신청기간</th>
						<td>
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="applStartDate" name="applStartDate" value="${resultData.applStartDate}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate2" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('applStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="applEndDate" name="applEndDate" value="${resultData.applEndDate}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate2" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('applEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</div>
						</td>
					</tr>
					<c:if test="${resultData.devCfrcId != null}">
					<tr>
						<th scope="row">참석 신청 현황</th>
						<td >
							<span>신청 : &nbsp;<c:out value="${resultData.aplctCnt}"/> </span>
							<span style="margin-left: 100px;">확정 : &nbsp;<c:out value="${resultData.cnfCnt}"/> </span>
						</td>
						<th scope="row">QR발급 여부</th>
						<td>
							<c:if test="${resultData.qrYn == 'Y'}">
								발급 완료
							</c:if>
							<c:if test="${resultData.qrYn == 'N'}">
								발급전
							</c:if>
						</td>
					</tr>
					</c:if>
					<tr>
						<th scope="row">비고</th>
						<td colspan="3">
							<input class="input form_text w100p" type="text" name="dscr" id="dscr" maxlength="200" value="<c:out value="${resultData.dscr}"/>">
						</td>
					</tr>
					</tbody>
				</table><!-- // 무역의날 기념식 관리 저장 테이블-->
		</div>
		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar" style="margin-bottom: 5px;">
				<h3 class="tit_block">객관식 항목관리</h3>
			</div>
			<div style="display: flex; justify-content: space-between;">
				<div style="position:relative; width: 49%;" >
					<button type="button" class="btn_sm btn_primary" onclick="fn_RowAdd();" style="position:absolute; top:-33px; right:0;">문항 추가</button>
					<div id='tblGridSheet' style="padding-top: 10px;"></div>
				</div>
				<div style="position:relative; width: 50%;">
					<button type="button" class="btn_sm btn_primary" onclick="fn_addDetail();" style="position:absolute; top:-33px; right:0;">세부 항목 추가</button>
					<div id='tblGrid2Sheet' style="padding-top: 10px;"></div>
				</div>
			</div>
		</div>

		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar">
				<h3 class="tit_block">주관식 템플릿</h3>
			</div>
			<div>
				<c:if test="${resultData.etcTemplate == null}">
				<textarea  name="etcTemplate" rows="10" class="form_textarea">
1) 기술애로 사항 (상담을 요청하는 기술에 대한 자세한 설명 기재) 및 상담회를 통한 달성목표 (장문형 텍스트)

2) 기술의뢰와 관련된 보유특허(출원번호 기재)

3) 기술애로 사항을 해결하기위해 기업에서 시도한 내용 및 방법에 대해서 설명 (장문형 텍스트)

4) 상담을 통한 달성 목표 또는 기대효과 (장문형 텍스트)
				</textarea>
				</c:if>
				<c:if test="${resultData.etcTemplate != null}">
				<textarea  name="etcTemplate" rows="10" class="form_textarea"><c:out value="${resultData.etcTemplate}" escapeXml="false"/></textarea>
				</c:if>
			</div>
		</div>

		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar">
				<h3 class="tit_block">안내 내용</h3>
			</div>
			<div>
				<textarea id="contEditor" name="contEditor" style="width:100%;" rows="25" maxlength="21000" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.guide}" escapeXml="false"/></textarea>
			</div>
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<input type="hidden" name="searchCondition" value="<c:out value="${searchVO.searchCondition}"/>"/>
	<input type="hidden" name="cfrcName" value="<c:out value="${searchVO.searchKeyword}"/>"/>
	<input type="hidden" name="cfrcPlace" value="<c:out value="${searchVO.searchKeyword2}"/>"/>
	<input type="hidden" name="partner" value="<c:out value="${searchVO.partner}"/>"/>
	<input type="hidden" name="cfrcStartDate" value="<c:out value="${searchVO.cfrcStartDate}"/>"/>
	<input type="hidden" name="cfrcEndDate" value="<c:out value="${searchVO.cfrcEndDate}"/>"/>
</form>

<script type="text/javascript">
	var oEditors = [];
	$(document).ready(function () {

		$('.datepicker').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString) {
				var inputName = $(this).attr('name');
				$('#' + inputName).val(dateString);
				console.log("1111" + inputName);

				$('label[for="all"]').css('background', '#fff');
				$('label[for="commCode_01"]').css('background', '#fff');
				$('label[for="commCode_02"]').css('background', '#fff');

				fn_dateChked(inputName);
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});

		nhn.husky.EZCreator.createInIFrame({
		  	  oAppRef : oEditors
			, elPlaceHolder : 'contEditor'
			, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
			, htParam : {
				// 툴바 사용 여부 (true: 사용 / false : 사용하지 않음)
				bUseToolbar : true
				// 입력창 크기 조절바 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseVerticalResizer : true
				// 모드 탭 (Editor | HTML | TEXT) 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseModeChanger : true
			}
		});

		// QR코드 발급 버튼
		var closeChk = $('input[name=cnfCnt]').val();
		// QR코드 발급 버튼
		if( closeChk == 0) {
			$('#qrCode').addClass('disabled');
			//$('#qrCode').attr('disabled', true);
		} else {
			$('#qrCode').removeClass('disabled');
			//$('#qrCode').attr('disabled', false);

		}

		f_Init_tblGridSheet();   //객관식항목관리 SHEET 세팅

		f_Init_tblGrid2Sheet();  //객관식항목관리 상세 SHEET 세팅

		questionList();

		questionItemList();

	});

	var qNum = "";
	var itemQum = 0;

	function f_Init_tblGridSheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: 'Status',   Header: '상태',            SaveName: 'status',       Hidden: true});
		ibHeader.addHeader({Type: "Text",     Header: "상담회아이디",     SaveName: "devCfrcId",    Align: "Center", Width: 70, Hidden:true});
		ibHeader.addHeader({Type: "Text",     Header: "질문ID", 		    SaveName: "questionId",   Hidden : true});
		ibHeader.addHeader({Type: 'DelCheck', Header: '삭제',            SaveName: 'sCheckBox',    Align: 'Center', Width: 20	, HeaderCheck : 0});
		ibHeader.addHeader({Type: "Int",      Header: "No",             SaveName: "sortNo",       Align: "Center", Width: 30, Edit: false});
		ibHeader.addHeader({Type: "Text",     Header: "질문문항", 		SaveName: "questionText", Align: "Left", Width: 180, Edit: true, KeyField: 1, UpdateEdit: true, InsertEdit: true});
		ibHeader.addHeader({Type: "Combo",    Header: "중복선택", 		SaveName: "dupYn",     Align: "Center", Width: 50, ComboText: '가능|불가능', ComboCode: 'Y|N', KeyField: 1, UpdateEdit: true, InsertEdit: true});

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetSelectionMode(4);
	};

	function f_Init_tblGrid2Sheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: 'Status',   Header: '상태',            SaveName: 'status',     Hidden: true});
		ibHeader.addHeader({Type: "Text",     Header: "질문ID", 		    SaveName: "questionId", Hidden : true});
		ibHeader.addHeader({Type: "Text",     Header: "세부항목ID", 		SaveName: "itemId",     Hidden : true});
		ibHeader.addHeader({Type: 'DelCheck', Header: '삭제',            SaveName: 'sCheckBox',   Align: 'Center', Width: 20	, HeaderCheck : 0});
		ibHeader.addHeader({Type: "Int",      Header: "No",             SaveName: "sortNo",     Align: "Center", Width: 30, UpdateEdit: true, InsertEdit: true, Edit: false});
		ibHeader.addHeader({Type: "Text",     Header: "세부항목", 		SaveName: "itemText",   Align: "Left", Width: 180, Edit: true, KeyField: 1, UpdateEdit: true, InsertEdit: true});

		var sheetId = "tblGrid2Sheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		//tblGridSheet.SetEditable(0);
		tblGrid2Sheet.ShowFilterRow();    //필터
        tblGrid2Sheet.SetRowHidden(1, 1); // 마스터 키 에따른 히든
		tblGrid2Sheet.SetSelectionMode(4);

		tblGrid2Sheet.CheckAll(4, 2);
	};

	/**
	 * 객관식 항목 관리 조회
	 */
	function questionList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/technicalConsulting/questionList.do" />'
			, data : $('#submitForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	/**
	 * 객관식 항목관리 검색 이벤트
	 * @param code
	 * @param msg
	 */
	function tblGridSheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete){
		tblGrid2Sheet.SetFilterValue("questionId", tblGridSheet.GetCellValue(tblGridSheet.GetSelectRow(), "questionId"), 1);
	}

	/**
	 * 객관식 항목관리 OnChange 이벤트
	 * @param code
	 * @param msg
	 */
	function tblGridSheet_OnChange(row, col, value, oldValue, raiseFlag) {
		var chkRow = row;

		var datarows = tblGrid2Sheet.GetDataRows();
		var lastrow = tblGrid2Sheet.LastRow();

		// 마스터 시트 체크 시 디테일 시트도 같이 체크
		if(value == 1) {
        	var fromData = tblGridSheet.GetRowData(chkRow);
        	for(var i = datarows; i <= lastrow; i++) {
        	 	var targetData = tblGrid2Sheet.GetRowData(i);

        	  if(fromData['questionId'] == targetData['questionId']) {
	    	      tblGrid2Sheet.SetCellValue(i, 'sCheckBox', true);
	    	    }
	    	  }
          } else {
          	for(var i = datarows; i <= lastrow; i++) {
            	tblGrid2Sheet.SetCellValue(i, 'sCheckBox', false);
            }
	    }
	}

	/**
	 * 객관식 항목관리 검색 이벤트
	 * @param code
	 * @param msg
	 */
	function tblGridSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGridSheet_OnSearchEnd : ', msg);
    	} else {
			tblGridSheet.SelectCell(1,1);

    	}
    }

	/**
	 * 세부항목 그리드 검색 이벤트
	 * @param code
	 * @param msg
	 */
	function tblGrid2Sheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGridSheet_OnSearchEnd : ', msg);
    	} else {
			itemQum = tblGrid2Sheet.GetCellValue(1, 'itemId');
		}

	}

	/**
	 * 객관식 항목 관리 조회
	 */
	function questionItemList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/technicalConsulting/questionItemList.do" />'
			, data : $('#submitForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGrid2Sheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	/**
	 * value 초기화 버튼
	 * @param targetId
	 */
	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

	/**
	 * Row 추가
	 */
	function fn_RowAdd() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/technicalConsulting/getQuestionSequence.do" />'
			, data : $('#submitForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				qNum = data.seq;

				var rNum = tblGridSheet.DataInsert(-1);
				var maxSeq = tblGridSheet.GetColMaxValue('sortNo');

				if( maxSeq == '-Infinity') {
					maxSeq = 0;
				}

				tblGridSheet.SetCellValue(rNum, 'questionId', qNum);
				tblGridSheet.SetCellValue(rNum, 'sortNo', maxSeq+1);
				tblGridSheet.SetCellValue(rNum, 'devCfrcId', $('#devCfrcId').val());
				// 편집시 컬럼 색깔 변경
				tblGridSheet.SetCellBackColor(rNum, 'categoryId', '#ffffff');
			}
		});

	}

	/**
	 * 세부항목 Row 추가
	 */
	function fn_addDetail() {
		itemQum++;
		var maxSeq = tblGrid2Sheet.FilteredRowCount();

		if( maxSeq == '-Infinity') {
			maxSeq = 0;
		}

		var data = {itemId: itemQum, sortNo: maxSeq+1, questionId: tblGridSheet.GetCellValue(tblGridSheet.GetSelectionRows(), 'questionId')};
		var rNum = tblGrid2Sheet.DataInsert(-1);
		tblGrid2Sheet.SetRowData(rNum, data);


		/*var rNum = tblGrid2Sheet.DataInsert(-1);
		tblGrid2Sheet.SetCellValue(rNum, 'itemId', itemQum);
		tblGrid2Sheet.SetCellValue(rNum, 'questionId', tblGridSheet.GetCellValue(tblGridSheet.GetSelectionRows(), 'questionId'));*/

		//voucherService.SetCellEditable(rNum,'voucherCd',1);
		//voucherService.SetRowData(rNum, data);
	}

	var submitFlag = true;
	/**
	 * 저장 프로세스
	 */
	function fnSubmit(){
		//초기화
		$('#eventStus').val("");

		// 저장 프로세스
		if($('#devCfrcId').val() == '' || $('#devCfrcId').val() == null) {
			$('#eventStus').val('insert');
		} else {
			$('#eventStus').val('update');
		}

		if ($("input[name=cfrcName]").val().trim() == ""){
			alert("상담회명을 입력해주세요.");
			$("input[name=cfrcName]").focus();
			return;
		}

		if ($("input[name=cfrcPlace]").val().trim() == ""){
			alert("행사장소를 입력해주세요.");
			$("input[name=cfrcPlace]").focus();
			return;
		}

		if ($("input[name=cfrcStartDate]").val().trim() == ""){
			alert("개최일 시작일을 입력해주세요.");
			$("input[name=cfrcStartDate]").focus();
			return;
		}

		if ($("input[name=applStartDate]").val().trim() == ""){
			alert("신청기간 시작일을 입력해주세요.");
			$("input[name=applStartDate]").focus();
			return;
		}

		if ($("input[name=applEndDate]").val().trim() == ""){
			alert("신청기간 종료일을 입력해주세요.");
			$("input[name=applEndDate]").focus();
			return;
		}

		var sHTML = oEditors.getById["contEditor"].getIR();
		$('#guide').val(sHTML);


		// 객관식 항목 마스터
		var jsonParam = {};
		var saveJson = tblGridSheet.GetSaveJson();
		jsonParam.sheetDataList = saveJson.data;

		// 객관식 항목 디테일
		var jsonParam2 = {};
		var saveJson2 = tblGrid2Sheet.GetSaveJson();
		jsonParam2.sheetDataList = saveJson2.data;

		if (saveJson.Message == 'KeyFieldError') {
			return false;
		}

		if (saveJson2.Message == 'KeyFieldError') {
			return false;
		}


		// 문항 중복 체크
		if( tblGridSheet.ColValueDup('sortNo',{'IncludeDelRow': 0}) > -1 ){
			alert(tblGridSheet.ColValueDup('sortNo',{'IncludeDelRow': 0})+'번째행 [No : '+tblGridSheet.GetCellValue(tblGridSheet.ColValueDup('sortNo',{'IncludeDelRow': 0}),'sortNo')+'] 중복됩니다.');
			return false;

		}

		//세부항목 중복 체크
		if( tblGrid2Sheet.ColValueDup('questionId|sortNo',{'IncludeDelRow': 0}) > -1 ){
			alert('세부항목에 [No : '+tblGrid2Sheet.GetCellValue(tblGrid2Sheet.ColValueDup('questionId|sortNo',{'IncludeDelRow': 0}),'sortNo')+'] 중복됩니다.');
			return false;

		}

		var conferencFrom = $('#submitForm').serializeObject();

		var pQuestion = tblGridSheet.GetSaveJson();                 // 마스터 데이터
        var pItemQuestion = tblGrid2Sheet.GetSaveJson();            // 세부항목 데이터

		// 객관식 항목관리
		if (pQuestion.data.length) {
			var map = {};
			var list = [];
			$.each(pQuestion, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				conferencFrom['questionList'] = list;
			});
		}

		// 객관식 세부항목 관리
		if (pItemQuestion.data.length) {
			var map = {};
			var list = [];
			$.each(pItemQuestion, function(key1, value1) {
				map = {};
				$.each(value1, function(key2, value2) {
					map = value2;
					list.push(map);
				});

				conferencFrom['itemQuestionList'] = list;
			});
		}

		if (confirm('저장 하시겠습니까?')) {
			if (submitFlag) {
				submitFlag = false;
				global.ajax({
					type: 'POST'
					, url: '<c:url value="/technicalConsulting/conferenceManagementSave.do" />'
					, data: JSON.stringify(conferencFrom)
					, contentType : 'application/json'
					, dataType: 'json'
					, async: false
					, spinner: true
					, success: function (data) {

						if( data.MESSAGE != "" ) {
							alert(data.MESSAGE)
							window.location.reload(true);
						} else {
							fn_list();
						}
					}
				});
			}
		}
	}

	// QR코드 발급
	function fnQrCode() {
		var qrYn = $('input[name=qrYn]').val();
		var cnfCnt = $('input[name=cnfCnt]').val();
		var msg = "";

		if( cnfCnt == 0) {  // 참석 확정자가 있을때(Y)
			alert("참석 확정된 인원이 없습니다.");
			return false;
		} else {

			if (qrYn == 'Y') { //전송한 이력 체크
				msg = "QR코드 발급한 이력이 있습니다. 다시 발급하시겠습니까?";
			} else {
				msg = "QR코드를 발급 하시겠습니까?";
			}

			$('#loading_image').show(); // 로딩이미지 시작
			if (confirm(msg)) {
				global.ajax({
					type: 'POST'
					, url: '<c:url value="/technicalConsulting/conferenceManagementQrCode.do" />'
					, data: $('#submitForm').serialize()
					, dataType: 'json'
					, async: true
					, spinner: true
					, success: function (data) {
						$('#loading_image').hide(); // 로딩이미지 종료
						alert(data.MESSAGE);
					}
				});
			} else {
				$('#loading_image').hide(); // 로딩이미지 종료
			}
		}
	}

	/**
	 * 홍보 알림톡 발송(행사 0일 전 알림)
	 */
	function fnPromotion() {
		global.ajax({
			type: 'POST'
			, url: '<c:url value="/technicalConsulting/promotionSendCheck.do" />'
			, data: $('#submitForm').serialize()
			, dataType: 'json'
			, async: true
			, spinner: true
			, success: function (data) {

				var cfrcDay = data.resultData.cfrcDay;

				$('#loading_image').show(); // 로딩이미지 시작
				if (confirm("행사 "+ cfrcDay+ "일전 입니다. 발송하시겠습니까?" )) {
					global.ajax({
						type: 'POST'
						, url: '<c:url value="/technicalConsulting/promotionSend.do" />'
						, data: $('#submitForm').serialize()
						, dataType: 'json'
						, async: true
						, spinner: true
						, success: function (data) {
							$('#loading_image').hide(); // 로딩이미지 종료
							alert(data.MESSAGE);
						}
					});
				}else {
					$('#loading_image').hide(); // 로딩이미지 종료
				}
			}
		});

	}

	/**
	 * 날짜 벨리데이션
	 * @param name
	 * @returns {boolean}
	 */
	function fn_dateChked(name) {

		var form = eval("document.submitForm");
		var frDt = form.cfrcStartDate.value;
		var toDt = form.cfrcEndDate.value;
		var applFrDt = form.applStartDate.value;
		var applToDt = form.applEndDate.value;

		//개최일
		var cFromDate = new Date(frDt.replace(/\./g, "/"));
		var cToDate = new Date(toDt.replace(/\./g, "/"));

		//신청기간
		var cApplFromDate = new Date(applFrDt.replace(/\./g, "/"));
		var cApplToDate = new Date(applToDt.replace(/\./g, "/"));


		if(name == 'cfrcStartDate') {
			if( cToDate < cFromDate) {
				alert("개최 시작일이 종료일자보다 큽니다.")
				form.cfrcStartDate.value = "";
				return true;
			}
		}

		if(name == 'cfrcEndDate') {
			if( cToDate < cFromDate) {
				alert("개최 종료일이 시작일자보다 작습니다.")
				form.cfrcEndDate.value = "";
				return true;
			} else if(cToDate <= cFromDate ) {
				alert("개최 시작일과 같을 수 없습니다. 상담회가 1일만 진행 될 경우 시작일만 입력해주세요.");
				form.cfrcEndDate.value = "";
				return true;
			}
		}

		if(name == 'applStartDate') {
			if( cApplToDate < cApplFromDate) {
				alert("신청기간 시작일이 종료일자보다 큽니다.")
				form.applStartDate.value = "";
				return true;
			}
		}

		if(name == 'applEndDate') {
			if( cApplToDate < cApplFromDate) {
				alert("신청기간 종료일이 시작일자보다 작습니다.")
				form.applEndDate.value = "";
				return true;
			}
		}

	}

</script>