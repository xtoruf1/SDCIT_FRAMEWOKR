<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">

		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>

	</div>
</div>

<form id="searchForm" method="post">
	<input type="hidden" id="searchAwardRound" name="searchAwardRound" value="${params.searchAwardRound}"/>
	<input type="hidden" id="searchSuccessLink" name="searchSuccessLink" value="${params.searchSuccessLink}"/>
	<input type="hidden" id="searchCompanyName" name="searchCompanyName" value="${params.searchCompanyName}"/>
	<input type="hidden" id="searchCeoName" name="searchCeoName" value="${params.searchCeoName}"/>
</form>

<form id="frm" method="post">
<input type="hidden" id="pictureFileId" name="pictureFileId" value="${result.pictureFileId}"/>
<input type="hidden" id="winnerId" name="winnerId" value="${result.winnerId}"/>
<div class="cont_block">
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th>사진</th>
					<td colspan="3">
						<div class="form_file form_img">
							<c:choose>
								<c:when test="${not empty result.pictureFileId}">
									<figure id="photoBox" class="photo_img">
										<img alt="" src="/hanbit/hanbitApplicant/habitImage.do?attachSeq=${result.pictureFileId}&fileSeq=1">
									</figure>
								</c:when>
								<c:otherwise>
									<figure id="photoBox" class="photo_img">
										<img alt="" src="/images/admin/defaultImg.jpg">
									</figure>
								</c:otherwise>
							</c:choose>
							<label class="file_btn">
								<input type="file"  id="pictureFile" name="pictureFile" accept="image/*" onchange="setPhoto(event);">
								<span class="btn_tbl mt-5">사진등록</span>
							</label>
						</div>
					</td>
				</tr>
				<tr>
					<th>성명 <strong class="point">*</strong></th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="nameKor" id="nameKor"  value="<c:out value="${ result.nameKor }" />" maxlength="30"/>
					</td>
					<th>회사명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="companyName" id="companyName" value="<c:out value="${ result.companyName }" />" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<th>업종</th>
					<td class="bRight">
						<select name="businessType" id="businessType" class="form_select">
							<c:forEach items="${gubunList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.codeNm}" />" label="<c:out value="${ resultInfo.codeNm}" />" <c:out value="${ result.businessType eq resultInfo.codeNm ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th>소재지</th>
					<td class="bRight">
						<select name="area" id="area" class="form_select">
							<c:forEach items="${areaList}" var="resultInfo" varStatus="status">
								<option value="<c:out value="${ resultInfo.codeNm}" />" label="<c:out value="${ resultInfo.codeNm}" />" <c:out value="${ result.area eq resultInfo.codeNm ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>홈페이지</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="homepage" id="homepage"  value="<c:out value="${ result.homepage }" />" maxlength="150"/>
					</td>
					<th>성공사례</th>
					<td>
						<input type="text" class="form_text w100p" name="successLink" id="successLink" value="<c:out value="${ result.successLink }" />"  maxlength="150"/>
					</td>
				</tr>
				<tr>
					<th>주생산품</th>
					<td class="bRight">
						<input type="text" class="form_text w100p" name="mainProduct1" id="mainProduct1"  value="<c:out value="${ result.mainProduct1 }" />" maxlength="100"/>
					</td>
					<th>주수출품</th>
					<td>
						<input type="text" class="form_text w100p" name="mainExp1" id="mainExp1" value="<c:out value="${ result.mainExp1 }" />"  maxlength="100"/>
					</td>
				</tr>
				<tr>
					<th>수출국가</th>
					<td colspan="3" class="bRight">
						<fieldset class="form_group">
							<input type="text" class="form_text group_item w100p" name="countryName1" id="countryName1" value="<c:out value="${ result.countryName1 }" />"  maxlength="30"/>
							<input type="text" class="form_text group_item w100p" name="countryName2" id="countryName2" value="<c:out value="${ result.countryName2 }" />"  maxlength="30"/>
							<input type="text" class="form_text group_item w100p" name="countryName3" id="countryName3" value="<c:out value="${ result.countryName3 }" />"  maxlength="30"/>
							<input type="text" class="form_text group_item w100p" name="countryName4" id="countryName4" value="<c:out value="${ result.countryName4 }" />"  maxlength="30"/>
						</fieldset>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){

	});

	function setPhoto() {	//사진
		global.ajaxSubmit($('#frm'), {
			type : 'POST'
			, url : '/hanbit/hanbitSelectedCompany/saveHanbitSelectedCeoPhoto.do'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.result == 'false') {
					alert(data.message);
				} else {
					$('#pictureFileId').val(data.pictureFileId);
				}
	        }
		});
	}

	function doSave() {	//저장

		if($('#nameKor').val() == '') {
			alert('성명을 입력하세요.');
			$('#nameKor').focus();
			return;
		}

		if($('#companyName').val() == '') {
			alert('회사명을 입력하세요.');
			$('#companyName').focus();
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		var saveData = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitSelectedCompany/updateSelectedCompanyInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				goList();
			}
		});
	}

	function goList() {	// 초기화
		$('#searchForm').attr('action', '/hanbit/hanbitSelectedCompany/hanbitSelectedCompanyList.do');
		$('#searchForm').submit();
	}

</script>