<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<%
	pageContext.setAttribute("cn", "\n");
%>
<div style="width: 700px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">공적조서</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col />
			</colgroup>
	<c:choose>
		<c:when test="${param.prvPriType eq '10' or param.prvPriType eq '21'}">
			<tr>
				<th style="text-align: left;">1) 기본사항</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Item1, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">2) 수출실적</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Item2, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">3) 기술개발</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Item4, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">4) 해외시장개척</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Item4, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">5) 기타</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Etc, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
		</c:when>
		<c:otherwise>
			<tr>
				<th style="text-align: left;">1) 기본사항</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk2Item1, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">2) 기여도</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk2Item2, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">3) 수상등 공적</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk2Item3, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th style="text-align: left;">4) 기타</th>
			</tr>
			<tr>
				<td style="height: 100px;"><c:out value="${fn:replace(resultView.kongjuk1Etc, cn, '<br />')}" escapeXml="false" /></td>
			</tr>
		</c:otherwise>
	</c:choose>
		</table>
		<div style="margin-top: 10px;">
			<table class="formTable">
				<colgroup>
					<col />
				</colgroup>
				<tr>
					<th style="text-align: left;">1) 수공기간</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj1, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th style="text-align: left;">2) 국가발전 기여도</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj2, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th style="text-align: left;">3) 국민생활 향상도</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj3, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th style="text-align: left;">4) 창조적 기여도</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj4, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th style="text-align: left;">5) 무역진흥 기여도</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj5, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
				<tr>
					<th style="text-align: left;">6) 사회공헌 및 기타 기여도</th>
				</tr>
				<tr>
					<td style="height: 100px;"><c:out value="${fn:replace(resultView.sanghunKj6, cn, '<br />')}" escapeXml="false" /></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>