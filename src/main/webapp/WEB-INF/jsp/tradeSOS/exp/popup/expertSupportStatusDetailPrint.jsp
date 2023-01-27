<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<% 
	pageContext.setAttribute("crcn", "\r\n");
%>
<div class="cont_block" style="margin: 50px 50px 50px 50px;">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">전문가지원 신청정보</h3>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width: 20%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">이름</th>
				<td>${resultData.expertNm}</td>
				<th scope="row" rowspan="3">증명사진</th>
				<td rowspan="3">
					<figure class="photo">
						<c:choose>
							<c:when test="${not empty resultData.expertFileVO}">
								<img src="<c:url value='/tradeSOS/exp/expertImage.do' />?fileId=${resultData.expertFileVO.fileId}&fileSeq=${resultData.expertFileVO.fileSeq}" style="width:108px;height:144px;" alt="" />
							</c:when>
							<c:otherwise>
								<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
							</c:otherwise>
						</c:choose>
					</figure>
				</td>
			</tr>
			<tr>
				<th scope="row">생년월일</th>
				<td>${resultData.birthDay}</td>
			</tr>
			<tr>
				<th scope="row">성별</th>
				<td>${resultData.sex}</td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td>
					<c:if test="${not empty resultData.maskCellPhone1 and not empty resultData.maskCellPhone2 and not empty resultData.cellPhone3}">
						${resultData.maskCellPhone1}-${resultData.maskCellPhone2}-${resultData.cellPhone3}
					</c:if>
				</td>
				<th scope="row">전화</th>
				<td>
					<c:if test="${not empty resultData.tel1 and not empty resultData.tel2 and not empty resultData.tel3}">
						${resultData.tel1}-${resultData.tel2}-${resultData.tel3}
					</c:if>
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>&nbsp;</td>
				<th scope="row">활동국가</th>
				<td>
					<c:forEach var="item" items="${nationList}" varStatus="status">
						<c:if test="${item.CODE eq resultData.atvCtrCd}">${item.CODE_NM}</c:if>
					</c:forEach>
					<c:forEach var="item" items="${regionList}" varStatus="status">
						<c:if test="${item.cdId eq resultData.atvAreaCd}">${item.cdNm}</c:if>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<th scope="row">지원 전문가 분야</th>
				<td colspan="3">
					<c:forEach var="item" items="${consultList}" varStatus="status1">
						<c:forEach var="resultData" items="${consultingList}" varStatus="status2">
								<c:if test="${item.CONSULT_TYPE_CD eq resultData.consultTypeCd}">${item.CONSULT_TYPE_NM}</c:if>
						</c:forEach>
					</c:forEach>
				</td>
			</tr>
			<tr id="eduClass">
				<th scope="row">학력</th>
				<td colspan="3">
					<div class="addInput">
						<c:forEach var="item" items="${educationList}" varStatus="status">
							<div class="add_line">
								${item.edu}
							</div>
						</c:forEach>
					</div>
				</td>
			</tr>
			<tr id="licenseClass">
				<th scope="row">자격증</th>
				<td colspan="3">
					<div class="addInput">
						<c:forEach var="item" items="${licenseList}" varStatus="status">
							<div class="add_line">
								${item.license}
							</div>
						</c:forEach>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">주요이력</th>
				<td colspan="3">
					<c:out value="${fn:replace(resultData.majorHistory , crcn, '<br/>')}" escapeXml="false" />
				</td>
			</tr>
			<tr>
				<th scope="row">자기소개</th>
				<td colspan="3">
					<c:out value="${fn:replace(resultData.myIntro , crcn, '<br/>')}" escapeXml="false" />
				</td>
			</tr>
		</tbody>
	</table>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		window.print();
	});
</script>