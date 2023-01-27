<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="flex">
	<h2 class="popup_title">첨부파일</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body" style="width:650px!important;">
	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col width="20%">
			</colgroup>
			<c:if test="${ totCnt gt 0 }">
				<tr>
					<th>통장사본</th>
					<td>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${bankbookFileList}" varStatus="status">
								<div id="fileList_bankbook_<c:out value="${status.count}" />" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/>
										<c:choose>
											<c:when test="${fileVO.fileMg >= 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg / 1024}" type="number" maxFractionDigits="0"/>&nbsp;kb)
											</c:when>
											<c:when test="${fileVO.fileMg < 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg}" type="number" maxFractionDigits="0"/>&nbsp;byte)
											</c:when>
										</c:choose>
									</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
							<c:if test="${ fn:length(bankbookFileList) == 0 }">
								&nbsp;
							</c:if>
						</div>
					</td>

				</tr>
				<tr>
					<th>사업자등록증</th>
					<td>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${saupjaFileList}" varStatus="status">
								<div id="fileList_saupja_<c:out value="${status.count}" />" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/>
										<c:choose>
											<c:when test="${fileVO.fileMg >= 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg / 1024}" type="number" maxFractionDigits="0"/>&nbsp;kb)
											</c:when>
											<c:when test="${fileVO.fileMg < 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg}" type="number" maxFractionDigits="0"/>&nbsp;byte)
											</c:when>
										</c:choose>
									</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
							<c:if test="${ fn:length(saupjaFileList) == 0 }">
								&nbsp;
							</c:if>
						</div>
					</td>

				</tr>
				<tr>
					<th>추가서류</th>
					<td>
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${etcFileList}" varStatus="status">
								<div id="fileList_etc_<c:out value="${status.count}" />" class="addedFile">
									<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
										<c:out value="${fileVO.orignlFileNm}"/>
										<c:choose>
											<c:when test="${fileVO.fileMg >= 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg / 1024}" type="number" maxFractionDigits="0"/>&nbsp;kb)
											</c:when>
											<c:when test="${fileVO.fileMg < 1024}">
												(<fmt:formatNumber value="${fileVO.fileMg}" type="number" maxFractionDigits="0"/>&nbsp;byte)
											</c:when>
										</c:choose>
									</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
							<c:if test="${ fn:length(etcFileList) == 0 }">
								&nbsp;
							</c:if>
						</div>
					</td>
				</tr>
			</c:if>
			<c:if test="${ totCnt eq 0 }">
				<tr>
					<td style="text-align: center;">조회된 데이터가 없습니다.</td>
				</tr>
			</c:if>
		</table>
	</div>
</div>

<script type="text/javascript">

function doVoucherFileDown(atchFileId, fileSn) {	// 파일 다운로드
	window.open("/voucher/voucherFileDownload.do?atchFileId="+atchFileId+"&fileSn="+fileSn+"");
}

//레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
$('.modal').on('click', function(e){
	if (!$(e.target).is($('.modal-content, .modal-content *'))) {
		closeLayerPopup();
	}
});

</script>
