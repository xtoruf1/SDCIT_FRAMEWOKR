<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>

<% pageContext.setAttribute("newLineChar", "\n"); %>
<%
 /**
  * @Class Name : topMenu.jsp
  * @Description : 대메뉴 목록화면
  * @Modification Information
  * @
  * @ 수정일			수정자		수정내용
  * @ ----------	----	------
  * @ 2016.04.28	이인오		최초 생성
  *
  * @author 이인오
  * @since 2016.04.28
  * @version 1.0
  * @see
  *
  */
%>
<script type="text/javascript">
	var oEditors = [];

	function fn_list() {
		document.frm.action = "/tradeSOS/problem/problSuggestList.do";
		document.frm.submit();
	}

	// $(document).ready(function() {
	// 	// 첨부파일
	// 	$("input:file[name^='adminAttach']").change(function(){
	// 		$(this).parents('div.inputFile').find("input:hidden[name^='FILE_SEQ']").val("");
	// 		$(this).parents('div.inputFile').find("input:text[name^='fileName']").val($(this).val().substring($(this).val().lastIndexOf("\\")+1));
	// 	});
	//
	// });
	function fn_print() {
		var f = document.adminForm;

		var left, top, nWidth, nHeight, url ,strUrl ;
		nWidth = 1000;
		nHeight = 700;
		left = ((screen.width - nWidth) / 2);
		top = ((screen.height - nHeight) / 2);

		strUrl = '/tradeSOS/problem/problSuggestPrintPop.do';
		strUrl += "?sosSeq="+$('#sosSeq').val();

		window.open(strUrl, "problSuggestPrintPop", 'left='+left+',top='+top+',width='+nWidth+',height='+nHeight+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no');
	}

</script>
<%--완료상태가 아닌경우 수정 가능--%>
<c:set var="edit" value="false"/>
<c:if test="${resultData.proState ne 'FY' and resultData.proState ne 'M '}">
	<c:set var="edit" value="true"/>
</c:if>

<!-- 무역애로건의 - 애로건의 현황 상세 -->

<div class="flex">
	<h2 class="popup_title">애로건의 신청 정보</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="fn_print();">보고자료출력</button>
<%--	(사용하지 않는 메뉴라 이관,저장 주석처리됨)	<button type="button" class="btn_sm btn_primary" onclick="fnMoveFta()">FTA 이관</button>--%>
<%--		<button type="button" class="btn_sm btn_primary" onclick="goMoveConsult()">무역실무 이관</button>--%>
	</div>
	<c:if test="${edit}">
		<div class="ml-15">
<%--			<button type="button" class="btn_sm btn_primary" onclick="fnSubmit()">저장</button>--%>
			<button type="button" class="btn_sm btn_secondary" onclick="fnDelete();">삭제</button>
		</div>
	</c:if>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>

</div>

<div class="page_tradesos popWrap">
	<!-- 인쇄 결제라인 -->
	<div class="approve" style="display:none">
		<table>
			<colgroup>
				<col style="width:50px">
				<col style="width:90px">
				<col style="width:90px">
				<col style="width:90px">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" rowspan="2">결재</td>
					<th scope="col"> </td>
					<th scope="col"> </td>
					<th scope="col"> </td>
				</tr>
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
				</tr>
			</tbody>
		</table>
	</div>
	<!-- // 인쇄 결제라인 -->

	<!-- <h4 class="para_sub_title">애로건의 신청 정보</h4> -->

	<form name="adminForm" id="adminForm" action ="" method="post">
		<input type="hidden" id="sosSeq" name="sosSeq" value="<c:out value="${resultData.sosSeq}"/>"/>
		<input type="hidden" id="proState" name="proState" value="<c:out value="${resultData.proState}"/>"/>
		<input type="hidden" name="eventSdcit" id="eventSdcit" value=""/>
		<div class="cont_block">
			<table class="formTable">
				<colgroup>
					<col style="width:10%">
					<col style="width:15%">
					<col>
					<col style="width:15%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" rowspan="5">회사정보</th>
						<th scope="row">회사명</th>
						<td>
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<span class="form_search w100p">
										<input class="form_text w100p" id="compnyNm" name="compnyNm" type="text" maxlength="25" value="<c:out value="${resultData.compnyNm}"/>"/>
										<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(1);"></button>
									</span>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.compnyNm}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
						<th scope="row">무역업고유번호</th>
						<td>
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<span class="form_search w100p">
										<input class="form_text w100p" name="tradeNum" id="tradeNum" type="text" maxlength="25" value="<c:out value="${resultData.tradeNum}"/>" />
										<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(2);"></button>
									</span>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.tradeNum}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">대표자</th>
						<td>
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="presidentKor" name="presidentKor" class="form_text w100p" maxlength="25" value="<c:out value="${resultData.presidentKor}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.presidentKor}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">사업자등록번호</th>
						<td>
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<span class="form_search w100p">
										<input class="form_text w100p" name="regNo" id="regNo" type="text" maxlength="25" value="<c:out value="${resultData.regNo}"/>"/>
										<button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openTradePopup(3);"></button>
									</span>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.regNo}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">대표전화</th>
						<td>
							<input type="hidden" id="compPhone" name="compPhone" value="<c:out value="${resultData.compPhone}"/>">
									<div class="flex align_center">
										<c:choose>
											<c:when test="${edit}">
												<select id="compPhone1" name="compPhone1" class="form_select">
													<option value="">선택</option>
													<c:forEach var="data" items="${code130}" varStatus="status">
														<option value="${data.cdId}" <c:out value="${fn:split(resultData.compPhone,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
													</c:forEach>
												</select>
												<input type="text" name="compPhone2" id="compPhone2" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.compPhone,'-')[1]}"/>" maxlength="4">
												<input type="text" name="compPhone3" id="compPhone3" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.compPhone,'-')[2]}"/>" maxlength="4">
											</c:when>
											<c:otherwise>
												<c:out value="${resultData.compPhone}"/>
											</c:otherwise>
										</c:choose>
									</div>
						</td>
						<th scope="row">FAX</th>
						<td>
							<input type="hidden" id="compFax" name="compFax" value="<c:out value="${resultData.compFax}"/>">
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<select id="compFax1" name="compFax1" class="form_select">
										<option value="">선택</option>
										<c:forEach var="data" items="${code130}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.compFax,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="compFax2" id="compFax2" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.compFax,'-')[1]}"/>" maxlength="4" >
									<input type="text" name="compFax3" id="compFax3" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.compFax,'-')[2]}"/>" maxlength="4" >
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.compPhone}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">지역</th>
						<td>
							<select id="reqArea" name="reqArea" class="form_select" <c:out value="${edit ? '' : 'disabled'}"/>>
								<option value="">소재지</option>
								<c:forEach var="data" items="${code120}" varStatus="status">
									<option value="${data.cdId}" <c:out value="${resultData.reqArea eq data.cdId ? 'selected' : ''}"/>>${data.cdNm}</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">취급품목</th>
						<td>
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="bizItems" name="bizItems" class="form_text w100p" value="<c:out value="${resultData.bizItems}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.bizItems}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row">회사주소</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="compAddr" name="compAddr" class="form_text w100p" value="<c:out value="${resultData.compAddr}"/>" maxlength="60">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.compAddr}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row" rowspan="4">업체담당자</th>
						<th scope="row">이름</th>
						<td>
							<c:choose>
								<c:when test="${edit}">
									<input type="text" idname="reqName" name="reqName" class="form_text w100p" value="<c:out value="${resultData.reqName}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqName}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">직위</th>
						<td>
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="reqPostion" name="reqPostion" class="form_text w100p" value="<c:out value="${resultData.reqPostion}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqPostion}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th scope="row">부서</th>
						<td>
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="reqDept" name="reqDept" class="form_text w100p" value="<c:out value="${resultData.reqDept}"/>">
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqDept}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th scope="row">휴대폰</th>
						<td>
							<input type="hidden" id="reqHp" name="reqHp" value="<c:out value="${resultData.reqHp}"/>">
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<select id="reqHp1" name="reqHp1" class="form_select">
										<option value="" selected="">선택</option>
										<c:forEach var="data" items="${code132}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.reqHp,'-')[0] eq data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="reqHp2" id="reqHp2" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqHp,'-')[1]}"/>" maxlength="4" >
									<input type="text" name="reqHp3" id="reqHp3" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqHp,'-')[2]}"/>" maxlength="4" >
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqHp}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td>
							<input type="hidden" id="reqPhone" name="reqPhone" value="<c:out value="${resultData.reqPhone}"/>">
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<select id="reqPhone1" name="reqPhone1" class="form_select">
										<option value="">선택</option>
										<c:forEach var="data" items="${code130}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.reqPhone,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="reqPhone2" id="reqPhone2" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqPhone,'-')[1]}"/>" maxlength="4" >
									<input type="text" name="reqPhone3" id="reqPhone3" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqPhone,'-')[2]}"/>" maxlength="4" >
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqPhone}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
						</td>
						<th scope="row">FAX</th>
						<td>
							<input type="hidden" id="reqFax" name="reqFax" value="<c:out value="${resultData.reqFax}"/>">
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<select id="reqFax1" name="reqFax1" class="form_select">
										<option value="">선택</option>
										<c:forEach var="data" items="${code130}" varStatus="status">
											<option value="${data.cdId}" <c:out value="${fn:split(resultData.reqFax,'-')[0] == data.cdId ? 'selected' : ''}"/>>${data.cdId}</option>
										</c:forEach>
									</select>
									<input type="text" name="reqFax2" id="reqFax2" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqFax,'-')[1]}"/>" maxlength="4" >
									<input type="text" name="reqFax3" id="reqFax3" class="form_text w100p ml-8" value="<c:out value="${fn:split(resultData.reqFax,'-')[2]}"/>" maxlength="4" >
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqFax}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td colspan="3">
							<input type="hidden" id="reqEmail" name="reqEmail" value="${resultData.reqEmail}"/>
							<div class="flex align_center">
							<c:choose>
								<c:when test="${edit}">
									<input type="text" id="reqEmail1" name="reqEmail1" class="form_text w100p" value="<c:out value="${fn:split(resultData.reqEmail,'@')[0]}"/>">
									<div class="spacing">@</div>
									<input type="text" id="reqEmail2" name="reqEmail2" class="form_text w100p" value="<c:out value="${fn:split(resultData.reqEmail,'@')[1]}"/>">
									<select id="selectEmail" class="form_select ml-8">
										<option value="">직접입력</option>
										<c:forEach var="data" items="${code070}" varStatus="status">
											<option value="${data.cdNm}" <c:out value="${fn:split(resultData.reqEmail,'@')[1] == data.cdNm ? 'selected' : ''}"/>>${data.cdNm}</option>
										</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									<c:out value="${resultData.reqEmail}"/>
								</c:otherwise>
							</c:choose>
							</div>
						</td>
					</tr>
					<c:if test="${resultData.directYn eq 'N'}">
						<tr>
							<th scope="row" rowspan="2">대리입력정보</th>
							<th scope="row"> 대리입력자</th>
							<td><c:out value="${resultData.proUserid}"/></td>
							<th scope="row">대리입력자 소속</th>
							<td><c:out value="${resultData.proDept}"/></td>
						</tr>
						<tr>
							<th scope="row">대리입력자 연락처</th>
							<td><c:out value="${resultData.proHp}"/></td>
							<th scope="row">대리입력자 E-mail</th>
							<td><c:out value="${resultData.proEmail}"/></td>
						</tr>
					</c:if>
					<tr>
						<th scope="row" rowspan="5">건의내용</th>
						<th scope="row"> 제목</th>
						<td colspan="3"><c:out value="${resultData.reqTitle}"/></td>
					</tr>
					<tr>
						<th scope="row">분야</th>
						<td><c:out value="${resultData.reqCatHight}"/> – <c:out value="${resultData.reqCatMiddle}"/></td>
						<th scope="row">신청채널</th>
						<td><c:out value="${resultData.reqChannel}"/></td>
					</tr>
					<tr>
						<th scope="row">상세</th>
						<td colspan="3">
							${fn:replace(resultData.reqContents, newLineChar, "<br/>")}
						</td>
					</tr>
					<tr>
						<th scope="row">공개여부</th>
						<td colspan="3"><c:out value="${resultData.openYn eq 'Y' ? '공개' : '비공개' }"/></td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td colspan="3">
<%--							<c:forEach var="data" items="${userFileList}" varStatus="status">--%>
<%--								<span class="attr_list"><a href="javascript:directFileDown('<c:out value="${data.filePath}" />', '<c:out value="${data.encSaveName}" />', '<c:out value="${data.encOrgName}" />')" class="txt_line"><c:out value="${data.rfilenm}"/></a></span>--%>
<%--							</c:forEach>--%>
						<div id="attachFieldList">
							<c:forEach var="data" items="${userFileList}" varStatus="status">
								<div class="addedFile" id="${data.sosSeq}">
									<a href="<c:url value="/tradeSOS/com/fileDownload.do" />?seq=${data.seq}&sosSeq=${data.sosSeq}&fileSeq=${data.fileSeq}" class="filename">
											${data.rfilenm}
									</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/com/fileDownload.do?seq=${data.seq}&sosSeq=${data.sosSeq}&fileSeq=${data.fileSeq}', '${data.rfilenm}', 'membershipboard_${profile}_${data.seq}_${data.sosSeq}_${data.fileSeq}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</div>
						</td>
					</tr>
				</tbody>
			</table><!-- // 애로건의 현황 상세 테이블-->
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">접수정보</h3>
				<div class="ml-auto">
					<button type="button" class="btn_sm btn_secondary" onclick="openLayerPerson();">담당자 변경</button>
				</div>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:20%">
					<col>
					<col style="width:20%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">소관기관</th>
						<td>
							<c:choose>
								<c:when test="${resultData.conOrga eq 'K'}">
									무역협회
								</c:when>
								<c:when test="${resultData.conOrga eq 'G'}">
									정부기관
								</c:when>
								<c:when test="${resultData.conOrga eq 'I'}">
									유관기관
								</c:when>
								<c:when test="${resultData.conOrga eq 'L'}">
									지자체
								</c:when>
							</c:choose>
						</td>
						<th scope="row">기관명</th>
						<td><c:out value="${resultData.conOrganm}"/></td>
					</tr>
					<tr>
						<th scope="row">담당부처</th>
						<td><c:out value="${resultData.conDept}"/></td>
						<th scope="row">담당자</th>
						<td><c:out value="${resultData.conName}"/></td>
					</tr>
					<tr>
						<th scope="row">연락처</th>
						<td>
							<c:out value="${resultData.conPhone}"/>
						</td>
						<th scope="row">이메일</th>
						<td><c:out value="${resultData.conEmail}"/></td>
					</tr>
				</tbody>
			</table><!-- // 애로건의 현황 접수정보 테이블-->
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">검토결과</h3>
				<div class="ml-auto">
					<button type="button" class="btn_sm btn_secondary" onclick="openLayerResult();">결과등록</button>
				</div>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:10%">
					<col style="width:10%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" colspan="2">건의 구분</th>
						<td>
							<c:out value="${resultData.reqTypeCdNm}"/>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">답변 내용</th>
						<td>
							<c:out value="${resultData.reqCompAns}" escapeXml="false"/>
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2">비망록 [업체비공개]</th>
						<td>${fn:replace(resultData.recComment, newLineChar, "<br/>")} </td>
					</tr>

					<tr>
						<th scope="row" rowspan="2">관련법률</th>
						<th scope="row">법률</th>
						<td><c:out value="${resultData.law}"/></td>
					</tr>
					<tr>
						<th scope="row">조항</th>
						<td><c:out value="${resultData.lawClause}"/></td>
					</tr>
					<tr>
						<th scope="row" colspan="2">기타참고사항</th>
						<td><c:out value="${resultData.dscr}"/></td>
					</tr>

					<tr>
						<th scope="row" colspan="2">첨부파일</th>
						<td>
							<div id="attachFieldList">
								<c:forEach var="data" items="${adminFileList}" varStatus="status">
									<div class="addedFile" id="${data.sosSeq}">
										<a href="<c:url value="/tradeSOS/com/fileDownload.do" />?seq=${data.seq}&sosSeq=${data.sosSeq}&fileSeq=${data.fileSeq}" class="filename">
												${data.rfilenm}
										</a>
										<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/com/fileDownload.do?seq=${data.seq}&sosSeq=${data.sosSeq}&fileSeq=${data.fileSeq}', '${data.rfilenm}', 'membershipboard_${profile}_${data.seq}_${data.sosSeq}_${data.fileSeq}');" class="file_preview btn_tbl_border">
											<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
										</button>
									</div>
								</c:forEach>
							</div>
						</td>
					</tr>
				</tbody>
			</table><!-- // 애로건의 현황 검토결과 테이블-->
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">처리이력</h3>
			</div>
			<div id='processingHistory' class="colPosi"></div>
		</div>
	</form>

</div> <!-- // .page_tradesos -->

<script type="text/javascript">

	$(document).ready(function()
	{									//IBSheet 호출
		f_Init_processingHistory();		// 리스트  Sheet 셋팅
		getProcessingHistory();						// 목록 조회
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function f_Init_processingHistory()								//처리이력 목록
	{
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", Header: "일시"			, SaveName: "indate"		, Align: "Center"	, Width: 150});
		ibHeader.addHeader({Type: "Text", Header: "상태"			, SaveName: "statusCdNm"	, Align: "Center"	, Width: 100	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "이력내용"		, SaveName: "hisText"		, Align: "Left"		, Width: 300	, ToolTip: true});
		ibHeader.addHeader({Type: "Text", Header: "소관부처/기관"	, SaveName: "conOrganm"		, Align: "Left"		, Width: 200});
		ibHeader.addHeader({Type: "Text", Header: "담당자"		, SaveName: "conName"		, Align: "Center"	, Width: 100});

		var sheetId = "processingHistory";
		var container = $("#"+sheetId)[0];

		if (typeof processingHistory !== 'undefined' && typeof processingHistory.Index !== 'undefined') {
			processingHistory.DisposeSheet();
		}

		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	};

	function getProcessingHistory() {
		$.ajax({
			url: '/tradeSOS/problem/processResultListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#adminForm').serialize(),
			success: function (data) {
				processingHistory.LoadSearchData({Data: data.resultList});
			},
			error:function(request,status,error) {
				alert('처리이력 조회에 실패했습니다.');
			}
		});
	}

	function openTradePopup(tradeParam) {						//무역업 검색 팝업
		var companyNm = $('#compnyNm').val();					//상세보기에 입력된 회사명 팝업창에 입력
		var tradeNum = $('#tradeNum').val();						//상세보기에 입력된 고유번호로 팝업창에 입력
		var regNo = $('#regNo').val();						//상세보기에 입력된 사업자번호로 팝업창에 입력

		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/tradeSearch.do'
			, params : {
				searchKeyword : tradeParam						//회사명 : 1, 무역업고유번호 :2, 사업자등록번호 구분 : 3
				,companyNm : companyNm
				,tradeNum : tradeNum
				,regNo : regNo
			}
			, callbackFunction : function(resultObj) {
				$('#compnyNm').val(resultObj.companyKor);
				$('#tradeNum').val(resultObj.memberId);
				$('#regNo').val(resultObj.enterRegNo);
				$('#presidentKor').val(resultObj.presidentKor);

			}
		});
	}

	function openLayerPerson() {								//담당자 변경 팝업
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/personnelChanges.do'
			, params : {
				pSosSeq : $('#sosSeq').val(),
				ajaxUrl : '/tradeSOS/problem/problSuggestDetailProc.do'
			}, callbackFunction : function(resultObj) {
				// $('#compny_nm').val(resultObj.companyKor);
				// $('#trade_num').val(resultObj.memberId);
				// $('#reg_no').val(resultObj.enterRegNo);

			}
		});
	}

	function openLayerResult() {								//결과입력 팝업

		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/resultRegistration.do'
			, params : {
				pSosSeq : $('#sosSeq').val(),
				ajaxUrl : "/tradeSOS/problem/problSuggestDetailProc.do"
			}, callbackFunction : function(resultObj) {
				// $('#compny_nm').val(resultObj.companyKor);
				// $('#trade_num').val(resultObj.memberId);
				// $('#reg_no').val(resultObj.enterRegNo);

			}
		});
	}

	function goMoveConsult() {									//무역실무 이관 팝업
		global.openLayerPopup({
			popupUrl : '/tradeSOS/problem/popup/tradePractice.do'
			, params : {
				ajaxUrl : "/tradeSOS/problem/problSuggestDetailProc.do"
			}, callbackFunction : function(resultObj) {
			}
		});
	}

	function fnPhoneValidation(value) {
		if (/^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}/.test(value)) {
			return true;
		}
		return false;
	}

	//fta이관
	var moveFtaSubmitFlag = true;
	function fnMoveFta(){
		$('#eventSdcit').val('MoveFta');
		var formData = new FormData($('#adminForm')[0]);

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url:"/tradeSOS/problem/problSuggestDetailProc.do",
			data:formData,
			processData:false,
			contentType:false,
			async:false,
			success:function(data){
				window.opener.location.reload()
				window.close();
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});

	}

	var submitFlag = true;
	function fnSubmit() {
		if (confirm('저장 하시겠습니까?')) {
			var form = document.adminForm;


			//회사 FAX------------------------------------------------------------------------------------
			var compFax1 = form.compFax1.value;													// 회사 FAX
			var compFax2 = form.compFax2.value;													// 회사 FAX
			var compFax3 = form.compFax3.value;													// 회사 FAX

			//회사 대표전화------------------------------------------------------------------------------------
			var compPhone1 = form.compPhone1.value;													// 회사 대표전화
			var compPhone2 = form.compPhone2.value;													// 회사 대표전화
			var compPhone3 = form.compPhone3.value;													// 회사 대표전화

			//신청자 정보 핸드폰 ------------------------------------------------------------------------------------
			var reqHp1 = form.reqHp1.value;
			var reqHp2 = form.reqHp2.value;													// 신청자 정보 핸드폰
			var reqHp3 = form.reqHp3.value;													// 신청자 정보 핸드폰


			//신청자 정보 전화번호  ------------------------------------------------------------------------------------
			var reqPhone1 = form.reqPhone1.value;													//신청자 정보 전화번호
			var reqPhone2 = form.reqPhone2.value;													// 신청자 정보 전화번호
			var reqPhone3 = form.reqPhone3.value;													// 신청자 정보 전화번호
			//신청자 FAX  ------------------------------------------------------------------------------------
			var reqFax1 = form.reqFax1.value;													// 신청자 FAX
			var reqFax2 = form.reqFax2.value;													// 신청자 FAX
			var reqFax3 = form.reqFax3.value;													// 신청자 FAX

			var reqEmai1 = form.reqEmail1.value;													// 신청자 Email
			var reqEmai2 = form.reqEmail2.value;													// 신청자 Email
			form.reqEmail.value = reqEmai1 + "@" + reqEmai2;

			form.compFax.value = tel_block_chk(compFax1, compFax2, compFax3);
			form.compPhone.value = tel_block_chk(compPhone1, compPhone2, compPhone3);
			form.reqHp.value = tel_block_chk(reqHp1, reqHp2, reqHp3);
			form.reqPhone.value = tel_block_chk(reqPhone1, reqPhone2, reqPhone3);
			form.reqFax.value = tel_block_chk(reqFax1, reqFax2, reqFax3);

			//회사 정보 입력 validate
			if (isStringEmpty(form.compnyNm.value)) {
				alert("회사명은 필수입력 항목입니다.");
				form.compnyNm.focus();
				return;
			}

			if (isStringEmpty(form.tradeNum.value)) {
				alert("무역업고유번호는 필수입력 항목입니다.");
				form.tradeNum.focus();
				return;
			}

			if (isStringEmpty(form.presidentKor.value)) {
				alert("대표자명은 필수입력 항목입니다.");
				form.presidentKor.focus();
				return;
			}

			if (isStringEmpty(form.regNo.value)) {
				alert("사업자 등록번호는 필수입력 항목입니다.");
				form.regNo.focus();
				return;
			}
			if (isStringEmpty(form.reqArea.value)) {
				alert("지역은 필수입력 항목입니다.");
				form.reqArea.focus();
				return;
			}
			if (isStringEmpty(form.bizItems.value)) {
				alert("취급품목은 필수입력 항목입니다.");
				form.bizItems.focus();
				return;
			}
			if (isStringEmpty(form.compAddr.value)) {
				alert("회사주소는 필수입력 항목입니다.");
				form.compAddr.focus();
				return;
			}

			if (isStringEmpty(form.reqName.value)) {
				alert("이름은 필수입력 항목입니다.");
				form.reqName.focus();
				return;
			}


			if (isStringEmpty(form.reqPostion.value)) {
				alert("직위는 필수입력 항목입니다.");
				form.reqPostion.focus();
				return;
			}

			if (isStringEmpty(form.reqDept.value)) {
				alert("부서는 필수입력 항목입니다.");
				form.reqDept.focus();
				return;
			}
			if (!fnPhoneValidation(form.reqHp.value)) {
				alert("휴대폰번호는 필수입력 항목입니다.");
				form.reqHp1.focus();
				return;
			}
			if (!global.isEmail(form.reqEmail.value)) {
				alert("이메일은 필수입력 항목입니다.");
				form.reqEmail1.focus();
				return;
			}

			$('#eventSdcit').val('Update');						//상태값 설정
			tranProc();											//저장함수

		}
	}

	function fnDelete(){
		$('#eventSdcit').val('Delete');						//상태값 설정
		var form = document.submitForm;
		if (confirm("삭제 하시겠습니까?")){
			tranProc();
		}
	}

	//첨부파일 다운로드
	function directFileDown(filePath, saveName, fileName) {
		var f = document.adminForm;
		f.action = "/tradeSOS/com/fileDownload.do?filePath="+filePath+"&encSaveName="+saveName+"&encOrgName="+fileName;
		f.target = "_self";
		f.submit();
	}

	function tranProc() {									//수정,삭제 함수
		var formData = new FormData($('#adminForm')[0]);

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url:"/tradeSOS/problem/problSuggestProc.do",
			data:formData,
			processData:false,
			contentType:false,
			async:false,
			success:function(data){
				closeLayerPopup();
				window.location.reload();
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	function tel_block_chk(val1, val2, val3){
		var value = "";
		if(val1 == null || val2 == null || val3 == null){
			return false;
		}else{
			value = val1+"-"+val2+"-"+val3;
		}
		return value;
	}
	//태그제거
	function deletetag(input, allow) {
		var regExp;
		if (allow.length != 0)
			regExp = "<\\/?(?!(" + allow.join('|') + "))\\b[^>]*>";
		else
			regExp = "<\/?[^>]*>";
		return input.replace(new RegExp(regExp, "gi"), "");
	}


	function fnNumber(){
		if((event.keyCode<45)||(event.keyCode>57 || event.keyCide > 45 || event.keyCode <48) || (event.keyCode == 47))
			event.returnValue=false;
	}

	function check_byte(str)

	{

		var byteLength= 0;

		for(var inx=0; inx < str.length; inx++)

		{

			var oneChar = escape(str.charAt(inx));

			if( oneChar.length == 1 )

				byteLength ++;

			else if(oneChar.indexOf("%u") != -1)

				byteLength += 2;

			else if(oneChar.indexOf("%") != -1)

				byteLength += oneChar.length/3;

		}

		return byteLength;

	}

	function doDownloadFile(filePath,sosSeq,seq,fileSeq,rfilenm) {								//첨부파일 다운로드
		location.href = '/tradeSOS/problem/File/FileDownload.do?filePath='+filePath+'&sosSeq='+sosSeq+'&seq='+seq+'&fileSeq='+fileSeq+'&rfilenm='+rfilenm;
	}
</script>