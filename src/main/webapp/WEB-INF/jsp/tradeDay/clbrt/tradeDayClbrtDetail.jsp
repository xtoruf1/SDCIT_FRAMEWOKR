<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<script type="text/javascript">
	function fn_list() {
		$("#searchForm").attr("action","/tradeDay/clbrt/tradeDayClbrtList.do");
		$("#searchForm").submit();
	}
</script>

<!-- 페이지 위치 -->
<div class="location compact" style="margin-bottom: -10px;">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<!-- <button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnSndinAtndnResume();">이어서발송</button> -->
	<%--	<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnQrCodeTest();">테스트QR발급</button>--%>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnSndinAtndn();">참석모집발송</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnAwardRenewal();">수상데이터 갱신</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnQrCode();" id="qrCode" name="qrCode">QR발급</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnTradeDayPromotionSend();" id="promotionSend" name="promotionSend">홍보 알림톡 발송</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnSubmit();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
	</div>
</div>

<!-- 무역현장 컨설팅 상세 -->
<div class="page_tradesos">
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
		</div>
		<form name="submitForm" id="submitForm" method="post" enctype="multipart/form-data" >
		<input type="hidden" id="svrId" name="svrId" value="<c:out value="${resultData.svrId}"/>"/>
		<input type="hidden" name="closeChk" value="<c:out value="${resultData.closeChk}"/>"/>     <%-- 신청마감 체크 --%>
		<input type="hidden" name="limitYnChk" value="<c:out value="${resultData.limitYn}"/>"/>       <%-- 제한인원 Y : 무제한 / N : 제한 --%>
		<input type="hidden" name="cnfAtnYn" value="<c:out value="${resultData.cnfAtnYn}"/>"/>     <%-- 수상자 확정 체크 --%>
		<input type="hidden" name="qrYn" value="<c:out value="${resultData.qrYn}"/>"/>             <%-- QR코드 전송 여부 --%>

			<table class="boardwrite formTable">
				<colgroup>
					<col style="width:20%">
					<col>
					<col style="width:20%">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">행사명</th>
					<td>
						<input class="input form_text w100p" type="text" name="tradeDayTitle" id="tradeDayTitle" value="<c:out value="${resultData.tradeDayTitle}"/>">
					</td>
					<th scope="row">대리인 허용 여부</th>
					<td>
						<label class="label_form">
							<input type="radio" class="form_radio" name="delegatorYn" id="radio2_1" value="Y" <c:out value="${resultData.delegatorYn eq 'Y' ? 'checked' : '' }"/> checked>
							<span class="label">가능</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="delegatorYn" id="radio2_2" value="N" <c:out value="${resultData.delegatorYn eq 'N' ? 'checked' : '' }"/>>
							<span class="label">불가능</span>
						</label>
					</td>
				</tr>
				<tr>
					<th scope="row">제한인원</th>
					<td>
						<label class="label_form">
							<input type="radio" class="form_radio" name="limitYn" id="radio1_1" value="N" <c:out value="${resultData.limitYn eq 'N' ? 'checked' : '' }"/> checked>
							<span class="label">무제한</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="limitYn" id="radio1_2" value="Y" <c:out value="${resultData.limitYn eq 'Y' ? 'checked' : '' }"/>>
							<span class="label">제한</span>
						</label>
						<label class="label_form">
							<input class="input form_text w30p" type="text" name="limitMax" id="limitMax" maxlength="6" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="<c:out value="${resultData.limitMax}"/>"  <c:if test="${resultData.limitYn eq 'N' or resultData.limitYn eq null}">disabled="disabled"</c:if> >
							<span style="margin-left: 5px;">명</span>
						</label>
					</td>
					<th scope="row">허용 가능 동행인 수</th>
					<td>
						<label class="label_form">
							<input type="checkbox" style="padding-top: 6px;" name="companionMax_chk" id="companionMax_chk" class="form_checkbox" <c:out value="${resultData.companionMax != null ? 'checked' : ''}"/>>

							<input class="input form_text w30p" type="text" name="companionMax" id="companionMax" style="margin-left: 5px;" maxlength="1" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="<c:out value="${resultData.companionMax}"/>" <c:if test="${ resultData.companionMax eq null }">disabled</c:if>>
							<span style="margin-left: 5px;">명</span>
						</label>
					</td>
				</tr>
				<tr>
					<th scope="row">신청마감</th>
					<td>
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="closeYn" name="closeYn" value="${resultData.closeYn}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
							</div>
							<div class="spacing"> </div>
							<div class="form_row w20p">
								<select id="closeHh" name="closeHh"  class="form_select w40p">
									<c:forEach var="item" items="${COM021}" varStatus="status">
										<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq resultData.closeHh}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
									</c:forEach>
								</select>
								<span style="margin-left: 5px;">시</span>
							</div>

						</div>
					</td>
					<th scope="row">신청대상 선택</th>
					<td class="blindCheckbox">
						<%--<label class="label_form" style="padding-right: 50px;">
							<input type="checkbox" name="enterTypeCd"  value="99" class="form_checkbox uniqueCheck" onchange="blindCheck(this)" <c:out value="${resultData.enterTypeCd eq '21,22,30,60' ? 'checked' : ''}"/>>
							<span class="label">전체</span>
						</label>--%>
					<c:forEach var="data" items="${AWD005}" varStatus="status">
						<label class="label_form" style="padding-right: 50px; padding-top: 5px;">
							<input type="checkbox" name="enterTypeCd" class="form_checkbox normalCheck" onchange="blindCheck(this)" value="<c:out value="${data.detailcd eq '22' ? '22,23' : data.detailcd}"/>" <c:out value="${fn:contains(resultData.enterTypeCd, data.detailcd) ? 'checked' : ''}"/>>
							<span class="label"><c:out value="${data.detailnm}"/></span>
						</label>
					</c:forEach>
					</td>
				</tr>
				<tr>
					<th scope="row">모집현황</th>
					<td colspan="3">
						<span>모집대상 : &nbsp;<c:out value="${resultData.baseCnt}"/> </span>
						<span style="margin-left: 100px;">신청 : &nbsp;<c:out value="${resultData.expctAtendCnt}"/> </span>
						<span style="margin-left: 100px;">확정 : &nbsp;<c:out value="${resultData.cnfAtnCnt}"/> </span>
						<span style="margin-left: 100px;"> &#8251;&nbsp;확정 : 신청자중 수상확정자 </span>
					</td>
				</tr>
				</tbody>
			</table><!-- // 무역의날 기념식 관리 저장 테이블-->
		</form>
	</div>

	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">참석 대상자 목록</h3>
			<div class="ml-auto">
				<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
				<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
			</div>
		</div>
		<form name="searchForm" id="searchForm" action ="" method="get">
			<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
			<input type="hidden" name="svrId" value="<c:out value="${resultData.svrId}"/>"/>
			<input type="hidden" id="totalCount" name="totalCount" value="" default='0'>
			<input type="hidden" name="reqSendYn" value="<c:out value="${reqSendYn}"/>"/>
			<input type="hidden" name="praYear" value="<c:out value="${praYear}"/>"/>
			<div class="search">
				<table class="boardwrite formTable">
					<colgroup>
						<col style="width:10%">
						<col>
						<col style="width:10%">
						<col>
						<col style="width:10%">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">업체명</th>
							<td>
								<input type="text" name="companyName" class="form_text w100p" onkeydown="onEnter(doSearch);">
							</td>
							<th scope="row">무역업/사업자번호</th>
							<td>
								<select id="searchCondition" name="searchCondition" class="form_select" style="width:32% !important; max-width:32% !important;">
									<option value="tradeNo" <c:if test="${param.searchCondition eq 'tradeNo'}">selected="selected"</c:if>>무역업번호</option>
									<option value="businessNo" <c:if test="${param.searchCondition eq 'businessNo'}">selected="selected"</c:if>>사업자번호</option>
								</select>
								<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="textType form_text" style="width:67% !important; max-width:67% !important;" title="검색어" />
							</td>
							<th scope="row">참석자명</th>
							<td>
								<input type="text" name="attendName" class="form_text w100p" onkeydown="onEnter(doSearch);">
							</td>
						</tr>
						<tr>
							<th scope="row">수상자명</th>
							<td>
								<input type="text" name="laureateName" class="form_text w100p" onkeydown="onEnter(doSearch);">
							</td>
							<th scope="row">참석구분</th>
							<td>
								<label class="label_form">
									<input type="radio" name="attendTypeCd" id="radio4_1"  value="" checked="checked" class="form_radio">
									<span class="label">전체</span>
								</label>
								<label class="label_form">
									<input type="radio" name="attendTypeCd" id="radio4_2" value="01" class="form_radio">
									<span class="label">본인</span>
								</label>
								<label class="label_form">
									<input type="radio" name="attendTypeCd" id="radio4_3" value="02" class="form_radio">
									<span class="label">대리</span>
								</label>
								<label class="label_form">
									<input type="radio" name="attendTypeCd" id="radio4_4" value="03" class="form_radio">
									<span class="label">동행</span>
								</label>
							</td>
							<th scope="row">수령구분</th>
							<td>
								<label class="label_form">
									<input type="radio" name="searchCnd" id="radio7_1"  value="" checked="checked" class="form_radio">
									<span class="label">전체</span>
								</label>
								<label class="label_form">
									<input type="radio" name="searchCnd" id="radio7_2" value="01" class="form_radio">
									<span class="label">본인수령</span>
								</label>
								<label class="label_form">
									<input type="radio" name="searchCnd" id="radio7_3" value="02" class="form_radio">
									<span class="label">대리수령</span>
								</label>
							</td>
						</tr>
						<tr>
							<th scope="row">포상구분</th>
							<td>
								<select name="awardTypeCd" class="form_select w100p">
									<option value="">전체</option>
									<c:forEach var="item" items="${AWD045}" varStatus="status">
										<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
									</c:forEach>
								</select>
							</td>
							<th scope="row">수상여부</th>
							<td>
								<label class="label_form">
									<input type="radio" name="awardCd" id="radio5_1"  value="" checked="checked" class="form_radio">
									<span class="label">전체</span>
								</label>
								<label class="label_form">
									<input type="radio" name="awardCd" id="radio5_2" value="Y" class="form_radio">
									<span class="label">수상</span>
								</label>
								<label class="label_form">
									<input type="radio" name="awardCd" id="radio5_3" value="N" class="form_radio">
									<span class="label">미수상</span>
								</label>
							</td>
							<th scope="row">QR발송여부</th>
							<td>
								<label class="label_form">
									<input type="radio" name="qrCheckYn" id="radio6_1"  value="" checked="checked" class="form_radio">
									<span class="label">전체</span>
								</label>
								<label class="label_form">
									<input type="radio" name="qrCheckYn" id="radio6_2" value="Y" class="form_radio">
									<span class="label">발송</span>
								</label>
								<label class="label_form">
									<input type="radio" name="qrCheckYn" id="radio6_3" value="N" class="form_radio">
									<span class="label">미발송</span>
								</label>
							</td>
						</tr>
					</tbody>
				</table><!-- // 검색 테이블-->
			</div>

			<div class="cont_block mt-20">
				<div class="tbl_opt">
					<!-- 상담내역조회 -->
					<div id="tradeTotalCnt" class="total_count"></div>
					<fieldset class="ml-auto">
						<%--<button type="button" class="btn_sm btn_secondary btn_modify_auth" onclick="fnAttendDelete();">참석자삭제</button>--%>
						<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnAddAttend();">참석등록</button>
						<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnUseYnSave();">참석정보저장</button>
						<button type="button" class="btn_sm btn_primary btn_modify_auth" id="qrCodeIndvd" onclick="indvdQRRsend();">개별 QR 재발송</button>
						<button type="button" class="btn_sm btn_primary btn_modify_auth" id="qrCodeMMS" onclick="indvdQRMMSsend();">수령 QR MMS</button>
						<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="getExcelList();" >엑셀 다운</button>
						<select id="pageUnit" name="pageUnit" onchange="dataList();" title="목록수" class="form_select" style="margin-left:5px !important;">
							<c:forEach var="item" items="${pageUnitList}" varStatus="status">
								<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
							</c:forEach>
						</select>
					</fieldset>

				</div>
				<!-- 리스트 테이블 -->
				<div class="cont_block mt-20">
					<div style="width: 100%;height: 100%;">
						<div id='tblGrid2Sheet' class="colPosi"></div>
					</div>
					<!-- .paging-->
					<div id="pagingTrade" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
					<!-- //.paging-->
				</div>
			</div>
		</form>
	</div>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function () {

		// 제한인원 체크 이벤트
		$("input[name=limitYn]").on("change",function(){
			if ($(this).val() == 'Y'){
				$("input[name=limitMax]").attr('disabled', false);
			} else {
				$("input[name=limitMax]").val("");
				$("input[name=limitMax]").attr('disabled', true);
			}
		});

		//동행인 허용 인원수 체크 이벤트
		$("input[name=companionMax_chk]").on("change",function(){
			if($("#companionMax_chk").is(":checked")) {
				$("input[name=companionMax]").attr('disabled', false);
			} else {
				$("input[name=companionMax]").val("");
				$("input[name=companionMax]").attr('disabled', true);
			}
		});

		//행사전알림 체크 이벤트
		$("input[name=preevNtc_chk]").on("change",function(){
			if($("#preevNtc_chk").is(":checked")) {
				$("input[name=preevNtc]").attr('disabled', false);
			} else {
				$("input[name=preevNtc]").val("");
				$("input[name=preevNtc]").attr('disabled', true);
			}
		});

		f_Init_tblGrid2Sheet(); //업체이력 SHEET 세팅

		doSearch(); // 참석 대상자 조회

	});

	function f_Init_tblGrid2Sheet() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, SelectionRowsMode: 1, SizeMode: 1,  Alternate : 0, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});


		ibHeader.addHeader({Type: 'Status',		Header: '상태',				SaveName: 'status',					Hidden: true});
		ibHeader.addHeader({Type: "Text",		Header: "포상아이디",			SaveName: "svrId",					Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "참석자아이디",		SaveName: "attendId",				Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "신청아이디",			SaveName: "applySeq",				Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "무역의날기념식타이틀",	SaveName: "tradeDayTitle",			Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "등록자",       		SaveName: "creBy",					Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "회차",         		SaveName: "bsnSeq",					Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "행사참가여부",		SaveName: "hallEntranceYn",			Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "포상수령여부",		SaveName: "awardReceiptYn",			Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "수령구분",			SaveName: "delegateTypeCd",			Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "QR아이디",			SaveName: "qrId",					Hidden : true});
		ibHeader.addHeader({Type: "Text",		Header: "포상일",			SaveName: "priDt",					Hidden : true});
		ibHeader.addHeader({Type: 'DelCheck',	Header: '삭제',				SaveName: 'delCheck',				Width: 80, HeaderCheck : 0});
		ibHeader.addHeader({Type: 'CheckBox',	Header: '선택',				SaveName: 'check',					Width: 80, HeaderCheck : 0});
		ibHeader.addHeader({Type: "Text",		Header: "업체명",			SaveName: "companyName",			Align: "Left",		Width: 200, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "무역업번호", 		SaveName: "tradeNo",				Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "사업자번호",			SaveName: "businessNo",				Align: "Center", 	Width: 150, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "포상구분",			SaveName: "awardTypeNm",			Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "포상명",			SaveName: "prizeName",				Align: "Center", 	Width: 200, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "수상자명",			SaveName: "laureateName",			Align: "Center", 	Width: 100,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "수상자주민번호",		SaveName: "laureateJuminNo",		Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "수상자연락처",		SaveName: "laureatePhone",			Align: "Center", 	Width: 120, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "참석구분",			SaveName: "attendPurposeType",		Align: "Center", 	Width: 150, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "참석자명",			SaveName: "attendName",				Align: "Center", 	Width: 100,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "관계",				SaveName: "attendTypeNm",			Align: "Center", 	Width: 80, 		Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "내·외국인",			SaveName: "attendForeignNm",		Align: "Center", 	Width: 80, 		Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "참석자 주민번호",		SaveName: "attendJuminNo",			Align: "Center", 	Width: 120, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "참석자 연락처",		SaveName: "attendPhone",			Align: "Center", 	Width: 120, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "참석자 이메일",		SaveName: "attendEmail",			Align: "Left", 		Width: 180, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "참석자 여권번호",		SaveName: "passportNo",				Align: "Center", 	Width: 120, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "참석자 여권만료일",	SaveName: "passportExpiryDate",		Align: "Center", 	Width: 120, 	Edit: false, Hidden : true });
		ibHeader.addHeader({Type: "Button",		Header: "변경이력"	,		SaveName: "delegateHis",			Align: "Center",	Width: 100,		Cursor:"Pointer"});
		ibHeader.addHeader({Type: "Text",		Header: "포상수령자",			SaveName: "delegateName",			Align: "Center", 	Width: 100,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "포상주민번호",		SaveName: "delegateJuminNo",		Align: "Center", 	Width: 120,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "포상여권번호",		SaveName: "delegatePassportNo",		Align: "Center", 	Width: 120,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "포상수령자",			SaveName: "delegateName",			Align: "Center", 	Width: 100,		Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "포상수령자 연락처",	SaveName: "delegatePhone",			Align: "Center", 	Width: 120, 	Edit: true });
		ibHeader.addHeader({Type: "Text",		Header: "포상수령자 이메일",	SaveName: "delegateEmail",			Align: "Left", 		Width: 180, 	Edit: false, Hidden : true });
		ibHeader.addHeader({Type: "Text",		Header: "수상",				SaveName: "awardYn",				Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Combo",		Header: "대상여부",			SaveName: "useYn",					Align: "Center", 	Width: 120, 	ComboText: '대상|미대상', ComboCode: 'Y|N'});
		ibHeader.addHeader({Type: "Text",		Header: "참석",				SaveName: "attendYn",				Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "포상수령",			SaveName: "pickupYn",				Align: "Center", 	Width: 120, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "수출의탑 수령확인자",	SaveName: "topConfirmBy",			Align: "Center", 	Width: 150,		Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "수출의탑 수령확인일시",SaveName: "topConfirmDate",			Align: "Center", 	Width: 150, 	Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "개인포상 수령확인자",	SaveName: "confirmBy",				Align: "Center", 	Width: 150,		Edit: false });
		ibHeader.addHeader({Type: "Text",		Header: "개인포상 수령확인일시",SaveName: "confirmDate",			Align: "Center", 	Width: 150, 	Edit: false });


		var sheetId = "tblGrid2Sheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		//tblGrid2Sheet.SetEditable(0);
		//tblGrid2Sheet.SetSelectionMode(4);

	};

	/**
	 * 그리드 컬러 변경
	 * @param row
	 */
	function tblGrid2Sheet_OnRowSearchEnd(row) {
		notEditableCellColor('tblGrid2Sheet', row);
	}

	/**
	 * 페이징 세팅
	 * @param pageIndex
	 */
	function goPage(pageIndex) {
		document.searchForm.pageIndex.value = pageIndex;
		dataList();
	}

	function doSearch(){
		goPage(1);
	}

	/**
	 * 참석 대상자 목록 검색
	 */
	function dataList(){

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/tradeDayAttendListAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#tradeTotalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				setPaging(
					 'pagingTrade'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

				tblGrid2Sheet.LoadSearchData({Data: data.resultList});
			}
		});

	}

	/**
	 * 참석 등록
	 */
	function fnAddAttend(){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/tradeDay/clbrt/addAwardAttendInfo.do'
			, params : { svrId : $('#svrId').val() }
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				fnAddAttendDetail(resultObj.svrId,resultObj.applySeq,resultObj.awardTypeCd);
			}
		});
	}

	/**
	 * 참석 등록 상세
	 * @param svrId
	 * @param applySeq
	 * @param awardTypeCd
	 */
	function fnAddAttendDetail(svrId, applySeq, awardTypeCd){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/tradeDay/clbrt/addAwardAttendDetail.do'
			, params : { svrId : svrId
						,applySeq : applySeq
						,awardTypeCd : awardTypeCd
				}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				dataList();
			}
		});
	}

	/**
	 * ibSheet buttonEvent (변경이력 팝업 )
	 * @param row
	 * @param col
	 */
	function tblGrid2Sheet_OnButtonClick(row, col) {

		var pAttendId = tblGrid2Sheet.GetCellValue(row, 'attendId');    // 참석자아이디

		global.openLayerPopup({
			  // 레이어 팝업 URL
			  popupUrl : '<c:url value="/tradeDay/clbrt/delegateHistryPopup.do" />'
			, params : {  attendId : pAttendId
				}
			, callbackFunction : function(resultObj){
				closeLayerPopup();
				dataList();
			}
		});



	}

	function tblGrid2Sheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tblGrid2Sheet_OnSearchEnd : ', msg);
    	} else {

			var closeChk = $('input[name=closeChk]').val();
			// QR코드 발급 버튼
			if( closeChk == "N") {
				$('#qrCode').addClass('disabled');
				$('#qrCodeIndvd').addClass('disabled');
				$('#qrCodeMMS').addClass('disabled');
				$('#promotionSend').addClass('disabled');
				//$('#qrCode').attr('disabled', true);
			} else {
				$('#qrCode').removeClass('disabled');
				$('#qrCodeIndvd').removeClass('disabled');
				$('#qrCodeMMS').removeClass('disabled');
				$('#promotionSend').removeClass('disabled');
				//$('#qrCode').attr('disabled', false);
			}

			//수상자에게만 개별QR코드 발송 가능 체크
			var size = tblGrid2Sheet.RowCount();
			var firstIdx = tblGrid2Sheet.GetDataFirstRow();

			for(var i = firstIdx; i <= size; i++){

				var awardYn = tblGrid2Sheet.GetCellValue(i, 'awardYn');// 수상여부
				var useYn = tblGrid2Sheet.GetCellValue(i, 'useYn');    // 확정여부(법무부)

				if(awardYn == 'Y'){
					tblGrid2Sheet.SetCellEditable(i,"check", true);
				} else {
					tblGrid2Sheet.SetCellEditable(i,"check", false);
				}
			}
    	}
    }

	/**
	 * 상담내역조회 엑셀다운로드
	 */
	function getExcelList(){
		var totalCount = $("#totalCount").val();

		if(totalCount < 5000) { //최대 5,000건 다운로드 가능
			$("#searchForm").attr("action","/tradeDay/clbrt/tradeDayAttendExcelDown.do");
			$("#searchForm").submit();
		} else {
			alert("5,000건 이상 엑셀다운로드가 불가능 합니다.");
		}

	}


	var submitFlag = true;

	/**
	 * 상세 저장
	 */
	function fnSubmit(){

		if( $('input[name=limitYn]:checked').val() == "Y") {
			if ($("input[name=limitMax]").val().trim() == ""){
				alert("제한인원을 입력해주세요.");
				$("input[name=limitMax]").focus();
				return;
			}
		}

		if ($("input[name=closeYn]").val().trim() == ""){
			alert("신청마감을 입력해주세요.");
			$("input[name=closeYn]").focus();
			return;
		}


		if (submitFlag) {
			submitFlag = false;
			if (confirm('저장 하시겠습니까?')) {
				global.ajax({
					type: 'POST'
					, url: '<c:url value="/tradeDay/clbrt/tradeDayClbrtSave.do" />'
					, data: $('#submitForm').serialize()
					, dataType: 'json'
					, async: true
					, spinner: true
					, success: function (data) {
						window.location.reload(true);
					}
				});
			}
		}
	}

	/**
	 * 대상여부 저장
	 */
	function fnUseYnSave(){
		var pPramData = tblGrid2Sheet.GetSaveJson();

		if(pPramData.Code == 'IBS000') {
			alert("작업할 데이터가 없습니다.");
			return;
		}

		if (confirm('데이터를 저장 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: "/tradeDay/clbrt/tradeDayClbrtUseYnSave.do"
				, contentType: 'application/json'
				, data: JSON.stringify(pPramData.data)
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					window.location.reload(true);
				}
			});
		}
	}

	/**
	 * 참석모집발송(알림톡)
	 */
	function fnSndinAtndn() {
		$('#loading_image').show(); // 로딩이미지 시작
		if (confirm('참석모집발송시 약 5분정도 시간이 소요됩니다. \n참석모집알림톡을 발송 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/tradeDaySndinAtndn.do" />'
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

	/**
	 * 참석자모집 전송 중 끊겼을 시 이어서 발송
	 */
	function fnSndinAtndnResume() {
		$('#loading_image').show(); // 로딩이미지 시작
		if (confirm('참석모집발송시 약 5분정도 시간이 소요됩니다. \n참석모집알림톡을 발송 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeDay/clbrt/tradeDaySndinAtndnResume.do" />'
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

	/**
	 * 수상데이터 갱신
	 * @returns {boolean}
	 */
	function fnAwardRenewal() {
		$('#loading_image').show(); // 로딩이미지 시작
		if (confirm('수상데이터를 갱신하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeDay/clbrt/tradeDayAwardRenewal.do" />'
				, data : $('#submitForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#loading_image').hide(); // 로딩이미지 종료
					window.location.reload(true);
					doSearch();
					alert(data.MESSAGE);

				}
			});
		} else {
			$('#loading_image').hide(); // 로딩이미지 종료
		}
	}

	/**
	 * QR코드 발급
	 * @returns {boolean}
	 */
	function fnQrCode() {
		var closeChk = $('input[name=closeChk]').val();
		var	cnfAtnYn = $('input[name=cnfAtnYn]').val();
		var qrYn = $('input[name=qrYn]').val();
		var msg = "";

		if( closeChk == 'N') {  // 신청마감이 지났을 때(Y)
			alert("신청마감이 되지 않았습니다.");
			return false;
		} else {
			if( cnfAtnYn == 'Y') { // 수상자가 있을 경우
				if(qrYn == 'Y') { //전송한 이력 체크
					msg = "QR코드 발급한 이력이 있습니다. 다시 전체 발급하시겠습니까?";

				} else {
					msg = "QR코드를 전체 발급 하시겠습니까?";
				}

				$('#loading_image').show(); // 로딩이미지 시작
				if (confirm(msg)) {
					global.ajax({
						type: 'POST'
						, url: '<c:url value="/tradeDay/clbrt/tradeDaySendQrCode.do" />'
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

			} else {
				if( cnfAtnYn == 'N') {
					alert("수상자가 선정되지 않았았습니다.");
					return false;
				}
			}
		}
	}

	function fnQrCodeTest() {
		var closeChk = $('input[name=closeChk]').val();
		var	cnfAtnYn = $('input[name=cnfAtnYn]').val();
		var qrYn = $('input[name=qrYn]').val();
		var msg = "";

		if( closeChk == 'N') {  // 신청마감이 지났을 때(Y)
			alert("신청마감이 되지 않았습니다.");
			return false;
		} else {
			if( cnfAtnYn == 'Y') { // 수상자가 있을 경우
				if(qrYn == 'Y') { //전송한 이력 체크
					msg = "QR코드 발급한 이력이 있습니다. 다시 전체 발급하시겠습니까?";

				} else {
					msg = "QR코드를 전체 발급 하시겠습니까?";
				}

				$('#loading_image').show(); // 로딩이미지 시작
				if (confirm(msg)) {
					global.ajax({
						type: 'POST'
						, url: '<c:url value="/tradeDay/clbrt/tradeDaySendQrCodeTest.do" />'
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

			} else {
				if( cnfAtnYn == 'N') {
					alert("수상자가 선정되지 않았았습니다.");
					return false;
				}
			}
		}
	}

	/**
	 * 개별 QR코드 재발송
	 * @returns {boolean}
	 */
	function indvdQRRsend() {

		var chkRow = tblGrid2Sheet.FindCheckedRow('check');
		var closeChk = $('input[name=closeChk]').val();

		if( closeChk == 'N') {  // 신청마감이 지났을 때(Y)
			alert("신청마감이 되지 않았습니다.");
			return false;
		}

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return false;
		}

		var saveData = tblGrid2Sheet.GetSaveJson();
		$('#loading_image').show(); // 로딩이미지 시작
		if (confirm("개별QR 재발송 하시겠습니까?")) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeDay/clbrt/tradeDayQrCodeReSend.do" />'
				, contentType : 'application/json'
				, data : JSON.stringify(saveData.data)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#loading_image').hide(); // 로딩이미지 종료
					alert(data.MESSAGE);
				}
			});
		} else {
			$('#loading_image').hide(); // 로딩이미지 종료
		}

	}

	function indvdQRMMSsend() {

		var chkRow = tblGrid2Sheet.FindCheckedRow('check');
		var closeChk = $('input[name=closeChk]').val();

		if( closeChk == 'N') {  // 신청마감이 지났을 때(Y)
			alert("신청마감이 되지 않았습니다.");
			return false;
		}

		if(chkRow == '') {
			alert('선택한 항목이 없습니다.');
			return false;
		}

		var saveData = tblGrid2Sheet.GetSaveJson();
		$('#loading_image').show(); // 로딩이미지 시작
		if (confirm("개별QR 재발송 하시겠습니까?")) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeDay/clbrt/tradeDayQrCodeMMSSend.do" />'
				, contentType : 'application/json'
				, data : JSON.stringify(saveData.data)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#loading_image').hide(); // 로딩이미지 종료
					alert(data.MESSAGE);
				}
			});
		} else {
			$('#loading_image').hide(); // 로딩이미지 종료
		}

	}

	 /**
	 * 홍보 알림톡 발송(행사 0일 전 알림)
	 */
	function fnTradeDayPromotionSend() {
		global.ajax({
			type: 'POST'
			, url: '<c:url value="/tradeDay/clbrt/tradeDayPromotionSendCheck.do" />'
			, data: $('#submitForm').serialize()
			, dataType: 'json'
			, async: true
			, spinner: true
			, success: function (data) {

				var priDay = data.resultData.priDay;
				var msg = "행사 "+ priDay+ "일전 입니다. 발송하시겠습니까?"

				if( priDay == 0) {
					msg = "행사 당일 입니다. 발송하시겠습니까?"
				}
				$('#loading_image').show(); // 로딩이미지 시작
				if (confirm(msg)) {
					global.ajax({
						type: 'POST'
						, url: '<c:url value="/tradeDay/clbrt/tradeDayPromotionSend.do" />'
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
		});

	}

    /**
     * 참가자 임시 삭제용(테스트용)
     */
    function fnAttendDelete() {
        var chkRow = tblGrid2Sheet.FindCheckedRow('delCheck');

		if(chkRow == '') {
			alert('삭제할 참석자를 선택하세요.');
			return false;
		}

		var saveData = tblGrid2Sheet.GetSaveJson();

		if( confirm('선택한 참석자를 삭제하시겠습니까?') ){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeDay/clbrt/tradeDayAttendDelete.do" />'
				, contentType : 'application/json'
				, data : JSON.stringify(saveData.data)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					doSearch();
					alert(data.MESSAGE);
				}
			});
		}

    }


    function getAttendKey() {
    	var saveData = tblGrid2Sheet.GetSaveJson();
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/getAttendKey.do" />'
			, contentType : 'application/json'
			, data: JSON.stringify(saveData.data)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){}
		});

	}
</script>