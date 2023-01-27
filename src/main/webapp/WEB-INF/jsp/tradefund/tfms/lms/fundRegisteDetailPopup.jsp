<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundRegisteDetailPopupForm" name="fundRegisteDetailPopupForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchExpertIdPop" 	id="searchExpertIdPop" 	value="<c:out value="${searchExpertIdPop}"/> /">
<input type="hidden" name="pageIndex"			id="pageIndex"  		value="<c:out value='${param.pageIndex}' 	default='1' />" />

<div style="max-width: 800px; max-height: 700px;" class="fixed_pop_tit">
<!-- 팝업 타이틀 -->
	<div class="flex popup_top">
		<h2 class="popup_title">KITA무역진흥자금 융자 상세 조회</h2>
		<div class="ml-auto">
			<button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<div class="popup_body" >
	<table class="formTable">
		<colgroup>
			<col style="width:15%;">
			<col style="width:15%;">
			<col>
		</colgroup>
		<tr>
			<th colspan="2">무역기금 융자명 </th>
			<td >
				<input type="text" class="form_text" placeholder="무역기금융자명" title="무역기금융자명" id="title" name="title" style="width: 99%" maxlength="150" required="required" value="<c:out value="${result.title}"/>" readonly="readonly" />
			</td>
		</tr>
		<%-- <tr>
			<th rowspan="2">무역기금융자<br> 세부내용 </th>
			<td colspan="2">
				<textarea rows="10" class="form_textarea" id="bodyDesc" name="bodyDesc" placeholder="무역기금융자 세부내용" title="무역기금융자 세부내용" style="height:99%; width:99%" required="required" readonly="readonly"
				onKeyUp="textareachk(this)"  ><c:out value="${result.bodyDesc}"/></textarea>
			</td>
		</tr>
		<tr>
            <td colspan="2">
            	<div class="flex align_center">
            	(<input type="text" id="textareaCnt" name="textareaCnt" style="width:40px; font-size:14px; color:#5C5F68; border:0; ime-mode:disabled; text-align : right;"  readonly="readonly" /> ) / 4000 byte
            	</div>
            </td>
        </tr> --%>
		<tr>
			<th rowspan="7">담당자</th>
			<th>이름 </th>
			<td>
				<input type="hidden" id="regEmpId" name="regEmpId" />
				<input type="text" class="form_text" placeholder="무역기금융자명" title="무역기금융자명" id="regEmpNm" name="regEmpNm" maxlength="100" readonly="readonly" required="required" value="<c:out value="${result.regEmpNm}"/>"  readonly="readonly" />
			</td>

		</tr>
		<tr>
			<th>전화 </th>
			<td>
				<input type="text" class="form_text" placeholder="담당자전화" title="담당자전화" id="regTel" name="regTel"  maxlength="13" required="required"   value="<c:out value="${result.regTel}"/>"  readonly="readonly"  />
			</td>
		<tr>
			<th>팩스 </th>
			<td>
				<input type="text" class="form_text" placeholder="담당자팩스" title="담당자팩스" id="regFax" name="regFax" " maxlength="13" required="required"  value="<c:out value="${result.regFax}"/>"  readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<th>부서 </th>
			<td>
				<input type="hidden" id="REG_DEPT_CD" name="REG_DEPT_CD" />
				<input type="text" class="form_text" placeholder="담당자부서" title="담당자부서" id="regDeptNm" name="regDeptNm"  maxlength="50" readonly="readonly" required="required" value="<c:out value="${result.regDeptNm}"/>"  readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<th>E-Mail </th>
			<td >
				<input type="text" class="form_text" placeholder="무역기금융자명" title="무역기금융자명" id="regEmail" name="regEmail"  maxlength="150" required="required"  value="<c:out value="${result.regEmail}"/>"  readonly="readonly" />
			</td>
		</tr>
		<tr>
			<th>접수기간 </th>
			<td >
				<!-- datepicker -->
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="bsnStartDt" name="bsnStartDt" class="txt " placeholder="접수기간 시작" title="접수기간 시작" readonly="readonly" required="required" value="<c:out value="${result.bsnStartDt}"/>"  readonly="readonly" style="width: 80px;" />
					</span>
					<div class="spacing">~</div>
					<span class="form_datepicker">
						<input type="text" id="bsnEndDt" name="bsnEndDt" class="txt " placeholder="접수기간 종료" title="접수기간 종료" readonly="readonly" required="required" value="<c:out value="${result.bsnEndDt}"/>"  readonly="readonly" style="width: 80px;" />
					</span>

				</div>
			</td>
		</tr>
		<tr>
			<th>사업기간 </th>
			<td >
				<!-- datepicker -->
				<div class="datepicker_box">
					<span class="form_datepicker">
						<input type="text" id="bsnAplStartDt" name="bsnAplStartDt" class="txt " placeholder="사업기간 시작" title="사업기간 시작" readonly="readonly" required="required" value="<c:out value="${result.bsnAplStartDt}"/>"  readonly="readonly" style="width: 80px;" />
					</span>
					<div class="spacing">~</div>
					<span class="form_datepicker">
						<input type="text" id="bsnAplEndDt" name="bsnAplEndDt" class="txt " placeholder="사업기간 종료" title="사업기간 종료" readonly="readonly" required="required" value="<c:out value="${result.bsnAplEndDt}"/>"  readonly="readonly" style="width: 80px;" />
					</span>

				</div>
			</td>
		</tr>
		<tr >
			<th rowspan="3">융자 </th>
			<th>1차 지급일 </th>
			<td>
				<div class="flex align_center">
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 1차 지급월" id="fund1Mm" name="fund1Mm" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund1Mm}"/>"  readonly="readonly" />
						<span class="append">월</span>
					</div>
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 1차 지급일" id="fund1Dd" name="fund1Dd" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund1Dd}"/>"  readonly="readonly" />
						<span class="append">일</span>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<th>2차 지급일</th>
			<td>
				<div class="flex align_center">
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 2차 지급월" id="fund2Mm" name="fund2Mm" size="2" maxlength="2" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund2Mm}"/>"  readonly="readonly" />
						<span class="append">월</span>
					</div>
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 2차 지급일" id="fund2Dd" name="fund2Dd" size="2" maxlength="2" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund2Dd}"/>"  readonly="readonly" />
						<span class="append">일</span>
					</div>
				</div>
			</td>
		</tr>
<%-- 		<tr>
			<th>3차 지급일 </th>
			<td >
				<div class="flex align_center">
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 3차 지급월" id="fund3Mm" name="fund3Mm" size="2" maxlength="2" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund3Mm}"/>"  readonly="readonly" />
						<span class="append">월</span>
					</div>
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="융자 3차 지급일" id="fund3Dd" name="fund3Dd" size="2" maxlength="2" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.fund3Dd}"/>"  readonly="readonly" />
						<span class="append">일</span>
					</div>
				</div>
			</td>
		</tr> --%>
		<tr>
			<th>추천 유효기간 </th>
			<td >
				<div class="flex align_center">
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="추천 유효기간 월" id="validMm" name="validMm" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.validMm}"/>"  readonly="readonly" />
						<span class="append">월</span>
					</div>
					<div class="form_row" style="min-width:100px;">
						<input type="text" class="form_text align_ctr" title="추천 유효기간 일" id="validDd" name="validDd" size="2" maxlength="2" required="required" onkeypress="doKeyPressEvent(this, 'NUMBER', event)" value="<c:out value="${result.validDd}"/>"  readonly="readonly" />
						<span class="append">일</span>
					</div>
				</div>
			</td>
		</tr>
<%-- 		<tr>
			<th colspan="2">상태</th>
			<td >
				<select id="st" name="st"  class="form_select" style="width:100px;" >
					<c:forEach var="item" items="${LMS001}" varStatus="status">
						<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq result.st}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
					</c:forEach>
				</select>
			</td>
		</tr> --%>
		<tr>
			<th colspan="2">첨부파일</th>
			<td >
				<input type="hidden" id="attFileId" 	name="attFileId" value="<c:out value="${result.attFileId}"/>" />
				<input type="hidden" id="fileId" 		name="fileId" />
				<input type="hidden" id="fileNo" 		name="fileNo" />
				<div id="attachFieldList">

				<c:if test="${not empty fileList}">
					<c:set var="lastFileSeq" value="0" />
					<c:forEach var="fileList" items="${fileList}" varStatus="status">
						<div class="addedFile" id="fileNo_<c:out value="${fileList.fileNo}"/>">
							<a href="javascript:doDownloadFile('<c:out value="${fileList.fileNo}"/>');" class="filename" class="filename">
								${fileList.fileName}
							</a>
                              </div>
					</c:forEach>
				</c:if>

				</div>
			</td>
		</tr>
	 </table>
	</div>
</div>
</form>

<script type="text/javascript">
	$(document).ready(function () {

		setExpPhoneNumber(['#regTel', '#regFax'], 'W');

		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});
	});

	//첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var form = document.fundRegisteDetailPopupForm;
		form.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		form.fileNo.value = fileNo;
		form.fileId.value = form.attFileId.value;
		form.target = '_self';
		form.submit();
	}
</script>