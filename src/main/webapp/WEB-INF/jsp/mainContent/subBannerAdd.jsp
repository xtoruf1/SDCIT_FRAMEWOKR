<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="cont_block">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<!-- 섹션 타이틀 -->
	</div>
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab on" onclick="goOpenPage();">현재배너</button>
			<button class="tab" onclick="fn_Closelist();">지난배너</button>
		</div>
		<form id="bannerRegForm" name="bannerRegForm" action="" method="post">
			<table class="formTable">
				<colgroup>
					<col style="width:120px;" />
					<col/>
				</colgroup>
				<tbody>
				<tr>
					<th>제목</th>
					<td>
						<input type="text" class="form_text w100p" name="title" id="title" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<th>게재기간</th>
					<td class="pick_area">
						<div class="group_datepicker">
							<!-- datepicker -->
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="fromDate" name="fromDate" value='' class="txt datepicker" placeholder="시작일" title="게재기간 시작일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyStartDate" value="" />
								</span>
							</div>
							<div class="spacing">~</div>
							<div class="datepicker_box">
								<span class="form_datepicker">
									<input type="text" id="endDate" name="endDate" value='' class="txt datepicker" placeholder="종료일" title="게재기간 종료일" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									<input type="hidden" id="dummyEndDate" value="" />
								</span>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>유튜브 링크</th>
					<td>
						https://www.youtube.com/embed/<input type="text" class="form_text" name="youtubeUrl" id="youtubeUrl" maxlength="200" style="width: 120px;" />&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" id="btnHelp" class="btn_tbl" onclick="helpPop();">HELP</button>
					</td>
				</tr>
				<tr>
					<th>공개여부</th>
					<td>
						<label class="label_form">
							<input type="radio" name="viewYn" class="form_radio" id="viewYnY" value="Y" checked/>
							<span class="label">공개</span>
						</label>
						<label class="label_form">
							<input type="radio" name="viewYn" class="form_radio" id="viewYnN" value="N" >
							<span class="label">비공개</span>
						</label>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="btn_group mt-20 _center">
				<button type="button" id="btnSave" class="btn btn_primary" onclick="saveBanner();">저장</button>
				<button type="button" id="btnList" class="btn btn_secondary" onclick="goList();">목록</button>
			</div>
		</form>
	</div>
</div>


<script type="text/javaScript" language="javascript">
	$(document).ready(function() {

	});

	function helpPop(){
		window.open('/help/youtube_help.jsp', "SDCIT", "width=1060, height=600, scrollbars=yes, toolbar=no, menubar=no");
	}

	function goList(){
		location.href = "/mainContent/subBannerOpen.do";
	}

	function saveBanner() {

		if( jQuery('#title').val() == '' ){
			alert('제목은 필수입니다.');
			jQuery('#title').focus();
			return false;
		} else if( jQuery('#fromDate').val() == '' ){
			alert('게재 시작일자는 필수입니다.');
			jQuery('#fromDate').focus();
			return false;
		} else if( jQuery('#youtubeUrl').val() == '' ){
			alert('유튜브 링크는 필수입니다.');
			jQuery('#youtubeUrl').focus();
			return false;
		}

		if(confirm('저장 하시겠습니까?')){
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/mainContent/saveSubBanner.do" />'
				, data : $('#bannerRegForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 게시물을 등록하였습니다.');

					// 수정화면으로 이동
					location.href = '<c:url value="/mainContent/subBannerOpenModify.do"/>?subBannerId='+data.subBannerId;
				}
			});

		}
	}

	function fn_Closelist() {
			location.href = '<c:url value="/mainContent/subBannerOpen.do?typeFlag=close" />';
	}

	// 현재배너
	function goOpenPage() {
		location.href = '<c:url value="/mainContent/subBannerOpen.do" />';
	}
</script>