<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%-- <c:url value="/hanbit/hanbitApplicant/hanbitApplicantList.do" var="regUrl" /> --%>
<%-- <c:url value="/voucher/voucherPayMngList.do" var="scoreUrl" /> --%>

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="openSearchPopup();">회차 변경</button>
		</div>
</div>

<form id="searchForm" method="post">
	<input type="hidden" id="traderId" name="traderId" value="${traderId}"/>
	<div class="dashboard">
		<h3 id="awardTitle" class="dashboard_tit"><c:out value="${awdTitle}" /></h3>
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_body">
					<ul class="state col3">
						<li>
							<a href="javascript:goHanbitApplicantList('R');"><p id="regCnt" class="data"></p></a>
							<p class="name">신청</p>
						</li>
						<li>
							<a href="javascript:goHanbitApplicantList('');"><p id="avgScore" class="data"></p></a>
							<p class="name">평균점수</p>
						</li>
						<li>
							<a href="javascript:goHanbitApplicantList('');"><p id="maxScore" class="data"></p></a>
							<p class="name">최고점수</p>
						</li>
					</ul>
				</div>
			</div>
			<div class="dashboard_graph" style="width: 100%">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">업종별신청현황</h4>
					<p class="ml-auto">단위 : 업체수</p>
				</div>
				<div class="dash_cont_body">
					<div id="busibessStatusChart"></div>
				</div>
			</div>

			<div class="dashboard_graph" style="width: 100%">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">소재지별신청현황</h4>
					<p class="ml-auto">단위 : 업체수</p>
				</div>
				<div class="dash_cont_body">
					<div id="areaStatusChart"></div>
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
			, url : '/hanbit/selectHanbitDashBoard.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, async : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료
				// 한빛회 신청 카운트
				var regCnt = global.formatCurrency(data.regCnt);
				$('#regCnt').text(regCnt);

				// 평균점수
				var avgScore = data.scoreStatus.avgScore;
				// 최고점수
				var maxScore = data.scoreStatus.maxScore;
				$('#avgScore').text(avgScore);
				$('#maxScore').text(maxScore);

				// 지역별 신청현황
				var areaStatus = data.areaStatus;

				areaStatusChart(areaStatus);

				// 업종별 신청현황
				var busibessStatus = data.busibessStatus;

				busibessStatusChart(busibessStatus);

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
			popupUrl : '/hanbit/popup/hanbitSearchPop.do'
			, callbackFunction : function(resultObj){
				console.log(resultObj);
				$("#traderId").val(resultObj.traderId);			// 한빛회ID
				$("#awardTitle").text(resultObj.awardTitle);	// 회차명

				getData();
			}
		});
	}

	function areaStatusChart(areaStatus) {

		var listArray = [];
		var statusTitle = [];
		var statusArray = [];

		for(i = 0; i < areaStatus.length;  i++){
			statusTitle.push(areaStatus[i].areaNm);
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
						, '#7f7f7f'
						, '#c7c7c7'
						, '#bcbd22'
						, '#dbdb8d'
						, '#17becf'
						, '#9edae5'
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
			, bindto: '#areaStatusChart'
			, size: {
		    	height: 195,
		    }
		});
	}

	function busibessStatusChart(busibessStatus) {

		var listArray = [];
		var statusTitle = [];
		var statusArray = [];

		for(i = 0; i < busibessStatus.length;  i++){
			statusTitle.push(busibessStatus[i].businessNm);
			statusArray.push(busibessStatus[i].regCnt);
		}

		statusArray.unshift('업종별 신청 현황');
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
						, '#7f7f7f'
						, '#c7c7c7'
						, '#bcbd22'
						, '#dbdb8d'
						, '#17becf'
						, '#9edae5'
					][d.index];
				}
			}
			, bar: {
				width: {
					ratio: 0.3
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
			, bindto: '#busibessStatusChart'
			, size: {
		    	height: 195,
		    }
		});
	}

	function goHanbitApplicantList(chk) {

		var url = "<c:url value='/hanbit/hanbitApplicant/hanbitApplicantList.do' />";

		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","post");
		newForm.attr("action", url );
		newForm.attr("target","_self");
		newForm.append($('<input/>', {type: 'hidden', name: 'traderId', value: $("#traderId").val() }));
		if(chk == 'R') {
			newForm.append($('<input/>', {type: 'hidden', name: 'searchStatus', value: 'N' }));
		}
		newForm.appendTo('body');
		newForm.submit();
	}

</script>