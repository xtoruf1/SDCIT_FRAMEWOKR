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

<input type="hidden" name="foreignVisaId" id="foreignVisaId" value="<c:out value="${result.foreignVisaId}"/>"/>
<input type="hidden" name="certMngId" id="certMngId" value="<c:out value="${result.certMngId}"/>"/>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
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
			<td><c:out value="${result.companyName}"/></p><p class="engTag hidden"><c:out value="${result.companyNameEng}"/></td>
			<th>사업자번호</th>
			<td><c:out value="${result.businessNo}"/></td>
		</tr>
		<tr>
			<th>대표자</th>
			<td><c:out value="${result.ceoName}"/></p><p class="engTag hidden"><c:out value="${result.ceoNameEng}"/></td>
			<th>무역업고유번호</th>
			<td><c:out value="${result.tradeNo}"/></td>
		</tr>
		<tr>
			<th>취급품목</th>
			<td><c:out value="${result.item}"/></td>
			<th>전년도수출실적</th>
			<td><c:out value="${result.lastTotalAmt}"/></td>
		</tr>
		<tr>
			<th>주소</th>
			<td colspan="3"><c:out value="${result.address}"/></p><p class="engTag hidden"><c:out value="${result.addressEng}"/></td>
		</tr>
		<tr>
			<th>신청일</th>
			<td><c:out value="${result.reqDate}"/></td>
			<th>상태</th>
			<td><c:out value="${result.statusNm}"/></td>
		</tr>
		<tr>
			<th>첨부파일</th>
			<td colspan="3">
				<c:if test="${not empty fileList}">
					<c:forEach var="result" items="${fileList}" varStatus="status">
						<p>
							<span class="attr_list">
								<c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${result.groupId}"/>', '<c:out value="${result.attachSeq}"/>', '<c:out value="${result.fileSeq}"/>');"><c:out value="${result.fileNm}"/> ( <c:out value="${result.fileSize}"/> byte )</a>
							</span>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/common/fileDownload.do?groupId=${result.groupId}&attachSeq=${result.attachSeq}&fileSeq=${result.fileSeq}','<c:out value="${result.fileNm}"/>', '<c:out value="${serverName}_foreignVisa_${result.groupId}_${result.attachSeq}_${result.fileSeq}"/>')" >
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
	<c:forEach var="appUser" items="${userList}">

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
				<td><c:out value="${appUser.reqName}"/></td>
				<th>여권번호</th>
				<td><c:out value="${appUser.passport}"/></td>
			</tr>
			<tr>
				<th>성별</th>
				<td><c:out value="${appUser.sex}"/></td>
				<th>생년월일</th>
				<td><c:out value="${appUser.birthDate}"/></td>
			</tr>
			<tr>
				<th>국적</th>
				<td><c:out value="${appUser.nationalNm}"/></td>
				<th>전화번호</th>
				<td><c:out value="${appUser.phone}"/></td>
			</tr>
			<tr>
				<th>주소</th>
				<td colspan="3"><c:out value="${appUser.reqAddress}"/></td>
			</tr>
			<tr>
				<th>주요학력</th>
				<td colspan="3"><c:out value="${appUser.education}"/></td>
			</tr>
			<tr>
				<th>주요경력</th>
				<td colspan="3"><c:out value="${appUser.career}"/></td>
			</tr>
			<tr>
				<th>고용사유</th>
				<td colspan="3"><c:out value="${appUser.employReason}"/></td>
			</tr>
			<tr>
				<th>고용기간</th>
				<td><c:out value="${appUser.startDate} ~ ${appUser.endDate}" escapeXml="false" /></td>
				<th>근무처 및 담당업무</th>
				<td><c:out value="${appUser.employDscr}" escapeXml="false" /></td>
			</tr>
		</table>
		<br>
	</c:forEach>
</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
	});

	/*목록 이동*/
	function goList() {

		$('#frm').attr('action', '/issue/recommend/foreignVisaList.do');
		$('#frm').submit();

	}

	/*
	//국문표시
	function doShowKor(){
		$('#showKor').removeClass("btn_secondary");
		$('#showKor').addClass("btn_primary");
		$('#showEng').removeClass("btn_primary");
		$('#showEng').addClass("btn_secondary");
		$('.korTag').show();
		$('.engTag').hide();
	}

	//영문표시
	function doShowEng(){
		$('#showKor').removeClass("btn_primary");
		$('#showKor').addClass("btn_secondary");
		$('#showEng').removeClass("btn_secondary");
		$('#showEng').addClass("btn_primary");

		$('.korTag').hide();
		$('.engTag').removeClass("hidden");
		$('.engTag').show();
	}
	*/

	//파일다운로드
	function doDownloadFile(groupId, attachSeq, fileSeq){
		$('#frm').attr('action', '<c:url value="/common/fileDownload.do" />?groupId='+groupId+'&attachSeq='+attachSeq+'&fileSeq='+fileSeq);
		$('#frm').submit();
	}

	//승인팝업
	function callApplyPopup(){

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/issue/recommend/popup/foreignVisaApply.do'
			, params : { foreignVisaId : $('#foreignVisaId').val()
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
			popupUrl : '/issue/recommend/popup/foreignVisaReject.do'
			, params : { foreignVisaId : $('#foreignVisaId').val()
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
			url : '<c:url value="/issue/recommend/resetPrintForeignVisa.do" />'
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
			popupUrl : '/issue/recommend/popup/foreignVisaAgreement.do'
			, params : {foreignVisaId : $('#foreignVisaId').val()}
		});
	}
</script>