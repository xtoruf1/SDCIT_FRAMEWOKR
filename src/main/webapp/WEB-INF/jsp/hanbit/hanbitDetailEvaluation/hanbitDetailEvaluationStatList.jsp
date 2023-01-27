<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(applicantDetailListExcelSheet, '한빛회_업체상세평가현황', '');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="doClear();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<form id="searchForm" method="post">
<div class="cont_block">
	<div class="search">
		<input type="hidden" id="pageIndex" name="pageIndex" value="1"/>
		<input type="hidden" id="traderId" name="traderId" value=""/>
		<input type="hidden" id="applId" name="applId" value=""/>
		<input type="hidden" id="exptBaseMonth" name="exptBaseMonth" value=""/>
		<input type="hidden" id="selectCount" name="selectCount" value=""/>
		<table class="formTable">
			<colgroup>
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:25%">
				<col style="width:11%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>회차</th>
					<td>
						<div class="field_set flex align_center">
							<span class="form_search w100p">
								<input type="hidden" id="searchTraderId" name="searchTraderId" value="${searchTraderId}"/>
								<input type="text" class="form_text"  title="기금융자" id="awardTitle" name="awardTitle" maxlength="150" readonly="readonly" value="<c:out value="${params.awardTitle}"/>" />
								<button type="button" class="btn_icon btn_search" title="기금융자 검색" onclick="openSearchPopup()"></button>
							</span>
						</div>
					</td>
					<th>선정일</th>
					<td colspan="5">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchRegStartDt" id="searchRegStartDt" value="${param.searchRegStartDt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchRegStartDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="searchRegEndDt" id="searchRegEndDt" value="${param.searchRegEndDt}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" class="dateClear" onclick="clearPickerValue('searchRegEndDt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>업체명</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchCompanyName" id="searchCompanyName"  value="<c:out value="${ param.searchCompanyName }" />" onkeydown="onEnter(doSearch);"/>
					</td>
					<th>사업자번호</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="searchBusinessNo" id="searchBusinessNo"  value="<c:out value="${ param.searchBusinessNo }" />" onkeydown="onEnter(doSearch);"/>
					</td>
					<th>무역업번호</th>
					<td colspan="3">
						<input type="text" class="form_text w100p" name="searchTradeNo" id="searchTradeNo" value="<c:out value="${ param.searchTradeNo }" />" onkeydown="onEnter(doSearch);" />
					</td>
				</tr>
				<tr>
					<th>대표자</th>
					<td>
						<input type="text" class="form_text w100p" name="searchCeoName" id="searchCeoName" value="<c:out value="${ param.searchCeoName }" />"  onkeydown="onEnter(doSearch);"/>
					</td>
					<th>평가점수</th>
					<td>
						<input type="text" class="form_text" style="width: 95px;" name="searchStartScore" id="searchStartScore" value="<c:out value="${ param.searchCorpRegNo }" />"  onkeydown="onEnter(doSearch);"/>
						<span> ~ </span>
						<input type="text" class="form_text" style="width: 95px;" name="searchEndScore" id="searchEndScore" value="<c:out value="${ param.searchCorpRegNo }" />" onkeydown="onEnter(doSearch);" />
					</td>
					<th>선정여부</th>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="" <c:if test="${ param.searchStatus eq '' }">checked</c:if> checked>
							<span class="label">전체</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="Y" <c:if test="${ param.searchStatus eq 'Y' }">checked</c:if>>
							<span class="label">선정</span>
						</label>

						<label class="label_form">
							<input type="radio" class="form_radio" name="searchStatus" value="N" <c:if test="${ param.searchStatus eq 'N' }">checked</c:if>>
							<span class="label">미선정</span>
						</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>


<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>

		<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
			<c:forEach var="item" items="${pageUnitList}" varStatus="status">
				<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
			</c:forEach>
		</select>
	</div>
	<div style="width: 100%;">
		<div id="applicantDetailListSheet" class="sheet"></div>
	</div>
	<div id="paging" class="paging ibs"></div>

	<div style="width: 100%;">
		<div id="applicantDetailListExcelSheet" class="sheet"></div>
	</div>
</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_applicantDetailList();				// 사업 리스트 헤더
		getApplicantDetailList();							// 사업 리스트 조회
		setSheetHeader_applicantDetailListExcel();
		getApplicantDetailListExcel();

	});

	function setSheetHeader_applicantDetailList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: 'No|No|No'										, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '회차|회차|회차'									, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|업체명|업체명'								, Type: 'Text'			, SaveName: 'companyName'		, Edit: false	, Width: 120	, Align: 'Left'});
		ibHeader.addHeader({Header: '업체현황|무역업번호|무역업번호'						, Type: 'Text'			, SaveName: 'tradeNo'			, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|사업자번호|사업자번호'						, Type: 'Text'			, SaveName: 'businessNo'		, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|대표자|대표자'								, Type: 'Text'			, SaveName: 'ceoName'			, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|4년 전 수출액|4년 전 수출액'		, Type: 'Int'			, SaveName: 'beforeExpAmt'		, Edit: false	, Width: 120	, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 전|수출액'				, Type: 'Int'			, SaveName: 'threeYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 전|증가율'				, Type: 'Text'			, SaveName: 'threeYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|2년 전|수출액'				, Type: 'Int'			, SaveName: 'twoYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|2년 전|증가율'				, Type: 'Text'			, SaveName: 'twoYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|현재|수출액'					, Type: 'Int'			, SaveName: 'oneYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|현재|증가율'					, Type: 'Text'			, SaveName: 'oneYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 평균 증가율|3년 평균 증가율'	, Type: 'Float'			, SaveName: 'extRateAvg'		, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|기준점수|기준점수'				, Type: 'Int'			, SaveName: 'extBaseScore'	, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|가중치|가중치'					, Type: 'Float'			, SaveName: 'weightRate'		, Edit: false	, Width: 80		, Align: 'Center', Format: "#,##0.0"});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|점수|점수'					, Type: 'Float'			, SaveName: 'extRateScore'		, Edit: false	, Width: 80		, Align: 'Center', Format: "#,##0.0", BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '수출규모|최근수출금액|최근수출금액'						, Type: 'Int'			, SaveName: 'lastExpAmt'		, Edit: false	, Width: 120	, Align: 'Right'});
		ibHeader.addHeader({Header: '수출규모|점수|점수'									, Type: 'Int'			, SaveName: 'extSizeScore'		, Edit: false	, Width: 80		, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '해외매출 비중|매출 비중|매출 비중'						, Type: 'Float'			, SaveName: 'overRate'			, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '해외매출 비중|점수|점수'								, Type: 'Int'			, SaveName: 'overRateScore'		, Edit: false	, Width: 80		, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '직수출 비중|비중|비중'								, Type: 'Float'			, SaveName: 'directRate'		, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '직수출 비중|점수|점수'								, Type: 'Int'			, SaveName: 'directRateScore'	, Edit: false	, Width: 80		, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '기술개발|기업부설연구소|기업부설연구소'					, Type: 'Text'			, SaveName: 'researchYn'		, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '기술개발|국내,해외인증|국내,해외인증'					, Type: 'Int'			, SaveName: 'totalCertCount'	, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '기술개발|점수|점수'									, Type: 'Int'			, SaveName: 'researchScore'		, Edit: false	, Width: 100	, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '업력|연수|연수'									, Type: 'Int'			, SaveName: 'since'				, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '업력|점수|점수'									, Type: 'Int'			, SaveName: 'sinceScore'		, Edit: false	, Width: 100	, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '재무제표|영업이익|영업이익'							, Type: 'Text'			, SaveName: 'profitYear'		, Edit: false	, Width: 200	, Align: 'Left'});
		ibHeader.addHeader({Header: '재무제표|점수|점수'									, Type: 'Int'			, SaveName: 'profitScore'		, Edit: false	, Width: 100	, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '크레탑 신용반영|등급|등급'							, Type: 'Text'			, SaveName: 'creditRating'		, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '크레탑 신용반영|점수|점수'							, Type: 'Int'			, SaveName: 'creditScore'		, Edit: false	, Width: 100	, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '대표이사 재직기간|재직기간|재직기간'						, Type: 'Int'			, SaveName: 'ceoTenure'			, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '대표이사 재직기간|점수|점수'							, Type: 'Int'			, SaveName: 'ceoScore'			, Edit: false	, Width: 100	, Align: 'Center', BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '심사위원평가|심사위원평가|심사위원평가'					, Type: 'Int'			, SaveName: 'judgeScore'		, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '총점|총점|총점'									, Type: 'Float'			, SaveName: 'totScore'			, Edit: false	, Width: 80		, Align: 'Center', Format: "#,##0.0" , BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '한빛회ID'										, Type: 'Text'			, SaveName: 'traderId'			, Hidden: true});
		ibHeader.addHeader({Header: '한빛회신청ID'										, Type: 'Text'			, SaveName: 'applId'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:6, MergeSheet: msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1 });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var container = $('#applicantDetailListSheet')[0];
		createIBSheet2(container, 'applicantDetailListSheet', '100%', '600px');
		ibHeader.initSheet('applicantDetailListSheet');

		applicantDetailListSheet.SetEllipsis(1); // 말줄임 표시여부
		applicantDetailListSheet.SetSelectionMode(4);
	}

	function setSheetHeader_applicantDetailListExcel() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: 'No|No|No'										, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '회차|회차|회차'									, Type: 'Text'			, SaveName: 'awardRound'		, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|업체명|업체명'								, Type: 'Text'			, SaveName: 'companyName'		, Edit: false	, Width: 120	, Align: 'Left'});
		ibHeader.addHeader({Header: '업체현황|무역업번호|무역업번호'						, Type: 'Text'			, SaveName: 'tradeNo'			, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|사업자번호|사업자번호'						, Type: 'Text'			, SaveName: 'businessNo'		, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '업체현황|대표자|대표자'								, Type: 'Text'			, SaveName: 'ceoName'			, Edit: false	, Width: 60		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|4년 전 수출액|4년 전 수출액'		, Type: 'Int'			, SaveName: 'beforeExpAmt'		, Edit: false	, Width: 120	, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 전|수출액'				, Type: 'Int'			, SaveName: 'threeYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 전|증가율'				, Type: 'Text'			, SaveName: 'threeYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|2년 전|수출액'				, Type: 'Int'			, SaveName: 'twoYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|2년 전|증가율'				, Type: 'Text'			, SaveName: 'twoYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|현재|수출액'					, Type: 'Int'			, SaveName: 'oneYearAmt'		, Edit: false	, Width: 80		, Align: 'Right'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|현재|증가율'					, Type: 'Text'			, SaveName: 'oneYearRate'		, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|3년 평균 증가율|3년 평균 증가율'	, Type: 'Float'			, SaveName: 'extRateAvg'		, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|기준점수|기준점수'				, Type: 'Int'			, SaveName: 'extBaseScore'	, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|가중치|가중치'					, Type: 'Float'			, SaveName: 'weightRate'		, Edit: false	, Width: 80		, Align: 'Center', Format: "#,##0.0"});
		ibHeader.addHeader({Header: '최근 3년 평균 수출 증가율|점수|점수'					, Type: 'Float'			, SaveName: 'extRateScore'		, Edit: false	, Width: 80		, Align: 'Center', Format: "#,##0.0", BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '수출규모|최근수출금액|최근수출금액'						, Type: 'Int'			, SaveName: 'lastExpAmt'		, Edit: false	, Width: 120	, Align: 'Right'});
		ibHeader.addHeader({Header: '수출규모|점수|점수'									, Type: 'Int'			, SaveName: 'extSizeScore'		, Edit: false	, Width: 80		, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '해외매출 비중|매출 비중|매출 비중'						, Type: 'Float'			, SaveName: 'overRate'			, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '해외매출 비중|점수|점수'								, Type: 'Int'			, SaveName: 'overRateScore'		, Edit: false	, Width: 80		, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '직수출 비중|비중|비중'								, Type: 'Float'			, SaveName: 'directRate'		, Edit: false	, Width: 120	, Align: 'Center'	, Format: "#,##0.00\\%"});
		ibHeader.addHeader({Header: '직수출 비중|점수|점수'								, Type: 'Int'			, SaveName: 'directRateScore'	, Edit: false	, Width: 80		, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '기술개발|기업부설연구소|기업부설연구소'					, Type: 'Text'			, SaveName: 'researchYn'		, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '기술개발|국내,해외인증|국내,해외인증'					, Type: 'Int'			, SaveName: 'totalCertCount'	, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '기술개발|점수|점수'									, Type: 'Int'			, SaveName: 'researchScore'		, Edit: false	, Width: 100	, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '업력|연수|연수'									, Type: 'Int'			, SaveName: 'since'				, Edit: false	, Width: 80		, Align: 'Center'});
		ibHeader.addHeader({Header: '업력|점수|점수'									, Type: 'Int'			, SaveName: 'sinceScore'		, Edit: false	, Width: 100	, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '재무제표|영업이익|영업이익'							, Type: 'Text'			, SaveName: 'profitYear'		, Edit: false	, Width: 200	, Align: 'Left'});
		ibHeader.addHeader({Header: '재무제표|점수|점수'									, Type: 'Int'			, SaveName: 'profitScore'		, Edit: false	, Width: 100	, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '크레탑 신용반영|등급|등급'							, Type: 'Text'			, SaveName: 'creditRating'		, Edit: false	, Width: 100	, Align: 'Center'});
		ibHeader.addHeader({Header: '크레탑 신용반영|점수|점수'							, Type: 'Int'			, SaveName: 'creditScore'		, Edit: false	, Width: 100	, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '대표이사 재직기간|재직기간|재직기간'						, Type: 'Int'			, SaveName: 'ceoTenure'			, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '대표이사 재직기간|점수|점수'							, Type: 'Int'			, SaveName: 'ceoScore'			, Edit: false	, Width: 100	, Align: 'Center'	, BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '심사위원평가|심사위원평가|심사위원평가'					, Type: 'Int'			, SaveName: 'judgeScore'		, Edit: false	, Width: 120	, Align: 'Center'});
		ibHeader.addHeader({Header: '총점|총점|총점'									, Type: 'Float'			, SaveName: 'totScore'			, Edit: false	, Width: 80		, Align: 'Center'	, Format: "#,##0.0" , BackColor: "#EEE6C4"});
		ibHeader.addHeader({Header: '한빛회ID'										, Type: 'Text'			, SaveName: 'traderId'			, Hidden: true});
		ibHeader.addHeader({Header: '한빛회신청ID'										, Type: 'Text'			, SaveName: 'applId'			, Hidden: true});

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:6, MergeSheet: msHeaderOnly });
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var container = $('#applicantDetailListExcelSheet')[0];
		createIBSheet2(container, 'applicantDetailListExcelSheet', '100%', '600px');
		ibHeader.initSheet('applicantDetailListExcelSheet');

		applicantDetailListExcelSheet.SetEllipsis(1); // 말줄임 표시여부
		applicantDetailListExcelSheet.SetVisible(0);

		// 시작일 선택 이벤트
		datepickerById('searchSelectStartDt', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('searchSelectEndDt', toDateSelectEvent);
	}

	// sort시 스크롤 상위로 이동
	function applicantDetailListSheet_OnSort(col, order) {
		applicantDetailListSheet.SetScrollTop(0);
	}

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchSelectStartDt').val());

		if ($('#searchSelectEndDt').val() != '') {
			if (startymd > Date.parse($('#searchSelectEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchSelectStartDt').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchSelectEndDt').val());

		if ($('#searchSelectStartDt').val() != '') {
			if (endymd < Date.parse($('#searchSelectStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchSelectEndDt').val('');

				return;
			}
		}
	}

	function doSearch() {
		$('#pageIndex').val(1);
		getApplicantDetailList();
		getApplicantDetailListExcel();
	}

	function goPage(pageIndex) {	// 페이징 함수
		$('#pageIndex').val(pageIndex);
		getApplicantDetailList();
	}

	function chgPageCnt() {
		doSearch();
	}

	function applicantDetailListSheet_OnRowSearchEnd(row) {	// 시트

		if(applicantDetailListSheet.GetCellValue(row, 'creditRating') == '미반영') {
			applicantDetailListSheet.SetCellFontColor(row ,'creditRating' ,"#FF0000");

		}
	}

	function getApplicantDetailList() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitDetailEvaluation/selectHanbitDetailEvaluationStatList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				setPaging(	// 페이징
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				applicantDetailListSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function getApplicantDetailListExcel() {	// 회사 조회

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitDetailEvaluation/hanbitDetailEvaluationStatListExcelDown.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				applicantDetailListExcelSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function doClear() {	// 초기화
		location.reload();
	}

	function openSearchPopup() {

		global.openLayerPopup({
			popupUrl : '/hanbit/popup/hanbitSearchPop.do'
			, callbackFunction : function(resultObj){

				$("#searchTraderId").val(resultObj.traderId);			// 한빛회ID
				$("#awardTitle").val(resultObj.awardTitle);	// 회차명
				$("#sendYn").val(resultObj.sendYn);	// 회차명

				getApplicantDetailList();
				getApplicantDetailListExcel();
			}
		});
	}

</script>