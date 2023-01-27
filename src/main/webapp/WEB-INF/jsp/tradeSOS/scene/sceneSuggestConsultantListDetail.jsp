<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<script type="text/javascript">
	function fn_list() {
		$("#searchForm").attr("action","/tradeSOS/scene/sceneSuggestConsultantList.do");
		$("#searchForm").submit();
	}
</script>

<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
	</div>
</div>

<!-- 무역현장 컨설팅 상세 -->
<div class="page_tradesos">
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">회사정보</h3>
		</div>
		<table class="boardwrite formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"> 회사명</th>
					<td class="align_ctr"><c:out value="${resultData.company}"/></td>
					<th scope="row">무역업고유번호</th>
					<td class="align_ctr"><c:out value="${resultData.tradeNo}"/></td>
				</tr>
				<tr>
					<th scope="row">대표자</th>
					<td class="align_ctr"><c:out value="${resultData.companyPresident}"/></td>
					<th scope="row">사업자등록번호</th>
					<td class="align_ctr"><c:out value="${resultData.companyNo}"/></td>
				</tr>
				<tr>
					<th scope="row">대표전화</th>
					<td class="align_ctr"><c:out value="${resultData.companyTel}"/></td>
					<th scope="row">FAX</th>
					<td class="align_ctr"><c:out value="${resultData.companyFax}"/></td>
				</tr>
				<tr>
					<th scope="row">회사주소</th>
					<td colspan="3"><c:out value="${resultData.companyAddr}"/></td>
				</tr>
			</tbody>
		</table><!-- // 회사정보 테이블-->
	</div>
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">신청내역</h3>
		</div>
		<table class="boardwrite formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">접수경로</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${empty resultData.routeCdNm}">
								자문신청
							</c:when>
							<c:otherwise>
								<c:out value="${resultData.routeCdNm}"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td><c:out value="${resultData.applyName}"/></td>
					<th scope="row">직책</th>
					<td><c:out value="${resultData.applyGrade}"/></td>
				</tr>
			</tbody>
		</table><!-- // 신청내역 테이블-->
	</div>
	<form id="searchForm">
		<input type="hidden" name="pageIndex" value="<c:out value="${searchVO.pageIndex}"/>"/>
		<input type="hidden" name="frDt" value="<c:out value="${searchVO.frDt}"/>"/>
		<input type="hidden" name="toDt" value="<c:out value="${searchVO.toDt}"/>"/>
		<input type="hidden" name="title" value="<c:out value="${searchVO.title}"/>"/>
		<input type="hidden" name="content" value="<c:out value="${searchVO.content}"/>"/>
		<input type="hidden" name="searchCondition" value="<c:out value="${searchVO.searchCondition}"/>"/>
		<input type="hidden" name="searchKeyword" value="<c:out value="${searchVO.searchKeyword}"/>"/>
		<input type="hidden" name="searchKeyword2" value="<c:out value="${searchVO.searchKeyword2}"/>"/>
		<input type="hidden" name="applyName" value="<c:out value="${searchVO.applyName}"/>"/>
		<input type="hidden" name="expertNm" value="<c:out value="${searchVO.expertNm}"/>"/>
		<input type="hidden" name="sect" value="<c:out value="${searchVO.sect}"/>"/>
		<input type="hidden" name="item" value="<c:out value="${searchVO.item}"/>"/>
		<input type="hidden" name="mtiCode" value="<c:out value="${searchVO.mtiCode}"/>">
		<input type="hidden" name="mtiUnit" value="<c:out value="${searchVO.mtiUnit}"/>">
		<input type="hidden" name="status" value="<c:out value="${searchVO.status}"/>"/>
	</form>

</div> <!-- // .page_tradesos -->