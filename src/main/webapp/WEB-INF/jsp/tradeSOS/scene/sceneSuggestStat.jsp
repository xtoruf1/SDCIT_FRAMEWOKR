<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- TradeSOS > 무역현장 컨설팅 통계 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" id="saveBtn" class="btn_sm btn_primary btn_modify_auth" title="저장" onclick="fnRatingSave();">저장</button>
	</div>
	<div class="ml-15">
	   	<button type="button" class="btn_sm btn_primary" title="엑셀" onclick="getTabExcel();">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" title="초기화" onclick="fnResetTab();">초기화</button>
		<button type="button" class="btn_sm btn_primary" title="조회" onclick="fnSearch();">검색</button>
	</div>
</div>
<div class="cont_block">
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab on"  value="evaluation" onclick="fn_buttonChk('evaluation');">자문위원 평가관리</button>
			<button class="tab"     value="satisfaction" onclick="fn_buttonChk('satisfaction');">만족도</button>
			<button class="tab"     value="company" onclick="fn_buttonChk('company');">업체별</button>
			<button class="tab"     value="memberCommittee" onclick="fn_buttonChk('memberCommittee');">위원별</button>
			<button class="tab"     value="consultingField" onclick="fn_buttonChk('consultingField');">컨설팅분야별</button>
			<button class="tab"     value="area" onclick="fn_buttonChk('area');">지역별</button>
			<button class="tab"     value="reporting" onclick="fn_buttonChk('reporting');">보고용통계</button>
		</div>

		<div class="tab_body">
			<div class="tab_cont on">
				<!-- 타이틀 영역 -->
				<div class="tit_bar">
				</div>
				<form id="memberRatingFrm" name="memberRatingFrm" onsubmit="return false">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:15%">
							<col>
							<col style="width:15%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록일</th>
								<td>
									<div class="form_row w100p">
										<select id="startYear" name="startYear" class="form_select">
											<c:forEach var="i" begin="2010" end="${year}" step="1">
												<option value="${year - i + 2010}" <c:if test="${year - i + 2010 == year}">selected</c:if>>
														${year - i + 2010}
												</option>
											</c:forEach>
										</select>
										<span class="spacing">~</span>
										<select id="endYear" name="endYear" class="form_select">
											<c:forEach var="i" begin="2010" end="${year}" step="1">
												<option value="${year - i + 2010}" <c:if test="${year - i + 2010 == year}">selected</c:if>>
														${year - i + 2010}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>
								<th scope="row">위원명</th>
								<td>
									<input type="text" name="expertNm" onkeydown="onEnter(fnSearch);" class="form_text w100p">
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<form id="adviceMemberRatingFrm" name="adviceMemberRatingFrm">
					<div id='tblGridSheet' class="colPosi mt-20"></div>
				</form>
			</div> <!-- // 자문위원 평가관리 통계 종료 -->

			<%-- 만족도 통계 시작--%>
			<div class="tab_cont">
				<form id="surveyFrm" name="surveyFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록일</th>
								<td>
									<div class="group_datepicker">
										<!-- datepicker -->
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="startDate2" name="recDateFrom" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyStartDate2" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('startDate2');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="endDate2" name="recDateTo" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyEndDate2" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('endDate2');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div class="tbl_opt mt-20">
					<div class="total_count" id="totalAvg"></div>
				</div>
				<div id='tblGridSheet2' class="colPosi"></div>

			</div> <!-- // 만족도 통계 종료-->

			<%--업체별 통계 시작--%>
			<div class="tab_cont">
				<form id="companyFrm" name="companyFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록일</th>
								<td>
									<div class="group_datepicker">
										<!-- datepicker -->
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="startDate3" name="recDateFrom" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyStartDate3" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('startDate3');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="endDate3" name="recDateTo" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyEndDate3" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('endDate3');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</td>
								<th scope="row">항목구분</th>
								<td>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio3_1" class="form_radio" value="001" checked>
										<span for="radio3_1" class="label">업체</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio3_2" class="form_radio" value="002">
										<span for="radio3_2" class="label">업체 - 상담채널</span>
									</label>
								</td>
							</tr>
							<tr>
								<th scope="row">업체명</th>
								<td>
									<input type="text" name="companyNm" onkeydown="onEnter(fnSearch);" class="form_text w100p">
								</td>
								<th scope="row">사업자번호</th>
								<td>
									<input type="text" name="companyNo" onkeydown="onEnter(fnSearch);" class="form_text w100p">
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div id='tblGridSheet3' class="colPosi mt-20"></div>
			</div> <%-- 업체별 통계 종료 --%>

			<%-- 위원별 통계 시작 --%>
			<div class="tab_cont">
				<form id="memberFrm" name="memberFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
							<tr>
<!-- 								<th scope="row">연도</th> -->
<!-- 								<td> -->
<!-- 									<div class="form_row w50p"> -->
<!-- 										<select id="endYear2" name="recDateTo" class="form_select"> -->
<%-- 											<c:forEach var="i" begin="2010" end="${year}" step="1"> --%>
<%-- 												<option value="${year - i + 2010}" <c:if test="${year - i + 2010 == year}">selected</c:if>> --%>
<%-- 														${year - i + 2010} --%>
<!-- 												</option> -->
<%-- 											</c:forEach> --%>
<!-- 										</select> -->
<!-- 									</div> -->
<!-- 								</td> -->
								<th scope="row">등록일</th>
								<td>
									<div class="group_datepicker">
										<!-- datepicker -->
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="startDate4" name="recDateFrom" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyStartDate4" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('startDate4');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="endDate4" name="recDateTo" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyEndDate4" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('endDate4');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</td>
								<th scope="row">위원명</th>
								<td>
									<input type="text" name="expertNm" onkeydown="onEnter(fnSearch);" class="form_text w100p">
								</td>
							</tr>
								<th scope="row">항목구분</th>
								<td colspan="3">
									<label class="label_form">
										<input type="radio" name="gubun" id="radio4_1" class="form_radio" value="001" checked>
										<span for="radio3_1" class="label">위원별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio4_2" class="form_radio" value="002">
										<span for="radio4_2" class="label">위원별 - 상담채널별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio4_3" class="form_radio" value="003">
										<span for="radio4_3" class="label">위원별 - 업체별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio4_4" class="form_radio" value="004">
										<span for="radio4_4" class="label">위원별 - 신규/기존별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio4_5" class="form_radio" value="005">
										<span for="radio4_5" class="label">위원별 - 신규/기존별 - 상담채널</span>
									</label>
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>
				<!-- 리스트 테이블 -->
				<div id='tblGridSheet4' class="colPosi mt-20"></div>
			</div> <%-- 위원별 통계 종료 --%>

			<%--컨설팅분야별 통계 시작--%>
			<div class="tab_cont">
				<form id="consultingFrm" name="consultingFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록일</th>
								<td>
									<div class="group_datepicker">
										<!-- datepicker -->
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="startDate5" name="recDateFrom" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyStartDate5" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('startDate5');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="endDate5" name="recDateTo" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyEndDate5" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('endDate5');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</td>
								<th scope="row">항목구분</th>
								<td>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio5_1" class="form_radio" value="001" checked>
										<span for="radio5_1" class="label">컨설팅분야별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio5_2" class="form_radio" value="002">
										<span for="radio5_2" class="label">컨설팅분야별 - 상담채널별</span>
									</label>
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>

				<!-- 리스트 테이블 -->
				<div id='tblGridSheet5' class="colPosi mt-20"></div>
			</div> <%--컨설팅분야별 종료--%>

			<%--지역별 통계 시작 --%>
			<div class="tab_cont">
				<div class="btn_group align_r">
				</div>
				<form id="areaFrm" name="areaFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">등록일</th>
								<td>
									<div class="group_datepicker">
										<!-- datepicker -->
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="startDate6" name="recDateFrom" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyStartDate6" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('startDate6');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
										<div class="spacing">~</div>
										<div class="datepicker_box">
											<span class="form_datepicker">
												<input type="text" id="endDate6" name="recDateTo" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
												<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
												<input type="hidden" id="dummyEndDate6" value="" />
											</span>
										</div>
										<!-- clear 버튼 -->
										<button type="button" class="ml-8" onclick="clearDate('endDate6');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									</div>
								</td>
								<th scope="row">항목구분</th>
								<td>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio6_1" class="form_radio" value="001" checked>
										<span for="radio6_1" class="label">지역별</span>
									</label>
									<label class="label_form">
										<input type="radio" name="gubun" id="radio6_2" class="form_radio" value="002">
										<span for="radio6_2" class="label">지역별 - 상담채널별</span>
									</label>
								</td>
							</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>

				<!-- 리스트 테이블 -->
				<div id='tblGridSheet6' class="colPosi mt-20"></div>
			</div>

			<%-- 보고용 통계 시작--%>
			<div class="tab_cont">
				<form id="reportFrm" name="reportFrm">
					<input type="reset" style="display: none;"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">등록일</th>
							<td>
								<div class="group_datepicker">
									<!-- datepicker -->
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="startDate7" name="frDt" value="${frDt}" class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											<input type="hidden" id="dummyStartDate7" value="" />
										</span>
									</div>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="clearDate('startDate7');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
									<div class="spacing">~</div>
									<div class="datepicker_box">
										<span class="form_datepicker">
											<input type="text" id="endDate7" name="toDt" value="${toDt}" class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
											<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
											<input type="hidden" id="dummyEndDate7" value="" />
										</span>
									</div>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="clearDate('endDate7');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</td>
						</tr>
						</tbody>
					</table><!-- // 검색 테이블-->
				</form>

				<div id="reportHtml" class="mt-20">
					<div class="cont_block">
						<div class="tit_bar">
							<h4 class="tit_block">총괄</h4>
						</div>
						<table class="formTable">
							<colgroup>
								<col style="width:25%" />
								<col style="width:25%" />
								<col />
							</colgroup>
							<thead>
							<tr>
								<th scope="col" rowspan="2">구분</th>
								<th scope="col" rowspan="2">상담 업체수</th>
								<th scope="col" colspan="3">상담건수</th>
							</tr>
							<tr>
								<th scope="col">현장방문</th>
								<th scope="col">전화 및 온라인</th>
								<th scope="col">소계</th>
							</tr>
							</thead>
							<tbody>
								<tr>
									<td class="align_ctr">
										지난주
									</td>
									<td id="totalLastWeekCnt" class="align_ctr">
										0
									</td>
									<td id="totalLastWeek010Cnt" class="align_ctr">
										0
									</td>
									<td id="totalLastWeek020Cnt" class="align_ctr">
										0
									</td>
									<td id="totalLastWeekCnt2" class="align_ctr">
										0
									</td>
								</tr>
								<tr>
									<td id="lastMonthText" class="align_ctr">

									</td>
									<td id="lastMonthCnt" class="align_ctr">
										0
									</td>
									<td id="lastMonthCnt1" class="align_ctr">
										0
									</td>
									<td id="lastMonthCnt2" class="align_ctr">
										0
									</td>
									<td id="lastMonthTotalCnt" class="align_ctr">
										0
									</td>
								</tr>
								<tr>
									<td id="sumTotalText" class="align_ctr">

									</td>
									<td id="sumCnt" class="align_ctr">
										0
									</td>
									<td id="sumCnt1" class="align_ctr">
										0
									</td>
									<td id="sumCnt2" class="align_ctr">
										0
									</td>
									<td id="sumTotalCnt" class="align_ctr">
										0
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h4 class="tit_block">지역별 현황</h4>
						</div>
						<table class="formTable align_ctr">
							<colgroup>
								<col  />
								<c:forEach items="${code034}" var="data" varStatus="status">
									<col style="width:4.9%"/>
								</c:forEach>
								<col style="width:4.5%"/>
							</colgroup>
							<thead>
							<tr>
								<th scope="col">구분</th>
								<c:forEach items="${code034}" var="data" varStatus="status">
									<th scope="col" class="break-word">${data.cdNm}</th>
								</c:forEach>
								<th scope="col">소계</th>
							</tr>

							</thead>
							<tbody id="areaBody">

							</tbody>
						</table>
					</div>

					<div class="cont_block">
						<div class="tit_bar">
							<h4 class="tit_block">상담 분야별 현황</h4>
						</div>
						<table class="formTable align_ctr">
							<colgroup>
								<col  />
								<col style="width:16%"/>
								<col style="width:16%"/>
								<col style="width:16%"/>
								<col style="width:16%"/>
								<col style="width:16%"/>

							</colgroup>
							<thead>
							<tr>
								<th scope="col">분야</th>
								<th scope="col">건수</th>
								<th scope="col">분야</th>
								<th scope="col">건수</th>
								<th scope="col">분야</th>
								<th scope="col">건수</th>
							</tr>

							</thead>
							<tbody id="channelBody">

							</tbody>
						</table>
					</div>
				</div>

				<form id="reportDataFrm" name="reportDataFrm" method="post">
					<input type="hidden" name="reportData" id="reportData"/>
					<input type="hidden" name="excelFileName" id="excelFileName" value=""/>
				</form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function () {

		setMemberRatingGrid();  //자문위원평가관리 Sheet

		setSurveyGrid();        //만족도 Sheet

		setCompanyGrid();       //업체별 Sheet

		setMemberGrid();        //위원별 Sheet

		setConsultingGrid();    // 컨설팅분야별 Sheet

		setAreaGrid();          // 지역별 Sheet

		getReportList();       // 보고용통계

		// 시작일 선택 이벤트
		datepickerById('startDate2', fromDateSelectEvent2);
		// 종료일 선택 이벤트
		datepickerById('endDate2', toDateSelectEvent2);
		// 시작일 선택 이벤트
		datepickerById('startDate3', fromDateSelectEvent3);
		// 종료일 선택 이벤트
		datepickerById('endDate3', toDateSelectEvent3);
		// 시작일 선택 이벤트
		datepickerById('startDate5', fromDateSelectEvent5);
		// 종료일 선택 이벤트
		datepickerById('endDate5', toDateSelectEvent5);
		// 시작일 선택 이벤트
		datepickerById('startDate6', fromDateSelectEvent6);
		// 종료일 선택 이벤트
		datepickerById('endDate6', toDateSelectEvent6);
		// 시작일 선택 이벤트
		datepickerById('startDate7', fromDateSelectEvent7);
		// 종료일 선택 이벤트
		datepickerById('endDate7', toDateSelectEvent7);


	});
	function fromDateSelectEvent2() {
		var startymd = Date.parse($('#startDate2').val());

		if ($('#endDate2').val() != '') {
			if (startymd > Date.parse($('#endDate2').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDate2').val('');

				return;
			}
		}
	}

	function toDateSelectEvent2() {
		var endymd = Date.parse($('#endDate2').val());

		if ($('#startDate2').val() != '') {
			if (endymd < Date.parse($('#startDate2').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDate2').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent3() {
		var startymd = Date.parse($('#startDate3').val());

		if ($('#endDate3').val() != '') {
			if (startymd > Date.parse($('#endDate3').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDate3').val('');

				return;
			}
		}
	}

	function toDateSelectEvent3() {
		var endymd = Date.parse($('#endDate3').val());

		if ($('#startDate3').val() != '') {
			if (endymd < Date.parse($('#startDate3').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDate3').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent5() {
		var startymd = Date.parse($('#startDate5').val());

		if ($('#endDate5').val() != '') {
			if (startymd > Date.parse($('#endDate5').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDate5').val('');

				return;
			}
		}
	}

	function toDateSelectEvent5() {
		var endymd = Date.parse($('#endDate5').val());

		if ($('#startDate5').val() != '') {
			if (endymd < Date.parse($('#startDate5').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDate5').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent6() {
		var startymd = Date.parse($('#startDate6').val());

		if ($('#endDate6').val() != '') {
			if (startymd > Date.parse($('#endDate6').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDate6').val('');

				return;
			}
		}
	}

	function toDateSelectEvent6() {
		var endymd = Date.parse($('#endDate6').val());

		if ($('#startDate6').val() != '') {
			if (endymd < Date.parse($('#startDate6').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDate6').val('');

				return;
			}
		}
	}

	function fromDateSelectEvent7() {
		var startymd = Date.parse($('#startDate7').val());

		if ($('#endDate7').val() != '') {
			if (startymd > Date.parse($('#endDate7').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#startDate7').val('');

				return;
			}
		}
	}

	function toDateSelectEvent7() {
		var endymd = Date.parse($('#endDate7').val());

		if ($('#startDate7').val() != '') {
			if (endymd < Date.parse($('#startDate7').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#endDate7').val('');

				return;
			}
		}
	}

	function fnSearch() {
		var gubun = $('[class*="tab on"]').val();   //선택한 탭의 값

		if (gubun == 'evaluation'){
			getMemberRating();
		}else if (gubun == 'satisfaction'){
			getSurveyList();
		}else if (gubun == 'company'){
			getCompanyList();
		}else if (gubun == 'memberCommittee'){
			getMemberList();
		}else if (gubun == 'consultingField'){
			getConsultingList();
		}else if (gubun == 'area'){
			getAreaList();
		}else if (gubun == 'reporting'){
			getReportList();
		}
	}

	function fnResetTab() {
		var gubun = $('[class*="tab on"]').val();   //선택한 탭의 값

		if (gubun == 'evaluation'){
			$("#memberRatingFrm > input[type=reset]").click();
			getMemberRating();
		}else if (gubun == 'satisfaction'){
			$("#surveyFrm > input[type=reset]").click();
			getSurveyList();
		}else if (gubun == 'company'){
			$("#companyFrm > input[type=reset]").click();
			getCompanyList();
		}else if (gubun == 'memberCommittee'){
			$("#memberFrm > input[type=reset]").click();
			getMemberList();
		}else if (gubun == 'consultingField'){
			$("#consultingFrm > input[type=reset]").click();
			getConsultingList();
		}else if (gubun == 'area'){
			$("#areaFrm > input[type=reset]").click();
			getAreaList();
		}else if (gubun == 'reporting'){
			$("#reportFrm > input[type=reset]").click();
			getReportList();
		}
	}

	//자문위원 평가관리 sheet 생성
	function setMemberRatingGrid() {
		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Status",     Header: "상태",     SaveName:"status",      Hidden: true });
		ibHeader.addHeader({Type: "Text", 		Header: "expertid", 	SaveName: "expertId", 	Align: "Center",    Width: 150, 	Edit: false, Hidden:true });
		ibHeader.addHeader({Type: "Text", 		Header: "bungi", 	    SaveName: "bungi",    	Align: "Center",    Width: 150, 	Edit: false, Hidden:true });
		ibHeader.addHeader({Type: "Text", 		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center",    Width: 80, 	Edit: false, editable: false });
		ibHeader.addHeader({Type: "Text",		Header: "연도", 		    SaveName: "year", 	    Align: "Center", 	Width: 40, 	Edit: false, editable: false });
		ibHeader.addHeader({Type: "Text",		Header: "반기", 		    SaveName: "bungiNm", 	Align: "Center",    Width: 40, 	Edit: false, editable: false });
		ibHeader.addHeader({Type: "Text",		Header: "자문건수", 	    SaveName: "cnt", 	    Align: "Right",		Width: 150, 	Edit: false, editable: false });
		ibHeader.addHeader({Type: "CheckBox", 	Header: "평가", 	        SaveName: "rating", 	Align: "Center",	Width: 50,		editable: true, ItemText:"상|중|하", ItemCode:"001|002|003", Edit: true, "MaxCheck": 1, "RadioIcon": 1});

		if (typeof tblGridSheet !== "undefined" && typeof tblGridSheet.Index !== "undefined") {
			tblGridSheet.DisposeSheet();
		}

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "590px");
		ibHeader.initSheet(sheetId);

		getMemberRatingList(); //조회

	};

	function tblGridSheet_OnRowSearchEnd(row) {
	   // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
	   notEditableCellColor('tblGridSheet', row);
	}

	// 자문위원 평가관리 조회
	function getMemberRatingList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatAdviceMemberListAjax.do" />'
			, data : $('#memberRatingFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 자문위원 평가 관리 조회
	function getMemberRating(){
		setMemberRatingGrid();
	}

	// 자문위원 평가 저장
	function fnRatingSave() {
		//tblGridSheet.DoSave("/tradeSOS/scene/sceneSuggestStatAdviceMemberProc.do", "", "RATING");

		var pMemberRatingList = tblGridSheet.GetSaveJson();    // 자문위원 평가관리 데이터
		var starYear = $("#startYear").val();
		var endYear = $("#endYear").val();
		var experNm = $("#experNm").val();

		var params = {
			starYear: starYear
			, endYear: endYear
			, experNm: experNm
			, memberRatingList: pMemberRatingList.data
		};
		if (confirm('저장 하시겠습니까?')) {
			global.ajax({
				type: 'POST'
				, url: '<c:url value="/tradeSOS/scene/sceneSuggestStatAdviceMemberProc.do" />'
				, data: JSON.stringify(params)
				, dataType: 'json'
				, contentType: 'application/json'
				, async: true
				, spinner: true
				, success: function (data) {
					getMemberRating();
				}
			});
		}
	}

	// 만족도 Sheet 생성
	function setSurveyGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		ibHeader.addHeader({Type: "Text", 	Header: "expertid",		SaveName: "expertId", 	Align: "Center", 	Width: 160, Hidden : true });
		ibHeader.addHeader({Type: "Text", 	Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 160 , Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoSum",	Header: "자문건수", 		SaveName: "totCnt", 	Align: "Right",	 Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoSum",	Header: "만족도건수", 	SaveName: "surveyTotalCount", 	Align: "Right",  Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg",	Header: "상담채널일치", 	SaveName: "matchPer", 	Align: "Center", Format : "#,###.##", Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg",	Header: "전반적 만족도", 	SaveName: "survey02", 	Align: "Center", Format : "#,###.##", 	Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg",	Header: "위원 전문성", 	SaveName: "survey03", 	Align: "Center", Format : "#,###.##", 	Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg", 	Header: "위원 친절도", 	SaveName: "survey04", 	Align: "Center", Format : "#,###.##", 	Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg", 	Header: "재상담 의향", 	SaveName: "survey05", 	Align: "Center", Format : "#,###.##", 	Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg", 	Header: "추천 의향", 	SaveName: "survey06", 	Align: "Center", Format : "#,###.##", 	Width: 130, Cursor:"Pointer"});
		ibHeader.addHeader({Type: "AutoAvg", 	Header: "평균", 			SaveName: "totalAvg", 	Align: "Center", Format : "#,###.##", Sum:true,	 Width: 130, Cursor:"Pointer"});

		if (typeof tblGridSheet2 !== "undefined" && typeof tblGridSheet2.Index !== "undefined") {
			tblGridSheet2.DisposeSheet();
		}

		var sheetId = "tblGridSheet2";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "550px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet2.SetEditable(0);

		getSurveyList();
	}

	// 만족도 평가관리 조회
	function getSurveyList(){
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatSurveyListAjax.do" />'
			, data : $('#surveyFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet2.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function tblGridSheet2_OnSearchEnd(code, msg) {
		var sumRow = Number(tblGridSheet2.FindSumRow());
		tblGridSheet2.SetSumValue(0, 1, "합계");          // 합계 텍스트
		tblGridSheet2.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
		if (code != 0) {
			console.log('tblGridSheet2_OnSearchEnd : ', msg);
		} else {
			// 제목에 볼드 처리
			tblGridSheet2.SetColFontBold('expertNm', 1);
		}
	}

	// 만족도 엑셀 다운로드
	function getSurveyExcel() {
		var f;
		f = document.surveyFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatMemberListSurveyExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	// 만족도 평가 상세
	function tblGridSheet2_OnClick(Row, Col, Value) {
		var rowData = tblGridSheet2.GetRowData(Row);
		var recDateFrom = $("#startDate2").val();
		var recDateTo = $("#endDate2").val();
		var expertId = rowData["expertId"];
		var expertNm = rowData["expertNm"];
		if (row != 0 && row != Number(tblGridSheet2.FindSumRow())){
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/tradeSOS/popup/surveyPopup.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
					    expertId : expertId
				      , expertNm : expertNm
				      , recDateFrom : recDateFrom
				      , recDateTo   : recDateTo
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
			}
		});
		}
	};

	function tblGridSheet2_OnLoadData(Data) {
		var resultData = JSON.parse(Data);

		//만족도 카운트
		var surveyCount = 0;
		//위원별 만족도 합계
		var surveyAvgTotal = 0;
		//전체 위원 평균
		var totalAvg = 0;

		for (var i = 0 ; i < resultData.Data.length; i++){
			if (getNum(resultData.Data[i].totalAvg) > 0){
				surveyCount++;
				surveyAvgTotal = surveyAvgTotal+resultData.Data[i].totalAvg;
			}
		}
		if (surveyCount == 0){
			totalAvg = 0;
		}else{
			totalAvg = setRound(surveyAvgTotal/surveyCount);
		}

		$("#totalAvg").html("전체 위원 평균 : <span>"+totalAvg+"</span>");
	}

	//업체별 통계 리스트 가져오기
	function getCompanyList(){
		setCompanyGrid();
	}

	// 업체별 Sheet 생성
	function setCompanyGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
		if ($("#companyFrm input[name=gubun]:checked").val() == "001"){
			ibHeader.addHeader({Type: "Status",     Header: "상태",    	SaveName:"status",      Hidden: true });
			ibHeader.addHeader({Type: "Text", 		Header: "No", 		SaveName: "vnum", 		Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "업체명", 	SaveName: "companyNm", 	Align: "Left", Width: 200, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "사업자번호", 	SaveName: "companyNo", 	Align: "Center", Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		SaveName: "totCnt", 	Align: "Right",	 Width: 300, 	Edit: false });

		} else {
			ibHeader.addHeader({Type: "Status",     Header: "상태",     	SaveName:"status",      Hidden: true });
			ibHeader.addHeader({Type: "Text", 		Header: "No", 		SaveName: "vnum", 		Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "업체명", 	SaveName: "companyNm", 	Align: "Left", 	 Width: 200, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "사업자번호", 	SaveName: "companyNo", 	Align: "Center", Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", 	SaveName: "channelNm", 	Align: "Center", Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		SaveName: "totCnt", 	Align: "Right",  Width: 250, 	Edit: false });
		}

		if (typeof tblGridSheet3 !== "undefined" && typeof tblGridSheet3.Index !== "undefined") {
			tblGridSheet3.DisposeSheet();
		}

		var sheetId = "tblGridSheet3";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "540px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet3.SetEditable(0);

		fn_CompanyList(); // 업체별 조회
	}

	//업체별 통계 리스트 가져오기
	function fn_CompanyList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatCompanyListAjax.do" />'
			, data : $('#companyFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet3.LoadSearchData({Data: data.resultList});

			}
		});
	}

	function tblGridSheet3_OnSearchEnd(code, msg) {
		var sumRow = Number(tblGridSheet3.FindSumRow());
		tblGridSheet3.SetSumValue(0, 1, "합계");          // 합계 텍스트
		tblGridSheet3.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
		if ($("#companyFrm input[name=gubun]:checked").val() == "001"){
			tblGridSheet3.SetMergeCell(sumRow, 1, 1, 3);
		}else{
			tblGridSheet3.SetMergeCell(sumRow, 1, 1, 4);
		}
	}

	// 업체별 엑셓다운로드
	function getCompanyExcel() {
		var f;
		f = document.companyFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatCompanyListSurveyExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	//위원별 통계 리스트 가져오기
	function getMemberList(){

		setMemberGrid();
	}

	//위원별 통계 그리드 생성
	function setMemberGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		if ($("#memberFrm input[name=gubun]:checked").val() == "001"){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 80, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Right", Width: 400, 	Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "002"){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 80, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", 		SaveName: "channelNm", 	Align: "Center", 	Width: 60, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Right", Width: 320, 	Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "003"){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 80, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "업체명", 		SaveName: "company", 	Align: "Left", 	Width: 180, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "사업자번호", 	SaveName: "companyNo", 	Align: "Center", 	Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Right", Width: 250, 	Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "004"){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 80, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "신규구분", 		SaveName: "grp", 	Align: "Center", 	Width: 40,		Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		    SaveName: "cnt", 	Align: "Right", Width: 390, 		Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "005"){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 80, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "신규구분", 		SaveName: "grp", 	Align: "Center", 	Width: 40, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", 		SaveName: "channelNm", 	Align: "Center", 	Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "AutoSum",		Header: "건수", 		    SaveName: "cnt", 	Align: "Right", Width: 370, 	Edit: false });
		}

		if (typeof tblGridSheet4 !== "undefined" && typeof tblGridSheet4.Index !== "undefined") {
			tblGridSheet4.DisposeSheet();
		}

		var sheetId = "tblGridSheet4";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "550px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet4.SetEditable(0);

		fn_MemberList();
	}

	//위원별 조회
	function fn_MemberList() {
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatMemberListAjax.do" />'
			, data : $('#memberFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet4.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function tblGridSheet4_OnSearchEnd(code, msg) {
		var sumRow = Number(tblGridSheet4.FindSumRow());
		tblGridSheet4.SetSumValue(0, 0, "합계");          // 합계 텍스트
		tblGridSheet4.SetCellAlign(sumRow, 0 , "Center"); // 가운데 정렬
		if ($("#memberFrm input[name=gubun]:checked").val() == "001"){
			tblGridSheet4.SetMergeCell(sumRow, 0, 1, 2);
		}else if ($("#memberFrm input[name=gubun]:checked").val() == "002"){
			tblGridSheet4.SetMergeCell(sumRow, 0, 1, 3);
		}else if ($("#memberFrm input[name=gubun]:checked").val() == "003"){
			tblGridSheet4.SetMergeCell(sumRow, 0, 1, 4);
		}else if ($("#memberFrm input[name=gubun]:checked").val() == "004"){
			tblGridSheet4.SetMergeCell(sumRow, 0, 1, 3);
		}else if ($("#memberFrm input[name=gubun]:checked").val() == "005"){
			tblGridSheet4.SetMergeCell(sumRow, 0, 1, 4);
		}
	}

	// 위원별 엑셀다운로드
	function getMemberExcel(){
		var f;
		f = document.memberFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatMemberListExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();

	}

	/**
	 * 컨설팅분야별 리스트 가져오기
	 */
	function getConsultingList(){
		setConsultingGrid();
	}

	//컨설팅분야별 통계 그리드 생성
	function setConsultingGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		if ($("#consultingFrm input[name=gubun]:checked").val() == '001'){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "컨설팅분야별", 		SaveName: "sectNm", 	Align: "Center", 	Width: 100, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		        SaveName: "cnt", 	Align: "Right", Width: 400, 	Edit: false });

		} else if ($("#consultingFrm input[name=gubun]:checked").val() == '002'){
			ibHeader.addHeader({Type: "Text", Header: "No", SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "컨설팅분야별", 		SaveName: "sectNm", 	Align: "Center", 	Width: 100, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", SaveName: "channelNm", 	Align: "Center", Width: 50, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		SaveName: "cnt", 	Align: "Right", Width: 350, 	Edit: false });

		}

		if (typeof tblGridSheet5 !== "undefined" && typeof tblGridSheet5.Index !== "undefined") {
			tblGridSheet5.DisposeSheet();
		}

		var sheetId = "tblGridSheet5";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "580px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet5.SetEditable(0);

		fn_consultingList(); // 컨설팅분야별 조회
	}

	//컨설팅분야별 조회
	function fn_consultingList() {
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatConsultingListAjax.do" />'
			, data : $('#consultingFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet5.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 컨설팅분야별 엑셀다운로드
	function getConsultingExcel(){
		var f;
		f = document.consultingFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatConsultingListExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();

	}

	 /**
	 * 지역별 리스트 가져오기
	 */
	function getAreaList(){
		setAreaGrid();
	}

	//지역별 통계 그리드 생성
	function setAreaGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, MergeSheet :5, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		if ($("#areaFrm input[name=gubun]:checked").val() == '001'){
			ibHeader.addHeader({Type: "Text",       Header: "No",       SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "지역", 		SaveName: "cdNm", 	Align: "Center", 	Width: 70, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		SaveName: "cnt", 	Align: "Right", Width: 400,	Edit: false });

		} else if ($("#areaFrm input[name=gubun]:checked").val() == '002'){
			ibHeader.addHeader({Type: "Text",       Header: "No",       SaveName: "vnum", Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "지역", 		SaveName: "cdNm", 	Align: "Center", 	Width: 60, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", 	SaveName: "channelNm", 	Align: "Center", Width: 60, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		SaveName: "cnt", 	Align: "Right", Width: 300, 	Edit: false });

		}

		if (typeof tblGridSheet6 !== "undefined" && typeof tblGridSheet6.Index !== "undefined") {
			tblGridSheet6.DisposeSheet();
		}

		var sheetId = "tblGridSheet6";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "580px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet6.SetEditable(0);

		fn_areaList();

	}

	//지역별 조회
	function fn_areaList() {
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatAreaListAjax.do" />'
			, data : $('#areaFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet6.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 지역별 엑셀다운로드
	function getAreaExcel(){
		var f;
		f = document.areaFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatAreaListExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();

	}

	// 보고용 통계 조회
	function getReportList(){
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatReportListAjax.do" />'
			, data : $('#reportFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setReportGrid(data);
			}
		});
	}

	// 보고용통계 데이터
	function setReportGrid(data) {
		var lastWeekCnt = getNum(parseInt(data.result.now_cnt));
		var lastWeekCnt1 = getNum(parseInt(data.result.now_cnt1));
		var lastWeekCnt2 = getNum(parseInt(data.result.now_cnt2));
		var lastWeekTotalCnt = addComma(lastWeekCnt1+lastWeekCnt2);
		var monDt = data.result.mon_dt;
		var monDtLd = data.result.mon_dt_ld;
		var totDt = data.result.tot_dt;


		var lastMonthCnt = getNum(parseInt(data.result.lastmonth_cnt));
		var lastMonthCnt1 = getNum(parseInt(data.result.lastmonth_cnt1));
		var lastMonthCnt2 = getNum(parseInt(data.result.lastmonth_cnt2));
		var lastMonthTotalCnt = lastMonthCnt1+lastMonthCnt2;

		var sumCnt = getNum(parseInt(data.result.cnt));
		var sumCnt1 = getNum(parseInt(data.result.cnt1));
		var sumCnt2 = getNum(parseInt(data.result.cnt2));
		var sumTotalCnt = sumCnt1+sumCnt2;

		$("#totalLastWeek010Cnt").text(addComma(lastWeekCnt1));
		$("#totalLastWeek020Cnt").text(addComma(lastWeekCnt2));
		$("#totalLastWeekCnt").text(addComma(lastWeekCnt));
		$("#totalLastWeekCnt2").text(addComma(lastWeekTotalCnt));

		$("#lastMonthText").text("지난달 ("+monDt+"~"+monDtLd+")");
		$("#lastMonthCnt").text(addComma(lastMonthCnt));
		$("#lastMonthCnt1").text(addComma(lastMonthCnt1));
		$("#lastMonthCnt2").text(addComma(lastMonthCnt2));
		$("#lastMonthTotalCnt").text(addComma(lastMonthTotalCnt));

		$("#sumTotalText").text("누계 ("+totDt+" ~ 현재)")
		$("#sumCnt").text(addComma(sumCnt));
		$("#sumCnt1").text(addComma(sumCnt1));
		$("#sumCnt2").text(addComma(sumCnt2));
		$("#sumTotalCnt").text(addComma(sumTotalCnt));


		var areaList1 = data.result.list1;
		var areaList2 = data.result.list2;
		var areaList3 = data.result.list3;
		var areaList4 = data.result.list4;
		var areaHtml = "";
		areaHtml = "<tr>";
		areaHtml += "<td>상담 업체</td>";
		var totalCnt = 0
		for (var i = 0 ; i < areaList1.length ; i++){
			var cnt = getNum(parseInt(areaList1[i].CNT));
			totalCnt = totalCnt+cnt;
			areaHtml += "<td>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td>"+addComma(totalCnt)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>(신규신청)</td>";
		var totalCnt2 = 0
		for (var i = 0 ; i < areaList2.length ; i++){
			var cnt = getNum(parseInt(areaList2[i].CNT));
			totalCnt2 = totalCnt2+cnt;
			areaHtml += "<td>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td>"+addComma(totalCnt2)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>상담 건수</td>";
		var totalCnt3 = 0
		for (var i = 0 ; i < areaList3.length ; i++){
			var cnt = getNum(parseInt(areaList3[i].CNT));
			totalCnt3 = totalCnt3+cnt;
			areaHtml += "<td>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td>"+addComma(totalCnt3)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>현장방문</td>";
		var totalCnt4 = 0;
		for (var i = 0 ; i < areaList4.length ; i++){
			var cnt = getNum(parseInt(areaList4[i].CNT));
			totalCnt4 = totalCnt4+cnt;
			areaHtml += "<td>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td>"+addComma(totalCnt4)+"</td>";
		areaHtml += "</tr>";

		$("#areaBody").html(areaHtml);

		var channelHtml = "";
		var channelList = data.result.list5;
		var channelTotalCnt = 0;
		for (var i = 0 ; i < channelList.length ; i++){

			var cnt = getNum(parseInt(channelList[i].CNT));
			var sect_nm = channelList[i].SECT_NM;
			channelTotalCnt = channelTotalCnt+cnt;
			if (i == 0 || (i >1 && (i %3) ==0)){
				channelHtml += "<tr>";
			}
			channelHtml += "<td>"+sect_nm+"</td>";
			channelHtml += "<td>"+addComma(cnt)+"</td>";

			if (i >0 && (3 % i) == 1){
				channelHtml += "</tr>";
			}
		}
		channelHtml += "<tr>"
		channelHtml += "<td colspan='1'>합계</td><td colspan='5'>"+addComma(channelTotalCnt)+"</td>"
		channelHtml += "</tr>"
		$("#channelBody").html(channelHtml);

	}

	// JSP방식 엑셀다운로드
	function getReportExcel() {
		var reportHtmlData = $("#reportHtml").html();
		$("#reportData").val(reportHtmlData);

		// excle 파일명
		$("#excelFileName").val("무역현장컨설팅_위원별통계_");

		$("#reportDataFrm").attr("action","/tradeSOS/scene/sceneSuggestStatMemberListReportExcelDown.do");
		$("#reportDataFrm").submit();

	}

	//선택 탭에 따라 엑셀 함수 조회
	function getTabExcel() {
		var selectTab = $('[class*="tab on"]').val();   //선택한 탭의 값
		if(selectTab == 'evaluation'){				    //자문위원평가관리
			downloadIbSheetExcel(tblGridSheet,'무역현장컨설팅_자문위원평가관리통계','');
		}

		if(selectTab == 'satisfaction'){						//만족도
			getSurveyExcel();
		}

		if(selectTab == 'company'){				//업체별
			getCompanyExcel();
		}

		if(selectTab == 'memberCommittee'){				//위원별
			getMemberExcel();
		}

		if(selectTab == 'consultingField'){				//컨설팅분야별
			getConsultingExcel();
		}

		if(selectTab == 'area'){						//지역별
			getAreaExcel();
		}

		if(selectTab == 'reporting'){					//보고용통계
			getReportExcel();

		}
	}

	function setRound(val){
		return Math.round(val*10)/10;
	}

	function getNum(val){
		if (isNaN(val)) {
			return 0;
		}
		return val;
	}

	function press(event) {
		if (event.keyCode==13) {
			getList();
		}
	}

	//콤마 추가
	function addComma(num){
		if(num<1000) return num;

		var len, point, str;
		num = num + "";
		point = num.length % 3;
		len = num.length;
		str = num.substring(0, point);

		while (point < len) {
			if (str != "") str += ",";
			str += num.substring(point, point + 3);
			point += 3;
		}
		return str;
	};

	function fn_buttonChk(val) {
		if( val == 'evaluation') {
			$('#saveBtn').show();
		} else {
			$('#saveBtn').hide();
		}
	}
	function clearDate( targetId){
		$("#"+targetId).val("");
	}
</script>