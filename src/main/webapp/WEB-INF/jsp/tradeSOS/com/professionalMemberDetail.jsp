<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	/**
	 * @Class Name : topMenu.jsp
	 * @Description : 대메뉴 목록화면
	 * @Modification Information
	 * @
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2016.04.28	이인오		최초 생성
	 *
	 * @author 이인오
	 * @since 2016.04.28
	 * @version 1.0
	 * @see
	 *
	 */
%>
<script type="text/javascript">
	function press(event) {
		if (event.keyCode==13) {

		}
	}
	function fn_list() {
		document.listForm.action = "/tradeSOS/com/professionalMember.do";
		document.listForm.submit();
	}

	// 컨설턴트 팝업
	function openLayerConsultantPop(){
		global.openLayerPopup({
			popupUrl : '/tradeSOS/com/popup/consultantSearch.do'
		});
	}

	/*계층형*/
	function openLayerItemPop(){
		//기본값 초기화
		$('#searchUnit').val('');
		$('#searchMtiCodePop').val('');
		$('#upperItem').data('unit','0');
		//품목별 초기화 추가
		$('#searchMtiNmPop').val('');
// 		itemStepList(tblSheet);
// 		itemKeyList(tblSheet2);
// 		$('#itemPop').show();

		global.openLayerPopup({
			popupUrl : '/tradeSOS/com/popup/professionalField.do'
			, callbackFunction : function(resultObj) {
				var appendHtml = "";

				for(var i = 0; i < resultObj.mtiCodeArray.length; i++)							//선택한 행의 갯수만큼
				{
					appendHtml += '<option value='+resultObj.mtiCodeArray[i]+'>';							//선택한 품목 추가
					appendHtml += resultObj.mtiKorArray[i];
					appendHtml += '</option>';
				}

				$('#mti_code_list').append(appendHtml);

// 				$('#mtiCode').append(resultObj.mtiCodeArray);
// 				$('#mti_code_list').append(resultObj.mtiKorArray);
			}
		});

	}
	/*계층형*/
	function closeLayerItemPop(){
		//setResetGrid('mySheet');
		//initGrid('tblGrid','mySheet',650,250);
		/*if (typeof mySheet !== "undefined" && typeof mySheet.Index !== "undefined") {
			mySheet.DisposeSheet();
		}*/
		$('#itemPop').hide();
	}

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
<form name="listForm" id="listForm" method="post">
	<c:forEach var="params" items="${param}"  varStatus="status">
		<input type="hidden" id="<c:out value="${params.key}"/>" name="<c:out value="${params.key}"/>" value="<c:out value="${params.value}"/>" />
	</c:forEach>
</form>

<form name="registForm" id="registForm" method="post" encType="multipart/form-data">
	<input type="hidden" name="topMenuId" value="" />
	<input type="hidden" name="procType" value="${searchVO.procType}" />
	<input type="hidden" name="expertGrp" value="">
<!-- 컨설턴트/전문가 관리 - 무역전문컨설턴트 상세 -->
<div class="page_tradesos">
	<div class="location">
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_submit();"><c:out value="${searchVO.procType eq 'I' ? '등록' : '수정'}"/></button>
			<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
		</div>
	</div>
	<div class="tit_bar">
		<h3 class="tit_block">신청정보</h3>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width:15%">
			<col>
			<col style="width:15%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" rowspan="4">증명사진</th>
				<td rowspan="4">
					<div class="form_file form_img">
<%--						<input type="file" id="imageAdd" name="expertImage" accept="image/*"  class="file_input_hidden" onchange="setPhoto(event);"/>--%>
						<input type="hidden" id="attachSeqNo" name="attachSeqNo" value="${!empty resultFile.attachSeqNo ? resultFile.attachSeqNo : "0"}"/>
						<input type="hidden" id="attachDocumId" name="attachDocumId" value="${!empty resultFile.attachDocumId ? resultFile.attachDocumId : "0"}"/>
						<figure id="photoBox">
							<c:choose>
								<c:when test="${!empty resultFile}">
									<img src="<c:out value="/cmm/fms/getMemberImage.do?attachDocumId=${resultFile.attachDocumId}&attachSeqNo=${resultFile.attachSeqNo}"/>" alt="" style="width: 108px;height: 144px;">
								</c:when>
								<c:otherwise>
									<img src="/images/admin/defaultImg.jpg" alt="" class="img_size">
								</c:otherwise>
							</c:choose>
						</figure>
						<div class="file_btn wrap">
							<label class="file_btn">
							<input type="file" name="expertImage" accept="image/*" onchange="setPhoto(event);">
							<span class="btn_tbl mb-10" >사진등록</span>
							</label>
							<strong>권장사이즈 : 108*144</strong>
						</div>
					</div>
				</td>
				<th scope="row">이름(아이디)</th>
				<td>
					<div class="flex align_center">
					<input type="text" id="name" name="name" class="form_text" value="<c:out value="${resultData.name}"/>" readonly="readonly">
					<span class="form_search ml-8">
						<input type="text" id="expertId" name="expertId" class="form_text" value="<c:out value="${resultData.expertId}"/>" readonly="readonly">
						<c:if test="${searchVO.procType eq 'I'}">
							<button type="button" class="btn_icon btn_search modal-open" data-name="consultantSearchPopup" onclick="openLayerConsultantPop()"></button>
						</c:if>
						<%--<button type="button" class="btn_icon btn_search" onclick="openLayer2('<c:url value="/system/tradeSOS/popup/consultantList.do"/>','searchPop')"></button>--%>
					</span>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">휴대전화</th>
				<td>
					<div class="flex align_center">
						<input type="hidden" id="tel" name="tel" value="<c:out value="${resultData.tel}"/>"/>
						<c:choose>
							<c:when test="${fn:length(resultData.tel) eq 10}">
								<input type="text" id="tel1"  class="form_text w100p"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,3,6)}"/>" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,6,10)}"/>" maxlength="4" numberOnly>
							</c:when>
							<c:when test="${fn:length(resultData.tel) eq 11}">
								<input type="text" id="tel1"  class="form_text w100p"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,3,7)}"/>" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="<c:out value="${fn:substring(resultData.tel,7,11)}"/>" maxlength="4" numberOnly>
							</c:when>
							<c:otherwise>
								<input type="text" id="tel1"  class="form_text w100p"  value="" maxlength="3" numberOnly>
								<input type="text" id="tel2"  class="form_text w100p ml-8" value="" maxlength="4" numberOnly>
								<input type="text" id="tel3"  class="form_text w100p ml-8" value="" maxlength="4" numberOnly>
							</c:otherwise>
						</c:choose>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">이메일</th>
				<td>
					<div class="flex align_center form_row">
						<input type="hidden" id="email" name="email" value="${resultData.email}">
						<c:choose>
							<c:when test="${!empty resultData.email}">
								<c:set var="emailSplit" value="${fn:split(resultData.email,'@')}"/>
								<input type="text" id="email1" class="form_text w100p ml-0" value="${emailSplit[0]}" maxlength="49">
								<span class="append">@</span>
								<input type="text" id="email2" class="form_text w100p" value="${emailSplit[1]}" maxlength="50">
							</c:when>
							<c:otherwise>
								<input type="text" id="email1" class="form_text w100p ml-0" maxlength="49">
								<span class="append">@</span>
								<input type="text" id="email2" class="form_text w100p" maxlength="50">
							</c:otherwise>
						</c:choose>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">직함</th>
				<td>
					<select name="itemType4" id="itemType4" class="form_select w100p">
						<option value="">전체</option>
						<c:forEach items="${jobList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${resultData.itemType4 eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">상담가능요일</th>
				<td>
					<input type="hidden" name="weekday" id="weekday" value="${resultData.weekday}">
					<label for="item_day1"><input type="checkbox" class="form_checkbox" id="item_day1" name="weekdayArr" value="0" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'0') != -1}">checked</c:if>> 일요일</label>
					<label for="item_day2"><input type="checkbox" class="form_checkbox" id="item_day2" name="weekdayArr" value="1" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'1') != -1}">checked</c:if>> 월요일</label>
					<label for="item_day3"><input type="checkbox" class="form_checkbox" id="item_day3" name="weekdayArr" value="2" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'2') != -1}">checked</c:if>> 화요일</label>
					<label for="item_day4"><input type="checkbox" class="form_checkbox" id="item_day4" name="weekdayArr" value="3" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'3') != -1}">checked</c:if>> 수요일</label>
					<label for="item_day5"><input type="checkbox" class="form_checkbox" id="item_day5" name="weekdayArr" value="4" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'4') != -1}">checked</c:if>> 목요일</label>
					<label for="item_day6"><input type="checkbox" class="form_checkbox" id="item_day6" name="weekdayArr" value="5" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'5') != -1}">checked</c:if>> 금요일</label>
					<label for="item_day7"><input type="checkbox" class="form_checkbox" id="item_day7" name="weekdayArr" value="6" <c:if test="${!empty resultData.weekday and fn:indexOf(resultData.weekday,'6') != -1}">checked</c:if>> 토요일</label>
				</td>
				<th scope="row">활동여부</th>
				<td>
					<input type="radio" class="form_radio" name="stYn" id="work" value="N" <c:if test="${empty resultData.stYn or (!empty(resultData.stYn) and resultData.stYn eq 'N')}">checked="checked"</c:if>> <label for="work">활동</label>
					<input type="radio" class="form_radio" name="stYn" id="leave" value="Y"<c:if test="${!empty(resultData.stYn) and resultData.stYn eq 'Y'}">checked="checked"</c:if>> <label for="leave">활동종료</label>
				</td>
			</tr>
			<tr>
				<th scope="row">상담분야</th>
				<td>
					<input type="hidden" name="itemType3" id="itemType3" value="${resultData.itemType3}">
					<ul class="inp_list">
						<c:forEach items="${counselingList}" var="item" varStatus="status">
							<li>
								<label for="itemType${status.count}">
									<input type="checkbox" class="form_checkbox" id="itemType${status.count}" name="itemType_arr3" value="${item.cdId}"
										   <c:if test="${!empty resultData.itemType3 and fn:indexOf(resultData.itemType3,item.cdId) != -1 }">checked</c:if>>
											<c:out value="${item.cdNm}"/>
								</label>
							</li>
						</c:forEach>
					</ul>
				</td>
				<th scope="row">전문분야</th>
				<td>
					<div class="form_row w100p">
						<input class="form_text" type="hidden" id="mtiCode" name="mtiCode"/>
						<select id="mti_code_list" size="3" style="height: 260px;" class="form_select ml-0">
								<c:out value="${resultData.mtiOptionHtml}" escapeXml="false" />
						</select>
						<div class="btn_vertical ml-8">
							<button type="button" class="btn_tbl" onclick="openLayerItemPop();">추가</button>
							<button type="button" class="btn_tbl_border" onclick="mtiCodeDel()">삭제</button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">학력</th>
				<td colspan="3">
					<textarea id="scholar" name="scholar" rows="3" class="form_textarea" maxlength="650" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.scholar}"/></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">자격증</th>
				<td colspan="3">
					<textarea id="license" name="license" rows="3" class="form_textarea" maxlength="300" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.license}"/></textarea>
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





	$("input:text[numberOnly]").on({
		keyup: function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		},
		focusout : function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		}
	});



	function mtiCodeDel(){
		var selectedObj = $('#mti_code_list option:selected');
		if(selectedObj.length < 0){
			alert('삭제할 전문분야를 선택해주세요');
			return false;
		}else{
			$('#mti_code_list option:selected')[0].remove();
		}
	}


	function fc_chk_byte(obj, max_byte){
		var objStr = obj.value;
		var byteLength = 0; ;		//common
		for(var i=0; i < objStr.length; i++){
			var oneChar = escape(objStr.charAt(i));
			if( oneChar.length == 1 )
				byteLength ++;
			else if(oneChar.indexOf("%u") != -1)
				byteLength += 2;
			else if(oneChar.indexOf("%") != -1)
				byteLength += oneChar.length/3;
		}

		// 전체길이를 초과하면
		if(byteLength > max_byte){		// 입력된 > 맥스
			alert(max_byte + " 바이트를 초과 입력할수 없습니다. 현재 " + byteLength + "Byte입니다.");
			obj.focus();
			return false;
		}
		return true;
	}

	function fn_submit(){
		var text = '<c:out value="${searchVO.procType eq 'I' ? '등록' : '수정'}"/>';
		if (confirm(text+' 하시겠습니까?')) {
			var form = eval("document.registForm");
			var weekArray = new Array();
			var itemType3Array = new Array();
			var mtiCodeArray = new Array();

			if (form.expertId.value == "" || form.name.value == "") {
				alert("컨설턴트 찾기 팝업을 클릭하여 컨설턴트를 선택하셔야 합니다.");
				return;
			}

			if ($('#itemType4').val() == "") {
				alert("직함을 선택하셔야 합니다.");
				$('#itemType4').focus();
				return;
			}

			if ($('#email1').val == '' || $('#email2').val == '') {
				alert('이메일를 입력해주세요');
				$('#email1').focus();
				returnVal = false;
				return false;
			} else {
				$('#email').val($('#email1').val() + '@' + $('#email2').val());
				var emailExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
				if (!emailExp.test($('#email').val())) {
					alert("이메일주소가 유효하지 않습니다.");
					$('#email1').focus();
					returnVal = false;
					return;
				}
			}

		if(fc_chk_byte(form.scholar, 2000) == false){ //학력
			return;
		}

		if(fc_chk_byte(form.license, 1000) == false){ //자격증
			return;
		}

			var itemType3_arr = "";
			var itemType3Chk = document.getElementsByName("itemType_arr3");

			var ic = 0;
			for (var i = 0; i < itemType3Chk.length; i++) {
				if (itemType3Chk[i].checked == true) {
					if (itemType3_arr == "") {
						if (itemType3Chk[i].value == '009') ic = 1;

						itemType3_arr += itemType3Chk[i].value;
					} else {
						if (itemType3Chk[i].value == '009') ic = 1;
						itemType3_arr += "," + itemType3Chk[i].value;
					}
				}
			}

			if (itemType3_arr == "") {
				alert("최소 한개의 상담분야를 선택하셔야 합니다.");
				form.itemType_arr3[0].focus();
				return;
			}

			form.expertGrp.value = "004";

			// 해외인증
			if (ic == 1) {
				var mtiList = form.mti_code_list;
				var mtiListArr = "";

				if (mtiList.length <= 0) {
					alert('전문분야를 선택해주세요.');
					return;
				}

				var day_gubun_arr = "";
				var day_gubunChk = document.getElementsByName("weekdayArr");

				for (var i = 0; i < day_gubunChk.length; i++) {
					if (day_gubunChk[i].checked == true) {
						if (day_gubun_arr.length == 0)
							day_gubun_arr += day_gubunChk[i].value;
						else
							day_gubun_arr += "," + day_gubunChk[i].value;
					}
				}

				if (day_gubun_arr == "") {
					alert("최소 한개의 상담가능 요일를 선택하셔야 합니다.");
					day_gubunChk[0].focus();
					return;
				}
				form.expertGrp.value = "009";
			} else {
				form.weekday.value = "";
				form.mtiCode.value = "";
			}

			//전화번호
			if ($('#tel1').val() != '' && $('#tel2').val() != '' && $('#tel3').val() != '') {
				$('#tel').val('');
				$('#tel').val($('#tel1').val() + $('#tel2').val() + $('#tel3').val())
			}
			//이메일
			if ($('#email1').val() != '' && $('#email2').val() != '') {
				$('#email').val('');
				$('#email').val($('#email1').val() + '@' + $('#email2').val());
			}

			$('input[name="weekdayArr"]:checked').each(function () {
				weekArray.push($(this).val());
				$('#weekday').val(String(weekArray.join()));
			});

			$('input[name="itemType_arr3"]:checked').each(function () {
				itemType3Array.push($(this).val());
				$('#itemType3').val(String(itemType3Array.join()));
			});

			$('#mti_code_list option').each(function () {
				mtiCodeArray.push($(this).val());
				$('#mtiCode').val(String(mtiCodeArray.join()));
			});

			global.ajaxSubmit($('#registForm'), {
				type: 'POST'
				, url: '<c:url value="/tradeSOS/com/professionalMemberProc.do" />'
				, enctype: 'multipart/form-data'
				, dataType: 'json'
				, async: false
				, spinner: true
				, success: function (data) {
					if (data.FLAG) {
						fn_list();
					} else {
						alert(data.msg);
						return false;
					}
				},
				error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			});
		}
	}

	// 증명사진 등록
	function setPhoto(event) {
		var reader = new FileReader();
		reader.onload = function(event) {
			var img = document.createElement("img");
			img.setAttribute("src", event.target.result);
			img.setAttribute("style", "width: 108px;height: 144px;border: 1px solid #dbdcde;vertical-align: top;");
			var imgBox = document.querySelector("#photoBox");
			$(imgBox).html('');
			imgBox.appendChild(img)
		};
		reader.readAsDataURL(event.target.files[0]);
	}
</script>
