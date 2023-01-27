<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<form id="sampleForm" name="sampleForm" method="get" onsubmit="return false;">
<input type="hidden" id="boardSeq" name="boardSeq" value="0" />
<input type="hidden" id="articleSeq" name="articleSeq" value="0" />

<!-- 페이지 위치 -->
<div class="location">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 페이지 타이틀</li>
	</ol>
</div>

<div class="location compact">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 리스트 페이지용 타이틀 ('compact' 클래스 추가)</li>
	</ol>
</div>

<div class="location">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 샘플게시판</li>
	</ol>

	<div class="ml-auto">
		<button class="btn_sm btn_primary">등록</button>
		<button class="btn_sm btn_secondary">목록</button>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">타이틀</h3>
	</div>

	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">타이틀 + 검색</h3>

		<div class="ml-auto">
			<span class="form_search">
				<input type="text" class="form_text">
				<button type="button" class="btn_icon btn_search" title="검색"></button>
			</span>
		</div>
	</div>

	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">타이틀 + 버튼</h3>

		<div class="ml-auto">
			<button class="btn_sm btn_primary">등록</button>
			<button class="btn_sm btn_secondary">목록</button>
		</div>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">테이블 레이아웃</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col>
			<col style="width:15%;">
			<col>
		</colgroup>
		<tr>
			<th>회사명</th>
			<td>한국무역협회</td>
			<th>사업자등록번호</th>
			<td>0000000000</td>
		</tr>
		<tr>
			<th>주소</th>
			<td colspan="3">(06164) 서울시 강남구 영동대로 511 (삼성동)</td>
		</tr>
	 </table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">텍스트 정렬</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:20%;">
			<col>
		</colgroup>
		<thead>
			<tr>
				<th>클래스명</th>
				<th>스타일</th>
			</tr>
		</thead>
		<tr>
			<td>align_l</td>
			<td>text-align : left</td>
		</tr>
		<tr>
			<td>align_ctr</td>
			<td>text-align : center</td>
		</tr>
		<tr>
			<td>align_r</td>
			<td>text-align : right</td>
		</tr>
	</table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">Spacing</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:20%;">
			<col>
		</colgroup>
		<thead>
			<tr>
				<th>클래스명</th>
				<th>스타일</th>
			</tr>
		</thead>
		<tr>
			<td>ml-auto</td>
			<td>margin-left : auto</td>
		</tr>
		<tr>
			<td>ml-0</td>
			<td>margin-left : 0</td>
		</tr>
		<tr>
			<td>ml-5</td>
			<td>margin-left : 5px</td>
		</tr>
		<tr>
			<td>ml-8</td>
			<td>margin-left : 8px</td>
		</tr>
		<tr>
			<td>ml-15</td>
			<td>margin-left : 15px</td>
		</tr>
		<tr>
			<td>ml-30</td>
			<td>margin-left : 30px</td>
		</tr>
		<tr>
			<td>mr-3</td>
			<td>margin-right : 3px</td>
		</tr>
		<tr>
			<td>mr-5</td>
			<td>margin-right : 5px</td>
		</tr>
		<tr>
			<td>mr-8</td>
			<td>margin-right : 8px</td>
		</tr>
		<tr>
			<td>mr-10</td>
			<td>margin-right : 10px</td>
		</tr>
		<tr>
			<td>mt-5</td>
			<td>margin-right : 5px</td>
		</tr>
		<tr>
			<td>mt-10</td>
			<td>margin-right : 10px</td>
		</tr>
		<tr>
			<td>mt-20</td>
			<td>margin-right : 20px</td>
		</tr>
		<tr>
			<td>mt-40</td>
			<td>margin-right : 40px</td>
		</tr>
		<tr>
			<td>mb-10</td>
			<td>margin-bottom : 10px</td>
		</tr>
		<tr>
			<td>mb-20</td>
			<td>margin-bottom : 20px</td>
		</tr>
		<tr>
			<td>mb-40</td>
			<td>margin-bottom : 40px</td>
		</tr>
	</table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">스타일 클래스</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:20%;">
			<col>
		</colgroup>
		<thead>
			<tr>
				<th>클래스명</th>
				<th>스타일</th>
			</tr>
		</thead>
		<tr>
			<td>hide</td>
			<td>display : none</td>
		</tr>
		<tr>
			<td>flex</td>
			<td>display : flex</td>
		</tr>
		<tr>
			<td>align_center</td>
			<td>align-items : center</td>
		</tr>
		<tr>
			<td>w100p</td>
			<td>width : 100%</td>
		</tr>
		<tr>
			<td>w80p</td>
			<td>width : 80%</td>
		</tr>
		<tr>
			<td>wAuto</td>
			<td>width : auto</td>
		</tr>
	</table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">버튼</h3>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:20%;">
			<col>
		</colgroup>
		<tr>
			<td>
	            <button class="btn_sm btn_primary">상단 기능 버튼</button>
			</td>
			<td>
				<pre>&lt;button class="btn_sm btn_primary"&gt;상단 기능 버튼&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn_sm btn_secondary">상단 기능 버튼</button>
			</td>
			<td>
				<pre>&lt;button class="btn_sm btn_primary"&gt;상단 기능 버튼&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn_sm btn_primary disabled">비활성화 버튼</button>
			</td>
			<td>
				<pre>&lt;button class="btn_sm btn_primary disabled"&gt;비활성화 버튼&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn btn_primary">저장</button>
			</td>
			<td>
				<pre>&lt;button class="btn btn_primary"&gt;저장&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn btn_secondary">취소</button>
			</td>
			<td>
				<pre>&lt;button class="btn btn_secondary"&gt;취소&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn btn_primary disabled">버튼</button>
			</td>
			<td>
				<pre>&lt;button class="btn btn_primary disabled"&gt;비활성화 버튼&lt;/button&gt;</pre>
			</td>
		</tr>
		<tr>
			<td>
	            <button class="btn_tbl_primary">테이블 버튼</button>
	            <button class="btn_tbl">테이블 버튼</button>
	            <button class="btn_tbl_border">테이블 버튼</button>
			</td>
			<td>
				<pre>&lt;button class="btn_tbl_primary"&gt;테이블 안에서 사용하는 버튼&lt;/button&gt;</pre>
				<pre>&lt;button class="btn_tbl"&gt;테이블 안에서 사용하는 버튼&lt;/button&gt;</pre>
				<pre>&lt;button class="btn_tbl_border"&gt;테이블 안에서 사용하는 버튼&lt;/button&gt;</pre>
			</td>
		</tr>
	 </table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">Form 요소</h3>
	</div>

	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>

	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col>
		</colgroup>
		<tr>
			<th>Text Field <strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" placeholder="텍스트입력">
				<input type="text" class="form_text" placeholder="텍스트입력" disabled>
			</td>
		</tr>
		<tr>
			<th>Form Radio</th>
			<td>
				<label class="label_form">
					<input type="radio" class="form_radio">
					<span class="label">radio1</span>
				</label>

				<label class="label_form">
					<input type="radio" class="form_radio">
					<span class="label">radio2</span>
				</label>

				<label class="label_form">
					<input type="radio" class="form_radio" disabled>
					<span class="label">disabled</span>
				</label>
			</td>
		</tr>
		<tr>
			<th>Form Checkbox</th>
			<td>
				<label class="label_form">
					<input type="checkbox" class="form_checkbox">
					<span class="label">checkbox1</span>
				</label>

				<label class="label_form">
					<input type="checkbox" class="form_checkbox">
					<span class="label">checkbox2</span>
				</label>

				<label class="label_form">
					<input type="checkbox" class="form_checkbox" disabled>
					<span class="label">disabled</span>
				</label>
			</td>
		</tr>
		<tr>
			<th>셀렉트박스</th>
			<td>
				<select class="form_select">
					<option value="">전체</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>form + 텍스트</th>
			<td>
				<div class="form_row">
					<input type="text" class="form_text">
					<span class="append">단위</span>
				</div>
			</td>
		</tr>
		<tr>
			<th>텍스트 + form</th>
			<td>
				<div class="form_row">
					<span class="prepend">단위</span>
					<input type="text" class="form_text">
				</div>
			</td>
		</tr>
		<tr>
			<th>전화번호</th>
			<td>
				<div class="form_row" style="width:300px;">
					<select class="form_select">
						<option value="">010</option>
					</select>
					<input type="text" class="form_text" value="1234">
					<input type="text" class="form_text" value="5678">
				</div>
			</td>
		</tr>
		<tr>
			<th>검색</th>
			<td>
				<span class="form_search">
					<input type="text" class="form_text">
					<button type="button" class="btn_icon btn_search" title="검색"></button>
				</span>
				<span class="form_search">
					<input type="text" class="form_text" readonly>
					<button type="button" class="btn_icon btn_search" title="검색"></button>
				</span>
			</td>
		</tr>
		<tr>
			<th>Monthpicker</th>
			<td>
				<!-- monthpicker -->
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="searchMonth" name="searchMonth" value="" class="txt monthpicker" placeholder="검색월" title="검색월" readonly="readonly" />
						<img src="<c:url value='/images/icon_calender.png' />" onclick="showMonthpicker('searchMonth');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
					</span>

					<!-- clear 버튼 -->
					<button type="button" onclick="clearPickerValue('searchMonth');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
				</div>
			</td>
		</tr>
		<tr>
			<th>Datepicker</th>
			<td>
				<!-- datepicker -->
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="searchStartAloneDate" name="searchStartAloneDate" value="${param.searchStartAloneDate}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
						<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
						<input type="hidden" id="dummyStartAloneDate" value="" />
					</span>

					<!-- clear 버튼 -->
					<button type="button" onclick="clearPickerValue('searchStartAloneDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
				</div>
			</td>
		</tr>
		<tr>
			<th>Datepicker Group</th>
			<td>
				<div class="group_datepicker">
					<!-- datepicker -->
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="searchStartDate" name="searchStartDate" value="${param.searchStartDate}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyStartDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('searchStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>

					<div class="spacing">~</div>

					<!-- datepicker -->
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							<input type="hidden" id="dummyEndDate" value="" />
						</span>

						<!-- clear 버튼 -->
						<button type="button" onclick="clearPickerValue('searchEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<th>Textarea</th>
			<td>
				<textarea rows="10" class="form_textarea"></textarea>
			</td>
		</tr>
		<tr>
			<th>첨부파일</th>
			<td>
				<div id="attachFieldList">
					<div class="addedFile">
						<a href="" class="filename">파일명1.pdf <span>(12345)</span></a>
						<a href="" class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
						<button type="button" class="file_preview btn_tbl_border"><img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기"> 미리보기</button>
					</div>
					<div class="addedFile">
						<a href="" class="filename">파일명2.pdf <span>(12345)</span></a>
						<a href="" class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
					</div>
				</div>
				<div class="form_file">
					<p class="file_name">첨부파일을 선택하세요</p>
					<label class="file_btn">
						<input type="file" />
						<span class="btn_tbl">찾아보기</span>
					</label>
				</div>
			</td>
		</tr>
	 </table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">테이블 간소화</h3>
	</div>

	<div class="foldingTable fold">
		<div class="foldingTable_inner">
			<table class="formTable">
				<colgroup>
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
					<col style="width:15%;" />
					<col />
				</colgroup>
				<tr>
					<th>사업년도</th>
					<td>
						<select class="form_select">
							<option value="">전체</option>
						</select>
					</td>
					<th>사업명</th>
					<td>
						<input type="text" class="form_text" />
					</td>
					<th>게시일</th>
					<td>
						<select class="form_select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>상태</th>
					<td>
						<select class="form_select">
							<option value="">전체</option>
						</select>
					</td>
					<th>오픈여부</th>
					<td>
						<select class="form_select">
							<option value="">오픈</option>
						</select>
					</td>
					<th>추가사업</th>
					<td>
						<input type="text" class="form_text" value="N" />
					</td>
				</tr>
				<tr>
					<th>사업기간</th>
					<td colspan="3">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchBusinessStartDate" name="searchBusinessStartDate" value="${param.searchBusinessStartDate}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyBusinessStartDate" value="" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('searchBusinessStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>

							<div class="spacing">~</div>

							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="searchBusinessEndDate" name="searchBusinessEndDate" value="${param.searchBusinessEndDate}" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyBusinessEndDate" value="" />
								</span>

								<!-- clear 버튼 -->
								<button type="button" onclick="clearPickerValue('searchBusinessEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
							</div>
						</div>
					</td>
					<th>사업예산</th>
					<td>
						<input type="text" class="form_text" />
					</td>
				</tr>
			</table>
		</div>
		<button class="btn_folding" title="테이블접기"></button>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">데이터 테이블</h3>
	</div>

	<table class="formTable dataTable">
		<colgroup>
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:25%" />
			<col />
		</colgroup>
		<thead>
			<tr>
				<th scope="col" colspan="2">용역명</th>
				<th scope="col">기 간()</th>
				<th scope="col">금 액(US $)</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th scope="row" rowspan="2">운임수입</th>
				<th scope="col">국내수출입화물 운임수입</th>
				<td class="align_ctr">2020-01-01 ~ 2022-01-01</td>
				<td class="align_r">1,000,001</td>
			</tr>
			<tr>
				<th scope="row">삼국간 화물 운임수입</th>
				<td class="align_ctr">2020-01-02 ~ 2022-01-02</td>
				<td class="align_r">1,000,002</td>
			</tr>
			<tr>
				<th colspan="2" class="align_ctr">외국인에 대한 대선 수입</th>
				<td class="align_ctr">2020-01-03 ~ 2022-01-03	</td>
				<td class="align_r">0</td>
			</tr>
			<tr>
				<th scope="row" rowspan="2">터미널 운영수입</th>
				<th scope="row">국내터미널 운영수입</th>
				<td class="align_ctr">2020-01-04 ~ 2022-01-04</td>
				<td class="align_r">1,000,004</td>
			</tr>
			<tr>
				<th scope="row">국외터미널 운영수입</th>
				<td class="align_ctr">2020-01-05 ~ 2022-01-05</td>
				<td class="align_r">1,000,005</td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<th scope="row" colspan="2" class="align_ctr">합  계</th>
				<td class="align_r" colspan="2">5,000,015</td>
			</tr>
		</tfoot>
	</table>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">검색</h3>
	</div>

	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%;" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">검색</th>
					<td colspan="3">
						<fieldset class="form_group">
							<div class="group_datepicker group_item">
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchStartDate1" name="searchStartDate1" value="${param.searchStartDate1}" class="txt datepicker" placeholder="시작일" title="시작일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate1" value="" />
									</span>
								</div>
								<div class="spacing">~</div>
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchEndDate1" name="searchEndDate1" value="${param.searchEndDate1}" class="txt datepicker" placeholder="종료일" title="종료일" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate1" value="" />
									</span>
								</div>
							</div>
							<div class="group_item">
								<select class="form_select" id="searchCondition" name="searchCondition">
									<option value="" <c:if test="${empty param.searchCondition or param.searchCondition eq ''}">selected="selected"</c:if>>전체</option>
									<option value="title" <c:if test="${param.searchCondition eq 'title'}">selected="selected"</c:if>>제목</option>
									<option value="contents" <c:if test="${param.searchCondition eq 'contents'}">selected="selected"</c:if>>내용</option>
								</select>
							</div>
							<div class="group_item">
								<input type="text" id="searchKeyword" name="searchKeyword" value="${param.searchKeyword}" onkeydown="onEnter(doSearch);" class="form_text" title="검색어" />
								<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
							</div>
						</fieldset>
					</td>
	            </tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">탭</h3>
	</div>

	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab on">바우처 등록</button>
			<button class="tab">바우처 서비스</button>
			<button class="tab">바우처 서비스</button>
		</div>
		<div class="tab_body">
			<div class="tab_cont on">탭1</div>
			<div class="tab_cont">탭2</div>
			<div class="tab_cont">탭3</div>
		</div>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">버튼</h3>
	</div>

	<div class="">
		<a href="javascript:doExcelHeaderDownload();" class="ui-button ui-widget ui-corner-all">엑셀(HEADER)</a>
		<a href="javascript:doExcelDoubleHeaderDownload();" class="ui-button ui-widget ui-corner-all">엑셀(DOUBLE HEADER)</a>
		<a href="javascript:doExcelDoubleMultiDownload();" class="ui-button ui-widget ui-corner-all">엑셀(DOUBLE MULTI)</a>
		<a href="javascript:doExcelMultiSheetDownload();" class="ui-button ui-widget ui-corner-all">엑셀(MULTI SHEET)</a>
		<a href="javascript:doExcelIBSheetDownload();" class="ui-button ui-widget ui-corner-all">엑셀(IBSHEET)</a>
		<a href="javascript:openCommonPopup1();" class="ui-button ui-widget ui-corner-all">샘플 레이어1</a>
	</div>
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">사용자 게시판</h3>
	</div>

	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="basicTotalCnt" class="total_count"></div>

		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
		<!-- 한 페이지 갯수 -->
		<select id="basicPageUnit" name="basicPageUnit" onchange="doSearch();" class="form_select ml-auto" title="목록수">
			<option value="10" <c:if test="${empty param.basicPageUnit or param.basicPageUnit eq '10'}">selected="selected"</c:if>>10개씩 보기</option>
			<option value="20" <c:if test="${param.basicPageUnit eq '20'}">selected="selected"</c:if>>20개씩 보기</option>
			<option value="30" <c:if test="${param.basicPageUnit eq '30'}">selected="selected"</c:if>>30개씩 보기</option>
		</select>
	</div>
	<%--HTML --%>
	<%--<div id="boardList" class="boardList charge"></div>--%>

	<%--Toast Grid --%>
	<div id="grid"></div>
	<div id="basicPaging" class="paging ibs"></div>

	<div class="btn_group mt-20">
		<button type="button" onclick="goWrite();" class="btn btn_primary">등록</button>
		<a href="javascript:goWrite();" class="btn btn_secondary">취소</a>
	</div>

	<div class="btn_group mt-20 _center">
		<a  onclick="goWrite();" class="btn btn_primary">등록</a>
		<a href="javascript:goWrite();" class="btn btn_secondary">취소</a>
	</div>
	<div class="btn_group mt-20 _right">
		<a  onclick="goWrite();" class="btn btn_primary">등록</a>
		<a href="javascript:goWrite();" class="btn btn_secondary">취소</a>
	</div>
</div>
</form>

<div style="margin-bottom: 100px;">

</div>
<div class="location">
	<ol>
		<li><img src="<c:url value='/images/admin/ico_home.png' />" alt="home"> 메일전송</li>
	</ol>

	<div class="ml-auto">
		<button type="button" onclick="mailSend();" class="btn_sm btn_primary">메일보내기</button>
	</div>
</div>
<div class="search">
	<form id="mailForm" name="mailForm" method="get" onsubmit="return false;">
	<table class="formTable">
		<colgroup>
			<col style="width:18%;">
			<col>
			<col style="width:18%;">
			<col>
		</colgroup>
		<tr>
			<th>메일 제목</th>
			<td colspan="3">
				<input type="text" class="form_text" id="mailTitle" name="mailTitle"  placeholder="메일제목" title="메일제목" maxlength="300" required="required" style="width:100%;"  />
			</td>
		</tr>
		<tr>
			<th>메일 내용</th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mailMsg" name="mailMsg" placeholder="문자내용" title="문자내용" style="height:99%; width:99%" required="required"></textarea>
			</td>
		</tr>
		<tr>
			<th>발신자 전화번호</th>
			<td>
				<input type="text" class="form_text"  id="membTelNo" name="membTelNo"  placeholder="발신자전화번호" 	title="발신자전화번호" maxlength="15" required="required"  style="width:80%;" />
			</td>
			<th>발신자 이메일</th>
			<td>
				<input type="text" class="form_text" id="membEmail" name="membEmail"  placeholder="발신자이메일" 	title="발신자이메일" maxlength="80" required="required"  style="width:80%;" />
			</td>
		</tr>
		<tr>
			<th>비고2</th>
			<td >
				<input type="text" class="form_text" id="note2" name="note2"  placeholder="비고2" 	title="비고2" maxlength="300" required="required"   style="width:80%;" />
			</td>
			<th>비고3</th>
			<td >
				<input type="text" class="form_text" id="note3" name="note3"  placeholder="비고3" 	title="비고3" maxlength="300" required="required"   style="width:80%;"  />
			</td>
		</tr>
	</table>
	</form>
</div>


<script type="text/javascript">
	var f;
	var grid;

	$(document).ready(function(){
		f = document.sampleForm;

		//toast Grid
		init_sampleGrid();

		getList();

		/* Event 시작 */
		grid.on('click', function(ev) {
			console.log(grid.getRow(ev.rowKey));
		});

		/* Evnet 종료 */

	});

	function init_sampleGrid() {
		// grid 생성
		grid = new tui.Grid({
			el: document.getElementById('grid'),
			scrollX: false,
			scrollY: false,
			columns: [
			  { type: 'number', header: '번호', name: 'articleSeq', width: 50, align: 'center', sorting: true, readOnly: true},
			  { type: 'text', header: '제목', name: 'title', align: 'left', sorting: true, readOnly: true,
				onBeforeChange(ev) {
					console.log('Before change:' + ev);
				},
				onAfterChange(ev) {
					console.log('After change:' + ev);
				},
			  },
			  { type: 'text', header: '날짜', name: 'regDate', width: 150, align: 'center', sorting: true, readOnly: true},
			  { type: 'text', header: '조회수', name: 'viewCnt', width: 100, align: 'center', sorting: true, readOnly: true}
			]
		  });
	}

	function doSearch() {
		goPage(1);
	}

	function goPage(pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	function getList() {
		f.boardSeq.value = '0';

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sample/board/selectList.do" />'
			, data : $('#sampleForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				$('#basicTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				console.log(data.resultList);
				// 데이터
				grid.resetData(eval(data.resultList));

				/* 페이징 처리 */
				setPaging(
					'basicPaging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

			}
		});
	}

	// 목록 가져오기(HTML)
	function getHtmlList() {
		f.boardSeq.value = '0';

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sample/board/selectList.do" />'
			, data : $('#sampleForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#basicTotalCnt').html('총 ' + global.formatCurrency(data.resultCnt) + ' 건');

				var list = '';

				list += '<ul>';

		/*			list += '	<div class="cont_block">';
					            <!-- 타이틀 영역 -->
					list += '		<div class="tit_bar">';
					list += '			<h3 class="tit_block">일반 게시판</h3>';
					list += '		</div>';*/
					list += '		<table class="formTable">';
					list += '			<colgroup>';
					list += '			<col style="width:10%;">';
					list += '			<col style="width:70%;">';
					list += '			<col style="width:10%;">';
					list += '			<col style="width:10%;">';
					list += '			</colgroup>';
					list += '			<thead>';
					list += '				<tr>';
					list += '					<th>번호</th>';
					list += '					<th>제목</th>';
					list += '					<th>날짜</th>';
					list += '					<th>조회수</th>';
					list += '				</tr>';
					list += '			</thead>';
				for (var i = 0; i < data.resultList.length; i++) {
					list += '			<tr>';
					list += '				<td style="text-align: center;">' + global.formatCurrency(data.resultList[i].rownum) + '</td>';
					list += '				<td><a href="javascript:goView(\'' + data.resultList[i].articleSeq + '\');" class="sbj bord_tit sbj_m">' + data.resultList[i].title + '</a></td>';
					list += '				<td>'+data.resultList[i].regDate+'</td>';
					list += '				<td style="text-align: center;">'+global.formatCurrency(data.resultList[i].viewCnt)+'</td>';
					list += '			</tr>';
				}
			/*		list += '	</div>';*/

				list += '</ul>';

				$('#boardList').html(list);

				/* 페이징 처리 */
				setPaging(
					'basicPaging'
					, goPage
					, data.paginationInfo.currentPageNo
					, data.paginationInfo.totalRecordCount
					, data.paginationInfo.recordCountPerPage
					, data.paginationInfo.pageSize
				);

			}
		});
	}

	// 등록화면
	function goWrite() {
		f.action = '<c:url value="/sample/board/sampleWrite.do" />';
		f.articleSeq.value = '0';
		f.target = '_self';
		f.submit();
	}

	// 조회화면
	function goView(articleSeq) {
		f.action = '<c:url value="/sample/board/sampleView.do" />';
		f.boardSeq.value = 0;
		f.articleSeq.value = articleSeq;
		f.target = '_self';
		f.submit();
	}

	// 엑셀 다운받기
	function doExcelHeaderDownload() {
		f.action = '<c:url value="/sample/board/headerList/excelDownload.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function doExcelDoubleHeaderDownload() {
		f.action = '<c:url value="/sample/board/doubleList/excelDownload.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function doExcelDoubleMultiDownload() {
		f.action = '<c:url value="/sample/board/multiList/excelDownload.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function doExcelMultiSheetDownload() {
		f.action = '<c:url value="/sample/board/multiSheet/excelDownload.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();
	}

	function doExcelIBSheetDownload() {
		downloadIbSheetExcel(basicListSheet, '외국어통번역통계_언어별통계', '');
	}

	// 샘플 레이어1
	function openCommonPopup1() {
		global.openLayerPopup({
			// 레이어 팝업 URL
			popupUrl : '<c:url value="/common/popup/searchPopup1.do" />'
			// 레이어 팝업으로 넘기는 parameter 예시
			, params : {
				aaa : '111'
				, bbb : '222'
				, ccc : '333'
			}
			// 레이어 팝업 Callback Function
			, callbackFunction : function(resultObj){
				alert('샘플 레이어1의 콜백');
				alert(resultObj);
			}
		});
	}

	function mailSend() {

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sample/board/sampleMailSend.do" />'
			, data : $('#mailForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("메일이 전송되었습니다.");

			}
		});
	}
</script>