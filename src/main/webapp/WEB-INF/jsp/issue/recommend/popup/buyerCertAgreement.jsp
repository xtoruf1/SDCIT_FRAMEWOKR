<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="flex">
	<h2 class="popup_title">개인정보 수집·이용·제3자 제공 동의서</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doPrint();">출력</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div class="popup_body" id="printTable">
	<style type="text/css">
	@media print {
		.terms_agree *:not(.terms_agree_tit) { font-size: 13px; }
		html, body { -webkit-print-color-adjust:exact; width: 210mm; height: 297mm; }
	    table { page-break-inside:auto; }
	    tr    { page-break-inside:avoid; page-break-after:auto; }
	    thead { display:table-header-group; }
	    tfoot { display:table-footer-group; }
	}
	</style>
	<div class="terms_agree">
		<h1 class="terms_agree_tit">개인정보 수집·이용·제3자 제공 동의서</h1>
		<p>한국무역협회에서는 <strong>단기방문 사증발급 추천서</strong> 발급을 위하여 귀하의 개인정보를 수집·이용 및 제3자 제공을 하고자 합니다. 다음의 사항을 숙지하여 동의 여부를 체크, 서명하여 주시기 바랍니다.</p>

		<div class="terms_agree_details">
			<p><strong>▶개인정보 수집 및 이용 동의 [고유식별정보]</strong></p>
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
						<td>성명, [<strong>무역업고유번호</strong>], 취급 품목, 수출실적, 주소, 전화번호, 이메일주소 등</td>
						<td>외국인의 단기방문 체류자격 사증 발급 추천 검토</td>
						<td>1년</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="terms_agree_checkArea">
			<p>※ 귀하께서는 개인정보 제공 및 활용에 거부할 권리가 있습니다.</p>
	 		<p class="mt-10">▸거부에 따른 불이익: 위 정보제공에 동의하지 않을 경우 추천서 발급이 불가합니다.</p>
			<div class="agree_checked">
				<p>■<strong>동의함</strong></p>
				<p>□동의하지 않음</p>
			</div>
		</div>
		<div class="terms_agree_details">
			<p><strong>▶개인정보의 제3자 제공 동의 [고유식별정보]</strong></p>
			<table class="formTable mt-10">
				<colgroup>
					<col style="width:33%" />
					<col style="width:33%" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th>정보를 제공받는 자</th>
						<th>제공 항목</th>
						<th><strong>정보를 받는자의 이용목적</strong></th>
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
				<p>■<strong>동의함</strong></p>
				<p>□동의하지 않음</p>
			</div>
		</div>

		<div class="terms_agree_bottom">
			<p>본인은 본 『개인정보의 수집 · 이용 제공 동의서』 내용을 읽고 명확히 이해하였으며, 이에 동의합니다. 또한 사증발급 추천 대상 외국인에 대해서는 본인이 동 건 관련 개인정보 수입·이용·제3자 제공 동의를 받았음을 확인합니다(외국인의 성명, 성별, 여권번호, 생년월일, 국적, 주소, 전화번호 등).</p>
			<div class="mt-20">
				<p>작성일자 : <c:out value="${fn:substring(result.reqDate,0,4)}"/>년 <c:out value="${fn:substring(result.reqDate,4,6)}"/>월 <c:out value="${fn:substring(result.reqDate,6,8)}"/>일</p>
				<div class="signature_bar">성명 : <c:out value="${result.ceoName}"/> <div class="signature">(서명) <span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div>
			</div>
		</div>
	</div>

	<!-- 사증발급 추천신청서 -->
	<c:forEach var="reqList" items="${reqList}" varStatus="status">
		<div style="page-break-before:always">
		</div>
		<div class="terms_agree">
			<div class="align_ctr"><u class="popup_title">사증발급 추천신청서</u></br>
			<p>(단기방문(C-3)사증)</p></div>
			<p>신청번호(APPLICATION No.) : 제 <c:out value="${compResult.appNo}"/> 호</p>
			<p class="mt-10">○<strong>추천 대상 바이어</strong></p>
			<table class="formTable">
				<colgroup>
					<col style="width:8%" />
					<col style="width:13%" />
					<col style="width:20%" />
					<col style="width:25%" />
					<col style="width:15%" />
					<col style="width:25%" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">성명</br>NAME IN FULL</th><td colspan="2"><c:out value="${reqList.reqName}"/></td><th>여권번호</th><td colspan="2"><c:out value="${reqList.passport}"/></td>
				</tr>
				<tr>
					<th>성별</th><td><c:out value="${reqList.sex}"/></td><th>생년월일</th><td><c:out value="${reqList.birthDate}"/></td><th>국적</th><td colspan="2"><c:out value="${reqList.nationalNm}"/></td>
				</tr>
				<tr>
					<th colspan="2">주소</th><td colspan="2"><c:out value="${reqList.reqAddress}"/></td><th>전화번호</th><td colspan="2"><c:out value="${reqList.phone}"/></td>
				</tr>
				<tr>
					<th colspan="2">직업</th><td colspan="2"><c:out value="${reqList.reqJob}"/></td><th>팩스번호</th><td colspan="2"><c:out value="${reqList.fax}"/></td>
				</tr>
				<tr>
					<th colspan="2">직장 및 주소</th><td colspan="5"><c:out value="${reqList.reqAddress}"/></td>
				</tr>
			</table>
			<p class="mt-10">○<strong>추천 신청 업체</strong></p>
			<table class="formTable">
				<colgroup>
					<col style="width:20%" />
					<col style="width:30%" />
					<col style="width:13%" />
					<col style="width:20%" />
					<col style="width:13%" />
					<col style="width:15%" />
					<col />
				</colgroup>
				<tr>
					<th>회사명</br>NAME IN FULL</th><td><c:out value="${compResult.companyName}"/></td><th>대표자명</th><td><c:out value="${compResult.ceoName}"/></td><th>무역업고유번호</th><td><c:out value="${compResult.tradeNo}"/></td>
				</tr>
				<tr>
					<th>취급 품목</br>(영업 분야)</th><td colspan="2"><c:out value="${compResult.item}"/></td><th>전년도수출실적</th><td colspan="2"><c:out value="${compResult.lastTotalAmt}"/></td>
				</tr>
				<tr>
					<th>주소</th><td colspan="2"><c:out value="${compResult.address}"/></td><th>전화번호</th><td colspan="2"><c:out value="${compResult.companyTel}"/></td>
				</tr>
				<tr>
					<th>담당자</th><td colspan="2"><c:out value="${compResult.chargeName}"/></td><th>연락처</th><td colspan="2"><c:out value="${compResult.chargePhone}"/></td>
				</tr>
				<tr>
					<th>부서 및 직위</th><td colspan="2"><c:out value="${compResult.chargeDept}"/> / <c:out value="${compResult.chargePosition}"/></td><th>이메일</th><td colspan="2"><c:out value="${compResult.chargeEmail}"/></td>
				</tr>
			</table>
			<table class="formTable mt-10">
				<colgroup>
					<col style="width:20%" />
					<col style="width:80%" />
					<col />
				</colgroup>
				<tr>
					<th>○ 체류예정기간</th><td><c:out value="${reqList.startDate}"/> ~ <c:out value="${reqList.endDate}"/></td>
				</tr>
				<tr>
					<th>○ 입국목적</br>(초청목적)</th><td><c:out value="${reqList.entryPurpose}"/></td>
				</tr>
				<tr>
					<th>○ 방한사실</th><td><c:out value="${reqList.pastVisit}"/></td>
				</tr>
			</table>
			<p>출입국관리사증발급 지침개정과 신흥국바이어 국내입국 간소화 조치에 의거 단기방문(C-3) 사증발급추천을 신청합니다.</p>
			<div class="terms_agree_bottom mt-10">
				<div class="ml-auto">
					<div class="signature_bar">신청일 <span class="signature"><c:out value="${fn:substring(result.reqDate,0,4)}"/>년 <c:out value="${fn:substring(result.reqDate,4,6)}"/>월 <c:out value="${fn:substring(result.reqDate,6,8)}"/>일</span></div>
					<div class="signature_bar">신청인(대표자) <c:out value="${compResult.ceoName}"/><div class="signature">서명 또는 날인 <span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div>
				</div>
			</div>
		<div>
		<p>【제출서류】신청인</p>
		<div style="float:Left; width:400px;">1. 회사소개서</br>
			2. 사업자등록증</br>
			3. 무역업고유번호부여중</br>
			4. 수출실적 증명서</div>
		<div>5. 바이어와 수출관련 증빙서류</br>
			6. 중소기업 확인서</br>
			7. 서약서</br>
			8. 개인정보 수집·이용·제3자 제공 동의서</div>
		</div>
		<div>
		<p class="mt-10">【제출서류】초청바이어</p>
		<div style="float:Left; width:400px;">1. 사업자등록증</br>
			2. 수출입거래 관련 서류</br>
			3. 재직 입증서류</div>
		<div>4. 여권사본</br>
			5. 이력서
		</div></div></br>
		</div>
	</c:forEach>
	<div style="page-break-before:always">
	</div>

	<!-- 신흥시장 바이어 초청 비자추천 서약서 -->
	<div class="terms_agree">
		<h2 class="align_ctr"><u class="popup_title">신흥시장 바이어 초청 비자추천 서약서</u></h2>
		<table class="formTable mt-10 mb-20">
			<colgroup>
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:20%" />
				<col />
			</colgroup>
			<tr>
				<th rowspan="4"><strong>신청업체</strong></th>
				<th>회사명</th><td colspan="3"><c:out value="${compResult.companyName}"/></td>
			</tr>
			<tr><th>대표자</th><td colspan="3"><c:out value="${compResult.ceoName}"/></td>
			</tr>
			<tr><th>주소</th><td colspan="3"><c:out value="${compResult.address}"/></td>
			</tr>
			<tr><th>전화</th><td colspan="3"><c:out value="${compResult.companyTel}"/></td>
			</tr>
			<tr>
				<th rowspan="2"><strong>담당자</strong></th>
				<th>성명</th><td><c:out value="${compResult.chargeName}"/></td><th>연락처</th><td><c:out value="${compResult.chargePhone}"/></td>
			</tr>
			<tr>
				<th>부서 및 직위</th><td><c:out value="${compResult.chargeDept}"/> / <c:out value="${compResult.chargePosition}"/></td><th>이메일</th><td><c:out value="${compResult.chargeEmail}"/></td>
			</tr>
			<c:forEach var="reqList" items="${reqList}" varStatus="status">
			<tr>
				<th rowspan="2"><strong>초청바이어</strong></th>
				<th>성명</th><td><c:out value="${reqList.reqName}"/></td><th>국적</th><td><c:out value="${reqList.nationalNm}"/></td>
			</tr>
			<tr>
				<th>여권번호</th><td><c:out value="${reqList.passport}"/></td><th>이메일</th><td><c:out value="${reqList.email}"/></td>
			</tr>
			<tr>
				<th><strong>출(입)국 사	항</strong></th><th>입국 예정일</th><td><c:out value="${reqList.startDate}"/></td><th>출국 예정일</th><td><c:out value="${reqList.endDate}"/></td>
			</tr>
			</c:forEach>
		</table>
		<strong>* 상기 사증발급 추천과 관련 초청외국인의 무단이탈·불법체류 방지를 위한 제반조치를 강구하며 초청외국인의 무단이탈 불법체류가 발생시, 향후 무역협회 사증추천 대상자격이 박탈되며 출입국 관련법령에 따라 어떠한 처벌도 받을 것을 서약합니다.</strong>
		<div class="terms_agree_bottom">
			<div class="ml-auto">
				<div class="signature_bar"><span class="signature"><c:out value="${fn:substring(result.reqDate,0,4)}"/> . <c:out value="${fn:substring(result.reqDate,4,6)}"/> . <c:out value="${fn:substring(result.reqDate,6,8)}"/> . </span></div>
				<div class="signature_bar">회사명 <span class="signature"><c:out value="${compResult.companyName}"/></span></div>
				<div class="signature_bar">대표자 <div class="signature"><c:out value="${compResult.ceoName}"/>  (인) <span class="signature_img"><img src='<c:out value="/common/getFileImage.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}"/>' alt=""></span></div></div>
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

            //출력 시 서류 제목이 2회 나오므로 잠시 보이지 않게 처리
            var flexClassArr = document.getElementsByClassName('flex');
            for(var flexClass of flexClassArr) {
            	flexClass.style.display = "none";
            }

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

           //출력 후 안 보였던 요소들을 다시 보이도록 처리
            var flexClassArr = document.getElementsByClassName('flex');
            for(var flexClass of flexClassArr) {
            	flexClass.style.display = "";
            }
        };
        window.print();
	}

</script>
