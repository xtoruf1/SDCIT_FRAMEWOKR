<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
</div>

<div class="btn_group mt-20 _right">
	<div class="ml-auto">
	<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	<button type="button" id="btnDel" class="btn_sm btn_secondary btn_modify_auth" onclick="doDelete();">삭제</button>
	</div>
	<div class="ml-15">
	<button type="button" id="btnApply" class="btn_sm btn_primary btn_modify_auth" onclick="callApplyPop();">승인</button>
	<button type="button" id="btnApplyCancel" class="btn_sm btn_secondary btn_modify_auth" onclick="chgStatus('10');">승인취소</button>
	<button type="button" id="btnReturnAmt" class="btn_sm btn_secondary btn_modify_auth" onclick="callReturnRsnPop();">환불</button>
	<button type="button" id="btnReturn" class="btn_sm btn_secondary btn_modify_auth" onclick="callReturnHoldPop();">가입보류</button>
	<button type="button" id="btnHistory" class="btn_sm btn_primary" onclick="historyPop();">이력정보</button>
	<button type="button" id="btnList" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<form id="frm" name="frm" action="" method="post">
	<double-submit:preventer/>
	<!-- 리스트 조회조건 파라미터 세팅 Start -->
	<c:forEach items="${params.searchStatusCd}" var="searchStatusCd">
		<input type="hidden" name="searchStatusCd" id="searchStatusCd_<c:out value='${searchStatusCd}'/>" value="<c:out value='${searchStatusCd}'/>"/>
	</c:forEach>
	<input type="hidden" name="searchAll" id="searchAll" value="<c:out value='${params.searchAll}'/>"/>
	<input type="hidden" name="searchBaseYear" id="searchBaseYear" value="<c:out value='${params.searchBaseYear}'/>"/>
	<input type="hidden" name="searchCorpName" id="searchCorpName" value="<c:out value='${params.searchCorpName}'/>"/>
	<input type="hidden" name="searchCorpRegNo" id="searchCorpRegNo" value="<c:out value='${params.searchCorpRegNo}'/>"/>
	<input type="hidden" name="searchTradeNo" id="searchTradeNo" value="<c:out value='${params.searchTradeNo}'/>"/>
	<input type="hidden" name="searchInsCode" id="searchInsCode" value="<c:out value='${params.searchInsCode}'/>"/>
	<input type="hidden" name="searchMemberLev" id="searchMemberLev" value="<c:out value='${params.searchMemberLev}'/>"/>
	<input type="hidden" name="searchStartDate" id="searchStartDate" value="<c:out value='${params.searchStartDate}'/>"/>
	<input type="hidden" name="searchEndDate" id="searchEndDate" value="<c:out value='${params.searchEndDate}'/>"/>
	<input type="hidden" name="searchDateType" id="searchDateType" value="<c:out value='${params.searchDateType}'/>"/>
	<input type="hidden" name="pageUnit"  value="<c:out value='${params.pageUnit}'/>"/>
	<input type="hidden" name="pageIndex"  value="<c:out value='${params.pageIndex}'/>"/>
	<input type="hidden" name="preUrl" id="preUrl" value="<c:out value='${params.preUrl}'/>" />
	<!-- 리스트 조회조건 파라미터 세팅 End -->

	<%-- <input type="hidden" name="isSelected" id="isSelected" value="<c:out value='${insApproInfo.INS_ID}'/>,<c:out value='${insReqInfo.TRADE_NO}'/>"/> --%>
	<input type="hidden" name="insReqId" id="insReqId" value="<c:out value='${insApproInfo.insReqId}'/>"/>
	<input type="hidden" name="insId" id="insId" value="<c:out value='${insApproInfo.insId}'/>"/>
	<input type="hidden" name="tradeNo" id="tradeNo" value="<c:out value='${insApproInfo.tradeNo}'/>"/>
	<input type="hidden" name="duesYear" id="duesYear" value="<c:out value='${insApproInfo.duesYear}'/>"/>
	<input type="hidden" name="selfCost" id="selfCost" value="<c:out value='${insApproInfo.selfCost}'/>"/>
	<input type="hidden" name="statusCd" id="statusCd" value="<c:out value='${insApproInfo.statusCd}'/>"/>
	<input type="hidden" name="beforeInsCode" id="beforeInsCode" value="<c:out value='${insApproInfo.insCode}'/>"/>
	<input type="hidden" name="returnDate" id="returnDate" value=""/>
	<input type="hidden" name="returnRsn" id="returnRsn" value=""/>
	<input type="hidden" name="payDate" id="payDate" value="<c:out value='${insApproInfo.payDate}'/>" />
	<input type="hidden" name="bankbookFileId" id="bankbookFileId" value="<c:out value='${insApproInfo.bankbookFileId}'/>"/>
	<input type="hidden" name="viewYn" id="viewYn" value="<c:out value='${insApproInfo.viewYn}'/>" />


	<c:if test="${not empty insApproInfo.returnRsn}">
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">반려사유</h3>
			</div>
			<div id="divReturnRsn">
				<table class="formTable">
					<colgroup>
						<col style="width:17%;">
					</colgroup>
					<tr>
						<th>반려사유</th>
						<td >
							<textarea id="return_rsn_dp" class="form_textarea" rows="8"  readonly="readonly"><c:out value='${insApproInfo.returnRsn}'/></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</c:if>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">사업정보</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:16%" />
				<col />
				<col style="width:16%" />
				<col style="width:22%" />
			</colgroup>
			<tr>
				<th rowspan="2">사업명</th>
				<td rowspan="2">
					<c:out value='${insApproInfo.insTitle}'/>
				</td>
				<th>사업기간</th>
				<td>
					<c:out value='${insApproInfo.insStartDate}'/> ~ <c:out value='${insApproInfo.insStartDate}'/>
				</td>
			</tr>
			<tr>
				<th>신청기간</th>
				<td>
					<c:out value='${insApproInfo.reqStartDate}'/> ~ <c:out value='${insApproInfo.reqEndDate}'/>
				</td>
			</tr>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">업체 정보</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:8%" />
				<col style="width:8%" />
				<col style="width:220px" />
				<col style="width:12%" />
				<col style="width:220px" />
				<col style="width:8%" />
				<col style="width:8%" />
				<col style="width:22%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" colspan="2">무역업고유번호</th>
					<td>
						<c:out value='${insApproInfo.tradeNo}'/>
					</td>
					<th scope="row">법인번호</th>
					<td>
						<c:out value='${insApproInfo.corpNo}'/>
					</td>
					<th scope="row" colspan="2">사업자등록번호</th>
					<td>
						<c:out value='${insApproInfo.corpRegNo}'/>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="2">회사명</th>
					<th scope="row">국문</th>
					<td colspan="3">
						<c:out value='${insApproInfo.corpNameKr}'/>
					</td>
					<th scope="row" rowspan="2">대표자</th>
					<th scope="row">국문</th>
					<td>
						<c:out value='${insApproInfo.repreNameKr}'/>
					</td>
				</tr>
				<tr>
					<th scope="row">영문</th>
					<td colspan="3">
						<c:out value='${insApproInfo.corpNameEn}'/>
					</td>
					<th scope="row">영문</th>
					<td>
						<c:out value='${insApproInfo.repreNameEn}'/>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2">주소</th>
					<td colspan="3">
						<c:out value='${insApproInfo.corpZipcode}'/>, <c:out value='${insApproInfo.corpAddr1}'/><c:out value='${insApproInfo.corpAddr2}'/>
					</td>
					<th scope="row" colspan="2">회사전화번호</th>
					<td>
						<c:out value='${insApproInfo.corpTelno}'/>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="2" >대표 E-Mail</th>
					<td colspan="3">
						<c:out value='${insApproInfo.corpHpno}'/>
					</td>
					<th scope="row" colspan="2">휴대전화번호</th>
					<td>
						<c:out value='${insApproInfo.corpHpno}'/>
					</td>
				</tr>
				<tr>
					<th scope="row" rowspan="4">담당자</th>
					<th scope="row">성명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manName" id="manName" value="<c:out value="${ insApproInfo.manName }" />"  maxlength="6" />
					</td>
					<th scope="row">부서명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manDept" id="manDept" value="<c:out value="${ insApproInfo.manDept }" />"  maxlength="60" />
					</td>
					<th scope="row" colspan="2">직위명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manPos" id="manPos" value="<c:out value="${ insApproInfo.manPos }" />"  maxlength="6" />
					</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td>
						<div class="form_row">
							<select id="manTelno1" name="manTelno1" class="form_select">
			                    <c:forEach var="domain" items="${COM013}" varStatus="status">
			                    	<option value="<c:out value="${domain.cdId}" />" <c:if test="${insApproInfo.manTelno1 eq domain.cdId}">selected="selected"</c:if>><c:out value="${domain.cdId}" /></option>
			                    </c:forEach>
							</select>
							<input type="text" class="form_text align_ctr" name="manTelno2" id="manTelno2" value="<c:out value="${ insApproInfo.manTelno2 }" />"  maxlength="5" />
							<input type="text" class="form_text align_ctr" name="manTelno3" id="manTelno3" value="<c:out value="${ insApproInfo.manTelno3 }" />"  maxlength="4" />
						</div>
					</td>

					<th scope="row">휴대폰번호 <strong class="point">*</strong></th>
					<td>
						<div class="form_row">
							<select id="manHpno1" name="manHpno1" class="form_select">
			                    <c:forEach var="domain" items="${COM012}" varStatus="status">
			                    	<option value="<c:out value="${domain.cdId}" />" <c:if test="${insApproInfo.manHpno1 eq domain.cdId}">selected="selected"</c:if>><c:out value="${domain.cdId}" /></option>
			                    </c:forEach>
							</select>
							<input type="text" class="form_text align_ctr" name="manHpno2" id="manHpno2" value="<c:out value="${ insApproInfo.manHpno2 }" />"  maxlength="5" />
							<input type="text" class="form_text align_ctr" name="manHpno3" id="manHpno3" value="<c:out value="${ insApproInfo.manHpno3 }" />"  maxlength="4" />
						</div>
					</td>
					<th scope="row" colspan="2">팩스번호</th>
					<td>
						<div class="form_row">
							<select id="manFaxno1" name="manFaxno1" class="form_select">
			                    <c:forEach var="domain" items="${COM013}" varStatus="status">
			                    	<option value="<c:out value="${domain.cdId}" />" <c:if test="${insApproInfo.manFaxno1 eq domain.cdId}">selected="selected"</c:if>><c:out value="${domain.cdId}" /></option>
			                    </c:forEach>
				                    <option value="0303" <c:if test="${ insApproInfo.manFaxno1 == '0303' }">selected</c:if>>0303</option>
									<option value="0504" <c:if test="${ insApproInfo.manFaxno1 == '0504' }">selected</c:if>>0504</option>
							</select>
							<input type="text" class="form_text align_ctr" name="manFaxno2" id="manFaxno2" value="<c:out value="${ insApproInfo.manFaxno2 }" />"  maxlength="4" />
							<input type="text" class="form_text align_ctr" name="manFaxno3" id="manFaxno3" value="<c:out value="${ insApproInfo.manFaxno3 }" />"  maxlength="4" />
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">E-Mail <strong class="point">*</strong></th>
					<td colspan="6">
						<input type="text" class="form_text" name="manEmail01" id="manEmail01" value="<c:out value="${ insApproInfo.manEmail01 }" />"  maxlength="16" />
						@
						<input type="text" class="form_text" name="manEmail02" id="manEmail02" value="<c:out value="${ insApproInfo.manEmail02 }" />"  maxlength="16" />
						<select id="man_eamil02_domain" name="man_eamil02_domain" class="form_select" onchange="setmail(this.value, 'manEmail02');">
		                    <c:forEach var="domain" items="${COM014}" varStatus="status">
		                    	<option value="<c:out value="${domain.cdNm}" />" <c:if test="${insApproInfo.manEmail02 eq domain.cdNm}">selected="selected"</c:if>><c:out value="${domain.cdNm}" /></option>
		                    </c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">수출보험 선택 및 지원사항</h3>
		</div>

		<table class="formTable">
		<colgroup>
			<col style="width:16%" />
			<col />
			<col style="width:16%" />
			<col style="width:22%" />
		</colgroup>
		<tr>
			<th scope="row">회비 납부 년차</th>
			<td><c:out value="${ insApproInfo.duesYear }" /> 년차</td>
			<th scope="row">작년도 수출실적</th>
			<td class="align_r"><fmt:formatNumber value="${ insApproInfo.expAmt }" /></td>
		</tr>
		<tr>
			<th scope="row" rowspan="<c:out value="${fn:length(insTypeList)}" />">
				보험선택 <strong class="point">*</strong><br>(<c:out value="${fn:length(insTypeList)}" />종류 중 택1)
			</th>
		<c:forEach var="insTypeVo" items="${insTypeList}" varStatus="status">
			<c:if test="${status.index > 0}"><tr></c:if>
			<td>
				<label for="insCode_<c:out value="${insTypeVo.insCode}"/>" class="label_form">
					<input type="radio" class="form_radio" name="insCode" id="insCode_<c:out value="${insTypeVo.insCode}"/>" value="<c:out value="${insTypeVo.insCode}"/>" <c:if test="${ insTypeVo.insCode == insApproInfo.insCode }">checked</c:if> <c:if test="${ (insApproInfo.statusCd == '30' || insApproInfo.statusCd == '40' || insApproInfo.statusCd == '90') && insTypeVo.insCode != insApproInfo.insCode }">disabled</c:if> />
					<span class="label"><c:out value="${insTypeVo.insName}"/>(<c:out value="${insTypeVo.insDscr}"/>)</span>
				</label>
			</td>
			<th scope="row">업체부담금</th>
			<td class="align_r">
				<fmt:formatNumber value='${insTypeVo.payAmt}' pattern='#,###' />
				<input type="hidden" value="<c:out value="${insTypeVo.payAmt}"/>" />
			</td>
		</tr>
		</c:forEach>
	</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">업체부담금 환불 계좌정보</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:16%" />
				<col style="width:12%" />
				<col style="width:16%" />
				<col style="width:12%" />
				<col style="width:16%" />
				<col style="width:12%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" rowspan="3">신청회사<br>법인명의</th>
					<td colspan="6">
						※ 보험심사 탈락시에는 납부한 업체부담금을 환불해 드립니다. (<span style="color: red;">저축은행, 단위농협, 새마을금고는 제외</span>)
					</td>
				</tr>
				<tr>
					<th scope="row">은행명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text" name="bankName" id="bankName" value="<c:out value="${ insApproInfo.bankName }" />"  maxlength="16" />
					</td>
					<th scope="row">예금주 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text" name="accountName" id="accountName" value="<c:out value="${ insApproInfo.accountName }" />"  maxlength="10" />
					</td>
					<th scope="row">계좌번호 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="accountNo" id="accountNo" value="<c:out value="${ insApproInfo.accountNo }" />"  maxlength="100" />
					</td>
				</tr>
				<tr>
					<th scope="row">통장사본 <strong class="point">*</strong></th>
					<td colspan="5">
						<c:if test="${ insApproInfo.bankbookFilepath != null }">
						<div id="attachFieldList">
							<div class="addedFile">
								<a class="filename" href="javascript:doInsuranceFileDown('<c:out value="${insApproInfo.bankbookFileId}"/>');"><c:out value="${insApproInfo.bankbookRealname}"/></a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/insurance/insuranceFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.orignlFileNm}"/>','test123insu_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</div>
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</div>


	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">이용현황</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:16%" />
				<col />
				<col style="width:16%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>신청일자</th>
					<td><c:out value="${ insApproInfo.reqDate }" /></td>
					<th>회원등급</th>
					<td><c:out value="${ insApproInfo.memberLev }" /></td>
				</tr>
				<tr>
					<th>보험종류</th>
					<td><c:out value="${ insApproInfo.insName }" /></td>
					<th>이전보험 가입기간</th>
					<td><c:if test="${insApproInfo.lastInsStartDate != null && insApproInfo.lastInsEndDate != null }"><c:out value="${ insApproInfo.lastInsStartDate }" /> ~ <c:out value="${ insApproInfo.lastInsEndDate }" /></c:if></td>
				</tr>
				<tr>
					<th>진행상태</th>
					<td><c:out value="${ insApproInfo.statusNm }" /></td>
					<th>가입기간</th>
					<td><c:if test="${insApproInfo.startDate != null && insApproInfo.endDate != null }"><c:out value="${ insApproInfo.startDate }" /> ~ <c:out value="${ insApproInfo.endDate }" /></c:if></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">보험료 업체부담금 사항</h3>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:16%" />
				<col />
				<col style="width:16%" />
				<col />
			</colgroup>
			<tr>
				<th>보험료</th>
				<td class="align_r">200USD</td>
				<th>발생업체부담금</th>
				<td class="align_r"><fmt:formatNumber value="${insApproInfo.selfCost}" /></td>
			</tr>
			<tr>
				<th>업체부담금 납부여부</th>
				<td style="text-align: center;">
					<div class="form_row">
						<c:if test="${not empty insApproInfo.payDate}">
						<span class="prepend">납부완료</span>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" name="modPayDate" id="modPayDate" value="${insApproInfo.payDate}" class="txt datepicker" title="조회종료일자입력" readonly="readonly"/>
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>
						</c:if>
					</div>
					<div class="form_row">
						<c:if test="${not empty insApproInfo.returnDate}">
							<span class="prepend">환불완료</span>
							(<c:out value="${ insApproInfo.returnDate }" />)
						</c:if>
					</div>
				</td>
				<th>업체부담금 납부계좌</th>
				<td>우리은행 / 1005-403-142428 / (사)한국무역협회</td>
			</tr>
			<tr>
				<th>업체부담금 납부기한</th>
				<td><c:out value="${ insApproInfo.limitDate }" /></td>
				<th>승인일자</th>
				<td><c:out value="${ insApproInfo.applyDate }" /></td>
			</tr>
			<tr>
				<th>영수증 발급 여부</th>
				<td colspan="3">
				<c:if test="${insApproInfo.payDate != null}">
					<select class="form_select" onchange="chg_view_yn(this.value)">
						<option value="Y" <c:if test="${insApproInfo.viewYn ne 'N'}">selected</c:if> >발급</option>
						<option value="N" <c:if test="${insApproInfo.viewYn eq 'N'}">selected</c:if> >미발급</option>
					</select>
				</c:if>
				</td>
			</tr>
		</table>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){

		pageControl($('#statusCd').val());		// 상태값에 따라 버튼 컨트롤

		$('input[name="insCode"]').on('change',function(){
			if( $('#statusCd').val() == '00' || $('#statusCd').val() == '10' ){
				if( $('#beforeInsCode').val() != $(this).val() ){
					$('#btnApply').hide();
				}else {
					$('#btnApply').show();
				}
			}
		});

		setMailBalnk();

	});



	function goList(){	// 목록

		var f = $('#frm');
		f.attr('action', $('#preUrl').val());
		f.submit();
	}

	function reloadPage(){	// 화면 재조회

		var f = $('#frm');
		f.attr('action', '/insurance/insuranceApproDetail.do');
		f.submit();
	}

	function pageControl(statusCd){		// 버튼 컨트롤

		switch (statusCd) {

		case "00":
			$("#btnSave").show();
			$("#btnApply").show();
			$("#btnApplyCancel").hide();
			if( $('#selfCost').val() != '0' ){
				$("#btnReturnAmt").show();
			}
			$("#btnReturn").hide();
			break;

		case "01":
			$("#btnSave").show();
			$("#btnApply").hide();
			$("#btnApplyCancel").hide();
			$("#btnReturnAmt").hide();
			$("#btnReturn").hide();
			break;

		case "10":
			$("#btnSave").show();
			$("#btnApply").show();
			$("#btnApplyCancel").hide();
			if( $('#selfCost').val() != '0' ){
				$("#btnReturnAmt").show();
				$("#btnReturn").show();
			}

			break;

		case "20":
			$("#btnSave").show();
			$("#btnApply").hide();
			$("#btnApplyCancel").show();
			if( $('#selfCost').val() != '0' ){
				$("#btnReturnAmt").show();
			}
			$("#btnReturn").hide();
			break;

		case "30":
			$("#btnSave").show();
			$("#btnApply").hide();
			$("#btnApplyCancel").hide();
			if( $('#selfCost').val() != '0' ){
				$("#btnReturnAmt").show();
			}
			$("#btnReturn").hide();
			break;

		case "40":
			$("#btnSave").show();
			$("#btnApply").show();
			$("#btnApplyCancel").hide();
			if( $('#selfCost').val() != '0' ){
				$("#btnReturnAmt").show();
			}
			$("#btnReturn").hide();
			break;

		case "90":
			$("#btnSave").hide();
			$("#btnApply").hide();
			$("#btnApplyCancel").hide();
			$("#btnReturnAmt").hide();
			$("#btnReturn").hide();
			break;
		}
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
		$('#man_eamil02_domain').prepend('<option value="">직접입력</option>');

		if($('#man_eamil02_domain').val() != $('#manEmail02').val() ){
			$('#man_eamil02_domain option:eq(0)').attr('selected', 'selected');
		}
	}

	function callApplyPop(){	// 승인

		if( $('#selfCost').val() != '0' && $('#statusCd').val() != '40' ){
			// 팝업호출
			global.openLayerPopup({
				// 레이어 팝업 URL
				popupUrl : '/insurance/popup/insuranceApproPop.do'
				// 레이어 팝업으로 넘기는 parameter 예시
				, callbackFunction : function(resultObj){
					if(resultObj == '') {
						alert('문제가 발생했습니다.');
					} else {
						var payDate = resultObj[0];
						var receYn = resultObj[1];
						doApply(payDate, receYn);
					}
				}
			});
		}else {
			if(!confirm("승인 하시겠습니까?")){
				return;
			}
			doApply('');
		}
	}

	function doApply(payDate, receYn){	// 승인처리

		$('#payDate').val(payDate);
		$('#viewYn').val(receYn);
		$('#statusCd').val('20');

		var pParamData = [];

		var data = $('#frm').serializeObject();

		data.searchStatusCd = null;
		var searchStatusCdArr = [];

		$("input[name='searchStatusCd']").each(function(e){
			searchStatusCdArr.push($(this).val());
		})

		if(searchStatusCdArr.length > 0){
			data.searchStatusCd = searchStatusCdArr;
		}

		pParamData.push(data);

		global.ajax({
			type : 'POST'
			, url : "/insurance/insuranceStatusChg.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pParamData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				reloadPage();
				pageControl('20');
			}
		});


	}

	function saveValid(){	// 업체정보 vaildation

		if($("#manName").val() == ""){
			alert("담당자 성명은 필수입니다.");
			$("#manName").focus();
			return false;
		}

		if($("#manDept").val() == ""){
			alert("담당자 부서명은 필수입니다.");
			$("#manDept").focus();
			return false;
		}

		if($("#manPos").val() == ""){
			alert("담당자 직위명은 필수입니.");
			$("#manPos").focus();
			return false;
		}

		if($("#manHpno1").val() == ""){
			alert("담당자 휴대전화번호는 필수입니다.");
			$("#manHpno1").focus();
			return false;
		}

		if($("#manHpno2").val() == ""){
			alert("담당자 휴대전화번호는 필수입니다.");
			$("#manHpno2").focus();
			return false;
		}

		if($("#manHpno3").val() == ""){
			alert("담당자 휴대전화번호는 필수입니다.");
			$("#manHpno3").focus();
			return false;
		}

		if($("#manEmail01").val() == ""){
			alert("E-mail은 필수입니다.");
			$("#manEmail01").focus();
			return false;
		}

		if($("#manEmail02").val() == ""){
			alert("E-mail은 필수입니다.");
			$("#manEmail02").focus();
			return false;
		}

		return true;

	}

	function doSave() {	// 수출보험상세정보 등록

		if(!saveValid()){	// 회사상세정보 validation
			return false;
		}

		if(!confirm("저장하시겠습니까?")){
			return false;
		}

		var modPayDate = $('#modPayDate').val();
		var payDate = $('#payDate').val();

		if(modPayDate != payDate) {
			$('#payDate').val(modPayDate);
		}

		var pParamData = $('#frm').serializeObject();

		pParamData.searchStatusCd = null;
		var searchStatusCdArr = [];

		$("input[name='searchStatusCd']").each(function(e){
			searchStatusCdArr.push($(this).val());
		})

		if(searchStatusCdArr.length > 0){
			pParamData.searchStatusCd = searchStatusCdArr;
		}

		global.ajax({
			type : 'POST'
			, url : "/insurance/saveInsuranceApproDetail.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pParamData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				reloadPage();
			}
		});
	}

	function doDelete() {	// 수출보험 신청정보 삭제

		if(!confirm("삭제하시겠습니까?")){
			return false;
		}

		global.ajax({
			type : 'POST'
			, url : "/insurance/deleteInsuranceApproDetail.do"
			, data : {'insReqId' : $('#insReqId').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				goList();
			}
		});
	}

	function chgStatus(statusCd) {	// 승인취소

		if($('#statusCd').val() != '20'){
			alert("승인상태가 아닙니다.");
			return false;
		}

		if(!confirm("승인취소 하시겠습니까?")){
			return false;
		}

		$('#viewYn').val('Y');
		$('#statusCd').val(statusCd);

		var pParamData = [];

		var data = $('#frm').serializeObject();

		data.searchStatusCd = null;
		var searchStatusCdArr = [];

		$("input[name='searchStatusCd']").each(function(e){
			searchStatusCdArr.push($(this).val());
		})

		if(searchStatusCdArr.length > 0){
			data.searchStatusCd = searchStatusCdArr;
		}

		pParamData.push(data);

		global.ajax({
			type : 'POST'
			, url : "/insurance/insuranceStatusChg.do"
			, contentType : 'application/json'
			, data : JSON.stringify(pParamData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				reloadPage();
				pageControl('10');
			}
		});
	}

	function callReturnRsnPop() {	// 환불 팝업

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/insurance/popup/insuranceReturnRsnPop.do'
			, callbackFunction : function(resultObj){
				if(resultObj == '') {
					alert('문제가 발생했습니다.');
				} else {

					$('#returnDate').val(resultObj);
					$('#statusCd').val('01');

					var pParamData = [];

					var data = $('#frm').serializeObject();

					data.searchStatusCd = null;
					var searchStatusCdArr = [];

					$("input[name='searchStatusCd']").each(function(e){
						searchStatusCdArr.push($(this).val());
					})

					if(searchStatusCdArr.length > 0){
						data.searchStatusCd = searchStatusCdArr;
					}

					pParamData.push(data);

					global.ajax({
						type : 'POST'
						, url : "/insurance/insuranceStatusChg.do"
						, contentType : 'application/json'
						, data : JSON.stringify(pParamData)
						, dataType : 'json'
						, async : true
						, spinner : true
						, success : function(data){
							reloadPage();
							pageControl('01');
						}
					});
				}
			}
		});
	}

	function callReturnHoldPop(){	//  가입보류 팝업

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/insurance/popup/insuranceReturnHoldPop.do'
			, callbackFunction : function(resultObj){
				if(resultObj == '') {
					alert('문제가 발생했습니다.');
				} else {

					$('#returnRsn').val(resultObj);
					$('#statusCd').val('00');

					var pParamData = [];

					var data = $('#frm').serializeObject();

					data.searchStatusCd = null;
					var searchStatusCdArr = [];

					$("input[name='searchStatusCd']").each(function(e){
						searchStatusCdArr.push($(this).val());
					})

					if(searchStatusCdArr.length > 0){
						data.searchStatusCd = searchStatusCdArr;
					}

					pParamData.push(data);

					global.ajax({
						type : 'POST'
						, url : "/insurance/insuranceStatusChg.do"
						, contentType : 'application/json'
						, data : JSON.stringify(pParamData)
						, dataType : 'json'
						, async : true
						, spinner : true
						, success : function(data){
							reloadPage();
							pageControl('00');
						}
					});
				}
			}
		});
	}

	function historyPop() {	// 이력정보

		var insId = $('#insId').val();
		var tradeNo = $('#tradeNo').val();

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/insurance/popup/insuranceHistoryPop.do'
			, params : {'insId' : insId,
					   'tradeNo' : tradeNo
			}
		});
	}

	function doInsuranceFileDown(atchFileId, fileSn) {	// 파일 다운로드
		window.open("/insurance/insuranceFileDownload.do?atchFileId="+atchFileId+"");
	}

</script>