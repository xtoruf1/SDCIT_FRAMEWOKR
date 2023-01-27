<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url value="/voucher/voucherCompanyMngList.do" var="regUrl" />
<c:url value="/voucher/voucherPayMngList.do" var="payUrl" />

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
</div>

<form id="searchForm" name="searchForm" method="post">
	<div class="dashboard">
		<h3 id="pcfrcName" class="dashboard_tit">승인요청 증명서</h3>
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_body">
					<ul class="state">
						<li>
							<a href="javascript:fn_move('01');"><p id="cert01" class="data"><c:out value="${info.cert01}"/></p></a>
							<p class="name">해외지사/사무소<br/>추천서</p>
						</li>
						<li>
							<a href="javascript:fn_move('02');"><p id="cert02" class="data"><c:out value="${info.cert02}"/></p></a>
							<p class="name">외국인비자발급<br/>추천서</p>
						</li>	<li>
							<a href="javascript:fn_move('03');"><p id="cert03" class="data"><c:out value="${info.cert03}"/></p></a>
							<p class="name">바이어사증발급<br/>추천서</p>
						</li>
						<li>
							<a href="javascript:fn_move('04');"><p id="cert04" class="data"><c:out value="${info.cert04}"/></p></a>
							<p class="name">외화영수부<br/>실적증명서</p>
						</li>
						<li>
							<a href="javascript:fn_move('06');"><p id="cert06" class="data"><c:out value="${info.cert06}"/></p></a>
							<p class="name">용역/전자적<br/>무체물</p>
						</li>
						<li>
							<a href="javascript:fn_move('07');"><p id="cert07" class="data"><c:out value="${info.cert07}"/></p></a>
							<p class="name">선용품<br/>증명서</p>
						</li>
						<li>
							<a href="javascript:fn_move('05');"><p id="cert05" class="data"><c:out value="${info.cert05}"/></p></a>
							<p class="name">수출의탑확인증<br/>폐업기업</p>
						</li>
					</ul>
				</div>
			</div>
			<div class="dashboard_graph" style="width: 100%; height: 100%;">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">오늘 발급된 증명서</h4>
					<p class="ml-auto"></p>
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
			, url : '<c:url value="/online/selectDashboardData.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료


				var cert01 = global.formatCurrency(data.info.cert01);
				var cert02 = global.formatCurrency(data.info.cert02);
				var cert03 = global.formatCurrency(data.info.cert03);
				var cert04 = global.formatCurrency(data.info.cert04);
				var cert05 = global.formatCurrency(data.info.cert05);
				var cert06 = global.formatCurrency(data.info.cert06);
				var cert07 = global.formatCurrency(data.info.cert07);

				$('#cert01').text(cert01);
				$('#cert02').text(cert02);
				$('#cert03').text(cert03);
				$('#cert04').text(cert04);
				$('#cert05').text(cert05);
				$('#cert06').text(cert06);
				$('#cert07').text(cert07);

				//오늘발급된증명서
				var chartData = data.chartData;
				chartDataLoad(chartData);

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
	 * 클릭 시 신청내역 이동
	 * @param status
	 * @param val
	 */
	function fn_move(status) {
		if( status == '01' ){
			location.href = '/issue/recommend/overseasOfficeList.do?sStatusCd=20';
		}else if( status == '02' ){
			location.href = '/issue/recommend/foreignVisaList.do?sStatusCd=20';
		}else if( status == '03' ){
			location.href = '/issue/recommend/buyerCertList.do?sStatusCd=20';
		}else if( status == '04' ){
			location.href = '/issue/cert/foreignCurrencyList.do?sStatusCd=20';
		}else if( status == '05' ){
			location.href = '/issue/cert/closeExportTopList.do?sStatusCd=20';
		}else if( status == '06' ){
			location.href = '/svcex/svcexCertificate/applyList.do?searchStateCd=B&defaultValue=none';
		}else if( status == '07' ){
			location.href = '/supves/supCertificateList.do?searchStateCd=B&defaultValue=none';

		}
	}

	function chartDataLoad(chartData) {

		var listArray = [];
		var statusTitle = [];
		var statusArray = [];

		for(i = 0; i < chartData.length;  i++){
			statusTitle.push(chartData[i].certName);
			statusArray.push(chartData[i].certCnt);
		}

		statusArray.unshift('오늘 발급된 증명서');
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


</script>