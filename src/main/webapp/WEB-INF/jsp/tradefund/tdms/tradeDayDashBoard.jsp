<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url value="/tradeSOS/problem/regulationSuggestList.do" var="goUrl" />

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="openLayerDlgSearchAwardPop();">포상 변경</button>
	</div>
</div>
<form id="searchForm" method="post">
	<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>"/>
	<input type="hidden" id="searchBsnNm" name="searchBsnNm" value="<c:out value="${searchBsnNm}"/>"/>
	<div>
		<div class="dashboard">
			<h3 class="dashboard_tit" id="title"></h3>
			<!-- dashboard body -->
			<div class="dashboard_body">
				<div class="dash_cont">
					<div class="dash_cont_body">
						<ul class="state" id="regInfoView"></ul>
					</div>
				</div>
				<!-- 그래프 영역 -->
				<div class="dashboard_graph_group">
					<div class="dashboard_graph w100p">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">소재지별 신청 현황</h4>
							<p class="ml-auto">단위 : 건수</p>
						</div>
						<div class="dash_cont_body">
							<div id="areaReqChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">회원 등급별 분포</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="memberGradeChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">기업규모별 분포</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="enterpriseScaleChart"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	var searchCnt = 0;

	$(document).ready(function() {
		getList();
	});

	// 포상 검색(팝업)
	function openLayerDlgSearchAwardPop() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/tdms/popup/dlgSearchAwardPopup.do" />'
			, callbackFunction : function(resultObj) {
				$('#searchSvrId').val(resultObj.svrId);
				$('#searchBsnNm').val(resultObj.bsnNm);
				getList();
			}
		});
	}

	function getList() {

		$('#loading_image').show(); // 로딩이미지 시작

		var searchParams = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/tdms/selectTradeDayDashBoardList.do"
			, contentType : 'application/json'
			, data : JSON.stringify(searchParams)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data) {
				var searchBsnNm = $('#searchBsnNm').val();
				$('#title').text(searchBsnNm);
				$('#loading_image').hide(); // 로딩이미지 종료
				$('#regInfoView').empty();

				var content = '';
				$(data.regInfoList).each(function() {
					content += '<li>';
					content += '	<p class="data">' + plusComma(this.cnt) + '</p>';
					content += '	<p class="name">' + this.summaryNm + '</p>';
					content += '</li>';
				});

				$('#regInfoView').append(content);

				// 소재지별 신청 현황
				var areaReqList = data.areaReqList;
				areaReqChart(areaReqList);

				// 회원 등급별 분포
				var memberGradeList = data.memberGradeList;
				memberGradeChart(memberGradeList);

				// 기업규모별 분포
				var enterpriseScaleList = data.enterpriseScaleList;
				enterpriseScaleChart(enterpriseScaleList);

				searchCnt++;
				setNextSearch(searchCnt);	// 1분마다 자동조회
			}
		});

	}

	function setNextSearch(cnt) {	// 1분마다 자동조회
		setInterval(function () {
			if(cnt == searchCnt) {
				getList();
			}
		}, 60000);
	}

	//소재지별 신청 현황
	function areaReqChart(areaReqList) {

		var cntArr = [];
		var codeNmArr = [];

		$(areaReqList).each(function() {
			cntArr.push(this.cnt);
			codeNmArr.push(this.areaNm);
		});

		cntArr.unshift('신청수');
		codeNmArr.unshift('지역');

		bb.generate({
		    bindto: "#areaReqChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "bar",
		        color: function(color, d){
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
				},
		        x : '지역',
		        columns: [
		        	cntArr,
		        	codeNmArr
		        ]
		    },
		    legend: {
		        show: false
		    },
		    axis: {
		        x: {
		          type: "category",
		          tick: {
		            rotate: 0,
		            multiline: false,
		            tooltip: true
		          }
		        },
		        y: {
		        	tick: {
		        		count : 5
		        	}
		        }
		      }
		});
	}

	function memberGradeChart(memberGradeList) {

		var codeArr1 = [];
		var codeArr2 = [];
		var codeArr3 = [];

		$(memberGradeList).each(function() {

			if(this.levGbCd == 'royal') {
				codeArr1.push(this.cnt);
				codeArr1.unshift(this.levGbNm);
			}

			if(this.levGbCd == 'gold') {
				codeArr2.push(this.cnt);
				codeArr2.unshift(this.levGbNm);
			}

			if(this.levGbCd == 'silver') {
				codeArr3.push(this.cnt);
				codeArr3.unshift(this.levGbNm);
			}

		});

		bb.generate({
		    bindto: "#memberGradeChart",
		    size: {
		    	height: 220,
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	codeArr1,
		        	codeArr2,
		        	codeArr3
		        ],
		        labels: true
		    },
		    gauge: {
		    	max: 1
		    },
		    legend: {
	            position: "inset",
	            inset: {
	                anchor: "top-right",  // top-left, top-right, bottom-left, bottom-right
	                x: 5,
	                y: 0
	            }
	        },
	        onafterinit: function() {
				$('.bb-legend-background').remove();
			}
		});
	}

	function enterpriseScaleChart(enterpriseScaleList) {

		var codeArr1 = [];
		var codeArr2 = [];
		var codeArr3 = [];

		console.log(enterpriseScaleList);
		$(enterpriseScaleList).each(function() {

			if(this.scaleCd == '1') {
				codeArr1.push(this.cnt);
				codeArr1.unshift(this.scaleNm);
			}

			if(this.scaleCd == '2') {
				codeArr2.push(this.cnt);
				codeArr2.unshift(this.scaleNm);
			}

			if(this.scaleCd == '3') {
				codeArr3.push(this.cnt);
				codeArr3.unshift(this.scaleNm);
			}

		});

		bb.generate({
		    bindto: "#enterpriseScaleChart",
		    size: {
		    	height: 220
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	codeArr1,
		        	codeArr2,
		        	codeArr3
		        ],
		        labels: true
		    },
		    gauge: {
		    	max: 1
		    },
		    legend: {
	            position: "inset",
	            inset: {
	                anchor: "top-right",  // top-left, top-right, bottom-left, bottom-right
	                x: 5,
	                y: 0
	            }
	        },
	        onafterinit: function() {
				$('.bb-legend-background').remove();
			}
		});
	}


</script>