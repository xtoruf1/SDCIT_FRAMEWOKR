<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form id="inquiryPopupForm" name="inquiryPopupForm" method="post">
<input type="hidden" name="svrId" value="<c:out value="${param.svrId}" />" />
<input type="hidden" name="applySeq" value="<c:out value="${param.applySeq}" />" />
<div style="width: 900px;height: 750px;" class="fixed_pop_tit">
	<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">공적조서</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<c:if test="${fundForm.prvPriType eq '30'}">
			<div class="flex">
				<h3 style="margin-top: 20px;">특수유공 추천자 설정</h3>
			</div>
			<div class="mt-10">
				<table class="formTable">
					<colgroup>
						<col style="width: 12%;" />
						<col style="width: 12%;" />
						<col />
						<col style="width: 20%;" />
						<col />
					</colgroup>
					<tr>
						<th rowspan="2">추천</th>
						<th>추천기관</th>
						<td colspan="3"><c:out value="${fundForm.spRecOrg}" /></td>
					</tr>
					<tr>
						<th>추천부문</th>
						<td colspan="3"><c:out value="${fundForm.spRecKind}" /></td>
					</tr>
					<tr>
						<th rowspan="2">추천담당자</th>
						<th>성명</th>
						<td><c:out value="${fundForm.spRecName}" /></td>
						<th>전화번호</th>
						<td class="phoneNum"><c:out value="${fundForm.spRecTel}" /></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td><c:out value="${fundForm.spRecEmail}" /></td>
						<th>핸드폰번호</th>
						<td class="phoneNum"><c:out value="${fundForm.spRecHp}" /></td>
					</tr>
				</table>
			</div>
		</c:if>
		<c:if test="${fundForm.prvPriType eq '30'}">
			<div class="flex">
				<h3 style="margin-top: 20px;">공적조서</h3>
			</div>
		</c:if>
		<div <c:if test="${fundForm.prvPriType eq '30'}">class="mt-10"</c:if>>
			<table class="formTable">
				<colgroup>
					<col style="width: 12%;" />
					<col style="width: 12%;" />
					<col />
					<col style="width: 20%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="5">
						<c:choose>
							<c:when test="${fundForm.prvPriType eq '10'}">수출의탑(대표자)</c:when>
							<c:when test="${fundForm.prvPriType eq '21'}">대표자</c:when>
							<c:when test="${fundForm.prvPriType eq '22'}">종업원(사무직)</c:when>
							<c:when test="${fundForm.prvPriType eq '23'}">종업원(생산직)</c:when>
							<c:when test="${fundForm.prvPriType eq '30'}">특수유공자</c:when>
						</c:choose>
					</th>
				</tr>
				<tr>
					<th colspan="2">내외구분</th>
					<td><c:out value="${fundForm.fromYn}" /></td>
					<th>국적</th>
					<td><c:out value="${fundForm.bonjuk}" /></td>
				</tr>
				<tr>
					<th rowspan="4">성명</th>
					<th rowspan="2">한글</th>
					<td rowspan="2"><c:out value="${fundForm.userNmKor}" /></td>
					<th>주민등록번호</th>
					<td><c:out value="${fundForm.juminNo}" /></td>
				</tr>
				<tr>
					<th>여권번호</th>
					<td><c:out value="${fundForm.passportNo}" /></td>
				</tr>
				<tr>
					<th>영문</th>
					<td><c:out value="${fundForm.userNmEn}" /></td>
					<th>생년월일</th>
					<td><c:out value="${birthday1}" />년 <c:out value="${birthday2}" />월 <c:out value="${birthday3}" />일 <c:out value="${fundForm.age}" />세</td>
				</tr>
				<tr>
					<th>한자</th>
					<td><c:out value="${common:reverseXss(fundForm.userNmCh)}" escapeXml="false" /></td>
					<th>성별</th>
					<td><c:out value="${fundForm.sex}" /></td>
				</tr>
				<tr>
					<th rowspan="2" colspan="2">현주소</th>
					<td colspan="3">
						<c:out value="${fundForm.zipCd1}" />-<c:out value="${fundForm.zipCd2}" />
						<c:out value="${fundForm.addr1}" />
					</td>
				</tr>
				<tr>
					<td colspan="3"><c:out value="${fundForm.addr2}" /></td>
				</tr>
				<tr>
					<th colspan="2">휴대전화번호</th>
					<td class="phoneNum"><c:out value="${mobile}" /></td>
					<th>E-Mail</th>
					<td><c:out value="${fundForm.email}" /></td>
				</tr>
				<tr>
					<th colspan="2">호주 성명</th>
					<td>
						<c:out value="${fundForm.hojuNm}" />
						<c:if test="${not empty fundForm.hojuRl}">
							(호주와의 관계 : <c:out value="${fundForm.hojuRl}" />)
						</c:if>
					</td>
					<th>임원여부</th>
					<td><c:out value="${fundForm.imwonYn}" /></td>
				</tr>
				<tr>
					<th colspan="2">직업</th>
					<td><c:out value="${fundForm.job}" /></td>
					<th>소속(한글)</th>
					<td><c:out value="${fundForm.deptPos}" /></td>
				</tr>
				<tr>
					<th colspan="2">직위</th>
					<td><c:out value="${fundForm.pos}" /></td>
					<th>등급(직급, 계급)</th>
					<td><c:out value="${fundForm.rank}" /></td>
				</tr>
				<tr>
					<th colspan="2">입사일자(현 재직사)</th>
					<td><c:out value="${fundForm.enterYmd}" /></td>
					<th>소속사업장</th>
					<td><c:out value="${fundForm.deptPosPlace}" /></td>
				</tr>
				<tr>
					<th colspan="2">근무기간(수공기간)</th>
					<td>
						<c:out value="${fundForm.curwrkTermYy}" /> 년
						<c:out value="${fundForm.curwrkTermMm}" /> 개월
					</td>
					<th>총근무기간(수공기간)</th>
					<td>
						<c:out value="${fundForm.wrkTermYy}" /> 년
						<c:out value="${fundForm.wrkTermMm}" /> 개월
					</td>
				</tr>
				<tr>
					<th colspan="2">공적요지(50자 내외)</th>
					<td colspan="3"><c:out value="${fundForm.kongjukSum}" /></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">국가연구개발사업 참여제재 여부(해당사항 있는 경우 반드시 기재)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>제재사유</td>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList4) > 0}">
						<c:forEach var="item" items="${awd0021tList4}" varStatus="status">
							<tr>
								<td align="center"><c:out value="${item.historyDt}" /> ~ <c:out value="${item.historyToDt}" /></td>
								<td><c:out value="${item.history}" escapeXml="false" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="2" align="center">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">주요경력(학력)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</td>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList1) > 0}">
						<c:forEach var="item" items="${awd0021tList1}" varStatus="status">
							<tr>
								<td align="center"><c:out value="${item.historyDt}" /> ~ <c:out value="${item.historyToDt}" /></td>
								<td><c:out value="${item.history}" escapeXml="false" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="2" align="center">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">주요경력(경력)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</td>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList2) > 0}">
						<c:forEach var="item" items="${awd0021tList2}" varStatus="status">
							<tr>
								<td align="center"><c:out value="${item.historyDt}" /> ~ <c:out value="${item.historyToDt}" /></td>
								<td><c:out value="${item.history}" escapeXml="false" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="2" align="center">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<tr>
					<th colspan="2">과거 포상기록(훈장, 포상, 표창별로 기록)</th>
				</tr>
				<tr>
					<th>년 월 일</th>
					<th>내 용</td>
				</tr>
				<c:choose>
					<c:when test="${fn:length(awd0021tList3) > 0}">
						<c:forEach var="item" items="${awd0021tList3}" varStatus="status">
							<tr>
								<td align="center"><c:out value="${item.historyDt}" /></td>
								<td><c:out value="${item.history}" escapeXml="false" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="2" align="center">데이터가 존재하지 않습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 40%;" />
					<col />
				</colgroup>
				<tr>
					<th>최근 5년이내 1년 이상의 해외근무경력</th>
					<td><c:out value="${fundForm.fognWorkYn}" /></td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col />
				</colgroup>
				<tr>
					<td>
						<c:choose>
							<c:when test="${fundForm.prvPriType eq '10' or fundForm.prvPriType eq '21'}">
								1) 기본사항<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk1Item1)}" escapeXml="false" />
								<br /><br />
								2) 수출실적<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk1Item2)}" escapeXml="false" />
								<br /><br />
								3) 기술개발 및 품질향상 노력<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk1Item3)}" escapeXml="false" />
								<br /><br />
								4) 해외시장 개척활동<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk1Item4)}" escapeXml="false" />
								<br /><br />
								5) 기타 공적내용<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk1Etc)}" escapeXml="false" />
							</c:when>
							<c:otherwise>
								1) 기본사항<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk2Item1)}" escapeXml="false" />
								<br /><br />
								2) 기여도<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk2Item2)}" escapeXml="false" />
								<br /><br />
								3) 수상등 공적내용<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk2Item3)}" escapeXml="false" />
								<br /><br />
								5) 기타 공적내용<br /><br />
								<c:out value="${common:reverseXss(fundForm.kongjuk2Etc)}" escapeXml="false" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col />
				</colgroup>
				<tr>
					<td>별지 제 3-1호 서식</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col />
				</colgroup>
				<tr>
					<td>
						1) 수공기간(근무기간)<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj1)}" escapeXml="false" />
						<br /><br />
						2) 국가발전 기여도<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj2)}" escapeXml="false" />
						<br /><br />
						3) 국민생활 향상도<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj3)}" escapeXml="false" />
						<br /><br />
						4) 창조적 기여도<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj4)}" escapeXml="false" />
						<br /><br />
						5) 무역진흥 기여도<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj5)}" escapeXml="false" />
						<br /><br />
						6) 사회공헌 및 기타기여도<br /><br />
						<c:out value="${common:reverseXss(fundForm.sanghunKj6)}" escapeXml="false" />
					</td>
				</tr>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<c:set var="picAttachCnt" value="${fn:length(picAttachList)}" />
				<tr>
					<th rowspan="${picAttachCnt + 1}">이력서 사진</th>
					<c:choose>
						<c:when test="${picAttachCnt eq 0}">
							<td>&nbsp;</td>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${picAttachList}" varStatus="status">
								<c:if test="${status.index eq 0}">
									<td>
										<div class="addedFile">
											<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
										</div>
									</td>
								</c:if>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tr>
				<c:if test="${picAttachCnt > 0}">
					<c:forEach var="item" items="${picAttachList}" varStatus="status">
						<c:if test="${status.index ne 0}">
							<tr>
								<td>
									<div class="addedFile">
										<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
									</div>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</c:if>
			</table>
		</div>
		<div class="mt-10">
			<table class="formTable">
				<colgroup>
					<col style="width: 24%;" />
					<col />
				</colgroup>
				<c:set var="fileAttachCnt" value="${fn:length(fileAttachList)}" />
				<tr>
					<th rowspan="${fileAttachCnt + 1}">공적내용 추가파일</th>
					<c:choose>
						<c:when test="${fileAttachCnt eq 0}">
							<td>&nbsp;</td>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${fileAttachList}" varStatus="status">
								<c:if test="${status.index eq 0}">
									<td>
										<div class="addedFile">
											<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
										</div>
									</td>
								</c:if>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tr>
				<c:if test="${fileAttachCnt > 0}">
					<c:forEach var="item" items="${fileAttachList}" varStatus="status">
						<c:if test="${status.index ne 0}">
							<tr>
								<td>
									<div class="addedFile">
										<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileId}" />', '<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
									</div>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</c:if>
			</table>
		</div>
		<div class="mt-10">&nbsp;</div>
	</div>
</div>
</form>
<form id="inquiryPopupDownloadForm" name="inquiryPopupDownloadForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="fileId" value="" />
<input type="hidden" name="fileNo" value="" />
</form>
<script type="text/javascript">
	$(document).ready(function(){
		var f = document.viewPopupForm;

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#inquiryPopupForm .phoneNum'], 'R');

		// 로딩이미지 종료
		$('#loading_image').hide();
	});

	// 첨부파일 다운로드
	function doDownloadFile(fileId, fileNo) {
		var f = document.inquiryPopupDownloadForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = fileId;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});
</script>