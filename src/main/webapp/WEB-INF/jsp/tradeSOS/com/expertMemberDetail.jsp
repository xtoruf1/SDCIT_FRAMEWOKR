<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
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
<!-- <script type="text/javascript" src="/js/tradeSosComm.js"></script> -->
<script type="text/javascript">
	var atvCtrCd = '<c:out value="${resultData.atvCtrCd}"/>';
	$(document).ready(function(){
		$("input:text[numberOnly]").on({
			keyup: function() {
				$(this).val($(this).val().replace(/[^0-9]/g,""));
			},
			focusout : function() {
				$(this).val($(this).val().replace(/[^0-9]/g,""));
			}
		});

		if(atvCtrCd == "KR"){
			$('#atvAreaCd').show();
		}else{
			$('#atvAreaCd').val('');
			$('#atvAreaCd').hide();
		}

	});
	function press(event) {
		if (event.keyCode==13) {

		}
	}
	function goList() {
		document.listForm.action = "/tradeSOS/com/expertMember.do";
		document.listForm.submit();
	}

	// 학력, 자격증 추가
	function addLine(obj){
		var addInput = $(obj).parents(".addInput");
		addInput.append(
			'<div class="add_line">'
			+ '<input type="text" id="" name="" class="form_text">'
			+ ' <button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="deleteRow(this);">삭제</button>'
			+ '</div>'
		);
	}
	// 학력, 자격증 삭제
	function deleteRow(obj){
		var clickedRow = $(obj).parent(".add_line");
		clickedRow.remove();
	}

	// 레이어 팝업
	function openLayer(IdName){
		var openPop = $('#' + IdName);
		openPop.show();
	}
	function closePop(IdName) {
		var openPop = $('#' + IdName);
		openPop.hide();
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



	function fn_modify(){
		if(confirm("수정 하시겠습니까?")){
			if(checkValidate()){
				var formData = new FormData($('#registForm')[0]);

				global.ajaxSubmit($('#registForm'), {
					type : 'POST'
					, url : '<c:url value="/tradeSOS/com/expertMemberProc.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if (data.FLAG) {
							goList();
						} else {
							alert(data.msg);
							return false;
						}
			        }
				});

			}
		}
	}

	function checkValidate(){
		let returnVal = true;

		if( ($('#cellPhone1').val() != '' || $('#cellPhone2').val() != '' || $('#cellPhone3').val() != '') && $('#foreignMobilePhone').val() != '' ){

			if( !confirm('국내/해외 휴대전화가 모두 입력되어있으면 [국내] 휴대전화 번호로 알림톡이 발송됩니다.\n[국내] 휴대전화 번호로 알림톡을 받으시겠습니까?') ) {
				returnVal = false;
				$('#foreignMobilePhone').focus();
				return false;
			}
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

		if($('#atvCtrCd').val() == ''){
			alert('활동국가를 선택해주세요');
			$('#atvCtrCd').focus();
			returnVal = false;
			return false;
		}

		if($('#selfIntro').val() == ''){
			alert('15글자 이내로 자기소개 문구를 입력해주세요');
			$('#selfIntro').focus();
			returnVal = false;
			return false;
		}


		if(!$('#majorHistory').val().replace(/(^\s*)|(\s*$)/gi, "")){
			alert("주요이력을 입력해주세요");
			$('#majorHistory').focus();
			return;
		}

		/*if(!$('#selfIntro').val().replace(/(^\s*)|(\s*$)/gi, "")){
			alert("자기소개를 입력해주세요");
			$('#selfIntro').focus();
			return;
		}*/

		//학력정렬
		if(returnVal){
			if($('#eduClass td:eq(0) .addInput .add_line').length > 0){
				$('#eduClass td:eq(0) .addInput .add_line').each(function(i,e){
					$('#eduClass td:eq(0) .addInput .add_line:eq('+i+') input[type="text"]').attr('name','educationList['+i+'].edus');
// 					$('#eduClass td:eq(0) .addInput .add_line:eq('+i+') input[type="hidden"]').attr('name','educationList['+i+'].educationSeqs');
					if($('#eduClass td:eq(0) .addInput .add_line:eq('+i+') input[type="text"]').val() == ''){
						alert('학력을 입력하세요');
						returnVal = false;
						return false;
					}
				});
			}
		}

		//자격증정렬
		/* if(returnVal){
			if($('#licenseClass td:eq(0) .addInput .add_line').length > 0){
				$('#licenseClass td:eq(0) .addInput .add_line').each(function(i,e){
					$('#licenseClass td:eq(0) .addInput .add_line:eq('+i+') input[type="text"]').attr('name','licenseList['+i+'].licenses');
					$('#licenseClass td:eq(0) .addInput .add_line:eq('+i+') input[type="hidden"]').attr('name','licenseList['+i+'].licenseSeqs');
					if($('#licenseClass td:eq(0) .addInput .add_line:eq('+i+') input[type="text"]').val() == ''){
						alert((i+1) + '번째 자격증을 입력하세요');
						returnVal = false;
					}
				});
			}
		} */

		return returnVal;
	}

	function fn_region(val){
		if(val.trim() == 'KR'.trim()){
			$('#atvAreaCd').show();
		}else{
			$('#atvAreaCd').val('');
			$('#atvAreaCd').hide();
		}
	}


</script>

<form name="listForm" id="listForm" method="post">
	<c:forEach var="params" items="${param}"  varStatus="status">
		<input type="hidden" id="<c:out value="${params.key}"/>" name="<c:out value="${params.key}"/>" value="<c:out value="${params.value}"/>" />
	</c:forEach>
</form>

<form name="registForm" id="registForm" method="post" encType="multipart/form-data">
	<input type="hidden" name="topMenuId" value="" />

<!-- 컨설턴트/전문가 관리 - 전문가 상세 -->
<div class="page_tradesos">
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<!-- 검색 테이블 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_modify();">저장</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
		</div>
	</div>

	<div class="cont_block">
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
						<div class="form_file form_img">
								<input type="hidden" name="pictureFileId" id="pictureFileId" value="${!empty resultData.pictureFileId ? resultData.pictureFileId : "0"}" />
<%--							<input type="hidden" id="attachDocumFg" name="attachDocumFg" value=""/>--%>
							<figure id="photoBox" class="photo_img">
								<c:choose>
									<c:when test="${!empty resultData.expertFileVO}">
										<img src='<c:out value="/tradeSOS/exp/expertImage.do?fileId=${resultData.expertFileVO.fileId}&fileSeq=${resultData.expertFileVO.fileSeq}"/>' alt="" style="width: 108px;height: 144px;">
									</c:when>
									<c:otherwise>
										<img src="/images/admin/defaultImg.jpg" alt="" class="img_size">
									</c:otherwise>
								</c:choose>
							</figure>
							<label class="file_btn">
								<input type="file"  id="imageAdd" name="pictureFiles" accept="image/*" onchange="setPhoto(event);">
								<span class="btn_tbl mt-5">사진등록</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td>
						<input type="hidden" id="expertId" name="expertId" value="<c:out value="${resultData.expertId}"/>">
						<input type="hidden" id="expertNm" name="expertNm" class="w160x" value="<c:out value="${resultData.expertNm}"/>">
						<c:out value="${resultData.expertNm}"/>
					</td>
					<th scope="row">생년월일</th>
					<td>
						<c:out value="${resultData.birthDay}"/>
					</td>
				</tr>
				<tr>
					<th scope="row">성별</th>
					<td>
						<c:out value="${resultData.sex}"/>
					</td>
					<th scope="row">채용기간</th>
					<td>
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="recruitStDate" name="recruitStDate" value="<c:out value="${resultData.recruitStDate}"/>" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
									<img src="/images/icon_calender.png" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('recruitStDate');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="recruitEdDate" name="recruitEdDate" value="<c:out value="${resultData.recruitEdDate}"/>" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
									<img src="/images/icon_calender.png" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('recruitEdDate');" class="dateClear"><img src="/images/admin/btn_clear.png" alt="초기화" /></button>
							</div>
						</div>
					</td>
				</tr>

				<tr>
					<th scope="row">휴대전화<br> 국내/해외</th>
					<td>
						<div class="form_row w100p">
							<span class="prepend mr-8">국내 :</span>
							<div class="flex align_center w100p">
								<input type="text" id="cellPhone1" name="cellPhone1" class="form_text w100p" value="<c:out value="${resultData.cellPhone1}"/>" maxlength="3" numberOnly>
								<input type="text" id="cellPhone2" name="cellPhone2" class="form_text w100p ml-8" value="<c:out value="${resultData.cellPhone2}"/>" maxlength="4" numberOnly>
								<input type="text" id="cellPhone3" name="cellPhone3" class="form_text w100p ml-8" value="<c:out value="${resultData.cellPhone3}"/>" maxlength="4" numberOnly>
							</div>
						</div>
						<br>
						<div class="form_row w100p mt-10">
							<span class="prepend mr-8">해외 :</span>
							<input type="text" id="foreignMobilePhone" name="foreignMobilePhone" class="form_text w100p" value="<c:out value="${resultData.foreignMobilePhone}"/>" placeHolder="ex>821011112222" maxlength="20">
						</div>
					</td>
					<th scope="row">전화</th>
					<td>
						<div class="flex align_center">
							<input type="text" id="tel1" name="tel1" class="form_text w100p" value="<c:out value="${resultData.tel1}"/>" maxlength="3" numberOnly>
							<input type="text" id="tel2" name="tel2" class="form_text w100p ml-8" value="<c:out value="${resultData.tel2}"/>" maxlength="4" numberOnly>
							<input type="text" id="tel3" name="tel3" class="form_text w100p ml-8" value="<c:out value="${resultData.tel3}"/>" maxlength="4" numberOnly>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<div class="flex align_center">
							<input type="hidden" id="email" name="email" value="${resultData.email}">
							<c:set var="emailSplit" value="${fn:split(resultData.email,'@')}"/>
							<input type="text" id="email1" class="form_text w100p" value="${emailSplit[0]}">
							<span class="spacing">@</span>
							<input type="text" id="email2" class="form_text w100p" value="${emailSplit[1]}">
						</div>
					</td>
					<th scope="row">활동국가</th>
					<td>
						<select class="form_select" onchange="fn_region(this.value);" name="atvCtrCd" id="atvCtrCd">
	 						<c:forEach items="${nationList}" var="item" varStatus="status">
	 							<option value="${item.CODE}" <c:if test="${item.CODE eq resultData.atvCtrCd}">selected</c:if>><c:out value="${item.CODE_NM}"/></option>
	 						</c:forEach>
						</select>

							<select class="form_select" name="atvAreaCd" id="atvAreaCd">
								<option value="">전체</option>
								<c:forEach items="${regionList}" var="item" varStatus="status">
									<option value="${item.cdId}" <c:if test="${item.cdId eq resultData.atvAreaCd}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:forEach>
							</select>

					</td>
				</tr>
				<tr>
					<th scope="row">자기소개 문구</th>
					<td>
						<%--<textarea id="selfIntro" name="selfIntro" rows="3" class="w100p"><c:out value="${resultData.selfIntro}" escapeXml="false"/></textarea>--%>
						<input type="text" name="selfIntro" id="selfIntro" class="form_text w100p" value="<c:out value="${resultData.selfIntro}"/>" maxlength="15">
					</td>
					<th scope="row">활동여부</th>
					<td>
						<label class="label_form">
							<input type="radio" class="form_radio" id="activeY" name="activeYn" value="Y" <c:if test="${resultData.activeYn eq 'Y'}">checked="checked"</c:if> >
							<span class="starb1 on label">활동</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" id="activeN" name="activeYn" value="N" <c:if test="${resultData.activeYn eq 'N'}">checked="checked"</c:if> >
							<span class="starb2 on label">미활동</span>
						</label>
					</td>
				</tr>


				<tr>
					<th scope="row">지원 전문가 분야</th>
					<td colspan="3">
						<ul class="inp_list">
							<c:forEach items="${consultList}" var="item" varStatus="i">
								<li>
									<label for="item_type${i.count}" class="label_form">
										<input type="checkbox" class="form_checkbox" id="item_type${i.count}" name="consultList[${i.index}].consultTypeCds" value="<c:out value="${item.CONSULT_TYPE_CD}"/>"
										<c:forEach items="${consultingList}" var="resultData" varStatus="j">
											   <c:if test="${item.CONSULT_TYPE_CD eq resultData.consultTypeCd}">checked</c:if>
										</c:forEach>
										>
										<span class="label"><c:out value="${item.CONSULT_TYPE_NM}"/></span>
									</label>
								</li>
							</c:forEach>
						</ul>
					</td>
				</tr>
				<tr id="eduClass">
					<th scope="row">학력</th>
					<td colspan="3">
						<c:set var="educationListLength" value="${fn:length(educationList) > 0 ? fn:length(educationList) : 0 }"/>
						<input type="hidden" id="educationListLength" value="${educationListLength}"/>
						<div class="addInput">
							<c:forEach items="${educationList}" var="item" varStatus="status">
								<div class="add_line">
	<%-- 								<input type="hidden" name="educationList[${status.index}].educationSeqs" value="<c:out value="${item.educationSeq}"/>"> --%>
									<input type="text" name="educationList[${status.index}].edus" class="form_text" value="<c:out value="${item.edu}"/>">
									<c:choose>
										<c:when test="${status.first}">
											<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="addLine(this);" data-flag="edu">추가</button>
										</c:when>
										<c:otherwise>
											<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="deleteRow(this);">삭제</button>
										</c:otherwise>
									</c:choose>
								</div>
							</c:forEach>
							<c:if test="${fn:length(educationList) == 0}">
								<div class="add_line">
	<!-- 								<input type="hidden" name="educationList[0].educationSeqs" value=""> -->
									<input type="text" name="educationList[0].edus" class="form_text" value="">
									<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="addLine(this);" data-flag="edu">추가</button>
								</div>
							</c:if>
						</div>
					</td>
				</tr>
				<tr id="licenseClass">
					<th scope="row">자격증</th>
					<td colspan="3">
						<c:set var="licenseListLength" value="${fn:length(licenseList) > 0 ? fn:length(licenseList) : 0 }"/>
						<input type="hidden" id="licenseListLength" value="${licenseListLength}"/>
						<div class="addInput">
							<c:forEach items="${licenseList}" var="item" varStatus="status">
								<div class="add_line">
									<input type="hidden" name="licenseList[${status.index}].licenseSeqs" value="<c:out value="${item.licenseSeq}"/>">
									<input type="text" name="licenseList[${status.index}].licenses" class="form_text" value="<c:out value="${item.license}"/>">
									<c:choose>
										<c:when test="${status.first}">
											<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="addLine(this);" data-flag="license">추가</button>
										</c:when>
										<c:otherwise>
											<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="deleteRow(this);">삭제</button>
										</c:otherwise>
									</c:choose>
								</div>
							</c:forEach>
							<c:if test="${fn:length(licenseList) == 0}">
								<div class="add_line">
									<input type="hidden" name="licenseList[0].licenseSeqs" value="1"/>
									<input type="text" name="licenseList[0].licenses" class="form_text" value=""/>
									<button type="button" class="btn_tbl btn_modify_auth btnUpdateReply" onclick="addLine(this);" data-flag="license">추가</button>
								</div>
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">주요이력</th>
					<td colspan="3">
						<textarea name="majorHistory" id="majorHistory" rows="3" class="form_textarea"><c:out value="${resultData.majorHistory}" escapeXml="false"/></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">주상담분야</th>
					<td colspan="3">
						<textarea name="majorConsult" id="majorConsult" rows="3" class="form_textarea"><c:out value="${resultData.majorConsult}" escapeXml="false"/></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">정산여부</th>
					<td colspan="3">
						<label class="label_form">
							<input type="radio" class="form_radio" id="calculateY" name="calculateYn" value="Y" <c:if test="${resultData.calculateYn eq 'Y'}">checked="checked"</c:if> >
							<span class="starb1 on label">정산</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" id="calculateN" name="calculateYn" value="N" <c:if test="${resultData.calculateYn eq 'N'}">checked="checked"</c:if> >
							<span class="starb2 on label">고정급</span>
						</label>
					</td>
				</tr>
			</tbody>
		</table><!-- // 전문가 상세 테이블-->
	</div>

	<c:if test="${fn:length(proofList) > 0}">
	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">증빙첨부파일</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">증빙구분</th>
					<th scope="col">파일</th>
					<th scope="col">비고</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${proofList}" var="item" varStatus="status">
				<tr>
					<th scope="row"><c:out value="${item.proofNm}"/></th>
					<td id="attachFieldList">
							<div class="addedFile">
								<a href="<c:url value='/tradeSOS/exp/expertFileDownload.do' />?fileId=${item.expertFileVO.fileId}&fileSeq=${item.expertFileVO.fileSeq}" class="filename">
									<c:out value="${item.expertFileVO.orgFileNm}"/>
								</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.expertFileVO.fileId}&fileSeq=${item.expertFileVO.fileSeq}', '${item.expertFileVO.orgFileNm}', 'membershipboard_${profile}_${item.expertFileVO.fileId}_${item.expertFileVO.fileSeq}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
					</td>
					<td><c:out value="${item.dscr}"/></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	</c:if>
</div> <!-- // .page_tradesos -->
</form>


