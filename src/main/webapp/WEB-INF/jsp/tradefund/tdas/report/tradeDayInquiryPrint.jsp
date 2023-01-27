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

	.td_01 {background-color: #dddfe5;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;}
	.td_02 {background-color: #fff;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;}
	.td_02_last {background-color: #fff;border-bottom: #000000 solid 1px;}
	.td_03 {background-color: #fff;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;padding-left: 3px; padding-right: 3px;}
	.td_03_last {background-color: #fff;border-bottom: #000000 solid 1px;padding-left: 3px; padding-right: 3px;}

	table {
		padding: 0px;
		font-family: "dotum";
		font-size: 12px ;
		color: #404149;
		scroollbar: auto;
		border: 0;
		/* height:auto; */
	}

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
<table width="95%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr height="30px">
		<td align="right" style="padding-right: 10px;">
			<button type="button" id="printId" onclick="printPage();" class="btn_sm btn_primary">인쇄하기</button>
		</td>
	</tr>
	<tr>
		<td valign="top">
		<c:if test="${param.reportGb1 eq 'Y'}">
			<table style="width: 750px;">
				<tr>
					<td align="right" style="font-size: 30px;font-weight: bold;"><c:out value="${printVO.receiptNm}" /></td>
				</tr>
			</table>
			<table>
				<tr height="25px">
					<td>(별지 제1호 서식)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="60px">
					<td align="center" style="font-size: 20px;font-weight: bold;">수출업체종사자 포상신청서(A)</td>
				</tr>
			</table>
			<table>
				<tr height="5px"><td></td></tr>
			</table>
			<table style="width: 750px;">
				<tr>
					<td align="left">※ 작성대상 : <span style="font-weight: bold;">수출의 탑ㆍ개인포상 동시신청</span> 또는 <span style="font-weight: bold;">포상만 신청</span>하는 경우</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="30px" />
					<col width="100px" />
					<col width="120px" />
					<col width="50px" />
					<col width="250px" />
					<col width="50px" />
					<col width="150px" />
				</colgroup>
				<tr height="25px">
					<td rowspan="8" align="center" class="td_02">①<br />신<br />청<br />업<br />체</td>
					<td align="center" class="td_02">법인번호</td>
					<td align="left" class="td_03"><c:out value="${printVO.corpoNo}" /></td>
					<td rowspan="2" align="center" class="td_02">업체명</td>
					<td class="td_03">(한글) <c:out value="${printVO.coNmKr}" /></td>
					<td rowspan="2" align="center" class="td_03">대표자</td>
					<td class="td_03">(한글) <c:out value="${printVO.ceoKr}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">무역업고유번호</td>
					<td class="td_03"><c:out value="${printVO.memberId}" /></td>
					<td class="td_03">(한자) <c:out value="${common:reverseXss(printVO.coNmCh)}" escapeXml="false" /></td>
					<td class="td_03">(한자) <c:out value="${common:reverseXss(printVO.ceoNmCh)}" escapeXml="false" /></td>
				</tr>
				<tr height="25px">
					<td colspan="6" align="center" class="td_02">
						<table style="width: 100%;">
							<tr height="25px">
								<td width="60%" align="center" class="td_02">주 소(공장, 사무소 등 전사업장)</td>
								<td width="40%" align="center" class="td_02_last">산재보험관리번호(공장, 사무소 등 전사업장)</td>
							</tr>
							<c:choose>
								<c:when test="${empty indusNoList}">
									<tr height="25px">
										<td class="td_02">1)</td>
										<td class="td_02_last">→</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="item" items="${indusNoList}" varStatus="status">
										<tr height="25px">
											<td class="td_03"><c:out value="${status.index + 1}" />) (<c:out value="${item.officeNm}" />) <c:out value="${item.addr}" /></td>
											<td class="td_03_last">→<c:out value="${item.indusNo1}" />-<c:out value="${item.indusNo2}" /></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</table>
					</td>
				</tr>
				<tr height="45px">
					<td align="center" class="td_02">업체구분</td>
					<td colspan="5" class="td_03" style="">
						* 업체규모 : 대기업(<c:out value="${scaleGb}" />), 중견기업(<c:out value="${scaleGb6}" />), 중소기업(<c:out value="${scaleGb2}" />), 본사지방소재(<c:out value="${scaleGb3}" />),<br />
						* 상장여부 : <c:out value="${stockMsg}" /><br />
						* 업종구분 : <c:out value="${upMsg}" /><br />
						* 특이사항(중복가능) : 소비재(<c:out value="${scaleGb12}" />), 전자상거래 활용(<c:out value="${scaleGb13}" />), 수출국 다변화(<c:out value="${scaleGb14}" />), 무역일자리 창출(<c:out value="${worknewNm}" />)<br />
						- 고용증가 근로자 수 : <c:out value="${pyear.ppyear}" />년 12월말 근로자수 – <c:out value="${pyear.pyear}" />년 12월말 근로자수, 단 근로자는 고용보험 가입자로서 1년 미만 계약을 체결한 근로자 및 근로기준법 상의 단시간 근로자가 아닐 것
					</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">포상신청</td>
					<td colspan="5" class="td_03">수출의 탑(<c:out value="${priTypeGb}" />), 포상(<c:out value="${priTypeGb2}" />)</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">신청탑종류</td>
					<td colspan="5" class="td_03">(<c:out value="${printVO.expTapPrizeNm}" />) 탑 <!-- ※ 예) (100만불)탑 --> * 탑업체명 : <c:out value="${printVO.tapCoNmKr}" /></td>
				</tr>
				<tr height="25px">
					<td colspan="6" class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="100px" style="width: 78px;">담당자 성명 : </td>
								<td width="100px"><c:out value="${printVO.userNm}" /></td>
								<td width="80px" style="width: 30px;">TEL : </td>
								<td width="100px"><c:out value="${printVO.userPhone}" /></td>
								<td width="80px" style="width: 33px;">HP : </td>
								<td width="100px"><c:out value="${printVO.userHp}" /></td>
								<td style="width: 50px;">E-Mail : </td>
								<td width="*"><c:out value="${printVO.userEmail}" /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td colspan="6" class="td_03">
						<table>
							<tr>
								<td style="width: 78px;">주거래 은행 : </td>
								<td style="width: 101px;"><c:out value="${printVO.mainBankCd}" /></td>
								<td style="width: 36px;">지점 : </td>
								<td style="width: 96px;"><c:out value="${printVO.mainBankbranchNm}" /></td>
								<td style="width: 48px;">담당자 :</td>
								<td style="width: 92px;"><c:out value="${printVO.mainBankWrkNm}" /></td>
								<td style="width: 32px;">TEL :</td>
								<td style="width: 91px;"><c:out value="${printVO.mainBankPhone}" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="30px" />
					<col width="120px" />
					<col width="120px" />
					<col width="120px" />
					<col width="120px" />
					<col width="70px" />
					<col width="200px" />
				</colgroup>
				<tr height="50px">
					<td rowspan="4" align="center" class="td_02">②<br />수<br />출<br />실<br />적</td>
					<td align="center" class="td_02">구 분</td>
					<td align="center" class="td_02">전전년도(A)<br /><c:out value="${printVO.twoDayStart}" /> ~<br /> <c:out value="${printVO.twoDayEnd}" /></td>
					<td align="center" class="td_02">전년도(B)<br /><c:out value="${printVO.pastDayStart}" /> ~<br /> <c:out value="${printVO.pastDayEnd}" /></td>
					<td align="center" class="td_02">당해년도(C)<br /><c:out value="${printVO.custDayStart}" /> ~<br /> <c:out value="${printVO.custDayEnd}" /></td>
					<td align="center" class="td_02">최근 3년간<br />평균신장율</td>
					<td align="center" class="td_02">당해년도 주종<br />수출품목(금액순)</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">직수출(A)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.twoDrExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.pastDrExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.currDrExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.drExpAmtRate}" /></td>
								<td width="20%">%</td>
							</tr>
						</table>
					</td>
					<td rowspan="4" class="td_02">
						<table style="width: 100%;">
							<tr height="25px">
								<td style="padding-left: 3px;">1) HS: <c:out value="${printVO.exptemHscode1}" /></td>
							</tr>
							<tr height="25px">
								<td style="padding-left: 3px;">품명: <c:out value="${printVO.expItemNm1}" /></td>
							</tr>
							<tr height="25px">
								<td style="padding-left: 3px;">2) HS: <c:out value="${printVO.expItemHscode2}" /></td>
							</tr>
							<tr height="25px">
								<td style="padding-left: 3px;">품명: <c:out value="${printVO.expItemNm2}" /></td>
							</tr>
							<tr height="25px">
								<td style="padding-left: 3px;">※ HS는 10단위기준</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">로컬등기타수출(B)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.twoLcExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.pastLcExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.currLcExpAmt}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.lcExpAmtRate}" /></td>
								<td width="20%">%</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">합계(A+B)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.twoExpAmtSum}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.pastExpAmtSum}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.currExpAmtSum}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.expIncrsRate}" /></td>
								<td width="20%">%</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td colspan="2" class="td_03">③수입실적</td>
					<td id="line_01" class="td_02"></td>
					<td id="line_01" class="td_02"></td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.impSiljukSum}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td class="td_02"></td>
				</tr>
				<tr height="25px">
					<td colspan="2" class="td_03">④무역수지(당해년도)</td>
					<td colspan="5" class="td_03">금액 <c:out value="${printVO.tradeIndex}" /> 천불, 외화가득율 (1※- 2※/ 1※) : <c:out value="${printVO.tradeIndexImprvRate}" /> %</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="90px" />
					<col width="90px" />
					<col width="*" />
					<col width="230px" />
				</colgroup>
				<tr height="25px">
					<td rowspan="2" align="center" class="td_02">⑤시장개척<br />(당해년도)</td>
					<td align="center" class="td_02">5대시장</td>
					<td class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="50%" align="center"><c:out value="${printVO.dvlpExploAmtSum}" /> 천불</td>
								<td width="50%">비중: <c:out value="${printVO.dvlpExploAmtPor}" /> %</td>
							</tr>
						</table>
					</td>
					<td class="td_03">※ 중국, 미국, 일본, 홍콩, 베트남</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">기타시장</td>
					<td class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="50%" align="center"><c:out value="${printVO.newMktExploAmtSum}" /> 천불</td>
								<td width="50%">비중: <c:out value="${printVO.newMktExploAmtPor}" /> %</td>
							</tr>
						</table>
					</td>
					<td class="td_03">※ 5대 시장을 제외한 전지역</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="30px" />
					<col width="150px" />
					<col width="130px" />
					<col width="130px" />
					<col width="*" />
				</colgroup>
				<tr height="25px">
					<td rowspan="4" align="center" class="td_02">⑥<br />기<br />술<br />개<br />발</td>
					<td align="center" class="td_02">신기술개발</td>
					<td colspan="2" align="left" class="td_03">품목명 : <c:out value="${printVO.newTechItemNm}" /></td>
					<td align="left" class="td_03">인정기관 : <c:out value="${printVO.newTechTerm}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">정부기술개발참여</td>
					<td colspan="2" align="left" class="td_03">사업명 : <c:out value="${printVO.govTechNm}" /></td>
					<td align="left" class="td_03">시행기관 : <c:out value="${printVO.govTechInst}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">수입대체상품생산</td>
					<td colspan="2" align="left" class="td_03">품목수 : <c:out value="${printVO.impReplItemCnt}" /></td>
					<td align="left" class="td_03">품목명 : <c:out value="${printVO.impReplItemNm}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">자기상표제품수출</td>
					<td align="left" class="td_03">상표수 : <c:out value="${printVO.selfBrandExpCnt}" /></td>
					<td align="left" class="td_03">품목수 : <c:out value="${printVO.selfBrandExpItemCnt}" /></td>
					<td align="left" class="td_03">상표명 : <c:out value="${printVO.selfBrandExpItemNm}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="100px" />
					<col width="80px" />
					<col width="80px" />
					<col width="130px" />
					<col width="80px" />
					<col width="80px" />
					<col width="180px" />
					<col width="100px" />
				</colgroup>
				<tr height="25px">
					<td colspan="8" align="center" class="td_02">⑦ 유 공 자</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">추 천 자</td>
					<td align="center" class="td_02">성 명</td>
					<td align="center" class="td_02">직 위</td>
					<td align="center" class="td_02">주민등록번호</td>
					<td colspan="2" align="center" class="td_02">근무기간(현 재직회사)</td>
					<td align="center" class="td_02">과거포상기록</td>
					<td align="center" class="td_02">소속사업장</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">대표자</td>
					<td align="left" class="td_03"><c:out value="${printVO.ceoUserNmKor}" /></td>
					<td align="left" class="td_03"><c:out value="${printVO.ceoPos}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.ceoJuminNo}" /></td>
					<td align="right" class="td_02"><c:out value="${printVO.ceoCurwrkTermYy}" /> 년</td>
					<td align="right" class="td_02"><c:out value="${printVO.ceoCurwrkTermMm}" /> 개월</td>
					<td align="left" class="td_03"><c:out value="${printVO.ceoHistory}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.ceoDeptPosPlace}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">종업원(사무직)</td>
					<td align="left" class="td_03"><c:out value="${printVO.empUserNmKor}" /></td>
					<td align="left" class="td_03"><c:out value="${printVO.empPos}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.empJuminNo}" /></td>
					<td align="right" class="td_02"><c:out value="${printVO.empCurwrkTermYy}" /> 년</td>
					<td align="right" class="td_02"><c:out value="${printVO.empCurwrkTermMm}" /> 개월</td>
					<td align="left" class="td_03"><c:out value="${printVO.empHistory}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.empDeptPosPlace}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">종업원(생산직)</td>
					<td align="left" class="td_03"><c:out value="${printVO.workUserNmKor}" /></td>
					<td align="left" class="td_03"><c:out value="${printVO.workPos}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.workJuminNo}" /></td>
					<td align="right" class="td_02"><c:out value="${printVO.workCurwrkTermYy}" /> 년</td>
					<td align="right" class="td_02"><c:out value="${printVO.workCurwrkTermMm}" /> 개월</td>
					<td align="left" class="td_03"><c:out value="${printVO.workHistory}" /></td>
					<td align="center" class="td_02"><c:out value="${printVO.workDeptPosPlace}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px">
					<td style="font-size: 15px;"><c:out value="${title}" /> 공고 <c:out value="${titleGb}" />에 의하여 위와 같이 신청합니다</td>
				</tr>
				<tr height="25px">
					<td align="right" style="padding-right: 100px;"><c:out value="${printVO.toDay}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" style="padding-left: 400px;font-size: 15px;font-weight: bold;">회사명 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:out value="${printVO.coNmKr}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" style="padding-left: 390px;font-size: 15px;font-weight: bold;">
						대표자 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:out value="${printVO.ceoKr}" />
						<c:choose>
							<c:when test="${empty printVO.certFileId}">
								(인)
							</c:when>
							<c:otherwise>
								<img src="<c:url value="/common/util/tradefundImageDownload.do" />?fileId=<c:out value="${printVO.certFileId}" />&fileNo=<c:out value="${printVO.certFileNo}" />" style="width: 80px;height: 80px;" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="30px"><td></td></tr>
			</table>
			<table style="width:750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;border-bottom: #000000 solid 1px;">
				<tr height="30px">
					<td style="font-size: 18px;font-weight: bold;"><c:out value="${title}" />장관 귀하</td>
				</tr>
				<tr height="35px">
					<td></td>
				</tr>
			</table>
		</c:if>
		<c:if test="${param.reportGb4 eq 'Y'}">
			<c:if test="${param.reportGb1 eq 'Y'}">
				<p style="page-break-before: always;"/>
			</c:if>
			<table style="width: 750px;">
				<tr>
					<td align="right" style="font-size: 30px;font-weight: bold;"><c:out value="${printVO.receiptNm}" /></td>
				</tr>
			</table>
			<table>
				<tr height="25px">
					<td>(별지 제2호 서식)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="60px">
					<td align="center" style="font-size: 25px;font-weight: bold;">「수출의 탑」 신청서(B)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr>
					<td align="left">※ 작성대상 : <span style="font-weight: bold;">수출의 탑만 신청</span> 하는 경우</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="30px" />
					<col width="100px" />
					<col width="120px" />
					<col width="50px" />
					<col width="250px" />
					<col width="50px" />
					<col width="150px" />
				</colgroup>
				<tr height="25px">
					<td rowspan="10" align="center" class="td_02">①<br />신<br />청<br />업<br />체</td>
					<td align="center" class="td_02">법인번호</td>
					<td class="td_03"><c:out value="${printVO.corpoNo}" /></td>
					<td rowspan="2" align="center" class="td_02">업체명</td>
					<td class="td_03">(한글) <c:out value="${printVO.coNmKr}" /></td>
					<td rowspan="2" align="center" class="td_02">대표자</td>
					<td class="td_03">(한글) <c:out value="${printVO.ceoKr}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">무역업고유번호</td>
					<td class="td_03"><c:out value="${printVO.memberId}" /></td>
					<td class="td_03">(한자) <c:out value="${common:reverseXss(printVO.coNmCh)}" escapeXml="false" /></td>
					<td class="td_03">(한자) <c:out value="${common:reverseXss(printVO.ceoNmCh)}" escapeXml="false" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">주소</td>
					<td colspan="5" class="td_03">본사 : <c:out value="${printVO.coAddr1}" /> <c:out value="${printVO.coAddr2}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">신청탑종류</td>
					<td colspan="5" class="td_03">(<c:out value="${printVO.expTapPrizeNm}" />) 탑 * 탑업체명 : <c:out value="${printVO.tapCoNmKr}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">업체구분</td>
					<td colspan="5" class="td_03">대기업(<c:out value="${scaleGb}" />), 중견기업(<c:out value="${scaleGb6}" />), 중소기업(<c:out value="${scaleGb2}" />)</td>
				</tr>
				<tr height="50px">
					<td align="center" class="td_02">특이사항<br />(중복가능)</td>
					<td colspan="5" class="td_03">
						소비재(<c:out value="${scaleGb12}" />), 전자상거래 활용(<c:out value="${scaleGb13}" />), 수출국 다변화(<c:out value="${scaleGb14}" />), 무역일자리 창출(<c:out value="${worknewNm}" />)
						<br />
						- 고용증가 근로자 수 : <c:out value="${pyear.ppyear}" />년 12월말 근로자수 – <c:out value="${pyear.pyear}" />년 12월말 근로자수, 단 근로자는 고용보험 가입자로서 1년 미만 계약을 체결한 근로자 및 근로기준법 상의 단시간 근로자가 아닐 것
					</td>
				</tr>
				<tr height="25px">
					<td rowspan="2" align="center" class="td_02">담당자</td>
					<td colspan="5" class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="10%">성명 : </td>
								<td width="20%"><c:out value="${printVO.userNm}" /></td>
								<td width="10%">Tel :</td>
								<td width="20%"><c:out value="${printVO.userPhone}" /></td>
								<td width="10%">핸드폰 :</td>
								<td width="20%"><c:out value="${printVO.userHp}" /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td colspan="5" class="td_03">E-Mail : <c:out value="${printVO.userEmail}" /></td>
				</tr>
				<tr height="25px">
					<td colspan="6" class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="100px" style="width: 78px;">주거래은행 : </td>
								<td width="100px"><c:out value="${printVO.mainBankCd}" /></td>
								<td width="80px"><c:out value="${printVO.mainBankbranchNm}" /></td>
								<td width="100px">지점</td>
								<td width="80px">담당자 : </td>
								<td width="100px"><c:out value="${printVO.mainBankWrkNm}" /></td>
								<td style="width: 50px;">전화 : </td>
								<td width="*" class="phoneNum"><c:out value="${printVO.mainBankPhone}" /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td colspan="6" class="td_03">산재보험관리번호 : <c:out value="${indusNoList[0].indusNo1}" />-<c:out value="${indusNoList[0].indusNo2}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="30px" />
					<col width="120px" />
					<col width="120px" />
					<col width="120px" />
					<col width="120px" />
					<col width="70px" />
					<col width="200px" />
				</colgroup>
				<tr height="50px">
					<td rowspan="4" align="center" class="td_02">②<br />수<br />출<br />실<br />적</td>
					<td align="center" class="td_02">구 분</td>
					<td align="center" class="td_02">전전년도(A)<br /><c:out value="${printVO.twoDayStart}" /><br />~<c:out value="${printVO.twoDayEnd}" /></td>
					<td align="center" class="td_02">전년도(B)<br /><c:out value="${printVO.pastDayStart}" /><br />~<c:out value="${printVO.pastDayEnd}" /></td>
					<td align="center" class="td_02">당해년도(C)<br /><c:out value="${printVO.custDayStart}" /><br />~<c:out value="${printVO.custDayEnd}" /></td>
					<td align="center" class="td_02">최근 3년간<br />평균신장율</td>
					<td align="center" class="td_02">당해년도 주종<br />수출품목(금액순)</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">직수출(A)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.twoDrExpAmtP}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.pastDrExpAmtP}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.currDrExpAmtP}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.drExpAmtRate}" /></td>
								<td width="20%">%</td>
							</tr>
						</table>
					</td>
					<td rowspan="4" class="td_02">
						<table style="width: 100%;">
							<tr height="25px">
								<td>1) HS: <c:out value="${printVO.expItemHscode1}" /></td>
							</tr>
							<tr height="25px">
								<td>품명: <c:out value="${printVO.expItemNm1}" /></td>
							</tr>
							<tr height="25px">
								<td>2) HS: <c:out value="${printVO.expItemHscode2}" /></td>
							</tr>
							<tr height="25px">
								<td>품명: <c:out value="${printVO.expItemNm2}" /></td>
							</tr>
							<tr height="25px">
								<td>※ HS는 10단위기준</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">로컬등기타수출(B)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.twoLcExpAmt}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.pastLcExpAmt}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr height="25px">
								<td align="right"><c:out value="${printVO.currLcExpAmt}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.lcExpAmtRate}" /></td>
								<td width="20%"> %</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">합계(A+B)</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td align="right"><c:out value="${printVO.twoExpAmtSum}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td align="right"><c:out value="${printVO.pastExpAmtSum}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td align="right"><c:out value="${printVO.currExpAmtSum}" /> 천불</td>
							</tr>
						</table>
					</td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="80%" align="right" style="padding-right: 3px;"><c:out value="${printVO.expIncrsRate}" /></td>
								<td width="20%">%</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td colspan="2" class="td_03">③수입실적</td>
					<td id="line_01" class="td_02"></td>
					<td id="line_01" class="td_02"></td>
					<td align="right" class="td_02">
						<table style="width: 95%;">
							<tr>
								<td width="60%" align="right" style="padding-right: 3px;"><c:out value="${printVO.impSiljukSum}" /></td>
								<td width="40%" align="left">천불</td>
							</tr>
						</table>
					</td>
					<td class="td_02"></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px; border-right : #000000 solid 1px; border-bottom: #000000 solid 1px;">
				<tr height="25px">
					<td>④ 공적사항(500자 이상) : 붙임으로도 가능</td>
				</tr>
				<tr height="25px">
					<td>
						1) 기본사항<br />
						<c:out value="${fn:replace(printVO.kongjukItem1, cn, '<br />')}" escapeXml="false" />
						<br />
						<br />
						2) 수출실적<br />
						<c:out value="${fn:replace(printVO.kongjukItem2, cn, '<br />')}" escapeXml="false" />
						<br />
						<br />
						3) 해외시장 개척활동<br />
						<c:out value="${fn:replace(printVO.kongjukItem4, cn, '<br />')}" escapeXml="false" />
						<br />
						<br />
						4) 기술개발 및 품질향상 노력<br />
						<c:out value="${fn:replace(printVO.kongjukItem3, cn, '<br />')}" escapeXml="false" />
						<br />
						<br />
						<c:if test="${not empty printVO.kongjukEtc}">
							5) 기타 공적내용<br />
							<c:out value="${fn:replace(printVO.kongjukEtc, cn, '<br />')}" escapeXml="false" />
						</c:if>
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px">
					<td style="font-size: 15px;"><c:out value="${title}" /> 공고 <c:out value="${titleGb}" />에 의하여 위와 같이 신청합니다</td>
				</tr>
				<tr height="25px">
					<td align="right" style="padding-right: 100px;"><c:out value="${printVO.toDay}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" style="padding-left: 400px;font-size: 18px;font-weight: bold;">회사명 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:out value="${printVO.coNmKr}" /></td>
				</tr>
				<tr height="25px">
					<td align="center" style="padding-left: 400px;font-size: 18px;font-weight: bold;">
						대표자 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:out value="${printVO.ceoKr}" />
						<c:choose>
							<c:when test="${empty printVO.certFileId}">
								(인)
							</c:when>
							<c:otherwise>
								<img src="<c:url value="/common/util/tradefundImageDownload.do" />?fileId=<c:out value="${printVO.certFileId}" />&fileNo=<c:out value="${printVO.certFileNo}" />" style="width: 80px;height: 80px;" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="30px"><td></td></tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;border-bottom: #000000 solid 1px;">
				<tr height="30px">
					<td style="font-size: 20px;font-weight: bold;"><c:out value="${title}" />장관 귀하</td>
				</tr>
				<tr height="35px">
					<td style=""></td>
				</tr>
			</table>
		</c:if>
		<c:if test="${param.reportGb2 eq 'Y'}">
			<c:forEach var="item" items="${awd0020T}" varStatus="status">
				<c:if test="${item.prvPriType ne '10'}">
					<c:if test="${param.reportGb1 eq 'Y' or param.reportGb4 eq 'Y'}">
						<p style="page-break-before: always;" />
					</c:if>
			<table>
				<tr height="25px">
					<td>(별지 제3호 서식)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="60px">
					<td align="center" style="font-size: 20px;font-weight: bold;">공 적 조 서</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr>
					<td align="left">※ 빗금부분은 기재하지 마십시오.</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="100px" />
					<col width="400px" />
					<col width="350px" />
				</colgroup>
				<tr height="35px">
					<td class="td_03">(1) 성 명</td>
					<td colspan="2" class="td_03">
						<table style="width: 100%;">
							<tr>
								<td width="50%">(한글) <c:out value="${item.userNmKor}" /></td>
								<td width="50%">(한자) <c:out value="${common:reverseXss(item.userNmCh)}" escapeXml="false" /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td rowspan="2" class="td_03">(2) 주민등록<br />&nbsp;&nbsp;&nbsp;번 &nbsp;&nbsp;&nbsp;호<br />&nbsp;(생년월일)</td>
					<td align="center" class="td_02"><c:out value="${item.juminNoDis}" /></td>
					<td class="td_03">(3) 군번(군인의 경우)</td>
				</tr>
				<c:set var="birthDay1" value="" />
				<c:set var="birthDay2" value="" />
				<c:set var="birthDay3" value="" />
				<c:if test="${fn:length(fn:split(item.birthday, '-')) == 3}">
					<c:set var="birthDay1" value="${fn:split(item.birthday, '-')[0]}" />
					<c:set var="birthDay2" value="${fn:split(item.birthday, '-')[1]}" />
					<c:set var="birthDay3" value="${fn:split(item.birthday, '-')[2]}" />
				</c:if>
				<tr height="35px">
					<td align="center" class="td_02"><c:out value="${birthDay1}" />년 <c:out value="${birthDay2}" />월 <c:out value="${birthDay3}" />일</td>
					<td align="center" class="td_02">해당없음</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(4) 국 적</td>
					<td colspan="2" class="td_03"><c:out value="${item.bonjuk}" /></td>
				</tr>
				<tr height="35px">
					<td class="td_03">(5) 주 소</td>
					<td colspan="2" class="td_03"><c:out value="${item.zipCd}" /> <c:out value="${item.addr1}" /> <c:out value="${item.addr2}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="250px" />
					<col width="250px" />
					<col width="125px" />
					<col width="125px" />
				</colgroup>
				<tr height="35px">
					<td class="td_03">(6) 직 업</td>
					<td class="td_03">(7) 소 속</td>
					<td colspan="2" class="td_03">(8) 소속사업장 산재보험관리번호</td>
				</tr>
				<tr height="35px">
					<td class="td_03"><c:out value="${item.job}" /></td>
					<td class="td_03"><c:out value="${item.deptPos}" /></td>
					<td colspan="2" class="td_03"><c:out value="${item.deptPosPlace}" /></td>
				</tr>
				<tr height="50px">
					<td class="td_03">(9) 직 위</td>
					<td class="td_03">(10) 등 급(직급ㆍ계급)</td>
					<td class="td_03">(11) 동종업체 <br /> &nbsp;&nbsp;&nbsp;총 수공기간</td>
					<td class="td_03">(12) 현 소속 <br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무기간</td>
				</tr>
				<tr height="35px">
					<td class="td_03"><c:out value="${item.pos}" /></td>
					<td class="td_03"><c:out value="${item.rank}" /></td>
					<td align="center" class="td_03"><c:out value="${item.wrkTermYy}" />년 <c:out value="${item.wrkTermMm}" />개월</td>
					<td align="center" class="td_03"><c:out value="${item.curwrkTermYy}" />년 <c:out value="${item.curwrkTermMm}" />개월</td>
				</tr>
				<tr height="35px">
					<td colspan="4" style="border-right: #000000 solid 1px;">(13) 공적요지(50자 이상 100자이내)</td>
				</tr>
				<tr height="35px">
					<td colspan="4" class="" style="border-right: #000000 solid 1px;">*(31) 공적사항을 요약</td>
				</tr>
				<tr height="105px">
					<td colspan="4" class="td_03">
						<c:out value="${item.kongjukSum}" />
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="100px" />
					<col width="350px" />
					<col width="100px" />
					<col width="200px" />
				</colgroup>
				<tr height="35px">
					<td class="td_01">(14) 추천훈격</td>
					<td class="td_01"></td>
					<td class="td_01">(15) 추천순위</td>
					<td class="td_01"></td>
				</tr>
				<tr height="35px">
					<td colspan="4" align="center" class="td_01">조 사 자</td>
				</tr>
				<tr height="35px">
					<td class="td_01">(16) 소 속</td>
					<td class="td_01"></td>
					<td class="td_01">(17) 직 위</td>
					<td class="td_01"></td>
				</tr>
				<tr height="35px">
					<td class="td_01">(18) 직 급</td>
					<td class="td_01"></td>
					<td class="td_01">(19) 성 명</td>
					<td align="right" class="td_01">(인)</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px">
					<td style="padding-left: 60px;font-size: 15px;">위의 기록이 틀림없음을 확인함</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px">
					<td style="padding-left: 400px;font-size:15px;"><c:out value="${printVO.toDay}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-bottom: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px">
					<td style="padding-left: 30px;font-size: 20px;font-weight: bold;">추 천 관</td>
				</tr>
				<tr height="30px">
					<td>&nbsp;</td>
				</tr>
			</table>
			<p style="page-break-before: always;" />
			<table style="width: 750px;">
				<tr height="25px">
					<td>(별지 제3호 서식)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="25px">
					<td></td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px; border-bottom: #000000 solid 1px;">
				<colgroup>
					<col width="150px" />
					<col width="225px" />
					<col width="150px" />
					<col width="225px" />
				</colgroup>
				<tr height="35px">
					<td colspan="4" align="center" class="td_02" style="font-weight: bold;">국가연구개발 사업 참여제재 여부(해당사항 있는 경우 반드시 기재)</td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">(20) 제재시작일</td>
					<td align="center" class="td_02">(21) 제재종료일</td>
					<td colspan="2" align="center" class="td_02">(22) 제재사유</td>
				</tr>
				<c:set var="item4Count" value="0" />
				<c:forEach var="item4" items="${awd0021T}" varStatus="status4">
					<c:if test="${item.prvPriType eq item4.prvPriType and item4.type eq '30001'}">
						<c:set var="item4Count" value="${item4Count + 1}" />
						<tr height="35px">
							<td align="center" class="td_02"><c:out value="${item4.historyDt}" /></td>
							<td align="center" class="td_02"><c:out value="${item4.historyToDt}" /></td>
							<td colspan="2" class="td_03"><c:out value="${item4.history}" /></td>
						</tr>
					</c:if>
				</c:forEach>
				<c:if test="${item4Count eq 0}">
					<tr height="35px">
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
						<td colspan="2" class="td_03">&nbsp;</td>
					</tr>
				</c:if>
				<tr height="35px">
					<td colspan="4" align="center" class="td_02" style="font-weight: bold;">주요경력(민간 및 군사 학력과 경력)</td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">(23) 년 월 일</td>
					<td align="center" class="td_02">(24) 이 력</td>
					<td align="center" class="td_02">(25) 년 월 일</td>
					<td align="center" class="td_02">(26) 이 력</td>
				</tr>
				<c:set var="item1Count" value="0" />
				<c:set var="item1Idx" value="0" />
				<c:set var="item1Mod" value="0" />
				<c:forEach var="item1" items="${awd0021T}" varStatus="status1">
					<c:if test="${item.prvPriType eq item1.prvPriType and (item1.type eq '10001' or item1.type eq '10002')}">
						<c:set var="item1Count" value="${item1Count + 1}" />
						<c:set var="item1Mod" value="${item1Idx % 2}" />
						<c:if test="${item1Mod eq 0}">
							<tr height="35px">
						</c:if>
						<td align="center" class="td_03"><c:out value="${item1.historyDt}" />~<c:out value="${item1.historyToDt}" /></td>
						<td class="td_03"><c:out value="${item1.history}" /></td>
						<c:if test="${item1Mod eq 1}">
							</tr>
						</c:if>
						<c:set var="item1Idx" value="${item1Idx + 1}" />
					</c:if>
				</c:forEach>
				<c:if test="${item1Count ne 0}">
					<c:forEach begin="${item1Mod + 1}" end="1" step="1">
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
					</c:forEach>
					<c:if test="${item1Mod eq 0 or item1Mod eq 1}">
						</tr>
					</c:if>
				</c:if>
				<c:if test="${item1Count eq 0}">
					<tr height="35px">
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
					</tr>
				</c:if>
				<tr height="35px">
					<td colspan="4" align="center" class="td_02" style="font-weight: bold;">과거 포상기록(훈장ㆍ포장ㆍ표창별로 기록)</td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">(27) 년 월 일</td>
					<td align="center" class="td_02">(28) 내 용</td>
					<td align="center" class="td_02">(29) 년 월 일</td>
					<td align="center" class="td_02">(30) 내 용</td>
				</tr>
				<c:set var="item2Count" value="0" />
				<c:set var="item2Idx" value="0" />
				<c:set var="item2Mod" value="0" />
				<c:forEach var="item2" items="${awd0021T}" varStatus="status2">
					<c:if test="${item.prvPriType eq item2.prvPriType and item2.type eq '20001'}">
						<c:set var="item2Count" value="${item2Count + 1}" />
						<c:set var="item2Mod" value="${item2Idx % 2}" />
						<c:if test="${item2Mod eq 0}">
							<tr height="35px">
						</c:if>
						<td align="center" class="td_03"><c:out value="${item2.historyDt}" />~<c:out value="${item2.historyToDt}" /></td>
						<td class="td_03"><c:out value="${item2.history}" /></td>
						<c:if test="${item2Mod eq 1}">
							</tr>
						</c:if>
						<c:set var="item2Idx" value="${item2Idx + 1}" />
					</c:if>
				</c:forEach>
				<c:if test="${item2Count ne 0}">
					<c:forEach begin="${item2Mod + 1}" end="1" step="1">
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
					</c:forEach>
					<c:if test="${item2Mod eq 0 or item2Mod eq 1}">
						</tr>
					</c:if>
				</c:if>
				<c:if test="${item2Count eq 0}">
					<tr height="35px">
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
						<td class="td_03">&nbsp;</td>
					</tr>
				</c:if>
				<tr height="35px">
					<td colspan="4" align="center" class="td_02">(31) 공 적 사 항</td>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 5px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;border-right: #000000 solid 1px;">
					<c:choose>
						<c:when test="${item.prvPriType eq '21'}">
							1) 기본사항<br />
							<c:out value="${fn:replace(item.kongjuk1Item1, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							2) 수출실적<br />
							<c:out value="${fn:replace(item.kongjuk1Item2, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							3) 기술개발 및 품질향상 노력<br />
							<c:out value="${fn:replace(item.kongjuk1Item3, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							4) 해외시장 개척등<br />
							<c:out value="${fn:replace(item.kongjuk1Item4, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							5) 기타공적<br />
							<c:out value="${fn:replace(item.kongjuk1Etc, cn, '<br />')}" escapeXml="false" />
						</c:when>
						<c:otherwise>
							1) 기본사항<br />
							<c:out value="${fn:replace(item.kongjuk2Item1, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							2) 기여도<br />
							<c:out value="${fn:replace(item.kongjuk2Item2, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							3) 수상등 공적내용<br />
							<c:out value="${fn:replace(item.kongjuk2Item3, cn, '<br />')}" escapeXml="false" />
							<br />
							<br />
							4) 기타공적<br />
							<c:out value="${fn:replace(item.kongjuk2Etc, cn, '<br />')}" escapeXml="false" />
						</c:otherwise>
					</c:choose>
					</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="25px">
					<td style="font-weight: bold;">※ 기재요령(수출의 탑만 신청하는 업체는 작성할 필요 없음)</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 20px;"><span style="font-weight: bold;">* 외국인의 경우</span> 국문공적조서와 함께 <span style="font-weight: bold;">영문공적조서</span>를 반드시 제출</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">(13) <span style="font-weight: bold;">공적요지</span>는 (31)공적사항의 요약으로 반드시 50자 이상 100자 내외로 작성</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">(23)~(26) <span style="font-weight: bold;">학력</span>은 최종학력을 기준으로 2이상 기재하며, <span style="font-weight: bold;">경력</span>은 최초입사(개인의 全경력 중)년월을 포함하여 주요경력 기재</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">(27)~(30) <span style="font-weight: bold;">과거포상기록</span>은 총리이상(훈ㆍ포장, 대통령표창, 국무총리표창) 정부포상 수상사실만 기재</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">(31) <span style="font-weight: bold;">공적사항</span>에는 다음항목을 순서에 따라 서술적으로 작성(※  A4용지 4매 이상-5매 이내)</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 30px;">가. 대표자 ①회사설립년도 ②자본금 ③종업원수 ④해외지사 ⑤매출액 ⑥복지시설을 항목별로 작성</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 95px;">⑦최근 3년간 연도별 수출실적, 당해연도 지역별ㆍ품목별 수출실적을 상세히 기록</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 95px;">⑧기술개발, 시장개척, 품질향상 등을 위한 노력등을 기재</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 30px;">나. 종업원 ①근무년수, 해외근무경력, 회사내에서 생상성 향상 및 수출증대를 위한 기여도 ②사외표창수상 사실 등</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 100px;">개인공적을 상세히 기술하고 관련증빙자료 첨부(평가요소)</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">(별지 제3-1호 서식) - 신설 (별지 제3호 서식과 함께 제출) </td>
				</tr>
			</table>
			<p style="page-break-before: always;" />
			<table>
				<tr height="25px">
					<td>(별지 제3-1호 서식) - <span style="font-weight: bold;">(신설)</span></td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="60px">
					<td align="center" style="font-size: 20px;font-weight: bold;">공 적 사 항</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="170px" />
					<col width="580px" />
				</colgroup>
				<tr height="35px">
					<td class="td_03">(1)수공기간(근무기간)</td>
					<td class="td_03">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞ 수공기간을 고려하여 수행한 업무를 시간순으로 열거형식으로 작성</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj1, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(2)국가발전 기여도</td>
					<td class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞ 생산 제품, 기술 등을 고려하여 2~4개 항목으로 구분하여 작성</td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">- 대표자 : 기업 전체업무의 성과를 대상으로 작성</td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">- 근로자(근로자/생산직) : 기업 성과에 대한 기여를 내용으로 작성</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj2, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(3)국민생활 향상도</td>
					<td class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞ 노사관계, 인재육성, 생산제품의 국민생활 향상(편리제공,수입품대체등)에 미친 영향</td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">- 대표자 : 기업 전체업무의 성과를 대상으로 작성</td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">- 근로자(근로자/생산직) : 기업 성과에 대한 기여를 내용으로 작성</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj3, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(4)창조적 기여도</td>
					<td class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞ 무역진흥과 별도로 정부 정책에 동참(에너지절약, 동반성장, 상생협력등)한 내용 위주로 작성</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj4, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(5)무역진흥 기여도</td>
					<td class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞ 업태별(부품산업, 에너지산업 등)로 작성(특수유공은 분야별 공적을 고려하여 작성)</td>
							</tr>
							<tr>
								<td style="padding-left: 10px;">- 수출증대 노력에 따른 무역진흥에 대한 기여 내용</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj5, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
				<tr height="35px">
					<td class="td_03">(6)사회공헌 및 기타기여도</td>
					<td class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<table style="width: 100%;">
							<tr>
								<td>【작성지침】</td>
							</tr>
							<tr>
								<td style="padding-left: 5px;">☞  사회공헌 내용 및 기타 국가발전에 기여한 전반적인 내용을 작성</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td colspan="2" class="td_03" style="padding-top: 5px;padding-bottom: 5px;">
						<c:out value="${fn:replace(item.sanghunKj6, cn, '<br />')}" escapeXml="false" />
					</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="20px">
					<td style="font-weight: bold;">※ 기재요령 : 글자크기 아래한글 10포인트로 작성, 항목별 최소 200자 이상이어야 하며 공적사항 전체</td>
				</tr>
				<tr height="20px">
					<td style="font-weight: bold;padding-left: 93px;">내용은 최소 2,000자 이상(A4용지 4-5페이지)이어야 함.</td>
				</tr>
			</table>
				</c:if>
			</c:forEach>
		</c:if>
		<c:if test="${param.reportGb3 eq 'Y' or param.reportGb5 eq 'Y'}">
			<c:forEach var="item" items="${awd0020T}" varStatus="status">
				<c:choose>
					<c:when test="${param.reportGb1 eq 'Y' or param.reportGb2 eq 'Y' or param.reportGb4 eq 'Y'}">
						<p style="page-break-before: always;" />
					</c:when>
					<c:otherwise>
						<c:if test="${status.index gt 0}">
							<p style="page-break-before: always;" />
						</c:if>
					</c:otherwise>
				</c:choose>
			<table style="width: 750px;">
				<tr height="25px">
					<td width="130px">(별지 제7호 서식)</td>
					<td width="620px" style="text-decoration: underline;font-weight: bold;">* 최종학교 졸업부터 모든 경력(기간) 기재(최소 수공기간 요건 확인을 위함)</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="160px" />
					<col width="100px" />
					<col width="*" />
				</colgroup>
				<tr height="35px">
					<td rowspan="5" valign="middle" class="td_02">
						<c:if test="${not empty item.attPictId}">
							<img src="<c:url value="/common/util/tradefundImageDownload.do" />?fileId=<c:out value="${item.attPictId}" />&fileNo=<c:out value="${item.fileNo}" />" style="width: 160px;height: 190px;" />
						</c:if>
					</td>
					<td colspan="2" valign="middle" class="td_02">
						<table style="width: 100%;">
							<tr>
								<td width="380px" align="center" style="font-size: 25px;font-weight: bold;padding-left: 40px;">이 력 서</td>
								<td width="150px">※ 학력 기재시 입학 및 졸업 년원을 반드시 기재, 경력사항은 최초 산업체경력을 반드시 기재</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td rowspan="2" align="center" class="td_02">성 명</td>
					<td align="left" class="td_03">(한글) <c:out value="${item.userNmKor}" /></td>
				</tr>
				<tr height="35px">
					<td align="left" class="td_03">(한자) <c:out value="${common:reverseXss(item.userNmCh)}" escapeXml="false" /></td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">주민등록번호</td>
					<td align="center" class="td_03">
						<table style="width: 100%;height: 100%;">
							<tr>
								<td width="400px" style="border-right: #000000 solid 1px;">
									<c:choose>
										<c:when test="${item.fromYn eq 'N'}">
											<c:out value="${item.passportNo}" />
										</c:when>
										<c:otherwise>
											<c:out value="${item.juminNoDis}" />
										</c:otherwise>
									</c:choose>
								</td>
								<td width="50px" align="center" style="border-right: #000000 solid 1px;">연 령</td>
								<td width="80px" style="padding-left: 10px;">만 <c:out value="${item.age}" />세</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">현 근 무 처</td>
					<td align="left" class="td_03"><c:out value="${printVO.coNmKr}" /></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="160px" />
					<col width="*" />
					<col width="100px" />
					<col width="80px" />
					<col width="100px" />
				</colgroup>
				<tr height="35px">
					<td align="center" class="td_02">현 주 소</td>
					<td colspan="4" class="td_03"><c:out value="${item.zipCd}" /> <c:out value="${item.addr1}" /> <c:out value="${item.addr2}" /></td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">이메일</td>
					<td class="td_03"><c:out value="${item.email}" /></td>
					<td align="center" class="td_02 phoneNum">휴대폰</td>
					<td colspan="2" class="td_03">
						<c:set var="mobile" value="${item.mobile}" />
						<c:choose>
							<c:when test="${fn:indexOf(mobile, '직접입력') > -1}">
								<c:set var="mobile" value="${fn:replace(mobile, '직접입력-', '')}" />
								<c:set var="mobileSplit" value="${fn:split(mobile, '-')}" />
								<c:set var="mobileTel" value="" />
								<c:forEach var="mobileItem" items="${mobileSplit}" varStatus="status">
									<c:if test="${status.first}">
										<c:set var="mobileTel" value="${mobileItem}" />
									</c:if>
									<c:if test="${not status.first and not status.last}">
										<c:set var="mobileTel" value="${mobileTel}-${mobileItem}" />
									</c:if>
								</c:forEach>
								<c:out value="${mobileTel}" />
							</c:when>
							<c:otherwise>
								<c:out value="${mobile}" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr height="35px">
					<td align="center" class="td_02">년 월 일</td>
					<td colspan="3" align="center" class="td_02">학 력 및 경 력 사 항</td>
					<td align="center" class="td_02">발 령 자</td>
				</tr>
				<c:set var="tradeCount" value="0" />
				<c:set var="tradeCount1" value="0" />
				<c:set var="tradeCount2" value="0" />
				<c:forEach var="trade" items="${awd0021T}" varStatus="tradeStatus1">
					<c:if test="${item.prvPriType eq trade.prvPriType and trade.type eq '10001'}">
						<c:set var="tradeCount1" value="${tradeCount1 + 1}" />
						<tr height="35px">
							<td align="center" class="td_02"><c:out value="${trade.historyDt}" /> ~ <c:out value="${trade.historyToDt}" /></td>
							<td colspan="3" class="td_03"><c:out value="${trade.history}" /></td>
							<td align="center" class="td_02"><c:out value="${trade.historyOwner}" /></td>
						</tr>
					</c:if>
				</c:forEach>
				<c:forEach var="trade" items="${awd0021T}" varStatus="tradeStatus2">
					<c:if test="${item.prvPriType eq trade.prvPriType and trade.type eq '10002'}">
						<c:set var="tradeCount2" value="${tradeCount2 + 1}" />
						<tr height="35px">
							<td align="center" class="td_02"><c:out value="${trade.historyDt}" /> ~ <c:out value="${trade.historyToDt}" /></td>
							<td colspan="3" class="td_03"><c:out value="${trade.history}" /></td>
							<td align="center" class="td_02"><c:out value="${trade.historyOwner}" /></td>
						</tr>
					</c:if>
				</c:forEach>
				<c:set var="tradeCount" value="${tradeCount1 + tradeCount2}" />
				<c:if test="${tradeCount lt 13}">
					<c:forEach begin="1" end="${13 - tradeCount}" step="1">
						<tr height="35px">
							<td align="center" class="td_02"></td>
							<td colspan="3" class="td_03"></td>
							<td align="center" class="td_02"></td>
						</tr>
					</c:forEach>
				</c:if>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="35px;">
					<td></td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;">
				<tr height="25px;">
					<td align="center" style="font-size: 15px;">위의 내용은 사실과 틀림없습니다.</td>
				</tr>
				<tr height="25px;">
					<td align="center" style="font-size: 15px;"><c:out value="${printVO.toDay}" /></td>
				</tr>
				<tr height="25px;">
					<td align="right" style="padding-right: 50px;font-size: 15px;">
						<c:out value="${item.userNmKor}" />
						<c:choose>
							<c:when test="${item.prvPriType eq '10'}">
								<c:choose>
									<c:when test="${empty printVO.certFileId}">
										(인)
									</c:when>
									<c:otherwise>
										<img src="<c:url value="/common/util/tradefundImageDownload.do" />?fileId=<c:out value="${printVO.certFileId}" />&fileNo=<c:out value="${printVO.certFileNo}" />" style="width: 80px;height: 80px;" />
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${empty item.signFileId}">
										(인)
									</c:when>
									<c:otherwise>
										<img src="<c:url value="/common/util/tradefundImageDownload.do" />?fileId=<c:out value="${item.signFileId}" />&fileNo=<c:out value="${item.signFileNo}" />" style="width: 80px;height: 80px;" />
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
			<table style="width: 750px;border-left: #000000 solid 1px;border-right: #000000 solid 1px;border-bottom: #000000 solid 1px;">
				<tr height="30px">
					<td style="font-size: 25px;font-weight: bold;"><c:out value="${title}" />장관 귀하</td>
				</tr>
				<tr height="50px"><td></td></tr>
			</table>
			</c:forEach>
		</c:if>
		<c:if test="${param.reportGb6 eq 'Y'}">
			<p style="page-break-before: always;" />
			<table style="width: 750px;">
				<tr height="25px">
					<td>(별지 제7호 서식)</td>
				</tr>
			</table>
			<table style="width: 750px;">
				<tr height="60px">
					<td align="center" style="font-size: 20px;font-weight: bold;">특수유공자 포상추천서</td>
				</tr>
			</table>
			<table style="width: 750px;border-top: #000000 solid 1px;border-left: #000000 solid 1px;">
				<colgroup>
					<col width="50px" />
					<col width="100px" />
					<col width="150px" />
					<col width="150px" />
					<col width="50px" />
					<col width="150px" />
					<col width="100px" />
					<col width="100px" />
				</colgroup>
				<tr height="25px">
					<td rowspan="2" align="center" class="td_02">추천<br />기관</td>
					<td align="center" class="td_02">기관명</td>
					<td colspan="6" class="td_02"></td>
				</tr>
				<tr height="50px">
					<td align="center" class="td_02">담당자</td>
					<td colspan="6" class="td_02">
						<table style="width: 100%;height: 100%;">
							<tr>
								<td width="150px">직위 :</td>
								<td width="150px">성명 :</td>
								<td width="200px">전화번호 :</td>
							</tr>
							<tr>
								<td colspan="3">E-Mail :</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr height="25px">
					<td rowspan="2" align="center" class="td_02">연번</td>
					<td rowspan="2" align="center" class="td_02">추천부문</td>
					<td rowspan="2" align="center" class="td_02">성명<br />(주민등록번호)</td>
					<td rowspan="2" align="center" class="td_02">소속</td>
					<td rowspan="2" align="center" class="td_02">직위</td>
					<td rowspan="2" align="center" class="td_02">과거포상기록<br />(증빙서사본첨부)</td>
					<td colspan="2" align="center" class="td_02">연락처</td>
				</tr>
				<tr height="25px">
					<td align="center" class="td_02">이메일</td>
					<td align="center" class="td_02">휴대폰</td>
				</tr>
				<c:forEach var="countItem" begin="1" end="10" step="1">
					<tr height="25px">
						<td align="center" class="td_02"><c:out value="${countItem}" /></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
						<td align="center" class="td_02"></td>
					</tr>
				</c:forEach>
			</table>
			<table style="width: 750px;border-right: #000000 solid 1px;border-left: #000000 solid 1px;border-bottom: #000000 solid 1px;">
				<colgroup>
					<col width="50px" />
					<col width="700px" />
				</colgroup>
				<tr height="25px">
					<td style="padding-left: 10px;">첨부서류</td>
					<td style="padding-left: 10px;">1. 공적조서 각2부(별지 제3호 서식)</td>
				</tr>
				<tr height="25px">
					<td rowspan="7"></td>
					<td style="padding-left: 10px;">2. 이력서 각2부(별지 제6호 서식), 사진부착</td>
				</tr>
				<tr height="25px">
					<td style="text-decoration: underline;padding-left: 20px;">* 최종학교 졸업부터 모든 경력 기재(최소 수공기간 요건 확인을 위함)</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">3. 특수공적을 증빙하는 서류 1부</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">4. 사업자등록증 사본 1부</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">5. 수출업체종사자 추천시 산업재해보상보험가입증명원 각1부(사업장별)</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">6. 중소기업증명서 1부(별지 제5호 서식), 소액수출업체에 한함</td>
				</tr>
				<tr height="25px">
					<td style="padding-left: 10px;">7. 정부포상에 대한 동의서</td>
				</tr>
			</table>
			<table style="width: 750px;border-right: #000000 solid 1px;border-left: #000000 solid 1px;">
				<tr height="25px">
					<td><c:out value="${title}" /> 공고 <c:out value="${titleGb}" />에 의하여 위와 같이 신청합니다.</td>
				</tr>
				<tr height="25px">
					<td align="center"><c:out value="${printVO.toDay}" /></td>
				</tr>
				<tr height="25px">
					<td align="center">추 천 자 (인)</td>
				</tr>
			</table>
			<table style="width: 750px;border-right: #000000 solid 1px;border-left: #000000 solid 1px;">
				<tr height="30px">
					<td></td>
				</tr>
			</table>
			<table style="width: 750px;border-right: #000000 solid 1px;border-left: #000000 solid 1px;border-bottom: #000000 solid 1px;">
				<tr height="30px">
					<td style="font-size: 18px;font-weight: bold;padding-left: 10px;"><c:out value="${title}" />장관 귀하</td>
				</tr>
			</table>
		</c:if>
		</td>
	</tr>
	<tr height="30px">
		<td></td>
	</tr>
</table>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['.phoneNum'], 'R');
	});

	function printPage() {
		document.getElementById('printId').style.display = 'none';

		window.print();

		document.getElementById('printId').style.display = '';
	}
</script>