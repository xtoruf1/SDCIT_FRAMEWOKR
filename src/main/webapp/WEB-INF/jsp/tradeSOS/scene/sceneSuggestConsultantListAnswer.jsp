<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<% pageContext.setAttribute("newLineChar", "\n"); %>

<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fnSubmit();">등록</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
	</div>
</div>
<!-- 무역현장 컨설팅 상세 -->
<div class="page_tradesos">
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">회사정보</h3>
		</div>
		<table class="boardwrite formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"> 회사명</th>
					<td class="align_ctr"><c:out value="${resultData.company}"/></td>
					<th scope="row">무역업고유번호</th>
					<td class="align_ctr"><c:out value="${resultData.tradeNo}"/></td>
				</tr>
				<tr>
					<th scope="row">대표자</th>
					<td class="align_ctr"><c:out value="${resultData.companyPresident}"/></td>
					<th scope="row">사업자등록번호</th>
					<td class="align_ctr"><c:out value="${resultData.companyNo}"/></td>
				</tr>
				<tr>
					<th scope="row">대표전화</th>
					<td class="align_ctr"><c:out value="${resultData.companyTel}"/></td>
					<th scope="row">FAX</th>
					<td class="align_ctr"><c:out value="${resultData.companyFax}"/></td>
				</tr>
				<tr>
					<th scope="row">회사주소</th>
					<td colspan="3"><c:out value="${resultData.companyAddr}"/></td>
				</tr>
			</tbody>
		</table><!-- // 회사정보 테이블-->
	</div>
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">신청내역</h3>
		</div>
		<table class="boardwrite formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">접수경로</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${empty resultData.routeCdNm}">
								자문신청
							</c:when>
							<c:otherwise>
								<c:out value="${resultData.routeCdNm}"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th scope="row">이름</th>
					<td><c:out value="${resultData.applyName}"/></td>
					<th scope="row">직책</th>
					<td><c:out value="${resultData.applyGrade}"/></td>
				</tr>
				<tr>
					<th scope="row">부서</th>
					<td><c:out value="${resultData.applyDepart}"/></td>
					<th scope="row">휴대폰</th>
					<td><c:out value="${resultData.applyCell}"/></td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td><c:out value="${resultData.applyTel}"/></td>
					<th scope="row">이메일</th>
					<td><c:out value="${resultData.applyEmail}"/></td>
				</tr>
					<th scope="row">상담(방문)지역</th>
					<td><c:out value="${resultData.hopeCityNm}"/></td>
					<th scope="row">해외진출시장</th>
					<td><c:out value="${resultData.relNm}"/></td>
				</tr>
				<tr>
					<th scope="row">자문분야</th>
					<td colspan="3"><c:out value="${resultData.sectNm}"/></td>
				</tr>
				<tr>
					<th scope="row">취급품목</th>
					<td colspan="3"><c:out value="${resultData.itemNm}"/></td>
				</tr>
				<tr>
					<th scope="row">컨설팅 신청 제목</th>
					<td colspan="3"><c:out value="${resultData.title}"/></td>
				</tr>
				<tr>
					<th scope="row">신청내용</th>
					<td colspan="3">${fn:replace(resultData.regContent, newLineChar, "<br/>")}</td>
				</tr>
				<tr>
					<tr>
					<th>첨부파일 목록</th>
					<td colspan="3">
						<div id="attachFieldList">
						<c:forEach var="fileResult" items="${fileList}" varStatus="status">
							<div class="addedFile" id="${fileResult.attachSeqNo}">
								<a href="javascript:doDownloadFile('<c:out value="${fileResult.attachDocumId}"/>', '<c:out value="${fileResult.attachSeqNo}"/>');" class="filename">
									<c:out value="${fileResult.attachDocumNm}"/>
								</a>
								<a href="javascript:doDeleteFile('${fileResult.attachDocumId}', '${fileResult.attachSeqNo}', '006');" class="btn_del">
									<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
								</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/scene/tradeSOSFileDownload.do?attachDocumId=${fileResult.attachDocumId}&attachSeqNo=${fileResult.attachSeqNo}', '${fileResult.attachDocumNm}', 'membershipexpert_${profile}_${fileResult.attachDocumId}_${fileResult.attachSeqNo}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</c:forEach>
						</div>
					</td>
				</tr>
				</tr>
			</tbody>
		</table><!-- // 신청내역 테이블-->
	</div>
	<div class="cont_block">
		<!-- 타이틀 영역 -->
		<div class="tit_bar">
			<h3 class="tit_block">컨설팅 내역</h3>
		</div>
		<form name="submitForm" id="submitForm" method="post">
			<input type="hidden" name="no" value="${resultData.no}"/>
			<input type="hidden" name="eventSdcit" value=""/>
			<input type="file" id="attachFile" name="attachFile" class="txt attachment hidden" title="첨부파일" />
			<table class="boardwrite formTable">
				<colgroup>
					<col style="width:12%">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">상담방법</th>
					<td>
						<label class="label_form">
							<input type="radio" name="gubun" id="radio2_1" class="form_radio" value="010"> <span for="radio2_1" class="label">현장방문</span>
						</label>
						<label class="label_form">
							<input type="radio" name="gubun" id="radio2_2" class="form_radio" value="020"> <span for="radio2_2" class="label">전화 및 온라인</span>
						</label>
					</td>
				</tr>
				<tr>
					<th scope="row">담당위원</th>
					<td><c:out value="${resultData.expertNm}"/></td>
				</tr>
				<tr>
					<th scope="row">상담내용</th>
					<td>
						<textarea  name="content" rows="20" class="form_textarea"></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">규제 접수 내용</th>
					<td>
						<textarea  name="content2" rows="2" class="form_textarea"></textarea>
					</td>
				</tr>
				</tbody>
			</table><!-- // 컨설팅 내역 등록 테이블-->
		</form>
	</div>

	<form id="searchForm">
		<input type="hidden" name="pageIndex" value="<c:out value="${searchVO.pageIndex}"/>"/>
		<input type="hidden" name="frDt" value="<c:out value="${searchVO.frDt}"/>"/>
		<input type="hidden" name="toDt" value="<c:out value="${searchVO.toDt}"/>"/>
		<input type="hidden" name="title" value="<c:out value="${searchVO.title}"/>"/>
		<input type="hidden" name="content" value="<c:out value="${searchVO.content}"/>"/>
		<input type="hidden" name="searchCondition" value="<c:out value="${searchVO.searchCondition}"/>"/>
		<input type="hidden" name="searchKeyword" value="<c:out value="${searchVO.searchKeyword}"/>"/>
		<input type="hidden" name="searchKeyword2" value="<c:out value="${searchVO.searchKeyword2}"/>"/>
		<input type="hidden" name="applyName" value="<c:out value="${searchVO.applyName}"/>"/>
		<input type="hidden" name="expertNm" value="<c:out value="${searchVO.expertNm}"/>"/>
		<input type="hidden" name="sect" value="<c:out value="${searchVO.sect}"/>"/>
		<input type="hidden" name="item" value="<c:out value="${searchVO.item}"/>"/>
		<input type="hidden" name="mtiCode" value="<c:out value="${searchVO.mtiCode}"/>">
		<input type="hidden" name="mtiUnit" value="<c:out value="${searchVO.mtiUnit}"/>">
		<input type="hidden" name="status" value="<c:out value="${searchVO.status}"/>"/>
	</form>

</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	var submitFlag = true;
	function fnSubmit(){
		var form = document.submitForm;
		if ($("textarea[name=content]").val().trim() == ""){
			alert("상담내용을 입력해주세요.");
			$("textarea[name=content]").focus();
			return;
		}
		if(fc_chk_byte3(form.content, 500, '상담내용은') == false){
			$("textarea[name=content]").focus();
			return;
		}
		if (fc_chk_byte2(form.content, 4000, "상담내용은") == false) {
			return;
		}
		if (confirm('등록 하시겠습니까?')) {
			if (submitFlag){
				submitFlag = false;
				$('input[name=eventSdcit]').val("Answer"); // 분기

				global.ajaxSubmit($('#submitForm'), {
					type: 'POST'
					, url: '<c:url value="/tradeSOS/scene/sceneSuggestProc.do" />'
					, enctype: 'multipart/form-data'
					, dataType: 'json'
					, async: false
					, spinner: true
					, success: function (data) {
						location.reload();
					}
				});
			}
		}
	}

	//목록으로 가기
	function fn_list() {
		$("#searchForm").attr("action", "/tradeSOS/scene/sceneSuggestConsultantList.do");
		$("#searchForm").submit();
	}

</script>