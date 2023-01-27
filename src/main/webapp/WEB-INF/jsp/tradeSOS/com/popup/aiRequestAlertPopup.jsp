<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<input type="hidden" id="continueBtnYn" value="${param.continueBtnYn}" />
<input type="hidden" id="pageType" value="${param.pageType}" />
<div style="width: 550px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">질문이 너무 짧습니다.<br />AI가 이해 할 수 있도록, 좀 더 길게 질문해 주세요.</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body exp_alert" style="margin-top: -20px;">
		<dl class="dot_dl">
			<dt style="font-weight: 450;">원스탑 AI 자문 추천 질문 예시</dt>
			<dd style="font-weight: 450;">FDA 시설 등록 넘버를 받는 절차</dd>
			<dd style="font-weight: 450;">기어 펌프 부분품에 대한 HS Code 문의</dd>
			<dd style="font-weight: 450;">한미 FTA 원산지 증명서를 발급 방법 및 서식</dd>
		</dl>
	</div>
	<div class="btn_group mt-20 _center">
		<button type="button" id="conBtn" onclick="goConsultService();" class="btn btn_primary" style="display: none;">계속 진행하기</button>
		<button type="button" onclick="closeLayerPopup();" class="btn btn_primary">질문 수정하기</button>
	</div>
</div>
<script>
	$(document).ready(function(){
		var conBtn = $('#continueBtnYn').val();
		
		if (conBtn == 'Y') {
			$('#conBtn').show();
		} else {
			$('#conBtn').hide();
		}
	});
	
	function goConsultService() {
		var pageType = $('#pageType').val();
		if (pageType == 'func') {
			// 콜백
			layerPopupCallback({gbn : '1'});
			
			/*
			selectConsultApiKeys();
			closeLayerPopup();
			*/
		} else {
			// 콜백
			layerPopupCallback({gbn : '2'});
			
			/*
			$('#frmConsultService').submit();
			*/
		}
	}
</script>