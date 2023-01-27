<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="registForm" name="registForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="activeYn" value="${resultData.activeYn}" />
<input type="hidden" name="calculateYn" value="${resultData.calculateYn}" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
	</div>
</div>
<div class="cont_block">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">증명사진</th>
				<td colspan="3">
					<div class="form_file image_add">
						<figure id="photoBox" class="photo">
							<c:choose>
								<c:when test="${not empty resultData.expertFileVO}">
									<img src="<c:url value='/tradeSOS/exp/expertImage.do' />?fileId=${resultData.expertFileVO.fileId}&fileSeq=${resultData.expertFileVO.fileSeq}" style="width: 108px;height: 144px;vertical-align: top;border: 1px solid #dbdcde;" alt="" />
								</c:when>
								<c:otherwise>
									<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
								</c:otherwise>
							</c:choose>
						</figure>
					</div>
					<div style="margin-top: 5px;">
						<label for="imageAdd" class="btn_tbl file_input_button" style="cursor: pointer;">사진등록</label>
						<input type="hidden" id="pictureFileId" name="pictureFileId" value="${not empty resultData.pictureFileId ? resultData.pictureFileId : '0'}" />
						<input type="file" id="imageAdd" name="pictureFiles" onchange="setPhoto(event);" accept="image/*" class="file_input_hidden"
							style="width: 100%;position: absolute;font-size: 0;top: inherit;right: 0px;bottom: 0;opacity: 0;cursor: pointer;" 
						/>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">이름</th>
				<td>
					${resultData.expertNm}
					<input type="hidden" id="expertId" name="expertId" value="${resultData.expertId}" />
					<input type="hidden" id="expertNm" name="expertNm" value="${resultData.expertNm}" />
				</td>
				<th scope="row">생년월일</th>
				<td>${resultData.birthDay}</td>
			</tr>
			<tr>
				<th scope="row">성별</th>
				<td>${resultData.sex}</td>
				<th scope="row">채용기간</th>
				<td>
					<c:if test="${not empty resultData.recruitStDate and not empty resultData.recruitEdDate}">
						${resultData.recruitStDate} ~ ${resultData.recruitEdDate}
					</c:if>
					<input type="hidden" id="recruitStDate" name="recruitStDate" value="${resultData.recruitStDate}" />
					<input type="hidden" id="recruitEdDate" name="recruitEdDate" value="${resultData.recruitEdDate}" />
				</td>
			</tr>
			<tr>
				<th scope="row">휴대전화 국내 <strong class="point">*</strong> / 해외</th>
				<td>
					<input type="text" id="cellPhone1" name="cellPhone1" value="${resultData.cellPhone1}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="cellPhone2" name="cellPhone2" value="${resultData.cellPhone2}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="cellPhone3" name="cellPhone3" value="${resultData.cellPhone3}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					&nbsp;&nbsp;
					해외 :
					&nbsp;
					<input type="text" id="foreignMobilePhone" name="foreignMobilePhone" value="${resultData.foreignMobilePhone}" maxlength="20" class="form_text" style="width: 35%;" placeHolder="ex>821011112222" />
				</td>
				<th scope="row">전화</th>
				<td>
					<input type="text" id="tel1" name="tel1" value="${resultData.tel1}" maxlength="4" class="form_text" style="width: 25%;" numberOnly />
					<input type="text" id="tel2" name="tel2" value="${resultData.tel2}" maxlength="4" class="form_text" style="width: 25%;" numberOnly />
					<input type="text" id="tel3" name="tel3" value="${resultData.tel3}" maxlength="4" class="form_text" style="width: 25%;" numberOnly />
				</td>
			</tr>
			<tr>
				<th scope="row">이메일 <strong class="point">*</strong></th>
				<td>
					<c:set var="emailSplit" value="${fn:split(resultData.email, '@')}" />
					<input type="text" id="email1" value="${emailSplit[0]}" maxlength="50" class="form_text" style="width: 40%;" />
					@
					<input type="text" id="email2" value="${emailSplit[1]}" maxlength="50" class="form_text" style="width: 40%;" />
					<input type="hidden" id="email" name="email" value="${resultData.email}" />
				</td>
				<th scope="row">활동국가 <strong class="point">*</strong></th>
				<td>
					<select id="atvCtrCd" name="atvCtrCd" onchange="setRegion(this.value);" class="form_select">
						<c:forEach var="item" items="${nationList}" varStatus="status">
							<option value="${item.CODE}" <c:if test="${item.CODE eq resultData.atvCtrCd}">selected="selected"</c:if>>${item.CODE_NM}</option>
						</c:forEach>
					</select>
					<select id="atvAreaCd" name="atvAreaCd" class="form_select">
						<option value="">전체</option>
						<c:forEach var="item" items="${regionList}" varStatus="status">
							<option value="${item.cdId}" <c:if test="${item.cdId eq resultData.atvAreaCd}">selected="selected"</c:if>>${item.cdNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">자기소개 문구 <strong class="point">*</strong></th>
				<td colspan="3">
					<input type="text" id="selfIntro" name="selfIntro" value="${resultData.selfIntro}" maxlength="15" class="form_text" style="width: 40%;" />
				</td>
			</tr>
			<tr style="display: none;">
				<th scope="row">지원 전문가 분야</th>
				<td colspan="3">
					<ul class="inp_list consultTypeCheckbox">
						<c:forEach var="item" items="${consultList}" varStatus="status1">
							<li>
								<label for="item_type${status1.count}">
									<input type="checkbox" id="item_type${status1.count}" name="consultList[${status1.index}].consultTypeCds" value="${item.CONSULT_TYPE_CD}" class="form_checkbox"
										<c:forEach var="resultData" items="${consultingList}" varStatus="status2">
											<c:if test="${item.CONSULT_TYPE_CD eq resultData.consultTypeCd}">checked="checked" disabled="disabled"</c:if>
										</c:forEach>
									>
									${item.CONSULT_TYPE_NM}
								</label>
							</li>
						</c:forEach>
					</ul>
				</td>
			</tr>
			<tr id="eduClass">
				<th scope="row">학력 <strong class="point">*</strong></th>
				<td colspan="3">
					<c:set var="educationListLength" value="${fn:length(educationList) > 0 ? fn:length(educationList) : 0}" />
					<input type="hidden" id="educationListLength" value="${educationListLength}" />
					<div class="addInput">
						<c:forEach var="item" items="${educationList}" varStatus="status">
							<div class="add_line">
								<input type="hidden" name="educationList[${status.index}].educationSeqs" value="${item.educationSeq}" />
								<input type="text" name="educationList[${status.index}].edus" value="${item.edu}" maxlength="100" class="form_text" style="width: 40%;" />
								<c:choose>
									<c:when test="${status.first}">
										<button type="button" onclick="addLine(this);" class="btn_tbl_border" data-flag="edu">추가</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="deleteRow(this);" class="btn_tbl_border">삭제</button>
									</c:otherwise>
								</c:choose>
							</div>
						</c:forEach>
						<c:if test="${fn:length(educationList) == 0}">
							<div class="add_line">
								<input type="hidden" name="educationList[0].educationSeqs" value="" />
								<input type="text" name="educationList[0].edus" value="" maxlength="100" class="form_text" style="width: 40%;" />
								<button type="button" onclick="addLine(this);" class="btn_tbl_border" data-flag="edu">추가</button>
							</div>
						</c:if>
					</div>
				</td>
			</tr>
			<tr id="licenseClass">
				<th scope="row">자격증</th>
				<td colspan="3">
					<c:set var="licenseListLength" value="${fn:length(licenseList) > 0 ? fn:length(licenseList) : 0}" />
					<input type="hidden" id="licenseListLength" value="${licenseListLength}" />
					<div class="addInput">
						<c:forEach var="item" items="${licenseList}" varStatus="status">
							<div class="add_line">
								<input type="hidden" name="licenseList[${status.index}].licenseSeqs" value="${item.licenseSeq}" />
								<input type="text" name="licenseList[${status.index}].licenses" value="${item.license}" maxlength="30" class="form_text" style="width: 40%;" />
								<c:choose>
									<c:when test="${status.first}">
										<button type="button" onclick="addLine(this);" class="btn_tbl_border" data-flag="license">추가</button>
									</c:when>
									<c:otherwise>
										<button type="button" onclick="deleteRow(this);" class="btn_tbl_border">삭제</button>
									</c:otherwise>
								</c:choose>
							</div>
						</c:forEach>
						<c:if test="${fn:length(licenseList) == 0}">
							<div class="add_line">
								<input type="hidden" name="licenseList[0].licenseSeqs" value="1" />
								<input type="text" name="licenseList[0].licenses" value="" maxlength="30" class="form_text" style="width: 40%;" />
								<button type="button" onclick="addLine(this);" class="btn_tbl_border" data-flag="license">추가</button>
							</div>
						</c:if>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row">주요이력 <strong class="point">*</strong></th>
				<td colspan="3">
					<textarea id="majorHistory" name="majorHistory" rows="5" maxlength="300" onkeyup="return textareaMaxLength(this);" class="form_textarea"><c:out value="${resultData.majorHistory}" escapeXml="false"/></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">주상담분야</th>
				<td colspan="3">
					<textarea id="majorConsult" name="majorConsult" rows="5" maxlength="1200" onkeyup="return textareaMaxLength(this);" class="form_textarea"><c:out value="${resultData.majorConsult}" escapeXml="false"/></textarea>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<c:if test="${fn:length(proofList) > 0}">
	<div class="cont_block" style="margin-top: 20px;">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">증빙첨부파일</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col style="width: 35%;" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">증빙구분</th>
					<th scope="col">파일</th>
					<th scope="col">비고</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="item" items="${proofList}" varStatus="status">
					<tr>
						<th scope="row">${item.proofNm}</th>
						<td id="attachFieldList">
							<div class="addedFile" style="margin-top: 10px;">
								<a href="<c:url value='/tradeSOS/exp/expertFileDownload.do' />?fileId=${item.expertFileVO.fileId}&fileSeq=${item.expertFileVO.fileSeq}" class="filename">${item.expertFileVO.orgFileNm}</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.expertFileVO.fileId}&fileSeq=${item.expertFileVO.fileSeq}', '${item.expertFileVO.orgFileNm}', 'membershipexpert_${profile}_${item.expertFileVO.fileId}_${item.expertFileVO.fileSeq}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</td>
						<td>${item.dscr}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</c:if>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		$('.consultTypeCheckbox li').each(function(){
			$('input[type=checkbox]').attr('disabled', true);
		});

		var atvCtrCd = '${resultData.atvCtrCd}';
		
		if (atvCtrCd == 'KR') {
			$('#atvAreaCd').show();
		} else {
			$('#atvAreaCd').val('');
			$('#atvAreaCd').hide();
		}
	});
	
	// 학력, 자격증 추가
	function addLine(obj) {
		var addInput = $(obj).parents(".addInput");
		addInput.append(
			'<div class="add_line" style="overflow: hidden;margin-top: 10px;">'
			+ '	<input type="text" id="" name="" class="form_text" style="width: 40%;" />'
			+ ' <button type="button" onclick="deleteRow(this);" class="btn_tbl_border">삭제</button>'
			+ '</div>'
		);
	}
	
	// 학력, 자격증 삭제
	function deleteRow(obj) {
		var clickedRow = $(obj).parent(".add_line");
		clickedRow.remove();
	}
	
	// 증명사진 등록
	function setPhoto(event) {
		var reader = new FileReader();
		reader.onload = function(event){
			var img = document.createElement('img');
			img.setAttribute('src', event.target.result);
			img.setAttribute('style', 'width: 108px;height: 144px;vertical-align: top;border: 1px solid #dbdcde;');
			var imgBox = document.querySelector('#photoBox');
			$(imgBox).html('');
			imgBox.appendChild(img);
		};
		
		reader.readAsDataURL(event.target.files[0]);
	}

	function setRegion(val){
		if (val.trim() == 'KR'.trim()) {
			$('#atvAreaCd').show();
		} else {
			$('#atvAreaCd').val('');
			$('#atvAreaCd').hide();
		}
	}
	
	function isValid() {
		var returnVal = true;
		
		if (($('#cellPhone1').val() != '' || $('#cellPhone2').val() != '' || $('#cellPhone3').val() != '') && $('#foreignMobilePhone').val() != '') {
			if (!confirm('국내/해외 휴대전화가 모두 입력되어있으면 [국내] 휴대전화 번호로 알림톡이 발송됩니다.\n[국내] 휴대전화 번호로 알립톡을 받으시겠습니까?')) {
				$('#foreignMobilePhone').focus();
				
				returnVal = false;
				return false;	
			}
		}

		if ($('#email1').val == '' || $('#email2').val == '') {
			alert('이메일를 입력해 주세요.');
			
			$('#email1').focus();
			
			returnVal = false;
			return false;
		} else {
			$('#email').val($('#email1').val() + '@' + $('#email2').val());
			
			var emailExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (!emailExp.test($('#email').val())) {
				alert('이메일주소가 유효하지 않습니다.');
				
				$('#email1').focus();
				
				returnVal = false;
				return;
			}
		}

		if ($('#atvCtrCd').val() == '') {
			alert('활동국가를 선택해 주세요.');
			
			$('#atvCtrCd').focus();
			
			returnVal = false;
			return false;
		}

		if ($('#selfIntro').val() == '') {
			alert('15글자 이내로 자기소개 문구를 입력해 주세요.');
			
			$('#selfIntro').focus();
			
			returnVal = false;
			return false;
		}

		if (!$('#majorHistory').val().replace(/(^\s*)|(\s*$)/gi, '')) {
			alert('주요이력을 입력해 주세요.');
			
			$('#majorHistory').focus();
			
			return;
		}

		// 학력정렬
		if (returnVal) {
			if ($('#eduClass td:eq(0) .addInput .add_line').length > 0) {
				$('#eduClass td:eq(0) .addInput .add_line').each(function(i,e){
					$('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').attr('name','educationList[' + i + '].edus');
					$('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="hidden"]').attr('name','educationList[' + i + '].educationSeqs');
					
					if ($('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').val() == '') {
						alert((i + 1) + '번째 학력을 입력해 주세요.');
						
						returnVal = false;
					}
				});
			}
		}

		return returnVal;
	}
	
	function doSave() {
		if (isValid()) {
			if (confirm('수정 하시겠습니까?')) {
				$('.consultTypeCheckbox li').each(function(){
					$('input[type=checkbox]').removeAttr('disabled');
				});

				global.ajaxSubmit($('#registForm'), {
					type : 'POST'
					, url : '<c:url value="/tradeSOS/mypage/expertMemberProc.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if (data.FLAG) {
							window.location.reload();
						} else {
							alert('문제가 발생했습니다.');
							
							return false;
						}
			        }
				});
			}
		}
	}	
</script>