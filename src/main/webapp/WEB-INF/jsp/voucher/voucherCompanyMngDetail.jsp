<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>

<div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

	<div class="ml-auto">
		<button type="button" id="btnSave" class="btn_sm btn_primary btn_modify_auth" onclick="saveVoucherCompanyInfo();">저장</button>
		<button type="button" id="btnAprv" class="btn_sm btn_primary btn_modify_auth" onclick="chgStatus('90');">승인</button>
		<button type="button" id="btnAprvCancel" class="btn_sm btn_secondary btn_modify_auth" onclick="chgStatus('10');">승인대기</button>
		<button type="button" id="btnReturn" class="btn_sm btn_secondary btn_modify_auth" onclick="callReturnRsnPop();">반려</button>
		<button type="button" id="btnReject" class="btn_sm btn_secondary btn_modify_auth" onclick="chgStatus('50');">포기</button>

	</div>
	<div class="ml-15">
		<button type="button" id="btnList" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<form id="voucherCompanyInfoForm" name="voucherCompanyInfoForm" action="" method="post" enctype="multipart/form-data">
	<double-submit:preventer/>
	<!-- 리스트 조회조건 파라미터 세팅 Start -->
	<input type="hidden" name="searchBaseYear" id="searchBaseYear" value="<c:out value='${param.searchBaseYear}'/>"/>
	<input type="hidden" name="searchVmstSeq" id="searchVmstSeq" value="<c:out value='${param.searchVmstSeq}'/>"/>
	<input type="hidden" name="searchStatusCd" id="searchStatusCd" value="<c:out value='${param.searchStatusCd}'/>"/>
	<input type="hidden" name="searchPeriodExp" id="searchPeriodExp" value="<c:out value='${param.searchPeriodExp}'/>"/>
	<input type="hidden" name="searchVoucherLev" id="searchVoucherLev" value="<c:out value='${param.searchVoucherLev}'/>"/>
	<input type="hidden" name="searchCorpNameKr" id="searchCorpNameKr" value="<c:out value='${param.searchCorpNameKr}'/>"/>
	<input type="hidden" name="searchCorpRegNo" id="searchCorpRegNo" value="<c:out value='${param.searchCorpRegNo}'/>"/>
	<input type="hidden" name="searchPeriodType" id="searchPeriodType" value="<c:out value='${param.searchPeriodType}'/>"/>
	<input type="hidden" name="searchStdt" id="searchStdt" value="<c:out value='${param.searchStdt}'/>"/>
	<input type="hidden" name="searchEddt" id="searchEddt" value="<c:out value='${param.searchEddt}'/>"/>
	<input type="hidden" name="searchPageIndex"  value="<c:out value='${param.pageIndex}' default='1' />"/>
	<input type="hidden" name="pageIndex" id="pageIndex" value="0"/>
	<!-- 리스트 조회조건 파라미터 세팅 End -->

	<input type="hidden" name="tradeNo" id="tradeNo" value="<c:out value='${companyInfo.tradeNo}'/>"/>
	<input type="hidden" name="vmstSeq" id="vmstSeq" value="<c:out value='${companyInfo.vmstSeq}'/>"/>
	<input type="hidden" name="statusCd" id="statusCd" value="<c:out value='${companyInfo.statusCd}'/>"/>
	<input type="hidden" name="bankbookFileId" id="bankbookFileId" value="<c:out value='${companyInfo.bankbookFileId}'/>"/>
	<input type="hidden" name="saupjaFileId" id="saupjaFileId" value="<c:out value='${companyInfo.saupjaFileId}'/>"/>
	<input type="hidden" name="etcFileId" id="etcFileId" value="<c:out value='${companyInfo.etcFileId}'/>"/>



	<c:if test="${companyInfo.statusCd eq '40'}">
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">반려사유</h3>
			</div>
			<div id="divReturnRsn">
				<table class="formTable">
					<colgroup>
						<col style="width:15%">
						<col>
					</colgroup>
					<tr>
						<th>반려사유</th>
						<td>
							<textarea id="returnRsnDp" class="form_textarea" rows="4"  readonly="readonly"><c:out value='${companyInfo.returnRsn}'/></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</c:if>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">바우처 정보</h3>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th rowspan="2" scope="row">사업명</th>
					<td rowspan="2">
						<c:out value='${companyInfo.voucherTitle}'/>
					</td>
					<th scope="row">바우처 사업기간</th>
					<td>
						<c:out value='${companyInfo.voucherStdt}'/> ~ <c:out value='${companyInfo.voucherEddt}'/>
					</td>
				</tr>
				<tr>
					<th scope="row">바우처 신청기간</th>
					<td>
						<c:out value='${companyInfo.receStdt}'/> ~ <c:out value='${companyInfo.receEddt}'/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">업체 기본 정보</h3>
			<span class="ml-auto"><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:7.5%">
				<col style="width:7.5%">
				<col>
				<col style="width:15%">
				<col>
				<col style="width:7.5%">
				<col style="width:7.5%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th colspan="2" scope="row">무역업고유번호</th>
					<td>
						<c:out value='${companyInfo.tradeNo}'/>
					</td>
					<th scope="row">법인번호</th>
					<td>
						<c:out value='${companyInfo.corpNo}'/>
					</td>
					<th colspan="2" scope="row">사업자등록번호</th>
					<td>
						<c:out value='${companyInfo.corpRegNo}'/>
					</td>
				</tr>
				<tr>
					<th rowspan="2" scope="row">회사명</th>
					<th scope="row">국문</th>
					<td colspan="3">
						<c:out value='${companyInfo.corpNameKr}'/>
					</td>
					<th rowspan="2" scope="row">대표자</th>
					<th>국문</th>
					<td>
						<c:out value='${companyInfo.repreNameKr}'/>
					</td>
				</tr>
				<tr>
					<th scope="row">영문</th>
					<td colspan="3">
						<c:out value='${companyInfo.corpNameEn}'/>
					</td>
					<th scope="row">영문</th>
					<td>
						<c:out value='${companyInfo.repreNameEn}'/>
					</td>
				</tr>
				<tr>
					<th colspan="2" scope="row">주소</th>
					<td colspan="3">
						<c:out value='${companyInfo.corpZipcode}'/>, <c:out value='${companyInfo.corpAddr1}'/> <c:out value='${companyInfo.corpAddr2}'/>
					</td>
					<th colspan="2" scope="row">회사전화번호</th>
					<td>
						<c:out value='${companyInfo.corpTelno}'/>
					</td>
				</tr>
				<tr>
					<th colspan="2" scope="row">대표 E-Mail</th>
					<td colspan="3">
						<c:out value='${companyInfo.corpEmail}'/>
					</td>
					<th colspan="2" scope="row">휴대전화번호</th>
					<td>
						<c:out value='${companyInfo.corpHpno}'/>
					</td>
				</tr>
				<tr>
					<th rowspan="4" scope="row">담당자</th>
					<th scope="row">성명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manName" id="manName" value="<c:out value="${ companyInfo.manName }" />"  maxlength="10" />
					</td>
					<th scope="row">부서명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manDept" id="manDept" value="<c:out value="${ companyInfo.manDept }" />"  maxlength="10" />
					</td>
					<th colspan="2" scope="row">직위명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="manPos" id="manPos" value="<c:out value="${ companyInfo.manPos }" />"  maxlength="6" />
					</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td>
						<div class="form_row">
							<select id="manTelno1" name="manTelno1" class="form_select">
			                    <c:forEach var="domain" items="${telDomainList}" varStatus="status">
			                    	<option value="<c:out value="${domain.cdId}" />" <c:if test="${companyInfo.manTelno1 eq domain.cdId}">selected="selected"</c:if>><c:out value="${domain.cdId}" /></option>
			                    </c:forEach>
							</select>
							<input type="text" class="form_text align_ctr" name="manTelno2" id="manTelno2" value="<c:out value="${ companyInfo.manTelno2 }" />"  maxlength="4" />
							<input type="text" class="form_text align_ctr" name="manTelno3" id="manTelno3" value="<c:out value="${ companyInfo.manTelno3 }" />"  maxlength="3" />
						</div>
					</td>

					<th scope="row">휴대폰번호 <strong class="point">*</strong></th>
					<td>
						<div class="form_row">
							<select id="manHpno1" name="manHpno1" class="form_select">
			                    <c:forEach var="domain" items="${hpDomainList}" varStatus="status">
			                    	<option value="<c:out value="${domain.cdId}" />" <c:if test="${companyInfo.manHpno1 eq domain.cdId}">selected="selected"</c:if>><c:out value="${domain.cdId}" /></option>
			                    </c:forEach>
							</select>
							<input type="text" class="form_text align_ctr" name="manHpno2" id="manHpno2" value="<c:out value="${ companyInfo.manHpno2 }" />"  maxlength="4" />
							<input type="text" class="form_text align_ctr" name="manHpno3" id="manHpno3" value="<c:out value="${ companyInfo.manHpno3 }" />"  maxlength="3" />
						</div>
					</td>
					<th colspan="2" scope="row"></th>
					<td></td>
				</tr>
				<tr>
					<th scope="row">E-Mail <strong class="point">*</strong></th>
					<td colspan="6">
						<input type="text" class="form_text" name="manEmail01" id="manEmail01" value="<c:out value="${ companyInfo.manEmail01 }" />"  maxlength="16" />
						@
						<input type="text" class="form_text" name="manEmail02" id="manEmail02" value="<c:out value="${ companyInfo.manEmail02 }" />"  maxlength="16" />
						<select id="man_eamil02_domain" class="form_select" onchange="setmail(this.value, 'manEmail02');">
		                    <c:forEach var="domain" items="${emailDomainList}" varStatus="status">
		                    	<option value="<c:out value="${domain.cdNm}" />" <c:if test="${companyInfo.manEmail02 eq domain.cdNm}">selected="selected"</c:if>><c:out value="${domain.cdNm}" /></option>
		                    </c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">지원금 한도 결정</h3>
			<span class="ml-auto"><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">회비납부년차</th>
					<td>
						<div class="form_row">
							<input type="text" class="form_text align_r" size="2" name="duesYear" id="duesYear" value="<c:out value="${ companyInfo.duesYear }" />"  maxlength="2" readonly="readonly" />
							<span class="append"> 년</span>
						</div>

					</td>
					<th scope="row">기본지원금액</th>
					<td>
						<div class="form_row w100p">
							<input type="text" class="form_text align_r" name="baseSuppAmt" id="baseSuppAmt" value="<fmt:formatNumber value="${ companyInfo.baseSuppAmt }" />"  maxlength="15" readonly="readonly"/>
							<span class="append"> 원</span>
						</label>
					</td>
				</tr>
				<tr>
					<th rowspan="3" scope="row">
						KITA 멤버쉼 카드 발급 <strong class="point">*</strong><br>
						(2016년 이후 발급)
					</th>
					<td>
						<label class="label_form">
							<input type="radio" name="kitaCardCd" class="form_radio" value="Y" <c:out value="${ companyInfo.kitaCardCd eq 'Y' ? 'checked' : '' }" />  <c:out value="${ companyInfo.kitaCardCd ne 'Y' ? 'disabled' : '' }" />/>
							<span class="label ml-8">발급완료</span>
						</label>
					</td>
					<th scope="row"></th>
					<td></td>
				</tr>
				<tr>
					<td>
						<label class="label_form">
							<input type="radio" name="kitaCardCd" class="form_radio" value="E" <c:out value="${ companyInfo.kitaCardCd eq 'E' ? 'checked' : '' }" />  <c:out value="${ companyInfo.kitaCardCd eq 'Y' ? 'disabled' : '' }" /> />
							<span class="label">발급예정</span>
						</label>
					</td>
					<th scope="row">추가지원금액</th>
					<td>
						<div class="form_row w100p">
							<input type="text" class="form_text align_r" name="addSuppAmt" id="addSuppAmt" value="<fmt:formatNumber value="${ companyInfo.addSuppAmt }" />"  maxlength="15" readonly="readonly"/>
							<span class="append"> 원</span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<label class="label_form">
							<input type="radio" name="kitaCardCd" class="form_radio" value="N" <c:out value="${ companyInfo.kitaCardCd eq 'N' ? 'checked' : '' }" /> <c:out value="${ companyInfo.kitaCardCd eq 'Y' ? 'disabled' : '' }" /> />
							<span class="label">미발급(발급 계획 없음, 추가 예산 없음)</span>
						</label>
					</td>
					<th scope="row"><strong class="point"><span>총지원한도</span></strong></th>
					<td>
						<div class="form_row w100p">
							<input type="text" class="form_text align_r" readonly="readonly" name="sumSuppAmt" id="sumSuppAmt" value="<fmt:formatNumber value="${ companyInfo.baseSuppAmt + companyInfo.addSuppAmt}" />"  onblur="addComma(this.value);" maxlength="15" />
							<span class="append"> 원</span>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">정산입금용 계좌정보</h3>
			<span class="ml-auto"><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col style="width:15%" />
				<col />
				<col style="width:15%" />
				<col />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th rowspan="2" scope="row">신청회사 법인명의</th>
					<td colspan="6">
						※ 추후 정산금 지급 시 지원금을 입금받을 통장계좌 정보를 기입해 주세요. (<span class="point">저축은행, 단위농협, 새마을금고는 제외</span>)
					</td>
				</tr>
				<tr>
					<input type="hidden" name="bankSeq" id="bankSeq" value="<c:out value='${companyInfo.bankSeq}'/>"/>
					<input type="hidden" name="bankCdBefore" value="<c:out value="${ companyInfo.bankCd }" />"  />
					<input type="hidden" name="accountHolderBefore" value="<c:out value="${ companyInfo.accountHolder }" />" />
					<input type="hidden" name="accountNumBefore" value="<c:out value="${ companyInfo.accountNum }" />"   />
					<th scope="row">은행명 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="bankCd" id="bankCd" value="<c:out value="${ companyInfo.bankCd }" />"  maxlength="16" />
					</td>
					<th scope="row">예금주 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="accountHolder" id="accountHolder" value="<c:out value="${ companyInfo.accountHolder }" />"  maxlength="10" />
					</td>
					<th scope="row">계좌번호 <strong class="point">*</strong></th>
					<td>
						<input type="text" class="form_text w100p" name="accountNum" id="accountNum" value="<c:out value="${ companyInfo.accountNum }" />"  maxlength="20" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">신청내역</h3>
		</div>

		<div>
			<div id="voucherServiceSheet" class="sheet"></div>
		</div>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">첨부서류</h3>
			<span class="ml-auto"><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th rowspan="2" scope="row">기본서류</th>
					<th scope="row">통장사본 <strong class="point">*</strong></th>
					<td>
						<c:if test="${!empty bankbookFileList}">
							<c:set var="bankFileStyle" value="none;"></c:set>
						</c:if>
						<div class="form_file" id="bankbookControl" style='display: <c:out value="${bankFileStyle}" /> ' >
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" name="bankbookFile" id="bankbookFile" title="파일첨부" onchange="addFile('bankbookControl');"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${bankbookFileList}" varStatus="status">
								<div id="fileList_bankbook_<c:out value="${status.count}" />" name="bankbookControl" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>byte)
									</a>
									<button type="button" onclick="deleteVoucherAttchFile('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>','bankbookControl');">
										<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
									</button>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">사업자등록증 <strong class="point">*</strong></th>
					<td>
						<c:if test="${!empty saupjaFileList}">
							<c:set var="saupFileStyle" value="none;"></c:set>
						</c:if>
						<div class="form_file" id="saupjaControl" style='display: <c:out value="${saupFileStyle}" /> '>
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" name="saupjaFile" id="saupjaFile" title="파일첨부" onchange="addFile('saupjaControl');"/>
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${saupjaFileList}" varStatus="status">
								<div id="fileList_saupja_<c:out value="${status.count}" />" name="saupjaControl" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>byte)
									</a>
									<button type="button" onclick="deleteVoucherAttchFile('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>','saupjaControl');">
										<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
									</button>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</div>
					</td>
				</tr>
				<tr>
					<th colspan="2" scope="row" style="text-align: center;">추가서류</th>
					<td>
						<c:if test="${!empty etcFileList}">
							<c:set var="etcFileStyle" value="none;"></c:set>
						</c:if>
						<div class="form_file" id="etcControl" style='display: <c:out value="${etcFileStyle}" /> '>
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" name="etcFile" id="etcFile" title="파일첨부" onchange="addFile('etcControl');" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${etcFileList}" varStatus="status">
								<div id="fileList_etc_<c:out value="${status.count}" />" name="etcControl" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/>&nbsp;[<c:out value="${fileVO.fileMg}"/>&nbsp;byte]
									</a>
									<button type="button" onclick="deleteVoucherAttchFile('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>','etcControl');">
										<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
									</button>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">과거 신청 이력</h3>
		</div>

		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>

			<select id="pageUnit" name="pageUnit" title="목록수" class="form_select ml-auto" onchange="chgPageCnt();">
				<c:forEach var="item" items="${pageUnitList}" varStatus="status">
					<option value="${item.code}" <c:if test="${searchParam.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
				</c:forEach>
			</select>
		</div>
		<div id="voucherHistroySheet" class="sheet"></div>
		<div id="paging" class="paging ibs"></div>
	</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){

		setSheetHeader_voucherService();		// 바우처 서비스 리스트 헤더
		setSheetHeader_voucherHistroy();		// 바우처 과거신청 리스트 헤더
		getServiceList();						// 바우처 서비스 리스트 조회
		getHistroySheet();						// 바우처 과거신청 리스트
		pageControl($('#statusCd').val());		// 상태값에 따라 버튼 컨트롤

		setMailBalnk();							// 직접입력 추가
	});

	function setSheetHeader_voucherService() {	// 바우처 서비스 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '순번'			, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 10		, Align: 'Center'	, HeaderCheck : 0});
		ibHeader.addHeader({Header: '이용희망서비스'		, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '신청여부'			, Type: 'CheckBox'		, SaveName: 'useYn'				, Edit: false	, Width: 10		, Align: 'Center'	, TrueValue: "Y"	, FalseValue: "N"	, HeaderCheck: 0});
		ibHeader.addHeader({Header: '지원금액'			, Type: 'AutoSum'		, SaveName: 'reqAmt'			, Edit: false	, Width: 40		, Align: 'Right'	, Format: 'Integer'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherServiceSheet')[0];
		createIBSheet2(container, 'voucherServiceSheet', '100%', '10%');
		ibHeader.initSheet('voucherServiceSheet');

		voucherServiceSheet.SetEllipsis(1); // 말줄임 표시여부
		voucherServiceSheet.SetSelectionMode(4);

	}

	function setSheetHeader_voucherHistroy() {	// 바우처 과거신청 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'		, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '무역업번호'		, Type: 'Text'		, SaveName: 'tradeNo'			, Hidden: true});
		ibHeader.addHeader({Header: '사업년도'			, Type: 'Text'		, SaveName: 'baseYear'			, Edit: false	, Width: 15		, Align: 'Center'});
		ibHeader.addHeader({Header: '사업명'			, Type: 'Text'		, SaveName: 'voucherTitle'		, Edit: false	, Width: 40		, Align: 'Left'	, Cursor: 'Pointer'});
		ibHeader.addHeader({Header: '신청일'			, Type: 'Text'		, SaveName: 'regDt'				, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '지원총액'			, Type: 'Int'		, SaveName: 'totAmt'			, Edit: false	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '사용액'			, Type: 'Int'		, SaveName: 'totFixAmt'			, Edit: false	, Width: 30		, Align: 'Right'});
		ibHeader.addHeader({Header: '상태'			, Type: 'Text'		, SaveName: 'statusCdNm'		, Edit: false	, Width: 20		, Align: 'Center'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#voucherHistroySheet')[0];
		createIBSheet2(container, 'voucherHistroySheet', '100%', '10%');
		ibHeader.initSheet('voucherHistroySheet');

		voucherHistroySheet.SetEllipsis(1); // 말줄임 표시여부
		voucherHistroySheet.SetSelectionMode(4);

	}

	function goPage(pageIndex) {
		getHistroySheet(pageIndex);
	}

	function chgPageCnt() {
		getHistroySheet(1);
	}

	function voucherHistroySheet_OnSearchEnd() {
		// 제목에 볼드 처리
		voucherHistroySheet.SetColFontBold('voucherTitle', 1);
	}

	function addFile(gubun) {	// 첨부파일 선택

		if(gubun == 'bankbookControl') {
			$('#bankbookControl .btn_tbl').hide();
			$('#bankbookControl').append('<button type="button" id="cencel_'+gubun+'" onclick="addFileCancel(this.id)"><img src="/images/admin/ico_btn_delete.png "alt="파일삭제"></button>');
		}

		if(gubun == 'saupjaControl') {
			$('#saupjaControl .btn_tbl').hide();
			$('#saupjaControl').append('<button type="button" id="cencel_'+gubun+'" onclick="addFileCancel(this.id)"><img src="/images/admin/ico_btn_delete.png "alt="파일삭제"></button>');
		}

		if(gubun == 'etcControl') {
			$('#etcControl .btn_tbl').hide();
			$('#etcControl').append('<button type="button" id="cencel_'+gubun+'" onclick="addFileCancel(this.id)"><img src="/images/admin/ico_btn_delete.png "alt="파일삭제"></button>');
		}

	}

	function addFileCancel(tagId) {	// 선택한 첨부파일 삭제

		if(tagId.indexOf('bankbook') != -1) {
			$('#bankbookFile').val('');

			$('#bankbookControl .file_name').text('첨부파일을 선택하세요.');
			$('#bankbookControl .btn_tbl').show();
			$('#cencel_bankbookControl').remove();

		}

		if(tagId.indexOf('saupja') != -1) {
			$('#saupjaFile').val('');

			$('#saupjaControl .file_name').text('첨부파일을 선택하세요.');
			$('#saupjaControl .btn_tbl').show();
			$('#cencel_saupjaControl').remove();
		}

		if(tagId.indexOf('etc') != -1) {
			$('#etcFile').val('');

			$('#etcControl .file_name').text('첨부파일을 선택하세요.');
			$('#etcControl .btn_tbl').show();
			$('#cencel_etcControl').remove();
		}
	}

	function deleteVoucherAttchFile(atchFileId, fileSn, gubun) {	// 첨부파일 삭제

		global.ajax({
			type : 'POST'
			, url : "/voucher/voucherFileDelete.do"
			, data : {'atchFileId' : atchFileId,
					  'fileSn' : fileSn
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if(data.successYn == true) {
					$('div[name=' + gubun + ']').remove();
					$('#'+gubun).css('display','');
				}
			}
		});
	}

	function doVoucherFileDown(atchFileId, fileSn) {	// 파일 다운로드
		window.open("/voucher/voucherFileDownload.do?atchFileId="+atchFileId+"&fileSn="+fileSn+"");
	}

	function reloadPage(){

		window.location.reload();
	}

	function voucherHistroySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {

		if(rowType == 'HeaderRow'){
			return;
		}

		if(voucherHistroySheet.ColSaveName(Col) == 'voucherTitle'){

			var vmstSeq = voucherHistroySheet.GetCellValue(Row, 'vmstSeq');
			var tradeNo = voucherHistroySheet.GetCellValue(Row, 'tradeNo');

			var url = '/voucher/voucherCompanyMngDetail.do?vmstSeq=' + vmstSeq + '&tradeNo=' + tradeNo;

			window.open(url, '_blank');

		}

	}

	function getServiceList() {	// 사업정보 조회

		var tradeNo = $('#tradeNo').val();
		var vmstSeq = $('#vmstSeq').val();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherServiceCompanyMngList.do"
			, data : {'tradeNo' : tradeNo,
					  'vmstSeq' : vmstSeq}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				voucherServiceSheet.LoadSearchData({data: (data.serviceList || []) }, {Sync : true});

				var rowCnt = voucherServiceSheet.RowCount();

				var vCnt = 0;

				var chkRow = voucherServiceSheet.FindCheckedRow('useYn', {ReturnArray:1});

				if(chkRow.length > 0) {
					vCnt = chkRow.length;
				}

				var reqAmtSum = voucherServiceSheet.GetCellValue(rowCnt+1, 'reqAmt');

				$('#reqAmtSum').val(reqAmtSum);
				voucherServiceSheet.SetSumText(2, '합계');
				voucherServiceSheet.SetSumText(3, "신청서비스 총 ("+ vCnt +") 건");

			}
		});
	}

	function getHistroySheet(pageIndex) {	// 사업정보 조회

		var tradeNo = $('#tradeNo').val();
		var vmstSeq = $('#vmstSeq').val();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherHistoryList.do"
			, data : {'tradeNo' : tradeNo,
					  'vmstSeq' : vmstSeq,
					  'pageIndex' : pageIndex}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				setPaging(	// 페이징
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

				$('#totalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				voucherHistroySheet.LoadSearchData({data: (data.historyList || []) }, {Sync : true});

			}
		});
	}

	function goList(){

		var f = $('#voucherCompanyInfoForm');

		f.attr('action', '/voucher/voucherCompanyMngList.do');
		f.attr('target', '_self');
		f.submit();
	}

	function pageControl(statusCd){

		switch (statusCd) {

		case "10":

			$("#btnSave").show();
			$("#btnAprv").show();
			$("#btnAprvCancel").hide();
			$("#btnReturn").show();
			$("#btnReject").show();

			break;

		case "30":

			$("#btnSave").hide();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;


		case "40":

			$("#btnSave").hide();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;

		case "50":

			$("#btnSave").hide();
			$("#btnAprv").hide();
			$("#btnAprvCancel").hide();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;

		case "90":

			$("#btnSave").show();
			$("#btnAprv").hide();
			$("#btnAprvCancel").show();
			$("#btnReturn").hide();
			$("#btnReject").hide();

			break;
		}

		if($("#return_rsn").val() != ""){
			$("#divReturnRsn").show();
		} else {
			$("#divReturnRsn").hide();
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

	function addComma(val) {

		var eVal = global.formatCurrency(onlyNum(val));

		$('#sumSuppAmt').val(eVal);
	}

	function callReturnRsnPop() {

		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '/voucher/popup/voucherReturnRsnPop.do'
			// 레이어 팝업으로 넘기는 parameter 예시
			, callbackFunction : function(resultObj){
				if(resultObj == '') {
					alert('문제가 발생했습니다.');
				} else {
					var returnRsn = resultObj;
					updateReturnRsn(returnRsn);
				}
			}
		});
	}

	function updateReturnRsn(returnRsn) {

		var saveData = new Array();
    	var jsonObj = new Object();

    	jsonObj.vmstSeq = $('#vmstSeq').val();
    	jsonObj.tradeNo = $('#tradeNo').val();
    	jsonObj.returnRsn = returnRsn;
    	jsonObj.statusCd = '40';

    	saveData.push(jsonObj);

		global.ajax({
			type : 'POST'
			, url : "/voucher/voucherStatusChg.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				reloadPage();
			}
		});
	}

	function chgStatus(statusCd){	//반려를 제외

		var statusNm = "";

		switch (statusCd) {

		case "10":	// 승인취소 시도

			if($('#statusCd').val() != "90"){
				alert("승인상태가 아닙니다.");
				return false;
			}

			statusNm = "승인대기";
			break;

		case "50":
			statusNm = "포기";
			break;

		case "90":
			statusNm = "승인";
			break;
		}

		if(!confirm(statusNm+" 하시겠습니까?")){
			return false;
		}

    	var saveData = new Array();
    	var jsonObj = new Object();

    	jsonObj.vmstSeq = $('#vmstSeq').val();
    	jsonObj.tradeNo = $('#tradeNo').val();
    	jsonObj.statusCd = statusCd;

    	saveData.push(jsonObj);

    	global.ajax({
			type : 'POST'
			, url : '/voucher/voucherStatusChg.do'
			, contentType : 'application/json'
			, data : JSON.stringify(saveData)
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.result == false) {
					alert(data.message);
					return;
				} else {
					reloadPage();
				}
	        }
		});
	}

	function saveValid(){

		var numChk = /[^0-9]/;

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
			alert("담당자 직위명은 필수입니다.");
			$("#manPos").focus();
			return false;
		}

		if($("#manHpno2").val() == ""){
			alert("담당자 휴대전화번호는 필수입니다.");
			$("#manHpno2").focus();
			return false;
		} else {
			if(numChk.test($('#manHpno2').val())) {
				alert('숫자만 입력해 주세요.');
				$('#manHpno2').focus();
				return false;
			}
		}

		if($("#manHpno3").val() == ""){
			alert("담당자 휴대전화번호는 필수입니다.");
			$("#manHpno3").focus();
			return false;
		} else {
			if(numChk.test($('#manHpno3').val())) {
				alert('숫자만 입력해 주세요.');
				$('#manHpno3').focus();
				return false;
			}
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

		if(!$('input:radio[name=kitaCardCd]').is(':checked')){
			alert("KITA 멤버쉽 카드 발급 내역은 필수입니다.");
			$("#kitaCardCd").focus();
			return false;
		}


		if($("#bankCd").val() == ""){
			alert("은행명은 필수입니다.");
			$("#bankCd").focus();
			return false;
		}

		if($("#accountHolder").val() == ""){
			alert("예금주는 필수입니다.");
			$("#accountHolder").focus();
			return false;
		}

		if($("#accountNum").val() == ""){
			alert("계좌번호는 필수입니다.");
			$("#accountNum").focus();
			return false;
		} else {
			if(numChk.test($('#accountNum').val())) {
				alert('숫자만 입력해 주세요.');
				$('#accountNum').focus();
				return false;
			}
		}

		//신청금액 검증
		var sumSuppAmt = Number(onlyNum($("#sumSuppAmt").val()));
		var reqAmtSum = Number(onlyNum($("#reqAmtSum").val()));

		if(sumSuppAmt < reqAmtSum){
			alert("지원금액의 합계는 총지원한도를 초과할 수 없습니다.");
			return false;
		}

		return true;

	}

	function saveVoucherCompanyInfo() {	// 바우처 서비스 등록

		if(!saveValid()){	// 회사상세정보 validation
			return false;
		}

		if(!confirm("저장 하시겠습니까?")){
			return false;
		}

		global.ajaxSubmit($('#voucherCompanyInfoForm'), {
			type : 'POST'
			, url : '/voucher/updateVoucherCompanyInfo.do'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.result == false) {
					alert(data.message);
				} else {
					reloadPage();
				}
	        }
		});
	}



</script>