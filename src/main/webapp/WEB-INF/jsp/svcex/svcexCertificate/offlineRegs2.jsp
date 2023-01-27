<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form id="viewForm" name="viewForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="event"			id="event" />
	<input type="hidden" name="memberId"		id="memberId"		value="<c:out value="${contentVo.memberId }"/>" />
	<input type="hidden" name="bsNo"			id="bsNo"			value="<c:out value="${contentVo2.bsNo }"/>"/>
	<input type="hidden" name="attFileId"		id="attFileId"		value="<c:out value="${contentVo2.attFileId }"/>" />
	<input type="hidden" name="reqno"			id="reqno"			value="<c:out value="${contentVo3.reqno }"/>"/>
	<input type="hidden" name="stateCd"			id="stateCd" 		value="<c:out value="${contentVo3.stateCd }"/>"/>
	<input type="hidden" name="manCreYn"		id="manCreYn" 		value="<c:out value="${contentVo3.manCreYn }"/>"/>
	<input type="hidden" name="listPagePre"		id="listPagePre"	value="<c:out value="${svcexVO.listPage }"/>"/>
	<input type="hidden" name="listPage"		id="listPage"		value="<c:out value="/svcex/svcexCertificate/offlineRegs2View.do"/>"/>
	<input type="hidden" name="fileId"			id="fileId"			value="">
	<input type="hidden" name="fileInputName"	id="fileInputName"	value="">

	<input type="hidden" name="fileNm"	id="fileNm"	value="${fileNm}">

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave('1');">임시저장</button>
			<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave('2');">다음</button>
			<button type="button" class="btn_sm btn_secondary" onclick="doPrvPage();">이전</button>
		</div>
	</div>

	<div class="cont_block">
		<div class="tbl_opt">
			<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>회사명</th>
					<td><c:out value="${contentVo.companyKor }"/></td>
					<th>대표자명</th>
					<c:if test="${contentVo3.stateCd eq 'A' }">
						<td><c:out value="${contentVo.orgPresidentKor }"/></td>
					</c:if>
					<c:if test="${contentVo3.stateCd ne 'A' }">
						<td><c:out value="${contentVo.presidentKor }"/></td>
					</c:if>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td><c:out value="${contentVo.enterRegNo1 }"/>-<c:out value="${contentVo.enterRegNo2 }"/>-<c:out value="${contentVo.enterRegNo3 }"/> </td>
					<th>무역업고유번호</th>
					<td><c:out value="${contentVo.memberId }"/></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3"><c:out value="${contentVo.korAddr1 }"/><c:out value="${contentVo.korAddr2 }"/></td>
				</tr>
				<tr>
					<th>사업자등록증 <strong class="point">*</strong></th>
					<td colspan="3">
						<div class="form_row w100p">
						<c:if test="${!empty fileListRow}" >
						<c:forEach var="fileList" items="${fileListRow}" varStatus="status">
							<input type="text" class="form_text w50p" name="attFileList" id="attFileList" readonly="readonly" value="<c:out value="${fileNm.replaceAll(',','') }"/>" >
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</c:forEach>
						</c:if>
						<c:if test="${empty fileListRow}" >
							<input type="text" class="form_text w50p" name="attFileList" id="attFileList" readonly="readonly" value="" >
						</c:if>
						<button class="btn_tbl" type="button" onclick="viewFiles();">찾아보기</button>
						</div>
					</td>
				</tr>
				<tr>
					<th>소유구분</th>
					<td>
						<select name="ownCd" id="ownCdId" class="form_select w100p" desc="소유구분" isrequired="true,">
							<c:forEach var="list" items="${com023}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${contentVo2.ownCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>크기구분</th>
					<td>
						<select name="sizeCd" id="sizeCdId" class="form_select w100p" desc="크기구분" isrequired="true,">
							<c:forEach var="list" items="${com024}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${contentVo2.sizeCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>상장구분</th>
					<td>
						<select name="listedCd" id="listedCdId" class="form_select w100p" desc="상장구분" isrequired="true,">
							<c:forEach var="list" items="${com025}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${contentVo2.listedCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>전업구분</th>
					<td>
						<select name="chagneCd" id="chagneCdId" class="form_select w100p" desc="전업구분" isrequired="true,">
							<c:forEach var="list" items="${com026}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${contentVo2.chagneCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<!-- <tr><td colspan="4"></td></tr> -->
				<tr>
					<th>담당자명 <strong class="point">*</strong></th>
					<td>
						<c:if test="${contentVo3.stateCd ne 'A' }">
							<input type="text" name="wrkMembNm" id="wrkMembNm" class="form_text w100p"  maxlength="10" value="<c:out value="${contentVo3.wrkMembNm }"/>" desc="담당자명" isrequired="true">
						</c:if>
						<c:if test="${contentVo3.stateCd eq 'A' }">
							<input type="text" name="wrkMembNm" id="wrkMembNm" class="form_text w100p"  maxlength="10" value="<c:out value="${contentVo3.orgWrkMembNm }"/>" desc="담당자명" isrequired="true">
						</c:if>
					</td>
					<th>핸드폰 <strong class="point">*</strong></th>
					<td>
						<div class="form_row" style="width:300px;">
							<c:if test="${empty contentVo3.coHp1 }">
							<select name="coHp1" id="coHp1" class="form_select">
								<c:forEach var="list" items="${com012}" varStatus="status">
									<option value="${list.detailcd}"<c:if test="${contentVo3.coHp1 == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
								</c:forEach>
							</select>
							</c:if>
							<c:if test="${!empty contentVo3.coHp1 }">
								<c:if test="${contentVo3.stateCd ne 'A' }">
									<input type="text" name="coHp1" id="coHp1" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.coHp1 }"/>" desc="핸드폰" isrequired="true">
								</c:if>
								<c:if test="${contentVo3.stateCd eq 'A' }">
									<input type="text" name="coHp1" id="coHp1" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.orgCoHp1 }"/>" desc="핸드폰" isrequired="true">
								</c:if>
							</c:if>

							<c:if test="${empty contentVo3.coHp2 }">
								<input type="text" name="coHp2" id="coHp2" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.coHp2 }"/>" desc="핸드폰" isrequired="true">
							</c:if>
							<c:if test="${!empty contentVo3.coHp2 }">
								<c:if test="${contentVo3.stateCd ne 'A' }">
									<input type="text" name="coHp2" id="coHp2" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.coHp2 }"/>" desc="핸드폰" isrequired="true">
								</c:if>
								<c:if test="${contentVo3.stateCd eq 'A' }">
									<input type="text" name="coHp2" id="coHp2" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.orgCoHp2 }"/>" desc="핸드폰" isrequired="true">
								</c:if>
							</c:if>

							<input type="text" name="coHp3" id="coHp3" size="5" maxlength="4" class="form_text" value="<c:out value="${contentVo3.coHp3 }"/>" desc="핸드폰" isrequired="true">
						</div>
					</td>
				</tr>
				<tr>
					<th>E-Mail <strong class="point">*</strong></th>
					<td>
						<div class="form_row">
							<input type="text" name="coEmail1" id="coEmail1" class="form_text" maxlength="30" value="<c:out value='${contentVo3.coEmail1}'/>" desc="E-Mail" isrequired="true">
							<span class="append">@</span>
							<input type="text" name="coEmail3" id="coEmail3" class="form_text" maxlength="30" value="<c:out value="${contentVo3.coEmail3 }"/>" desc="E-Mail" isrequired="true" <c:out value='${contentVo3.coEmail2 eq "1" || contentVo3.coEmail2 eq ""? "" : "readonly"}'/>>
							<select name="coEmail2" id="coEmail2Id" onchange="doChange(this)" class="form_select">
								<c:forEach var="list" items="${com014}" varStatus="status">
									<option value="${list.detailcd}"<c:if test="${contentVo3.coEmail2 == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
								</c:forEach>
							</select>
						</div>
					</td>
					<th>기존실적포함<br> 인쇄여부 <strong class="point">*</strong></th>
					<td>
						<label class="label_form">
							<input type="radio" class="form_radio" name="oriDataRadio" onclick="radioClick('oriData','oriDataRadio');" value="Y" <c:out value="${contentVo3.oriDataYn eq 'Y' ? 'checked' : '' }"/>>
							<span class="label">포함</span>
						</label>
						<label class="label_form">
							<input type="radio" class="form_radio" name="oriDataRadio" onclick="radioClick('oriData','oriDataRadio');" value="N" <c:out value="${contentVo3.oriDataYn eq 'N' ? 'checked' : '' }"/>>
							<span class="label">미포함</span>
						</label>
						<input type="hidden" name="oriData" id="oriData" value="<c:out value="${contentVo3.oriDataYn}"/>">
					</td>
				</tr>
				<!-- <tr><td colspan="4"></td></tr> -->
				<tr>
					<th>수출입구분</th>
					<td>
						<select name="expImpCd" id="expImpCdId" class="form_select w100p" desc="수출입구분" isrequired="true,">
							<c:forEach var="list" items="${com002}" varStatus="status">
								<option value="${list.detailcd}"<c:if test="${contentVo3.expImpCd == list.detailcd}"> selected</c:if>>${list.detailnm}</option>
							</c:forEach>
						</select>
					</td>
					<th>운수용역</th>
					<td>
						<input class="form_checkbox" type="checkbox" name="expImpChk" <c:out value="${contentVo3.transportServiceCd eq '2' ? 'checked' : ''}"/>>
						<input type="hidden" name="transportServiceCd" value="<c:out value="${contentVo3.transportServiceCd }"/>">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

</form>

<script type="text/javascript">
	var f;

	$(document).ready(function(){
		f = document.viewForm;

		if( !f.coEmail2.value ) {
			f.coEmail3.style.backgroundColor = "#f3f4f2";
		}

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			//f.attFileList.style.backgroundColor = "#ffffff";
		}else{
			$("#attFileList").next('button').attr("onclick","");
		}

	});

	function viewFiles(){
		var paramFileId = f.attFileId.value;
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/svcex/svcexCertificate/popup/offlineRegsFileList.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
				fileId : paramFileId
				, fileInputName : "attFileId"
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if( resultObj.length > 0 ){
					ReloadFileList( resultObj[0] );
				}
// 				document.viewForm.targetCountryNm.value = resultObj[1];
			}
		});
	}

	function ReloadFileList(fileId) {
		f.attFileId.value = fileId;
		f.fileId.value = fileId;
		f.fileInputName.value = fileId;

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/fileList.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				f.attFileList.value = data.fileNm.replaceAll(',', '');
			}
		});
	}

	function doPrvPage(){
		if(!confirm("이전 페이지로 이동 하시겠습니까?")){
			return;
		}

		if("" == f.listPagePre.value){
			f.action = '<c:url value="/svcex/svcexCertificate/offlineRegsView.do" />';
			f.target = '_self';
			f.submit();
		}else{

			if( f.transportServiceCd.value == '2'){
				f.action = "/svcex/svcexCertificate/applyDetail2View.do";
			}else{
				f.action = "/svcex/svcexCertificate/applyDetailView.do";
			}
			f.event.value= "SIMSA";
			f.target = "_self";
			f.submit();
		}
	}

	function doSave(gubun){
		if (f.attFileList.value.length == 0) {
			alert("사업자등록증을 첨부하세요.");
			return;
		}

		if (f.ownCd.value.length == 0) {
			alert("소유구분을 입력하세요.");
			f.ownCd.focus();
			return;
		}
		if (f.sizeCd.value.length == 0) {
			alert("크기구분을 입력하세요.");
			f.sizeCd.focus();
			return;
		}
		if (f.listedCd.value.length == 0) {
			alert("상장구분을 입력하세요.");
			f.listedCd.focus();
			return;
		}
		if (f.chagneCd.value.length == 0) {
			alert("전업구분을 입력하세요.");
			f.chagneCd.focus();
			return;
		}
		if (f.wrkMembNm.value.length == 0) {
			alert("담당자명을 입력하세요.");
			f.wrkMembNm.focus();
			return;
		}
		if (f.coHp2.value.length < 3) {
			alert("핸드폰을 정확하게 입력해 주세요.");
			f.coHp2.focus();
			return;
		}
		if (f.coHp3.value.length != 4) {
			alert("핸드폰을 정확하게 입력해주세요.");
			f.coHp3.focus();
			return;
		}

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			var telNo = f.coHp1.value+"-"+f.coHp2.value+"-"+f.coHp3.value;
		    var regex = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		    if ( $('#coHp1').prop('disabled') == false ){
			    if (!regex.test(telNo)) {
			    	alert("핸드폰 형식이 돌바르지 않습니다.");
			    	f.coHp1.focus();
			    	return false;
			    }
		    }
		}

		if( f.expImpChk.checked == true){
			f.transportServiceCd.value = '2'; //구분이 운수용이이다.
		}else{
			f.transportServiceCd.value = '1';
		}

		f.stateCd.value = 'A';

		if(f.oriData.value == null || f.oriData.value == "")
		{
			alert("기존실적포함 인쇄 여부를 선택하여 주십시오");
			return;
		}

		var email = f.coEmail1.value+'@'+f.coEmail3.value;
		var check = checkMail(email);
		if(!check){
			alert("올바른 E-Mail 형식이 아닙니다.");
			f.coEmail1.focus();
			return;
		}

		if(!confirm("저장하시겠습니까?")){
			return;
		}

		if (f.stateCd.value != 'E' && f.stateCd.value != 'F' ){
			saveProcess(gubun);
		}
	}

	function saveProcess(gubun) {
		global.ajaxSubmit($('#viewForm'), {
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/insertOfflineReg2Save.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				f.bsNo.value = data.svcexVO.bsNo;
				f.reqno.value = data.svcexVO.reqno;

				if( gubun == "1" ){
					//alert("임시저장 신청이 완료되었습니다.");
					doCurrPage();
				}else{
					//alert("저장이 완료되었습니다.\n다음 페이지로 이동합니다.");
					doNextPage();
				}
	        }
		});
	}

	function doCurrPage() {
		f.action = "/svcex/svcexCertificate/offlineRegs2View.do";
		f.target = "_self";
		f.submit();
	}

	function doNextPage(){
		f.event.value = "";
		if( f.transportServiceCd.value == "2" ){
			f.action = "/svcex/svcexCertificate/offlineRegs4View.do";
		}else{
			f.action = "/svcex/svcexCertificate/offlineRegs3View.do";
		}
		f.target = "_self";
		f.submit();
	}

	function doChange(obj){
		var f = document.viewForm;
		if("1" == obj.value){
			f.coEmail3.value = "";
			f.coEmail3.readOnly = false;
			f.coEmail3.style.backgroundColor = "#ffffff";
		}else{
			f.coEmail3.readOnly = true;
			f.coEmail3.value = obj[obj.selectedIndex].text;
			f.coEmail3.style.backgroundColor = "#f3f4f2";
		}
	}

	function checkMail(val) {
		var check1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)/;
		var check2 = /^[a-zA-Z0-9\-\.\_]+\@[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4})$/;

		if (!check1.test(val) && check2.test(val)) {
			return true;
		} else {
			return false;
		}
	}

	function radioClick(name, radioNm){
		var valObj = document.getElementById(name);
		var radioObj = document.getElementsByName(radioNm);

		for(var i = 0; i < radioObj.length; i++){
			if(radioObj[i].checked == true){
				valObj.value = radioObj[i].value;
			}
		}
	}

	//수출입 구분 "선택" 없애기
	function doPageInit() {
		var f = document.viewForm;
		document.viewForm.expImpCd.remove(0);
	}
	document.body.onload = doPageInit;

</script>
