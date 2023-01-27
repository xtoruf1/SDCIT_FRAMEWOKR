<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="goSearch();">검색</button>
	</div>
</div>

<div class="page_na_list">
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">무역협회 발급 일자별 출력통계 검색</h3>
		</div>
		<form id="searchFrm" method="get">

			<table class="formTable">
				<colgroup>
					<col width="15%;">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th>기간</th>
						<td>
							<div class="field_set date_set" data-term-type="date">
								<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="sdate" name="sdate" value="<c:out value="${sDate}"/>" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('sdate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>

								<div class="spacing">~</div>

								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="edate" name="edate" value="<c:out value="${eDate}"/>" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="mtiClearDate('edate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</div>
							<!-- 종료 날짜는 현재 날짜가 선택되어 있도록 기본 셋팅 -->
						</td>
					</tr>
				</tbody>
			</table><!-- //.formTable -->
		</form>
	</div>
	<div class="cont_block mt-20">
		<!-- TO-BE 스타일 -->
		<c:if test="${not empty total}">
			<table class="formTable dataTable" style="border-top:0;">
				<colgroup>
					<col style="width:25%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><date><c:out value="${sDate }"/></date> ~ <date><c:out value="${eDate }"/></date> 기간 총 출력횟수</th>
						<td class="align_r"><fmt:formatNumber value="${total }" pattern="#,###" /></td>
					</tr>
				</tbody>
			</table><!-- //.rowPosi -->
		</c:if>
	</div>
	<P class="mt-20">일자별로 출력완료횟수 합계를 검색합니다.</P>

</div><!-- //.page_na_list -->

<script type="text/javascript">
	function goSearch(){
		$("#searchFrm").submit();
	}

	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

</script>