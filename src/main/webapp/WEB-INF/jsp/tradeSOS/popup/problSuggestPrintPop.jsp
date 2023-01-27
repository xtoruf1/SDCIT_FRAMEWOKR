<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="/smartEditor/js/HuskyEZCreator.js" charset="utf-8" ></script>

<% pageContext.setAttribute("newLineChar", "\n"); %>
<script type="text/javascript">


</script>

<!-- 무역애로건의 - 무역애로 건의 현황 출력 -->
<div class="flex">
	<h2 class="popup_title">애로건의 신청 정보</h2>
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
	<form name="adminForm1" id="adminForm1" action ="" method="post">
		<input type="hidden" id="sosSeq1" name="sosSeq" value="<c:out value="${resultData.sosSeq}"/>"/>
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
						<th scope="row">회사명 <strong class="point">*</strong></th>
						<td>
								<c:out value="${resultData.compnyNm}"/>
						</td>
						<th scope="row">무역업고유번호 <strong class="point">*</strong></th>
						<td>
								<c:out value="${resultData.tradeNum}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">대표자 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.presidentKor}"/>
						</td>
						<th scope="row">사업자등록번호 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.regNo}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">대표전화</th>
						<td>
							<div class="flex align_center">
								<c:out value="${resultData.compPhone}"/>
							</div>
						</td>
						<th scope="row">FAX</th>
						<td>
							<c:out value="${resultData.compFax}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">지역 <strong class="point">*</strong></th>
						<td>
							<c:forEach var="data" items="${code120}" varStatus="status">
								<c:out value='${resultData.reqArea eq data.cdId ? data.cdNm : ""}'/>
							</c:forEach>
						</td>
						<th scope="row">취급품목 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.bizItems}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">회사주소 <strong class="point">*</strong></th>
						<td colspan="3">
							<c:out value="${resultData.compAddr}"/>
						</td>
					</tr>
					<tr>
						<th scope="row" rowspan="4">업체담당자</th>
						<th scope="row">이름 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.reqName}"/>
						</td>
						<th scope="row">직위 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.reqPostion}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">부서 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.reqDept}"/>
						</td>
						<th scope="row">휴대폰 <strong class="point">*</strong></th>
						<td>
							<c:out value="${resultData.reqHp}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td>
							<c:out value="${resultData.reqPhone}"/>
						</td>
						</td>
						<th scope="row">FAX</th>
						<td>
							<c:out value="${resultData.reqFax}"/>
						</td>
					</tr>
					<tr>
						<th scope="row">이메일 <strong class="point">*</strong></th>
						<td colspan="3">
							<c:out value="${resultData.reqEmail}"/>
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
						<td><c:out value="${resultData.reqRgfHight}"/></td>
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
				</tbody>
			</table><!-- // 애로건의 현황 상세 테이블-->
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">접수정보</h3>
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
			</table>
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">검토결과</h3>
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
						<th scope="row" rowspan="2">관련<br>법률</th>
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
				</tbody>
			</table><!-- // 애로건의 현황 검토결과 테이블-->
		</div>
		<div class="cont_block">
			<div class="tit_bar">
				<h3 class="tit_block">처리이력</h3>
			</div>
			<div id='processingHistorySheetPrint' class="colPosi"></div>
		</div>
	</form>
</div>


<script type="text/javascript">
	$(document).ready(function()
	{									//IBSheet 호출
		f_Init_processingHistorySheetPrint();		// 리스트  Sheet 셋팅
		getList1();						// 목록 조회
	});

	function f_Init_processingHistorySheetPrint()								//처리이력 목록
	{
		// 세팅
		var	ibHeader	=	new	IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'init',  SearchMode: 0, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true});

		ibHeader.addHeader({Type: "Text", Header: "일시"			, SaveName: "indate"		, Align: "Center"	, Width: 150});
		ibHeader.addHeader({Type: "Text", Header: "상태"			, SaveName: "statusCdNm"	, Align: "Center"	, Width: 100	, Ellipsis:1});
		ibHeader.addHeader({Type: "Text", Header: "이력내용"		, SaveName: "hisText"		, Align: "Left"		, Width: 300	, ToolTip: true});
		ibHeader.addHeader({Type: "Text", Header: "소관부처/기관"	, SaveName: "conOrganm"		, Align: "Left"		, Width: 200});
		ibHeader.addHeader({Type: "Text", Header: "담당자"		, SaveName: "conName"		, Align: "Center"	, Width: 100});

		var sheetId = "processingHistorySheetPrint";
		var container = $("#"+sheetId)[0];

		if (typeof processingHistorySheetPrint !== 'undefined' && typeof processingHistorySheetPrint.Index !== 'undefined') {
			processingHistorySheetPrint.DisposeSheet();
		}

		createIBSheet2(container,sheetId, "100%", "100%");
		ibHeader.initSheet(sheetId);
	};

	function doSearch1() {
		getList1();
	}

	function getList1() {
		//global.ajax 사용하면 HideProcessDlg 적용 안됨
		$.ajax({
			url: '/tradeSOS/problem/processResultListAjax.do',
			dataType: 'json',
			type: 'POST',
			data: $('#adminForm1').serialize(),
			success: function (data) {
				processingHistorySheetPrint.LoadSearchData({Data: data.resultList}, {Sync:1});
				doPrint1();
			},
			error:function(request,status,error) {
				alert('처리이력 조회에 실패했습니다.');
			}
		});
	}

	// function processingHistorySheetPrint_OnSearchEnd() {
	// 	setTimeout(function () {
	// 		doPrint1();
	// 	}, 2000);
	// }


	function doPrint1(){

		var initBody;

		window.onbeforeprint = function(){
			initBody = document.body.innerHTML;
			$('.hiddenPrint').hide();
		};
		window.onafterprint = function(){
			document.body.innerHTML = initBody;
		};
		window.print();
	}

// 	function doClose(){
// 		window.close();
// // 		closeLayerPopup();
// 	}

</script>