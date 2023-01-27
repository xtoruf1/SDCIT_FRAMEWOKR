<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" id="btnList" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<form id="frm" method="post">
<double-submit:preventer/>
<!-- 리스트 조회조건 파라미터 세팅 Start -->
<input type="hidden" name="cardReqId" id="cardReqId" value="<c:out value='${resultInfo.cardReqId}'/>"/>
<input type="hidden" name="searchCorpNameKr" id=searchCorpNameKr value="<c:out value='${param.searchCorpNameKr}'/>"/>
<input type="hidden" name="searchCorpRegNo" id="searchCorpRegNo" value="<c:out value='${param.searchCorpRegNo}'/>"/>
<input type="hidden" name="searchTradeNo" id="searchTradeNo" value="<c:out value='${param.searchTradeNo}'/>"/>
<input type="hidden" name="searchCardStatus" id="searchCardStatus" value="<c:out value='${param.searchCardStatus}'/>"/>
<input type="hidden" name="searchCardCode" id="searchCardCode" value="<c:out value='${param.searchCardCode}'/>"/>
<input type="hidden" name="searchDateType" id="searchDateType" value="<c:out value='${param.searchDateType}'/>"/>
<input type="hidden" name="searchStartDate" id="searchStartDate" value="<c:out value='${param.searchStartDate}'/>"/>
<input type="hidden" name="searchEndDate" id="searchEndDate" value="<c:out value='${param.searchEndDate}'/>"/>
<input type="hidden" name="cntPerPage" id="cntPerPage" value="<c:out value='${param.cntPerPage}'/>"/>
<input type="hidden" name="pageIndex"  value="<c:out value='${param.pageIndex}' default='1' />"/>
<!-- 리스트 조회조건 파라미터 세팅 End -->
<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">업체 정보</h3>
	</div>

	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>

	<table class="formTable">

		<colgroup>
			<col style="width:8%" />
			<col style="width:7%" />
			<col style="width:21%" />
			<col style="width:8%" />
			<col style="width:21%" />
			<col style="width:8%" />
			<col style="width:7%" />
			<col />
		</colgroup>

		<tr>
			<th colspan="2">무역업고유번호 <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="tradeNo" name="tradeNo" value="<c:out value="${resultInfo.tradeNo}"/>" maxlength="9"/>
			</td>
			<th>법인번호 <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="corpNo" name="corpNo" value="<c:out value="${resultInfo.corpNo}"/>" maxlength="10"/>
			</td>
			<th colspan="2">사업자등록번호 <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="corpRegNo" name="corpRegNo" value="<c:out value="${resultInfo.corpRegNo}"/>" maxlength="10"/>
			</td>
		</tr>

		<tr>
			<th rowspan="2">회사명 <strong class="point">*</strong></th>
			<th>국문 <strong class="point">*</strong></th>
			<td colspan="3">
				<input type="text" class="form_text w100p" id="corpNameKr" name="corpNameKr" value="<c:out value="${resultInfo.corpNameKr}"/>" />
			</td>
			<th rowspan="2">대표자 <strong class="point">*</strong></th>
			<th>국문 <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="repreNameKr" name="repreNameKr" value="<c:out value="${resultInfo.repreNameKr}"/>" />
			</td>
		</tr>

		<tr>
			<th>영문 <strong class="point">*</strong></th>
			<td colspan="3">
				<input type="text" class="form_text w100p" id="corpNameEn" name="corpNameEn" value="<c:out value="${resultInfo.corpNameEn}"/>" />
			</td>
			<th>영문 <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text w100p" id="repreNameEn" name="repreNameEn" value="<c:out value="${resultInfo.repreNameEn}"/>" />
			</td>
		</tr>

		<tr>
			<th colspan="2" rowspan="2">주소</th>
			<td colspan="3" rowspan="2">
				<input type="text" name="corpZipcode" id="corpZipcode" class="form_text" style="width: 25%; margin-bottom: 5px;" readonly="readonly" value="<c:out value="${resultInfo.corpZipcode}"/>" maxlength="6"/>
				<input type="text" name="corpAddr1" id="corpAddr1" class="form_text" style="width: 74%; margin-bottom: 5px;" readonly="readonly" value="<c:out value="${resultInfo.corpAddr1}"/>" maxlength="60" /><br/>
				<input type="text" name="corpAddr2" id="corpAddr2" class="form_text" style="width: 100%;" readonly="readonly" value="<c:out value="${resultInfo.corpAddr2}"/>" maxlength="30" />
			</td>
			<th colspan="2">회사전화</th>
			<td>
				<input type="text" class="form_text w100p" id="corpTelno" name="corpTelno" value="<c:out value="${resultInfo.corpTelno}"/>" maxlength=""/>
			</td>
		</tr>

		<tr>
			<th colspan="2">휴대전화</th>
			<td>
				<input type="text" class="form_text w100p" id="corpHpno" name="corpHpno" value="<c:out value="${resultInfo.corpHpno}"/>" maxlength="20"/>
			</td>
		</tr>

		<tr>
			<th colspan="2">대표 E-Mail</th>
			<td colspan="6" style="text-align: left;">
				<input type="text" class="form_text" name="corpEmail1" id="corpEmail1" style="width: 25%" maxlength="40" value="<c:out value="${resultInfo.corpEmail1}"/>" />
				<span>@</span>
				<input type="text" class="form_text" name="corpEmail2" id="corpEmail2" style="width: 25%" maxlength="40" value="<c:out value="${resultInfo.corpEmail2}"/>" />
				<select class="form_select" id="checkCorpEmail" onChange="setmail(this.value, 'corpEmail2');" >
					<c:forEach var="COM014" items="${COM014}" varStatus="status">
						<option value="<c:out value="${COM014.cdNm}"/>" ><c:out value="${COM014.cdNm}"/></option>
					</c:forEach>
				</select>
			</td>
		</tr>

	</table>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">카드사 선택</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col width="15%"/>
			<col />
		</colgroup>
		<tr>
			<th>카드사 선택<br/>(중복선택 가능)</th>
			<td>
				<c:forEach var="result" items="${cardList}" varStatus="status">
					<label class="label_form">
						<c:choose>
							<c:when test="${result.cardUseYn eq 'Y'}">
								<input type="checkbox" class="form_checkbox" checked="true"  id="cardCode_${result.cardCode}" onclick="return false;" value="${result.cardCode}">
								<span class="label"><c:out value="${result.cardName}"/></span>
							</c:when>
							<c:otherwise>
								<input type="checkbox" class="form_checkbox" id="cardCode_${result.cardCode}" onclick="return false;" value="${result.cardCode}" onchange="">
								<span class="label"><c:out value="${result.cardName}"/></span>
							</c:otherwise>
						</c:choose>
						<br/>
					</label>
				</c:forEach>
			</td>
		</tr>
	</table>
	<div class="mt-10">
		<p>※ 발급 카드 종류 및 발급 매수는 발급 진행 시 카드사와 협의 후 결정 하실 수 있습니다.</p>
		<p>※ 카드 발급 후 추가발급/갱신은 해당 카드사에 문의해 주시기 바랍니다.</p>
	</div>
</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){

		setMailBalnk();
	});

	function goList() {

		$('#frm').attr('action', '/kitaCard/kitaCardIssueMngList.do');
		$('#frm').submit();

	}

	function setmail(domain, targetId) {

		if(domain == ""){
			domain = "";
			$("#"+targetId).attr('readOnly',false);
			$("#"+targetId).val(domain);
			$("#"+targetId).focus();
		} else {
			$("#"+targetId).attr('readOnly',true);
			$("#"+targetId).val(domain);
		}
	}

	function setMailBalnk() {
		$('#checkCorpEmail').prepend('<option value="">직접입력</option>');

		if($('#checkCorpEmail').val() != $('#manEmail02').val() ){
			$('#checkCorpEmail option:eq(0)').attr('selected', 'selected');
		}
	}

	function saveValid(){

		var numChk = /[^0-9]/;

		if( $('#tradeNo').val() == '' ){
			alert('무역업고유번호는 필수입니다.');
			$('#tradeNo').focus();
			return false;
		} else {
			if(numChk.test($('#tradeNo').val())) {
				alert('숫자만 입력해 주세요.');
				$('#tradeNo').focus();
				return false;
			}
		}

		if( $('#corpNo').val() == '' ){
			alert('법인번호는 필수입니다.');
			$('#corpNo').focus();
			return false;
		} else {
			if(numChk.test($('#corpNo').val())) {
				alert('숫자만 입력해 주세요.');
				$('#corpNo').focus();
				return false;
			}
		}

		if( $('#corpRegNo').val() == '' ){
			alert('사업자등록번호는 필수입니다.');
			$('#corpRegNo').focus();
			return false;
		} else {
			if(numChk.test($('#corpRegNo').val())) {
				alert('숫자만 입력해 주세요.');
				$('#corpRegNo').focus();
				return false;
			}
		}

		if( $('#corpNameKr').val() == '' ){
			alert('회사명은 필수입니다.');
			$('#corpNameKr').focus();
			return false;

		}

		if( $('#corpNameEn').val() == '' ){
			alert('회사명은 필수입니다.');
			$('#corpNameEn').focus();
			return false;

		}

		if( $('#repreNameKr').val() == '' ){
			alert('대표자명은 필수입니다.');
			$('#repreNameKr').focus();
			return false;

		}

		if( $('#repreNameEn').val() == '' ){
			alert('대표자명은 필수입니다.');
			$('#repreNameEn').focus();
			return false;

		}

		return true;
	}

	function doSave() {

		if(!saveValid()){	// 회사상세정보 validation
			return false;
		}

		if(!confirm("저장하시겠습니까?")){
			return false;
		}

		var pParamData = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/kitaCard/updateKitaCardIssueMng.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pParamData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}

</script>