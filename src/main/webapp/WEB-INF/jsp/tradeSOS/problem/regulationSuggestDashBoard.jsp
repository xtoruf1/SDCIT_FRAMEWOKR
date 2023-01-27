<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url value="/tradeSOS/problem/regulationSuggestList.do" var="goUrl" />

<div class="location compact dashboard_center">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="search">
		<div class="dateSelector" style="text-align: center;">
			<button type="button" onclick="setPrevDate();" class="btn_standard" style="border-radius: 3px;"><span class="prev"></span></button>
			<input type="text" id="selectDate" value="" onchange="changeSelectDate(this.value);" class="yearpicker changeCalender" readonly="readonly" />
			<button type="button" onclick="setNextDate();" class="btn_standard" style="border-radius: 3px;"><span class="next"></span></button>
			<input type="hidden" id="searchBaseYear" name="searchBaseYear" />
		</div>
	</div>
</div>

<form id="searchForm" method="post">
	<div>
		<div class="dashboard">
			<!-- dashboard body -->
			<div class="dashboard_body">
				<div class="dash_cont">
					<div class="dash_cont_body">
						<ul class="state">
							<li>
								<a href="<c:out value="${goUrl}"/>"><p id="ryCnt" class="data"></p></a>
								<p class="name">신청</p>
							</li>
							<li>
								<a href="<c:out value="${goUrl}"/>"><p id="syCnt" class="data"></p></a>
								<p class="name">검토</p>
							</li>
							<li>
								<a href="<c:out value="${goUrl}"/>"><p id="myCnt" class="data"></p></a>
								<p class="name">이관</p>
							</li>
							<li>
								<a href="<c:out value="${goUrl}"/>"><p id="fyCnt" class="data"></p></a>
								<p class="name">완료</p>
							</li>
						</ul>
					</div>
				</div>
				<!-- 그래프 영역 -->
				<div class="dashboard_graph_group">
					<div class="dashboard_graph w100p">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">지역별신청현황</h4>
							<p class="ml-auto">단위 : 건수</p>
						</div>
						<div class="dash_cont_body">
							<div id="areaReqChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">분야별신청현황</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="rgfRegCntChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">신청채널별현황</h4>
							<p class="ml-auto">단위 : 비율(%)</p>
						</div>
						<div class="dash_cont_body">
							<div id="channelReqChart"></div>
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

		//url 변경
		setUrl();

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

		//날짜 변경에 따른 url 변경
		setUrl();
	}

	function getData() {

		$('#loading_image').show(); // 로딩이미지 시작

		var searchBaseYear = $('#searchBaseYear').val();

		global.ajax({
			type : 'POST'
			, url : '/tradeSOS/problem/regulationSuggestDashBoardAjax.do'
			, data : {'searchBaseYear' : searchBaseYear}
			, async : true
			, success : function(data){

				$('#loading_image').hide(); // 로딩이미지 종료

				// 신청
				var ryCnt = 0;

				// 검토
				var syCnt = 0;

				// 완료
				var fyCnt = 0;

				// 이관
				var myCnt = 0;

				for(var i = 0; i < data.regInfo.length; i++) {

					if(data.regInfo[i].CD_ID == 'RY') {
						ryCnt = data.regInfo[i].REQ_CNT;
						$('#ryCnt').text(ryCnt);
					}

					if(data.regInfo[i].CD_ID == 'SY') {
						syCnt = data.regInfo[i].REQ_CNT;
						$('#syCnt').text(syCnt);
					}

					if(data.regInfo[i].CD_ID == 'FY') {
						fyCnt = data.regInfo[i].REQ_CNT;
						$('#fyCnt').text(fyCnt);
					}

					if(data.regInfo[i].CD_ID == 'MY') {
						myCnt = data.regInfo[i].REQ_CNT;
						$('#myCnt').text(myCnt);
					}
				}

				// 지역별 신청 현황
				var areaReqList = data.areaReqList;

				areaReqChart(areaReqList);

				// 분야별 신청 현황
				var rgfReqList = data.rgfReqList;

				rgfRegCntChart(rgfReqList);

				// 신청채널별 현황
				var channelReqList = data.channelReqList;

				channelReqCnt(channelReqList);

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

	function areaReqChart(areaReqList) {

		var cntArr = [];
		var codeArr = [];

		for(i = 0; i < areaReqList.length;  i++){
			cntArr.push(areaReqList[i].REQ_CNT);
			codeArr.push(areaReqList[i].CODE_NM);
		}

		cntArr.unshift('신청수');
		codeArr.unshift('지역');


		bb.generate({
		    bindto: "#areaReqChart",
		    size: {
		    	height: 210,
		    },
		    data: {
		        type: "bar",
		        x : '지역',
		        columns: [
		        	cntArr,
		        	codeArr
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

	function rgfRegCntChart(rgfReqList) {

		var codeArr1 = [];
		var codeArr2 = [];
		var codeArr3 = [];
		var codeArr4 = [];
		var codeArr5 = [];
		var codeArr6 = [];
		var codeArr7 = [];
		var totCnt = 0;

		for(i = 0; i < rgfReqList.length;  i++){

			if(rgfReqList[i].CD_ID == '1000') {
				codeArr1.push(rgfReqList[i].REQ_CNT+100);
				codeArr1.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '2000') {
				codeArr2.push(rgfReqList[i].REQ_CNT+100);
				codeArr2.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '3000') {
				codeArr3.push(rgfReqList[i].REQ_CNT+100);
				codeArr3.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '4000') {
				codeArr4.push(rgfReqList[i].REQ_CNT+100);
				codeArr4.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '5000') {
				codeArr5.push(rgfReqList[i].REQ_CNT+100);
				codeArr5.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '6000') {
				codeArr6.push(rgfReqList[i].REQ_CNT+100);
				codeArr6.unshift(rgfReqList[i].CODE_NM);
			}

			if(rgfReqList[i].CD_ID == '7000') {
				codeArr7.push(rgfReqList[i].REQ_CNT);
				codeArr7.unshift(rgfReqList[i].CODE_NM);
			}

			totCnt += rgfReqList[i].REQ_CNT;
		}

		if(totCnt <= 100) {

			for(i = 0; i < rgfReqList.length;  i++){

				if(rgfReqList[i].CD_ID == '1000') {
					codeArr1 = [];
					codeArr1.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr1.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '2000') {
					codeArr2 = [];
					codeArr2.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr2.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '3000') {
					codeArr3 = [];
					codeArr3.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr3.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '4000') {
					codeArr4 = [];
					codeArr4.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr4.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '5000') {
					codeArr5 = [];
					codeArr5.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr5.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '6000') {
					codeArr6 = [];
					codeArr6.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr6.unshift(rgfReqList[i].CODE_NM);
				}

				if(rgfReqList[i].CD_ID == '7000') {
					codeArr7 = [];
					codeArr7.push(rgfReqList[i].REQ_CNT / totCnt * 100);
					codeArr7.unshift(rgfReqList[i].CODE_NM);
				}
			}

		}


		bb.generate({
		    bindto: "#rgfRegCntChart",
		    size: {
		    	height: 220,
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	codeArr1,
		        	codeArr2,
		        	codeArr3,
		        	codeArr4,
		        	codeArr5,
		        	codeArr6,
		        	codeArr7
		        ],
		        labels: true
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

	function channelReqCnt(channelReqList) {

		var codeArr1 = [];
		var codeArr2 = [];
		var codeArr3 = [];
		var codeArr4 = [];
		var codeArr5 = [];
		var codeArr6 = [];
		var codeArr7 = [];
		var codeArr8 = [];
		var codeArr9 = [];
		var totCnt = 0;

		for(i = 0; i < channelReqList.length;  i++){

			if(channelReqList[i].CD_ID == '1001') {
				codeArr1.push(channelReqList[i].REQ_CNT);
				codeArr1.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1002') {
				codeArr2.push(channelReqList[i].REQ_CNT);
				codeArr2.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1003') {
				codeArr3.push(channelReqList[i].REQ_CNT);
				codeArr3.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1005') {
				codeArr4.push(channelReqList[i].REQ_CNT);
				codeArr4.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1007') {
				codeArr5.push(channelReqList[i].REQ_CNT);
				codeArr5.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1008') {
				codeArr6.push(channelReqList[i].REQ_CNT);
				codeArr6.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1009') {
				codeArr7.push(channelReqList[i].REQ_CNT);
				codeArr7.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1010') {
				codeArr8.push(channelReqList[i].REQ_CNT);
				codeArr8.unshift(channelReqList[i].CODE_NM);
			}

			if(channelReqList[i].CD_ID == '1011') {
				codeArr9.push(channelReqList[i].REQ_CNT);
				codeArr9.unshift(channelReqList[i].CODE_NM);
			}

			totCnt += channelReqList[i].REQ_CNT;
		}

		if(totCnt <= 100) {

			for(i = 0; i < channelReqList.length;  i++){

				if(channelReqList[i].CD_ID == '1001') {
					codeArr1 = [];
					codeArr1.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr1.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1002') {
					codeArr2 = [];
					codeArr2.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr2.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1003') {
					codeArr3 = [];
					codeArr3.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr3.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1005') {
					codeArr4 = [];
					codeArr4.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr4.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1007') {
					codeArr5 = [];
					codeArr5.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr5.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1008') {
					codeArr6 = [];
					codeArr6.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr6.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1009') {
					codeArr7 = [];
					codeArr7.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr7.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1010') {
					codeArr8 = [];
					codeArr8.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr8.unshift(channelReqList[i].CODE_NM);
				}

				if(channelReqList[i].CD_ID == '1011') {
					codeArr9 = [];
					codeArr9.push(channelReqList[i].REQ_CNT / totCnt * 100);
					codeArr9.unshift(channelReqList[i].CODE_NM);
				}
			}
		}

		bb.generate({
		    bindto: "#channelReqChart",
		    size: {
		    	height: 220
		    },
		    data: {
		        type: "gauge",
		        columns: [
		        	codeArr1,
		        	codeArr2,
		        	codeArr3,
		        	codeArr4,
		        	codeArr5,
		        	codeArr6,
		        	codeArr7,
		        	codeArr8,
		        	codeArr9
		        ],
		        labels: true
		    },
		    legend: {
	            position: "inset",
	            inset: {
	                anchor: "top-right",  // top-left, top-right, bottom-left, bottom-right
	                x: -20,
	                y: -20
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
		var searchBaseYear = $('#selectDate').val();

		//신청 url 설정
		var ryCntHref = $('#ryCnt').parent().attr('href').split('?')[0];
		$('#ryCnt').parent().attr('href', ryCntHref + '?recDateFrom=' + searchBaseYear + '-01-01&recDateTo=' + searchBaseYear + '-12-31&proState=RY');

		//검토 url 설정
		var syCntHref = $('#syCnt').parent().attr('href').split('?')[0];
		$('#syCnt').parent().attr('href', syCntHref + '?recDateFrom=' + searchBaseYear + '-01-01&recDateTo=' + searchBaseYear + '-12-31&proState=PY');

		//이관 url 설정
		var myCntHref = $('#myCnt').parent().attr('href').split('?')[0];
		$('#myCnt').parent().attr('href', myCntHref + '?recDateFrom=' + searchBaseYear + '-01-01&recDateTo=' + searchBaseYear + '-12-31&proState=M');

		//완료 url 설정
		var fyCntHref = $('#fyCnt').parent().attr('href').split('?')[0];
		$('#fyCnt').parent().attr('href', fyCntHref + '?recDateFrom=' + searchBaseYear + '-01-01&recDateTo=' + searchBaseYear + '-12-31&proState=FY');
	}

</script>