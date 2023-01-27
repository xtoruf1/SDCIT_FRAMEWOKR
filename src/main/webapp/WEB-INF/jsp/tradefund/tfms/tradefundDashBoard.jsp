<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%-- <c:url value="/voucher/voucherCompanyMngList.do" var="regUrl" /> --%>
<%-- <c:url value="/voucher/voucherPayMngList.do" var="payUrl" /> --%>

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="openSearchPopup();">회차 변경</button>
		</div>
</div>

<form id="searchForm" method="post">
	<input type="hidden" id="svrId" name="svrId" value="${svrId}"/>

	<div class="dashboard">
		<h3 id="title" class="dashboard_tit"><c:out value="${title}" /></h3>
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_body">
					<ul class="state">
						<li>
							<a href="javascript:goApplicationSelectList('');"><p id="regCnt" class="data"></p></a>
							<p class="name">신청</p>
						</li>
						<li>
							<a href="javascript:goApplicationSelectList('01');"><p id="receiptCnt" class="data"></p></a>
							<p class="name">접수</p>
						</li>
						<li>
							<a href="javascript:goApplicationSelectList('02');"><p id="leavingCnt" class="data"></p></a>
							<p class="name">탈락</p>
						</li>
						<li>
							<a href="javascript:goApplicationSelectList('03');"><p id="selectCnt" class="data"></p></a>
							<p class="name">선정</p>
						</li>
						<li>
							<a href="javascript:goApplicationSelectList('04');"><p id="impossibleCnt" class="data"></p></a>
							<p class="name">불능</p>
						</li>
						<li>
							<a href="javascript:goApplicationSelectList('05');"><p id="giveUpCnt" class="data"></p></a>
							<p class="name">포기</p>
						</li>
					</ul>
				</div>
			</div>
			<div class="dashboard_graph" style="width: 100%">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">지역본부별신청현황</h4>
					<p class="ml-auto">단위 : 업체수</p>
				</div>
				<div class="dash_cont_body">
					<div id="fundAreaStatusChart"></div>
				</div>
			</div>

			<div class="dashboard_graph_group">
				<div class="dashboard_graph">
					<div class="dash_cont_header">
						<h4 class="cont_tit ico_graphBar">회원등급별분포</h4>
						<p class="ml-auto">단위 : 업체수</p>
					</div>
					<div class="dash_cont_body">
						<div id="fundMemberLevelSatausChart"></div>
					</div>
				</div>

				<div class="dashboard_graph">
					<div class="dash_cont_header">
						<h4 class="cont_tit ico_graphBar">융자희망은행별분포</h4>
						<p class="ml-auto">단위 : 업체수</p>
					</div>
					<div class="dash_cont_body">
						<div id="fundBankStatusChart"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	var searchCnt = 0;

	$(document).ready(function(){

		getData();
	});

	function getData() {

		$('#loading_image').show(); // 로딩이미지 시작

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/tfms/selectTradefundDashBoard.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, async : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료

				// 융자별 처리현황
				var fundRegStatus = data.fundRegStatus;
				regStatus(fundRegStatus);

				// 융자별 지역본부 신청현황
				var fundAreaStatus = data.fundAreaStatus;
				fundAreaStatusChart(fundAreaStatus);

				// 융자별 회원 등급별 분포
				var fundMemberLevelSataus = data.fundMemberLevelSataus;
				fundMemberLevelSatausChart(fundMemberLevelSataus);

				// 융자별 은행 분포
				var fundBankStatus = data.fundBankStatus;
				fundBankStatusChart(fundBankStatus);

				searchCnt++;
				setNextSearch(searchCnt);	// 1분마다 자동조회

			}
		});
	}

	function setNextSearch(cnt) {	// 1분마다 자동조회
		setInterval(function () {
			if(cnt == searchCnt){
				getData();
			}
		}, 60000);
	}

	function openSearchPopup() {

		global.openLayerPopup({
			popupUrl : '/tfms/lms/fundPopup.do'
			, callbackFunction : function(resultObj){

				$("#svrId").val(resultObj.svrId);			//기금융자코드
				$("#title").text(resultObj.title);			//기금융자명

				getData();
			}
		});
	}

	function regStatus(regStatusList) {

		for(var i = 0; i < regStatusList.length; i++) {
			if(regStatusList[i].codeNm == '접수') {
				$('#receiptCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}

			if(regStatusList[i].codeNm == '탈락') {
				$('#leavingCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}

			if(regStatusList[i].codeNm == '선정') {
				$('#selectCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}

			if(regStatusList[i].codeNm == '불능') {
				$('#impossibleCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}

			if(regStatusList[i].codeNm == '포기') {
				$('#giveUpCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}

			if(regStatusList[i].codeNm == '신청') {
				$('#regCnt').text(global.formatCurrency(regStatusList[i].regCnt));
			}
		}
	}

	function fundAreaStatusChart(areaStatus) {

		var listArray = [];
		var statusTitle = [];
		var statusArray = [];

		for(i = 0; i < areaStatus.length;  i++){
			statusTitle.push(areaStatus[i].codeNm);
			statusArray.push(areaStatus[i].regCnt);
		}

		statusArray.unshift('소재지별 신청 현황');
		listArray.push(statusArray);


		var chart = bb.generate({
			data: {
				columns: listArray
				, type: 'bar'			// for ESM specify as: bar()
				, labels: true
				, color: function(color, d){
					return [
						'#1f77b4'
						, '#aec7e8'
						, '#ff7f0e'
						, '#ffbb78'
						, '#2ca02c'
						, '#98df8a'
						, '#d62728'
						, '#ff9896'
						, '#9467bd'
						, '#c5b0d5'
						, '#8c564b'
						, '#c49c94'
						, '#e377c2'
						, '#f7b6d2'
					][d.index];
				}
			}
			, bar: {
				width: {
					ratio: 0.5
				}
			}
			, legend: {
				show: false
			}
			, axis: {
				x: {
					type: 'category'
					, categories: statusTitle
				}
			}
			, bindto: '#fundAreaStatusChart'
			, size: {
		    	height: 200,
		    }
		});
	}

	function fundMemberLevelSatausChart(data) {

		var silverCntArr = [];
		var goldCntArr = [];
		var royalCntArr = [];
		var totCnt = 0;

		for(i = 0; i < data.length;  i++){

			if(data[i].codeNm == '실버') {
				silverCntArr.push(data[i].regCnt+100);
				silverCntArr.unshift(data[i].codeNm);
				totCnt += data[i].regCnt;
			}

			if(data[i].codeNm == '골드') {
				goldCntArr.push(data[i].regCnt+100);
				goldCntArr.unshift(data[i].codeNm);
				totCnt += data[i].regCnt;
			}

			if(data[i].codeNm == '로얄') {
				royalCntArr.push(data[i].regCnt+100);
				royalCntArr.unshift(data[i].codeNm);
				totCnt += data[i].regCnt;
			}
		}

		if(totCnt <= 100) {

			for(i = 0; i < data.length;  i++){

				if(data[i].codeNm == '실버') {
					silverCntArr = [];
					silverCntArr.push(data[i].regCnt);
					silverCntArr.unshift(data[i].codeNm);
					totCnt += data[i].regCnt;
				}

				if(data[i].codeNm == '골드') {
					goldCntArr = [];
					goldCntArr.push(data[i].regCnt);
					goldCntArr.unshift(data[i].codeNm);
					totCnt += data[i].regCnt;
				}

				if(data[i].codeNm == '로얄') {
					royalCntArr = [];
					royalCntArr.push(data[i].regCnt);
					royalCntArr.unshift(data[i].codeNm);
					totCnt += data[i].regCnt;
				}
			}
		}

		bb.generate({
		    bindto: "#fundMemberLevelSatausChart",
		    size: {
		    	height: 220
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	silverCntArr,
		        	goldCntArr,
		        	royalCntArr,
		        ],
		        labels: true
		    },
		    legend: {
	            position: "inset",
	            inset: {
	                anchor: "top-right",  // top-left, top-right, bottom-left, bottom-right
	                x: 15,
	                y: 20
	            }
	        },
	        onafterinit: function() {
				$('.bb-legend-background').remove();
			}
		});
	}

	function fundBankStatusChart(data) {

		var top1CntArr = [];
		var top2CntArr = [];
		var top3CntArr = [];
		var top4CntArr = [];
		var top5CntArr = [];
		var etcCntArr = [];
		var totCnt = 0;
		var prenum = 0;


		totCnt += Number(data[0].regCnt);
		totCnt += Number(data[1].regCnt);
		totCnt += Number(data[2].regCnt);
		totCnt += Number(data[3].regCnt);
		totCnt += Number(data[4].regCnt);
		totCnt += Number(data[5].regCnt);

		if(totCnt <= 0) {
			prenum = 0;
		} else if(totCnt <= 100) {
			prenum = 100;
		}

		top1CntArr.push(data[0].regCnt+prenum);
		top1CntArr.unshift(data[0].codeNm);

		top2CntArr.push(data[1].regCnt+prenum);
		top2CntArr.unshift(data[1].codeNm);

		top3CntArr.push(data[2].regCnt+prenum);
		top3CntArr.unshift(data[2].codeNm);

		top4CntArr.push(data[3].regCnt+prenum);
		top4CntArr.unshift(data[3].codeNm);

		top5CntArr.push(data[4].regCnt+prenum);
		top5CntArr.unshift(data[4].codeNm);

		etcCntArr.push(data[5].regCnt+prenum);
		etcCntArr.unshift(data[5].codeNm);

		bb.generate({
		    bindto: "#fundBankStatusChart",
		    size: {
		    	height: 220
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	top1CntArr,
		        	top2CntArr,
		        	top3CntArr,
		        	top4CntArr,
		        	top5CntArr,
		        	etcCntArr,
		        ],
		        labels: true
		    },
		    legend: {
	            position: "inset",
	            inset: {
	                anchor: "top-right",  // top-left, top-right, bottom-left, bottom-right
	                x: 15,
	                y: 20
	            }
	        },
	        onafterinit: function() {
				$('.bb-legend-background').remove();
			}
		});
	}

	//신청업체선정-신청업체 화면 이동
	function goApplicationSelectList(code){
		var url = "/tfms/ssm/applicationSelectionList.do";

		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","post");
		newForm.attr("action", url );
		newForm.attr("target","_self");
		newForm.append($('<input/>', {type: 'hidden', name: 'searchSvrId', value: $("#svrId").val() }));
		newForm.append($('<input/>', {type: 'hidden', name: 'searchSt', value: code }));
		newForm.append($('<input/>', {type: 'hidden', name: 'searchKeyword', value: 'pass' }));
		newForm.appendTo('body');
		newForm.submit();

	}

</script>