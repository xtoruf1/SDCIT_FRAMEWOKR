<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="search">
		<div class="dateSelector">
			<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
			<input type="text" id="selectDate" value="" class="dates changeCalender" readonly="readonly" />
			<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
			<input type="hidden" id="searchBaseMonth" name="searchBaseMonth" />
		</div>
	</div>
</div>
<div class="dashboard">
	<!-- dashboard body -->
	<div class="dashboard_body">
		<!-- 그래프 영역 -->
		<div class="dashboard_graph_group">
			<div class="dashboard_graph">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">상담유형별비중</h4>
					<p class="ml-auto">단위 : 비율(%)</p>
				</div>
				<div class="dash_cont_body">
					<div id="gaugeChart"></div>
				</div>
			</div>
			<div class="dashboard_graph">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">상담유형별답변현황</h4>
					<p class="ml-auto">단위 : 건수</p>
				</div>
				<div class="dash_cont_body">
					<div id="stackedBarChart"></div>
				</div>
			</div>
			<div class="dashboard_graph w100p">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">상담분야별신청현황</h4>
					<p class="ml-auto">단위 : 건수</p>
				</div>
				<div class="dash_cont_body">
					<div id="barChart"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var searchCnt = 0;
	$(document).ready(function(){
		$('.changeCalender').datepicker('destroy');
		$('.changeCalender').monthpicker({
			pattern: 'yyyy.mm'
			, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
		});
		
		setNowTime();
	});

	// 현재 시간 설정
	function setNowTime() {
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();

		if (month < 10) {
			month = '0' + month;
		}
		
		if (day < 10) {
			day = '0' + day;
		}
		
		$('#searchBaseMonth').val(year + '-' + month + '-' + day);
		$('#selectDate').val(year + '.' + month);
		
		changeSelectDate();
	}
	
	function setPrevDate() {
		var selectDate = new Date($('#searchBaseMonth').val());
		selectDate.setMonth(selectDate.getMonth() - 1);
		var year = selectDate.getFullYear();
		var month = selectDate.getMonth() + 1;
		var day = selectDate.getDate();

		if (month < 10) {
			month = '0' + month;
		}
		
		if (day < 10) {
			day = '0' + day;
		}
		
		$('#searchBaseMonth').val(year + '-' + month + '-' + day);
		$('#selectDate').val(year + '.' + month);
		
		changeSelectDate();
	}

	function setNextDate() {
		var selectDate = new Date($('#searchBaseMonth').val());
		selectDate.setMonth(selectDate.getMonth() + 1);
		var year = selectDate.getFullYear();
		var month = selectDate.getMonth() + 1;
		var day = selectDate.getDate();

		if (month < 10) {
			month = '0' + month;
		}
		
		if (day < 10) {
			day = '0' + day;
		}
		
		$('#searchBaseMonth').val(year + '-' + month + '-' + day);
		$('#selectDate').val(year + '.' + month);
		
		changeSelectDate();
	}
	
	$(document).on('change', '.changeCalender', function(e, a) {
		var changeDate = $(this).val();
		
		var year = changeDate.substring(0, 4);
		var month = changeDate.substring(5, 7);
		
		$('#searchBaseMonth').val(year + '-' + month + '-01');
		$('#selectDate').val(year + '.' + month);
		
		changeSelectDate();
	});
	
	// 날짜 변경 시 처리
	function changeSelectDate() {
		getConsultTypeStatus();
		getConsultIngStatus();
		getConsultApplyStatus();
		
		// 1분마다 자동조회
		searchCnt++;
		setNextSearch(searchCnt);
	}

	// 1분마다 자동조회
	function setNextSearch(cnt) {
		setInterval(function(){
			if (cnt == searchCnt) {
				changeSelectDate();
			}
		}, 60000);
	}
	
	// 상담유형별비중
	function getConsultTypeStatus() {
		// 로딩이미지 시작
		$('#loading_image').show();
		
		var searchDate = $('#searchBaseMonth').val().replace(/-/gi, '').substring(0, 6);
		
		global.ajax({
			type : 'POST'
			, url : '/tradeSOS/exp/dashboard/selectConsultTypeStatus.do'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchDate : searchDate
			}
			, async : true
			, success : function(data){
				// 로딩이미지 종료
				$('#loading_image').hide();
				
				var listArray = [];
				if (data.list.length > 0) {
					for (var i = 0; i < data.list.length; i++) {
						var statusArray = [];
						statusArray.push(data.list[i].statType2Nm);
						statusArray.push(data.list[i].cnt);
						
						listArray.push(statusArray);
					}
				}
				
				// 빌보드 Gauge차트
				var chart = bb.generate({
					data : {
						columns : listArray
						, type : 'gauge'					// for ESM specify as: gauge()
						, onclick: function(d, i){
							console.log('onclick', d, i);
						}
						, onover : function(d, i){
							console.log('onover', d, i);
						}
						, onout : function(d, i){
							console.log('onout', d, i);
						}
					}
					, legend : {
						position : 'inset'
						, inset : {
							anchor : 'top-right'
							, x : 15
							, y : 20
						}
					} ,
			        onafterinit : function() {
						$('.bb-legend-background').remove();
					}
					, gauge : {}
					, bindto : '#gaugeChart'
					, size : {
						height : 270
					} 
				});
			}
		});
	}
	
	// 상담유형별답변현황
	function getConsultIngStatus() {
		// 로딩이미지 시작
		$('#loading_image').show();
		
		var searchDate = $('#searchBaseMonth').val().replace(/-/gi, '').substring(0, 6);

		global.ajax({
			type : 'POST'
			, url : '/tradeSOS/exp/dashboard/selectConsultIngStatus.do'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchDate : searchDate
			}
			, async : true
			, success : function(data){
				// 로딩이미지 종료
				$('#loading_image').hide();
				
				var listArray = [];
				if (data.list.length > 0) {
					var statusArray1 = [];
					var statusArray2 = [];
					for (var i = 0; i < data.list.length; i++) {
						if (i % 2 == 0) {
							statusArray1.push(data.list[i].cnt);
						} else if (i % 2 == 1) {
							statusArray2.push(data.list[i].cnt);
						}
					}
					
					statusArray1.unshift('완료');
					statusArray2.unshift('미답변/예약취소');
					
					listArray.push(statusArray1);
					listArray.push(statusArray2);
				}
				
				// 빌보드 스택바차트
				var chart = bb.generate({
					data: {
						columns: listArray
						, type: 'bar'			// for ESM specify as: bar()
						, labels: true
						, groups: [
							[
								'완료'
								, '미답변/예약취소'
							]
						],
						order: 'asc'
					}
					, grid: {
						y: {
							lines: [
								{
									value: 0
								}
							]
						}
					}
					, axis: {
						x: {
							type: 'category'
							, categories: [
								'채팅상담'
								, '화상상담'
								, '전화상담'
								, '오픈상담'
							]
						}
					}
					, bindto: '#stackedBarChart',
					size: {
				    	height: 270,
				    }
				});
			}
		});
	}

	// 상담분야별신청현황
	function getConsultApplyStatus() {
		// 로딩이미지 시작
		$('#loading_image').show();
		
		var searchDate = $('#searchBaseMonth').val().replace(/-/gi, '').substring(0, 6);

		global.ajax({
			type : 'POST'
			, url : '/tradeSOS/exp/dashboard/selectConsultApplyStatus.do'
			, dataType : 'json'
			, type : 'POST'
			, data : {
				searchDate : searchDate
			}
			, async : true
			, success : function(data){
				// 로딩이미지 종료
				$('#loading_image').hide();
				
				var listArray = [];
				var statusTitle = [];
				var statusArray = [];
				if (data.list.length > 0) {
					for (var i = 0; i < data.list.length; i++) {
						statusTitle.push(data.list[i].statTypeNm)
						statusArray.push(data.list[i].cnt);
					}
				}
				
				statusArray.unshift('상담 분야별 신청 현황');
				listArray.push(statusArray);
				
				// 빌보드 스택바차트
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
					, bindto: '#barChart'
					, size: {
				    	height: 270,
				    }
				});
			}
		});
	}
</script>