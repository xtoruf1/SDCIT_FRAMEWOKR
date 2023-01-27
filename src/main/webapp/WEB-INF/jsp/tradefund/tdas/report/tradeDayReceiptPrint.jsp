<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<%
	pageContext.setAttribute("cn", "\n");
%>
<link type="text/css" href="<c:url value='/css/style_tfas.css' />" rel="stylesheet" />
<style>
<!--
	/* button */
	button {
	    font-size: 100%;
	    vertical-align: middle;
	    cursor: pointer;
	    border: 0 none;
	    background-color: transparent;
	    outline: none;
	    text-align: left;
	    font-family: 'Noto Sans KR', sans-serif;
	}

	.btn {display:inline-flex; justify-content:center; align-items:center; width:200px; max-width:100%; padding:8px 10px; font-size:18px; font-weight:400; color:#fff; border-radius:2em; transition:all 0.2s ease;}
	.btn_sm {display:inline-flex; padding:5px 15px; font-size:15px; font-weight:400; color:#fff; border-radius:6px; transition:all 0.2s ease;}
	.btn_sm+.btn_sm {margin-left:5px;}
	.btn:hover:not(.disabled),
	.btn_sm:hover:not(.disabled) {box-shadow:3px 3px 8px rgba(0,0,0,.3);}
	.btn_primary {background-color:#2B5075;}
	.btn_secondary {background-color:#9C9C9C;}
	.btn.disabled,
	.btn_tbl.disabled,
	.btn_sm.disabled {color:#5C5F68; border:1px solid #ccc; background-color:#ddd; cursor:default;}
	.btn_tbl {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#1A1915;}
	.btn_tbl_border {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:4px 14px; font-size:14px; font-weight:400; color:#1A1915; border:1px solid #1A1915; border-radius:6px; background-color:#fff;}
	.btn_tbl_primary {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:4px 14px; font-size:14px; font-weight:400; color:#fff; border:1px solid #1A1915; border-radius:6px; background-color:#2B5075;}
	.btn_tbl_secondary {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#9C9C9C;}
	.btn_tbl._full,
	.btn_tbl_primary._full,
	.btn_tbl_border._full {width:100%; margin:0;}
	.GridMain1 .GridMain2 .btn_tbl {display:inline-flex; justify-content:center; align-items:center; margin:0 2px; padding:5px 15px; font-size:14px; font-weight:400; color:#fff; border-radius:6px; background-color:#1A1915;}

	.css-arrow-multicolor {
		border-color: transparent black black transparent;
		border-style: solid;
		border-width: 20px;
		width: 0;
		height: 0;
	}

	.td_01{background-color: #dddfe5;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;}
	.td_02{background-color: #fff;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;}
	.td_02_last{background-color: #fff;border-bottom: #000000 solid 1px;}
	.td_03{background-color: #fff;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;padding-left: 3px; padding-right: 3px;}
	.td_03_last{background-color: #fff;border-bottom: #000000 solid 1px;padding-left: 3px; padding-right: 3px;}

	td {
		font-family: "돋움체", "굴림체", "Arial";
		font-size: 9pt;
		color: #000000;
		text-decoration: none;
	}
-->
</style>
<form name="printForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<input type="hidden" name="event" value="" />
<table width="750px" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr id="printId" height="30px">
		<td align="right" style="padding-right: 10px;">
			<button type="button" onclick="printPage();" class="btn_sm btn_primary">인쇄하기</button>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table style="width: 750px;">
				<tr height="30px">
					<td align="center" style="font-size: 16px;font-weight: bold;color: #ff0000;">필수서류 : 1. 인수증  2. 신분증  3. 명함   (대리수령가능)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="50px">
					<td align="center" style="font-size: 28px;font-weight: bold;">제 <c:out value="${awd0050t[0].bsnSeq}" />회 무역의 날 수상 인수증</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="30px">
					<td align="left" colspan="" style="padding-left: 5px;font-size: 16px;font-weight: bold;">□ 회 사 명 : <c:out value="${awd0050t[0].coNmKr}" /></td>
				</tr>
				<tr height="30px">
					<td align="left" style="padding-left: 5px;font-size: 16px;font-weight: bold;">□ 수상번호 : <c:out value="${awd0050t[0].priNo}" /></td>
					<c:choose>
						<c:when test="${awd0050t[0].priGbn eq '30'}">
							<td align="right" style="padding-left: 5px;font-size: 16px;font-weight: bold;">□ 추천기관 : <c:out value="${awd0050t[0].spRecOrg}" /></td>
						</c:when>
						<c:otherwise>
							<td align="right" style="padding-left: 5px;font-size: 16px;font-weight: bold;">□ 접수번호 : <c:out value="${awd0050t[0].receiptNo}" /></td>
						</c:otherwise>
					</c:choose>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="160px" />
					<col width="200px" />
					<col width="190px" />
					<col width="200px" />
				</colgroup>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수상내역</td>
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수상자</td>
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수상번호</td>
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수령처</td>
				</tr>
				<c:set var="defaultRow" value="0" />
				<c:forEach var="item" items="${awd0050t}" varStatus="status">
					<c:set var="defaultRow" value="${defaultRow + 1}" />
					<tr height="30px">
						<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${item.priCodeNm}" /></td>
						<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${item.pos}" /> <c:out value="${item.priUserNm}" /></td>
						<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${item.priNo}" /></td>
						<td align="left" class="td_02" style="font-weight: bold;">&nbsp;<c:out value="${item.receiveNm}" /></td>
					</tr>
				</c:forEach>
				<c:if test="${(4 - defaultRow) > 0}">
					<c:forEach begin="0" end="${4 - defaultRow}" step="1">
						<tr height="30px">
							<td align="center" class="td_02"></td>
							<td align="center" class="td_02"></td>
							<td align="center" class="td_02"></td>
							<td align="center" class="td_02"></td>
						</tr>
					</c:forEach>
				</c:if>
			</table>
			<table>
				<tr>
					<td height="25px"></td>
				</tr>
			</table>
			<table style="width: 750px;border-top: dotted 2px #000000;">
				<colgroup>
					<col width="250px" />
					<col width="250px" />
					<col width="250px" />
				</colgroup>
				<tr height="60px">
					<td align="left" style="padding-left: 5px;font-size: 15px;font-weight: bold;">수상번호 : <c:out value="${awd0050t[0].priNo}" /></td>
					<td align="center" style="font-size: 25px;font-weight: bold;">인 수 증</td>
					<c:choose>
						<c:when test="${awd0050t[0].priGbn eq '30'}">
							<td align="right" style="font-size: 15px;font-weight: bold;">추천기관 : <c:out value="${awd0050t[0].spRecOrg}" /></td>
						</c:when>
						<c:otherwise>
							<td align="right" style="font-size: 15px;font-weight: bold;">접수번호 : <c:out value="${awd0050t[0].receiptNo}" /></td>
						</c:otherwise>
					</c:choose>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="150px" />
					<col width="200px" />
					<col width="220px" />
					<col width="180px" />
				</colgroup>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">회 사 명</td>
					<td colspan="3" align="center" class="td_02" style="font-size: 15px;font-weight: bold;"><c:out value="${awd0050t[0].coNmKr}" /></td>
				</tr>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수령처</td>
					<td colspan="3" align="center" class="td_02" style="font-size: 15px;font-weight: bold;"><c:out value="${awd0050t[0].receiveNm}" /></td>
				</tr>
				<c:set var="defaultSpan" value="4" />
				<c:set var="defaultRow2" value="0" />
				<c:if test="${defaultSpan < fn:length(awd0050t)}">
					<c:set var="defaultSpan" value="${fn:length(awd0050t)}" />
				</c:if>
				<c:forEach var="row1" begin="0" end="${fn:length(awd0050t) - 1}" step="1">
					<c:set var="defaultRow2" value="${defaultRow2 + 1}" />
					<c:choose>
						<c:when test="${row1 eq 0}">
							<tr height="30px">
								<td rowspan="<c:out value="${defaultSpan}" />" align="center" class="td_01" style="font-size: 15px;font-weight: bold;">수상내용</td>
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].priCodeNm}" /></td>
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].pos}" /> <c:out value="${awd0050t[row1].priUserNm}" /></td>
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].priNo}" /></td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr height="30px">
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].priCodeNm}" /></td>
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].pos}" /> <c:out value="${awd0050t[row1].priUserNm}" /></td>
								<td align="center" class="td_02" style="font-weight: bold;"><c:out value="${awd0050t[row1].priNo}" /></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:if test="${(4 - defaultRow2) > 0}">
					<c:forEach var="row2" begin="1" end="${4 - defaultRow2}" step="1">
						<tr height="30px">
							<td align="center" class="td_02"></td>
							<td align="center" class="td_02"></td>
							<td align="center" class="td_02"></td>
						</tr>
					</c:forEach>
				</c:if>
				<tr height="30px">
					<td colspan="2" class="td_01" align="center" style="font-size: 15px;font-weight: bold;">인 수 자</td>
					<td rowspan="5" colspan="2" align="center" valign="middle" class="td_02" style="font-size: 15px;font-weight: bold;">명 함 부 착</td>
				</tr>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">직 위</td>
					<td align="center" class="td_02"></td>
				</tr>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">성 명</td>
					<td align="center" class="td_02"></td>
				</tr>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">생년월일</td>
					<td align="center" class="td_02"></td>
				</tr>
				<tr height="30px">
					<td align="center" class="td_01" style="font-size: 15px;font-weight: bold;">연락처</td>
					<td align="center" class="td_02"></td>
				</tr>
			</table>
			<table>
				<tr>
					<td height="25px"></td>
				</tr>
			</table>
			<c:if test="${fn:length(awd033) > 0}">
				<table style="width: 750px;">
					<tr height="25px">
						<td align="left" style="font-size: 16px;font-weight: bold;">
							<c:out value="${common:reverseXss(awd033[0].remark)}" escapeXml="false" />
						</td>
					</tr>
				</table>
			</c:if>
			<table style="width: 750px;">
				<tr>
					<td height="10px">&nbsp;</td>
				</tr>
				<tr height="30px">
					<td align="center" style="font-size: 16px;font-weight: bold;"><c:out value="${awd0050t[0].priDtNm}" /></td>
				</tr>
				<tr height="30px">
					<td align="center" style="font-size: 16px;font-weight: bold;">상기와 같이 수상품을 인수하였습니다.</td>
				</tr>
				<tr>
					<td height="25px">&nbsp;</td>
				</tr>
				<tr height="25px">
					<td align="center" style="font-size: 16px;font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수령인 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명)
					</td>
				</tr>
				<tr>
					<td height="25px">&nbsp;</td>
				</tr>
				<tr height="25px">
					<td align="center" style="font-size: 25px;font-weight: bold;">한국무역협회 귀중</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height="30px">
		<td></td>
	</tr>
</table>
</form>
<script type="text/javascript">
	function printPage() {
		document.getElementById('printId').style.display = 'none';

		window.print();

		document.getElementById('printId').style.display = '';
	}
</script>