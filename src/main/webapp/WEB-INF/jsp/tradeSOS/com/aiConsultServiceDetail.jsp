<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<link type="text/css" href="<c:url value='/css/tradeproaiconsult.css' />" rel="stylesheet" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<form id="aiConsultForm" name="aiConsultForm" method="post">
<input type="hidden" id="rtnPageType" name="rtnPageType" value="${params.rtnPageType}" />
<input type="hidden" id="currentPageNo" name="currentPageNo" value="${params.currentPageNo}" />
<input type="hidden" id="aiNo" name="aiNo" value="<c:out value="${params.aiNo}" />" />
<input type="hidden" id="stringAiConsultList" name="stringAiConsultList" value="${params.stringAiConsultList}" />
<input type="hidden" id="apiCallYn" name="apiCallYn" value="N" />
<input type="hidden" id="orderCol" name="orderCol" value="${params.orderCol}" />
<input type="hidden" id="reqContents" name="reqContents" value="${params.reqContents}" />
<input type="hidden" id="searchBtnType" name="searchBtnType" value="${params.searchBtnType}" />
<input type="hidden" id="consultTypeCd" name="consultTypeCd" value="${params.consultTypeCd}" />
<input type="hidden" id="startDate" name="startDate" value="${params.startDate}" />
</form>
<div class="contents">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상담 분야</th>
				<td><span id="detailCategoryNm"></span></td>
			</tr>
			<tr>
				<th scope="row">등록일</th>
				<td><span id="detailReqCreDt"></span></td>
			</tr>
		</tbody>
	</table>
</div>
<div class="contents mt-20">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">질의 제목</th>
				<td><span id="detailReqTitle"></span></td>
			</tr>
			<tr>
				<th scope="row"><span>Q</span> 질의 내용</th>
				<td><span id="detailReqContent"></span></td>
			</tr>
			<tr>
				<th scope="row">답변 전문가</th>
				<td><span id="detailAnsExpertNm"></span></td>
			</tr>
			<tr>
				<th scope="row"><span>A</span> 답변 내용</th>
				<td><span id="detailAnsContent"></span></td>
			</tr>
		</tbody>
	</table>
</div>
<form action="">
<div class="starRatingArea mt-20" style="display: none;">
	<fieldset>
		<legend>질문에대한 답변 만족도 평가</legend>
		<p style="font-size: 20px;">입력하신 질문에 대한 추천 정보에 만족하셨나요?</p>
		<div class="starRatingIn">
			<input type="radio" id="saLevelCode01" name="saLevelCode" value="01" /><label for="saLevelCode01" class="starb1 on"><span style="font-weight: bold;">1점</span></label>
			<input type="radio" id="saLevelCode02" name="saLevelCode" value="02" /><label for="saLevelCode02" class="starb2 on"><span style="font-weight: bold;">2점</span></label>
			<input type="radio" id="saLevelCode03" name="saLevelCode" value="03" /><label for="saLevelCode03" class="starb3 on"><span style="font-weight: bold;">3점</span></label>
			<input type="radio" id="saLevelCode04" name="saLevelCode" value="04" /><label for="saLevelCode04" class="starb4 on"><span style="font-weight: bold;">4점</span></label>
			<input type="radio" id="saLevelCode05" name="saLevelCode" value="05" checked="checked" /><label for="saLevelCode05" class="starb5"><span style="font-weight: bold;">5점</span></label>
		</div>
		<div>
			<textarea id="userRemark" name="userRemark" rows="5" cols="30" class="form_textarea" placeholder="추가 의견 및 건의 사항이 있다면 입력해 주세요."></textarea>
			<button type="button" onclick="consultSatisfaction();" class="btn btn_primary">등록</button>
		</div>
	</fieldset>
</div> 
</form>
<script type="text/javascript">
	$(document).ready(function(){
		consultServiceDetail();
		
		if (!getAiConsultSatisfactionYn()) {
			setShowSatisfaction();
		}
	});

	// 별점주기
	// 별점1
	$('.starb1').on('click', function(){
		$('.starb2, .starb3, .starb4, .starb5').removeClass('on');
	});
	// 별점2
	$('.starb2').on('click', function(){
		$('.starb1').addClass('on');
		$('.starb3, .starb4, .starb5').removeClass('on');
	});
	// 별점3
	$('.starb3').on('click', function(){
		$('.starb1, .starb2').addClass('on');
		$('.starb4, .starb5').removeClass('on');
	});
	// 별점4
	$('.starb4').on('click', function(){
		$('.starb1, .starb2, .starb3').addClass('on');
		$('.starb5').removeClass('on');
	});
	// 별점5
	$('.starb5').on('click', function(){
		$('.starb1, .starb2, .starb3, .starb4').addClass('on');
	});
 
	function setHideSatisfaction() {
		$('.starRatingArea').css('display', 'none');
	}

	function setShowSatisfaction() {
		$('.starRatingArea').css('display', 'block');
	}

	function consultSatisfaction() {
		global.ajax({
			url : '<c:url value="/tradeSOS/com/saveAiConsultSatisfaction.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				saLevelCode : $('input[name="saLevelCode"]:checked').val()
				, userRemark : $('#userRemark').val()
			}
			, async : true
			, spinner : true
			, success : function(data){
				if (data != null && data['result'] == -1) {
					alert(data['errorMsg']);
					
					return;
				}
				
				alert('만족도 평가가 완료 되었습니다.');
				
				setHideSatisfaction();
				setAiConsultSatisfactionYn();
			}
		});
	}

	function setAiConsultSatisfactionYn() {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + 1);
		document.cookie = 'aiConsultSatisfactionYn=true; path=' + location.href + '; expires=' + todayDate.toGMTString() + ';';
	}

	function getAiConsultSatisfactionYn() {
		return document.cookie.indexOf('aiConsultSatisfactionYn') > -1;
	}

	/* AI 검색 목록 상세 */
	function consultServiceDetail() {
		var aiNo = $('#aiNo').val();
		
		if (aiNo == '') {
			alert('잘못된 접근입니다.');
			
			return false;
		}
		
		global.ajax({
			url : '<c:url value="/tradeSOS/com/consultServiceDetail.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				aiNo : aiNo
			}
			, async : true
			, spinner : true
			, success : function(data){
				$(data.result).each(function(){
					$('#detailCategoryNm').text(this.categoryNm == null ? '-' : this.categoryNm);
					$('#detailReqTitle').text(this.reqTitle);
					$('#detailReqContent').html(unescapeHtml(this.reqContent));
					$('#detailReqCreDt').text(this.reqCreDt);
					
					if (this.ansExpertNm == null || this.ansExpertNm == '') {
						$('#detailAnsExpertNm').text('-');
					} else {
						$('#detailAnsExpertNm').text(this.ansExpertNm);
					}
					
					$('#detailAnsContent').html(unescapeHtml(this.ansContent));
				});
			}
		});
	}

	function unescapeHtml(str) {
		return str
			.replace(/&amp;/g, '&')
			.replace(/&lt;/g, '<')
			.replace(/&gt;/g, '>')
			.replace(/&quot;/g, '\"')
			.replace(/&apos;/g, "'")
			.replace(/\n/g, '<br/>');
	}
	
	function goList() {
		var rtnPageType = $('#rtnPageType').val();
		
		var f = document.aiConsultForm;
		if (rtnPageType == 'top5') {
			if (location.href.indexOf('tradeSOSAi') > -1) {
				f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultService.do" />';
			} else {
				f.action = '<c:url value="/tradeSOS/com/aiConsultService.do" />';
			}
		} else {
			if (location.href.indexOf('tradeSOSAi') > -1) {
				f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
			} else {
				f.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
			}
		}	
		f.submit();
	}
</script>