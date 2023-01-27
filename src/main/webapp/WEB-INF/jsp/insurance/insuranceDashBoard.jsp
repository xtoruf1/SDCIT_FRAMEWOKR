<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url value="/insurance/insuranceApproList.do" var="regUrl" />
<c:url value="/insurance/insuranceSubscripList.do" var="payUrl" />

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="search">
		<div class="dateSelector" style="text-align: center;">
			<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
			<input type="text" id="selectDate" value="" onchange="changeSelectDate(this.value);" class="yearpicker changeCalender" readonly="readonly" />
			<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
		</div>
	</div>
</div>

<form id="searchForm" method="post">
	<input type="hidden" id="searchBaseYear" name="searchBaseYear" />
	<div>
		<div class="dashboard">
			<!-- dashboard body -->
			<div class="dashboard_body">
				<div class="dash_cont">
					<div class="dash_cont_body">
						<ul class="state">
							<li>
								<a href="<c:out value="${regUrl}"/>"><p id="applCnt" class="data"></p></a>
								<p class="name">신청</p>
							</li>
							<li>
								<a href="<c:out value="${payUrl}"/>"><p id="reqCnt" class="data"></p></a>
								<p class="name">가입완료</p>
							</li>
							<li>
								<a href="<c:out value="${payUrl}"/>"><p id="insTotAmt" class="data"></p></a>
								<p class="name">보험료(원)</p>
							</li>
							<li>
								<p id="insRate" class="data"></p>
								<p class="name">예산 집행률</p>
							</li>
						</ul>
					</div>
				</div>

				<!-- 그래프 영역 -->
				<div class="dashboard_graph_group">
					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">단체보험신청추이</h4>
							<p class="ml-auto">단위 : 업체수</p>
						</div>
						<div class="dash_cont_body">
							<div id="insReqCntChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">예산집행현황</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="insAmtChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">회원등급별분포</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="insGradeRegChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">보험종류별분포</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="insTypeRegChart"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	var searchCnt = 0;

	$(document).ready(function(){

		var date = new Date();
		var year = date.getFullYear();

		$('#searchBaseYear').val(year);
		$('#selectDate').val(year);

		$('.yearpicker').yearpicker({
			year: year
    	});

	});

	function setPrevDate() {
		var baseYear = Number($('#searchBaseYear').val());
		baseYear--;
		$('#searchBaseYear').val(baseYear);
		$('#selectDate').val(baseYear);
		$('#selectDate').trigger('change');
		setUrl();
	}

	function setNextDate() {
		var baseYear = Number($('#searchBaseYear').val());
		baseYear++;
		$('#searchBaseYear').val(baseYear);
		$('#selectDate').val(baseYear);
		$('#selectDate').trigger('change');
		setUrl();
	}

	// 날짜 변경 시 처리
	function changeSelectDate(val) {
		$('#searchBaseYear').val(val);
		reloadCheck = false;
		getData();
	}

	function getData() {

		$('#loading_image').show();	// 로딩이미지 시작

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/insurance/selectInsuranceDashBoard.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, async : true
			, success : function(data){

				$('#loading_image').hide();	// 로딩이미지 종료
				// 보험 신청 카운트
				var applCnt = data.applCnt;
				$('#applCnt').text(applCnt);

				// 보험 가입완료 카운트
				var reqCnt = data.reqCnt;
				$('#reqCnt').text(reqCnt);

				//url 설정
				setUrl();

				// 월별 보험 신청 추이
				var insReqCntList = data.insReqCntList;

				insReqCntChart(insReqCntList);

				// 보험 예산 집행 현황
				var insGrareInfo = data.insGrareInfo;

				insGradeChart(insGrareInfo);

				// 보험 등급별 이용 업체 수
				var insGradeDistribution = data.insGradeDistribution;

				insGradeDistributionChart(insGradeDistribution);

				// 보험 종류별 이용 업체 수
				var insTypeDistribution = data.insTypeDistribution;

				insTypeDistributionChart(insTypeDistribution);

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

	// 월별 보험 신청 추이 차트생성
	function insReqCntChart(insReqCntList) {

		var insCntArr = [];
		var monthArr = [];

		for(i = 0; i < insReqCntList.length;  i++){
			monthArr.push(insReqCntList[i].monthDt);
			insCntArr.push(insReqCntList[i].regCnt);
		}

		insCntArr.unshift('단체보험 신청 추이');
		monthArr.unshift('월');


		bb.generate({
		    bindto: "#insReqCntChart",
		    size: {
		    	height: 220,
		    },
		    data: {
		        type: "line",
		        x : '월',
		        columns: [
		        	insCntArr,
		        	monthArr
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
		        		format : function(insCntArr) {
				        	return global.formatCurrency(insCntArr);
				        },
				        count : 5
		        	}
		        }
		      }
		});
	}

	function insGradeChart(insGrareInfo) {

		var silverRate = 0;
		var goldRate = 0;
		var royalRate = 0;
		var totRete = 0;
		var toTotalRate = 0;

		for(i = 0; i < insGrareInfo.length;  i++){

			if(insGrareInfo[i].memberLev == 'silver') {
				silverRate = insGrareInfo[i].insRate;
				totRete += insGrareInfo[i].insRate;
			}

			if(insGrareInfo[i].memberLev == 'gold') {
				goldRate = insGrareInfo[i].insRate;
				totRete += insGrareInfo[i].insRate;
			}

			if(insGrareInfo[i].memberLev == 'royal') {
				royalRate = insGrareInfo[i].insRate;
				totRete += insGrareInfo[i].insRate;
			}

			if(!insGrareInfo[i].memberLev) {

				toTotalRate = insGrareInfo[i].totAmt;

				if(insGrareInfo[i].totAmt == 0) {
					$('#insRate').text('-');
					$('#insRate').css('color','black');
				} else {
					$('#insRate').text(insGrareInfo[i].insRate + '%');

					if(insGrareInfo[i].insRate >= 100) {
						$('#insRate').css('color','red');
					} else {
						$('#insRate').css('color','black');
					}
				}

				$('#insTotAmt').text(global.formatCurrency(insGrareInfo[i].insAmt));

			}
		}

		if( totRete < 120 ) {	// 차트 기준을 주기위해
			totRete = 120;
		}

		if(toTotalRate == 0) {	// 사업 예산이 0일 경우
			totRete = 100;
			silverRate = 0;
			goldRate = 0;
			royalRate = 0;
		}

		bb.generate({
			data: {
			    x: "x",
			    columns: [
			   ["x", "총"],
			   ['실버',silverRate],
			   ['골드',goldRate],
			   ['로얄',royalRate]
			    ],
			    type: "bar", // for ESM specify as: bar()
			    groups: [
			      [
			        "실버",
			        "로얄",
			        "골드",
			      ]
			    ]
			  },
			  grid: {
			    y: {
			      lines: [
			        {
			          value: 100,
			          text: "총예산"
			        }
			      ]
			    }
			  },
			  axis: {
			    rotated: true,
			    x: {
			      type: "category",
			      clipPath: false,
			      inner: false,
			      tick: {
			        text: {
			          show: false,
			          position: {
			            x: 35,
			            y: -23
			          }
			        }
			      }
			    },
			    y: {
			      show: true
			      ,max: totRete
			    }
			  },
			  bindto: "#insAmtChart",
			  size: {
			    	height: 220,
			  },
			  bar: {
				width: {
					ratio: 10,
				    max: 50
				}
			  }
		});


	}

	function insGradeDistributionChart(insGradeDistribution) {

		var silverArr = [];
		var goldArr = [];
		var royalArr = [];

		silverArr.push(insGradeDistribution.silverCnt);
		silverArr.unshift('실버');

		goldArr.push(insGradeDistribution.goldCnt);
		goldArr.unshift('골드');

		royalArr.push(insGradeDistribution.royalCnt);
		royalArr.unshift('로얄');

		bb.generate({
		    bindto: "#insGradeRegChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	silverArr,
		        	goldArr,
		        	royalArr
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

	function insTypeDistributionChart(insTypeDistribution) {

		var insTypeArr = [];
		var insCntArr = [];
		var object = {};

		var num = 0;

		for(i = 0; i < insTypeDistribution.length; i++) {


			object[num] = [];

			object[num].push(insTypeDistribution[i].insRegCnt);
			object[num].unshift(insTypeDistribution[i].insName);
			num++;

		}

		bb.generate({
		    bindto: "#insTypeRegChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	object[0],
		        	object[1]
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

	//신청에 있는 숫자를 누를 시, 조건에 맞는 데이터를 볼 수 있도록
	//DashBoard에서 조회했던 년도, 상태에 맞는 파라미터를 넣은 url로 설정
	function setUrl() {
		//조회 대상 년도 가져오기
		var searchBaseYear = $('#searchBaseYear').val();

		//신청 url 설정
		var applCntHref = $('#applCnt').parent().attr('href').split('?')[0];
		$('#applCnt').parent().attr('href', applCntHref + '?searchBaseYear=' + searchBaseYear + '&searchStatusCd=10&searchAll=ONSTATUS');

		//가입완료 url 설정 90
		var reqCntHref = $('#reqCnt').parent().attr('href').split('?')[0];
		$('#reqCnt').parent().attr('href', reqCntHref + '?searchBaseYear=' + searchBaseYear + '&searchStatusCd=90&searchAll=ONSTATUS');
	}

</script>