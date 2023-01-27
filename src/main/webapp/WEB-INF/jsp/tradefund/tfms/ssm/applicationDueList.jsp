<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" name="hSCreDateSt" value="<c:out value="${getCreDate.searchCreDateSt}"/>">
<input type="hidden" name="hSCreDateEd" value="<c:out value="${getCreDate.searchCreDateEd}"/>">

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
						<span class="form_search w100p">
							<input type="hidden" id="searchSvrId" name="searchSvrId" />
							<input type="text" class="form_text "  title="기금융자" id="searchTitle" name="searchTitle" readonly="readonly" onkeydown="onEnter(doSearch);" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td >

					<fieldset class="widget">
						<select id="searchTradeDept" name="searchTradeDept" class="form_select"  >
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="" >::: 전체 :::</option>
							</c:if>

							<c:forEach var="item" items="${COM001}" varStatus="status">
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="<c:out value="${item.chgCode01}"/>"><c:out value="${item.detailnm}"/></option>
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
				<th scope="row">회사명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCoNmKor" name="searchCoNmKor" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="회사명" maxlength="200" />
					</fieldset>
				</td>
            </tr>
			<tr>
				<th scope="row">무역업번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchBsNo" name="searchBsNo" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="무역업번호"  maxlength="8" />
					</fieldset>
				</td>
				<th scope="row">사업자등록번호</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchIndustryNo" name="searchIndustryNo" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사업자등록번호" maxlength="10"  />
					</fieldset>
				</td>
				<th scope="row">대표자명</th>
				<td>
					<fieldset class="widget">
						<input type="text" id="searchCeoNmKor" name="searchCeoNmKor" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="대표자명" maxlength="40"  />
					</fieldset>
				</td>
            </tr>
            <tr>
            	<th>기간검색</th>
				<td colspan="5">
					<div class="group_datepicker group_item">
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" name="searchCreDateSt" id="searchCreDateSt" value="${getCreDate.searchCreDateSt}" class="txt datepicker" title="조회시작일자입력" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" class="dateClear" onclick="clearPickerValue('searchCreDateSt')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>

						<div class="spacing">~</div>

						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" name="searchCreDateEd" id="searchCreDateEd" value="${getCreDate.searchCreDateEd}" class="txt datepicker" title="조회종료일자입력" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" class="dateClear" onclick="clearPickerValue('searchCreDateEd')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
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
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"기금융자명",    	Type:"Text",      Hidden:false,   Width:260,   Align:"Left",     SaveName:"svrTitle",        	 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"신청일자",        	Type:"Text",      Hidden:false,   Width:160,   Align:"Center",   SaveName:"creDt",      		 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"무역업번호",     	Type:"Text",      Hidden:false,   Width:180,   Align:"Center",   SaveName:"bsNo",         		 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"사업자번호",        Type:"Text",     Hidden:false,   Width:180,   Align:"Center",   SaveName:"industryNo",      	 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"회사명",        	Type:"Text",      Hidden:false,   Width:150,   Align:"Left",     SaveName:"coNmKor",      		 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"상태",      		Type:"Text",      Hidden:false,   Width:100,   Align:"Center",   SaveName:"state",    			 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"등급",          	Type:"Text",      Hidden:false,   Width:100,   Align:"Center",   SaveName:"levelGb",     	 	 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"금리",      		Type:"Float",     Hidden:false,   Width:100,   Align:"Center",   SaveName:"interestRate",   	 CalcLogic:"",   Format:"#,###.##",    PointCount:2,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"1차융자금",        	Type:"Text",      Hidden:false,   Width:140,   Align:"Right",    SaveName:"defntAmount",    	 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"2차융자금",    		Type:"Text",      Hidden:false,   Width:140,   Align:"Right",    SaveName:"defntAmount2",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"3차융자금",        	Type:"Text",      Hidden:false,  Width:140,    Align:"Right",    SaveName:"defntAmount3",      	 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"미납회수",    		Type:"Text",      Hidden:false,   Width:120,   Align:"Right",    SaveName:"feeArrearYearAllCnt", CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"미납연도",     		Type:"Text",      Hidden:false,   Width:170,   Align:"Left",     SaveName:"feeArrearYearAll",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_성명",    	Type:"Text",      Hidden:false,   Width:140,   Align:"Center",   SaveName:"membNm",    			 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_전화번호",  	Type:"Text",      Hidden:false,   Width:160,   Align:"Center",   SaveName:"membTel",   			 CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_팩스",     	Type:"Text",      Hidden:false,   Width:160,   Align:"Center",   SaveName:"membFax", 			 CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_핸드폰",     Type:"Text",      Hidden:false,   Width:160,   Align:"Center",   SaveName:"membHp",      		 CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_EMAIL",    	Type:"Text",      Hidden:false,   Width:180,   Align:"Left",     SaveName:"membEmail", 			 CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_부서명",     Type:"Text",   	  Hidden:false,   Width:140,   Align:"Center",   SaveName:"membDeptnm", 		 CalcLogic:"",   Format:"",     	   PointCount:0,   UpdateEdit:false,   InsertEdit:false});
		ibHeader.addHeader({Header:"담당자_직위",      	Type:"Text",      Hidden:false,   Width:140,   Align:"Center",   SaveName:"membPosition",   		 CalcLogic:"",   Format:"",     	   PointCount:0,   UpdateEdit:false,   InsertEdit:false});

		ibHeader.setConfig({AutoFitColWidth: 'colhidden|rowtransaction', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0 , FrozenCol:3, MergeSheet:msHeaderOnly, UseHeaderSortCancel: 1, MaxSort: 1});
		ibHeader.setHeaderMode({Sort: 1, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "540px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

	}

	// sort시 스크롤 상위로 이동
	function sheet1_OnSort(col, order) {
	   sheet1.SetScrollTop(0);
	}

	//초기화
	function doClear(){
		var f = document.form1;

		f.searchSvrId.value = "";
		f.searchTitle.value = "";

		f.searchCoNmKor.value = "";
		f.searchBsNo.value = "";

		f.searchIndustryNo.value = "";
		f.searchCeoNmKor.value = "";

		f.searchCreDateSt.value = f.hSCreDateSt.value;
		f.searchCreDateEd.value = f.hSCreDateEd.value;



		if( '${user.fundAuthType}' == 'ADMIN' ){
			f.searchTradeDept.value = '${searchTradeDept}';
		}else {
			f.searchTradeDept.options[0].selected = true;
		}
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectApplicationDueList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet1.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//엑셀다운
	function doExcel(){

        var f = document.form1;
        var rowSkip = sheet1.LastRow();

        if(sheet1.RowCount() > 0){
        	downloadIbSheetExcel(sheet1, "회비미납업체조회", "");
        }else{
        	alert("다운로드 할 항목이 없습니다.");
        }
	}

	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);			//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);			//기금융자명
				getList();
			}
		});
	}


</script>