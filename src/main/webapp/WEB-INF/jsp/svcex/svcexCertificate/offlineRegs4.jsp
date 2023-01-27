<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form id="viewForm" name="viewForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="event"					id="event" />
	<input type="hidden" name="memberId"				id="memberId"				value = "<c:out value="${resultView.memberId}"/>"  >
	<input type="hidden" name="bsNo"					id="bsNo"					value = "<c:out value="${resultView.bsNo}"/>"  />
	<input type="hidden" name="currencyTotalAttFileId"	id="currencyTotalAttFileId"	value = "<c:out value="${resultView.currencyTotalAttFileId}"/>"/>
	<input type="hidden" name="reqno"					id="reqno"					value = "<c:out value="${resultView.reqno}"/>"  >
	<input type="hidden" name="stateCd"					id="stateCd"				value = "<c:out value="${resultView.stateCd}"/>"/>
	<input type="hidden" name="coHp"					id="coHp"					value = "<c:out value="${resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>"/>
	<input type="hidden" name="coEmail"					id="coEmail"				value = "<c:out value="${resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>"/>
	<input type="hidden" name="reqnoDetail"				id="reqnoDetail"			value = "<c:out value="${resultView2.reqno}"/>"  >
	<input type="hidden" name="transportServiceCd"		id="transportServiceCd"		value = "<c:out value="${svcexVO.transportServiceCd}"/>"/>
	<input type="hidden" name="fileId"					id="fileId"					value = ""/>
	<input type="hidden" name="fileInputName"			id="fileInputName"			value = ""/>
	<!-- 페이지 위치 -->
	<div class="location">
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
					<td><c:out value="${resultView.companyKor}"/></td>
					<th>대표자명</th>
					<td><c:out value="${resultView.presidentKor}"/></td>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td><c:out value="${resultView.enterRegNo1}"/>-<c:out value="${resultView.enterRegNo2}"/>-<c:out value="${resultView.enterRegNo3}"/></td>
					<th>무역업고유번호</th>
					<td><c:out value="${resultView.memberId}"/></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3"><c:out value="${resultView.korAddr1}"/> <c:out value="${resultView.korAddr2}"/></td>
				</tr>

				<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
				<tr>
					<th>수출입실적 확인기간</th>
					<td colspan="3">
						<fmt:parseDate value="${resultView.amountSdate}" var="amountSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView.amountEdate}" var="amountEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${amountSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${amountEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" name="amountSdate" id="amountSdate" value="${resultView.amountSdate}"/>
						<input type="hidden" name="amountEdate" id="amountEdate" value="${resultView.amountEdate}"/>
					</td>
				</tr>
				</c:if>

				<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
				<tr>
					<th>수출입실적 확인기간</th>
					<td colspan="3">
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView.amountSdate}" var="amountSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="amountSdate" id="amountSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${amountSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView.amountEdate}" var="amountEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="amountEdate" id="amountEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${amountEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
				</tr>
				</c:if>
				<tr>
					<th>발급용도</th>
					<td colspan="3">
						<input type="text" class="form_text" name="issueUse" id="issueUse"   maxlength="100" value="<c:out value="${resultView.issueUse }"/>" desc="발급용도" isrequired="true">
					</td>
				</tr>
				<tr>
					<th>외국에서 입금한<br>외화 총액 확인서</th>
					<td colspan="3">
						<div class="form_row w100p">
						<c:if test="${!empty fileListRow}" >
							<div id="currencyAttFileList" name="currencyAttFileList" class="w50p">
								<c:forEach var="fileList" items="${fileListRow}" varStatus="status">
									<p>
										<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
										<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
											<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
										</button>
									</p>
								</c:forEach>
							</div>
						</c:if>
						<c:if test="${empty fileListRow}" >
							<div id="currencyAttFileList" name="currencyAttFileList" class="w50p"></div>
						</c:if>
						<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
							<button class="btn_tbl" type="button" onclick="viewFiles('currencyTotalAttFileId');">찾아보기</button>
						</c:if>
						</div>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
	</div>

	<div class="cont_block">
		<table class="formTable dataTable">
			<colgroup>
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:30%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="col" colspan="2">용역명</th>
					<th scope="col">기 간</th>
					<th scope="col">금 액(US $)</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th class="align_ctr" colspan="2">합  계</th>
					<td colspan="2">
						<input type="text" class="form_text" name="sumIncome" id="sumIncome" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" maxlength="300" readonly="" value="<c:out value="${resultView2.sumIncome }"/>">
					</td>
				</tr>
			</tfoot>
			<tbody>
				<tr>
					<th rowspan="2">운임수입</th>
					<th scope="col">국내수출입화물 운임수입</th>

					<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<td>
						<fmt:parseDate value="${resultView2.domesticEiFrightSdate}" var="domesticEiFrightSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView2.domesticEiFrightEdate}" var="domesticEiFrightEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${domesticEiFrightSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${domesticEiFrightEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" size="10" maxlength="8" name="domesticEiFrightSdate" id="domesticEiFrightSdate" value="<c:out value="${resultView2.domesticEiFrightSdate }"/>">
						<input type="hidden" size="10" maxlength="8" name="domesticEiFrightEdate" id="domesticEiFrightEdate" value="<c:out value="${resultView2.domesticEiFrightEdate }"/>">
					</td>
					</c:if>

					<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.domesticEiFrightSdate}" var="domesticEiFrightSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="domesticEiFrightSdate" id="domesticEiFrightSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${domesticEiFrightSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.domesticEiFrightEdate}" var="domesticEiFrightEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="domesticEiFrightEdate" id="domesticEiFrightEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${domesticEiFrightEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					</c:if>
					<td>
						<input type="text" class="form_text" name="domesticEiFrightReceipts" class="input" id="domesticEiFrightReceipts" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onchange="doSum()" maxlength="300" value="<c:out value="${resultView2.domesticEiFrightReceipts }"/>" desc="국내수출입화물 운임수입">
					</td>
				</tr>
				<tr>
					<th>삼국간 화물 운임수입</th>

					<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<td>
						<fmt:parseDate value="${resultView2.tripleFrightSdate}" var="tripleFrightSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView2.tripleFrightEdate}" var="tripleFrightEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${tripleFrightSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${tripleFrightEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" size="10" maxlength="8" name="tripleFrightSdate" id="tripleFrightSdate" value="<c:out value="${resultView2.tripleFrightSdate }"/>">
						<input type="hidden" size="10" maxlength="8" name="tripleFrightEdate" id="tripleFrightEdate" value="<c:out value="${resultView2.tripleFrightEdate }"/>">
					</td>
					</c:if>

					<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.tripleFrightSdate}" var="tripleFrightSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="tripleFrightSdate" id="tripleFrightSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${tripleFrightSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.tripleFrightEdate}" var="tripleFrightEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="tripleFrightEdate" id="tripleFrightEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${tripleFrightEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					</c:if>

					<td>
						<input type="text" class="form_text" name="tripleFrightReceipts" id="tripleFrightReceipts" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onchange="doSum()" maxlength="300" value="<c:out value="${resultView2.tripleFrightReceipts }"/>">
					</td>
				</tr>
				<tr>
					<th colspan="2">외국인에 대한 대선 수입</th>

					<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<td>
						<fmt:parseDate value="${resultView2.foriengnSdate}" var="foriengnSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView2.foriengnEdate}" var="foriengnEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${foriengnSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${foriengnEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" size="10" maxlength="8" name="foriengnSdate" id="foriengnSdate" value="<c:out value="${resultView2.foriengnSdate }"/>">
						<input type="hidden" size="10" maxlength="8" name="foriengnEdate" id="foriengnEdate" value="<c:out value="${resultView2.foriengnEdate }"/>">
					</td>
					</c:if>

					<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.foriengnSdate}" var="foriengnSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="foriengnSdate" id="foriengnSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${foriengnSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.foriengnEdate}" var="foriengnEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="foriengnEdate" id="foriengnEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${foriengnEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					</c:if>

					<td>
						<input type="text" class="form_text" name="foriengnRevenue" id="foriengnRevenue" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onchange="doSum()" maxlength="300" value="<c:out value="${resultView2.foriengnRevenue }"/>">
					</td>
				</tr>
				<tr>
					<th rowspan="2">터미널 운영수입</th>
					<th>국내터미널 운영수입</th>


					<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<td>
						<fmt:parseDate value="${resultView2.domesticTermOperRevSdate}" var="domesticTermOperRevSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView2.domesticTermOperRevEdate}" var="foriengnEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${domesticTermOperRevSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${domesticTermOperRevEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" size="10" maxlength="8" name="domesticTermOperRevSdate" id="domesticTermOperRevSdate" value="<c:out value="${resultView2.domesticTermOperRevSdate }"/>">
						<input type="hidden" size="10" maxlength="8" name="domesticTermOperRevEdate" id="domesticTermOperRevEdate" value="<c:out value="${resultView2.domesticTermOperRevEdate }"/>">
					</td>
					</c:if>

					<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.domesticTermOperRevSdate}" var="domesticTermOperRevSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="domesticTermOperRevSdate" id="domesticTermOperRevSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${domesticTermOperRevSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.domesticTermOperRevEdate}" var="domesticTermOperRevEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="domesticTermOperRevEdate" id="domesticTermOperRevEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${domesticTermOperRevEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					</c:if>

					<td>
						<input type="text" class="form_text" name="domesticTermOperRevenue" id="domesticTermOperRevenue" onkeypress="doKeyPressEvent(this, 'NUMBER', event);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onchange="doSum()" maxlength="300" value="<c:out value="${resultView2.domesticTermOperRevenue }"/>">
					</td>
				</tr>
				<tr>
					<th>국외터미널 운영수입</th>

					<c:if test="${resultView.stateCd eq 'E' || resultView.stateCd eq 'F' }">
					<td>
						<fmt:parseDate value="${resultView2.foreignTermOperSdate}" var="foreignTermOperSdate" pattern="yyyyMMdd"/>
						<fmt:parseDate value="${resultView2.foreignTermOperEdate}" var="foreignTermOperEdate" pattern="yyyyMMdd"/>
						<fmt:formatDate value="${foreignTermOperSdate}" pattern="yyyy-MM-dd"/>
						<span class="spacing">~</span>
						<fmt:formatDate value="${foreignTermOperEdate}" pattern="yyyy-MM-dd"/>
						<input type="hidden" size="10" maxlength="8" name="foreignTermOperSdate" id="foreignTermOperSdate" value="<c:out value="${resultView2.foreignTermOperSdate }"/>">
						<input type="hidden" size="10" maxlength="8" name="foreignTermOperEdate" id="foreignTermOperEdate" value="<c:out value="${resultView2.foreignTermOperEdate }"/>">
					</td>
					</c:if>

					<c:if test="${resultView.stateCd ne 'E' && resultView.stateCd ne 'F' }">
					<td>
						<div class="form_row w100p">
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.foreignTermOperSdate}" var="foreignTermOperSdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="foreignTermOperSdate" id="foreignTermOperSdate"  size="10" maxlength="8" value="<fmt:formatDate value="${foreignTermOperSdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
							<span class="spacing">~</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<fmt:parseDate value="${resultView2.foreignTermOperEdate}" var="foreignTermOperEdate" pattern="yyyyMMdd"/>
									<input type="text" class="txt datepicker" name="foreignTermOperEdate" id="foreignTermOperEdate"  size="10" maxlength="8" value="<fmt:formatDate value="${foreignTermOperEdate}" pattern="yyyy-MM-dd"/>" isrequired="true" >
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</div>
					</td>
					</c:if>

					<td>
						<input type="text" class="form_text" name="foreignTermOperRevenue" id="foreignTermOperRevenue" onkeypress="doKeyPressEvent(this);" onfocus="doNumberFloatFocusEvent(this);" onblur="doNumberFloatBlurEvent(this);" onchange="doSum()" maxlength="300" value="<c:out value="${resultView2.foreignTermOperRevenue }"/>">
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
	</div>

</form>

<script type="text/javascript">
	var f;

	$(document).ready(function(){
		f = document.viewForm;
	});

	function doNextPage(){
		f.event.value = "";
		f.action = "/svcex/svcexCertificate/applyList.do";
		f.target = "_self";
		f.submit();
	}
	function doPrvPage(){
		if(!confirm("이전 페이지로 이동 하시겠습니까?")){
			return;
		}
		f.event.value = "";
		f.action = "/svcex/svcexCertificate/offlineRegs2View.do";
		f.target = "_self";
		f.submit();
	}
	function doCurrPage(){
		f.event.value = "";
		f.action = "/svcex/svcexCertificate/offlineRegs4View.do";
		f.target = "_self";
		f.submit();
	}

	// 저장 프로세스 gubun 1: 임시저장 2: 승인
	function doSave(gubun){
		var d1 = f.amountSdate; //수출입실적 확인기간
		var d2 = f.amountEdate; //수출입실적 확인기간

		if( !isValid() ) { return; };
		//if( !checkDate(d1) ) { return; };
		//if( !checkDate(d2) ) { return; };

		if(gubun == "2" ){
			if(!confirm("승인 후엔 E-Mail과 알림톡이 발송 됩니다. \n계속 하시겠습니까?")){ return; }
		}else{
			if(!confirm("임시저장 하시겠습니까?")){ return; }
		}

		f.domesticEiFrightReceipts.value = f.domesticEiFrightReceipts.value.replace(/,/gi ,"");
		f.tripleFrightReceipts.value = f.tripleFrightReceipts.value.replace(/,/gi ,"");
		f.foriengnRevenue.value = f.foriengnRevenue.value.replace(/,/gi ,"");
		f.domesticTermOperRevenue.value = f.domesticTermOperRevenue.value.replace(/,/gi ,"");
		f.foreignTermOperRevenue.value = f.foreignTermOperRevenue.value.replace(/,/gi ,"");
		f.amountSdate.value =  $('#amountSdate').val().replace(/-/gi,'');
		f.amountEdate.value =  $('#amountEdate').val().replace(/-/gi,'');
		f.domesticEiFrightSdate.value = $('#domesticEiFrightSdate').val().replace(/-/gi,'');
		f.domesticEiFrightEdate.value = $('#domesticEiFrightEdate').val().replace(/-/gi,'');
		f.tripleFrightSdate.value = $('#tripleFrightSdate').val().replace(/-/gi,'');
		f.tripleFrightEdate.value = $('#tripleFrightEdate').val().replace(/-/gi,'');
		f.foriengnSdate.value = $('#foriengnSdate').val().replace(/-/gi,'');
		f.foriengnEdate.value = $('#foriengnEdate').val().replace(/-/gi,'');
		f.domesticTermOperRevSdate.value = $('#domesticTermOperRevSdate').val().replace(/-/gi,'');
		f.domesticTermOperRevEdate.value = $('#domesticTermOperRevEdate').val().replace(/-/gi,'');
		f.foreignTermOperSdate.value = $('#foreignTermOperSdate').val().replace(/-/gi,'');
		f.foreignTermOperEdate.value = $('#foreignTermOperEdate').val().replace(/-/gi,'');

		if( f.reqnoDetail.value == "" ) {
			if(gubun == "1" ){
				f.event.value = "TradeConfirmation4Save";
			}else{
				f.stateCd.value = "E";
				f.event.value = "TradeConfirmation4SaveNext";
			}
		}else{
			if(gubun == "1" ){
				f.event.value = "TradeConfirmation4Update";
			}else{
				f.stateCd.value = "E";
				f.event.value = "TradeConfirmation4UpdateNext";
			}
		}

		global.ajaxSubmit($('#viewForm'), {
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/insertOfflineReg4Save.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				var eventValue = f.event.value;
				if( eventValue == "TradeConfirmation4Save" || eventValue == "TradeConfirmation4Update" ) {
					//alert("임시저장 신청이 완료되었습니다.");
					doCurrPage();
				}else if( eventValue == "TradeConfirmation4SaveNext" || eventValue == "TradeConfirmation4UpdateNext" ) {
					//alert("저장이 완료되었습니다.\n다음 페이지로 이동합니다.");
					doNextPage();
				}
	        }
		});
	}

	function isValid() {
		var amountSdate =  parseInt($('#amountSdate').val().replace(/-/gi,''));
		var amountEdate =  parseInt($('#amountEdate').val().replace(/-/gi,''));
		var domesticEiFrightSdate = parseInt($('#domesticEiFrightSdate').val().replace(/-/gi,''));
		var domesticEiFrightEdate = parseInt($('#domesticEiFrightEdate').val().replace(/-/gi,''));
		var tripleFrightSdate = parseInt($('#tripleFrightSdate').val().replace(/-/gi,''));
		var tripleFrightEdate = parseInt($('#tripleFrightEdate').val().replace(/-/gi,''));
		var foriengnSdate = parseInt($('#foriengnSdate').val().replace(/-/gi,''));
		var foriengnEdate = parseInt($('#foriengnEdate').val().replace(/-/gi,''));
		var domesticTermOperRevSdate = parseInt($('#domesticTermOperRevSdate').val().replace(/-/gi,''));
		var domesticTermOperRevEdate = parseInt($('#domesticTermOperRevEdate').val().replace(/-/gi,''));
		var foreignTermOperSdate = parseInt($('#foreignTermOperSdate').val().replace(/-/gi,''));
		var foreignTermOperEdate = parseInt($('#foreignTermOperEdate').val().replace(/-/gi,''));


		if( f.amountSdate.value == "" ){
			alert("수출입실적 확인기간 시작날짜를 입력하십시요");
			f.amountSdate.focus();
			return false;
		}
		if( f.amountEdate.value == "" ){
			alert("수출입실적 확인기간 종료날짜를 입력하십시요");
			f.amountEdate.focus();
			return false;
		}
		if( f.issueUse.value == "" ){
			alert("발급용도를 입력하십시요");
			f.issueUse.focus();
			return false;
		}
		if( amountSdate > amountEdate ){
			alert("수출입실적 확인기간 날짜를 바르게 입력하십시요");
			f.amountSdate.focus();
			return false;
		}

		if( f.domesticEiFrightSdate.value != "" || f.domesticEiFrightEdate.value != ""){
			if( domesticEiFrightSdate > domesticEiFrightEdate ){
				alert("국내수출입화물 운임수입 날짜를 바르게 입력하십시요");
				f.domesticEiFrightSdate.focus();
				return false;
			}
			if( f.domesticEiFrightReceipts.value == "" ){
				alert("국내수출입화물 운임수입 금액을 입력하십시요");
				f.domesticEiFrightReceipts.focus();
				return false;
			}
		}
		if( f.tripleFrightSdate.value != "" || f.tripleFrightEdate.value != ""){
			if( tripleFrightSdate > tripleFrightEdate ){
				alert("삼국간 화물 운임수입 날짜를 바르게 입력하십시요");
				f.tripleFrightSdate.focus();
				return false;
			}
			if( f.tripleFrightReceipts.value == "" ){
				alert("삼국간 화물 운임수입 금액을 입력하십시요");
				f.tripleFrightReceipts.focus();
				return false;
			}
		}
		if( f.foriengnSdate.value != "" || f.foriengnEdate.value != ""){
			if( foriengnSdate > foriengnEdate ){
				alert("외국인에 대한 대선 수입 날짜를 바르게 입력하십시요");
				f.foriengnSdate.focus();
				return false;
			}
			if( f.foriengnRevenue.value == "" ){
				alert("외국인에 대한 대선 수입 금액을 입력하십시요");
				f.foriengnRevenue.focus();
				return false;
			}
		}
		if( f.domesticTermOperRevSdate.value != "" || f.domesticTermOperRevEdate.value != ""){
			if( domesticTermOperRevSdate > domesticTermOperRevEdate ){
				alert("국내터미널 운영수입 날짜를 바르게 입력하십시요");
				f.domesticTermOperRevSdate.focus();
				return false;
			}
			if( f.domesticTermOperRevenue.value == "" ){
				alert("국내터미널 운영수입 금액을 입력하십시요");
				f.domesticTermOperRevenue.focus();
				return false;
			}
		}
		if( f.foreignTermOperSdate.value != "" || f.foreignTermOperEdate.value != ""){
			if( foreignTermOperSdate > foreignTermOperEdate){
				alert("국외터미널 운영수입 날짜를 바르게 입력하십시요");
				f.domesticTermOperRevSdate.focus();
				return false;
			}
			if( f.foreignTermOperRevenue.value == "" ){
				alert("국외터미널 운영수입 금액을 입력하십시요");
				f.foreignTermOperRevenue.focus();
				return false;
			}
		}

		return true;
	}

	function doSum(){
		var val1 = Number(f.domesticEiFrightReceipts.value.replace(/,/gi ,""));
		var val2 = Number(f.tripleFrightReceipts.value.replace(/,/gi ,""));
		var val3 = Number(f.foriengnRevenue.value.replace(/,/gi ,""));
		var val4 = Number(f.domesticTermOperRevenue.value.replace(/,/gi ,""));
		var val5 = Number(f.foreignTermOperRevenue.value.replace(/,/gi ,""));

		f.sumIncome.value = plusComma(val1+val2+val3+val4+val5);
	}

	function checkDate(obj){
		var sYear = Trim(obj.value.substring(0,4));
		var sMonth = Trim(obj.value.substring(4,6));
		var sDay = Trim(obj.value.substring(6,8));
		if(sYear.length<1||sYear.length!=4)  {
			alert("년도는 4자리입니다!");
			obj.focus();
			return false;
		}
		if(sMonth.length<1||sMonth.length!=2)  {
			alert("월은 2자리입니다!");
			obj.focus();
			return false;
		}
		if(sDay.length<1||sDay.length!=2)  {
			alert("날짜는 2자리입니다!");
			obj.focus();
			return false;
		}
		if(!isNumber(sYear))  {
			alert("년도는 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		if(!isNumber(sMonth))  {
			alert("월은 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		if(!isNumber(sDay))  {
			alert("날짜는 숫자만 입력하십시요!");
			obj.focus();
			return false;
		}
		var days = lastDay(sYear + sMonth);
		if((sMonth == '00')||(sMonth >12))  {
			alert(sMonth+'월의 입력이 잘못 되었습니다!');
			obj.focus();
			return false;
		}
		if((sDay > days)||(sDay == '00'))  {
			alert(sDay+"일의 입력이 잘못되었습니다!");
			obj.focus();
			return false;
		}
		return true;
	}

	function isNumber(value) {
	    if (isNaN(value)) { // 값이 NaN 이면 숫자 아님.
	        return false;
	    }
	    return true;
	}

	function lastDay(sYM){
		if(sYM.length != 6){
			alert("정확한 년월을 입력하십시요.");
			return;
		}
		if(!isDateYM(sYM)){
			return;
		}
		daysArray = new makeArray(12);    // 배열을 생성한다.

		for (i=1; i<8; i++){
			daysArray[i] = 30 + (i%2);
		}
		for (i=8; i<13; i++){
			daysArray[i] = 31 - (i%2);
		}
		var sYear = sYM.substring(0, 4) * 1;
		var sMonth	= sYM.substring(4, 6) * 1;
		if (((sYear % 4 == 0) && (sYear % 100 != 0)) || (sYear % 400 == 0)){
			daysArray[2] = 29;
		}else{
			daysArray[2] = 28;
		}

		return daysArray[sMonth].toString();
	}

	function isDateYM(sYM){
		// 숫자 확인
		if(!isNumber(sYM)){
			alert('날짜는 숫자만 입력하십시오');
			return false;
		}
		// 길이 확인
		if(sYM.length != 6){
			alert('일자를 모두 입력하십시오');
			return false;
		}

		var iYear = parseInt(sYM.substring(0,4)); //년도값을 숫자로
		var iMonth = parseInt(trimZero(sYM.substring(4,6)));  //월을 숫자로

		if((iMonth < 1) ||(iMonth >12)){
			return false;
		}
		return true;
	}

	function Trim(sVal){
		return(LTrim(RTrim(sVal)));
	}
	function LTrim(sVal)	{
		var i;
		i = 0;
		while (sVal.substring(i,i+1) == ' '){
			i++;
		}
		return sVal.substring(i);
	}
	function RTrim(sVal)	{
		var i = sVal.length - 1;
		while (i >= 0 && sVal.substring(i,i+1) == ' ') {
			i--;
		}
		return sVal.substring(0,i+1);
	}
	function trimZero(sVal){
		if(sVal.charAt(0) == '0'){
			return sVal.substring(1,sVal.length);
		}else{
			return sVal;
		}
	}

	function viewFiles(){
		var paramFileId = f.currencyTotalAttFileId.value;
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/svcex/svcexCertificate/popup/offlineRegsFileList.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
				fileId : paramFileId
				, fileInputName : "currencyTotalAttFileId"
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if( resultObj.length > 0 ){
					ReloadFileList( resultObj[0] );
				}
			}
		});
	}
	function ReloadFileList(fileId) {
		f.currencyTotalAttFileId.value = fileId;
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
				$("#currencyAttFileList").html(data.fileNm.replaceAll(',', '<br/>'));
			}
		});
	}
	function doDownloadFile(fileId, fileNo) {
		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","get");
		newForm.attr("action","/supves/supvesFileDownload.do");
		newForm.attr("target","_blank");
		newForm.append($('<input/>', {type: 'hidden', name: 'fileId', value: fileId }));
		newForm.append($('<input/>', {type: 'hidden', name: 'fileNo', value: fileNo }));
		newForm.appendTo('body');
		newForm.submit();
	}

</script>
