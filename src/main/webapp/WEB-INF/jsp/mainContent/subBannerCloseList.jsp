<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="cont_block">
	<div class="tabGroup">
		<div class="tab_header">
			<button class="tab" onclick="goOpenPage();" title="현재배너">현재배너</button>
			<button class="tab on"    onclick="goClosePage();" title="지난배너">지난배너</button>
		</div>
		<form id="subBannerListForm" name="subBannerListForm" action="" method="post">
			<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default='0' />" />
			<input type="hidden" id="typeFlag" name="typeFlag" value="<c:out value="${searchVO.typeFlag}" default='' />"/>
			<input type="hidden" id="viewUrl" name="viewUrl" value="<c:out value="${viewUrl}"/> ">
			<div class="tab_body">
				<div class="tab_cont on">
					<div class="tit_bar">
						<!-- 타이틀 영역 -->
						<h3 class="tit_block">배너 목록</h3>
						<div class="btnGroup ml-auto">
						</div>
					</div>
					<div class="cont_block">
						<!-- 리스트 테이블 -->
						<div style="width: 100%;height: 100%;">
							<div id='boardList' class="colPosi"></div>
						</div>
						<!-- .paging-->
						<div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
						<!-- //.paging-->
					</div>
				</div>
			</div>
		</form>
	</div>
</div>

<script type="text/javaScript" language="javascript">
	var f;
	$(document).ready(function() {
		f = document.subBannerListForm;
		getList();

	});

	function goPage( pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();
	}

	function getList(){
	   global.ajax({
				type : 'POST'
				, url : '<c:url value="/mainContent/subBannercloseList.do" />'
				, data : $('#subBannerListForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					var list = '';

					list += '<ul>';
					if(data.resultList.length == 0) {

						list += '<table class="formTable dataTable">';
						list += '<colgroup>';
						list += '	<col width="40%">';
						list += '</colgroup>';
						list += '<tboody>';
						list += '<tr>';
						list += '	<td colspan="2" style="text-align: center; height: 100px">등록된 데이터가 없습니다.</td>';
						list += '</tr>';
						list += '</tboody>';
						list += '</table>';
					} else {
						for (var i = 0; i < data.resultList.length; i++) {

							list += '<table class="formTable dataTable">';
							list += '<colgroup>';
							list += '	<col width="40%">';
							list += '</colgroup>';
							list += '<tboody>';
							list += ' <tr style="cursor: pointer" onclick="getBannerInfo('+ data.resultList[i].subBannerId +');">';
							list += ' 	<td>';
							list += '   	<div id="video-container" class="videoCenter mb30">';
							list += ' 	    	<iframe width="400" src="https://www.youtube.com/embed/'+ data.resultList[i].youtubeUrl +'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen />';
							list += '   	</div>';
							list += ' 	</td>';
							list += ' 	<td class="td left">';
							list += ' 	    제목: ' + data.resultList[i].title +' </br>';
							list += ' 	    게재기간 : ' + data.resultList[i].fromDate +' ~ ' + data.resultList[i].endDate + ' </br> ';
							list += ' 	</td>';
							list += ' </tr>';
							list += '</tboody>';
							list += '</table>';
						}

					}
					list += '</ul>';
					$('#boardList').html(list);

					//PC페이징
					setPaging(
						'paging'
						, goPage
						, data.paginationInfo.currentPageNo
						, data.paginationInfo.totalRecordCount
						, data.paginationInfo.recordCountPerPage
						, data.paginationInfo.pageSize
					);

			   		$("#viewUrl").val("/mainContent/subBannerModify.do");
				}
			});
	}

	//서브배너 추가
	function addBanner() {
		location.href = "/mainContent/subBannerAdd.do";
	}

	//상세 페이지
	function getBannerInfo(subBannerId) {
		var url = $('#viewUrl').val();
		location.href = url+"?subBannerId="+subBannerId;
	}

	// 현재배너
	function goOpenPage() {
		location.href = '<c:url value="/mainContent/subBannerOpen.do" />';
	}

	// 지난배너
	function goClosePage() {
		location.href = '<c:url value="/mainContent/subBannerOpen.do?typeFlag=close" />';
	}
</script>