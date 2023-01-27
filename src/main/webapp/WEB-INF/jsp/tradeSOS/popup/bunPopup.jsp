<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!-- 팝업 타이틀 -->
<div class="flex">
	<h2 class="popup_title">번역 요약 내역</h2>
	<div class="ml-auto">
		<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
	</div>
</div>

<form id="popForm" name="popForm" action="post">
	<!-- 번역 요약 내역 팝업 -->
	<div id="searchPop" class="layerPopUpWrap">
		<div class="layerPopUp">
			<div class="layerWrap" style="width:700px;">
				<%--<h3 class="para_title no_bg">번역 요약 내역</h3>--%>
				<div class="box">
					<table class="boardwrite formTable">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">신청일</th>
								<td>${pRegstDt}</td>
								<th scope="row">컨설턴트</th>
								<td>${applyDetailVO.expertNm}</td>
							</tr>
							<tr>
								<th scope="row">언어</th>
								<td>${applyDetailVO.languageNm}</td>
								<th scope="row">번역구분</th>
								<td>${applyDetailVO.transGubunNm}</td>
							</tr>
							<tr>
								<th scope="row">번역물 종류</th>
								<td>${applyDetailVO.transTypeNm}</td>
								<th scope="row">원고 분량</th>
								<td>${applyDetailVO.transDocNum}장 (12Point , A4기준)</td>
							</tr>
							<tr>
								<th scope="row">품목군</th>
								<td>${applyDetailVO.itemTypeNm}</td>
								<th scope="row">이미지여부</th>
								<td>
									<c:if test="${applyDetailVO.imgYn == 'N'}">
										텍스트문서
									</c:if>
									<c:if test="${applyDetailVO.imgYn != 'N'}">
										텍스트 + 이미지파일 포함
									</c:if>
								</td>
							</tr>
							<c:if test="${applyDetailVO.file ne null}">
								<c:if test="${fn:length(applyDetailVO.file) > 0 }">
								<tr>
									<th scope="row">첨부파일</th>
									<td colspan="3">
										<div id="attachFieldList">
										<c:forEach var="result" items="${applyDetailVO.file}" varStatus="status">
											<div class="addedFile">
												<a href="javascript:directFileDown('<c:out value="${result.attachDocumPath}" />', '<c:out value="${result.attachDocumNm}" />', '<c:out value="${result.attachDocumNm}" />')" class="filename">
													<c:out value="${result.attachDocumNm}"/>
												</a>
											</div>
										</c:forEach>
										</div>
									</td>
								</tr>
								</c:if>
							</c:if>
							<c:if test="${applyMemberVO.ansFile ne null}">
								<c:if test="${fn:length(applyMemberVO.ansFile) > 0 }">
								<tr>
									<th scope="row">번역물</th>
									<td colspan="3">
										<div class="attachFieldList">
										<c:forEach var="result" items="${applyMemberVO.ansFile}" varStatus="status">
											<div class="addedFile">
												<a href="javascript:directFileDown('<c:out value="${result.attachDocumPath}" />', '<c:out value="${result.attachDocumNm}" />', '<c:out value="${result.attachDocumNm}" />')" class="filename">
													<c:out value="${result.attachDocumNm}"/>
												</a>
												<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/scene/tradeSOSFileDownload.do?attachDocumId=${result.attachDocumId}&attachSeqNo=${result.attachSeqNo}', '${result.attachDocumNm}', 'membershipexpert_${profile}_${result.attachDocumId}_${result.attachSeqNo}');" class="file_preview btn_tbl_border">
													<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
												</button>
											</div>
										</c:forEach>
										</div>
									</td>
								</tr>
								</c:if>
							</c:if>
							<tr>
								<th scope="row">번역분량</th>
								<td>${applyMemberVO.transResultNum}장 (12Point , A4기준)</td>
								<th scope="row">업체부담금</th>
								<td>${applyDetailVO.selfSupportMoney}</td>
							</tr>
							<tr>
								<th scope="row">바우처지원금</th>
								<td>${applyDetailVO.tradeSupportMoney}</td>
								<th scope="row">사용금액</th>
								<td>${applyDetailVO.selfSupportMoney + applyDetailVO.tradeSupportMoney}</td>
							</tr>
							<tr>
								<th scope="row">통지서발송</th>
								<td>
									<c:choose>
										<c:when test="${ applyDetailVO.mailCnt > 0}">
											발송 ( ${applyDetailVO.mailCnt}회)
										</c:when>
										<c:otherwise>
											미발송
										</c:otherwise>
									</c:choose>
								</td>
								<th scope="row">잠금설정여부</th>
								<td>
									<c:choose>
										<c:when test="${applyDetailVO.lockYn == 'Y'}">
											잠금중
										</c:when>
										<c:otherwise>
											잠금 해제중
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button type="button" class="btn_pop_close" onclick="closePopup();"></button>
			</div>
			<div class="layerFilter"></div>
		</div>
	</div>
</form>
<div class="overlay"></div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	//첨부파일 다운로드
	function directFileDown(filePath, saveName, fileName) {
		var f2 = document.popForm;

		f2.action = "/tradeSOS/com/fileDownload.do?filePath="+filePath+"&encSaveName="+saveName+"&encOrgName="+fileName;
		f2.target = "_self";
		f2.submit();
	}

	function closePopup() {
		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		// 콜백
		var returnObj = '공통 팝업1 ID : modalLayerPopup' + config.timestamp;
		config.callbackFunction(returnObj);

		// 레이어 닫기
		closeLayerPopup();
	}




</script>