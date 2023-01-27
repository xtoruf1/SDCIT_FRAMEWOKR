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
		<h3 class="tit_block">발급센터 출력통계 (무역협회, 아카데미 통합)</h3>
	</div>
		<table class="formTable dataTable">
			<colgroup>
				<col style="width:50%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="row">총 누적 출력횟수</th>
					<td class="align_ctr"><fmt:formatNumber value="${total1 }" pattern="#,###" /></td>
				</tr>
			</thead>
			<!--
				현재 달로부터 12개월  전까지 출력 통계를 날짜 내림차순으로 정렬하여 출력.
				맨 윗 행이 조회하는 현재 년월. 1월에 해당되는 칸에만 년도 표시
			-->
			<tbody>
				<c:forEach var="list" items="${resultList1}" varStatus="status">
					<tr>
						<th scope="row">
							<c:choose>
								<c:when test="${fn:substring(list.reqDate,4,6) eq '01' }">
									<c:out value="${fn:substring(list.reqDate,0,4) }"/>&nbsp;년&nbsp;<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:when>
								<c:otherwise>
									<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:otherwise>
							</c:choose>
							월&nbsp;출력횟수
						</th>
						<td class="align_ctr"><fmt:formatNumber value="${list.certCnt }" pattern="#,###" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table><!-- //.rowPosi -->
	</div>

	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">발급센터 출력통계 (무역협회)</h3>
		</div>
		<table class="formTable dataTable">
			<colgroup>
				<col style="width:50%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="row">총 누적 출력횟수</th>
					<td class="align_ctr"><fmt:formatNumber value="${total2 }" pattern="#,###" /></td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="list" items="${resultList2}" varStatus="status">
					<tr>
						<th scope="row">
							<c:choose>
								<c:when test="${fn:substring(list.reqDate,4,6) eq '01' }">
									<c:out value="${fn:substring(list.reqDate,0,4) }"/>&nbsp;년&nbsp;<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:when>
								<c:otherwise>
									<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:otherwise>
							</c:choose>
							월&nbsp;출력횟수
						</th>
						<td class="align_ctr"><fmt:formatNumber value="${list.certCnt }" pattern="#,###" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table><!-- //.rowPosi -->
	</div>

	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">발급센터 출력통계 (아카데미)</h3>
		</div>
		<table class="formTable dataTable">
			<colgroup>
				<col style="width:50%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="row">총 누적 출력횟수</th>
					<td class="align_ctr"><fmt:formatNumber value="${total3 }" pattern="#,###" /></td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="list" items="${resultList3}" varStatus="status">
					<tr>
						<th scope="row">
							<c:choose>
								<c:when test="${fn:substring(list.reqDate,4,6) eq '01' }">
									<c:out value="${fn:substring(list.reqDate,0,4) }"/>&nbsp;년&nbsp;<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:when>
								<c:otherwise>
									<c:out value="${fn:substring(list.reqDate,4,6) }"/>
								</c:otherwise>
							</c:choose>
							월&nbsp;출력횟수
						</th>
						<td class="align_ctr"><fmt:formatNumber value="${list.certCnt }" pattern="#,###" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table><!-- //.rowPosi -->
	</div>
	<P class="mt-20">현재달로부터 12개월전까지의 월별 출력완료횟수 합계를 나타냅니다.</P>
</div><!-- //.page_na_list-->