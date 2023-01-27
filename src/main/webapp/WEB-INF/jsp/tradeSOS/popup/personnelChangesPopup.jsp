<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : personChangesPop.jsp
	 * @Description : 담당자 변경 팝업
	 * @Modification Information
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2022.06.20	강다정		최초 생성
	 *
	 * @author 강다정
	 * @since 2022.06.20
	 * @version 1.0
	 * @see
	 *
	 */
%>

	<div class="flex">
		<h2 class="popup_title">담당자를 선택해 주세요</h2>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="fnChgManage();">담당자 등록</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>
	<!-- 담당자변경 레이어팝업 -->
	<div id="memberPop" class="layerPopUpWrap" >
		<div class="layerPopUp" >
			<div class="layerWrap" style="width:900px;">
				<div class="box">
					<form id="chgManageFrm" method="post">
						<input type="hidden" name="eventSdcit" id="eventSdcit" value="ChgManage"/>
						<input type="hidden" id="sosSeq" name="sosSeq" value="<c:out value="${resultData.sosSeq}"/>"/>
						<input type="hidden" id="proState" name="proState" value="<c:out value="${resultData.proState}"/>"/>
						<table class="formTable">
							<colgroup>
								<col style="width:12%">
								<col>
								<col style="width:12%">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">소관기관</th>
									<td>
										<input type="radio" name="conOrga" id="radio1" checked="checked" value="K" class="form_radio"> <label for="radio1">무역협회</label>
										<input type="radio" name="conOrga" id="radio2"  value="G" class="form_radio"> <label for="radio2">정부기관</label>
										<input type="radio" name="conOrga" id="radio3"  value="I" class="form_radio"> <label for="radio3">유관기관</label>
										<input type="radio" name="conOrga" id="radio4"  value="L" class="form_radio"> <label for="radio4">기타</label>
									</td>
									<th scope="row">기관명</th>
									<td>
										<input type="text" id="conOrganm" name="conOrganm" class="form_text w100p" value="한국무역협회">
									</td>
								</tr>
								<tr>
									<th scope="row">담당자</th>
									<td>
										<div class="flex align_center">
											<span class="form_search w100p">
												<input type="text" id="conName" name="conName" class="form_text w100p">
												<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="fnManageSearch();" id="manageSearchButton"></button>
											</span>
										</div>
									</td>
									<th scope="row">담당부처</th>
									<td>
										<input type="text" id="conDept" name="conDept" class="form_text w100p">
									</td>
								</tr>
								<tr>
									<th scope="row">연락처</th>
									<td>
										<div class="flex align_center">
										<select id="conPhone1" name="conPhone1" class="form_select">
											<option value="" selected="">선택</option>
											<c:forEach var="data" items="${code130}" varStatus="status">
												<option value="${data.cdId}">${data.cdId}</option>
											</c:forEach>
										</select>
										<input type="text" name="conPhone2" id="conPhone2" class="form_text w100p ml-8" maxlength="4">
										<input type="text" name="conPhone3" id="conPhone3" class="form_text w100p ml-8" maxlength="4">
										<input type="hidden" name="conPhone"/>
										</div>
									</td>
									<th scope="row">이메일</th>
									<td>
										<input type="text" id="conEmail" name="conEmail" class="form_text w100p">
									</td>
								</tr>
								<tr>
									<th scope="row">이력 내용</th>
									<td colspan="3">
										<input type="text" id="proContents" name="proContents" class="form_text w100p">
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>


			</div>
			<div class="layerFilter"></div>
		</div>
	</div>

<script type="text/javascript">

	$(document).ready(function()
	{
		var pSeq = $("#adminForm input[name=sosSeq]").val()
		$("#chgManageFrm input[name=sosSeq]").val(pSeq);
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function fnManageSearch(){

		$("input[name=empKorNm]").val($("input[name=conName]").val());
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/employeeSearch.do'
			, callbackFunction : function(resultObj) {
				var empKorNm = resultObj.empKorNm;
				var deptNm = resultObj.deptNm;
				var cpTelno = '';
				var email = resultObj.email;
				//전화번호 '-' 삭제 (유효성 체크를 위한 것)
				cpTelno = resultObj.cpTelno.replaceAll('-','');
				//연락처 유효성 체크 형식에 맞는것만 입력
				if (global.isHpTel(cpTelno)){
					var cp_telnoArr =  resultObj.cpTelno.split("-")
					$("select[name=conPhone1]").val(cp_telnoArr[0]);
					$("input[name=conPhone2]").val(cp_telnoArr[1]);
					$("input[name=conPhone3]").val(cp_telnoArr[2]);
				}

				$("input[name=conName]").val(empKorNm);
				$("input[name=conDept]").val(deptNm);
				$("input[name=conEmail]").val(email);

			}
		});

	}

	$("input[name=conOrga]").on("change",function(){
		if ($(this).val() == 'K'){
			$("#manageSearchButton").show();
			$("#manageSearchButton").prev().attr("class","form_text");
			$("input[name=conOrganm]").val("한국무역협회");
		}else{
			$("#manageSearchButton").hide();
			$("#manageSearchButton").prev().attr("class","form_text");
			$("input[name=conOrganm]").val("");
		}
	})

	//담당자 변경
	var chgManageSubmitFlag = true;
	function fnChgManage(){
		if (confirm('담당자 변경 하시겠습니까?')) {
		var form = $("#chgManageFrm");
		if ($("input[name=conOrganm]").val().trim() == ""){
			alert("기관명을 입력하세요.");
			$("input[name=conOrganm]").focus();
			return;
		}else if ($("input[name=conName]").val().trim() == ""){
			alert("담당자를 입력하세요.");
			$("input[name=conName]").focus();
			return;
		}else if ($("input[name=conDept]").val().trim() == ""){
			alert("담당부처를 입력하세요.");
			$("input[name=conDept]").focus();
			return;
		}else if ($("select[name=conPhone1]").val().trim() == ""){
			alert("연락처 앞자리를 입력하세요.");
			$("select[name=conPhone1]").focus();
			return;
		}else if ($("input[name=conPhone2]").val().trim() == ""){
			alert("연락처 중간자리를 입력하세요.");
			$("input[name=conPhone2]").focus();
			return;
		}else if ($("input[name=conPhone3]").val().trim() == ""){
			alert("연락처 마지막자리를 입력하세요.");
			$("input[name=conPhone3]").focus();
			return;
		}else if (!global.isEmail($("input[name=conEmail]").val())){
			alert("이메일을 형식에 맞게 입력하세요.");
			$("input[name=conEmail]").focus();
			return;
		}else if ($("input[name=proContents]").val().trim() == ""){
			alert("이력내용을 입력하세요.");
			$("input[name=proContents]").focus();
			return;
		}else{
			var conPhone = $("select[name=conPhone1]").val()+"-"+$("input[name=conPhone2]").val()+"-"+$("input[name=conPhone3]").val();
			$("input[name=conPhone]").val(conPhone);


			var aUrl = '<c:out value="${param.ajaxUrl}"/>';
			var formData = new FormData($('#chgManageFrm')[0]);

			$.ajax({
				type: "post",
				enctype: 'multipart/form-data',
				url: aUrl,
				data: formData,
				processData: false,
				contentType: false,
				async: false,
				success: function (data) {
					closeLayerPopup();
					window.location.reload();
				},
				error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}

		}
	}

</script>