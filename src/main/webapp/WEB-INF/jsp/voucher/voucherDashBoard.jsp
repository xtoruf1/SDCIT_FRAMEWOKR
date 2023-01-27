<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
								<a href="javascript:goVoucherList('01');"><p id="waitCnt" class="data"></p></a>
								<p class="name">승인대기</p>
							</li>
							<li>
								<a href="javascript:goVoucherList('02');"><p id="applCnt" class="data"></p></a>
								<p class="name">승인</p>
							</li>
							<li>
								<p id="currentAmt" class="data"></p>
								<p class="name">지급액(원)</p>
							</li>
							<li>
								<p id="currentRate" class="data"></p>
								<p class="name">예산 집행률</p>
							</li>
						</ul>
					</div>
				</div>

				<!-- 그래프 영역 -->
				<div class="dashboard_graph_group">
					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">정산지급업체추이</h4>
							<p class="ml-auto">단위 : 업체수</p>
						</div>
						<div class="dash_cont_body">
							<div id="payRegCntChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">정산지급금액추이</h4>
							<p class="ml-auto">단위 : 원</p>
						</div>
						<div class="dash_cont_body">
							<div id="payAmtChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">등급별이용업체비중</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="payGradeRegChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">등급별예산집행현황</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="payBudgetStatusChart"></div>
						</div>
					</div>
				</div>
				<!-- //그래프 영역 -->
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
	}

	function setNextDate() {
		var baseYear = Number($('#searchBaseYear').val());
		baseYear++;
		$('#searchBaseYear').val(baseYear);
		$('#selectDate').val(baseYear);
		$('#selectDate').trigger('change');
	}

	// 날짜 변경 시 처리
	function changeSelectDate(val) {
		$('#searchBaseYear').val(val);
		reloadCheck = false;
		getData();
	}

	function getData() {

		$('#loading_image').show(); // 로딩이미지 시작

		var searchParam = $('#searchForm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : '/voucher/selectVoucherDashBoard.do'
			, contentType : 'application/json'
			, data : JSON.stringify(searchParam)
			, async : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료

				$('#currentAmt').text('0');
				$('#currentRate').text('0%');
				$('#currentRate').css('color','black');

				// 바우처 승인대기 카운트
				$('#waitCnt').text('0');
				var waitCnt = global.formatCurrency(data.waitCnt);
				$('#waitCnt').text(waitCnt);

				// 바우처 승인완료 카운트
				$('#applCnt').text('0');
				var applCnt = global.formatCurrency(data.applCnt);
				$('#applCnt').text(applCnt);

				// 월별 정산 지급액
				var payAmtInfo = data.payAmtResult;

				payAmtChart(payAmtInfo);


				// 월별 정산 지급 업체수
				var payRegCntInfo = data.payRegCntResult;

				payRegCntChart(payRegCntInfo);

				// 등급별 정보
				var payGradeInfo = data.payGradeResult;

				// 등급별 이용 업체 수
				payGradeCnt(payGradeInfo);

				// 예산 집행현황
				payBudgetStatus(payGradeInfo);

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

	function payAmtChart(payAmtInfo) {

		var payAmtArr = [];
		var monthArr = [];

		for(i = 0; i < payAmtInfo.length;  i++){
			monthArr.push(payAmtInfo[i].payDt);
			payAmtArr.push(payAmtInfo[i].payAmt);
		}

		var maxAmt = Math.max.apply(null, payAmtArr);

		var strMaxAmt = ''+maxAmt;

		if( strMaxAmt.length > 6 ) {

			var baseUnit = 10;

			maxAmt = Math.ceil(maxAmt/Math.pow(baseUnit, (strMaxAmt.length - 1))) * Math.pow(baseUnit, (strMaxAmt.length - 1));
			//maxAmt = Math.ceil(maxAmt/baseUnit**(strMaxAmt.length - 1)) * baseUnit**(strMaxAmt.length - 1);
		}

		payAmtArr.unshift('정산지급액');
		monthArr.unshift('월');


		bb.generate({
		    bindto: "#payAmtChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "bar",
		        x : '월',
		        columns: [
		        	payAmtArr,
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
		        		format : function(payAmtArr) {
				        	return global.formatCurrency(payAmtArr);
				    	},
				    	count : 5
		        	},
		        	max: maxAmt
		        }
		      }
		});
	}

	function payRegCntChart(payRegCntInfo) {

		var payRegCntArr = [];
		var monthArr = [];

		for(i = 0; i < payRegCntInfo.length;  i++){
			monthArr.push(payRegCntInfo[i].payDt);
			payRegCntArr.push(payRegCntInfo[i].payCorpCnt);
		}

		payRegCntArr.unshift('정산 지급 업체 수');
		monthArr.unshift('월');


		bb.generate({
		    bindto: "#payRegCntChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "line",
		        x : '월',
		        columns: [
		        	payRegCntArr,
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
		        		format : function(payRegCntArr) {
				        	return global.formatCurrency(payRegCntArr);
				        },
				        count : 5
		        	}
		        }
		      }
		});
	}

	function payGradeCnt(payGradeInfo) {

		var silverCntArr = [];
		var goldCntArr = [];
		var royalCntArr = [];
		var jumpupCntArr = [];
		var bangCntArr = [];

		var dataInfo = {};

		for(i = 0; i < payGradeInfo.length;  i++){

			if(payGradeInfo[i].voucherLev == 'silver') {
				silverCntArr.push(payGradeInfo[i].payCorpCnt);
				silverCntArr.unshift(payGradeInfo[i].voucherLevNm);
			}

			if(payGradeInfo[i].voucherLev == 'gold') {
				goldCntArr.push(payGradeInfo[i].payCorpCnt);
				goldCntArr.unshift(payGradeInfo[i].voucherLevNm);
			}

			if(payGradeInfo[i].voucherLev == 'royal') {
				royalCntArr.push(payGradeInfo[i].payCorpCnt);
				royalCntArr.unshift(payGradeInfo[i].voucherLevNm);
			}

			if(payGradeInfo[i].voucherLev == 'jumpup') {
				jumpupCntArr.push(payGradeInfo[i].payCorpCnt);
				jumpupCntArr.unshift(payGradeInfo[i].voucherLevNm);
			}

			if(payGradeInfo[i].voucherLev == 'bang') {
				bangCntArr.push(payGradeInfo[i].payCorpCnt);
				bangCntArr.unshift(payGradeInfo[i].voucherLevNm);
			}

		}

		bb.generate({
		    bindto: "#payGradeRegChart",
		    size: {
		    	height: 220
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	silverCntArr,
		        	goldCntArr,
		        	royalCntArr,
		        	jumpupCntArr,
		        	bangCntArr
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

	function payBudgetStatus(payGradeInfo) {


		var silverAmt = 0;
		var goldAmt = 0;
		var royalAmt = 0;
		var jumpupAmt = 0;
		var bangAmt = 0;
		var totAmt = 0;
		var totAmtArr = [];

		var dataInfo = {};

		for(i = 0; i < payGradeInfo.length;  i++){

			if(payGradeInfo[i].voucherLev == 'silver') {
				silverAmt = payGradeInfo[i].payRate;
				totAmt += payGradeInfo[i].payRate;
			}

			if(payGradeInfo[i].voucherLev == 'gold') {
				goldAmt = payGradeInfo[i].payRate;
				totAmt += payGradeInfo[i].payRate;
			}

			if(payGradeInfo[i].voucherLev == 'royal') {
				royalAmt = payGradeInfo[i].payRate;
				totAmt += payGradeInfo[i].payRate;
			}

			if(payGradeInfo[i].voucherLev == 'jumpup') {
				jumpupAmt = payGradeInfo[i].payRate;
				totAmt += payGradeInfo[i].payRate;
			}

			if(payGradeInfo[i].voucherLev == 'bang') {
				bangAmt = payGradeInfo[i].payRate;
				totAmt += payGradeInfo[i].payRate;
			}

			if(!payGradeInfo[i].voucherLev) {
				$('#currentAmt').text(global.formatCurrency(payGradeInfo[i].payAmt));
				$('#currentRate').text(payGradeInfo[i].payRate + '%');
				if(payGradeInfo[i].payRate >= 100) {
					$('#currentRate').css('color','red');
				} else {
					$('#currentRate').css('color','black');
				}
			}
		}

		if( totAmt < 120 ) {
			totAmt = 120;
		}

		bb.generate({
			data: {
			    x: "x",
			    columns: [
			   ["x", "총"],
			   ['실버',silverAmt],
			   ['골드',goldAmt],
			   ['로얄',royalAmt],
			   ['점프업',jumpupAmt],
			   ['방방곡곡',bangAmt]
			    ],
			    type: "bar", // for ESM specify as: bar()
			    groups: [
			      [
			        "실버",
			        "로얄",
			        "골드",
			        "점프업",
			        "방방곡곡"
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
			      ,max: totAmt
			    }
			  },
			  bindto: "#payBudgetStatusChart",
			  size: {
			    	height: 210,
			  },
			  bar: {
				width: {
					ratio: 10,
				    max: 50
				}
			  }
		});
	}

	function goVoucherList(code) {

		var url = "<c:url value='/voucher/voucherCompanyMngList.do' />";

		var newForm = $('<form></form>');
		newForm.attr("name","newForm");
		newForm.attr("method","post");
		newForm.attr("action", url );
		newForm.attr("target","_self");

		newForm.append($('<input/>', {type: 'hidden', name: 'searchBaseYear', value: $("#searchBaseYear").val() }));
		if(code == '01') {
			newForm.append($('<input/>', {type: 'hidden', name: 'searchStatusCd', value: '10' }));
		} else {
			newForm.append($('<input/>', {type: 'hidden', name: 'searchStatusCd', value: '90' }));
		}

		newForm.appendTo('body');
		newForm.submit();

	}

</script>