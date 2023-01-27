<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="ly_column">
	<div class="dashboard">
		<!-- dashboard header -->
		<div class="dashboard_header">
			<!-- dashboard title -->
			<h3 class="header_tit">1:1 상담 현황</h3>
		</div>
		
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_dashboard">오늘의 현황</h4>
					<p class="date ml-auto">2022. 6. 9 현재</p>
				</div>
				<div class="dash_cont_body">
					<ul class="state">
						<li>
							<p class="data">17</p>
							<p class="name">신청</p>
						</li>
						<li>
							<p class="data">15</p>
							<p class="name">확정</p>
						</li>
						<li>
							<p class="data">2</p>
							<p class="name">취소</p>
						</li>
						<li>
							<p class="data ">0</p>
							<p class="name">NoShow</p>
						</li>
					</ul>
				</div>
			</div>
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">1 : 1 상담 추이</h4>
				</div>
				<div class="dash_cont_body">
					<img src="<c:url value='/images/admin/temp_graph_bar.png' />" alt="그래프" style="width:100%;">
				</div>
			</div>
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphDonut">상담 채널 분포</h4>
					<p class="date ml-auto">2022. 5. 10 ~ 2022. 6. 9 기준</p>
				</div>
				<div class="dash_cont_body">
					<img src="<c:url value='/images/admin/temp_graph_donut.png' />" alt="그래프" style="width:100%;">
				</div>
			</div>
		</div>
	</div>
	
	<div class="dashboard">
		<!-- dashboard header -->
		<div class="dashboard_header">
			<!-- dashboard title -->
			<h3 class="header_tit">오픈 상담 현황</h3>
		</div>
		
		<!-- dashboard body -->
		<div class="dashboard_body">
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_dashboard">오늘의 현황</h4>
					<p class="date ml-auto">2022. 6. 9 현재</p>
				</div>
				<div class="dash_cont_body">
					<ul class="state">
						<li>
							<p class="data">7</p>
							<p class="name">등록</p>
						</li>
						<li>
							<p class="data">5</p>
							<p class="name">답변</p>
						</li>
						<li>
							<p class="data">2</p>
							<p class="name">미답변</p>
						</li>
						<li>
							<p class="data ">12</p>
							<p class="name">미답변 <span>(누계)</span></p>
						</li>
					</ul>
				</div>
			</div>
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphBar">오픈 상담 추이</h4>
				</div>
				<div class="dash_cont_body">
					<img src="<c:url value='/images/admin/temp_graph_bar.png' />" alt="그래프" style="width:100%;">
				</div>
			</div>
			<div class="dash_cont">
				<div class="dash_cont_header">
					<h4 class="cont_tit ico_graphDonut">답변 등록 전문가</h4>
					<p class="date ml-auto">2022. 5. 10 ~ 2022. 6. 9 기준</p>
				</div>
				<div class="dash_cont_body">
					<img src="<c:url value='/images/admin/temp_graph_donut.png' />" alt="그래프" style="width:100%;">
				</div>
			</div>
		</div>
	</div>
</div>