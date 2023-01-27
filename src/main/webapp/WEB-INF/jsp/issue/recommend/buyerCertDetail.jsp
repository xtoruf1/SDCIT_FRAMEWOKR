<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<form id="frm" name="frm" method="post">
<!-- 리스트 조회조건 파라미터 세팅 Start -->
<input type="hidden" name="sCompanyName" id="sCompanyName" value="<c:out value='${param.sCompanyName}'/>"/>
<input type="hidden" name="sBusinessNo" id="sBusinessNo" value="<c:out value='${param.sBusinessNo}'/>"/>
<input type="hidden" name="sTradeNo" id="sTradeNo" value="<c:out value='${param.sTradeNo}'/>"/>
<input type="hidden" name="sCeoName" id="sCeoName" value="<c:out value='${param.sCeoName}'/>"/>
<input type="hidden" name="sStatusCd" id="sStatusCd" value="<c:out value='${param.sStatusCd}'/>"/>
<input type="hidden" name="sPrintYn" id="sPrintYn" value="<c:out value='${param.sPrintYn}'/>"/>
<input type="hidden" name="sStartDate" id="sStartDate" value="<c:out value='${param.sStartDate}'/>"/>
<input type="hidden" name="sEndDate" id="sEndDate" value="<c:out value='${param.sEndDate}'/>"/>
<!-- 리스트 조회조건 파라미터 세팅 End -->

<input type="hidden" name="buyerVisaId" id="buyerVisaId" value="<c:out value="${result.buyerVisaId}"/>"/>
<input type="hidden" name="certMngId" id="certMngId" value="<c:out value="${result.certMngId}"/>"/>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 상태 값에 맞는 버튼 표시 -->
	<div class="ml-auto">
		<button type="button" id="btnAgreement" class="btn_sm btn_primary btn_modify_auth" onclick="callAgreementPopup();">신청서 및 동의서</button>
		<c:if test="${result.statusCd eq '20' or result.statusCd eq '30' or result.statusCd eq '40'}">
			<button type="button" id="btnApply" class="btn_sm btn_primary btn_modify_auth" onclick="callApplyPopup();">승인</button>
		</c:if>
		<c:if test="${result.statusCd eq '20' or result.statusCd eq '30'}">
			<button type="button" id="btnReject" class="btn_sm btn_secondary btn_modify_auth" onclick="callRejectPopup();">반려</button>
		</c:if>
		<c:if test="${result.printYn eq 'Y'}">
			<button type="button" id="btnResetPrint" class="btn_sm btn_primary btn_modify_auth" onclick="doResetPrint();">출력초기화</button>
		</c:if>
	</div>
	<!-- 상태 값에 맞는 버튼 표시 -->
	<div class="ml-15">
		<button type="button" id="btnList" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">신청 정보</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col style="width:40%" />
			<col style="width:10%" />
			<col style="width:40%" />
			<col />
		</colgroup>
		<tr>
			<th>회사명</th>
			<td><p class="korTag"><c:out value="${result.companyName}"/></p></td>
			<th>사업자번호</th>
			<td><c:out value="${result.businessNo}"/></td>
		</tr>
		<tr>
			<th>대표자</th>
			<td><p class="korTag"><c:out value="${result.ceoName}"/></p></td>
			<th>무역업고유번호</th>
			<td><c:out value="${result.tradeNo}"/></td>
		</tr>
		<tr>
			<th>취급품목</th>
			<td><p class="korTag"><c:out value="${result.item}"/></p></td>
			<th>전년도 수출실적</th>
			<td><p class="korTag"><c:out value="${result.lastTotalAmt}"/></p></td>
		</tr>
		<tr>
			<th>소재지</th>
			<td colspan="3"><p class="korTag"><c:out value="${result.address}"/></p></td>
		</tr>
		<tr>
			<th>담당자 명</th>
			<td><p class="korTag"><c:out value="${result.chargeName}"/></p><p class="engTag hidden"><c:out value="${result.chargeNameEng}"/></p></td>
			<th>담당자 부서 및 직위</th>
			<td><p class="korTag"><c:out value="${result.chargeDept}"/> / <c:out value="${result.chargePosition}"/></p></td>
		</tr>
		<tr>
			<th>담당자 이메일</th>
			<td><c:out value="${result.chargeEmail}"/></td>
			<th>담당자 전화</th>
			<td><c:out value="${result.chargePhone}"/></td>
		</tr>
		<tr>
			<th>신청일시</th>
			<td><c:out value="${result.reqDate}"/></td>
			<th>상태</th>
			<td><c:out value="${result.statusNm}"/></td>
		</tr>
		<tr>
			<th>출력여부</th>
			<td><c:if test="${result.printYn eq 'Y'}">출력</c:if><c:if test="${result.printYn ne 'Y'}">미출력</c:if></td>
		</tr>
		<tr>
			<th>첨부문서</th>
			<td colspan="3">
				<c:if test="${not empty fileList}">
					<c:forEach var="result" items="${fileList}" varStatus="status">
						<p>
							<span class="attr_list">
								<c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${result.groupId}"/>', '<c:out value="${result.attachSeq}"/>', '<c:out value="${result.fileSeq}"/>');"><c:out value="${result.fileNm}"/> ( <c:out value="${result.fileSize}"/> byte )</a>
							</span>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/common/fileDownload.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}','<c:out value="${result.fileNm}"/>', '<c:out value="${serverName}_overseasOffice_${result.groupId}_${result.attachSeq}_${result.fileSeq}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</p>
					</c:forEach>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>추천일</th>
			<td><c:out value="${result.appDate}"/></td>
			<th>추천번호</th>
			<td><c:out value="${result.appNo}"/></td>
		</tr>
		<c:if test="${result.statusCd eq '40'}">
			<!-- 반려상태일때만 반려 사유 표시 -->
			<tr>
				<th>반려사유</th>
				<td colspan="3"><c:out value="${fn:replace(result.rejectDscr, newLineChar, '<br/>')}" escapeXml="false" /></td>
			</tr>
		</c:if>
	</table>
</div>

<div class="cont_block">
	<div class="tit_bar">
		<h3 class="tit_block">신청자</h3>
	</div>
	<!-- 신청자는 따로 불러와서 신청자 수 만큼 반복 -->
	<c:forEach var="reqList" items="${reqList}" varStatus="status">
	<table class="formTable">
		<colgroup>
			<col style="width:10%" />
			<col style="width:40%" />
			<col style="width:10%" />
			<col style="width:40%" />
			<col />
		</colgroup>
		<tr>
			<th>성명</th>
			<td><p class="korTag"><c:out value="${reqList.reqName}"/></p></td>
			<th>여권번호</th>
			<td><p class="korTag"><c:out value="${reqList.passport}"/></p></td>
		</tr>
		<tr>
			<th>성별</th>
			<td><p class="korTag"><c:out value="${reqList.sex}"/></p></td>
			<th>생년월일</th>
			<td><p class="korTag"><c:out value="${reqList.birthDate}"/></p></td>
		</tr>
		<tr>
			<th>국적</th>
			<td><p class="korTag"><c:out value="${reqList.nationalNm}"/></p></td>
			<th>전화번호</th>
			<td><p class="korTag"><c:out value="${reqList.phone}"/></p></td>
		</tr>
		<tr>
			<th>직업</th>
			<td><p class="korTag"><c:out value="${reqList.reqJob}"/></p></td>
			<th>팩스번호</th>
			<td><p class="korTag"><c:out value="${reqList.fax}"/></p></td>
		</tr>
		<tr>
			<th>직장 및 주소</th>
			<td colspan="3"><p class="korTag"><c:out value="${reqList.reqAddress}"/></p></td>
		</tr>
		<tr>
			<th>체류예정기간</th>
			<td><p class="korTag"><c:out value="${reqList.startDate}"/> ~ <c:out value="${reqList.endDate}"/></p></td>
			<th>입국목적</th>
			<td><p class="korTag"><c:out value="${reqList.entryPurpose}"/></p></td>
		</tr>
		<tr>
			<th>방한사실</th>
			<td colspan="3"><p class="korTag"><c:out value="${reqList.pastVisit}"/></p></td>
		</tr>
		</table>
		</br>
		</c:forEach>
		<!-- 신청자 끝 -->
</form>

<script type="text/javascript">

	$(document).ready(function(){

	});

	/*목록 이동*/
	function goList() {

		$('#frm').attr('action', '/issue/recommend/buyerCertList.do');
		$('#frm').submit();

	}

	//파일다운로드
	function doDownloadFile(groupId, attachSeq, fileSeq){
		$('#frm').attr('action', '<c:url value="/common/fileDownload.do" />?groupId='+groupId+'&attachSeq='+attachSeq+'&fileSeq='+fileSeq);
		$('#frm').submit();
	}

	//승인팝업
	function callApplyPopup(){

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/issue/recommend/popup/buyerCertApply.do'
			, params : { buyerVisaId : $('#buyerVisaId').val()
						,certMngId : $('#certMngId').val()
				}
			, callbackFunction : function(resultObj){
				goList();
			}
		});
	}

	//반려팝업
	function callRejectPopup(){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/issue/recommend/popup/buyerCertReject.do'
			, params : { buyerVisaId : $('#buyerVisaId').val()
						,certMngId : $('#certMngId').val()
				}
			, callbackFunction : function(resultObj){
				goList();
			}
		});
	}

	//출력초기화
	function doResetPrint() {

		if(!confirm("출력을 초기화 하시겠습니까?")){
			return false;
		}
		global.ajax({
			url : '<c:url value="/issue/recommend/resetPrintBuyerCert.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				certMngId : '${result.certMngId}'
			}
			, async : true
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}

	//동의서 팝업
	function callAgreementPopup() {

		global.openLayerPopup({
			popupUrl : '/issue/recommend/popup/buyerCertAgreement.do'
			, params : {buyerVisaId : $('#buyerVisaId').val()}
		});
	}



</script>