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
</div>

<div class="page_na_list">
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">발급센터 출력통계 (무역협회 발급)</h3>
		</div>
		<c:forEach var="list" items="${resultList}" varStatus="status">
			<div class="tbl_opt">
				<span><c:out value="${list.year }"/>년도</span>
			</div>
			<table class="formTable dataTable mb-20">
				<colgroup>
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col style="width:7.5%" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">1</th>
						<th scope="col">2</th>
						<th scope="col">3</th>
						<th scope="col">4</th>
						<th scope="col">5</th>
						<th scope="col">6</th>
						<th scope="col">7</th>
						<th scope="col">8</th>
						<th scope="col">9</th>
						<th scope="col">10</th>
						<th scope="col">11</th>
						<th scope="col">12</th>
						<th scope="col">Total</th>
					</tr>
				</thead>
				<tbody>
					<tr>
<%-- 						<td style="text-align: center;">
							<c:if test="${empty list.month1}"> 0 </c:if>
							<c:if test="${!empty list.month1}">"
								<fmt:formatNumber value="${list.month1 }" pattern="#,###" />
							</c:if>
						</td> --%>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month1 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month2 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month3 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month4 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month5 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month6 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month7 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month8 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month9 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month10 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month11 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.month12 }" pattern="#,###" /></td>
						<td style="text-align: center;"><fmt:formatNumber value="${list.yearTotal }" pattern="#,###" /></td>
					</tr>
				</tbody>
			</table><!-- //.rowPosi -->
		</c:forEach>
	</div>
	<P class="mt-10">현재년으로부터 2년전까지의 총3년간 월별 및 년도별 출력완료횟수 합계를 나타냅니다.</P>
</div><!-- //.page_na_list-->

<script type="text/javascript">

	$(document).ready(function(){

		$(".formTable tbody tr").each( function(){
			var findTd = $(this).find("td");

			findTd.each( function(){
				var tdVal = $(this).text();
				if ( tdVal == "" ){
					$(this).text("0");
				}
			});
		});

	})
</script>