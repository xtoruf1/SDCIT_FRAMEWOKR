<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />

<form id="viewForm" name="viewForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="event" />
	<input type="hidden" name="bsNo" value="<c:out value="${resultView.bsNo }"/>"/>
	<input type="hidden" name="memberId" value="<c:out value="${resultView.bsNo }"/>"/>
	<input type="hidden" name="transportServiceCd" value="<c:out value="${resultView.transportServiceCd }"/>"/>
	<input type="hidden" name="expImpCd" value="<c:out value="${resultView.expImpCd }"/>"/>
	<input type="hidden" name="stateCd" value="<c:out value="${resultView.stateCd }"/>"/>
	<input type="hidden" name="reqno" value="<c:out value="${resultView.reqno }"/>"/>
	<input type="hidden" name="returnReason" value=""/>
	<input type="hidden" name="coHp" value="<c:out value="${resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>"/>
	<input type="hidden" name="coEmail" value="<c:out value="${resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>"/>
	<input type="hidden" name="wrkMembNm" value="<c:out value="${resultView.wrkMembNm }"/>"/>
	<input type="hidden" name="coUserNm" value="<c:out value="${resultView.wrkMembNm }"/>"/>

	<input type="hidden" name="searchCompanyKor" value="<c:out value="${svcexVO.searchCompanyKor }"/>"/>
	<input type="hidden" name="searchEnterRegNo" value="<c:out value="${svcexVO.searchEnterRegNo }"/>"/>
	<input type="hidden" name="searchBsNo" value="<c:out value="${svcexVO.searchBsNo }"/>"/>
	<input type="hidden" name="issueStartDt" value="<c:out value="${svcexVO.issueStartDt }"/>"/>
	<input type="hidden" name="issueEndDt" value="<c:out value="${svcexVO.issueEndDt }"/>"/>
	<input type="hidden" name="searchIssueCd" value="<c:out value="${svcexVO.searchIssueCd }"/>"/>
	<input type="hidden" name="searchExpImpCd" value="<c:out value="${svcexVO.searchExpImpCd }"/>"/>
	<input type="hidden" name="searchStateCd" value="<c:out value="${svcexVO.searchStateCd }"/>"/>
	<input type="hidden" name="searchOrgCd" value="<c:out value="${svcexVO.searchOrgCd }"/>"/>
	<input type="hidden" name="issueNo" value="<c:out value="${resultView.issueNo }"/>"/>
	<input type="hidden" name="returnNo" value=""/>

	<input type="hidden" name="reqStartDt" value="<c:out value="${svcexVO.reqStartDt }"/>"/>
	<input type="hidden" name="reqEndDt" value="<c:out value="${svcexVO.reqEndDt }"/>"/>
	<input type="hidden" name="creStartDt" value="<c:out value="${svcexVO.creStartDt }"/>"/>
	<input type="hidden" name="creEndDt" value="<c:out value="${svcexVO.creEndDt }"/>"/>
	<input type="hidden" name="startDt" value="<c:out value="${svcexVO.startDt }"/>"/>
	<input type="hidden" name="endDt" value="<c:out value="${svcexVO.endDt }"/>"/>
	<input type="hidden" name="searchDateGubun" value="<c:out value="${svcexVO.searchDateGubun }"/>"/>
	<input type="hidden" name="listPagePre" id="listPagePre" value="<c:out value="${svcexVO.listPage }"/>"/>

	<!-- 페이지 위치 -->
	<div class="location">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
	</div>

	<div class="cont_block">
		<div class="tit_bar">

			<h3 class="tit_block">신청내역 조회</h3>

			<div class="ml-auto">
				<c:if test="${(resultView.stateCd eq 'B' || resultView.stateCd eq 'C') && viewYn}">
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doApprove();">승인</button>
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doReturn();">반려</button>
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doUpdate();">수정</button>
				</c:if>
				<c:if test="${(svcexVO.manCreYn eq 'Y' && resultView.stateCd eq 'A') && viewYn}">
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doUpdate();">수정</button>
				</c:if>
				<c:if test="${(resultView.stateCd eq 'E' || resultView.stateCd eq 'F')}">
					<c:if test="${viewYn}">
						<button type="button" class="btn_sm btn_primary" onclick="doPrint();">인쇄</button>
					</c:if>
				</c:if>
				<button type="button" class="btn_sm btn_secondary" onclick="doList();">목록</button>
			</div>
		</div>


		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<c:if test="${not empty returnResultView }">
					<c:forEach items="${returnResultView }" var="list" varStatus="status">
						<tr>
							<th>
								<c:choose>
									<c:when test="${resultView.stateCd eq 'D' && (fn:length(returnResultView) == (status.index+1)) }">
										<strong>
											<c:out value="${(status.index+1) }"/> 반려사유<br/>[<c:out value="${list.returnDate }"/>]
										</strong>
									</c:when>
									<c:otherwise>
										<c:out value="${(status.index+1) }"/> 반려사유<br/>[<c:out value="${list.returnDate }"/>]
									</c:otherwise>
								</c:choose>
							</th>
							<td colspan="3">
								<c:choose>
									<c:when test="${not empty list.returnNo }">
										<a href="goReturnView('<c:out value="${list.returnNo}"/>')" >
											<c:out value="${list.returnReason }"/>
										</a>
									</c:when>
									<c:otherwise>
										<c:out value="${list.returnReason }"/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
					<!-- <tr><td colspan="4"></td></tr> -->
				</c:if>
				<tr>
					<th>회사명</th>
					<td><c:out value="${resultView.companyKor }"/></td>
					<th>대표자명</th>
					<td><c:out value="${resultView.presidentKor }"/></td>
				</tr>
				<tr>
					<th>사업자등록번호</th>
					<td><c:out value="${resultView.bsNo1 }"/>-<c:out value="${resultView.bsNo2 }"/>-<c:out value="${resultView.bsNo3 }"/></td>
					<th>무역업고유번호</th>
					<td><c:out value="${resultView.bsNo }"/></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3"><c:out value="${resultView.korAddr1 }"/> <c:out value="${resultView.korAddr2 }"/></td>
				</tr>
				<tr>
					<th>사업자등록증</th>
					<td colspan="3">
						<input type="hidden" name="attFileId" id="attFileId" value="<c:out value="${resultView.attFileId }"/>">
						<c:forEach var="fileList" items="${fileList}" varStatus="status">
							<c:out value="${(status.index+1) }"/> :  <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a>
							<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
								<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
							</button>
						</c:forEach>
					</td>
				</tr>
				<!-- <tr><td colspan="4"></td></tr> -->
				<tr>
					<th>담당자명</th>
					<td><c:out value="${resultView.wrkMembNm }"/></td>
					<th>핸드폰</th>
					<td>
						<c:choose>
							<c:when test="${not empty resultView.coHp1}">
								<c:out value="${resultView.coHp1}"/>-<c:out value="${resultView.coHp2}"/>-<c:out value="${resultView.coHp3}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${resultView.coHpOld }"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td>
						<c:choose>
							<c:when test="${not empty resultView.coEmail1}">
								<c:out value="${resultView.coEmail1}"/>@<c:out value="${resultView.coEmail3}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${resultView.coEmailOld }"/>
							</c:otherwise>
						</c:choose>
					</td>
					<th>발급상태</th>
					<td><c:out value="${resultView.issueCd }"/></td>
				</tr>
				<!-- <tr><td colspan="4"></td></tr> -->
				<tr>
					<th>수출입실적확인기간</th>
					<td colspan="3"><date><c:out value="${resultView.amountSdate }"/></date> ~ <date><c:out value="${resultView.amountEdate }"/></date></td>
				</tr>
				<tr>
					<th>외화총액확인서</th>
					<td colspan="3">
						<input name="currencyTotalAttFileId" id="currencyTotalAttFileId" type="hidden" value="<c:out value="${resultView.currencyTotalAttFileId }"/>">
						<c:forEach var="fileList" items="${currencyTotalAttFileList}" varStatus="status">
							<p>
								<span class="attr_list"><c:out value="${(status.index+1) }"/> : <a class="view_data attach_file" href="javascript:doDownloadFile('<c:out value="${fileList.fileId}"/>', '<c:out value="${fileList.fileNo}"/>');"><c:out value="${fileList.fileName}"/> ( <c:out value="${fileList.fileSize}"/> )</a></span>
								<button class="file_preview btn_tbl_border" type="button" onclick="viewer.showFileContents('${serverName}/supves/supvesFileDownload.do?fileId=${fileList.fileId}&fileNo=${fileList.fileNo}','<c:out value="${fileList.fileName}"/>', '<c:out value="svcex_${fileList.fileId}_${fileList.fileNo}"/>')" >
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</p>
						</c:forEach>
					</td>
				</tr>
			</tbody>
		</table><!-- //formTable -->
	</div><!-- cont_block -->

	<div class="cont_block">
		<table class="formTable dataTable">
			<colgroup>
				<col style="width:20%" />
				<col style="width:20%" />
				<col style="width:25%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="col" colspan="2">용역명</th>
					<th scope="col">기 간</th>
					<th scope="col">금 액(US $)</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th rowspan="2">운임수입</th>
					<th scope="col">국내수출입화물 운임수입</th>
					<td class="align_ctr">
						<c:if test="${not empty resultSubView.domesticEiFrightSdate }">
							<c:out value="${resultSubView.domesticEiFrightSdate }"/> ~ <c:out value="${resultSubView.domesticEiFrightEdate }"/>
						</c:if>
					</td>
					<td class="align_r"><fmt:formatNumber value="${resultSubView.domesticEiFrightReceipts }" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>삼국간 화물 운임수입</th>
					<td class="align_ctr">
						<c:if test="${not empty resultSubView.tripleFrightSdate }">
							<c:out value="${resultSubView.tripleFrightSdate }"/> ~ <c:out value="${resultSubView.tripleFrightEdate }"/>
						</c:if>
					</td>
					<td class="align_r"><fmt:formatNumber value="${resultSubView.tripleFrightReceipts }" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="2" class="align_ctr">외국인에 대한 대선 수입</th>
					<td class="align_ctr">
						<c:if test="${not empty resultSubView.foriengnSdate }">
							<c:out value="${resultSubView.foriengnSdate }"/> ~ <c:out value="${resultSubView.foriengnEdate }"/>
						</c:if>
					</td>
					<td class="align_r"><fmt:formatNumber value="${resultSubView.foriengnRevenue }" pattern="#,###" /></td>
				</tr>
				<tr>
					<th rowspan="2">터미널 운영수입</th>
					<th>국내터미널 운영수입</th>
					<td class="align_ctr">
						<c:if test="${not empty resultSubView.domesticTermOperRevSdate }">
							<c:out value="${resultSubView.domesticTermOperRevSdate }"/> ~ <c:out value="${resultSubView.domesticTermOperRevEdate }"/>
						</c:if>
					</td>
					<td class="align_r"><fmt:formatNumber value="${resultSubView.domesticTermOperRevenue }" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>국외터미널 운영수입</th>
					<td class="align_ctr">
						<c:if test="${not empty resultSubView.foreignTermOperSdate }">
							<c:out value="${resultSubView.foreignTermOperSdate }"/> ~ <c:out value="${resultSubView.foreignTermOperEdate }"/>
						</c:if>
					</td>
					<td class="align_r"><fmt:formatNumber value="${resultSubView.foreignTermOperRevenue }" pattern="#,###" /></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="2" class="align_ctr">합  계</th>
					<td class="align_r" colspan="2"><fmt:formatNumber value="${resultSubView.amountSum }" pattern="#,###" /></td>
				</tr>
			</tfoot>
		</table>
	</div><!-- cont_block -->

</form>

<script type="text/javascript">

	var f = document.viewForm;

	$(document).ready(function(){
		$('#amountSdate').datepicker({ dateFormat: 'yy-mm-dd', altField : "#amountSdateTmp", altFormat : "yymmdd" });
		$('#amountEdate').datepicker({ dateFormat: 'yy-mm-dd', altField : "#amountEdateTmp", altFormat : "yymmdd" });
	});

	function doList(){
		var url = f.listPagePre.value;
		var pathname = window.location.pathname;

		if ( "" == f.listPagePre.value ){
			if ( pathname.includes('applyDetail2View') ){
				url = "/svcex/svcexCertificate/applyList.do";
			}else if ( pathname.includes('applyDetail2IssueCheckView')) {
				url = "/svcex/svcexCertificate/issueCheckList.do";
			}
		}else{
			f.action = url;
			f.target = "_self";
			f.submit();
		}
	}

	// 승인
	function doApprove(){
		if(!confirm("승인 후엔 E-Mail과 알림톡이 발송 됩니다. \n계속 하시겠습니까?"))return;
		f.event.value = "APPROVE";

		global.ajaxSubmit($('#viewForm'), {
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/insertApplyDetailSave.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//alert("승인 처리가 완료되었습니다.");
				doList();
	        }
		});
	}

	// 반려
	function doReturn(){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/svcex/svcexCertificate/popup/applyReturnView.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				if( resultObj ) {
					doReturnSave(resultObj);
				}
			}
		});
	}
	function doReturnSave(result) {
		f.returnReason.value = result;
		f.currencyTotalAttFileId.value = "";
		f.event.value = "RETURN";

		global.ajaxSubmit($('#viewForm'), {
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/insertReturnDetail.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				//alert("반려 처리가 완료되었습니다.");
				doList();
	        }
		});
	}

	//수정
	function doUpdate(){
		f.action = "/svcex/svcexCertificate/offlineRegs2View.do";
		f.target = "_self";
		f.submit();
	}

	//인쇄
	function doPrint(){

		var f = document.viewForm;

		if( !confirm( "인쇄 하시겠습니까?" ) ){
			return;
		}
		var ISSUE_NO = f.ISSUE_NO.value;
		var MEMBER_ID = f.MEMBER_ID.value;
		var REQNO = f.REQNO.value;
		var EXP_IMP_CD = f.EXP_IMP_CD.value;
		var TRANSPORT_SERVICE_CD = f.TRANSPORT_SERVICE_CD.value;

		ma_open_window( MEMBER_ID, REQNO, ISSUE_NO,EXP_IMP_CD, TRANSPORT_SERVICE_CD );
	}

	function ma_open_window(memId, reqno, issueNo, expImpCd,transportServiceCd )
	{
		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 780;
		nHeight = 550;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = "https://membership.kita.net/onlineTrade.do?ONLYVIEW=N";
		strUrl +=	 "&MEMBER_ID="+memId ;
		strUrl +=	 "&REQNO="+reqno ;
		strUrl +=	 "&CONTENT_NUM="+issueNo ;
		strUrl +=	 "&EXP_IMP_CD="+expImpCd ;
		strUrl +=	 "&TRANSPORT_SERVICE_CD="+transportServiceCd ;
		strUrl +=	 "&USER=ADMIN" ;
		strUrl +=	 "&P_CNT=3";
		strUrl +=	 "&CERT_PERIOD=201301201312";
		strUrl +=	 "&CTR_CD=&HS_CD=&MT_CD=";
		strUrl +=	 "&IE_SUB_CODE=1000";

		window.open(strUrl, "ma_print_window", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no');

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
