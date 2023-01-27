<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" id="svrId"     name="svrId"	value="" />
<input type="hidden" id="applyId"   name="applyId"	value="" />
<input type="hidden" id="bsNo"     	name="bsNo"    	value="" />
<input type="hidden" id="chkYm"  	name="chkYm"    value="<c:out value="${FND0000T.bsnStartDt}"/>" />
<input type="hidden" id="resultCnt"			name="resultCnt"        value="0" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운</a>
	</div>
	<div class="ml-15">
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">

<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기금융자 명</th>
				<td>
					<div class="field_set flex align_center">
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td>
					<fieldset class="widget">
						<select id="searchTradeDept" name="searchTradeDept" class="form_select"  >
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="" >::: 전체 :::</option>
							</c:if>

							<c:forEach var="item" items="${COM001}" varStatus="status">
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="<c:out value="${item.chgCode01}"/>" ><c:out value="${item.detailnm}"/></option>
							</c:if>

							<c:if test='${user.fundAuthType ne "ADMIN"}'>
								<c:if test="${item.chgCode01 eq searchTradeDept}"> >
									<option value="<c:out value="${item.chgCode01}"/>" <c:if test="${item.chgCode01 eq searchTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
								</c:if>
							</c:if>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">처리결과</th>
				<td>
					<fieldset class="widget">
						<select id="searchSt" name="searchSt" class="form_select" style="width: 100px;">
							<option value="" >::: 전체 :::</option>
							<c:forEach var="item" items="${LMS003}" varStatus="status">
								<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchSt}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
		<div id="sheet2" class="sheet" style="display:none"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		initOldIBSheet();
		doSearch();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No|No",                                	Type:"Int",       Hidden:false,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"rn",                 Wrap:true });
		ibHeader.addHeader({Header:"No|No",                                	Type:"Seq",       Hidden:true,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no",                 Wrap:true });
		ibHeader.addHeader({Header:"기금융자코드|기금융자코드",                    	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:true,   SaveName:"svrId",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"접수번호|접수번호",                         	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:true,   SaveName:"applyId",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"지역본부|지역본부",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"tradeDeptNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"회사명|회사명",                            	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:true,   SaveName:"coNmKor",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"대표자|대표자",                            	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"ceoNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"무역업고유번호|무역업고유번호",                 	Type:"Text",      Hidden:false,  Width:90,   Align:"Center",  ColMerge:true,   SaveName:"bsNo",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"사업자등록번호|사업자등록번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  ColMerge:true,   SaveName:"industryNo",         CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"우편번호|우편번호",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  ColMerge:true,   SaveName:"coZipCd",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"주소|주소",                               	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"coAddr",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"자본금|자본금",                            	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"capital",            CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"종업원수|종업원수",                         	Type:"Int",       Hidden:false,  Width:80,   Align:"Right",   ColMerge:true,   SaveName:"workerCnt",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"설립년도|설립년도",                         	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"coCretYear",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출품목|수출품목",                         	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:true,   SaveName:"productname",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"매출액|매출액",                            	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"salAmount",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"제조여부|제조여부",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"jejoupYn",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"전년도수출|전년도수출",                       	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"expAmount",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전직수출|2년전직수출",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmount2",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전직수출|1년전직수출",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmount1",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"직수출증가율|직수출증가율",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expRate",            CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전직수출누락분|2년전직수출누락분",             	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpAmount2",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전직수출누락분|1년전직수출누락분",             	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpAmount1",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"직수출누락분증가율|직수출누락분증가율",            	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpRate",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전기타수출|2년전기타수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpAmount2",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전기타수출|1년전기타수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpAmount1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타수출증가율|기타수출증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpRate",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전일본수출|2년전일본수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpAmount2",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전일본수출|1년전일본수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpAmount1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"일본수출증가율|일본수출증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpRate",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전수출합계|2년전수출합계",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmountSum2",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전수출합계|1년전수출합계",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmountSum1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출합계증가율|수출합계증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expSumRate",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"현재보유LC|현재보유LC",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"lcAmount",           CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출계약액|수출계약액",                       	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"extContrAmount",     CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수상경력|수상경력",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"prizNm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"포상내용|포상내용",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"backPrizeYn",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기술관련사항|기술관련사항",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"tecnlg",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"특허/인증여부|특허/인증여부",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"indsPropYn",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"특허/인증수|특허/인증수",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"indsPropCnt",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"자금용도|자금용도",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"moneyUse",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"은행|은행",                               	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"targetnationNm",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"은행지점|은행지점",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd11Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담보제공방식|담보제공방식",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd12Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자명|담당자명",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd1Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자전화번호|담당자전화번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd21Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자팩스번호|담당자팩스번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd22Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자이메일|담당자이메일",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd2Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"마케팅대상국가|마케팅대상국가",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd31Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_1년차금액|국내외전시참가_1년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd32Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_2년차금액|국내외전시참가_2년차금액",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd3Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_대상국가품목|국내외전시참가_대상국가품목",	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd41Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_1년차금액|수출상담회참가_1년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd42Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_2년차금액|수출상담회참가_2년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd4Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_대상국가품목|수출상담회참가_대상국가품목",	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd51Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_1년차금액|바이어초청_1년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd52Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_2년차금액|바이어초청_2년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd5Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_대상국가품목|바이어초청_대상국가품목",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd61Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_1년차금액|바이어방문_1년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd62Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_2년차금액|바이어방문_2년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd6Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_대상국가품목|바이어방문_대상국가품목",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd71Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_1년차금액|해외특허획득_1년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd72Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_2년차금액|해외특허획득_2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd7Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_대상국가품목|해외특허획득_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd81Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증_1년차금액|해외규격인증_1년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd82Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증-2년차금액|해외규격인증-2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd8Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증_대상국가품목|해외규격인증_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd91Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_1년차금액|해외홍보_1년차금액",           	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd92Amt",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_2년차금액|해외홍보_2년차금액",           	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd9Nationitem",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_대상국가품목|해외홍보_대상국가품목",       	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mainBankNm",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_1년차금액|해외시장조사_1년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mainBankBranchNm",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_2년차금액|해외시장조사_2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mortgage",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_대상국가품목|해외시장조사_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membNm",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_1년차금액|기타_1년차금액",                	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membTel",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_2년차금액|기타_2년차금액",                	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membFax",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_대상국가품목|기타_대상국가품목",              Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membEmail",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|수출실적",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita01",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|직수출비중",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita02",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|수출증가율",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita03",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|해상/항공운임",                 Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita04",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|해상/항공운임증가율",             Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita05",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
// 		ibHeader.addHeader({Header:"심사평가점수내역|자금용도",                     Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita06",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
// 		ibHeader.addHeader({Header:"심사평가점수내역|마케팅국가",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita07",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|사업참여",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita08",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|회비납부",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita09",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|융자횟수",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita10",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|종합평가",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita11",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|합계",                       	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKitaSum",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"등급|등급",                               	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:true,   SaveName:"levelGb",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"금리|금리",                               	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:true,   SaveName:"interestRate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"신청금액|신청금액",                         	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"necessAmount",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"추천금액|추천금액",                         	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"recdAmount",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"추천율(%)|추천율(%)",                      	Type:"Int",       Hidden:false,  Width:100,  Align:"Center",  ColMerge:true,   SaveName:"recdRate",           CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"선정여부|선정여부",                         	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"st",                 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"비고|비고",                               	Type:"Text",      Hidden:false,  Width:300,  Align:"Left",    ColMerge:true,   SaveName:"resnMemo",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });


		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction',  Page: 50,SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:5, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

// 		sheet1.SetColFontBold("loanSum", true);
// 		sheet1.SetColFontBold("coNmKor", true);

// 		sheet1.SetDataLinkMouse("loanSum", true);
// 		sheet1.SetDataLinkMouse("coNmKor", true);
	}

	function initOldIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No|No",                                	Type:"Int",       Hidden:false,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"rn",                  Wrap:true });
		ibHeader.addHeader({Header:"No|No",                                	Type:"Seq",       Hidden:true,  Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no",                  Wrap:true });
		ibHeader.addHeader({Header:"기금융자코드|기금융자코드",                    	Type:"Text",      Hidden:true,   Width:100,  Align:"Left",    ColMerge:true,   SaveName:"svrId",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"접수번호|접수번호",                         	Type:"Text",      Hidden:true,   Width:100,  Align:"Left",    ColMerge:true,   SaveName:"applyId",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"지역본부|지역본부",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"tradeDeptNm",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"회사명|회사명",                            	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:true,   SaveName:"coNmKor",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"대표자|대표자",                            	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"ceoNmKor",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"무역업고유번호|무역업고유번호",                 	Type:"Text",      Hidden:false,  Width:90,   Align:"Center",  ColMerge:true,   SaveName:"bsNo",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"사업자등록번호|사업자등록번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  ColMerge:true,   SaveName:"industryNo",          CalcLogic:"",   Format:"SaupNo",      PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"우편번호|우편번호",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Center",  ColMerge:true,   SaveName:"coZipCd",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"주소|주소",                               	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"coAddr",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"자본금|자본금",                            	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"capital",             CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"종업원수|종업원수",                         	Type:"Int",       Hidden:false,  Width:80,   Align:"Right",   ColMerge:true,   SaveName:"workerCnt",           CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"설립년도|설립년도",                         	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"coCretYear",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출품목|수출품목",                         	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:true,   SaveName:"productname",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"매출액|매출액",                            	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"salAmount",           CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"제조여부|제조여부",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"jejoupYn",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"전년도수출|전년도수출",                       	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"expAmount",           CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전직수출|2년전직수출",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmount2",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전직수출|1년전직수출",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmount1",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"직수출증가율|직수출증가율",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expRate",             CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전직수출누락분|2년전직수출누락분",             	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpAmount2",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전직수출누락분|1년전직수출누락분",             	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpAmount1",      CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"직수출누락분증가율|직수출누락분증가율",            	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"omisExpRate",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전기타수출|2년전기타수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpAmount2",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전기타수출|1년전기타수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpAmount1",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타수출증가율|기타수출증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"etcExpRate",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전일본수출|2년전일본수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpAmount2",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전일본수출|1년전일본수출",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpAmount1",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"일본수출증가율|일본수출증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"japExpRate",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"2년전수출합계|2년전수출합계",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmountSum2",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"1년전수출합계|1년전수출합계",                   Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expAmountSum1",       CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출합계증가율|수출합계증가율",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"expSumRate",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"현재보유LC|현재보유LC",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"lcAmount",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출계약액|수출계약액",                       	Type:"Text",      Hidden:true,   Width:150,  Align:"Right",   ColMerge:true,   SaveName:"extContrAmount",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수상경력|수상경력",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"prizNm",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"포상내용|포상내용",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"backPrizeYn",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기술관련사항|기술관련사항",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"tecnlg",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"특허/인증여부|특허/인증여부",                  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"indsPropYn",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"특허/인증수|특허/인증수",                     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"indsPropCnt",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"자금용도|자금용도",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"moneyUse",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"은행|은행",                               	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"targetnationNm",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"은행지점|은행지점",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd11Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담보제공방식|담보제공방식",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd12Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자명|담당자명",                         	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd1Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자전화번호|담당자전화번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd21Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자팩스번호|담당자팩스번호",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd22Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"담당자이메일|담당자이메일",                    	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd2Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"마케팅대상국가|마케팅대상국가",                 	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd31Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_1년차금액|국내외전시참가_1년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd32Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_2년차금액|국내외전시참가_2년차금액",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd3Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"국내외전시참가_대상국가품목|국내외전시참가_대상국가품목",	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd41Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_1년차금액|수출상담회참가_1년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd42Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_2년차금액|수출상담회참가_2년차금액",   	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd4Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"수출상담회참가_대상국가품목|수출상담회참가_대상국가품목",	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd51Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_1년차금액|바이어초청_1년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd52Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_2년차금액|바이어초청_2년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd5Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어초청_대상국가품목|바이어초청_대상국가품목",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd61Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_1년차금액|바이어방문_1년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd62Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_2년차금액|바이어방문_2년차금액",        	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd6Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"바이어방문_대상국가품목|바이어방문_대상국가품목",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd71Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_1년차금액|해외특허획득_1년차금액",      	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd72Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_2년차금액|해외특허획득_2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd7Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외특허획득_대상국가품목|해외특허획득_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd81Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증_1년차금액|해외규격인증_1년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd82Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증-2년차금액|해외규격인증-2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd8Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외규격인증_대상국가품목|해외규격인증_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd91Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_1년차금액|해외홍보_1년차금액",           	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd92Amt",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_2년차금액|해외홍보_2년차금액",           	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"plancd9Nationitem",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외홍보_대상국가품목|해외홍보_대상국가품목",       	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mainBankNm",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_1년차금액|해외시장조사_1년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mainBankBranchNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_2년차금액|해외시장조사_2년차금액",     	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"mortgage",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"해외시장조사_대상국가품목|해외시장조사_대상국가품목",  	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membNm",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_1년차금액|기타_1년차금액",                	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membTel",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_2년차금액|기타_2년차금액",                	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membFax",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"기타_대상국가품목|기타_대상국가품목",             	Type:"Text",      Hidden:true,   Width:150,  Align:"Left",    ColMerge:true,   SaveName:"membEmail",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|수출액",                     	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita01",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|직수출비율",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita02",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|일본직수출비중",                	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita03",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|수출증가율",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita04",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|업력",                       	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita05",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|매출액",                     	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita06",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|종업원수",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita07",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|제조업체",                     Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita08",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|기술력지정",                   	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita09",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|특허",                       	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita10",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|수상경력",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita11",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|협회사업참가",                 	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita12",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|회비납부기간",                 	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita13",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|융자횟수",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita14",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|과거융자여부",                 	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita15",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|종합평가",                    	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKita16",         CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"심사평가점수내역|합계",                       	Type:"Int",       Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"pointKitaSum",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"신청금액|신청금액",                         	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"necessAmount",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"추천금액|추천금액",                          	Type:"Int",       Hidden:false,  Width:100,  Align:"Right",   ColMerge:true,   SaveName:"recdAmount",          CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"추천율(%)|추천율(%)",                       Type:"Int",       Hidden:false,  Width:100,  Align:"Center",  ColMerge:true,   SaveName:"recdRate",            CalcLogic:"",   Format:"Integer",     PointCount:2,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"선정여부|선정여부",                          	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:true,   SaveName:"st",                  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });
		ibHeader.addHeader({Header:"비고|비고",                               	Type:"Text",      Hidden:false,  Width:300,  Align:"Left",    ColMerge:true,   SaveName:"resnMemo",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30,    Wrap:true });


		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 50, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, FrozenCol:5,  statusColHidden: true, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet2";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "600px");
		ibHeader.initSheet(sheetId);
		sheet2.SetSelectionMode(4);
	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	// sort시 스크롤 상위로 이동
	function sheet2_OnSort(col, order) {
	   sheet2.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		if( '<c:out value="${user.fundAuthType}"/>' == 'ADMIN' ){
			setSelect(f.searchTradeDept, '');
		}else {
			setSelect(f.searchTradeDept, '<c:out value="${searchTradeDept}"/>');
		}
		setSelect(f.searchSt, "");
	}

	//조회
	function doSearch() {

		var f = document.form1;
		var sheetObj1 = sheet1;
		var sheetObj2 = sheet2;
		var chk_ym = f.chkYm.value;
		chk_ym = chk_ym.replace("-", "");
		chk_ym = chk_ym.substring(0,6);

		if(chk_ym < '201301'){
			$('#sheet1').hide();
			$('#sheet2').show();
			getOldList()
		}else{
			$('#sheet1').show();
			$('#sheet2').hide();
			getList();
		}
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectEvaluateSpeHistoryList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function getOldList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectEvaluateSpeHistoryOldList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				$('#resultCnt').val(data.resultCnt);
				sheet2.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
			, params : {
				speChk : 'Y'
			}
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				$("input[name=chkYm]").val(resultObj.bsnStartDt);		//접수기간
			}
		});
	}

	//엑셀다운
	function doExcel(){
        var f = document.form1;
        var chk = getSelectedValue(f.searchTradeDept);
        var excelNm = f.searchTitle.value;

        if(chk != ""){
        	excelNm += "(" + getSelectedText(f.searchTradeDept) + ")";
        }

        var chk_ym = f.chkYm.value;
		chk_ym = chk_ym.replace("-", "");
		chk_ym = chk_ym.substring(0,6);

		if(chk_ym < '201301'){
	        if(sheet2.RowCount() > 0){
	        	downloadIbSheetExcel(sheet2, excelNm, '');
	        }else{
	        	alert("다운로드 할 항목이 없습니다.");
	        }
		}else{
	        if(sheet1.RowCount() > 0){
	        	downloadIbSheetExcel(sheet1, excelNm , '');
	        }else{
	        	alert("다운로드 할 항목이 없습니다.");
	        }
		}
	}

	function sheet1_OnRowSearchEnd(row) {
		if ( row > 0) {
		var index = sheet1.GetCellValue(row, "no");
		var resultCnt = $('#resultCnt').val();
		sheet1.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	}

	function sheet2_OnRowSearchEnd(row) {
		if ( row > 0) {
		var index = sheet2.GetCellValue(row, "no");
		var resultCnt = $('#resultCnt').val();
		sheet2.SetCellValue(row, "rn", parseInt(resultCnt - index)+1 );
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}
	}

</script>
