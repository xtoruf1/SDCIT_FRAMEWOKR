<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : visitCompany.jsp
	 * @Description : 방문업체 회원 가입현황
	 */
%>
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
	</div>
</div>

<div class="page_tradesos">
	<!-- 검색 테이블 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col style="width:50%">
				<col style="width:15%">
				<col style="width:20%">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">방문기간</th>
					<td>
						<div class="form_row">
							<div class="group_datepicker" style="width:330px;">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="stDate" name="stDate" value='<c:out value="${defaultDate.stDate }"/>' class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<button type="button" class="ml-8" onclick="mtiClearDate('stDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
								<div class="spacing">~</div>
								<input type="text" class="form_text w100p" value='<c:out value="${defaultDate.edDate }"/>' readonly>
							</div>
							<div class="ml-15">
								<input type="hidden" name="edDate" id="edDate" value='<c:out value="${defaultDate.edDate }"/>'/>
								<label class="label_form">
									<input type="checkbox" id="beforeChk" class="form_checkbox" name="beforeChk" value="Y"/>
									<span class="label">방문일자 이전 가입회원사 제외</span>
								</label>
							</div>
						</div>
					</td>
					<th scope="row">자문위원</th>
					<td>
						<c:set var="expertYN" value="N"/>
						<c:forEach var="list" items="${expertList}" varStatus="varStatus">
							<c:if test="${loginId==list.expertId}">
								<c:set var="expertYN" value="Y"/>
							</c:if>
						</c:forEach>
						<select name="expertId" id="expertId" class="form_select w100p">
							<c:if test="${expertYN=='N'}">
								<option value="">선택</option>
							</c:if>
							<c:forEach var="list" items="${expertList}" varStatus="varStatus">
								<c:if test="${loginId==list.expertId || expertYN=='N'}">
									<option value="${list.expertId}">${list.name}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table><!-- // 검색 테이블-->

	<!-- 리스트 테이블 -->
	<div class="tbl_list mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id='visitCompanySheet' class="colPosi"></div>
		</div>
	</div>

	</div>
</div> <!-- // .page_tradesos -->

<!-- 패널티 등록 -->
<div id="registerTimeSettingPop" class="layerPopUpWrap"></div>

<script type="text/javascript">

	$(document).ready(function () {

		setVisitCompanyGrid(); // Sheet 생성

		// 시작일 선택 이벤트
		datepickerById('stDate', fromDateSelectEvent);

		// 종료일 선택 이벤트
		datepickerById('edDate', toDateSelectEvent);

		doSearch();

	});

	function fromDateSelectEvent() {
		var startymd = Date.parse($('#stDate').val());

		if ($('#edDate').val() != '') {
			if (startymd > Date.parse($('#edDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#stDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#edDate').val());

		if ($('#stDate').val() != '') {
			if (endymd < Date.parse($('#stDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#edDate').val('');

				return;
			}
		}
	}

	//방문자 회원가입 현황 sheet 생성
	function setVisitCompanyGrid() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "업체명", 			SaveName: "company", 		Align: "Left", 	Width: 400});
		ibHeader.addHeader({Type: "Text", Header: "사업자등록번호", 	SaveName: "companyNo", 		Align: "Center", 	Width: 80});
		ibHeader.addHeader({Type: "Text", Header: "방문일자", 		SaveName: "visitDate", 		Align: "Center",	Width: 70});
		ibHeader.addHeader({Type: "Text", Header: "최초방문일자", 	SaveName: "firVisitDate", 	Align: "Center",	Width: 70});
		ibHeader.addHeader({Type: "Text", Header: "회원가입일", 		SaveName: "joinRegDate", 	Align: "Center",	Width: 70});

		var sheetId = "visitCompanySheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "640px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		visitCompanySheet.SetEditable(0);

	};

	//  1:1상담 시간 설정 조회
	function doSearch() {

		if( $('#expertId').val() == '' ){
			alert('자문위원을 선택 하세요');
			return;
		}

		var chk = '';
		if( $('#beforeChk:checked').val() != null ){
			chk = $('#beforeChk:checked').val();
		}

		var jsonParam = {
				expertId : $('#expertId').val()
				,stDate : $('#stDate').val()
				,edDate : $('#edDate').val()
				,beforeChk : chk
		};

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/selectVisitCompanyList.do" />'
			, data : JSON.stringify(jsonParam)
			, dataType : 'json'
			, contentType: "application/json; charset=utf-8"
			, async : true
			, spinner : true
			, success : function(data){

				visitCompanySheet.LoadSearchData({Data: data.result});
			},
			error:function(request, status, error) {
				alert('방문업체 회원 가입현황 조회에 실패했습니다.');
			}
		});
	}

	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

</script>
