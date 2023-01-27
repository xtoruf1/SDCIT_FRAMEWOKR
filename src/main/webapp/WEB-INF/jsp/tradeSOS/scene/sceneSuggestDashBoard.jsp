<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<form id="searchForm" name="searchForm" method="post">
	<input type="hidden" id="searchBaseYear" name="searchBaseYear">
	<input type="hidden" id="status" name="status">
	<input type="hidden" id="searchKeyword" name="searchKeyword">
	<div class="location compact">
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<div class="btnGroup ml-auto">
			<input type="text" id="frDt" name="frDt" value="<c:out value="${searchVO.frDt}"/>" class="txt datepicker hidden" placeholder="시작일" title="조회시작일자입력" />
			<input type="text" id="toDt" name="toDt" value="<c:out value="${searchVO.toDt}"/>" class="txt datepicker hidden" placeholder="종료일" title="조회종료일자입력"  />
		</div>
	</div>

	<div>
		<div class="dashboard">
			<!-- dashboard body -->
			<div class="dashboard_body">
				<div class="dash_cont">
					<div class="dash_cont_body box">
						<div class="left">
							<h4 class="cont_tit ico_graphBar">온라인 신청</h4>
							<ul class="state">
								<li>
									<a href="javascript:fn_move();">
										<p id="applyCnt" class="data"></p>
										<p class="name">신청</p>
									</a>
								</li>
								<li>
									<p id="notAllocatedCnt" class="data"></p>
									<p class="name">미배정</p>
								</li>
								<li>
									<a href="javascript:fn_move('S');">
										<p id="asgnmCmpltCnt" class="data"></p>
										<p class="name">배정완료</p>
									</a>
								</li>
								<li>
									<a href="javascript:fn_move('Y');">
										<p id="onlineCnsltCmpltCnt" class="data"></p>
										<p class="name" >자문완료</p>
									</a>
								</li>
							</ul>
						</div>
						<div class="right">
							<h4 class="cont_tit ico_graphBar">자문위원</h4>
							<ul class="state">
								<li>
									<p id="cnsltWritingCnt" class="data"></p>
									<p class="name">작성중</p>
								</li>
								<li>
									<a href="javascript:fn_move('Y', 'cnslt_Y');">
										<p id="cnsltCmpltCnt" class="data"></p>
										<p class="name">자문완료</p>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>

				<!-- 그래프 영역 -->
				<div class="dashboard_graph_group">
					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">접수경로별 신청 추이</h4>
							<p class="ml-auto">단위 : 건수</p>
						</div>
						<div class="dash_cont_body">
							<div id="rcptnPathChart"></div>
						</div>
					</div>

					<div class="dashboard_graph">
						<div class="dash_cont_header">
							<h4 class="cont_tit ico_graphBar">작년 동기 비교</h4>
							<p class="ml-auto">단위 : 건수</p>
						</div>
						<div class="dash_cont_body">
							<div id="lssCmprsChart"></div>
						</div>
					</div>
				</div>

				<div class="cont_block mt-20">
					<div class="tit_bar">
						<h4 class="tit_block">지역별 현황</h4>
					</div>
					<table class="formTable align_ctr">
						<colgroup>
							<col  />
							<c:forEach items="${code034}" var="data" varStatus="status">
								<col style="width:4.9%"/>
							</c:forEach>
							<col style="width:4.5%"/>
						</colgroup>
						<thead>
						<tr>
							<th scope="col">구분</th>
							<c:forEach items="${code034}" var="data" varStatus="status">
								<th scope="col" class="break-word">${data.cdNm}</th>
							</c:forEach>
							<th scope="col">계</th>
						</tr>

						</thead>
						<tbody id="areaBody">

						</tbody>
					</table>
				</div>

			</div>

		</div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function(){
		getSurveyList();

		getReportList(); //지역별 현황 데이터
 	});

	/**
	 * 무역현장컨설팅신청현황 조회
	 */
	function getSurveyList(){
		// 로딩이미지 시작
		$('#loading_image').show();
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestDashBoardData.do" />'
			, data : {
					  frDt: $('#frDt').val().replace(/-/gi, '')
					, toDt: $('#toDt').val().replace(/-/gi, '')
					}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				// 로딩이미지 종료
				$('#loading_image').hide();
				$('#applyCnt').text(data.resultData.applyCnt);
				$('#notAllocatedCnt').text(data.resultData.notAllocatedCnt);
				$('#asgnmCmpltCnt').text(data.resultData.asgnmCmpltCnt);
				$('#onlineCnsltCmpltCnt').text(data.resultData.onlineCnsltCmpltCnt);
				$('#cnsltWritingCnt').text(data.resultData.cnsltWritingCnt);
				$('#cnsltCmpltCnt').text(data.resultData.cnsltCmpltCnt);

				setReceptionPath(data); //접수경로별 신청 추이

				setLssCmprsChart(data); //작년동기비교
			}
		});
	}

	// 지역별 현황 데이터
	function getReportList(){
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatReportListAjax.do" />'
			, data : $('#searchForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				setReportGrid(data);

			}
		});
	}

	/**
	 * 작년동기비교 차트 ( lssCmprsChart )
	 * @param data
	 */
	function setLssCmprsChart(data) {
		var list = data.lssCmprsList;
		var weeklyArr = [];      // 현재
		var yearAgoArr = [];     // 작년동기
		var daysArr = [];
		for(i = 0; i < list.length; i++) {

			if (list[i].diffDay == '0') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);

			}

			if (list[i].diffDay == '1') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			if (list[i].diffDay == '2') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			if (list[i].diffDay == '3') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			if (list[i].diffDay == '4') {
			weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			if (list[i].diffDay == '5') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			if (list[i].diffDay == '6') {
				weeklyArr.push(list[i].weeklyCnt);
				yearAgoArr.push(list[i].yearAgoCnt);
			}

			daysArr.push(list[i].regDate);
		}

		weeklyArr.unshift("현재");
		yearAgoArr.unshift("작년동기");
		daysArr.unshift("x");

		 bb.generate({
			  data: {
				x: "x",
				columns: [
				  daysArr
				, weeklyArr
				, yearAgoArr
				],
				type: "area", // for ESM specify as: bar()
			  },
			  axis: {
				x: {
				  type: "timeseries",
				  tick: {
					format: "%Y-%m-%d"
				  }
				}
			  },
			  bindto: "#lssCmprsChart",
			  size: {
			    	height: 220,
			  }
			});

	}

	/**
	 * 접수 경로별 신청 추이 차트 ( rcptnPathChart )
	 * @param data
	 */
	function setReceptionPath(data) {
		var list = data.rcptnPathList;

		var hndwrArr = [];      // 수기화
		var drctExcvtArr = [];  //직접발굴
		var evnexExhbtArr = []; //행사/전시회참가
		var rqstAdvcArr = [];   //자문신청
		var otherArr = [];      //기타
		var daysArr = [];

		for(i = 0; i < list.length; i++) {

			if (list[i].diffDay == '0') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);

			}

			if (list[i].diffDay == '1') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			if (list[i].diffDay == '2') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			if (list[i].diffDay == '3') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			if (list[i].diffDay == '4') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			if (list[i].diffDay == '5') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			if (list[i].diffDay == '6') {
				hndwrArr.push(list[i].hndwr);
				drctExcvtArr.push(list[i].drctExcvt);
				evnexExhbtArr.push(list[i].evnexExhbt);
				rqstAdvcArr.push(list[i].rqstAdvc);
				otherArr.push(list[i].other);
			}

			daysArr.push(list[i].regDate);
		}

		hndwrArr.unshift("수기화");
		drctExcvtArr.unshift("직접발굴");
		evnexExhbtArr.unshift("행사/전시회참가");
		rqstAdvcArr.unshift("자문신청");
		otherArr.unshift("기타");
		daysArr.unshift("x");

		 bb.generate({
			  data: {
				x: "x",
				columns: [
				  daysArr
				, hndwrArr
				, drctExcvtArr
				, evnexExhbtArr
				, rqstAdvcArr
				, otherArr
				],
				type: "bar", // for ESM specify as: bar()
		/*		types: {
				  data3: "spline", // for ESM specify as: spline()
				  data4: "line", // for ESM specify as: line()
				  data6: "area", // for ESM specify as: area()
				  data7: "step", // for ESM specify as: step()
				},*/
				groups: [
				  [
					  "수기화"
					, "직접발굴"
					, "행사/전시회참가"
					, "자문신청"
					, "기타"
				  ]
				]
			  },
			  axis: {
				x: {
				  type: "timeseries",
				  tick: {
					format: "%Y-%m-%d"
				  }
				}
			  },
			  bindto: "#rcptnPathChart",
			  size: {
			    	height: 220,
			  }
			});


	}

	// 지역별 현황 데이터
	function setReportGrid(data) {
		var areaList1 = data.result.list1;
		var areaList2 = data.result.list2;
		var areaList3 = data.result.list3;
		var areaList4 = data.result.list4;
		var areaHtml = "";

		areaHtml = "<tr>";
		areaHtml += "<td>상담 업체</td>";
		var totalCnt = 0
		for (var i = 0 ; i < areaList1.length ; i++){
			var cnt = getNum(parseInt(areaList1[i].CNT));
			totalCnt = totalCnt+cnt;
			areaHtml += "<td align='Right'>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td align='Right'>"+addComma(totalCnt)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>(신규신청)</td>";
		var totalCnt2 = 0
		for (var i = 0 ; i < areaList2.length ; i++){
			var cnt = getNum(parseInt(areaList2[i].CNT));
			totalCnt2 = totalCnt2+cnt;
			areaHtml += "<td align='Right'>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td align='Right'>"+addComma(totalCnt2)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>상담 건수</td>";
		var totalCnt3 = 0
		for (var i = 0 ; i < areaList3.length ; i++){
			var cnt = getNum(parseInt(areaList3[i].CNT));
			totalCnt3 = totalCnt3+cnt;
			areaHtml += "<td align='Right'>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td align='Right'>"+addComma(totalCnt3)+"</td>";
		areaHtml += "</tr>";

		areaHtml += "<tr>";
		areaHtml += "<td>현장방문</td>";
		var totalCnt4 = 0;
		for (var i = 0 ; i < areaList4.length ; i++){
			var cnt = getNum(parseInt(areaList4[i].CNT));
			totalCnt4 = totalCnt4+cnt;
			areaHtml += "<td align='Right'>"+addComma(cnt)+"</td>";
		}
		areaHtml += "<td align='Right'>"+addComma(totalCnt4)+"</td>";
		areaHtml += "</tr>";

		$("#areaBody").html(areaHtml);
	}

	function getNum(val){
		if (isNaN(val)) {
			return 0;
		}
		return val;
	}

	//콤마 추가
	function addComma(num){
		if(num<1000) return num;

		var len, point, str;
		num = num + "";
		point = num.length % 3;
		len = num.length;
		str = num.substring(0, point);

		while (point < len) {
			if (str != "") str += ",";
			str += num.substring(point, point + 3);
			point += 3;
		}
		return str;
	};

	/**
	 * 클릭 시 상담내역조회 이동
	 * @param status
	 * @param val
	 */
	function fn_move(status, val) {
		var searchKeyword = "";

		if( val == "cnslt_Y") {
			searchKeyword = '1'
		} else {
			searchKeyword = '4'
		}

		document.searchForm.action = '/tradeSOS/scene/sceneSuggestList.do';
		document.searchForm.status.value = status;
		document.searchForm.searchKeyword.value = searchKeyword;
		document.searchForm.target = '_self';
		document.searchForm.submit();
	}

</script>