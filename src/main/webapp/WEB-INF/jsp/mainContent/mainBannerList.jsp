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
			<button class="tab on" onclick="goOpenPage();" title="현재배너">현재배너</button>
			<button class="tab"    onclick="goClosePage();" title="지난배너">지난배너</button>
		</div>
		<form name="mainBannerListForm" action="" method="post">
			<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default='0' />" />
			<input type="hidden" id="typeFlag" name="typeFlag" value="<c:out value="${searchVO.typeFlag}" default='' />"/>
			<input type="hidden" id="viewUrl" name="viewUrl" value="<c:out value="${viewUrl}"/> ">
			<div class="tab_body" style="margin-top: 10px;">
				<div class="tab_cont on">
					<div class="tit_bar">
						<!-- 타이틀 영역 -->
						<h3 class="tit_block">배너 목록</h3>
						<div class="ml-auto">
							<button type="button" id="btnAdd" class="btn_sm btn_primary btn_modify_auth" onclick="addBanner();">추가</button>
						</div>
					</div>
					<div class="cont_block mt-20">
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
		f = document.mainBannerListForm;

		getList();

	});

	function goPage( pageIndex) {
		f.pageIndex.value = pageIndex;
		getList();      //현재배너

	}

	// 현재배너
	function getList(){
	   global.ajax({
				type : 'POST'
				, url : '<c:url value="/mainContent/openList.do" />'
				, data : $('#mainBannerListForm').serialize()
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					var list = '';

					list += '<ul>';
					for (var i = 0; i < data.resultList.length; i++) {

						list += '<table class="formTable dataTable">';
						list += '<colgroup>';
						list += '	<col width="40%">';
						list += '</colgroup>';
						list += '<tboody>';
						list += ' <tr style="cursor: pointer" onclick="getBannerInfo('+ data.resultList[i].mainBannerId +');">';
						list += ' 	<td>';
						list += ' 	    <img src="/cmm/fms/getImage.do?atchFileId=" '+ data.resultList[i].pcFileId +'&fileSn=0" style="width: 400px; height: 80px;" alt="해당파일이미지" />';
						list += ' 	</td>';
						list += ' 	<td class="td left">';
						list += ' 	    제목: ' + data.resultList[i].title +' </br>';
						list += ' 	    게재기간 : ' + data.resultList[i].fromDate +' ~ ' + data.resultList[i].endDate + ' </br> ';
						list += ' 	    링크구분 : ' + data.resultList[i].linkType +'';
						list += ' 	</td>';
						list += ' </tr>';
						list += '</tboody>';
						list += '</table>';
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
				}
			});
	}

	// 배너 추가
	function addBanner() {
		location.href = "/mainContent/mainBannerAdd.do";
	}

	// 현재배너 상세
	function getBannerInfo(mainBannerId) {
		location.href = "/mainContent/mainBannerOpenModify.do?mainBannerId="+mainBannerId;
	}

	// 현재배너
	function goOpenPage() {
		location.href = '<c:url value="/mainContent/mainBannerOpen.do" />';
	}

	// 지난배너
	function goClosePage() {
		location.href = '<c:url value="/mainContent/mainBannerOpen.do?typeFlag=close" />';
	}
</script>