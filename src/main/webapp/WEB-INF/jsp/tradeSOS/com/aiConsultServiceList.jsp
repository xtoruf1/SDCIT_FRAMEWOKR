<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<link type="text/css" href="<c:url value='/css/tradeproaiconsult.css' />" rel="stylesheet" />
<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>
<!-- 검색페이지 -->
<!-- AI 추천 상담 사례 검색영역 -->
<form id="aiConsultForm" name="aiConsultForm" method="post">
<input type="hidden" id="apiCallYn" name="apiCallYn" value="<c:out value="${empty params.apiCallYn ? 'Y' : params.apiCallYn}" />" />
<input type="hidden" id="pageType" name="pageType" value="<c:out value="${empty params.pageType ? 'submit' : params.pageType}" />" />
<input type="hidden" id="searchBtnType" name="searchBtnType" value="${params.searchBtnType}" />
<input type="hidden" id="stringAiConsultList" name="stringAiConsultList" value="${params.stringAiConsultList}" />
<input type="hidden" id="tabNo" name="tabNo" />
<input type="hidden" id="aiNo" name="aiNo" />
<input type="hidden" id="pblcConsultId" name="pblcConsultId" />
<div class="aiConsult_searchBox type2">
	<fieldset>
		<legend>AI 추천 상담 사례 검색</legend>
		<textarea id="reqContents" name="reqContents" rows="5" cols="30" maxlength="500" onkeypress="if (event.keyCode == 13) {splitSearchType('A'); return false;}" placeholder="AI가 최적의 전문가와 상담사례를 추천 해드립니다.">${params.reqContents}</textarea>
		<p class="btn_recom">
			<button type="button" onclick="splitSearchType('A');" style="text-align: center;">AI 추천<br />받기</button>
			<button type="button" class="click_add_on2" style="text-align: center;">추천 옵션<br />더보기</button>
		</p>
		<ul class="ai_search_box" style="display: none;">
			<li>
				<label for="ai_search_input">질의 입력</label>
				<input type="text" id="boxReqContents" value="${params.reqContents}" onkeypress="if(event.keyCode == 13) {splitSearchType('S'); return false;}" title="질의 입력" placeholder="궁금한 무역 상담 질의를 입력하시면, AI가 베스트 답변을 추천드립니다." />
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
								<input type="radio" name="consultTypeCd" value="${list.consultTypeCd}" <c:if test="${params.consultTypeCd eq list.consultTypeCd}">checked="checked"</c:if> />
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
							<input type="radio" name="startDate" value="00000000" checked="checked" />
							<span style="cursor: pointer;">모든 날짜</span>
						</label>
					</li>
					<c:forEach var="ndate" items="${nDateArr}" varStatus="status">
						<li>
							<label>
								<input type="radio" name="startDate" value="${ndate}" <c:if test="${params.startDate eq ndate}">checked="checked"</c:if> />
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
<div class="fake_tap_wrap">
	<!-- fake_tap_wrap start -->
	<ul class="click_select_on">
		<li class="on"><a href="javascript:void(0);" onclick="splitTab('00');">전체</a></li>
		<li><a href="javascript:void(0);" onclick="splitTab('01');">1:1 상담 사례</a></li>
		<li><a href="javascript:void(0);" onclick="splitTab('02');">오픈상담 사례</a></li>
	</ul>
</div>
<!-- fake_tap_wrap end -->
<div id="oneConsultDiv">
	<div class="tit_bar mt40">
		<h4 class="tit_block">1:1 상담 사례 추천</h4>
	</div>
	<div id="prvtConsultBoard" class="aiConsultList type2">
		<ol id="resultList">
			<li class="noData">
				<p>요청하신 검색 결과가 없습니다.</p>
			</li>
		</ol>
	</div>
</div>
<div id="openConsultDiv">
	<div class="tit_bar mt40">
		<h4 class="tit_block">오픈상담 추천</h4>
	</div>
	<div class="page_openConsult">
		<div class="openConsultWrap">
			<div id="openConsultBoard" class="openConsult type2">
				<ol id="resultList" style="border: 0px;">
					<li class="noData">
						<p>요청하신 검색 결과가 없습니다.</p>
					</li>
				</ol>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var consultTypeList = new Array();
	<c:forEach var="list" items="${consultTypeList}" varStatus="status">
		consultTypeList.push({
			consultTypeCd: '${list.consultTypeCd}'
			, consultTypeNm: '${list.consultTypeNm}'
		});
	</c:forEach>

	$(document).ready(function(){
		searchConsult();
	});

	// 단일객체 토글 클래스2(부모에게 ON 클래스 전달)
	$(document).on('click', '.click_add_on2', function(){
		var thisOnParent=$(this).parent();
		thisOnParent.toggleClass('on');

		return false;
	});

	// AI박스 닫기
	$(document).on('click', '.ai_search_box > li > button:last', function(){
		$('.search_top .ai_search_box').fadeOut(500);
		$('.btn_recom').removeClass('on');

		return false;
	});

	// 여러객채중 하나만 클래스 주기
	$(document).on('click', '.click_select_on > li', function(){
		$(this).addClass('on');
		$(this).siblings().removeClass('on');

		return false;
	});

	$('#reqContents').on('keyup', function(){
		$('#boxReqContents').val($(this).val());
	});

	$('#boxReqContents').on('keyup', function(){
		$('#reqContents').val($(this).val());
	});

	function splitTab(tabNo) {
		// 탭에 따라 목록 별 모두보기,더보기 버튼 변경처리 tabNo
		$('#tabNo').val(tabNo);
		$('#oneConsultDiv, #openConsultDiv').css('display', 'none');
		$('#linkBtnArea').hide();

		if (tabNo == '01') {
			selectAiConsultTabList('1');

			$('#oneConsultDiv').css('display', 'block');
			$('.click_select_on > li').eq(1).addClass('on');
		} else if(tabNo == '02') {
			selectAiOpenConsultTabList('1');

			$('#openConsultDiv').css('display', 'block');
			$('.click_select_on > li').eq(2).addClass('on');
		} else {
			selectAiConsultTabList('1');
			selectAiOpenConsultTabList('1');

			$('#oneConsultDiv, #openConsultDiv').css('display', 'block');
			$('.click_select_on > li').eq(0).addClass('on');
			$('#linkBtnArea').show();
		}

		$('html').scrollTop(0);
	}

	function splitSearchType(searchBtnType) {
		$('#apiCallYn').val('Y');
		$('#reqContents, #boxReqContents').blur();
		$('#searchBtnType').val(searchBtnType);

		searchConsult();
	}

	function searchConsult() {
		var pageType = $('#pageType').val();
		if (pageType != 'submit') {
			var reqContents = $('#reqContents').val();

			var sp = reqContents.split(' ');
			if (reqContents.length < 2 || reqContents.trim() == '') {
				global.openLayerPopup({
					popupUrl : '<c:url value="/tradeSOS/com/popup/aiRequestAlertPopup.do" />'
					, params : {
						continueBtnYn : 'N'
						, pageType : 'func'
					}
					, callbackFunction : function(resultObj){
						if (resultObj.gbn == '1') {
							selectConsultApiKeys();

							closeLayerPopup();
						}
					}
				});
			} else if (sp.length < 5) {
				global.openLayerPopup({
					popupUrl : '<c:url value="/tradeSOS/com/popup/aiRequestAlertPopup.do" />'
					, params : {
						continueBtnYn : 'Y'
						, pageType : 'func'
					}
					, callbackFunction : function(resultObj){
						if (resultObj.gbn == '1') {
							selectConsultApiKeys();

							closeLayerPopup();
						}
					}
				});
			} else {
				selectConsultApiKeys();
			}
		} else {
			selectConsultApiKeys();
		}
	}

	// API조회 후 저장
	var aiNoList;					// 1:1 상담 datalist
	var pblcConsultNoList;			// 오픈 상담 datalist

	function selectConsultApiKeys() {
		// 로딩이미지 시작
		$('#loading_image').show();

		var searchBtnType = $('#searchBtnType').val();
		var apiCallYn = $('#apiCallYn').val();
		var reqContents = $('#reqContents').val();
		var startDate = $('input[name="startDate"]:checked').val();
		var stringAiConsultList = $('#stringAiConsultList').val();

		// 전체
		if (searchBtnType == 'A') {
			reqContents = $('#reqContents').val();
			consultTypeCd = '000';
		// 'S'
		} else {
			reqContents = $('#boxReqContents').val();
			consultTypeCd = $('input[name="consultTypeCd"]:checked').val();
			startDate = $('input[name="startDate"]:checked').val();
		}

		var jsonParam = {
			reqContents : reqContents
			, consultTypeCd : consultTypeCd
			, startDate : startDate
			, apiCallYn : apiCallYn
			, stringAiConsultList : stringAiConsultList
		};

		// API
		global.ajax({
			url : '<c:url value="/tradeSOS/com/selectConsultApiKeys.do" />'
			, dataType : 'json'
			, contentType : 'application/json; charset=utf-8'
			, type : 'POST'
			, data : JSON.stringify(jsonParam)
			, async : true
			, spinner : true
			, success : function(data){
				// 로딩이미지 종료
				$('#loading_image').hide();

				if (data.httpError == true || data.errorMessage != null) {
					alert('AI 시스템 장애로 데이터 조회에 실패했습니다. 잠시후 다시 시도해 주세요.');
					history.back();

					return false;
				} else {
					var apiAiconsultList = JSON.parse(decodeURIComponent(data.params.stringAiConsultList));

					if (apiAiconsultList.status_code != '200') {
						alert('AI 시스템 장애로 데이터 조회에 실패했습니다. 잠시후 다시 시도해 주세요.');

						history.back();

						return false;
					}

					aiNoList = data.params.aiNoList;
					pblcConsultNoList = data.params.pblcConsultNoList;

					// 전체 : 00, 1:1상담 : 01, 오픈상담 : 02
					splitTab('00');
					$('#closeBoxBtn').click();

					$('#apiCallYn').val('N');
					$('#stringAiConsultList').val(data.params.stringAiConsultList);
				}

				$('#pageType').val('func');
			}
		});
	}

	// 1:1상담 사례
	function selectAiConsultTabList(currentPageNo) {
		var content = '';
		if (aiNoList.length > 0) {
			// 로딩이미지 시작
			$('#loading_image').show();

			if (typeof currentPageNo != 'number') {
				currentPageNo = 1;
		    }

			var jsonParam = {
		    	pageIndex : currentPageNo
		    	, aiNoList : aiNoList
			}

			global.ajax({
				url : '<c:url value="/tradeSOS/com/selectAiConsultTabList.do" />'
				, dataType : 'json'
				, contentType : 'application/json; charset=utf-8'
				, type : 'POST'
				, data : JSON.stringify(jsonParam)
				, async : true
				, spinner : true
				, success : function (data){
					// 로딩이미지 종료
					$('#loading_image').hide();

					$('#btnAiConsultPaging').remove();
					$('#prvtConsultBoard').empty();

					var paginationInfo = data.paginationInfo;

					if (data.resultList) {
						content += '<ol id="resultList">';

						$(data.resultList).each(function(){
							content += '	<li>';
							content += '		<p title="분야" class="consultField">';

							if (this.reqInflowCodeNm != '') {
								content += this.reqInflowCodeNm;
							}
							if (this.categoryNm != null && this.categoryNm != '') {
								content += ', ' + this.categoryNm;
							}

							content += '		</p>';
							content += '		<a href="javascript:void(0);" onclick="goPrvtDetail(\'' + this.aiNo + '\');" style="margin-top: 15px;" title="원문으로 이동">';
							content += '			<span>' + this.rn + '</span>';
							content += '			<strong>' + this.reqTitle + '</strong>';
							content += '		</a>';
							content += '		<span title="작성일">' + this.reqCreDt + '</span>';
							content += '		<dl>';
							content += '			<dt><span title="질문">Q</span>' + this.reqContent + '</dt>';
							content += '			<dd><span title="답변">A</span>' + this.ansContent + '</dd>';
							content += '		</dl>';
							content += '	</li>';
						});

						content += '</ol>';
					} else {
						content += '<ol id="resultList" style="border:0px;">';
						content += '	<li class="noData">';
						content += '		<p>요청하신 검색 결과가 없습니다.</p>';
						content += '	</li>';
						content += '</ol>';
					}

					var tabNo = $('#tabNo').val();

					// 전체 탭
					if (tabNo == '00') {
						content += '<button type="button" id="btnAiConsultPaging" onclick="splitTab(\'01\');" class="more_list" style="text-align: center;">모두 보기</button>';
					// 01
					} else {
						if (paginationInfo.totalPageCount > 1 && data.resultList.length != paginationInfo.totalRecordCount) {
							content += '<button type="button" id="btnAiConsultPaging" onclick="moreAiConsultTabList(' + paginationInfo.currentPageNo + ', ' + paginationInfo.totalPageCount + ');" class="more_list" style="text-align: center;">더 보기</button>';
						}
					}

					$('#prvtConsultBoard').append(content);
				}
			});
		}
	}

	function goPrvtDetail(aiNo) {
		saveAiLogInfo('003', aiNo);

		var f = document.aiConsultForm;
		if (location.href.indexOf('tradeSOSAi') > -1) {
			f.action = '<c:url value="/tradeSOS/com/tradeSOSAiConsultServiceDetail.do" />';
		} else {
			f.action = '<c:url value="/tradeSOS/com/aiConsultServiceDetail.do" />';
		}
		f.aiNo.value = aiNo;
		f.submit();
	}

	// 오픈상담 사례
	function selectAiOpenConsultTabList(currentPageNo) {
		var content = '';

		if (pblcConsultNoList.length > 0) {
			// 로딩이미지 시작
			$('#loading_image').show();

			if (typeof currentPageNo != 'number') {
				currentPageNo = 1;
		    }

			var jsonParam = {
				pageIndex : currentPageNo
				, pblcConsultNoList : pblcConsultNoList
			}

			global.ajax({
				url : '<c:url value="/tradeSOS/com/selectAiOpenConsultTabList.do" />'
				, dataType : 'json'
				, contentType : 'application/json; charset=utf-8'
				, type : 'POST'
				, data : JSON.stringify(jsonParam)
				, async : true
				, spinner : true
				, success : function (data){
					// 로딩이미지 종료
					$('#loading_image').hide();

					$('#btnAiOpenConsultPaging').remove();
					$('#openConsultBoard').empty();

					var paginationInfo = data.paginationInfo;

					if (data.resultList) {
						$(data.resultList).each(function(){
							// 상세페이지 이동
							content += '<a href="javascript:void(0);" onclick="goPblcDetail(\'' + this.reqId + '\');" class="">';
							content += '	<dl>';
							content += '		<dt>';
							content += '			<span class="category">' + this.categoryNm + '</span>';
							content += '			<strong class="ListTit">' + this.reqTitle + '</strong>';
							content += '			<span class="date fr">접수일 : ' + this.reqCreDt + '</span>';
							content += '		</dt>';
							content += '		<dd>';
							content += '			<div>';
							content += '				<span class="badge gray">문의</span>';
							content += '				<p class="ellipsis" style="color: #666;">' + this.reqContent + '</p>';
							content += '			</div>';
							content += '			<div>';
							content += '				<span class="badge blue">답변</span>';
							content += '				<p class="ellipsis" style="color: #666;">' + this.ansContent + '</p>';
							content += '			</div>';
							content += '		</dd>';
							content += '	</dl>';
							content += '</a>';
						});
					} else {
						content += '<ol id="resultList" style="border: 0px;">';
						content += '	<li class="noData">';
						content += '		<p>요청하신 검색 결과가 없습니다.</p>';
						content += '	</li>';
						content += '</ol>'
					}

					var tabNo = $('#tabNo').val();
					if (tabNo == '00') {
						content += '<button type="button" id="btnAiOpenConsultPaging" onclick="splitTab(\'02\');" class="more_list" style="text-align: center;">모두 보기</button>';
					} else {
						if (paginationInfo.totalPageCount > 1 && data.resultList.length != paginationInfo.totalRecordCount) {
							content += '<button type="button" id="btnAiOpenConsultPaging" onclick="moreAiOpenConsultTabList(' + paginationInfo.currentPageNo + ', ' + paginationInfo.totalPageCount + ');" class="more_list" style="text-align: center;">더 보기</button>';
						}
					}

					$('#openConsultBoard').append(content);
				}
			});
		}
	}

	function goPblcDetail(pblcConsultId) {
		saveAiLogInfo('004', pblcConsultId);

		var f = document.aiConsultForm;
		if (location.href.indexOf('tradeSOSAi') > -1) {
			f.action = '<c:url value="/tradeSOS/com/tradeSOSAiOpenConsultDetail.do" />';
		} else {
			f.action = '<c:url value="/tradeSOS/com/aiOpenConsultDetail.do" />';
		}
		f.pblcConsultId.value = pblcConsultId;
		f.submit();
	}

	// AI검색 로그저장
	function saveAiLogInfo(viewTypeCode, dataId) {
		var reqText = $('#reqContents').val();

		global.ajax({
			url : '<c:url value="/tradeSOS/com/saveAiLogInfo.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				reqText : reqText
				, viewTypeCode : viewTypeCode
				, dataId : dataId
			}
			, async : false
			, spinner : true
			, success : function (data){
			}
		});
	}

	// 1:1상담 사례 추천 더보기 버튼
	function moreAiConsultTabList(currentPageNo, totalPageCount) {
		if (currentPageNo < totalPageCount) {
			selectAiConsultTabList(currentPageNo + 1);
		}
	}

	// 오픈상담 추천 더보기 버튼
	function moreAiOpenConsultTabList(currentPageNo, totalPageCount) {
		if (currentPageNo < totalPageCount) {
			selectAiOpenConsultTabList(currentPageNo+1);
		}
	}
</script>