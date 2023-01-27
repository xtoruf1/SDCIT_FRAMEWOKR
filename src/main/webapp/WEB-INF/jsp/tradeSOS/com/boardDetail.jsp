<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib  prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="listForm" name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="searchCreNm" value="${param.searchCreNm}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10' />" />
</form>
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:if test="${resultView.creBy eq user.loginId or requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardDetail.do'}">
			<button type="button" onclick="goModify();" class="btn_sm btn_primary btn_modify_auth">수정</button>
			<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
		</c:if>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<form id="boardForm" name="boardForm" method="post">
<input type="hidden" id="boardId" name="boardId" value="${resultView.boardId}" />
<input type="hidden" id="fileId" name="fileId" value="${resultView.fileId}" />
<div class="contents">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>${resultView.title}</td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td>${resultView.creNm}</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td><c:out value="${resultView.content}" escapeXml="false" /></td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td id="attachFieldList">
					<c:choose>
						<c:when test="${fn:length(fileList) > 0}">
							<c:forEach var="item" items="${fileList}" varStatus="status">
								<div class="addedFile" <c:if test="${status.first}">style="margin-top: 10px;"</c:if>>
									<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${item.fileId}&fileSeq=${item.fileSeq}" class="filename">${item.orgFileNm}</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.fileId}&fileSeq=${item.fileSeq}', '${item.orgFileNm}', 'membershipboard_${profile}_${item.fileId}_${item.fileSeq}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
						</c:when>
					</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div class="cont_block mt-20">
	<!-- 타이틀 영역 -->
	<div class="tit_bar">
		<h3 class="tit_block">댓글</h3>
		<div class="ml-auto">
			<button type="button" onclick="doAddReply();" class="btn_sm btn_primary btn_modify_auth">댓글추가</button>
		</div>
	</div>
</div>
<div class="contents">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 150px;" />
		</colgroup>
		<tbody>
			<c:if test="${fn:length(replyList) eq 0}">
				<tr>
					<td colspan="3" style="text-align: center;padding: 16px 10px 16px 10px;">등록된 댓글이 없습니다.</td>
				</tr>
			</c:if>
			<c:forEach var="list" items="${replyList}" varStatus="status">
				<tr>
					<th scope="row">
						${list.creNm}
						<br />
						(${list.creDate})
					</th>
					<td>
						<div class="replyViewDiv"><c:out value="${fn:replace(list.reply, newline, '<br/>')}" escapeXml="false"/></div>
						<div class="replyEditDiv" style="display: none;">
							<textarea name="updateReply" rows="7" cols="150" class="form_textarea" title="내용"><c:out value="${list.reply}" escapeXml="false" /></textarea>
							<input type="hidden" name="replyId" value="${list.replyId}" />
						</div>
					</td>
					<td style="text-align: center;">
						<c:if test="${list.creBy eq user.loginId}">
							<button type="button" onclick="doUpdateReply('${status.index}');" class="btn_tbl_primary btn_modify_auth btnUpdateReply">수정</button>
							<button type="button" onclick="doDeleteReply('${list.replyId}');" class="btn_tbl_border btn_modify_auth btnDeleteReply">삭제</button>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="addReply">
	</div>
</div>
</form>
<script type="text/javascript">
	function doDelete() {
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradePro/board/removeBoard.do" />'
				, data : {
					boardId : $('#boardId').val()
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					goList();
				}
			});
		}
	}

	function doAddReply() {
		for (var i = 0; i < $('.replyViewDiv').length; i++) {
			$('.replyEditDiv').eq(i).hide();
			$('.btnUpdateReply').eq(i).text('수정');
			$('.replyViewDiv').eq(i).show();
		}

		for (var i = 0; i < $('.btnUpdateReply').length; i++) {
			$('.btnUpdateReply').eq(i).text('수정');
		}

		$('.addReply').empty();

		var html = '';
		html += '<div class="cont_block mt-20">';
		html += '	<div class="tit_bar">';
		html += '		<h3 class="tit_block">댓글추가</h3>';
		html += '	</div>';
		html += '</div>';
		html += '<div class="contents">';
		html += '	<table class="formTable">';
		html += '		<colgroup>';
		html += '			<col style="width: 15%;" />';
		html += '			<col />';
		html += '			<col style="width: 150px;" />';
		html += '		</colgroup>';
		html += '		<tbody>';
		html += '			<tr>';
		html += '				<th scope="row">내용</th>';
		html += '				<td>';
		html += '					<textarea id="reply" name="reply" rows="7" cols="150" class="form_textarea" title="내용"></textarea>';
		html += '				</td>';
		html += '				<td style="text-align: center;">';
		html += '					<button type="button" id="saveBtn" onclick="doSaveReply();" class="btn_tbl_primary _full" style="height:100px">저장</button>	';
		html += '				</td>';
		html += '			</tr>';
		html += '		</tbody>';
		html += '	</table>';
		html += '</div>';

		// 답변추가 에디터 생성
		$('.addReply').append(html);
	}

	function doSaveReply() {
		if ($('#reply').val().trim() == '') {
			alert('댓글 내용을 입력해 주세요.');

			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradePro/board/saveBoardReply.do" />'
			, data : {
				boardId : $('#boardId').val()
				, replyId : ''
				, reply : $('#reply').val()
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				window.location.reload(true);
			}
		});
	}

	function doUpdateReply(idx) {
		// 수정 버튼을 클릭하였을때
		// 댓글추가 영역 삭제 -> 현재 클릭한 댓글제외한 다른영역 댓글 수정창 숨기기
		if ($('.replyEditDiv').eq(idx).parent('td').next().find('.btnUpdateReply').text() == '수정') {
			$('.addReply').empty();

			for (var i = 0; i < $('.replyViewDiv').length; i++) {
				$('.replyEditDiv').eq(i).hide();
				$('.btnUpdateReply').eq(i).text('수정');
				$('.replyViewDiv').eq(i).show();
			}

			for (var i = 0; i < $('.btnUpdateReply').length; i++) {
				$('.btnUpdateReply').eq(i).text('수정');
			}

			$('.replyViewDiv').eq(idx).hide();
			$('.replyEditDiv').eq(idx).show();
			$('.replyEditDiv').eq(idx).parent('td').next().find('.btnUpdateReply').text('저장');
		// 저장 버튼 클릭 하였을때
		// 저장 프로세스 실행
		} else {
			if ($('textarea[name="updateReply"]').eq(idx).val().trim() == '') {
				alert('입력한 내용이 없습니다.');

				return;
			}

			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradePro/board/saveBoardReply.do" />'
				, data : {
					boardId : $('#boardId').val()
					, replyId : $('input[name=replyId').eq(idx).val()
					, reply : $('textarea[name=updateReply').eq(idx).val()
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					window.location.reload(true);
				}
			});
		}
	}

	function doDeleteReply(replyId) {
		if (confirm('해당 댓글을 삭제 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradePro/board/removeBoardReply.do" />'
				, data : {
					boardId : $('#boardId').val()
					, replyId : replyId
					, reply : $('#reply').val()
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					window.location.reload(true);
				}
			});
		}
	}

	function goModify() {
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardDetail.do'}">
			document.boardForm.action = '<c:url value="/tradePro/board/boardForm.do" />';
		</c:if>
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/memberBoardDetail.do'}">
			document.boardForm.action = '<c:url value="/tradePro/board/memberBoardForm.do" />';
		</c:if>

		document.boardForm.submit();
	}

	function goList() {
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/boardDetail.do'}">
			document.listForm.action = '<c:url value="/tradePro/board/boardList.do" />';
		</c:if>
		<c:if test="${requestScope['javax.servlet.forward.servlet_path'] == '/tradePro/board/memberBoardDetail.do'}">
			document.listForm.action = '<c:url value="/tradePro/board/memberBoardList.do" />';
		</c:if>

		document.listForm.submit();
	}
</script>