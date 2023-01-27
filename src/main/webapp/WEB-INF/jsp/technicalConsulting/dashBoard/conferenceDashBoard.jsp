<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url value="/voucher/voucherCompanyMngList.do" var="regUrl" />
<c:url value="/voucher/voucherPayMngList.do" var="payUrl" />

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />

		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="openLayerEventChngPop();">상담회 변경</button>
		</div>
</div>

<form id="searchForm" name="searchForm" method="post">
	<input type="hidden" id="devCfrcId" name="devCfrcId" value="${resultData.devCfrcId}"/>
	<input type="hidden" id="searchKeyword2" name="searchKeyword2" value="${resultData.statusCd}"/>
	<input type="hidden" id="searchCondition" name="searchCondition" value="${resultData.resultCd}"/>
	<input type="hidden" id="cfrcName" name="cfrcName" value="${resultData.cfrcName}"/>

	<div class="dashboard">
		<h3 id="pcfrcName" class="dashboard_tit"><c:out value="${resultData.cfrcName}" /></h3>
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_body">
					<ul class="state">
						<li>
							<a href="javascript:fn_move('N', '');"><p id="aplctCnt" class="data"><c:out value="${resultData.aplctCnt}" default='0'/></p></a>
							<p class="name">신청</p>
						</li>
						<li>
							<a href="javascript:fn_move('Y', '');"><p id="cnfCnt" class="data"><c:out value="${resultData.cnfCnt}" default='0'/></p></a>
							<p class="name">확정</p>
						</li>	<li>
							<a href="javascript:fn_move('', 'C');"><p id="cnsltCnt" class="data"><c:out value="${resultData.cnsltCnt}" default='0'/></p></a>
							<p class="name">상담완료</p>
						</li>
						<li>
							<a href="javascript:fn_move('', 'F');"><p id="flwConsultCnt" class="data"><c:out value="${resultData.flwConsultCnt}" default='0'/></p></a>
							<p class="name">후속상담</p>
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

		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/technicalConsulting/selectConferenceDashBoard.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료

				console.log(data.resultData.cfrcName);
				// 타이틀 변경
				$('#pcfrcName').text(data.resultData.cfrcName);

				// 신청 건수
				var aplctCnt = global.formatCurrency(data.resultData.aplctCnt);
				$('#aplctCnt').text(aplctCnt);

				// 확정 건수
				var cnfCnt = global.formatCurrency(data.resultData.cnfCnt);
				$('#cnfCnt').text(cnfCnt);

				// 상담완료 건수
				var cnsltCnt = global.formatCurrency(data.resultData.cnsltCnt);
				$('#cnsltCnt').text(cnsltCnt);

				// 후속상담 건수
				var flwConsultCnt = global.formatCurrency(data.resultData.flwConsultCnt);
				$('#flwConsultCnt').text(flwConsultCnt);


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

	/**
	 * 행사 변경(팝업)
	 */
	function openLayerEventChngPop(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/technicalConsulting/eventChngPopup.do" />'
			, callbackFunction : function(resultObj) {
				$("input[name=devCfrcId]").val(resultObj.devCfrcId);
				getData();

			}
		});

	}

	/**
	 * 클릭 시 상담내역조회 이동
	 * @param status
	 * @param val
	 */
	function fn_move(status, result) {

		var devCfrcId = $('#devCfrcId').val();

		document.searchForm.action = '/participationCompany/technicalConsultingList.do';
		document.searchForm.searchKeyword2.value = status;
		document.searchForm.searchCondition.value = result;
		document.searchForm.devCfrcId = devCfrcId;
		document.searchForm.target = '_self';
		document.searchForm.submit();
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

</script>