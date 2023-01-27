<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value="" />
<input type="hidden" id="statusChk" name="statusChk" value="" />
<input type="hidden" id="svrId" name="svrId" value="<c:out value="${svrId}" />" />
<input type="hidden" id="applySeq" name="applySeq" value="<c:out value="${applySeq}" />" />
<input type="hidden" id="readYn" name="readYn" value="Y" />
<input type="hidden" id="listPage" name="listPage" value="/tdms/asm/tradeDayApplicationCheck.do" />
<input type="hidden" id="bsnAplDt" name="bsnAplDt" value="<c:out value="${bsnAplDt}" />" />
<input type="hidden" id="priType" name="priType" value="<c:out value="${pritype}" />" />
<input type="hidden" id="priTypeNm" name="priTypeNm" value="" />
<input type="hidden" id="memberId" name="memberId" value="<c:out value="${memberId}" />" />
<input type="hidden" id="proxyYn" name="proxyYn" value="Y" />
<input type="hidden" id="tempFileId" name="tempFileId" value="" />
<input type="hidden" id="appEditYn" name="appEditYn" value="Y" />
<input type="hidden" id="receiptNo" name="receiptNo" value="<c:out value="${receiptNo}" />" />
<input type="text" id="displayNone" name="displayNone" style="display: none;" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doSend();" class="btn_sm btn_primary">통보</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doExcel();" class="btn_sm btn_primary">엑셀 다운</button>
		<button type="button" onclick="clearForm('foldingTable_inner');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="getList();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="cont_block">
	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tr>
					<th>포상명</th>
					<td>
						<span class="form_search">
							<input type="text" id="searchBsnNm" name="searchBsnNm" value="<c:out value="${searchBsnNm}"/>" class="form_text" style="font-size: 14px;" readonly="readonly" />
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
							<button type="button" class="btn_icon btn_search" onclick="openLayerDlgSearchAwardPop();" title="포상검색"></button>
						</span>
					</td>
					<th>신청구분</th>
					<td>
						<select id="searchKongSt" name="searchKongSt" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${kongStSelect}" varStatus="status">
								<option value="${list.codeCd}"><c:out value="${list.codeNm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>회사명</th>
					<td>
						<input type="text" id="searchCoNmKr" name="searchCoNmKr" value="" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
				</tr>
				<tr>
					<th>대상자</th>
					<td>
						<input type="text" id="searchUserNmKor" name="searchUserNmKor" value="" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
					<th>접수번호</th>
					<td>
						<input type="text" id="searchReceiptNo" name="searchReceiptNo" value="" onkeydown="onEnter(getList);" maxlength="30" class="form_text" />
					</td>
					<th>업체구분</th>
					<td>
						<select id="searchScale" name="searchScale" class="form_select">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>사업자번호</th>
					<td>
						<input type="text" id="searchBsNo" name="searchBsNo" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="10" class="form_text" />
					</td>
					<th>무역업번호</th>
					<td>
						<input type="text" id="searchMemberId" name="searchMemberId" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="8" class="form_text" />
					</td>
					<th>포상구분</th>
					<td>
						<select id="searchPriType" name="searchPriType" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd001Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.detailnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>검토여부</th>
					<td>
						<select id="searchChkYn" name="searchChkYn" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd010Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.chgCode01}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>특이업체</th>
					<td>
						<select id="searchSpecialYn" name="searchSpecialYn" class="form_select">
							<option value="">전체</option>
							<c:forEach var="list" items="${awd010Select}" varStatus="status">
								<option value="<c:out value="${list.detailcd}" />"><c:out value="${list.chgCode02}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>지역구분</th>
					<td>
						<select id="searchTradeDept" name="searchTradeDept" class="form_select">
							<c:if test="${deptAllYn eq 'Y'}">
								<option value="">전체</option>
							</c:if>
							<c:forEach var="list" items="${com001Select}" varStatus="status">
								<option value="<c:out value="${list.chgCode03}" />"><c:out value="${list.detailsortnm}" /></option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">특이사항</th>
					<td colspan="5">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchConsumYn" name="searchConsumYn" value="Y" />
							<span class="label">소비재 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchElectronicYn" name="searchElectronicYn" value="Y" />
							<span class="label">전자상거래 활용 업체</span>
						</label>

						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchExportYn" name="searchExportYn" value="Y" />
							<span class="label">수출국 다변화 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchWorknewYn" name="searchWorknewYn" value="Y" />
							<span class="label">무역일자리 창출 업체</span>
						</label>

						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchNewgenYn" name="searchNewgenYn" value="Y" />
							<span class="label">신성장산업 업체</span>
						</label>
					</td>
				</tr>
				<tr>
					<td colspan="5">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchKCleanYn" name="searchKCleanYn" value="Y" />
							<span class="label">K-방역 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchKEsgYn" name="searchKEsgYn" value="Y" />
							<span class="label">K-ESG 업체</span>
						</label>

						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchKDefenseYn" name="searchKDefenseYn" value="Y" />
							<span class="label">K-방산 업체</span>
						</label>

						<label class="label_form">
							<input type="checkbox" class="form_checkbox" id="searchExplogiYn" name="searchExplogiYn" value="Y" />
							<span class="label">수출물류 업체</span>
						</label>
					</td>
				</tr>
				<tr>
					<th>특별탑 신청여부</th>
					<td>
						<select id="searchSpeTapYn" name="searchSpeTapYn" class="form_select">
							<option value="">전체</option>
							<option value="A">특별탑 신청 전체</option>
							<option value="Y">특별탑, 수출의탑 동시신청</option>
							<option value="H">특별탑만 신청</option>
							<option value="N">신청하지 않음</option>
						</select>
					</td>
					<th>특별탑 신청분야</th>
					<td colspan="3">
						<select id="searchSpeTapCd" name="searchSpeTapCd" class="form_select">
							<option value="">전체</option>
							<option value="10">(문화)콘텐츠</option>
							<option value="20">(보건)의료/헬스케어</option>
							<option value="30">(교육)에듀테크</option>
							<option value="40">(ICT)디지털서비스</option>
							<option value="50">(금융)핀테크</option>
							<option value="60">(기술)엔지니어링</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>
</div>
<div class="cont_block" style="margin-top: 30px !important;">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_tradeDayApplicationCheckSheet();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayApplicationCheckSheet() {
		var	ibHeader = new IBHeader();
		var initSheet = {};

		ibHeader.addHeader({Header:"No|No",									Type:"Text",      Hidden:1,	Width:60,   Align:"Center",  SaveName:"no" });
        ibHeader.addHeader({Header:"|",										Type:"Status",    Hidden:1, Width:60,   Align:"Center",  SaveName:"status" });
        ibHeader.addHeader({Header:"포상ID|포상ID",							Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"svrId",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID|포상신청ID",						Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"applySeq",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호|접수번호",							Type:"Text",      Hidden:0,	Width:150,  Align:"Left",    ColMerge:1,   SaveName:"receiptNo",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"본부코드|본부코드",							Type:"Text",      Hidden:1, Width:100,  Align:"Center",  ColMerge:1,   SaveName:"tradeDept",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호|무역업번호",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"memberId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"수정일자|수정일자",							Type:"Text",      Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"updDate",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"신청일자|신청일자",							Type:"Text",      Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"reqDate",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"신청상태|신청상태",							Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"stateGb",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"업체명|업체명",							Type:"Text",      Hidden:0,	Width:180,  Align:"Left",    ColMerge:1,   SaveName:"coNmKr",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"업체명_영문|업체명_영문",						Type:"Text",      Hidden:1,	Width:100,  Align:"Left",  ColMerge:1,   SaveName:"coNmEn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자|대표자",								Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"ceoKr",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대표자_영문|대표자_영문",						Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"ceoEn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체구분|업체구분",							Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"scale",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분|포상구분",							Type:"Combo",     Hidden:0,	Width:130,  Align:"Left",    ColMerge:1,   SaveName:"priType",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}', BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"추천기관|추천기관",							Type:"Text",      Hidden:0,	Width:180,  Align:"Left",    ColMerge:1,   SaveName:"spRecOrg",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"담당자연락처|담당자연락처",						Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userPhone",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_핸드폰|담당자_핸드폰",					Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userHp",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

        ibHeader.addHeader({Header:"담당자_이름|담당자_이름",						Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userNm",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_이메일|담당자_이메일",					Type:"Text",      Hidden:1,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"userEmail",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청탑|신청탑",								Type:"Text",      Hidden:1,	Width:130,  Align:"Left",    ColMerge:1,   SaveName:"expTapPrizeCd",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청탑|신청탑",								Type:"Text",      Hidden:0,	Width:100,  Align:"Left",    ColMerge:1,   SaveName:"expTapPrizeNm",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"첨부(업체)|첨부(업체)",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"corpFileCnt",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"첨부파일ID|첨부파일ID",						Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"attFileId",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청자첨부파일|대표자",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"scFileCnt",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"신청자첨부파일|대표자FILE_ID",					Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"scFileId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청자첨부파일|사무직",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"seFileCnt",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"신청자첨부파일|사무직FILE_ID",					Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"seFileId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청자첨부파일|생산직",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"swFileCnt",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"신청자첨부파일|생산직FILE_ID",					Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"swFileId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청자첨부파일|특수유공",						Type:"Text",      Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"spFileCnt",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, BackColor: '#f6f6f6', Cursor:"Pointer" });
        ibHeader.addHeader({Header:"신청자첨부파일|특수유공FILE_ID",				Type:"Text",      Hidden:1,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"spFileId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"검토확인|검토확인",							Type:"CheckBox",  Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"chkYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"검토내용|검토내용",							Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"remark",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 });
        ibHeader.addHeader({Header:"담당자|담당자",								Type:"Text",      Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"managerId",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"서류검토일자|서류검토일자",						Type:"Text",      Hidden:0,	Width:120,  Align:"Center",  ColMerge:1,   SaveName:"arrivalDocDate",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"서류도착확인|서류도착확인",						Type:"CheckBox",  Hidden:0,	Width:120,  Align:"Center",  ColMerge:1,   SaveName:"arrivalDocYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"발송여부|발송여부",							Type:"Text",      Hidden:1,	Width:120,  Align:"Center",  ColMerge:1,   SaveName:"sendYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 });
        ibHeader.addHeader({Header:"서비스업여부|서비스업여부",						Type:"CheckBox",  Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"serviceNewYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"K방역여부|K방역여부",							Type:"CheckBox",  Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"kCleanYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"K-ESG여부|K-ESG여부",						Type:"CheckBox",  Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"kEsgYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"소비재업체|소비재업체",						Type:"CheckBox",  Hidden:0,	Width:100,  Align:"Center",  ColMerge:1,   SaveName:"consumYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"전자상거래활용|전자상거래활용",					Type:"CheckBox",  Hidden:0,	Width:130,  Align:"Center",  ColMerge:1,   SaveName:"electronicYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"수출국다변화|수출국다변화",						Type:"CheckBox",  Hidden:0,	Width:130,  Align:"Center",  ColMerge:1,   SaveName:"exportYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"신성장산업|신성장산업",						Type:"CheckBox",  Hidden:0,	Width:130,  Align:"Center",  ColMerge:1,   SaveName:"newgenYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"무역일자리창출|해당여부",						Type:"CheckBox",  Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"worknewYn",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"무역일자리창출|전년도직원수",					Type:"Float",     Hidden:0,	Width:130,  Align:"Right",   ColMerge:1,   SaveName:"pastWorkerCnt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"무역일자리창출|당해년도직원수",					Type:"Float",     Hidden:0,	Width:130,  Align:"Right",   ColMerge:1,   SaveName:"currWorkerCnt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"특이업체|특이업체",							Type:"CheckBox",  Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"specialYn",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"업체특성|업체특성",							Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"specialContent",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:1000 });
        ibHeader.addHeader({Header:"취소|취소",								Type:"CheckBox",  Hidden:0,	Width:80,   Align:"Center",  ColMerge:1,   SaveName:"cancelYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:30, HeaderCheck: 0, TrueValue: 'Y', FalseValue: 'N' });
        ibHeader.addHeader({Header:"취소사유|취소사유",							Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"cancelReason",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:1000 });
        ibHeader.addHeader({Header:"감사의견|감사의견",							Type:"Combo",     Hidden:0,	Width:100,  Align:"Left",    ColMerge:1,   SaveName:"gamsaGb",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500, ComboCode: '${awd040Sheet.detailcd}' , ComboText: '${awd040Sheet.detailnm}' });
        ibHeader.addHeader({Header:"감사의견기타사유|감사의견기타사유",				Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"gamsaEtc",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"비고(유형)구분|비고(유형)구분",					Type:"Combo",     Hidden:0,	Width:100,  Align:"Left",    ColMerge:1,   SaveName:"bigoGb",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500, ComboCode: '${awd041Sheet.detailcd}' , ComboText: '${awd041Sheet.detailnm}' });
        ibHeader.addHeader({Header:"비고(유형)기타사유|비고(유형)기타사유",			Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"bigoEtc",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"메모|메모",								Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"etcMsg",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"신기술개발품목명|신기술개발품목명",				Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"newTechItemNm",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"신기술개발인정기관|신기술개발인정기관",				Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"newTechTerm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"정부기술개발참여_사업명|정부기술개발참여_사업명",		Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"govTechNm",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"정부기술개발참여_시행기관|정부기술개발참여_시행기관",	Type:"Text",      Hidden:0,	Width:250,  Align:"Left",    ColMerge:1,   SaveName:"govTechInst",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"수입대체상품생산_품목명|수입대체상품생산_품목명",		Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"impReplItemNm",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"수입대체상품생산_품목수|수입대체상품생산_품목수",		Type:"Float",     Hidden:0,	Width:200,  Align:"Right",    ColMerge:1,   SaveName:"impReplItemCnt",         CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"자기상표제품수출_상표명|자기상표제품수출_상표명",		Type:"Text",      Hidden:0,	Width:300,  Align:"Left",    ColMerge:1,   SaveName:"selfBrandExpItemNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"자기상표제품수출_상표수|자기상표제품수출_상표수",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",    ColMerge:1,   SaveName:"selfBrandExpCnt",        CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"자기상표제품수출_품목수|자기상표제품수출_품목수",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",    ColMerge:1,   SaveName:"selfBrandExpItemCnt",    CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:'${chkVal}',   InsertEdit:'${chkVal}',   EditLen:500 });
        ibHeader.addHeader({Header:"전전년도직수출|전전년도직수출",					Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoDrExpAmt",            CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도직수출|전년도직수출",						Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastDrExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도직수출|당해년도직수출",					Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currDrExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도직수출증가율|전년도직수출증가율",				Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoDrExpAmtRate",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도직수출증가율|당해년도직수출증가율",			Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastDrExpAmtRate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"직수출증가율|직수출증가율",						Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currDrExpAmtRate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도무체물실적|전전년도무체물실적",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLc1ExpAmt",            CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도무체물실적|전년도무체물실적",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLc1ExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도무체물실적|당해년도무체물실적",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLc1ExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도KTNET실적|전전년도KTNET실적",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLc2ExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도KTNET실적|전년도KTNET실적",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLc2ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도KTNET실적|당해년도KTNET실적",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLc2ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도전자상거래실적|전전년도전자상거래실적",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLc3ExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도전자상거래실적|전년도전자상거래실적",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLc3ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도전자상거래실적|당해년도전자상거래실적",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLc3ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도기타수출|전전년도기타수출",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLc4ExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도기타수출|전년도기타수출",					Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLc4ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도기타수출|당해년도기타수출",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLc4ExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도로컬등기타수출|전전년도로컬등기타수출",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLcExpAmt",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도로컬등기타수출|전년도로컬등기타수출",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLcExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도로컬등기타수출|당해년도로컬등기타수출",		Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLcExpAmt",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도로컬등기타수출증가율|전년도로컬등기타수출증가율",	Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLcExpAmtRate",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도로컬등기타수출증가율|당해년도로컬등기타수출증가율",Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLcExpAmtRate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"로컬등기타수출증가율|로컬등기타수출증가율",			Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"lcExpAmtRate",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전전년도수출실적합계|전전년도수출실적합계",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoExpAmtSum",           CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도수출실적합계|전년도수출실적합계",				Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastExpAmtSum",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도수출실적합계|당해년도수출실적합계",			Type:"Float",     Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currExpAmtSum",          CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"전년도수출실적합계증가율|전년도수출실적합계증가율",		Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoExpAmtSumRate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"당해년도수출실적합계증가율|당해년도수출실적합계증가율",	Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastExpAmtSumRate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });
        ibHeader.addHeader({Header:"수출실적합계증가율|수출실적합계증가율",				Type:"Text",      Hidden:0,	Width:100,  Align:"Right",   ColMerge:1,   SaveName:"expIncrsRate",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, BackColor: '#f6f6f6' });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
			DeferredVScroll: 1
			, Ellipsis: 1
			, SelectionRowsMode: 1
			, SearchMode: 2
			, NextPageCall : 90
			, NoFocusMode : 0
			, Alternate : 0
			, Page: 10
			, SizeMode: 4
			, MergeSheet: msHeaderOnly
			, UseHeaderSortCancel: 1
			, MaxSort: 1
		});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '469px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetEditable(1);
		listSheet.SetVisible(1);

		getList();
	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/asm/selectTradeDayApplicationCheckList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	function listSheet_OnSearchEnd(code, msg) {
   		listSheet.SetColFontBold('receiptNo', 1);
   		listSheet.SetColFontBold('coNmKr', 1);
   		listSheet.SetColFontBold('corpFileCnt', 1);
   		listSheet.SetColFontBold('scFileCnt', 1);
   		listSheet.SetColFontBold('seFileCnt', 1);
   		listSheet.SetColFontBold('swFileCnt', 1);
   		listSheet.SetColFontBold('spFileCnt', 1);
   		listSheet.SetSelectRow(listSheet.GetDataFirstRow());
    }

	function listSheet_OnRowSearchEnd(row) {
		if(listSheet.GetCellValue(row, 'worknewYn') == 'Y') {
			listSheet.SetCellEditable(row, 'pastWorkerCnt', 1);
			listSheet.SetCellEditable(row, 'currWorkerCnt', 1);
			listSheet.SetCellBackColor(row, 'pastWorkerCnt', '#FFFFFF');
			listSheet.SetCellBackColor(row, 'currWorkerCnt', '#FFFFFF');
		}
	}

	// 포상 검색(팝업)
	function openLayerDlgSearchAwardPop() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'
			, callbackFunction : function(resultObj) {
				$('#searchSvrId').val(resultObj.svrId);
				$('#searchBsnNm').val(resultObj.bsnNm);
				$('#bsnAplDt').val(resultObj.bsnAplDt);
				getList();
			}
		});
	}

	// 포상 검색(팝업)
	function openLayerDlgSearchCorpPop() {
		var svrId = $('#searchSvrId').val();
		var jsonParams = {
			svrId:svrId
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchCorpPopup.do"/>',
			params : jsonParams
			, callbackFunction : function(resultObj) {
				$('#memberId').val(resultObj.memberId);
				$('#priType').val(resultObj.priType);
				$('#priTypeNm').val(resultObj.priTypeNm);

				openLayerTradeDayApplicationPop();
			}
		});
	}

	function openLayerTradeDayApplicationPop() {
		$('#svrId').val($("#searchSvrId").val());
		$('#statusChk').val('I');

		return false;//todo : 팝업 완성시 아래 구현

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplication.do"/>',
			params : $('#searchForm').serializeObject()

			, callbackFunction : function(resultObj) {

			}
		});
	}

	// 상세 페이지 & 팝업
	function listSheet_OnDblClick(Row, Col, Value) {
		if(Row > 1) {
			if (listSheet.ColSaveName(Col) == 'receiptNo') {
				var receiptNo = listSheet.GetCellValue(Row, "receiptNo");

				if (receiptNo) {
					doReport(listSheet.GetCellValue(Row, "svrId"), listSheet.GetCellValue(Row, "applySeq"), listSheet.GetCellValue(Row, "memberId"), listSheet.GetCellValue(Row, "priType"));
				}
			} else if (listSheet.ColSaveName(Col) == 'coNmKr') {
				var rowData = listSheet.GetRowData(Row);
				goApplication(Row);
			} else if (listSheet.ColSaveName(Col) == 'corpFileCnt') {
				commonViewFileSheet(listSheet, Row, 'attFileId', 'N');
			} else if (listSheet.ColSaveName(Col) == 'scFileCnt') {
				commonViewFileSheet(listSheet, Row, 'scFileId', 'N');
			} else if (listSheet.ColSaveName(Col) == 'seFileCnt') {
				commonViewFileSheet(listSheet, Row, 'seFileId', 'N');
			} else if (listSheet.ColSaveName(Col) == 'swFileCnt') {
				commonViewFileSheet(listSheet, Row, 'swFileId', 'N');
			} else if (listSheet.ColSaveName(Col) == 'spFileCnt') {
				commonViewFileSheet(listSheet, Row, 'spFileId', 'N');
			}
		}
	}

	function listSheet_OnClick(Row, Col, Value) {

		if(listSheet.ColSaveName(Col) == 'worknewYn' && Row > 1) {
			if(Value == 'N') {
				listSheet.SetCellEditable(Row, 'pastWorkerCnt', 0);
				listSheet.SetCellEditable(Row, 'currWorkerCnt', 0);
				listSheet.SetCellBackColor(Row, 'pastWorkerCnt', '#f6f6f6');
				listSheet.SetCellBackColor(Row, 'currWorkerCnt', '#f6f6f6');
			}else {
				listSheet.SetCellEditable(Row, 'pastWorkerCnt', 1);
				listSheet.SetCellEditable(Row, 'currWorkerCnt', 1);
				listSheet.SetCellBackColor(Row, 'pastWorkerCnt', '#ffffff');
				listSheet.SetCellBackColor(Row, 'currWorkerCnt', '#ffffff');
			}
		}
	}

	function goApplication(Row) {

		$('#svrId').val(listSheet.GetCellValue(Row, 'svrId'));
		$('#memberId').val(listSheet.GetCellValue(Row, 'memberId'));
		$('#applySeq').val(listSheet.GetCellValue(Row, 'applySeq'));
		$('#priType').val(listSheet.GetCellValue(Row, 'priType'));
		$("#statusChk").val('U');

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayApplicationPopup.do"/>'
			, params : $('#searchForm').serializeObject()
			, callbackFunction : function(resultObj) {
				var event = resultObj.event;

				// 업체수정 처리
				if (event == 'tradeDayApplicationTempUpdate') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 삭제 처리
				} else if (event == 'tradeDayApplicationDelete') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();
				// 신청구분 변경
				} else if (event == 'tradeDayApplicationChangePriType') {
					// 레이어 닫기
					closeLayerPopup();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 저장
				} else if (event == 'tradeDayApplicationSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				// 신청서 임시저장
				} else if (event == 'tradeDayApplicationTempSave') {
					// 레이어 닫기
					closeLayerPopup();

					// 상세목록 다시 호출
					getList();

					// 레이어 다시 오픈
					goApplication(Row);
				}
			}
		});
	}

	function doExcel() {
        downloadIbSheetExcel(listSheet, '신청서검토_리스트', '');
	}


	function doSave() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson();
		var sRow = listSheet.FindStatusRow('U');
		var arrow = sRow.split(';');

		jsonParam.tradeDayApplicationCheckList = saveJson.data;

		if(jsonParam.tradeDayApplicationCheckList == '') {
			alert('수정 된 항목이 없습니다.');
			return false;
		}

		var chk = true;
		$(jsonParam.tradeDayApplicationCheckList).each(function(i) {
			if(this.status == 'U' && this.worknewYn == 'Y') {

				var pastCnt = this.pastWorkerCnt;
				var currCnt = this.currWorkerCnt;

				if(pastCnt == 0 || currCnt == 0){
					alert('무역일자리 창출 업체일 경우\n직원 수를 입력해주세요.\n' + (arrow[i]-1) + '번 행');

					if(pastCnt == 0) {
						listSheet.SelectCell(arrow[i], 'pastWorkerCnt');
					}else if(currCnt == 0) {
						listSheet.SelectCell(arrow[i], 'currWorkerCnt');
					}

					chk = false;
					return false;
				}

				if(parseInt(pastCnt) >= parseInt(currCnt)){
					alert('무역일자리 창출 업체일 경우\n전년도 직원 수가 당해년도 직원 수보다\n작거나 같을 수 없습니다.\n' + (arrow[i]-1) + '번 행');
					listSheet.SelectCell(arrow[i], 'pastWorkerCnt');
					chk = false;
					return false;
				}

			}

		});

		if(!chk) return false;

		if(confirm('저장하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '/tdms/asm/saveTradeDayApplicationCheck.do'
				, data : JSON.stringify(jsonParam)
				, contentType : 'application/json'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					getList();
				}
				, error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	function doSend() {
		var memberId = listSheet.GetCellValue(listSheet.GetSelectRow(), "memberId");
		var coNm = listSheet.GetCellValue(listSheet.GetSelectRow(), "coNmKr");
		var membNm = listSheet.GetCellValue(listSheet.GetSelectRow(), "userNm");
		var membHp = listSheet.GetCellValue(listSheet.GetSelectRow(), "userHp");
		var membEmail = listSheet.GetCellValue(listSheet.GetSelectRow(), "userEmail");
		var svrId = listSheet.GetCellValue(listSheet.GetSelectRow(), "svrId");
		var applyId = listSheet.GetCellValue(listSheet.GetSelectRow(), "applySeq");
		var applyIdPw = '';
		var st = listSheet.GetCellValue(listSheet.GetSelectRow(), "st");

		var deptGb = 'AWARD';

		if(listSheet.GetSelectRow() < 0 ){
			alert('항목을 선택해주세요.');
			listSheet.SetSelectRow(listSheet.GetDataFirstRow());
			return false;
		}

		var jsonParams = {
			deptGb:deptGb,
			memberId:memberId,
			coNm:coNm,
			membNm:membNm,
			membHp:membHp,
			membEmail:membEmail,
			svrId:svrId,
			applyId:applyId,
			applyIdPw:applyIdPw,
			st:"01",
			fundGb:"A"
		}

		global.openLayerPopup({
			popupUrl : '<c:url value="/sycs/send/sendMsgPopup.do"/>',
			params : jsonParams

			, callbackFunction : function(resultObj) {

				if(resultObj == null) {
					return false;
				}

			}
		});
	}

	function doReport(svrId, applySeq, memberId, priType) {
		var reportGb = '';

		if (priType == 'A') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'T') {
			reportGb += '&reportGB3=Y';		// 이력서
			reportGb += '&reportGB4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			reportGb += '&reportGB1=Y';		// 수출업체종사자 포상신청서(A)
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'S') {
			reportGb += '&reportGB2=Y';		// 공적조서
			reportGb += '&reportGB3=Y';		// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		var url = '';
		<c:choose>
			<c:when test="${profile eq 'prod'}">
				url = 'https://membership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:when>
			<c:otherwise>
				url = 'https://devmembership.kita.net/fai/award/popup/tradeDayInquiryPrint.do';
			</c:otherwise>
		</c:choose>
		url += '?svr_id=' + svrId + '&apply_seq=' + applySeq + reportGb;

		var popFocus = window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');
		popFocus.focus();

		return;

		/*
		var param = '';
		var url = '<c:url value="/tdas/report/tradeDayInquiryPrint.do" />?svrId=' + svrId + '&applySeq=' + applySeq + '&memberId=' + memberId;

		if (priType == 'A') {
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'T') {
			param += '&reportGb3=Y';		// 이력서
			param += '&reportGb4=Y';		// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			param += '&reportGb1=Y';		// 수출업체종사자 포상신청서(A)
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'S') {
			param += '&reportGb2=Y';		// 공 적 조 서
			param += '&reportGb3=Y';		// 이력서
		} else if (priType == 'G') {
			alert('출력 없음');

			return false;
		}

		url += param;

		var result = null;

		window.open(url, 'search', 'width=770px,height=690px,scrollbars=yes');

		if (result == null) {
			return;
		}
		*/
	}
</script>