<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">


	// 증명사진 등록
	 function setPhoto(event) {
		var reader = new FileReader();
		reader.onload = function(event) {
			var img = document.createElement("img");
			img.setAttribute("src", event.target.result);
			var imgBox = document.querySelector("#photoBox");
			$(imgBox).html('');
			imgBox.appendChild(img)
		};
		reader.readAsDataURL(event.target.files[0]);
	}

</script>
<script type="text/javascript" src="/js/tradeSosComm.js"></script>

<form name="registForm" id="registForm" method="post" encType="multipart/form-data">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="procType" value="U" />
	<input type="hidden" name="expert_grp" value="">
<!-- 컨설턴트/전문가 관리 - 무역전문컨설턴트 상세 -->
<div class="page_tradesos">

	<!-- <h4 class="para_sub_title">신청 정보</h4> -->
	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" onclick="fn_submit();" class="btn_sm btn_primary btn_modify">수정</button>
		</div>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width:12%">
			<col>
			<col style="width:12%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">증명사진</th>
				<td colspan="3">
					<div class="form_file">
<%--						<input type="file" id="imageAdd" name="expertImage" accept="image/*"  class="file_input_hidden" onchange="setPhoto(event);"/>--%>
						<input type="hidden" id="attachSeqNo" name="attachSeqNo" value="${!empty resultFile.attachSeqNo ? resultFile.attachSeqNo : "0"}"/>
						<input type="hidden" id="attachDocumId" name="attachDocumId" value="${!empty resultFile.attachDocumId ? resultFile.attachDocumId : "0"}"/>
						<figure id="photoBox" class="photo_img">
							<c:choose>
								<c:when test="${!empty resultFile}">
									<img src="<c:out value="/cmm/fms/getMemberImage.do?attachDocumId=${resultFile.attachDocumId}&attachSeqNo=${resultFile.attachSeqNo}"/>" alt="">
								</c:when>
								<c:otherwise>
									<img src="/images/admin/defaultImg.jpg" alt="" style="width: 108px;height: 148px;">
								</c:otherwise>
							</c:choose>
						</figure>
						<label class="file_btn">
							<input type="file"  id="imageAdd" name="expertImage" accept="image/*" onchange="setPhoto(event);">
							<span class="btn_tbl ml-8" >사진등록</span>
						</label>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">이름</th>
				<td colspan="3">
					<input type="text" id="name" name="name" class="form_text" value="<c:out value="${resultData.name}"/>" readonly="readonly">
					<input type="text" id="expertId" name="expertId" class="form_text" value="<c:out value="${resultData.expertId}"/>" readonly="readonly">
					<c:if test="${searchVO.procType eq 'I'}">
						<button type="button" class="btnSchOpt find" onclick="openLayer('searchPop')">검색</button>
					</c:if>
					<%--<button type="button" class="btnSchOpt find" onclick="openLayer2('<c:url value="/system/tradeSOS/popup/consultantList.do"/>','searchPop')">검색</button>--%>
				</td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td>
					<div class="flex align_center">
					<input type="hidden" id="tel" name="tel" value="<c:out value="${resultData.tel}"/>"/>
						<div class="form_row" style="width:300px;">
							<c:choose>
								<c:when test="${fn:length(resultData.tel) eq 10}">
									<input type="text" id="tel1"  class="form_text"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
									<input type="text" id="tel2"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,3,6)}"/>" maxlength="4" numberOnly>
									<input type="text" id="tel3"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,6,10)}"/>" maxlength="4" numberOnly>
								</c:when>
								<c:when test="${fn:length(resultData.tel) eq 11}">
									<input type="text" id="tel1"  class="form_text"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
									<input type="text" id="tel2"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,3,7)}"/>" maxlength="4" numberOnly>
									<input type="text" id="tel3"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,7,11)}"/>" maxlength="4" numberOnly>
								</c:when>
								<c:otherwise>
									<input type="text" id="tel1"  class="form_text"  value="" maxlength="3" numberOnly>
									<input type="text" id="tel2"  class="form_text" value="" maxlength="4" numberOnly>
									<input type="text" id="tel3"  class="form_text" value="" maxlength="4" numberOnly>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</td>
				<th scope="row">직함</th>
				<td>
					<select name="item_type4" id="item_type4" class="form_select">
						<option value="">전체</option>
						<c:forEach items="${jobList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${resultData.itemType4 eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<input type="hidden" id="email" name="email" value="${resultData.email}">
					<div class="flex align_center">
						<c:choose>
							<c:when test="${!empty resultData.email}">
								<c:set var="emailSplit" value="${fn:split(resultData.email,'@')}"/>
								<input type="text" id="email1" class="form_text" value="${emailSplit[0]}" maxlength="49">
								<div class="spacing">@</div>
								<input type="text" id="email2" class="form_text" value="${emailSplit[1]}" maxlength="50">
							</c:when>
							<c:otherwise>
								<input type="text" id="email1" class="form_text" maxlength="49">
								<div class="spacing">@</div>
								<input type="text" id="email2" class="form_text" maxlength="50">
							</c:otherwise>
						</c:choose>
					</div>
				</td>
				<th scope="row">활동여부</th>
				<td>
					<label class="label_form">
						<input type="radio" class="form_radio" name="stYn" id="work" value="N" <c:if test="${empty resultData.stYn or (!empty(resultData.stYn) and resultData.stYn eq 'N')}">checked="checked"</c:if>>
						<span for="work" class="label">활동</span>
					</label>
					<label class="label_form">
						<input type="radio" class="form_radio" name="stYn" id="leave" value="Y"<c:if test="${!empty(resultData.stYn) and resultData.stYn eq 'Y'}">checked="checked"</c:if>>
						<span for="leave" class="label">활동종료</span>
					</label>
				</td>
			</tr>
			<!-- 신청이 사라져서 해당 항목 필요 X -->
<%--			<tr>--%>
<%--				<th scope="row">상담가능요일</th>--%>
<%--				<td colspan="3">--%>
<%--					<input type="hidden" name="weekday" id="weekday" value="${resultData.weekday}">--%>
<%--					<label for="item_day1" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day1" name="weekdayArr" value="0" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'0') != -1}">checked</c:if>><span class="label">일요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day2" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day2" name="weekdayArr" value="1" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'1') != -1}">checked</c:if>><span class="label">월요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day3" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day3" name="weekdayArr" value="2" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'2') != -1}">checked</c:if>><span class="label">화요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day4" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day4" name="weekdayArr" value="3" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'3') != -1}">checked</c:if>><span class="label">수요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day5" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day5" name="weekdayArr" value="4" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'4') != -1}">checked</c:if>><span class="label">목요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day6" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day6" name="weekdayArr" value="5" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'5') != -1}">checked</c:if>><span class="label">금요일</span>--%>
<%--					</label>--%>
<%--					<label for="item_day7" class="label_form">--%>
<%--						<input type="checkbox" class="form_checkbox" id="item_day7" name="weekdayArr" value="6" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'6') != -1}">checked</c:if>><span class="label">토요일</span>--%>
<%--					</label>--%>
<%--				</td>--%>
<%--			</tr>--%>
<%--			<tr>--%>
<%--				<th scope="row">상담분야</th>--%>
<%--				<td colspan="3">--%>
<%--					<input type="hidden" name="itemType3" id="itemType3" value="${resultData.itemType3}">--%>
<%--					<ul class="inp_list">--%>
<%--						<c:forEach items="${counselingList}" var="item" varStatus="status">--%>
<%--							<li>--%>
<%--								<label for="item_type${status.count}"  class="label_form">--%>
<%--									<input type="checkbox" class="form_checkbox" id="item_type${status.count}" name="itemTypeArr3" value="${item.cdId}"--%>
<%--										<c:if test="${!empty resultData.itemType3 and fn:indexOf(resultData.itemType3,item.cdId) != -1 }">checked</c:if>>--%>
<%--										<span class="label"><c:out value="${item.cdNm}"/></span>--%>
<%--								</label>--%>
<%--							</li>--%>
<%--						</c:forEach>--%>
<%--					</ul>--%>
<%--				</td>--%>
<%--			</tr>--%>
<%--			<tr>--%>
<%--				<th scope="row">전문분야</th>--%>
<%--				<td colspan="3">--%>
<%--					<input type="hidden" id="mtiCode" name="mtiCode"/>--%>
<%--					<select id="mtiCodeList" size="3" class="form_select w80p" style="height: 90px;">--%>
<%--						<c:out value="${resultData.mtiOptionHtml}" escapeXml="false"/>--%>
<%--					</select>--%>
<%--					<div class="btn_vertical">--%>
<%--						<button type="button" class="btn_tbl"  onclick="openLayerItemPop();">추가</button>--%>
<%--						<button type="button" class="btn_tbl_border" onclick="mtiCodeDel()">삭제</button>--%>
<%--					</div>--%>
<%--				</td>--%>
<%--			</tr>--%>
			<tr>
				<th scope="row">학력</th>
				<td colspan="3">
					<textarea id="scholar" name="scholar" rows="3" class="form_textarea" maxlength="650" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.scholar}"/></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">자격증</th>
				<td colspan="3">
					<textarea id="license" name="license" rows="3" class="form_textarea" maxlength="650" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.license}"/></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">주요이력</th>
				<td colspan="3">
					<textarea id="career" name="career" rows="3" class="form_textarea" maxlength="650" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.career}"/></textarea>
				</td>
			</tr>
		</tbody>
	</table><!-- // 무역전문컨설턴트 상세 테이블-->


</div> <!-- // .page_tradesos -->
</form>


<script type="text/javascript">
	$(document).ready(function()
	{
	});

	$("input:text[numberOnly]").on({
		keyup: function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		},
		focusout : function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		}
	});

	// function mtiCodeDel(){
	// 	var selectedObj = $('#mtiCodeList option:selected');
	// 	if(selectedObj.length < 0){
	// 		alert('삭제할 전문분야를 선택해주세요');
	// 		return false;
	// 	}else{
	// 		$('#mtiCodeList option:selected')[0].remove();
	// 	}
	// }

	function fn_submit(){
		var form = eval("document.registForm");
		var weekArray = new Array();
		var itemType3Array = new Array();
		var mtiCodeArray = new Array();

		if(form.expertId.value == "" || form.name.value == ""){
			alert("컨설턴트 찾기 팝업을 클릭하여 컨설턴트를 선택하셔야 합니다.");
			return;
		}

		if($('#itemType4').val() == ""){
			alert("직함을 선택하셔야 합니다.");
			$('#itemType4').focus();
			return;
		}

		if($('#email1').val == '' || $('#email2').val == ''){
			alert('이메일를 입력해주세요');
			$('#email1').focus();
			returnVal = false;
			return false;
		}else{
			$('#email').val($('#email1').val()+'@'+$('#email2').val());
			var emailExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (!emailExp.test($('#email').val())){
				alert("이메일주소가 유효하지 않습니다.");
				$('#email1').focus();
				returnVal = false;
				return;
			}
		}

		if(fc_chk_byte2(form.scholar, 2000) == false){ //학력
			return;
		}

		if(fc_chk_byte2(form.license, 1000) == false){ //자격증
			return;
		}

		var item_type3_arr = "";
		var item_type3Chk = document.getElementsByName("itemTypeArr3");

		var ic = 0;
		for(var i = 0; i < item_type3Chk.length; i++){
			if(item_type3Chk[i].checked == true){
				if(item_type3_arr == ""){
					if (item_type3Chk[i].value == '009') ic = 1;

					item_type3_arr += item_type3Chk[i].value;
				}else{
					if (item_type3Chk[i].value == '009') ic = 1;
					item_type3_arr += ","+item_type3Chk[i].value;
				}
			}
		}

		// if(item_type3_arr == ""){
		// 	alert("최소 한개의 상담분야를 선택하셔야 합니다.");
		// 	form.itemTypeArr3[0].focus();
		// 	return;
		// }

		form.expert_grp.value = "004";

		// 해외인증
		// if (ic == 1){
		// 	var mtiList = form.mtiCodeList;
		// 	var mtiListArr = "";
		//
		// 	if( mtiList.length <= 0){
		// 		alert('전문분야를 선택해주세요.');
		// 		return ;
		// 	}
		//
		// 	var day_gubun_arr = "";
		// 	var day_gubunChk = document.getElementsByName("weekdayArr");
		//
		// 	if(day_gubun_arr == ""){
		// 		alert("최소 한개의 상담가능 요일를 선택하셔야 합니다.");
		// 		day_gubunChk[0].focus();
		// 		return;
		// 	}
		// 	form.expert_grp.value = "009";
		// }else{
		// 	form.weekday.value = "";
		// 	form.mtiCode.value = "";
		// }

		//전화번호
		if($('#tel1').val() != '' && $(                                                                                                                                                                                                                                                                                                                                                                                                          '#tel2').val() != ''  && $('#tel3').val() != ''){
			$('#tel').val($('#tel1').val()+$('#tel2').val()+$('#tel3').val())
		}
		//이메일
		if($('#email1').val() != '' && $('#email2').val() != ''){
			$('#email').val($('#email').val()+    '@'+$('#email2').val());
		}

		$('input[name="weekdayArr"]:checked').each(function(){
			weekArray.push($(this).val());
			$('#weekday').val(String(weekArray.join()));
		});

		$('input[name="itemTypeArr3"]:checked').each(function(){
			itemType3Array.push($(this).val());
			$('#itemType3').val(String(itemType3Array.join()));
		});

		$('#mtiCodeList option').each(function(){
			mtiCodeArray.push($(this).val());
			$('#mtiCode').val(String(mtiCodeArray.join()));
		});

		var formData = new FormData($('#registForm')[0]);

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url:"/tradeSOS/com/professionalMemberProc.do",
			data:formData,
			processData:false,
			contentType:false,
			async:false,
			success:function(data){
				if(data.FLAG){
					alert('처리되었습니다.');
					window.location.reload();
				}else{
					alert('문제가 발생했습니다.');
					return false;
				}
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	/*계층형*/
	function openLayerItemPop(){

		global.openLayerPopup({
			popupUrl : '/tradeSOS/com/popup/professionalField.do'
			, callbackFunction : function(resultObj) {
				var appendCode = "";
				var appendName = "";
					var appendHtml = "";

					for(var i = 0; i < resultObj.mtiCodeArray.length; i++)							//선택한 행의 갯수만큼
					{
						appendHtml += '<option value='+resultObj.mtiCodeArray[i]+'>';							//선택한 품목 추가
						appendHtml += resultObj.mtiKorArray[i];
						appendHtml += '</option>';
					}

					$('#mtiCodeList').append(appendHtml);

			}
		});

	}
</script>
