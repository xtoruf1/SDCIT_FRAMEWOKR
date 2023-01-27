<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="prepaymentRegisteDetailPrintPopupForm" name="prepaymentRegisteDetailPrintPopupForm" method="get" onsubmit="return false;">

<div class="winPopContinent">
<!-- 팝업 타이틀 -->
<div class="flex hiddenPrint">
	<h2 class="popup_title">상환상세관리</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_primary" 		onclick="doPrint();" 			 >인쇄</button>
		<button class="btn_sm btn_secondary" 	onclick="doClose();"	>닫기</button>
	</div>
</div>

<div class="popup_body">

	<div class="cont_block">

		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col style="width:15%;">
				<col style="width:17.5%;">
				<col style="width:17.5%;">
				<col style="width:17.5%;">
				<col style="width:5%;">
				<col>
			</colgroup>
			<tr>
				<th rowspan="10">
					정기상환
				</th>
				<th>회사명</th>
				<td>
					<c:out value="${fundVo.fndBiznm}"/>
				</td>
				<th>신청액</th>
				<td class="align_r">
					<c:out value="${fundVo.fndReqamt}"/>
				</td>
				<td  colspan="2">
				</td>
			</tr>
			<tr>
				<th>대표자</th>
				<td>
					<c:out value="${fundVo.ceoNmKor}"/>
				</td>
				<th>추천액</th>
				<td class="align_r">
					<c:out value="${fundVo.fndRecamt}"/>
				</td>
				<td  colspan="2" >
					<c:out value="${fundVo.fndRecdt}"/>
				</td>
			</tr>
			<tr>
				<th>사업자번호</th>
				<td>
					<c:out value="${fundVo.fndBizno}"/>
				</td>
				<th>융자액</th>
				<td class="align_r">
					<c:out value="${fundVo.fndFinamt}"/>
				</td>
				<td  colspan="2">
					<c:out value="${fundVo.fndFindt}"/>
				</td>
			</tr>
			<tr>
				<th>지역본부</th>
				<td>
					<c:out value="${fundVo.fndSitenm}"/>
				</td>
				<th>정기상환액</th>
				<td class="align_r">
					<c:out value="${fundVo.vfndSum1}"/>
				</td>
				<td  colspan="2">
				</td>
			</tr>
			<tr>
				<th>은행</th>
				<td>
					<c:out value="${fundVo.fndBankNm}"/>
				</td>
				<th>중도상환액</th>
				<td class="align_r">
					<c:out value="${fundVo.fndRedamt}"/>
				</td>
				<td  colspan="2">
				</td>
			</tr>
			<tr>
				<th>지점</th>
				<td>
					<c:out value="${fundVo.fndSbank}"/>
				</td>
				<th>총상환액</th>
				<td class="align_r">
					<c:out value="${fundVo.vfndSum2}"/>
				</td>
				<th>잔액</th>
				<td class="align_r">
					<c:out value="${fundVo.vfndBal}"/>
				</td>
			</tr>
			<tr>
				<th>비고</th>
				<td  colspan="5">
					<c:out value="${fundVo.fndMemo}"/>
				</td>
			</tr>
			<tr>
				<th>구분</th>
				<th>1차정기상환</th>
				<th>2차정기상환</th>
				<th>3차정기상환</th>
				<th colspan="2">4차정기상환</th>
			</tr>
			<tr>
				<th>금액</th>
				<td class="align_r">
					<c:out value="${fundVo.fndYamt1}"/>
				</td>
				<td class="align_r">
					<c:out value="${fundVo.fndYamt2}"/>
				</td>
				<td class="align_r">
					<c:out value="${fundVo.fndYamt3}"/>
				</td>
				<td colspan="2" class="align_r">
					<c:out value="${fundVo.fndYamt4}"/>
				</td>
			</tr>
			<tr>
				<th>일자</th>
				<td class="align_ctr">
					<c:out value="${fundVo.fndYdt1}"/>
				</td>
				<td class="align_ctr">
					<c:out value="${fundVo.fndYdt2}"/>
				</td>
				<td class="align_ctr">
					<c:out value="${fundVo.fndYdt3}"/>
				</td>
				<td colspan="2" class="align_ctr">
					<c:out value="${fundVo.fndYdt4}"/>
				</td>
			</tr>

		 </table>
	</div>

	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%;">
				<col>
			</colgroup>
			<tr>
				<th>중도상환
				</th>
				<td style="padding:0">
					<table class="formTable" style="border-top: 0;">
						<colgroup>
							<col style="width:17%;">
							<col>
						</colgroup>
						<tr>
							<th style="border-left: 0;">중도상환일</th>
							<th style="border-right: 0;">중도상환액</th>
						</tr>
						<c:choose>
							<c:when test="${fn:length(redAmtRow) > 0}">
								<c:forEach var="redAmtRow" items="${redAmtRow}" varStatus="status">
									<tr>
										<td class="align_ctr"><c:out value="${redAmtRow.fndReddt}"/></td>
										<td><fmt:formatNumber value="${redAmtRow.fndRedamt}"/></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
									<tr>
										<td colspan="2" style="border: 0;">&nbsp;</td>
									</tr>
							</c:otherwise>
						</c:choose>


					</table>
				</td>
			</tr>
		</table>
	</div>


</div>
</div>
<div class="overlay"></div>
</form>

<script type="text/javascript">
	$(document).ready(function () {
		doPrint();
	});

	function doPrint(){
		var initBody;

		window.onbeforeprint = function(){
			initBody = document.body.innerHTML;
			$('.hiddenPrint').hide();
		};
		window.onafterprint = function(){
			document.body.innerHTML = initBody;
		};
		window.print();
	}

	function doClose(){
		window.close();
// 		closeLayerPopup();
	}

</script>