<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="listForm" name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchFromDate" value="${param.searchFromDate}" />
<input type="hidden" name="searchToDate" value="${param.searchToDate}" />
<input type="hidden" name="searchConsult" value="${param.searchConsult}" />
<input type="hidden" name="searchNation" value="${param.searchNation}" />
<input type="hidden" name="searchRegion" value="${param.searchRegion}" />
<input type="hidden" name="searchStatusCd" value="${param.searchStatusCd}" />
<input type="hidden" name="searchExpertNm" value="${param.searchExpertNm}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="registForm" name="registForm" method="post" encType="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="statusCd" name="statusCd" value="${resultData.statusCd}" />
<input type="hidden" id="applicationId" name="applicationId" value="${resultData.applicationId}" />
<input type="hidden" id="recruitStDate" name="recruitStDate" value="" />
<input type="hidden" id="recruitEdDate" name="recruitEdDate" value="" />
<!-- 페이지 위치 -->
<div class="location" style="margin-bottom: 20px;">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:if test="${resultData.statusCd eq '010'}">
			<button type="button" onclick="doModify();" class="btn_sm btn_primary btn_modify_auth">수정</button>
		</c:if>
		<c:if test="${resultData.statusCd eq '010' or resultData.statusCd eq '030'}">
			<button type="button" onclick="openRecruitTermPopup();" class="btn_sm btn_primary btn_modify_auth">채용</button>
		</c:if>
		<c:if test="${resultData.statusCd eq '010' or resultData.statusCd eq '020'}">
			<button type="button" onclick="doDismissed();" class="btn_sm btn_secondary btn_modify_auth">미채용</button>
		</c:if>
	</div>
	<div class="ml-15">
		<button type="button" onclick="doPrint();" class="btn_sm btn_primary">출력</button>
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">신청 정보</h3>
	</div>
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">이름</th>
				<td>
					${resultData.expertNm}
					<input type="hidden" id="expertId" name="expertId" value="${resultData.expertId}" />
					<input type="hidden" id="expertNm" name="expertNm" value="${resultData.expertNm}" />
				</td>
				<th scope="row" rowspan="3">증명사진</th>
				<td rowspan="3">
					<figure class="photo">
						<c:choose>
							<c:when test="${not empty resultData.expertFileVO}">
								<img src="<c:url value='/tradeSOS/exp/expertImage.do' />?fileId=${resultData.expertFileVO.fileId}&fileSeq=${resultData.expertFileVO.fileSeq}" style="width: 108px;height: 144px;vertical-align: top;border: 1px solid #dbdcde;" alt="" />
							</c:when>
							<c:otherwise>
								<img src="<c:url value='/images/admin/defaultImg.jpg' />" alt="" />
							</c:otherwise>
						</c:choose>
					</figure>
				</td>
			</tr>
			<tr>
				<th scope="row">생년월일</th>
				<td>${resultData.birthDay}</td>
			</tr>
			<tr>
				<th scope="row">성별</th>
				<td>${resultData.sex}</td>
			</tr>
			<tr>
				<th scope="row">휴대전화 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="maskCellPhone1" name="maskCellPhone1" value="${resultData.maskCellPhone1}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="maskCellPhone2" name="maskCellPhone2" value="${resultData.maskCellPhone2}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="cellPhone3" name="cellPhone3" value="${resultData.cellPhone3}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					
					<input type="hidden" id="cellPhone1" name="cellPhone1" value="${resultData.cellPhone1}" />
					<input type="hidden" id="cellPhone2" name="cellPhone2" value="${resultData.cellPhone2}" />
				</td>
				<th scope="row">전화</th>
				<td>
					<input type="text" id="tel1" name="tel1" value="${resultData.tel1}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="tel2" name="tel2" value="${resultData.tel2}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
					<input type="text" id="tel3" name="tel3" value="${resultData.tel3}" maxlength="4" class="form_text" style="width: 17%;" numberOnly />
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
				<th scope="row">지원 전문가 분야</th>
				<td colspan="3">
					<ul class="inp_list consultTypeCheckbox">
						<c:forEach var="item" items="${consultList}" varStatus="status1">
							<li>
								<label for="item_type${status1.count}">
									<input type="checkbox" id="item_type${status1.count}" name="consultList[${status1.index}].consultTypeCds" value="${item.CONSULT_TYPE_CD}" class="form_checkbox"
										<c:forEach var="resultData" items="${consultingList}" varStatus="status2">
											<c:if test="${item.CONSULT_TYPE_CD eq resultData.consultTypeCd}">checked="checked"</c:if>
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
					</div>
				</td>
			</tr>
			<tr id="licenseClass">
				<th scope="row">자격증 <strong class="point">*</strong></th>
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
				<th scope="row">자기소개 <strong class="point">*</strong></th>
				<td colspan="3">
					<textarea id="myIntro" name="myIntro" rows="5" maxlength="1200" onkeyup="return textareaMaxLength(this);" class="form_textarea"><c:out value="${resultData.myIntro}" escapeXml="false"/></textarea>
				</td>
			</tr>
		</tbody>
	</table>
</div>
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
		var addInput = $(obj).parents('.addInput');
		
		if ($(obj).data('flag') == 'edu') {
			var eduLength = $('#educationListLength').val();
			$('#educationListLength').val(parseInt(eduLength) + 1);
			
			addInput.append(
				'<div class="add_line" style="overflow: hidden;margin-top: 10px;">'
				+ '	<input type="hidden" name="educationList[' + $('#educationListLength').val() + '].educationSeqs" value="0" />'
				+ '	<input type="text" name="educationList[' + $('#educationListLength').val() + '].edus" class="form_text" style="width: 40%;" />'
				+ ' <button type="button" onclick="deleteRow(this);" class="btn_tbl_border" data-flag="edu">삭제</button>'
				+ '</div>'
			);
		} else if ($(obj).data('flag') == 'license') {
			var licenseListLength = $('#licenseListLength').val();
			$('#licenseListLength').val(parseInt(licenseListLength) + 1);
			
			addInput.append(
				'<div class="add_line" style="overflow: hidden;margin-top: 10px;">'
				+ '	<input type="hidden" name="licenseList[' + $('#licenseListLength').val() + '].licenseSeqs" value="0" />'
				+ '	<input type="text" name="licenseList[' + $('#licenseListLength').val() + '].licenses" class="form_text" style="width: 40%;" />'
				+ ' <button type="button" onclick="deleteRow(this);" class="btn_tbl_border" data-flag="license">삭제</button>'
				+ '</div>'
			);
		}
	}
	
	// 학력, 자격증 삭제
	function deleteRow(obj) {
		var clickedRow = $(obj).parent('.add_line');
		
		if ($(obj).data('flag') == 'edu') {
			var eduLength = $('#educationListLength').val();
			$('#educationListLength').val(parseInt(eduLength) - 1);
		} else if ($(obj).data('flag') == 'license') {
			var licenseListLength = $('#licenseListLength').val();
			$('#licenseListLength').val(parseInt(licenseListLength) - 1);
		}
		
		clickedRow.remove();
	}

	function isValid() {
		var f = document.registForm;
		var returnVal = true;

		if ($('#maskCellPhone1').val() == '' || $('#maskCellPhone1').val() == '' || $('#cellPhone3').val() == '') {
			alert('휴대전화를 입력해 주세요.');
			
			$('#maskCellPhone1').focus();
			
			returnVal = false;
			return false;
		}

		if ($('#email1').val() == '' || $('#email2').val() == '') {
			alert('이메일을 입력해 주세요.');
			
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

		if ($('#atvCtrCd').val() == 'KR') {
			if ($('#atvAreaCd').val() == '') {
				alert('지역을 선택해 주세요.');
				
				$('#atvAreaCd').focus();
				
				returnVal = false;
				return false;
			}
		}

		if (!$('#majorHistory').val().replace(/(^\s*)|(\s*$)/gi, '')) {
			alert('주요이력을 입력해 주세요.');
			
			$('#majorHistory').focus();
			
			returnVal = false;
			return;
		}

		if (!$('#myIntro').val().replace(/(^\s*)|(\s*$)/gi, '')) {
			alert('자기소개를 입력해 주세요.');
			
			$('#myIntro').focus();
			
			returnVal = false;
			return;
		}

		if (fc_chk_byte2(f.majorHistory, 1000, '주요이력은') == false) {
			f.majorHistory.focus();
			
			returnVal = false;
			return;
		}

		if (fc_chk_byte2(f.myIntro, 4000, '자기소개는') == false) {
			f.myIntro.focus();
			
			returnVal = false;
			return;
		}

		// 학력 정렬
		if (returnVal) {
			if ($('#eduClass td:eq(0) .addInput .add_line').length > 0) {
				$('#eduClass td:eq(0) .addInput .add_line').each(function(i, e){
					$('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').attr('name', 'educationList[' + i + '].edus');
					$('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="hidden"]').attr('name', 'educationList[' + i + '].educationSeqs');
					
					if ($('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').val() == '') {
						alert((i + 1) + '번째 학력을 입력하세요');
						
						returnVal = false;
					}
				});
			}
		}

		// 자격증 정렬
		if (returnVal) {
			if ($('#licenseClass td:eq(0) .addInput .add_line').length > 0) {
				$('#licenseClass td:eq(0) .addInput .add_line').each(function(i, e){
					$('#licenseClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').attr('name', 'licenseList[' + i + '].licenses');
					$('#licenseClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="hidden"]').attr('name','licenseList[' + i + '].licenseSeqs');
					
					if ($('#licenseClass td:eq(0) .addInput .add_line:eq(' + i + ') input[type="text"]').val() == '') {
						alert((i + 1) + '번째 자격증을 입력하세요');
						
						returnVal = false;
					}
				});
			}
		}

		return returnVal;
	}
	
	function doModify() {
		if (isValid()) {
			if (confirm('수정 하시겠습니까?')) {
				if ($('#maskCellPhone1').val().indexOf('*') == -1) {
					$('#cellPhone1').val($('#maskCellPhone1').val());
				}
				
				if ($('#maskCellPhone2').val().indexOf('*') == -1) {
					$('#cellPhone2').val($('#maskCellPhone2').val());
				}
				
				global.ajaxSubmit($('#registForm'), {
					type : 'POST'
					, url : '<c:url value="/tradeSOS/exp/expertSupportDetailProc.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if (data.result) {
							goList();
						} else {
							alert(data.message);
							
							return false;
						}
			        }
				});
			}
		}
	}

	// 전문가 채용기간 설정 팝업 화면
	function openRecruitTermPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeSOS/exp/popup/expertRecruitTermPopup.do" />'
			, callbackFunction : function(resultObj){
				doRecruit(resultObj);
			}
		});
    }
	
	function doRecruit(termObj) {
		if (isValid()) {
			if (confirm('채용 하시겠습니까?')) {
				$('#statusCd').val('020');
				$('#recruitStDate').val(termObj.recruitStDate);
				$('#recruitEdDate').val(termObj.recruitEdDate);
				
				global.ajaxSubmit($('#registForm'), {
					type : 'POST'
					, url : '<c:url value="/tradeSOS/exp/expertSupportStatusProc.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if (data.result) {
							goList();
						} else {
							alert(data.message);
							
							return false;
						}
			        }
				});
			}			
		}
	}

	function doDismissed() {
		if (isValid()) {
			$('#statusCd').val('030');
			global.ajaxSubmit($('#registForm'), {
				type : 'POST'
				, url : '<c:url value="/tradeSOS/exp/expertSupportStatusProc.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					if (data.result) {
						alert('처리 하였습니다.');
						
						goList();
					} else {
						alert(data.message);
						
						return false;
					}
		        }
			});
		}
	}

	function setRegion(val){
		if (val.trim() == 'KR'.trim()) {
			$('#atvAreaCd').show();
		} else {
			$('#atvAreaCd').val('');
			$('#atvAreaCd').hide();
		}
	}
	
	function doPrint() {
		// 최소 사이즈
		var option = 'width = 1300,height = 700,scrollbars=yes';
		window.open('<c:url value="/tradeSOS/exp/expertSupportStatusDetailPrint.do" />?applicationId=' + $('#applicationId').val(), '' ,option);
	}
	
	function goList() {
		document.listForm.action = '<c:url value="/tradeSOS/exp/expertSupportStatus.do" />';
		document.listForm.submit();
	}
</script>