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
</div>
<form name="aiConsultForm" method="post" onsubmit="return false;">
<input type="hidden" name="apiCallYn" value="Y" />
<input type="hidden" id="searchBtnType" name="searchBtnType" />
<input type="hidden" id="aiNo" name="aiNo" />
<input type="hidden" id="pblcConsultId" name="pblcConsultId" />
<input type="hidden" name="rtnPageType" value="top5" />
<!-- 검색페이지 -->
<!-- AI 추천 상담 사례 검색영역 -->
<div class="aiConsult_searchBox type2">
	<fieldset>
		<legend>AI 추천 상담 사례 검색</legend>
		<textarea id="reqContents" name="reqContents" rows="5" cols="30" maxlength="500" onkeypress="if (event.keyCode == 13) {splitSearchType('A'); return false;}" placeholder="AI가 최적의 전문가와 상담사례를 추천 해드립니다."></textarea>
		<p class="btn_recom">
			<button type="button" onclick="splitSearchType('A');" style="text-align: center;">AI 추천<br />받기</button>
			<button type="button" class="click_add_on2" style="text-align: center;">추천 옵션<br />더보기</button>
		</p>
		<ul class="ai_search_box" style="display: none;">
			<li>
				<label for="ai_search_input">질의 입력</label>
				<input type="text" id="boxReqContents" onkeypress="if (event.keyCode == 13) {splitSearchType('S'); return false;}" title="질의 입력" placeholder="궁금한 무역 상담 질의를 입력하시면, AI가 베스트 답변을 추천드립니다." />
			</li>
			<li>
				<label>상담분야<br />설정</label>
				<ul class="rd_select">
					<li>
						<label>
							<input type="radio" name="consultTypeCd" value="000" checked="checked" />
							<span style="cursor: pointer;">전체</span>
						</label>
					</li>
					<c:forEach var="list" items="${consultTypeList}" varStatus="status">
						<li>
							<label>
								<input type="radio" name="consultTypeCd" value="${list.consultTypeCd}" />
								<span style="cursor: pointer;">${list.consultTypeNm}</span>
							</label>
						</li>
					</c:forEach>
				</ul>
			</li>
			<li>
				<label for="se_date_all">기간 설정</label>
				<ul class="rd_select box">
					<li>
						<label>
							<input type="radio" name="startDate" value="" checked="checked" />
							<span style="cursor: pointer;">모든 날짜</span>
						</label>
					</li>
					<c:forEach var="ndate" items="${nDateArr}" varStatus="status">
						<li>
							<label>
								<input type="radio" name="startDate" value="${ndate}" />
								<span style="cursor: pointer;">${nDateNmArr[status.index]}</span>
							</label>
						</li>
					</c:forEach>
				</ul>
				<button type="button" class="rd_btn point" onclick="splitSearchType('S');">AI 추천 받기</button>
				<button type="button" id="closeBoxBtn" class="rd_btn">닫기</button>
			</li>
		</ul>
	</fieldset>
</div>
</form>
<!-- //AI 추천 상담 사례 검색영역 -->
<!-- 서비스 이용 방법 안내 -->
	<div class="aiConsult_infoBox type2 cont_block">
		<div class="tit_bar">
			<h4 class="tit_block">서비스 이용 방법 안내</h4>
		</div>
		<ol>
			<li>
				<div>
					<span class="icon_step">step1</span>
					<strong>질문입력</strong>
					<p>궁금하신 사항을<br /> 입력하세요.</p>
				</div>
			</li>
			<li>
				<div>
					<span class="icon_step">step2</span>
					<strong>AI 최적의 전문가와<br />상담 사례 추천</strong>
					<p>입력하신 질문을 AI가 인식하고,<br /> 이와 연관된 최적의<br /> 전문가와 상담 사례를<br /> 추천 해 드립니다.</p>
				</div>
			</li>
			<li>
				<div>
					<span class="icon_step">step3</span>
					<strong>추천 정보 확인</strong>
					<p>AI가 추천해드리는<br /> 각 분야별 최적의 전문가와<br /> 상담 사례를 확인하세요.<br class="m" /><br />제목을 누르시면 원문을<br /> 확인하실 수 있습니다.</p>
				</div>
			</li>
		</ol>
		<div class="info_Btm mt-40">
			<p>서비스 이용 후 만족도 평가(원문보기 페이지 위치) 참여 부탁드립니다.</p>
		</div>
	</div>
	<!-- //서비스 이용 방법 안내 -->
	
	<div class="cont_block">
		<div class="tit_bar">
			<h4 class="tit_block">많이 본 상담 내역 TOP 5</h4>
		</div>
		<div class="page_openConsult">
			<div class="openConsultWrap">
				<div id="topFiveConsultList" class="openConsult"></div>
			</div>
		</div>
	</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		// 검색영역 포커스시 초기 text지우기
		$('textarea').on('focus', function(){
			$(this).addClass('on')
			$(this).attr('placeholder', '');
		});
			
		$('textarea').on('blur', function(){
			$(this).removeClass('on')
			$(this).attr('placeholder', 'AI가 최적의 전문가와 상담사례를 추천 해드립니다.');
		});
		
		topFiveConsultList();
	});

	// 단일객채 토글 클래스2(부모에게 ON클래스 전달)
	$(document).on('click', '.click_add_on2', function(){
		var thisOnParent = $(this).parent();
		thisOnParent.toggleClass('on');
		
		return false;
	});

	$(document).on('click', '.ai_search_box > li > button:last', function(){
		$('.search_top .ai_search_box').fadeOut(500);
		$('.btn_recom').removeClass('on');
		
		return false;
	});
	
	$('#reqContents').on('keyup', function(){
		$('#boxReqContents').val($(this).val());
	});
	
	$('#boxReqContents').on('keyup', function(){
		$('#reqContents').val($(this).val());
	});
	
	$('#moreAddBtn,#closeBoxBtn').on('click', function(){
		if ($('#moreAddBtn').hasClass('on')) {
			$('input:radio[name="consultTypeCd"]').eq(0).prop('checked', true);
			$('input:radio[name="startDate"]').eq(0).prop('checked', true);
		}
	});
	
	function topFiveConsultList() {
		// 로딩이미지 시작
		$('#loading_image').show();
		
		global.ajax({
			url : '<c:url value="/tradeSOS/com/topFiveConsultList.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {}
			, async : true
			, spinner : true
			, success: function (data){
				// 로딩이미지 종료
				$('#loading_image').hide();
				
				var content = '';
				if (data.resultList) {
					$(data.resultList).each(function(){
						// 오픈상담
						if (this.viewTypeCode == '004') {
							content += '<a href="javascript:void(0);" onclick="goPblcDetail(' + this.reqId + ');" class="">';
						// 1:1상담
						} else {
							content += '<a href="javascript:void(0);" onclick="goDetail(' + this.aiNo + ');" class="">';
						}
						
						content += '	<dl>';
						content += '		<dt>';
						content += '			<span class="open">' + this.dataDiv + '</span>';
						content += '			<span class="category">' + this.consultTypeNm + '</span>';
						content += '			<strong class="ListTit">' + this.reqTitle + '</strong>';
						content += '			<span class="date fr">접수일 : ' + this.reqCreDt + '</span>';
						content += '		</dt>';
						content += '		<dd>';
						content += '			<div><span class="badge gray">문의</span><p class="ellipsis" style="color: #666;">' + this.reqContent + '</p></div>';
						content += '			<div><span class="badge blue">답변</span><p class="ellipsis" style="color: #666;">' + this.ansContent + '</p></div>';
						content += '		</dd>';
						content += '	</dl>';
						content += '</a>';
					});
				} else {
					content += '	<dl>';
					content += '		<dd style="text-align:center;">조회 결과가 없습니다.</dd>';
					content += '	</dl>';
				}
								
				$('#topFiveConsultList').append(content);
			}
		});
	}
	
	function goPblcDetail(pblcConsultId) {
		var f = document.aiConsultForm;
		if (location.href.indexOf('tradeSOSAi') > -1) {
			f.action = '<c:url value="/tradeSOS/com/tradeSOSAiOpenConsultDetail.do" />';
		} else {
			f.action = '<c:url value="/tradeSOS/com/aiOpenConsultDetail.do" />';
		}
		f.pblcConsultId.value = pblcConsultId;
		f.submit();
	}
	
	function splitSearchType(searchBtnType) {
		$('#reqContents, #boxReqContents').blur();
		$('#searchBtnType').val(searchBtnType);
		
		searchConsult();
	}
	
	function searchConsult() {
		var reqContents = $('#reqContents').val();
		
		var sp = reqContents.split(' ');
		if (reqContents.length < 2 || reqContents.trim() == '') {
			global.openLayerPopup({
				popupUrl : '<c:url value="/tradeSOS/com/popup/aiRequestAlertPopup.do" />'
				, params : {
					continueBtnYn : 'N'
					, pageType : 'submit'
				}
				, callbackFunction : function(resultObj){
					if (resultObj.gbn == '2') {
						var f = document.aiConsultForm;
						if (location.href.indexOf('tradeSOSAi') > -1) {
							f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
						} else {
							f.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
						}
						f.target = '_self';
						f.submit();
					}
				}
			});
		} else if (sp.length < 5) {
			global.openLayerPopup({
				popupUrl : '<c:url value="/tradeSOS/com/popup/aiRequestAlertPopup.do" />'
				, params : {
					continueBtnYn : 'Y'
					, pageType : 'submit'
				}
				, callbackFunction : function(resultObj){
					if (resultObj.gbn == '2') {
						var f = document.aiConsultForm;
						if (location.href.indexOf('tradeSOSAi') > -1) {
							f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
						} else {
							f.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
						}
						f.target = '_self';
						f.submit();
					}
				}
			});
		} else {
			var f = document.aiConsultForm;
			if (location.href.indexOf('tradeSOSAi') > -1) {
				f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceList.do" />';
			} else {
				f.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
			}
			f.target = '_self';
			f.submit();
		}
	}
	
	function goDetail(aiNo) {
		var f = document.aiConsultForm;
		if (location.href.indexOf('tradeSOSAi') > -1) {
			f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceDetail.do" />';
		} else {
			f.action = '<c:url value="/tradeSOS/com/aiConsultServiceDetail.do" />';
		}
		f.aiNo.value = aiNo;
		f.submit();
	}
</script>