<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<input type="hidden" id="event" name="event" value="" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doImageDown();" class="btn_sm btn_primary">이력서 사진</button>
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
						<span class="form_search w100p">
							<input type="text" id="searchBsnNm" name="searchBsnNm" value="<c:out value="${searchBsnNm}"/>" class="form_text" style="font-size: 14px;" readonly="readonly" />
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<button type="button" onclick="openLayerDlgSearchAwardPop();" class="btn_icon btn_search" title="포상검색"></button>
						</span>
					</td>
					<th>포상구분</th>
					<td>
						<select class="form_select" id="searchPriType" name="searchPriType">
							<option value="">전체</option>
							<c:forEach items="${awd001Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>업체구분</th>
					<td>
						<select class="form_select" id="searchScale" name="searchScale">
							<option value="">전체</option>
							<c:forEach items="${awd007Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>훈격</th>
					<td colspan="3">
						<select class="form_select w40p" id="searchStartFAwardCd" name="searchStartFAwardCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092tUserSelect}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
							</c:forEach>
						</select>
						<span style="vertical-align:middle;">~</span>
						<select class="form_select w40p" id="searchEndFAwardCd" name="searchEndFAwardCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092tUserSelect}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
							</c:forEach>
						</select>
					</td>
					<th>본사소재지</th>
					<td>
						<select class="form_select" id="searchBonsaYn" name="searchBonsaYn">
							<option value="">전체</option>
							<option value="N">수도권</option>
							<option value="Y">지방</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>포상종류</th>
					<td>
						<select class="form_select" id="searchPrvPriType" name="searchPrvPriType">
							<option value="">전체</option>
							<c:forEach items="${awd024Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>신청상태</th>
					<td>
						<select class="form_select" id="searchState" name="searchState">
							<option value="">전체</option>
							<option value="01">신청</option>
							<option value="02">조정</option>
							<option value="03">탈락</option>
						</select>
					</td>
					<th>성별</th>
					<td>
						<select class="form_select" id="searchSex" name="searchSex">
							<option value="">전체</option>
							<option value="M">남자</option>
							<option value="F">여자</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>외국인여부</th>
					<td>
						<select class="form_select" id="searchFromYn" name="searchFromYn">
							<option value="">전체</option>
							<option value="Y">내국인</option>
							<option value="N">외국인</option>
						</select>
					</td>
					<th>공무원여부</th>
					<td>
						<select class="form_select" id="searchGEmpCd" name="searchGEmpCd">
							<option value="">전체</option>
							<c:forEach items="${awd016Select}" var="list" varStatus="status">
								<option value="${list.detailcd}">${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>학력</th>
					<td>
						<input type="text" class="form_text" id="searchHistory" name="searchHistory" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<th>순위</th>
					<td>
						<input type="text" class="form_text w40p" id="searchStartRank" name="searchStartRank" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="4"/>
						<span style="vertical-align:middle;">~</span>
						<input type="text" class="form_text w40p" id="searchEndRank" name="searchEndRank" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="4"/>
					</td>
					<th>나이</th>
					<td>
						<input type="text" class="form_text w40p" id="searchStartAge" name="searchStartAge" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="3"/>
						<span style="vertical-align:middle;">~</span>
						<input type="text" class="form_text w40p" id="searchEndAge" name="searchEndAge" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="3"/>
					</td>
					<th>수출신장율</th>
					<td>
						<input type="text" class="form_text w40p" id="searchStartExpIncrsRate" name="searchStartExpIncrsRate" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="12"/>
						<span style="vertical-align:middle;">~</span>
						<input type="text" class="form_text w40p" id="searchEndExpIncrsRate" name="searchEndExpIncrsRate" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="12"/>
					</td>
				</tr>
				<tr>
					<th>품목코드</th>
					<td>
						<input type="text" class="form_text w40p" id="searchStartMtiCode" name="searchStartMtiCode" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="6"/>
						<span style="vertical-align:middle;">~</span>
						<input type="text" class="form_text w40p" id="searchEndMtiCode" name="searchEndMtiCode" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="6"/>
					</td>
					<th>품목명</th>
					<td>
						<input type="text" class="form_text" id="searchMtiName" name="searchMtiName" value="" onkeydown="onEnter(getList);" maxlength="60"/>
					</td>
					<th>공적사항조회</th>
					<td>
						<input type="text" class="form_text" id="searchKongjuk" name="searchKongjuk" value="" onkeydown="onEnter(getList);" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<th>업종분류</th>
					<td colspan="2">
						<select class="form_select" id="searchChgCode01" name="searchChgCode01">
							<option value="">선택</option>
							<c:forEach items="${upCodeDepSelect}" var="list" varStatus="status">
								<option value="${list.chgCode01}">${list.chgCode01}</option>
							</c:forEach>
						</select>
						<select class="form_select w40p" id="searchChgCode02" name="searchChgCode02">
							<option value="">선택</option>
						</select>
					</td>
					<th>업종코드</th>
					<td colspan="2">
						<input type="text" class="form_text w20p" id="searchUpCode" name="searchUpCode" value="" onkeydown="onEnter(getList); return onlyNumber(event);" onkeyup="removeChar(event);" maxlength="6"/>
						<input type="text" class="form_text w60p" id="searchUpCodeNm" name="searchUpCodeNm" value="" onkeydown="onEnter(getList);" maxlength="30" placeholder="업종코드명"/>
					</td>
				</tr>
				<tr>
					<th>수출탑</th>
					<td colspan="5">
						<select class="form_select" id="searchStartExpTapPrizeCd" name="searchStartExpTapPrizeCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092tTapSelect}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
							</c:forEach>
						</select>
						<select class="form_select" id="searchEndExpTapPrizeCd" name="searchEndExpTapPrizeCd">
							<option value="">전체</option>
							<c:forEach items="${awd0092tTapSelect}" var="list" varStatus="status">
								<option value="${list.prizeCd}">${list.prizeName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">특이사항</th>
					<td colspan="5">
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="consumYn" id="consumYn" value="Y">
							<span class="label">소비재 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="electronicYn" id="electronicYn" value="Y">
							<span class="label">전자상거래 활용 업체</span>
						</label>

						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="exportYn" id="exportYn" value="Y">
							<span class="label">수출국 다변화 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="worknewYn" id="worknewYn" value="Y">
							<span class="label">무역일자리 창출 업체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_checkbox" name="tempYn" id="tempYn" value="Y">
							<span class="label">임시조회</span>
						</label>
					</td>
				</tr>
			</table>
		</div>
		<button type="button" class="btn_folding" title="테이블접기"></button>
	</div>
</div>
<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="listSheet" class="sheet"></div>
	</div>
</div>
</form>
<form id="wordForm" name="wordForm" method="post">
<input type="hidden" name="svrId" />
<input type="hidden" name="applySeq" />
<input type="hidden" name="memberId" />
<input type="hidden" name="prvPriType" />
<input type="hidden" name="priType" />
<input type="hidden" name="coNmKr" />
<input type="hidden" name="userNmKor" />
<input type="hidden" name="scale" />
<input type="hidden" name="prvPriTypeNm" />
<input type="hidden" name="event" />
<input type="hidden" name="reportGb1" />
<input type="hidden" name="reportGb2" />
<input type="hidden" name="reportGb3" />
<input type="hidden" name="reportGb4" />
</form>
<form id="downloadForm" name="downloadForm" method="post">
<input type="hidden" name="fileIdList" value="" />
<input type="hidden" name="fileNoList" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		setSheetHeader_tradeDayUnusualSearchSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function setSheetHeader_tradeDayUnusualSearchSheet() {

		var	ibHeader = new IBHeader();
		var initSheet = {};

        ibHeader.addHeader({Header:"No",				Type:"Text",      Hidden:1,  Width:60,   Align:"Center",                SaveName:"no" });
        ibHeader.addHeader({Header:"",					Type:"CheckBox",  Hidden:0,  Width:60,   Align:"Center",                SaveName:"chk" });
        ibHeader.addHeader({Header:"포상ID",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",                SaveName:"svrId",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상신청ID",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",                SaveName:"applySeq",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"접수번호",				Type:"Text",      Hidden:0,  Width:80,   Align:"Center",                SaveName:"receiptNo",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"본부코드",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",                SaveName:"tradeDept",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상년도",				Type:"Text",      Hidden:1,  Width:80,   Align:"Center",                SaveName:"regYear",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신청일자",				Type:"Text",      Hidden:1,  Width:80,   Align:"Center",                SaveName:"reqDate",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역업번호",			Type:"Text",      Hidden:0,  Width:80,   Align:"Center",                SaveName:"memberId",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상구분",				Type:"Combo",     Hidden:0,  Width:120,  Align:"Left",                  SaveName:"priType",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd001Sheet.detailcd}' , ComboText: '${awd001Sheet.detailnm}' });
        ibHeader.addHeader({Header:"포상종류",				Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",                SaveName:"prvPriType",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd002Sheet.detailcd}' , ComboText: '${awd002Sheet.detailnm}' });
        ibHeader.addHeader({Header:"수출의탑",				Type:"Text",      Hidden:0,  Width:120,  Align:"Left",                  SaveName:"expTapPrizeNm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체명",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",                  SaveName:"coNmKr",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"업체명_영문",			Type:"Text",      Hidden:1,  Width:100,  Align:"Left",                SaveName:"coNmEn",                   CalcLogic:"",   Format:"",              PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대상자",				Type:"Text",      Hidden:0,  Width:80,   Align:"Center",                SaveName:"userNmKor",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, Cursor:"Pointer" });
        ibHeader.addHeader({Header:"업체구분",				Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",                SaveName:"scale",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${awd007Sheet.detailcd}' , ComboText: '${awd007Sheet.detailnm}' });
        ibHeader.addHeader({Header:"법인번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"corpoNo",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"사업자등록번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"bsNo",                     CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"우편번호",				Type:"Text",      Hidden:0,  Width:80,   Align:"Center",                SaveName:"coZipCd",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",                  SaveName:"coAddr",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체전화번호",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"coPhone",                  CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체FAX",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"coFax",                    CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체Email",			Type:"Text",      Hidden:0,  Width:120,  Align:"Left",                  SaveName:"coEmail",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체HP",				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"coHp",                     CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체홈페이지",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"coHomepage",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_성명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userNm",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_전화번호",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userPhone",                CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_핸드폰",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userHp",                   CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_이메일",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userEmail",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자_이메일2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userEmail2",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자FAX",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userFax",                  CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자부서명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userDeptNm",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"담당자직위명",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"userPosition",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑_업체명",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"tapCoNmKr",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출의탑_대표자명",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"tapCeoNmKr",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"본사소재지",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"bonsaYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"제조업여부",			Type:"Text",      Hidden:0,  Width:80,   Align:"Left",                  SaveName:"jejoupYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"서비스업여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"serviceYn",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"상장여부",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"stockYnNm",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"농림수산업_수출업영위업체",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"agrifoodYnNm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"서류도착여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"arrivalDocYnNm",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"소비재업체",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"consumYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전자상거래활용",			Type:"Text",      Hidden:0,  Width:130,  Align:"Center",  ColMerge:1,   SaveName:"electronicYn",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출국다변화",			Type:"Text",      Hidden:0,  Width:130,  Align:"Center",  ColMerge:1,   SaveName:"exportYn",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역일자리창출",			Type:"Text",      Hidden:0,  Width:130,  Align:"Center",  ColMerge:1,   SaveName:"worknewYn",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특이업체여부",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"specialYn",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업체특성내용",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"specialContent",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도매출액",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"salAmount",                CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자본금",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"capital",                  CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"종원수",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"workerCnt",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"설립년도",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"coCretYear",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"각자대표",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"eachCeoKr",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공동대표",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"jointCeoKr",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공동대표수상이력",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"jointCeoHistory",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업종코드",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"upCode",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"대분류",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"upDep1",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"중분류",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"upDep2",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"업종명",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"upCodeNm",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_HSCODE1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"expItemHscode1",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명1",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"expItemNm1",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_HSCODE2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"expItemHscode2",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목명2",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"expItemNm2",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_MTICODE1",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"expItemMticode1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_MTICODE명1",	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"expItemMtiname1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출단가상승률1",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"priceInflation1",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_MTICODE2",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"expItemMticode2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출품목_MTICODE명2",	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"expItemMtiname2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출단가상승률2",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"priceInflation2",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도직수출",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoDrExpAmt",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도로컬수출",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoLcExpAmt",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전전년도직수출누락분",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"twoDrOmsExpAmt",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도직수출",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastDrExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도로컬수출",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastLcExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"전년도직수출누락분",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"pastDrOmsExpAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도직수출",			Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currDrExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도로컬수출",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currLcExpAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"당해년도직수출누락분",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"currDrOmsExpAmt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수출증가율",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"expIncrsRate",             CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입실적",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"impSiljuk",                CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입실적_누락분",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"exImpSiljuk",              CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지",				Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"tradeIndex",               CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"무역수지개선율",			Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"tradeIndexImprvRate",      CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"dvlpExploAmt",             CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액_비중",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"dvlpExploAmtPor",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액",		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"newMktExploAmt",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액_비중",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"newMktExploAmtPor",        CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척금액_누락분",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"exDvlpExploAmt",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장개척비중_누락분",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"exDvlpExploAmtPor",        CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척금액_누락분",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"exNewMktExploAmt",         CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"5대시장외개척비중_누락분",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"exNewMktExploAmtPor",      CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발품목명",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"newTechItemNm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"신기술개발인정기관",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"newTechTerm",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여_사업명",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"govTechNm",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"정부기술개발참여_시행기간",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"govTechInst",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산_품목명",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"impReplItemNm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"수입대체상품생산_품목수",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"impReplItemCnt",           CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출_상표수",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"selfBrandExpCnt",          CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출_품목수",	Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"selfBrandExpItemCnt",      CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"자기상표제품수출_상표명",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"selfBrandExpItemNm",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"내외국인구분",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"fromYn",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주민번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"juminNo",                  CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"나이",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"age",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"성별",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",                SaveName:"sex",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"국적",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"bonjuk",                   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"우편번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"zipCd",                    CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"주소",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"addr",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직업",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"job",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"소속",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"deptPos",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"직위",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"pos",                      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"등급(직급/계급)",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"rank",                     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간_년",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"curwrkTermYy",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간_월",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"curwrkTermMm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"근무기간_일",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"curwrkTermDd",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공적요지",				Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    ColMerge:1,   SaveName:"kongjukSum",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"최종학력일자",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"historyDt",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"공적조서_최종학력",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:1,   SaveName:"history",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"최종학력",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:1,   SaveName:"lastHak",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"해외근무경력_유무",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"fognWorkYn",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"생년월일",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"birthday",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"여권번호",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"passportNo",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"핸드폰",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"mobile",                   CalcLogic:"",   Format:"PhoneNo",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"이메일",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"email",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"임원여부",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"imwonYn",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_추천기관",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",                  SaveName:"spRecOrg",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_추천부문",		Type:"Combo",     Hidden:0,  Width:130,  Align:"Left",                  SaveName:"spRecKind",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30, ComboCode: '${spe000Sheet.detailcd}' , ComboText: '${spe000Sheet.detailnm}' });
        ibHeader.addHeader({Header:"특수유공_추천자",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"spRecName",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_직위",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"spRecPos",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_추천자전화번호",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"spRecTel",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_추천자HP",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"spRecHp",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"특수유공_추천자Email",	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"spRecEmail",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"선정여부",				Type:"Text",      Hidden:0,  Width:70,   Align:"Center",                SaveName:"state",                    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상코드",				Type:"Text",      Hidden:1,  Width:100,  Align:"Center",                SaveName:"fAwardCd",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"포상명",				Type:"Text",      Hidden:1,  Width:200,  Align:"Left",                  SaveName:"fAwardNm",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"이력서사진",			Type:"Text",      Hidden:1,  Width:200,  Align:"Left",                  SaveName:"attPictId",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"이력서사진암호",			Type:"Text",      Hidden:1,  Width:200,  Align:"Left",                  SaveName:"attPictIdA",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });
        ibHeader.addHeader({Header:"이력서사진파일이름",		Type:"Text",      Hidden:1,  Width:200,  Align:"Left",                  SaveName:"attPictIdFileNo",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: "colhidden|rowtransaction",
			DeferredVScroll: 1,
			Ellipsis: 1,
			SelectionRowsMode: 1,
			SearchMode: 2,
			NoFocusMode : 0,
			Alternate : 0,
			Page: 10,
			SizeMode: 4,
			MergeSheet: msHeaderOnly,
			UseHeaderSortCancel: 1,
			MaxSort: 1
		});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true, HeaderCheck: 0});

		var container = $('#listSheet')[0];
		createIBSheet2(container, 'listSheet', '100%', '425px');
		ibHeader.initSheet('listSheet');

		listSheet.SetEllipsis(1); 				// 말줄임 표시여부
		listSheet.SetSelectionMode(4);			// 셀 선택 모드 설정
		//listSheet.SetEditable(1);
		listSheet.SetVisible(1);

	}

	function listSheet_OnSort(col, order) {
		listSheet.SetScrollTop(0);
	}

	function listSheet_OnSearchEnd() {
		listSheet.SetColFontBold('coNmKr', 1);
		listSheet.SetColFontBold('userNmKor', 1);
		listSheet.SetColFontBold('receiptNo', 1);
	}

	// 목록 가져오기
	function getList() {
		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/agg/selectTradeDayUnusualSearchList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				listSheet.LoadSearchData({Data: (data.resultList || []) });
			}
		});
	}

	/**
	 * 포상 검색(팝업)
	 */
	function openLayerDlgSearchAwardPop(){
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

	// 상세 페이지 & 팝업
	function listSheet_OnClick(Row, Col, Value) {

		if(Row > 0) {
			if(listSheet.ColSaveName(Col) == 'coNmKr') {
				doTradeDayView(Row);

			}else if(listSheet.ColSaveName(Col) == 'userNmKor') {
				var prvPriType = listSheet.GetCellValue(Row, "prvPriType")
				kongJukPopup(Row, prvPriType);

			}else if(listSheet.ColSaveName(Col) == 'receiptNo') {
				doWord(listSheet.GetCellValue(Row, "svrId"), listSheet.GetCellValue(Row, "applySeq"), listSheet.GetCellValue(Row, "memberId"), listSheet.GetCellValue(Row, "prvPriType"), listSheet.GetCellValue(Row, "priType"), listSheet.GetCellValue(Row, "coNmKr"), listSheet.GetCellValue(Row, "userNmKor"), listSheet.GetCellText(Row, "scale"), listSheet.GetCellText(Row, "prvPriType"));
			}
		}

	}

	function doTradeDayView(Row) {

		var searchSvrId = $('#searchSvrId').val();
		var applySeq = listSheet.GetCellValue(Row, "applySeq")

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayViewPopup.do" />'
			, params : {
				svrId : searchSvrId
				, applySeq : applySeq
			}
			, callbackFunction : function(resultObj){
			}
		});
	}

	function kongJukPopup(Row, prvPriType) {

		var searchSvrId = $('#searchSvrId').val();
		var applySeq = listSheet.GetCellValue(Row, "applySeq")

		// 로딩이미지 시작
		$('#loading_image').show();

		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/tradeDayInquiryPopup.do" />'
			, params : {
				event : 'TradeDayInquiryPopupSearch'
				, svrId : searchSvrId
			    , applySeq : applySeq
			    , prvPriType : prvPriType
			}
			, callbackFunction : function(resultObj){
			}
		});

	}

	function doWord(svrId, applySeq, memberId, prvPriType, priType, coNmKr, userNmKor, scale, prvPriTypeNm) {

		$('#wordForm').each(function() {
			this.reset();
		});

		$('#wordForm input[name="svrId"]').val(svrId);
		$('#wordForm input[name="applySeq"]').val(applySeq);
		$('#wordForm input[name="memberId"]').val(memberId);
		$('#wordForm input[name="prvPriType"]').val(prvPriType);
		$('#wordForm input[name="priType"]').val(priType);
		$('#wordForm input[name="coNmKr"]').val(coNmKr);
		$('#wordForm input[name="userNmKor"]').val(userNmKor);
		$('#wordForm input[name="scale"]').val(scale);
		$('#wordForm input[name="prvPriTypeNm"]').val(prvPriTypeNm);
		$('#wordForm input[name="event"]').val('WORD');

		if (priType == 'A') {
			$('#wordForm input[name="reportGb1"]').val('Y');	// 수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');		// 수출의 탑 신청서(B)
		} else if (priType == 'T') {
			$('#wordForm input[name="reportGb1"]').val('');		//수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('');		//공적조서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('Y');	// 수출의 탑」 신청서(B)
		} else if (priType == 'P') {
			$('#wordForm input[name="reportGb1"]').val('Y');	// 수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');
		} else if (priType == 'S') {
			$('#wordForm input[name="reportGb1"]').val('');		//수출업체종사자 포상신청서(A)
			$('#wordForm input[name="reportGb2"]').val('Y');	// 공 적 조 서
			$('#wordForm input[name="reportGb3"]').val('Y');	// 이력서
			$('#wordForm input[name="reportGb4"]').val('');		//수출의탑 신청서(B)
		} else if (priType == 'G') {
			alert('출력 없음');
			return false;
		}

		$('#wordForm').attr('action','/tdas/report/tradeDayInquiryPrintWord.do');
		$('#wordForm').submit();

	}

	function doExcel() {
		downloadIbSheetExcel(listSheet, '특이업체조회_리스트', '');
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

	$('#searchChgCode01').on('change', function() {
		var searchChgCode01 = this.value;
		var jsonParam = {
				searchChgCode01:searchChgCode01
		}
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradefund/cmn/popup/upCodeChgCodeList.do" />'
			, data : jsonParam
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#searchChgCode02').html('');

				var codeList = '';
				codeList += '<option value="">선택</option>';
				$.each(data.upCodeDep2, function(index, value){
					codeList += '<option value="' + value.chgCode02 + '">' + value.chgCode02 + '</option>';
				});

				$('#searchChgCode02').html(codeList);
			}
		});
	});

	function doImageDown() {
		var jsonParam = $('#searchForm').serializeObject();
		var saveJson = listSheet.GetSaveJson({StdCol : 1});

		if (listSheet.CheckedRows(1) <= 0) {
			alert('선택된 것이 없습니다. 확인 후 진행 바랍니다.');

			return false;
		}

		var fileIdList = '';
		var fileNoList = '';
		$(saveJson.data).each(function(i){
			fileIdList += this.attPictIdA + '||';
			fileNoList += this.attPictIdFileNo + '||';
		});

		if (confirm('이미지를 다운로드하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundZipFileExit.do" />'
				, data : {
					fileIdList : fileIdList
					, fileNoList : fileNoList
				}
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					if (data.resultBoolean == true) {
						var f = document.downloadForm;
						f.action = '<c:url value="/common/util/tradefundZipImageDownload.do" />';
						f.fileIdList.value = fileIdList;
						f.fileNoList.value = fileNoList;
						f.target = '_self';
						f.submit();
					} else {
						alert('다운로드 받을 수 있는 이력서 사진이 없습니다.');

						return;
					}
				}
			});
		}
	}
</script>