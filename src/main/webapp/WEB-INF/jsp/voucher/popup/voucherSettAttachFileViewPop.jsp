<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="flex">
	<h2 class="popup_title">첨부파일(<c:out value="${fileType eq 'R' ? '결과물' : '증빙'}"/>)</h2>
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<div class="popup_body" style="width:500px!important;">
	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width: 20%" />
				<col/>
			</colgroup>
			<c:if test="${ totalCnt gt 0 }">
				<tr>
					<th>파일목록</th>
					<td>
						<c:forEach var="fileVO" items="${fileList}" varStatus="status">
							<div id="fileList_etc_<c:out value="${status.count}" />">
								<a href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')" class="attach_file">
								<img src="/images/icon/icon_file.gif" alt="첨부파일">
									<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>&nbsp;byte)
								</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</c:forEach>
						<c:if test="${ fn:length(fileList) == 0 }">
							&nbsp;
						</c:if>
					</td>
				</tr>
			</c:if>
			<c:if test="${ totalCnt eq 0 }">
				<tr>
					<td colspan="5" style="text-align: center;">조회된 데이터가 없습니다.</td>
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
