<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
	.formTable td .field_set[data-term-type] {display:none;}
	.formTable td .field_set[data-term-type].on {display:block;}
	.totRow {background-color: #DCDCDC !important; color: #000 !important; font-weight: 500;}
</style>

<script type="text/javascript">

	function goSearch(){
		if ($("input[name=chkDivision]:checked").val() == 'month'){
		    var startYear = $("#startYear").val();
		    var startMonth = $("#startMonth").val();
		    var endYear = $("#endYear").val();
		    var endMonth = $("#endMonth").val();
		    var da1 = new Date(startYear, startMonth, "01");
		    var da2 = new Date(endYear, endMonth, "01");
		    var dif = da2 - da1;
		    var cDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
		    var cMonth = cDay * 30;// 월 만듬
		    var cYear = cMonth * 12; // 년 만듬

		    if (startYear > endYear){
		    	alert("시작일은 종료일을 초과할 수 없습니다.");
		    	return;
		    }
		    if (startYear == endYear && startMonth > endMonth){
		    	alert("시작일은 종료일을 초과할 수 없습니다.");
		    	return;
		    }
		    if (parseInt(dif/cMonth) > 24){
		    	alert("월별검색은 2년을 초과할 수 없습니다.");
		    	return;
		    }
		}else if ($("input[name=chkDivision]:checked").val() == 'date'){
		    var startDate = $("#startDate").val();
		    var endDate = $("#endDate").val();

		    if (startDate == ""){
		    	alert("시작일을 입력해주세요.");
		    	return;
		    }
		    if (endDate == ""){
		    	alert("종료일을 입력해주세요.");
		    	return;
		    }
		    var ar1 = startDate.split('-');
		    var ar2 = endDate.split('-');
		    var da1 = new Date(ar1[0], ar1[1], ar1[2]);
		    var da2 = new Date(ar2[0], ar2[1], ar2[2]);
		    var dif = da2 - da1;
		    var cDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
		    var cMonth = cDay * 30;// 월 만듬
		    var cYear = cMonth * 12; // 년 만듬
		    if (startDate > endDate){
		    	alert("시작일은 종료일을 초과할 수 없습니다.");
		    	return;
		    }
		    if (parseInt(dif/cDay) > 30){
		    	alert("최대 30일까지만 조회가능합니다.");
		    	return;
		    }
		}else if ($("input[name=chkDivision]:checked").val() == 'year'){
		    var startYear = $("#searchStartYear").val();
		    var endYear = $("#searchEndYear").val();
		    var da1 = new Date(startYear, "01", "01");
		    var da2 = new Date(endYear, "01", "01");
		    var dif = da2 - da1;
		    var cDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
		    var cMonth = cDay * 30;// 월 만듬
		    var cYear = cMonth * 12; // 년 만듬
		    if (startYear > endYear){
		    	chkStatus = false;
		    	alert("시작일은 종료일을 초과할 수 없습니다.");
		    	return;
		    }

		    if (parseInt(dif/cMonth) > 24){
		    	alert("년도별검색은 2년을 초과할 수 없습니다.");
		    	return;
		    }
		}

		$("#division").val($("input[name=chkDivision]:checked").val());
		$('#searchFrm').attr('action','/online/certificate.do');
		$("#searchFrm").submit();

	}

	function goReset() {
		location.href = '/online/certificate.do';
	}

	$(document).ready(function(){

		if ( $("#division").val() !="" ){
			$('.formTable').find('.field_set').removeClass('on');
			$('.formTable').find('.field_set[data-term-type='+$("#division").val()+']').addClass('on')
		}

		$("input[type=radio]").change(function(){
			var radioVal = $(this).val();
			if($(this).prop('checked')) {
				$('.formTable').find('.field_set[data-term-type='+radioVal+']').addClass('on').siblings('.field_set[data-term-type]').removeClass('on');
			}
		});

	})

	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

	function doExcelDownload() {	// 엑셀다운
		$('#searchFrm').attr('action','/online/certificateExcelDown.do');
		$('#searchFrm').submit();
	}

</script>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" id="btnExcel" class="btn_sm btn_primary" onclick="doExcelDownload();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="goReset();">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="goSearch();">검색</button>
	</div>
</div>

<!-- 무역현장 컨설팅 리스트 -->
<div class="page_tradesos">
	<form name="searchFrm" id="searchFrm" method="post">
	<input type="hidden" id="division" name="division" value="<c:out value="${searchVO.division}"/>">

		<table class="formTable">
			<colgroup>
				<col style="width:380px">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>
						<label class="label_form">
							<input type="radio" name="chkDivision" class="form_radio" value="month" <c:if test="${empty searchVO.division or searchVO.division eq 'month' }">checked</c:if>>
							<span for="radio2_1" class="label">월별 검색</span>
						</label>
						<label class="label_form">
							<input type="radio" name="chkDivision" class="form_radio" value="date" <c:if test="${searchVO.division eq 'date' }">checked</c:if>>
							<span for="radio2_1" class="label">기간 검색</span>
						</label>
						<label class="label_form">
							<input type="radio" name="chkDivision" class="form_radio" value="year" <c:if test="${searchVO.division eq 'year' }">checked</c:if>>
							<span for="radio2_1" class="label">연도별 검색</span>
						</label>
					</th>
					<td>
						<div class="field_set on" data-term-type="month">
							<div class="flex">
								<div class="date_set_type2 form_row">
									<select name="startYear" id="startYear" class="form_select wAuto">
										<c:choose>
											<c:when test="${empty searchVO.startYear }">
												<c:set var="startYear" value="${searchVO.preYear }"/>
											</c:when>
											<c:otherwise>
												<c:set var="startYear" value="${searchVO.startYear }"/>
											</c:otherwise>
										</c:choose>

										<c:forEach var="i" begin="0" end="${searchVO.year-2005}">
										<c:set var="yearOption" value="${searchVO.year-i}" />
											<option value="${yearOption}" <c:if test="${yearOption eq startYear }">selected</c:if>>${yearOption}</option>
										</c:forEach>
									</select>

									<span class="append">년</span>
									<select name="startMonth" id="startMonth" class="form_select wAuto">
										<c:choose>
											<c:when test="${empty searchVO.startMonth }">
												<c:set var="startMonth" value="${searchVO.month }"/>
											</c:when>
											<c:otherwise>
												<c:set var="startMonth" value="${searchVO.startMonth }"/>
											</c:otherwise>
										</c:choose>
										<c:forEach var="i" begin="1" end="12">
											<c:set var="zero" value=""/>
											<c:if test="${i<10 }">
												<c:set var="zero" value="0"/>
											</c:if>
											<option value="${zero }${i}" <c:if test="${i eq startMonth }">selected</c:if>>${i}</option>
										</c:forEach>
									</select>
									<span class="append">월</span>
								</div><!-- //.date_set_type2 -->
								<div class="spacing">~</div>
								<div class="date_set_type2 form_row">
									<select name="endYear" id="endYear" class="form_select wAuto">
										<c:forEach var="i" begin="0" end="${searchVO.year-2005}">
										<c:set var="yearOption" value="${searchVO.year-i}" />
											<option value="${yearOption}" <c:if test="${yearOption eq searchVO.endYear }">selected</c:if>>${yearOption}</option>
										</c:forEach>
									</select>
									<span class="append">년</span>
									<select name="endMonth" id="endMonth" class="form_select wAuto">
										<c:forEach var="i" begin="1" end="12">
											<c:set var="zero" value=""/>
											<c:if test="${i<10 }">
												<c:set var="zero" value="0"/>
											</c:if>
											<option value="${zero }${i}" <c:if test="${i eq searchVO.month or i eq searchVO.endMonth }">selected</c:if>>${i}</option>
										</c:forEach>
									</select>
									<span class="append">월</span>
								</div>
							</div><!-- //.date_set_type2 -->
						</div><!-- //.field_set -->

						<div class="field_set date_set" data-term-type="date">
							<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="startDate" name="startDate" value="<c:out value="${searchVO.startDate}"/>" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="mtiClearDate('startDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="endDate" name="endDate" value="<c:out value="${searchVO.endDate}"/>" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
								<!-- clear 버튼 -->
								<button type="button" class="ml-8" onclick="mtiClearDate('endDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
							</div>
						</div>

						</div><!-- //.field_set -->

						<div class="field_set" data-term-type="year">
							<div class="flex">
								<div class="date_set_type2 form_row">
									<select name="searchStartYear" id="searchStartYear" class="form_select wAuto">
										<c:choose>
											<c:when test="${empty searchVO.searchStartYear }">
												<c:set var="searchStartYear" value="${searchVO.preYear }"/>
											</c:when>
											<c:otherwise>
												<c:set var="searchStartYear" value="${searchVO.searchStartYear }"/>
											</c:otherwise>
										</c:choose>
										<c:forEach var="i" begin="0" end="${searchVO.year-2005}">
										<c:set var="yearOption" value="${searchVO.year-i}" />
											<option value="${yearOption}" <c:if test="${yearOption eq searchStartYear }">selected</c:if>>${yearOption}</option>
										</c:forEach>
									</select>
									<span class="append">년</span>
								</div><!-- //.date_set_type2 -->
								<div class="spacing">~</div>
								<div class="date_set_type2 form_row">
									<select name="searchEndYear" id="searchEndYear" class="form_select wAuto">
										<c:forEach var="i" begin="0" end="${searchVO.year-2005}">
										<c:set var="yearOption" value="${searchVO.year-i}" />
											<option value="${yearOption}" <c:if test="${yearOption eq searchVO.searchEndYear }">selected</c:if>>${yearOption}</option>
										</c:forEach>
									</select>
									<span class="append">년</span>
								</div><!-- //.date_set_type2 -->
							</div>
						</div><!-- //.field_set -->
					</td>
				</tr>
			</tbody>
		</table><!-- //.formTable -->
	</form>
</div>
<div class="cont_block mt-20">
	<table class="formTable dataTable">
		<colgroup>
			<col />
			<col style="width:6%" />
			<col style="width:6%" />
			<col style="width:6%" />

			<col style="width:8%" />
			<col style="width:7%" />
			<col style="width:6%" />
			<col style="width:7%" />
			<col style="width:8%" />
			<col style="width:6%" />

			<col style="width:7%" />
			<col style="width:7%" />
			<col style="width:6%" />
			<col style="width:7%" />

			<col style="width:6%" />
		</colgroup>
		<thead>
			<tr>
				<th rowspan="2" class="half_tit"><span class="tit_scope_row">구분</span><span class="tit_scope_clm">기간</span></th>
				<th scope="col" colspan="3">수출입 증명서</th>
				<th scope="col" colspan="6">무역관련 증명서</th>
				<th scope="col" colspan="4">무역아카데미 증명서</th>
				<th scope="col" rowspan="2">기간 합계</th>
			</tr>
			<tr>
				<th scope="col">수출실적</th>
				<th scope="col">수입실적</th>
				<th scope="col">소계</th>
				<th scope="col">수출의 탑<br>수상 확인증</th>
				<th scope="col">외환수수료<br>우대 확인서</th>
				<th scope="col">회원증</th>
				<th scope="col">회비영수증<br>(입금증)</th>
				<th scope="col">무역업고유번호<br>부여증</th>
				<th scope="col">소계</th>
				<th scope="col">단기과정<br>수료증</th>
				<th scope="col">온라인(CTC)<br>수료증</th>
				<th scope="col">자격증</th>
				<th scope="col">소계</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${resultList }" var="list">
				<c:set var="totalCell1" value="${list.cell1+totalCell1 }"/>
				<c:set var="totalCell2" value="${list.cell2+totalCell2 }"/>
				<c:set var="totalCell3" value="${list.cell3+totalCell3 }"/>
				<c:set var="totalCell4" value="${list.cell4+totalCell4 }"/>
				<c:set var="totalCell5" value="${list.cell5+totalCell5 }"/>
				<c:set var="totalCell6" value="${list.cell6+totalCell6 }"/>
				<c:set var="totalCell7" value="${list.cell7+totalCell7 }"/>
				<c:set var="totalCell8" value="${list.cell8+totalCell8 }"/>
				<c:set var="totalCell9" value="${list.cell9+totalCell9 }"/>
				<c:set var="totalCell10" value="${list.cell10+totalCell10 }"/>
				<tr>
					<th scope="row">
						<c:choose>
							<c:when test="${searchVO.division eq 'date' }">
								<c:out value="${fn:substring(list.reqDate,0,4) }"/>.<c:out value="${fn:substring(list.reqDate,4,6) }"/>.<c:out value="${fn:substring(list.reqDate,6,8) }"/>
							</c:when>
							<c:when test="${searchVO.division eq 'year' }">
								<c:out value="${fn:substring(list.reqDate,0,4) }"/>
							</c:when>
							<c:otherwise>
								<c:out value="${fn:substring(list.reqDate,0,4) }"/>.<c:out value="${fn:substring(list.reqDate,4,6) }"/>
							</c:otherwise>
						</c:choose>

					</th>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell1 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell2 }" pattern="#,###" /></td>
					<td class="total_cell" data-column="2" style="text-align: right;"><fmt:formatNumber value="${list.cell1+list.cell2 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell3 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell4 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell5 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell6 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell7}" pattern="#,###" /></td>
					<td class="total_cell" data-column="5" style="text-align: right;"><fmt:formatNumber value="${list.cell3+list.cell4+list.cell5+list.cell6+list.cell7 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell8 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell9 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell10 }" pattern="#,###" /></td>
					<td class="total_cell" data-column="3" style="text-align: right;"><fmt:formatNumber value="${list.cell8+list.cell9+list.cell10 }" pattern="#,###" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.cell1+list.cell2+list.cell3+list.cell4+list.cell5+list.cell6+list.cell7+list.cell8+list.cell9+list.cell10 }" pattern="#,###" /></td>
				</tr>

			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<th scope="" class="totRow">합계</th>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell1 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell2 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell1+totalCell2 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell3 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell4 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell5 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell6 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell7 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell3+totalCell4+totalCell5+totalCell6+totalCell7 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell8 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell9 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell10 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell8+totalCell9+totalCell10 }" pattern="#,###" /></td>
				<td class="totRow" style="text-align: right;"><fmt:formatNumber value="${totalCell1+totalCell2+totalCell3+totalCell4+totalCell5+totalCell6+totalCell7+totalCell8+totalCell9+totalCell10 }" pattern="#,###" /></td>
			</tr>
		</tfoot>
	</table><!-- //.colPosi-->
</div>

<script>
	$(function(){
		tot();

		function tot(){
			var $totalCell = $('.sttTable tbody .total_cell');
			$totalCell.each(function(){
				var $row = $(this).parent('tr'),
					repeatNum = Number($(this).attr('data-column')),
					idx = $(this).index(),
					i = idx-repeatNum,
					tot = 0;
			});
		}
	});
	</script>