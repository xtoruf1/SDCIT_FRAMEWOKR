<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 무역의날 참석자 관리자 등록 팝업 -->
<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">무역의날 기념식 참석자 등록</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSave();">저장</button>
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>



<div id="coSearchPop" class="layerPopUpWrap popup_body">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:950px;">
			<div class="box">
				<form id="addAttendFrm" name="addAttendFrm">
					<input type="hidden" id="svrId" name="svrId" value="<c:out value='${resultInfo.svrId}' />" />
					<input type="hidden" id="applySeq" name="applySeq" value="<c:out value='${resultInfo.applySeq}' />" />
					<input type="hidden" id="awardTypeCd" name="awardTypeCd" value="<c:out value='${resultInfo.awardTypeCd}' />" />
					<input type="hidden" id="laureateName" name="laureateName" value="<c:out value='${resultInfo.laureateName}' />" />
					<input type="hidden" id="laureateJuminNo" name="laureateJuminNo" value="<c:out value='${resultInfo.laureateJuminNo}' />" />
					<input type="hidden" id="laureatePhone" name="laureatePhone" value="<c:out value='${resultInfo.laureatePhone}' />" />
					<input type="hidden" id="laureatePassportNo" name="laureatePassportNo" value="<c:out value='${resultInfo.passportNo}' />" />

					<input type="hidden" id="hallReceiptTypeTemp" name="hallReceiptTypeTemp" value="YY" />
					<input type="hidden" id="attendNameTemp" name="attendNameTemp" value="" />
					<input type="hidden" id="attendPhoneTemp" name="attendPhoneTemp" value="" />
					<input type="hidden" id="attendJuminNoTemp" name="attendJuminNoTemp" value="" />
					<input type="hidden" id="passportNoTemp" name="passportNoTemp" value="" />
					<input type="hidden" id="passportIssueDateTemp" name="passportIssueDateTemp" value="" />
					<input type="hidden" id="passportExpiryDateTemp" name="passportExpiryDateTemp" value="" />
					<input type="hidden" id="delegateNameTemp" name="delegateNameTemp" value="" />
					<input type="hidden" id="delegatePhoneTemp" name="delegatePhoneTemp" value="" />

					<table class="boardwrite formTable">
						<colgroup>
							<col style="width:15%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:35%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">업체명</th>
								<td colspan="3"><c:out value="${resultInfo.companyName}"/></td>
							</tr>
							<tr>
								<th scope="row">사업자번호</th>
								<td><c:out value="${resultInfo.businessNo}"/></td>
								<th scope="row">무역업번호</th>
								<td><c:out value="${resultInfo.tradeNo}"/></td>
							</tr>
							<tr>
								<th scope="row">수상자</th>
								<td><c:out value="${resultInfo.laureateName}"/></td>
								<th scope="row">수상종류</th>
								<td><c:out value="${resultInfo.awardTypeNm}"/></td>
							</tr>
							<tr>
								<th scope="row">참가구분</th>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" class="form_radio" name="hallReceiptType" id="radio1_1" value="YY" checked/>
										<span class="label">행사+수령</span>
									</label>
									<label class="label_form">
										<input type="radio" class="form_radio" name="hallReceiptType" id="radio1_2" value="YN" />
										<span class="label">행사만</span>
									</label>
									<label class="label_form">
										<input type="radio" class="form_radio" name="hallReceiptType" id="radio1_3" value="NY" />
										<span class="label">수령만</span>
									</label>
								</td>
							</tr>
							<tr>
								<th scope="row">참석자구분</th>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" class="form_radio" name="attendTypeCd" id="radio2_1" value="01" checked/>
										<span class="label">본인</span>
									</label>
									<label class="label_form">
										<input type="radio" class="form_radio" name="attendTypeCd" id="radio2_2" value="02" />
										<span class="label">대리인·내국인</span>
									</label>
									<label class="label_form">
										<input type="radio" class="form_radio" name="attendTypeCd" id="radio2_3" value="03" />
										<span class="label">대리인·외국인</span>
									</label>
								</td>
							</tr>
							<tr>
								<th scope="row">참석자</th>
								<td>
									<input class="input form_text w100p" type="text" name="attendName" id="attendName" value="<c:out value="${resultInfo.attendName}"/>" readonly />
								</td>
								<th scope="row">참석자 연락처</th>
								<td>
									<input class="input form_text w100p" type="text" name="attendPhone" id="attendPhone" value="<c:out value="${resultInfo.attendPhone}"/>" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="11" />
								</td>
							</tr>
							<tr>
								<th scope="row">주민등록번호</th>
								<td>
									<input class="input form_text w100p" type="text" name="attendJuminNo" id="attendJuminNo" value="<c:out value="${resultInfo.attendJuminNo}"/>" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="13" readonly />
								</td>
								<th scope="row">여권번호</th>
								<td>
									<input class="input form_text w100p" type="text" name="passportNo" id="passportNo" value="<c:out value="${resultInfo.passportNo}"/>" readonly />
								</td>
							</tr>
							<tr>
								<th scope="row">여권발급일</th>
								<td>
									<input class="input form_text w100p" type="text" name="passportIssueDate" id="passportIssueDate" value="" maxlength="6" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly />
								</td>
								<th scope="row">여권만료일</th>
								<td>
									<input class="input form_text w100p" type="text" name="passportExpiryDate" id="passportExpiryDate" value="" maxlength="6" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly />
								</td>
							</tr>
							<tr>
								<th scope="row">수령구분</th>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" class="form_radio" name="delegateTypeCd" id="radio3_1" value="01" checked/>
										<span class="label">본인</span>
									</label>
									<label class="label_form">
										<input type="radio" class="form_radio" name="delegateTypeCd" id="radio3_2" value="02" />
										<span class="label">대리인</span>
									</label>
								</td>
							</tr>
							<tr>
								<th scope="row">수령자</th>
								<td>
									<input class="input form_text w100p" type="text" name="delegateName" id="delegateName" value="<c:out value="${resultInfo.delegateName}"/>" readonly />
								</td>
								<th scope="row">수령자 연락처</th>
								<td>
									<input class="input form_text w100p" type="text" name="delegatePhone" id="delegatePhone" value="<c:out value="${resultInfo.delegatePhone}"/>" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="11" />
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
		</div>
		<div class="layerFilter"></div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function() {
		$("#addAttendFrm input[name=hallReceiptType]").change(function(){
			var radioVal = $(this).val();
			changeAttendForm(radioVal);
		});

		$("#addAttendFrm input[name=attendTypeCd]").change(function(){
			var radioVal = $(this).val();
			changeAttendInfo(radioVal);
		});

		$("#addAttendFrm input[name=delegateTypeCd]").change(function(){
			var radioVal = $(this).val();
			changeReceiptInfo(radioVal);
		});

	});

	//저장 밸리데이션
	function isValid() {

		var attendCheck = '';
		var delegateCheck = '';

		if( $("#addAttendFrm input[name=hallReceiptType]:checked").val() == 'YY' ){
			attendCheck = 'Y';
			delegateCheck = 'Y';
		}else if( $("#addAttendFrm input[name=hallReceiptType]:checked").val() == 'YN' ){
			attendCheck = 'Y';
			delegateCheck = 'N';
		}else if( $("#addAttendFrm input[name=hallReceiptType]:checked").val() == 'NY' ){
			attendCheck = 'N';
			delegateCheck = 'Y';
		}

		if( attendCheck == 'Y' ){

			if( $("#addAttendFrm input[name=attendName]").val() == '' ){
				alert('참석자를 입력해주세요.');
				$('#addAttendFrm input[name=attendName]').focus();
				return false;

			}else if( $("#addAttendFrm input[name=attendPhone]").val() == '' ){
				alert('참석자 연락처를 입력해주세요.');
				$('#addAttendFrm input[name=attendPhone]').focus();
				return false;

			}else if( $("#addAttendFrm input[name=attendJuminNo]").val() == '' && $("#addAttendFrm input[name=passportNo]").val() == '' ){

				if( $("#addAttendFrm input[name=attendTypeCd]:checked").val() == '02' && $("#addAttendFrm input[name=attendJuminNo]").val() == '' ){
					alert('주민번호를 입력해주세요.');
					$('#addAttendFrm input[name=attendJuminNo]').focus();
					return false;

				}else if( $("#addAttendFrm input[name=attendTypeCd]:checked").val() == '02' && $("#addAttendFrm input[name=passportNo]").val() == '' ){
					alert('여권번호를 입력해주세요.');
					$('#addAttendFrm input[name=passportNo]').focus();
					return false;

				}

			}else if( $("#addAttendFrm input[name=attendTypeCd]:checked").val() == '02' || $("#addAttendFrm input[name=attendJuminNo]").val() != '' ){
				if( $("#addAttendFrm input[name=attendJuminNo]").val().length != '13' ){
					alert('주민등록번호를 입력해주세요.');
					$('#addAttendFrm input[name=attendJuminNo]').focus();
					return false;
				}
			}

		}

		if( delegateCheck == 'Y' ){
			if( $("#addAttendFrm input[name=delegateName]").val() == '' ){
				alert('수령자를 입력해주세요.');
				$('#addAttendFrm input[name=delegateName]').focus();
				return false;

			}else if( $("#addAttendFrm input[name=delegatePhone]").val() == '' ){
				alert('수령자 연락처를 입력해주세요.');
				$('#addAttendFrm input[name=delegatePhone]').focus();
				return false;
			}
		}

		return true;
	}

	//저장
	function doSave() {
		if (isValid()) {
			if (confirm('참석자를 등록 하시겠습니까?')) {
				global.ajax({
					url : '<c:url value="/tradeDay/clbrt/saveAwardAttendInfoDetail.do" />'
					, dataType : 'json'
					, type : 'POST'
					, data : $('#addAttendFrm').serialize()
					, async : true
					, spinner : true
					, success : function(data){
						if(!data.result){
							alert(data.message);
						}
						// 콜백
						layerPopupCallback();
					}
				});
			}
		}
	}

	function changeReceiptInfo(delegateTypeCd){
		if( delegateTypeCd == '01' ){
			$("#addAttendFrm input[name=delegateName]").val($("#addAttendFrm input[name=laureateName]").val());
			$("#addAttendFrm input[name=delegatePhone]").val($("#addAttendFrm input[name=laureatePhone]").val());
			$("#addAttendFrm input[name=delegateName]").attr('readonly',true);
		}else {
			$("#addAttendFrm input[name=delegateName]").val('');
			$("#addAttendFrm input[name=delegatePhone]").val('');
			$("#addAttendFrm input[name=delegateName]").attr('readonly',false);
		}
	}

	function changeAttendInfo(attendTypeCd){
		if( attendTypeCd == '01' ){
			$("#addAttendFrm input[name=attendName]").val($("#addAttendFrm input[name=laureateName]").val());
			$("#addAttendFrm input[name=attendPhone]").val($("#addAttendFrm input[name=laureatePhone]").val());
			$("#addAttendFrm input[name=attendJuminNo]").val($("#addAttendFrm input[name=laureateJuminNo]").val());
			$("#addAttendFrm input[name=passportNo]").val($("#addAttendFrm input[name=laureatePassportNo]").val());
			$("#addAttendFrm input[name=attendName]").attr('readonly',true);
			$("#addAttendFrm input[name=attendJuminNo]").attr('readonly',true);
			$("#addAttendFrm input[name=passportNo]").attr('readonly',true);
			$("#addAttendFrm input[name=passportIssueDate]").attr('readonly',true);
			$("#addAttendFrm input[name=passportExpiryDate]").attr('readonly',true);
		}else if( attendTypeCd == '02' ){
			$("#addAttendFrm input[name=attendName]").val('');
			$("#addAttendFrm input[name=attendPhone]").val('');
			$("#addAttendFrm input[name=attendJuminNo]").val('');
			$("#addAttendFrm input[name=attendName]").attr('readonly',false);
			$("#addAttendFrm input[name=attendJuminNo]").attr('readonly',false);
			$("#addAttendFrm input[name=passportNo]").attr('readonly',true);
			$("#addAttendFrm input[name=passportIssueDate]").attr('readonly',true);
			$("#addAttendFrm input[name=passportExpiryDate]").attr('readonly',true);
		}else if( attendTypeCd == '03' ){
			$("#addAttendFrm input[name=attendName]").val('');
			$("#addAttendFrm input[name=attendPhone]").val('');
			$("#addAttendFrm input[name=attendJuminNo]").val('');
			$("#addAttendFrm input[name=attendName]").attr('readonly',false);
			$("#addAttendFrm input[name=attendJuminNo]").attr('readonly',false);
			$("#addAttendFrm input[name=passportNo]").attr('readonly',false);
			$("#addAttendFrm input[name=passportIssueDate]").attr('readonly',false);
			$("#addAttendFrm input[name=passportExpiryDate]").attr('readonly',false);
		}

	}

	function changeAttendForm(hallReceiptType){

		//행사+포상
		if( hallReceiptType == 'YY' ){

			if( $('#hallReceiptTypeTemp').val() != 'YN' ){

				$("#addAttendFrm input[name=attendName]").attr('disabled',false);
				$("#addAttendFrm input[name=attendPhone]").attr('disabled',false);
				$("#addAttendFrm input[name=attendJuminNo]").attr('disabled',false);
				$("#addAttendFrm input[name=passportNo]").attr('disabled',false);
				$("#addAttendFrm input[name=passportIssueDate]").attr('disabled',false);
				$("#addAttendFrm input[name=passportExpiryDate]").attr('disabled',false);

				$("#addAttendFrm input[name=attendName]").val($("#addAttendFrm input[name=attendNameTemp]").val());
				$("#addAttendFrm input[name=attendPhone]").val($("#addAttendFrm input[name=attendPhoneTemp]").val());
				$("#addAttendFrm input[name=attendJuminNo]").val($("#addAttendFrm input[name=attendJuminNoTemp]").val());
				$("#addAttendFrm input[name=passportNo]").val($("#addAttendFrm input[name=passportNoTemp]").val());
				$("#addAttendFrm input[name=passportIssueDate]").val($("#addAttendFrm input[name=passportIssueDateTemp]").val());
				$("#addAttendFrm input[name=passportExpiryDate]").val($("#addAttendFrm input[name=passportExpiryDateTemp]").val());
			}

			//참석자구분 on
			$("#addAttendFrm input[name=attendTypeCd]").each(function(i) {
				$(this).attr('disabled',false);
			})

			//수령구분 on
			$("#addAttendFrm input[name=delegateTypeCd]").each(function(i) {
				$(this).attr('disabled',false);
			})
			$("#addAttendFrm input[name=delegateName]").attr('disabled',false);
			$("#addAttendFrm input[name=delegatePhone]").attr('disabled',false);
			$("#addAttendFrm input[name=delegateName]").val($("#addAttendFrm input[name=delegateNameTemp]").val());
			$("#addAttendFrm input[name=delegatePhone]").val($("#addAttendFrm input[name=delegatePhoneTemp]").val());

		//행사만
		}else if( hallReceiptType == 'YN' ){

			if( $('#hallReceiptTypeTemp').val() != 'YY' ){

				$("#addAttendFrm input[name=attendName]").attr('disabled',false);
				$("#addAttendFrm input[name=attendPhone]").attr('disabled',false);
				$("#addAttendFrm input[name=attendJuminNo]").attr('disabled',false);
				$("#addAttendFrm input[name=passportNo]").attr('disabled',false);
				$("#addAttendFrm input[name=passportIssueDate]").attr('disabled',false);
				$("#addAttendFrm input[name=passportExpiryDate]").attr('disabled',false);

				$("#addAttendFrm input[name=attendName]").val($("#addAttendFrm input[name=attendNameTemp]").val());
				$("#addAttendFrm input[name=attendPhone]").val($("#addAttendFrm input[name=attendPhoneTemp]").val());
				$("#addAttendFrm input[name=attendJuminNo]").val($("#addAttendFrm input[name=attendJuminNoTemp]").val());
				$("#addAttendFrm input[name=passportNo]").val($("#addAttendFrm input[name=passportNoTemp]").val());
				$("#addAttendFrm input[name=passportIssueDate]").val($("#addAttendFrm input[name=passportIssueDateTemp]").val());
				$("#addAttendFrm input[name=passportExpiryDate]").val($("#addAttendFrm input[name=passportExpiryDateTemp]").val());
			}

			//참석자구분 on
			$("#addAttendFrm input[name=attendTypeCd]").each(function(i) {
				$(this).attr('disabled',false);
			})

			//수령구분 off
			$("#addAttendFrm input[name=delegateTypeCd]").each(function(i) {
				$(this).attr('disabled','disabled');
			})
			$("#addAttendFrm input[name=delegateName]").attr('disabled','disabled');
			$("#addAttendFrm input[name=delegatePhone]").attr('disabled','disabled');
			$("#addAttendFrm input[name=delegateNameTemp]").val($("#addAttendFrm input[name=delegateName]").val());
			$("#addAttendFrm input[name=delegatePhoneTemp]").val($("#addAttendFrm input[name=delegatePhone]").val());
			$("#addAttendFrm input[name=delegateName]").val('');
			$("#addAttendFrm input[name=delegatePhone]").val('');

		//수령만
		}else if( hallReceiptType == 'NY' ){

			if( $('#hallReceiptTypeTemp').val() == 'YY' ){
				$("#addAttendFrm input[name=delegateNameTemp]").val($("#addAttendFrm input[name=delegateName]").val());
				$("#addAttendFrm input[name=delegatePhoneTemp]").val($("#addAttendFrm input[name=delegatePhone]").val());
			}

			//참석자구분 off
			$("#addAttendFrm input[name=attendTypeCd]").each(function(i) {
				$(this).attr('disabled','disabled');
			})
			$("#addAttendFrm input[name=attendNameTemp]").val($("#addAttendFrm input[name=attendName]").val());
			$("#addAttendFrm input[name=attendPhoneTemp]").val($("#addAttendFrm input[name=attendPhone]").val());
			$("#addAttendFrm input[name=attendJuminNoTemp]").val($("#addAttendFrm input[name=attendJuminNo]").val());
			$("#addAttendFrm input[name=passportNoTemp]").val($("#addAttendFrm input[name=passportNo]").val());
			$("#addAttendFrm input[name=passportIssueDateTemp]").val($("#addAttendFrm input[name=passportIssueDate]").val());
			$("#addAttendFrm input[name=passportExpiryDateTemp]").val($("#addAttendFrm input[name=passportExpiryDate]").val());

			$("#addAttendFrm input[name=attendName]").val('');
			$("#addAttendFrm input[name=attendPhone]").val('');
			$("#addAttendFrm input[name=attendJuminNo]").val('');
			$("#addAttendFrm input[name=passportNo]").val('');
			$("#addAttendFrm input[name=passportIssueDate]").val('');
			$("#addAttendFrm input[name=passportExpiryDate]").val('');

			$("#addAttendFrm input[name=attendName]").attr('disabled','disabled');
			$("#addAttendFrm input[name=attendPhone]").attr('disabled','disabled');
			$("#addAttendFrm input[name=attendJuminNo]").attr('disabled','disabled');
			$("#addAttendFrm input[name=passportNo]").attr('disabled','disabled');
			$("#addAttendFrm input[name=passportIssueDate]").attr('disabled','disabled');
			$("#addAttendFrm input[name=passportExpiryDate]").attr('disabled','disabled');

			//수령구분 on
			$("#addAttendFrm input[name=delegateTypeCd]").each(function(i) {
				$(this).attr('disabled',false);
			})
			$("#addAttendFrm input[name=delegateName]").attr('disabled',false);
			$("#addAttendFrm input[name=delegatePhone]").attr('disabled',false);
			$("#addAttendFrm input[name=delegateName]").val($("#addAttendFrm input[name=delegateNameTemp]").val());
			$("#addAttendFrm input[name=delegatePhone]").val($("#addAttendFrm input[name=delegatePhoneTemp]").val());

		}

		$('#hallReceiptTypeTemp').val(hallReceiptType);
	}

	$(window).ready(function(){
		$("#addAttendFrm input[name=hallReceiptType]:radio[value='NY']").click();
	});

</script>