<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="popup_body" id="printTable">
	<style type="text/css">
	@media print {
		/* 출력 전 레이어 팝업에 보였던 상단 제목 안 보이게 처리 */
		.flex { display: none; }
		/* 폰트 크기 조절(임시) */
		.terms_agree *:not(.terms_agree_tit) { font-size: 13px; }
		html, body { -webkit-print-color-adjust:exact; width: 210mm; height: 297mm; }
	    table { page-break-inside:auto; }
	    tr    { page-break-inside:avoid; page-break-after:auto; }
	    thead { display:table-header-group; }
	    tfoot { display:table-footer-group; }
	}
	</style>
	<c:forEach var="appUser" items="${userList}" varStatus="status">
		<div class="flex<c:if test="${!status.first}"> mt-20</c:if>">
			<h2 class="popup_title">사증발급 추천신청서(무역인력)</h2>
			<c:if test="${status.first}">
				<div class="ml-auto">
					<button type="button" class="btn_sm btn_primary" onclick="doPrint();">출력</button>
					<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
				</div>
			</c:if>
		</div>
		<div class="terms_agree">
			<h1 class="terms_agree_tit" style="text-decoration: underline;">
				사증발급 추천신청서
				<p style="font-size:15px;">(무역인력)</p>
			</h1>
			<div class="terms_agree_details">
				<p>신청번호(APPLICATION No.) : 제 ${result.appNo}호</p>

				<p class="mt-10">○추천 대상 외국인</p>

				<table class="formTable mt-10">
					<colgroup>
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
					</colgroup>
					<tbody>
						<tr>
							<th>성    명<br>NAME IN FULL</th>
							<td colspan="3"><c:out value="${appUser.reqName}"/></td>
							<th>여권번호</th>
							<td><c:out value="${appUser.passport}"/></td>
						</tr>
						<tr>
							<th>성별</th>
							<td><c:out value="${appUser.sex}"/></td>
							<th>생년월일</th>
							<td><c:out value="${appUser.birthDate}"/></td>
							<th>국적</th>
							<td><c:out value="${appUser.nationalNm}"/></td>
						</tr>
						<tr>
							<th>주소</th>
							<td colspan="3"><c:out value="${appUser.reqAddress}"/></td>
							<th>전화번호</th>
							<td><c:out value="${appUser.phone}"/></td>
						</tr>
						<tr>
							<th>주요학력</th>
							<td colspan="5"><c:out value="${appUser.education}"/></td>
						</tr>
						<tr>
							<th>주요경력</th>
							<td colspan="5"><c:out value="${appUser.career}"/></td>
						</tr>
					</tbody>
				</table>
				<p class="mt-10">○추천 신청 업체</p>
				<table class="formTable mt-10">
					<colgroup>
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col style="width:16.7%" />
						<col/>
					</colgroup>
					<tbody>
						<tr>
							<th>대 표 성 명<br>NAME IN FULL</th>
							<td colspan="3"><c:out value="${result.ceoName}"/></td>
							<th>무역업고유번호</th>
							<td><c:out value="${result.tradeNo}"/></td>
						</tr>
						<tr>
							<th>취급 품목<br>(영업 분야)</th>
							<td colspan="3"><c:out value="${result.item}"/></td>
							<th>전년도 수출실적</th>
							<td><c:out value="${result.lastTotalAmt}"/></td>
						</tr>
						<tr>
							<th>주소</th>
							<td colspan="3"><c:out value="${result.address}"/></td>
							<th>전화번호</th>
							<td>${result.companyTel}</td>
						</tr>
					</tbody>
				</table>
				<table class="formTable mt-10">
					<tbody>
						<tr>
							<td>○ 고용사유 <c:out value="${appUser.employReason}"/></td>
						</tr>
						<tr>
							<td>○ 고용기간 <c:out value="${appUser.startDate} ~ ${appUser.endDate}" escapeXml="false" /></td>
						</tr>
						<tr>
							<td>○ 예정 근무처 및 담당업무 <c:out value="${fn:replace(appUser.employDscr, '=!=', '/')}" escapeXml="false" /></td>
						</tr>
					</tbody>
				</table>

				<p class="mt-10">출입국관리법시행규칙 제 76조 규정에 의한 사증 발급 추천서 발부를 신청합니다.</p>
				<table class="mt-10">
					<colgroup>
						<col style="width:50%" />
						<col style="width:12.5%" />
						<col/>
					</colgroup>
					<tr>
						<td></td>
						<td>신청일</td>
						<td><c:out value="${fn:substring(result.reqDate,0,4)}"/>년 <c:out value="${fn:substring(result.reqDate,4,6)}"/>월 <c:out value="${fn:substring(result.reqDate,6,8)}"/>일</td>
					</tr>
					<tr>
						<td></td>
						<td>신청인</td>
						<td><div class="signature_bar"><c:out value="${appUser.reqName}"/><div class="signature">서명 또는 날인<span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div></td>
					</tr>
					<tr>
						<td></td>
						<td>담당자 및</td>
						<td>${result.chargeName}</td>
					</tr>
					<tr>
						<td></td>
						<td>연락처</td>
						<td>${result.chargePhone}</td>
					</tr>
				</table>
				<p class="mt-10">[첨부물 명세]</p>
				<table>
					<tr>
						<td>1. 회사소개서</td>
						<td>7. 외국인 학력증명서 (졸업장 사본 가능)</td>
					</tr>
					<tr>
						<td>2. 사업자등록증</td>
						<td>8. 외국인 경력증명서</td>
					</tr>
					<tr>
						<td>3. 무역업고유번호 부여증</td>
						<td>9. 고용계약서</td>
					</tr>
					<tr>
						<td>4. 수출실적 증명서 (직전년도)</td>
						<td>10. 개인정보 수집·이용·제3자 제공동의서</td>
					</tr>
					<tr>
						<td>5. 외국인 여권 사본</td>
						<td>11. 무역인력 사증발급 추천 서약서</td>
					</tr>
					<tr>
						<td>6. 외국인 이력서</td>
						<td>12. 고용 사유서</td>
					</tr>
				</table>
			</div>
		</div>
		<div style="page-break-before:always;">
		</div>
	</c:forEach>
	<div class="flex mt-20">
		<h2 class="popup_title">무역인력 사증발급 추천 서약서</h2>
	</div>
	<div class="terms_agree">
		<h1 class="terms_agree_tit" style="text-decoration: underline;">무역인력 사증발급 추천 서약서</h1>

		<div class="terms_agree_details">
			<table class="formTable mt-10">
				<colgroup>
					<col style="width:33%" />
					<col style="width:33%" />
					<col style="width:33%" />
					<col style="width:33%" />
					<col style="width:33%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th rowspan="4">신청업체</td>
						<th>회사명</td>
						<td colspan="3"><c:out value="${result.companyName}"/></td>
					</tr>
					<tr>
						<th>대표자</td>
						<td colspan="3"><c:out value="${result.ceoName}"/></td>
					</tr>
					<tr>
						<th>주소</td>
						<td colspan="3"><c:out value="${result.address}"/></td>
					</tr>
					<tr>
						<th>전화</td>
						<td colspan="3">${result.companyTel}</td>
					</tr>
					<c:forEach var="appUser" items="${userList}">
						<tr>
							<th rowspan="2">추천대상<br>외국인</td>
							<th rowspan="2">성명<br>NAME IN FULL</td>
							<td rowspan="2"><c:out value="${appUser.reqName}"/></td>
							<th>국적</td>
							<td><c:out value="${appUser.nationalNm}"/></td>
						</tr>
						<tr>
							<th>성별</td>
							<td><c:out value="${appUser.sex}"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<div class="terms_agree_bottom mt-20">
			<p>* 당사는 상기 사증발급 추천과 관련 추천대상 외국인의 출입국관련 법령 준수와 불법체류 방지를 위한 제반조치를 강구하고 추천 대상 외국인의 불법체류 발생시, 향후 무역엽회 사증추천 대상 자격이 박탈되며 출입국 관련법령에 따라 어떤한 처벌도 받을 것을 서약합니다.</p>
			<div class="terms_agree_bottom" style="align-items: flex-end;">
				<p><c:out value="${fn:substring(result.reqDate,0,4)}"/>. <c:out value="${fn:substring(result.reqDate,4,6)}"/>. <c:out value="${fn:substring(result.reqDate,6,8)}"/>.</p>
				<div class="mt-20">
					<p class="mt-20">회사명 <c:out value="${result.companyName}"/></p>
					<div class="signature_bar">대표자 <c:out value="${result.ceoName}"/> <div class="signature">(인) <span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div>
				</div>
			</div>
		</div>
	</div>
	<div style="page-break-before:always;">
	</div>
	<div class="flex mt-20">
		<h2 class="popup_title">개인정보 수집·이용 제공 동의서</h2>
	</div>
	<div class="terms_agree">
		<h1 class="terms_agree_tit">개인정보 수집·이용·제3자 제공 동의서</h1>

		<p>한국무역협회에서는 <strong>무역인력 사증발급 추천서</strong> 발급을 위하여 귀하의 개인정보를 수집 · 이용 및 제 3자 제공을 하고자 합니다. 다음의 사항을 숙지하여 동의 여부를 체크, 서명하여 주시기 바랍니다.</p>
		<div class="terms_agree_details">
			<p>▶개인정보 수집 및 이용 동의 [고유식별정보]</p>
			<table class="formTable mt-10">
				<colgroup>
					<col style="width:33%" />
					<col style="width:33%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th>수집·이용하려는 개인정보</th>
						<th>개인정보의 수집·이용목적</th>
						<th>개인정보 이용 및 보유기간</th>
					</tr>
					<tr>
						<td>성명, [<strong>무역업고유번호</strong>], 취급품목, 수출실적, 주소, 전화번호, 이메일주소 등</td>
						<td>외국인력 채용을 위한 외국인 사증 발급 추천 검토</td>
						<td>1년</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="terms_agree_checkArea">
			<p>※ 귀하께서는 개인정보 제공 및 활용에 거부할 권리가 있습니다.</p>
			<p class="mt-10">▸거부에 따른 불이익: 위 정보제공에 동의하지 않을 경우 추천서 발급이 불가합니다.</p>
			<div class="agree_checked">
				<p>■ 동의함</p>
				<p>□ 동의하지 않음</p>
			</div>
		</div>
		<div class="terms_agree_details">
			<p>▶개인정보의 제3자 제공 동의 [고유식별정보]</p>
			<table class="formTable mt-10">
				<colgroup>
					<col style="width:20%" />
					<col style="width:30%" />
					<col style="width:30%" />
					<col style="width:20%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th>정보를 제공받는 자</th>
						<th>제공 항목</th>
						<th><strong>정보를 받는 자의 이용목적</strong></th>
						<th>이용 및 보유 기간</th>
					</tr>
					<tr>
						<td>법무부 출입국관리사무소</td>
						<td>성명, [<strong>무역업고유번호</strong>], 취급품목, 주소, 전화번호 등</td>
						<td>사증 심사·발급</td>
						<td>1년</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="terms_agree_checkArea">
			<p>※ 귀하께서는 개인정보 제공 및 활용에 거부할 권리가 있습니다.</p>
			<p class="mt-10">▸거부에 따른 불이익: 위 정보제공에 동의하지 않을 경우 추천서 발급이 불가합니다.</p>
			<div class="agree_checked">
				<p>■ 동의함</p>
				<p>□ 동의하지 않음</p>
			</div>
		</div>

		<div class="terms_agree_bottom">
			<p>본인은 본 『개인정보의 수집 · 이용 · 제3자 제공 동의서』 내용을 읽고 명확히 이해하였으며, 이에 동의합니다. 또한 사증발급 추천 대상 외국인에 대해서는 본인이 동 건 관련 개인정보 수입·이용·제3자 제공 동의를 받았음을 확인합니다.(외국인의 성명, 성별, 여권번호, 생년월일, 국적, 주소, 전화번호 등)</p>
			<div class="mt-10">
				<p>작성일자 : <c:out value="${fn:substring(result.reqDate,0,4)}"/>년 <c:out value="${fn:substring(result.reqDate,4,6)}"/>월 <c:out value="${fn:substring(result.reqDate,6,8)}"/>일</p>
				<div class="signature_bar">성명 : <c:out value="${result.ceoName}"/> <div class="signature">(서명) <span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">


	$(document).ready(function(){


	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function doPrint() {

		var _nbody = null;
        var _body = document.body; //innerHtml 이 아닌 실제 HTML요소를 따로 보관.
        var printDiv = document.createElement("div"); //프린트 할 영역의 DIV 생성(DIV높이 너비 등 설정 편하게 하기 위한 방법)


        window.onbeforeprint = function(){
            // initBody = document.body.innerHTML;

		// 프린트하는 영역도 아닌데 이를 숨기는 의도를 잘 모르겠습니다.
//              document.getElementsByClassName('btn_group')[0].style.display = "none";
             //$('#btn_group').hide();
             document.getElementById("printTable").style.height = "60%";
             document.getElementById("printTable").style.maxWidth = "100%";

            // 굳이 클래스네임은 선언하지 않아도 됩니다.
//             printDiv.className = "IBSheet_PrintDiv";
            var val = document.getElementById('printTable').innerHTML;
            document.body = _nbody = document.createElement("body");
            _nbody.appendChild(printDiv);
            printDiv.innerHTML = val; //프린트 할 DIV에 필요한 내용 삽입.
        };
        window.onafterprint = function(){
            // 프린트 후 printDiv 삭제.
            _nbody.removeChild(printDiv);
            // body영역 복원
            document.body = _body;
            //이젠 필요없으니 삭제.
            _nbody = null;
            // 아까 위에서 숨겼던 버튼들 복원.
//              document.getElementsByClassName('btn_group')[1].style.display = "";
           // $('#btn_group').show();
        };
        window.print();
	}

</script>
