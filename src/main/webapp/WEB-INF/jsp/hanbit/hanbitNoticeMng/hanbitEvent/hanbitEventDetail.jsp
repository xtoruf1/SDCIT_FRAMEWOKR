<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="goReg();">수정</button>
		<button type="button" class="btn_sm btn_secondary btn_modify_auth" onclick="doDelete();">삭제</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>

<form id="searchForm" name="searchForm" method="post">
	<input type="hidden" id="searchTitle" name="searchTitle" value="${params.searchTitle}"/>
	<input type="hidden" id="searchStdt" name="searchStdt" value="${params.searchStdt}"/>
	<input type="hidden" id="searchEddt" name="searchEddt" value="${params.searchEddt}"/>
</form>

<form id="frm" name="frm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="noticeId" name="noticeId" value="${resultInfo.noticeId}"/>
	<input type="hidden" id="attachSeq" name="attachSeq" value="${resultInfo.attachSeq}"/>
	<input type="hidden" id="mainFileSeq" name="mainFileSeq" value="${resultInfo.mainFileSeq}"/>
	<input type="hidden" id="repFileName" name="repFileName" value=""/>
	<div class="cont_block">
		<div class="board_details_top">
			<div class="board_details_top_inner">
				<h3 class="tit"><c:out value="${resultInfo.noticeTitle}" /></h3>
				<p class="date"><c:out value="${resultInfo.regDate}" /></p>
			</div>
		</div>
		<div class="board_details_body">
		<c:forEach items="${fileList}" var="fileList" varStatus="status">
			<img alt="" src="/hanbit/hanbitNoticeMng/habitNoticeImage.do?attachSeq=${fileList.attachSeq}&fileSeq=${fileList.fileSeq}">
		</c:forEach>
		</div>
		<br/><br/>
		<p style="padding:20px; word-break: break-all;"><c:out value="${resultInfo.noticeContent}" escapeXml="False" /></p>
	</div>
</form>
<script type="text/javascript">

	function goList() {
		$('#searchForm').attr('action', '/hanbit/hanbitNoticeMng/hanbitEventList.do');
		$('#searchForm').submit();
	}

	function goReg() {
		$('#frm').attr('action', '/hanbit/hanbitNoticeMng/hanbitEventReg.do');
		$('#frm').submit();
	}

	function doDelete() {

		if(!confirm('삭제 하시겠습니까?')) {
			return;
		}

		var noticeId = $('#noticeId').val();
		var attachSeq = $('#attachSeq').val();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitNoticeMng/deleteHanbitNoticeInfo.do"
			, data : {'noticeId' : noticeId,
					  'attachSeq' : attachSeq
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				goList();
			}
		});
	}

</script>
