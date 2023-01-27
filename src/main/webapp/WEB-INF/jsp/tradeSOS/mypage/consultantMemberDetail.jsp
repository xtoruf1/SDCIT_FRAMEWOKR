<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	function press(event) {
		if (event.keyCode==13) {

		}
	}
	function fn_list() {
		document.listForm.action = "/tradeSOS/com/consultantMember.do";
		document.listForm.submit();
	}

	// 주요경력 추가
	function addLine(obj){
		var addInput = $(obj).parents(".addInput");
		var nums = $('#careerMaxIndex').val();
		nums++;

		addInput.append(
			'<div class="add_line">'
			+'<input type="text" id="careerYearArr'+nums+'" name="careerYearArr" class="form_text careerYearArr">'
			+'<input type="text" id="careerContentArr'+nums+'" name="careerContentArr" class="form_text w40p careerContentArr">'
			+' <button type="button" class="btn_tbl_border" onclick="deleteRow(this);">삭제</button>'
			+'</div>'
		);
		$('#careerMaxIndex').val(nums);
	}

	// 주요경력 삭제
	function deleteRow(obj){
		var nums = $('#careerMaxIndex').val();
		var clickedRow = $(obj).parent(".add_line");
		if(nums > 0){
			nums--;
			$('#careerMaxIndex').val(nums);
		}
		clickedRow.remove();
	}

	$(document).ready(function () {
	})

	/*계층형*/
	function openLayerItemPop(){
		//기본값 초기화
		$('#searchUnit').val('');
		$('#searchMtiCodePop').val('');
		$('#upperItem').data('unit','0');
		//품목별 초기화 추가
		$('#searchMtiNmPop').val('');
// 		itemStepList(tblSheet);
// 		itemKeyList(tblSheet2);
// 		$('#itemPop').show();

		global.openLayerPopup({
				popupUrl : '/tradeSOS/com/popup/professionalField.do'
			, callbackFunction : function(resultObj) {
				var appendHtml = "";
				var chk = "";																					//중복된 경우 확인

				var existingList = $('#mtiCode').val();															//새로 추가하기 전에 있던 코드 목록
				for(var i=0; i <  resultObj.mtiCodeArray.length; i++)											//새로 추가한 행이 기존에 존재하는 경우 중복 제거
				{
					for(var j=0; j< $('#mti_code_list option').length; j++){
						if(resultObj.mtiCodeArray[i] == $('#mti_code_list option:eq('+j+')').val()){
							resultObj.mtiCodeArray.splice(i);
							resultObj.mtiKorArray.splice(i);
							chk = "중복 존재";
						}
					}
				}

				for(var i = 0; i < resultObj.mtiCodeArray.length; i++)							//선택한 행의 갯수만큼
				{
					appendHtml += '<option value='+resultObj.mtiCodeArray[i]+'>';				//선택한 품목 추가
					appendHtml += resultObj.mtiKorArray[i];
					appendHtml += '</option>';
				}

				$('#mti_code_list').append(appendHtml);											//option 입력
				$('#mtiCode').val(resultObj.mtiCodeArray);												//선택한 품목코드 값 입력

// 				$('#mtiCode').append(resultObj.mtiCodeArray);
// 				$('#mti_code_list').append(resultObj.mtiKorArray);
			}
		});

	}

	function countryLayerOpen(){																//주력시장팝업
		global.openLayerPopup({
				popupUrl : '/tradeSOS/com/popup/countrySearch.do'
			, callbackFunction : function(resultObj) {
				var appendHtml = "";
				var chk = "";																					//중복된 경우 확인

				var existingList = $('#ctrCode').val();															//새로 추가하기 전에 있던 코드 목록
				for(var i=0; i <  resultObj.ctrCodeArray.length; i++)											//새로 추가한 행이 기존에 존재하는 경우 중복 제거
				{
					for(var j=0; j< $('#ctr_code_list option').length; j++){
						if(resultObj.ctrCodeArray[i] == $('#ctr_code_list option:eq('+j+')').val()){
							resultObj.ctrCodeArray.splice(i);
							resultObj.ctrNameArray.splice(i);
							chk = "중복 존재";
						}
					}
				}

				for(var i=0; i <  resultObj.ctrCodeArray.length; i++)											//중복행 제외 후 추가
				{
					appendHtml += '<option value='+resultObj.ctrCodeArray[i]+'>';								//선택한 품목 추가
					appendHtml += resultObj.ctrNameArray[i];
					appendHtml += '</option>';
				}

				if(chk != "")																					//중복행이 존재한 경우
				{
					alert("중복을 제외하고 추가 되었습니다.");
				}

				$('#ctr_code_list').append(appendHtml);															//선택한 값 option 입력
				$('#ctrCode').val(resultObj.ctrCodeArray);														//코드값 입력

			}
		});

		$('#searchRelCodePop').val('');
		$('#searchPRelNmPop').val('');
	}

	// 컨설턴트 팝업
	function openLayerConsultantPop(){
		global.openLayerPopup({
			popupUrl : '/tradeSOS/com/popup/consultantSearch.do'
			, success : function(data){
				alert("chk:",data);
			}
		});
	}

	// 증명사진 등록
	 function setPhoto(event) {
		var reader = new FileReader();
		reader.onload = function(event) {
			var img = document.createElement("img");
			img.setAttribute("src", event.target.result);
			var imgBox = document.querySelector("#photoBox");
			$(imgBox).html('');
			imgBox.appendChild(img)
		};
		reader.readAsDataURL(event.target.files[0]);
	}
</script>
<script type="text/javascript" src="/js/tradeSosComm.js"></script>

<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_submit();">수정</button>
	</div>
</div>

<!-- 컨설턴트/전문가 관리 - 무역현장자문위원 상세 -->
<div class="page_tradesos">
	<form name="registForm" id="registForm" method="post" encType="multipart/form-data">
		<input type="hidden" id="topMenuId" name="topMenuId" value="" />
		<input type="hidden"  id="procType" name="procType" value="U" />
		<input type="hidden" id="expertGrp" name="expertGrp" value="">
		<div class="cont_block">
			<!-- 타이틀 영역 -->
			<div class="tit_bar">
				<h3 class="tit_block">신청 정보</h3>
			</div>
			<table class="formTable">
				<colgroup>
					<col style="width:12%">
					<col>
					<col style="width:12%">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">증명사진</th>
						<td colspan="3">
							<div class="form_file form_img">
		<%--						<input type="file" id="imageAdd" name="expertImage" accept="image/*"  class="file_input_hidden" onchange="setPhoto(event);"/>--%>
								<input type="hidden" id="attachSeqNo" name="attachSeqNo" value="${!empty resultFile.attachSeqNo ? resultFile.attachSeqNo : "0"}"/>
								<input type="hidden" id="attachDocumId" name="attachDocumId" value="${!empty resultFile.attachDocumId ? resultFile.attachDocumId : "0"}"/>
								<figure id="photoBox" class="photo_img">
									<c:choose>
										<c:when test="${!empty resultFile}">
											<img src="<c:out value="/cmm/fms/getMemberImage.do?attachDocumId=${resultFile.attachDocumId}&attachSeqNo=${resultFile.attachSeqNo}"/>" alt="" style="width: 108px;height: 144px;">
										</c:when>
										<c:otherwise>
											<img src="/images/admin/defaultImg.jpg" alt="" class="img_size">
										</c:otherwise>
									</c:choose>
								</figure>
								<label class="file_btn">
									<input type="file"  id="imageAdd" name="pictureFiles" accept="image/*" onchange="setPhoto(event);">
									<span class="btn_tbl mt-5">사진등록</span>
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">이름</th>
						<td colspan="3">
							<input type="text" id="name" name="name" class="form_text" value="<c:out value="${resultData.name}"/>" readonly/>
							<input type="text" id="expertId" name="expertId" class="form_text" value="<c:out value="${resultData.expertId}"/>" readonly/>
							<c:if test="${searchVO.procType eq 'I'}">
								<button type="button" class="btnSchOpt find" onclick="openLayer('searchPop')">검색</button>
							</c:if>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td>
							<input type="hidden" id="tel" name="tel" value="<c:out value="${resultData.tel}"/>"/>
							<div class="form_row" style="width:300px;">
								<c:choose>
									<c:when test="${fn:length(resultData.tel) eq 10}">
										<input type="text" id="tel1"  class="form_text"  value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
										<input type="text" id="tel2"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,3,6)}"/>" maxlength="4" numberOnly>
										<input type="text" id="tel3"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,6,10)}"/>" maxlength="4" numberOnly>
									</c:when>
									<c:when test="${fn:length(resultData.tel) eq 11}">
										<input type="text" id="tel1"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,0,3)}"/>" maxlength="3" numberOnly>
										<input type="text" id="tel2"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,3,7)}"/>" maxlength="4" numberOnly>
										<input type="text" id="tel3"  class="form_text" value="<c:out value="${fn:substring(resultData.tel,7,11)}"/>" maxlength="4" numberOnly>
									</c:when>
									<c:otherwise>
										<input type="text" id="tel1"  class="form_text" value="" maxlength="3" numberOnly>
										<input type="text" id="tel2"  class="form_text" value="" maxlength="4" numberOnly>
										<input type="text" id="tel3"  class="form_text" value="" maxlength="4" numberOnly>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
						<th scope="row">입사년도</th>
						<td>
							<c:set var="cYear" value="${fn:split(today,'-')[0]}"/>
							<c:set var="cMonth" value="${fn:split(today,'-')[1]}"/>
							<c:set var="workYear" value="${!empty resultData.workStartYear ?  fn:substring(resultData.workStartYear,0,4) : ''}"/>
							<c:set var="workMonth" value="${!empty resultData.workStartYear ?  fn:substring(resultData.workStartYear,4,6) : ''}"/>

							<input type="hidden" name="workStartYear" id="workStartYear" value="${resultData.workStartYear}"/>
							<select id="work_start_year_temp" class="form_select">
								<option value="">전체</option>
								<c:forEach begin="0" end="10" var="item" step="1">
									<option value="<c:out value="${cYear-item}" />" <c:if test="${workYear eq (cYear-item)}">selected</c:if>>
										<c:out value="${cYear-item}" />
									</option>
								</c:forEach>
							</select>
							<select id="work_start_month_temp" class="form_select">
								<option value="">선택</option>
								<c:forEach begin="1" end="12" var="idx" varStatus="status">
									<fmt:formatNumber var="no" minIntegerDigits="2" value="${status.count}" type="number"/>
									<option value="<c:out value="${no}"/>" <c:if test="${workMonth eq no}">selected</c:if>><c:out value="${no}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td>
							<input type="hidden" id="email" name="email" value="${resultData.email}">
							<div class="flex align_center">
								<c:choose>
									<c:when test="${!empty resultData.email}">
										<c:set var="emailSplit" value="${fn:split(resultData.email,'@')}"/>
										<input type="text" id="email1" class="form_text" value="${emailSplit[0]}">
										<div class="spacing">@</div>
										<input type="text" id="email2" class="form_text" value="${emailSplit[1]}">
									</c:when>
									<c:otherwise>
										<input type="text" id="email1" class="form_text">
										<div class="spacing">@</div>
										<input type="text" id="email2" class="form_text">
									</c:otherwise>
								</c:choose>
							</div>
						</td>
						<th scope="row">소재지</th>
						<td>
							<select name="region" id="region" class="form_select">
								<option value="">전체</option>
								<c:forEach items="${regionList}" var="item" varStatus="status">
									<option value="${item.cdId}" <c:if test="${resultData.region eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">활동기간</th>
						<td>
							<div class="group_datepicker">
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="sStartDate" name="contractFrDt" value='<c:out value="${resultData.contractFrDt}"/>' class="txt datepicker" placeholder="시작일" title="조회시작일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyStartDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="clearDate('sStartDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
								<div class="spacing">~</div>
								<!-- datepicker -->
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="sEndDate" name="contractToDt" value='<c:out value="${resultData.contractToDt}"/>' class="txt datepicker" placeholder="종료일" title="조회종료일자입력" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
										<input type="hidden" id="dummyEndDate" value="" />
									</span>
									<!-- clear 버튼 -->
									<button type="button" class="ml-8" onclick="clearDate('sEndDate');"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
								</div>
							</div>
						</td>
						<th scope="row">활동여부</th>
						<td>
							<label class="label_form">
								<input type="radio" name="stYn" class="form_radio" id="radio2_1" value="N" <c:if test="${empty resultData.stYn or (!empty(resultData.stYn) and resultData.stYn eq 'N')}">checked="checked"</c:if>>
								<span class="label">활동</span>
							</label>
							<label class="label_form">
								<input type="radio" name="stYn" class="form_radio" id="radio2_2" value="Y" <c:if test="${!empty(resultData.stYn) and resultData.stYn eq 'Y'}">checked="checked"</c:if>>
								<span class="label">활동종료</span>
							</label>
						</td>
					</tr>
					<tr>
						<th scope="row">전문품목</th> <%--mti--%>
						<td>
							<input type="hidden" id="mtiCode" name="mtiCode"/>
							<select id="mti_code_list" size="3" class="form_select w80p" style="height: 90px;">
								<c:out value="${resultData.mtiOptionHtml}" escapeXml="false"/>
							</select>
							<div class="btn_vertical">
								<button type="button" class="btn_tbl" onclick="openLayerItemPop();" title="추가">추가</button>
								<button type="button" class="btn_tbl_border" onclick="mtiCodeDel()" title="삭제">삭제</button>
							</div>
						</td>
						<th scope="row">주력 해외시장</th> <%--ctr--%>
						<td>
							<input type="hidden" name="ctrCode" id="ctrCode"/>
							<select name="ctr_code_list" id="ctr_code_list" size="3" class="form_select w80p" style="height: 90px;">
								<c:out value="${resultData.ctrOptionHtml}" escapeXml="false"/>
							</select>
							<div class="btn_vertical">
								<button type="button" class="btn_tbl" onclick="countryLayerOpen();" title="추가">추가</button>
								<button type="button" class="btn_tbl_border" onclick="ctrCodeDel();" title="삭제">삭제</button>
							</div>
						</td>
					</tr>
				<!-- 	<tr>
						<th scope="row">품목군</th>
						<td colspan="3">
							<ul class="inp_list divide5">
								<li><label for="item_type1"><input type="checkbox" id="item_type1"> 해외바이어 발굴</label></li>
								<li><label for="item_type2"><input type="checkbox" id="item_type2"> 무역지원·협회사업 소개</label></li>
								<li><label for="item_type3"><input type="checkbox" id="item_type3"> 계약서검토</label></li>
								<li><label for="item_type4"><input type="checkbox" id="item_type4"> 해외바이어 상담지원</label></li>
								<li><label for="item_type5"><input type="checkbox" id="item_type5"> 물류·통관</label></li>
								<li><label for="item_type6"><input type="checkbox" id="item_type6"> 외환·환리스크</label></li>
								<li><label for="item_type7"><input type="checkbox" id="item_type7"> FTA·원산지 증명</label></li>
								<li><label for="item_type8"><input type="checkbox" id="item_type8"> ITEM ·사업타당성 검토</label></li>
								<li><label for="item_type9"><input type="checkbox" id="item_type9"> 해외투자</label></li>
								<li><label for="item_type10"><input type="checkbox" id="item_type10"> 해외인증·규격</label></li>
								<li><label for="item_type11"><input type="checkbox" id="item_type11"> 세무·회계</label></li>
								<li><label for="item_type12"><input type="checkbox" id="item_type12"> 관세환급·HS분류</label></li>
								<li><label for="item_type13"><input type="checkbox" id="item_type13"> 무역사기 대응</label></li>
								<li><label for="item_type14"><input type="checkbox" id="item_type14"> 수출입 지원제도 소개</label></li>
								<li><label for="item_type15"><input type="checkbox" id="item_type15"> 전자상거래</label></li>
								<li><label for="item_type16"><input type="checkbox" id="item_type16"> 해외시장 정보</label></li>
								<li><label for="item_type17"><input type="checkbox" id="item_type17"> 신용장·대금결제</label></li>
								<li><label for="item_type18"><input type="checkbox" id="item_type18"> 수출입 절차</label></li>
								<li><label for="item_type19"><input type="checkbox" id="item_type19"> 무역실무 분쟁 대응</label></li>
								<li><label for="item_type20"><input type="checkbox" id="item_type20"> 인사·노무</label></li>
							</ul>
						</td>
					</tr>  -->
					<tr>
						<th scope="row">자문 우수사례</th>
						<td colspan="3">
							<textarea id="bestAdvisoryCase" name="bestAdvisoryCase" rows="3" class="form_textarea"><c:out value="${resultData.bestAdvisoryCase}"/></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">학력</th>
						<td colspan="3">
							<textarea id="scholar" name="scholar" rows="3" class="form_textarea"><c:out value="${resultData.scholar}"/></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">자격증</th>
						<td colspan="3">
							<textarea id="license" name="license" rows="3" class="form_textarea"><c:out value="${resultData.license}"/></textarea>
						</td>
					</tr>
					<tr id="eduClass">
						<th scope="row">주요경력</th>
						<td colspan="3">
							<input type="hidden" name="careerMaxIndex" id="careerMaxIndex" value="<c:out value="${!empty resultData ? resultData.careerMaxIndex : '0'}"/>">
							<div class="addInput" <%--id="careerBox"--%>>
								<c:choose>
									<c:when test="${fn:length(careerList) > 0}">
										<c:forEach items="${careerList}" var="item" varStatus="i">
											<div class="add_line">
												<input type="text" id="careerYearArr${i.index}" name="careerYearArr" class="form_text careerYearArr" value="${item.careerYear}">
												<input type="text" id="careerContentArr${i.index}" name="careerContentArr" class="form_text w40p careerContentArr" value="${item.careerContent}">
												<c:if test="${i.index eq 0}">
													<button type="button" class="btn_tbl" onclick="addLine(this);" title="추가">추가</button>
												</c:if>
												<c:if test="${i.index ne 0}">
													<button type="button" class="btn_tbl_border" onclick="deleteRow(this);" title="삭제">삭제</button>
												</c:if>
											</div>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<div class="add_line">
											<input type="text" id="careerYearArr<c:out value="${resultData.careerMaxIndex}"/>" name="careerYearArr" class="form_text" value="">
											<input type="text" id="careerContentArr<c:out value="${resultData.careerMaxIndex}"/>" name="careerContentArr" class="form_text w40p" value="">
											<button type="button" class="btn_tbl" onclick="addLine(this);" title="추가"></button>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
					</tr>
				</tbody>
			</table><!-- // 무역현장자문위원 상세 테이블-->
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	jQuery(document).ready(function(){
		$('.datepicker').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString) {
				var inputName = $(this).attr('name');
				$('#' + inputName).val(dateString);

				$('label[for="all"]').css('background', '#fff');
				$('label[for="commCode_01"]').css('background', '#fff');
				$('label[for="commCode_02"]').css('background', '#fff');

				fn_dateChked(inputName);
			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});
	});

	$("input:text[numberOnly]").on({
		keyup: function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		},
		focusout : function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		}
	});

	//
	// function mySheet3_OnClick(Row,Col,Value){
	// 	if(Row > 0){
	// 		var rowData = mySheet3.GetRowData(Row);
	// 		$('#name').val(rowData['memberNm']);
	// 		$('#expertId').val(rowData['memberId']);
	// 		$('#email').val(rowData['emailAddr']);
	// 		$('#email1').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[0] : '');
	// 		$('#email2').val(rowData['emailAddr'] != '' ? rowData['emailAddr'].split('@')[1] : '');
	// 		if(rowData['handTel'] != ''){
	// 			$('#tel').val(rowData['handTel']);
	// 			if(rowData['handTel'].length = 10){
	// 				$('#tel1').val(rowData['handTel'].substr(0,3));
	// 				$('#tel2').val(rowData['handTel'].substr(3,4));
	// 				$('#tel3').val(rowData['handTel'].substr(7,4));
	// 			}else if(rowData['handTel'].length = 11){
	// 				$('#tel1').val(rowData['handTel'].substr(0,3));
	// 				$('#tel2').val(rowData['handTel'].substr(3,3));
	// 				$('#tel3').val(rowData['handTel'].substr(6,4));
	// 			}
	// 		}
	// 		closePop('searchPop');
	// 	}
	// }


	function mtiCodeDel(){											//전문분야 삭제
		var selectedObj = $('#mti_code_list option:selected');
		if(selectedObj.length <= 0){								//삭제할 전문분야 선택 하지 않은 경우
			alert('삭제할 전문분야를 선택해주세요');
			return false;
		}else{														//삭제할 전문분야 존재시 해당 값 삭제
			$('#mti_code_list option:selected')[0].remove();
			$('#mtiCode').val();
		}
	}

	/**====================품목 END====================**/


	/**====================국가====================**/
	function ctrCodeDel(){											//주력 해외시장 삭제
		var selectedObj = $('#ctr_code_list option:selected');
		if(selectedObj.length <= 0){								//삭제할 주력 해외시장 선택 하지 않은 경우
			alert('삭제할 국가를 선택해주세요');
			return false;
		}else{														//삭제할 주력 해외시장 존재시 해당 값 삭제
			$('#ctr_code_list option:selected')[0].remove();
			$('#ctrCode').val();
		}
	}
	/**====================국가 END====================**/

	function fn_dateChked(name) {
		var form = eval("document.registForm");
		var frDt = form.contractFrDt.value;
		var toDt = form.contractToDt.value;

		var cFromDate = new Date(frDt.replace(/\./g, "/"));
		var cToDate = new Date(toDt.replace(/\./g, "/"));

		if(name == 'contractFrDt') {
			if( cToDate < cFromDate) {
				alert("활동시작일자가 종료일자보다 큽니다.")
				form.contractFrDt.value = "";
				return true;
			}
		}

		if(name == 'contractToDt') {
			if( cToDate < cFromDate) {
				alert("활동종료일자가 시작일자보다 큽니다.")
				form.contractToDt.value = "";
				return true;
			}
		}

	}

	function fn_submit(){
		var form = eval("document.registForm");

		// 오늘 년,도 구하기
		var now = new Date();
		var now_year = now.getFullYear();
		var now_month = now.getMonth()+1;


		var weekArray = new Array();
		var itemType3Array = new Array();
		var mtiCodeArray = new Array();
		var ctrCodeArray = new Array();

		var checkValidate = true;

		//입사년도
		if($('#work_start_year_temp').val() != '' && $('#work_start_month_temp').val() != '') {
			var wsy_year = $('#work_start_year_temp').val();
			var wsy_month = $('#work_start_month_temp').val();
			if (now_year < wsy_year) {
				alert("입사년도는 " + now_year + now_month + "보다 클수 없습니다.");
				return;
			} else if (now_year == wsy_year && now_month < wsy_month) {
				alert("입사년도는 " + now_year + now_month + "보다 클수 없습니다.");
				return;
			}
		}

		$('#work_start_year').val($('#work_start_year_temp').val()+ $('#work_start_month_temp').val());

		var frDtTemp = form.contractFrDt.value.replaceAll('-','');
		var toDtTemp = form.contractToDt.value.replaceAll('-','');

		if(form.contractFrDt.value == ""){
			alert("계약시작일자를 선택하셔야 합니다.");
			form.sStartDate.focus();
			return;
		}else if(form.contractToDt.value == ""){
			alert("계약종료일자를 선택하셔야 합니다.");
			form.contractToDt.focus();
			return;
		}else if(frDtTemp > toDtTemp){
			alert("계약 시작일자가 종료일자보다 큽니다.");
			form.contractFrDt.focus();
			return;
		}else if(form.region.value == ""){
			alert("소재지를 선택하셔야 합니다.");
			form.region.focus();
			return;
		}


		var mtiList = form.mti_code_list;
		var mtiListArr = "";

		if( mtiList.length <= 0){
			alert('전문품목을 선택해주세요.');
			return ;
		}

		var ctrList = form.ctr_code_list;
		var ctrListArr = "";

		if( ctrList.length <= 0){
			alert('주력 해외시장를 선택해주세요.');
			return ;
		}

		if ($('#eduClass td:eq(0) .addInput .add_line').length > 0) {
			$('#eduClass td:eq(0) .addInput .add_line').each(function(i,e){

				if ($('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[class="form_text careerYearArr"]').val() == '') {
					alert((i + 1) + '번째 년도를 입력해주세요.');
					$('#eduClass .add_line:eq('+i+') input[name=careerYearArr]').focus();
					checkValidate = false;

					return false;
				}

				if ($('#eduClass td:eq(0) .addInput .add_line:eq(' + i + ') input[class="form_text w40p careerContentArr"]').val() == '') {
					alert((i + 1) + '번째 경력를 입력해주세요.');
					$('#eduClass .add_line:eq('+i+') input[name=careerContentArr]').focus();
					checkValidate = false;
					return false;
				}
			});
		}

		if(checkValidate){

			//전화번호
			if($('#tel1').val() != '' && $('#tel2').val() != ''  && $('#tel3').val() != ''){
				$('#tel').val('');
				$('#tel').val($('#tel1').val()+$('#tel2').val()+$('#tel3').val())
			}
			//이메일
			if($('#email1').val() != '' && $('#email2').val() != ''){
				$('#email').val();
				$('#email').val($('#email1').val()+'@'+$('#email2').val());
			}

			//품목
			$('#mti_code_list option').each(function(){
				mtiCodeArray.push($(this).val());
				$('#mtiCode').val(String(mtiCodeArray.join()));
			});

			//국가
			$('#ctr_code_list option').each(function(){
				ctrCodeArray.push($(this).val());
				$('#ctrCode').val(String(ctrCodeArray.join()));
			});

			form.expertGrp.value="012";

			if (confirm('수정 하시겠습니까?')) {
				global.ajaxSubmit($('#registForm'), {
					type : 'POST'
					, url : '<c:url value="/tradeSOS/com/consultantMemberProc.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if (data.FLAG) {
							window.location.reload();
						} else {
							alert(data.MESSAGE);
							return false;
						}
			        }
				});
			}
		}
	}

	function clearDate(targetId) {
		$("#"+targetId).val("");
	}
</script>
