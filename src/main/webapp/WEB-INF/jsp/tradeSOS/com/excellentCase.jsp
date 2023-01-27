<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : topMenu.jsp
  * @Description : 대메뉴 목록화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2016.04.28	이인오		최초 생성
  *
  * @author 이인오
  * @since 2016.04.28
  * @version 1.0
  * @see
  *
  */
%>
<!-- <script type="text/javascript" src="/js/tradeSosComm.js"></script> -->

<form name="searchForm" id="searchForm" action ="" method="get">
<input type="hidden" name="topMenuId" value="" />
<input type="hidden" name="pageIndex" id="pageIndex" value="<c:out value="${!empty(searchVO) ? searchVO.pageIndex : '1'}"/>"/>
<input type="hidden" name="exId" id="exId" value=""/>
<input type="hidden" name="procType" id="procType" value=""/>
<!-- 공통 - 상담 우수사례 리스트-->
<div class="page_tradesos">
	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<!-- 검색 테이블 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_insert();">신규</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
		</div>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:10%">
			<col style="width:18%">
			<col style="width:10%">
			<col style="width:18%">
			<col style="width:10%">
			<col>
		</colgroup>
		<tbody>

			<tr>
				<th scope="row">구분</th>
				<td>
					<select name="searchSosType" id="searchSosType" class="form_select w100p" onchange="setClass(this.value,'');">
						<option value="">전체</option>
						<c:forEach items="${code56}" var="item" varStatus="status">
							<option value="<c:out value="${item.cdId}"/>" <c:if test="${searchVO.searchSosType eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">분류</th>
				<td>
					<select name="searchClass" id="searchClass" class="form_select w100p">
						<option value="">전체</option>
					</select>
				</td>
				<th scope="row">작성일자</th>
				<td>
					<div class="group_datepicker">
						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="startDt" name="startDt" value="" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
								<img src="/images/icon_calender.png" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyStartDate" value="" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" onclick="clearPickerValue('startDt');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>
						</div>

						<div class="spacing">~</div>

						<!-- datepicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="endDt" name="endDt" value="" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
								<img src="/images/icon_calender.png" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								<input type="hidden" id="dummyEndDate" value="" />
							</span>

							<!-- clear 버튼 -->
							<button type="button" onclick="clearPickerValue('endDt');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">키워드</th>
				<td colspan="5">
					<div class="flex align_center">
						<select name="searchtp" id="searchtp" class="form_select">
						<option value="all" <c:if test="${searchVO.searchtp eq 'all'}">selected</c:if> >제목+내용</option>
						<option value="title" <c:if test="${searchVO.searchtp eq 'title'}">selected</c:if> >제목</option>
						<option value="content" <c:if test="${searchVO.searchtp eq 'content'}">selected</c:if> >내용</option>
						</select>
						<input type="text" id="searchnm" name="searchnm" class="form_text w100p ml-8" value="<c:out value="${searchVO.searchnm}"/>" onkeydown="onEnter(doSearch);">
					</div>
				</td>
			</tr>
		</tbody>
	</table><!-- // 검색 테이블-->
	<div class="cont_block mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
			<fieldset class="ml-auto">
				<select id="pageUnit" name="pageUnit" onchange="doSearch();" class="form_select" title="목록수">
					<c:forEach var="item" items="${pageUnitList}" varStatus="status">
						<option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
					</c:forEach>
				</select>
			</fieldset>
		</div>
	</div>

	<!-- 리스트 테이블 -->
	<div class="tbl_list">
		<div id='excellentCaseListSheet' class="colPosi"></div>
	</div>

</div> <!-- // .page_tradesos -->
<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
</form>

<script type="text/javascript">
		var searchSosType = '${searchVO.searchSosType}';
		var searchClass = '${searchVO.searchClass}';
		if(searchClass != ''){
			setClass(searchSosType,searchClass);
		}

		$(document).ready(function() {
			// 시작일 선택 이벤트
			datepickerById('startDt', fromDateSelectEvent);

			// 종료일 선택 이벤트
			datepickerById('endDt', toDateSelectEvent);

			//IBSheet 호출
			f_Init_excellentCaseListSheet();		// 리스트  Sheet 셋팅
			doSearch();				// 목록 조회
		});

		function fromDateSelectEvent() {
			var startymd = Date.parse($('#startDt').val());

			if ($('#endDt').val() != '') {
				if (startymd > Date.parse($('#endDt').val())) {
					alert('시작일은 종료일 이전이어야 합니다.');
					$('#startDt').val('');

					return;
				}
			}
		}

		function toDateSelectEvent() {
			var endymd = Date.parse($('#endDt').val());

			if ($('#startDt').val() != '') {
				if (endymd < Date.parse($('#startDt').val())) {
					alert('종료일은 시작일 이후여야 합니다.');
					$('#endDt').val('');

					return;
				}
			}
		}

		function f_Init_excellentCaseListSheet()
		{
			// 세팅
			var	ibHeader	=	new	IBHeader();

			 /** 리스트,헤더 옵션 */
	    	ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	    	ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

	        /** 헤더 세팅 */
	        ibHeader.addHeader({Type: "Text", Header: "exId"	, SaveName: "exId"		, Align: "Center"	, Hidden : true});
	        ibHeader.addHeader({Type: "Text", Header: "No"		, SaveName: "rnum"		, Align: "Center"	, Width: 40});
			ibHeader.addHeader({Type: "Text", Header: "구분"		, SaveName: "sosType"	, Align: "Center"		, Width: 80});
	        ibHeader.addHeader({Type: "Text", Header: "분류"		, SaveName: "gubunNm"	, Align: "Center"		, Width: 50});
	        ibHeader.addHeader({Type: "Text", Header: "제목"		, SaveName: "title"		, Align: "Left"		, Width: 300	, Ellipsis:1	, Ellipsis:1, Cursor:"Pointer"});
	        ibHeader.addHeader({Type: "Text", Header: "작성일자"	, SaveName: "regstDt"	, Align: "Center"	, Width: 50});
	        ibHeader.addHeader({Type: "Text", Header: "조회수"	, SaveName: "viewCnt"	, Align: "Center"	, Width: 40});
	        var sheetId = "excellentCaseListSheet";
			var container = $("#"+sheetId)[0];
	        createIBSheet2(container,sheetId, "100%", "100%");
	        ibHeader.initSheet(sheetId);

		}

		function doSearch() {
			goPage(1);
		}

		function goPage(pageIndex) {
			document.searchForm.pageIndex.value = pageIndex;
			getList();
		}

		function getList() {																//목록 조회
			var v_Search_Val = $('#searchnm').val();  											//검색 키워드

			var params = {searchnm : v_Search_Val};
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/com/excellentCaseAjax.do" />'
				, data : $('#searchForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
					setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

					excellentCaseListSheet.LoadSearchData({Data: data.resultList});
					excellentCaseListSheet.SetColFontBold('title', 1);
				}
			});
		}




 	function excellentCaseListSheet_OnClick(Row, Col, Value) {
		if(excellentCaseListSheet.ColSaveName(Col) == "title" && Row > 0){
			fn_detail(excellentCaseListSheet.GetCellValue(Row,"exId"));// 상세
		}
	};

	function press(event) {
		if (event.keyCode==13) {
			getList();
		}
	}

	//분야 조회
	function setClass(val,selected){
		var returnList = '';
		global.ajax({
			type:"post",
			url:"/tradeSOS/com/excellentSearchClassAjax.do",
			data:{'sosType':val},
			success:function(data){
				returnList = "<option value=\"\">전체</option>";
				$.each(data.codeList, function(i,item){
					returnList += '<option value="'+ item.codeId+'"'
					if(selected != ''){
						if(item.codeId == selected){
							returnList += 'selected';
						}
					}
					/*if(item.cd_id == searchId){
						returnList += 'selected';
					}*/
					returnList += '>'+ item.codeNm +'</option>';
				});

				$('#searchClass').empty();
				$('#searchClass').append(returnList);
			},error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	//상세보기
	function fn_detail(exId) {
		document.searchForm.action = "/tradeSOS/com/excellentCaseDetail.do";
		document.searchForm.exId.value = exId;
		document.searchForm.procType.value = "U";
		document.searchForm.submit();
	}

	//등록
	function fn_insert() {
		document.searchForm.procType.value = "I";
		document.searchForm.action = "/tradeSOS/com/excellentCaseDetail.do";
		document.searchForm.submit();
	}
</script>