<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="flex">
	<h2 class="popup_title">개인정보 수집·이용 제공 동의서</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doPrint();">출력</button>
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>
<div class="popup_body" id="printTable">
	<div class="terms_agree">
		<h1 class="terms_agree_tit">개인정보 수집·이용 제공 동의서</h1>
		<p>한국무역협회에서는 해외지사 설치인증 추천서 발급을 위하여 귀하의 개인정보를 수집 · 이용하고자 합니다. 다음의 사항을 숙지하여 동의 여부를 체크, 서명하여 주시기 바랍니다.</p>

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
						<td>성명, [<strong>무역업고유번호</strong>], 취급 품목, 주소, 전화번호, 수출실적 등</td>
						<td>해외 지점, 사무소 설치인증 추천 검토</td>
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
			<p>본인은 본 『개인정보의 수집 · 이용 제공 동의서』 내용을 읽고 명확히 이해하였으며, 이에 동의합니다.</p>
			<div class="mt-20">
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
