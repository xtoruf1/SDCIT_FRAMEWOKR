<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchConsultTypeCd" value="${param.searchConsultTypeCd}" />
<input type="hidden" name="searchStatusCd" value="${param.searchStatusCd}" />
<input type="hidden" name="searchStartDate" value="${param.searchStartDate}" />
<input type="hidden" name="searchEndDate" value="${param.searchEndDate}" />
<input type="hidden" name="searchReqNm" value="${param.searchReqNm}" />
<input type="hidden" name="searchExptTypeCd" value="${param.searchExptTypeCd}" />
<input type="hidden" name="searchExptText" value="${param.searchExptText}" />
<input type="hidden" name="searchPblcTitle" value="${param.searchPblcTitle}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
<input type="hidden" name="pageUnit" value="<c:out value='${param.pageUnit}' default='10'/>" />
</form>
<form id="aiPopupForm" name="aiPopupForm" method="post">
<input type="hidden" id="apiCallYn" name="apiCallYn" value="Y" />
<input type="hidden" id="reqContents" name="reqContents" value="${detail.pblcContentText}" />
</form>
<input type="hidden" id="pblcConsultId" value="${param.pblcConsultId}" />
<!-- 페이지 위치 -->
<div class="location">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<c:if test="${hasAnswerYn ne 'Y'}">
			<c:if test="${detail.reqId eq memberId}">
				<button type="button" onclick="showAlertSelfApplication();" class="btn_sm btn_primary btn_modify_auth">답변추가</button>
			</c:if>
			<c:if test="${detail.reqId ne memberId}">
				<button type="button" onclick="addEditor();" class="btn_sm btn_primary btn_modify_auth">답변추가</button>
			</c:if>
		</c:if>
	</div>
	<div class="ml-15">
		<button type="button" onclick="openAiConsultPopup();" class="btn_sm btn_primary">AI 자문 확인</button>
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<div class="contents">
	<table class="formTable">
		<colgroup>
			<col style="width: 15%;" />
			<col />
			<col style="width: 15%;" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">${detail.pblcTitle}</td>
			</tr>
			<tr>
				<th scope="row">분야</th>
				<td>${detail.consultTypeNm}</td>
				<th scope="row">상태</th>
				<td>${detail.statusNm}</td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td>${detail.reqNm}</td>
				<th scope="row">이메일</th>
				<td>${detail.email}</td>
			</tr>
			<tr>
				<th scope="row">채택전문가</th>
				<td>${detail.expertNm}</td>
				<th scope="row">답변수</th>
				<td>${detail.answerCnt}</td>
			</tr>
			<tr>
				<th scope="row">작성일자</th>
				<td>${detail.creDate}</td>
				<th scope="row">조회수</th>
				<td>${detail.hitsCount}</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td colspan="3"><c:out value="${common:reverseXss(detail.pblcContent)}" escapeXml="false" /></td>
			</tr>
		</tbody>
	</table>
</div>
<c:if test="${not empty answerList}">
	<c:forEach var="item" items="${answerList}" varStatus="status">
		<c:if test="${item.expertId eq memberId}">
			<div class="cont_block mt-20">
				<!-- 타이틀 영역 -->
				<div class="tit_bar">
					<h3 class="tit_block">답변 내역</h3>
					<div class="ml-auto">
						<button type="button" id="updateButton" onclick="doUpdateAnswer('${item.answerId}');" class="btn_sm btn_primary btn_modify_auth">수정</button>
					</div>
				</div>
			</div>
			<div class="cont_block contents mt-20">
				<table class="formTable">
					<colgroup>
						<col style="width: 15%;" />
						<col />
						<col style="width: 15%;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">작성자</th>
							<td>${item.expertNm}</td>
							<th scope="row">작성일자</th>
							<td>${item.creDate}</td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="3"><textarea id="answerContent" name="answerContent" rows="10" cols="150" class="form_textarea w100p" title="내용"><c:out value="${common:reverseXss(item.answerContent)}" escapeXml="false" /></textarea></td>
						</tr>
						<tr>
							<th scope="row">관련 법률(법률)</th>
							<td colspan="3"><input type="text" id="law" name="law" value="${item.law}" class="form_text w100p" placeholder="답변 관련 법률 Ex) 관세법" /></td>
						</tr>
						<tr>
							<th scope="row">관련 법률(조항)</th>
							<td colspan="3"><input type="text" id="lawClause" name="lawClause" value="${item.lawClause}" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" /></td>
						</tr>
						<tr>
							<th scope="row">기타참고사항</th>
							<td colspan="3"><input type="text" id="dscr" name="dscr" value="${item.dscr}" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</c:if>
		<c:if test="${item.expertId ne memberId}">
			<div class="cont_block mt-20">
				<!-- 타이틀 영역 -->
				<div class="tit_bar">
					<h3 class="tit_block">답변 내역</h3>
				</div>
			</div>
			<div class="cont_block contents mt-20">
				<table class="formTable">
					<colgroup>
						<col style="width: 15%;" />
						<col />
						<col style="width: 15%;" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">작성자</th>
							<td>${item.expertNm}</td>
							<th scope="row">작성일자</th>
							<td>${item.creDate}</td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="3"><c:out value="${common:reverseXss(item.answerContent)}" escapeXml="false" /></td>
						</tr>
						<tr>
							<th scope="row">관련 법률(법률)</th>
							<td colspan="3">${item.law}</td>
						</tr>
						<tr>
							<th scope="row">관련 법률(조항)</th>
							<td colspan="3">${item.lawClause}</td>
						</tr>
						<tr>
							<th scope="row">기타참고사항</th>
							<td colspan="3">${item.dscr}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</c:if>
	</c:forEach>
</c:if>
<div class="addEditor">
</div>
<script type="text/javascript">
	$(document).ready(function(){
		<c:if test="${hasAnswerYn eq 'Y'}">
			// 초기화
			oEditors = [];
			// 에디터 활성화
			enableEditor();
		</c:if>
	});
	
	// 답변추가
	function addEditor() {
		$('.addEditor').empty();
		
		var html = '';
		html += '<div class="cont_block mt-20">';
		html += '	<div class="tit_bar">';
		html += '		<h3 class="tit_block">답변 추가</h3>';
		html += '		<div class="ml-auto align_ctr" style="display: none;">';
		html += '			<button type="button" id="saveButton" onclick="doSaveAnswer();" class="btn_sm btn_primary btn_modify_auth">저장</button>';
		html += '		</div>';
		html += '	</div>';
		html += '</div>';
		html += '<div class="cont_block contents mt-20">';
		html += '	<table class="formTable">';
		html += '		<colgroup>';
		html += '			<col style="width: 15%;" />';
		html += '			<col />';
		html += '			<col style="width: 15%;" />';
		html += '			<col />';
		html += '		</colgroup>';
		html += '		<tbody>';
		html += '			<tr>';
		html += '				<th scope="row">작성자</th>';
		html += '				<td>${userName}</td>';
		html += '				<th scope="row">작성일자</th>';
		html += '				<td>${nDate}</td>';
		html += '			</tr>';
		html += '			<tr>';
		html += '				<th scope="row">내용</th>';
		html += '				<td colspan="3"><textarea id="answerContent" name="answerContent" rows="10" cols="150" class="form_textarea w100p" title="내용"></textarea></td>';
		html += '			</tr>';
		html += '			<tr>';
		html += '				<th scope="row">관련 법률(법률)</th>';
		html += '				<td colspan="3"><input type="text" id="law" name="law" value="" class="form_text w100p" placeholder="답변 관련 법률 Ex) 관세법" /></td>';
		html += '			</tr>';
		html += '			<tr>';
		html += '				<th scope="row">관련 법률(조항)</th>';
		html += '				<td colspan="3"><input type="text" id="lawClause" name="lawClause" value="" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" /></td>';
		html += '			</tr>';
		html += '			<tr>';
		html += '				<th scope="row">기타참고사항</th>';
		html += '				<td colspan="3"><input type="text" id="dscr" name="dscr" value="" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" /></td>';
		html += '			</tr>';
		html += '		</tbody>';
		html += '	</table>';
		html += '</div>';
		
		// 답변추가 에디터 생성
		$('.addEditor').append(html);
		// 초기화
		oEditors = [];
		// 에디터 활성화
		enableEditor();
		// 저장버튼 활성화
		$('.align_ctr').show();
	}
		
	// 에디터 활성화 시키기
	var oEditors = [];
	function enableEditor() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors
			, elPlaceHolder : 'answerContent'
			, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
			, htParams : {
				// 툴바 사용 여부 (true : 사용 / false : 사용하지 않음)
				bUseToolbar : true
				// 입력창 크기 조절바 사용 여부 (true : 사용 / false : 사용하지 않음)
				, bUseVerticalResizer : true
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true : 사용 / false : 사용하지 않음)
				, bUseModeChanger : true
			}
			, fOnAppLoad : function(){
				var editorWidth = $('iframe').contents().find('#smart_editor2');
				editorWidth.css({'width' : '100%'});
			}
			, fCreator : 'createSEditor2'
		});
	}
	
	// 답변 등록
	var submitFlag = true;
	function doSaveAnswer() {
		oEditors.getById['answerContent'].exec('UPDATE_CONTENTS_FIELD', []);
		
		var answerContent = $('#answerContent').val();
		var law = $('#law').val();
		var lawClause = $('#lawClause').val();
		var dscr = $('#dscr').val();
		
		// img태그 제외 모든 태그 삭제 후 &nbsp;제거
		var checkContent = $.trim(deleteTag(answerContent, ['img']).replace(new RegExp('&nbsp;', 'gi'), ''));
		
		if (checkContent == '') {
			alert('내용을 입력해 주세요.');
			
			// 에디터 내용초기화
			oEditors.getById['answerContent'].exec('SET_IR', ['']);
			
			return false; 
		}
		
		// 에디터 img 태그 url에 도메인 추가 (KITA에서 이미지 확인을 위해)
		var defaultImageViewUrl = '/utl/web/imageSrc.do';
		var domain = window.location.protocol + '//' + window.location.host;
		var changeImageViewUrl = domain + defaultImageViewUrl;
		
		if (answerContent.indexOf(defaultImageViewUrl) != -1) {
			// 도메인 모두 삭제 (이미지 잘라내기, 붙여넣기시 img url에 도메인이 추가된거 삭제)
			answerContent = answerContent.replace(new RegExp(domain, 'gi'), '');
			// 도메인 새로 붙이기
			answerContent = answerContent.replace(new RegExp(defaultImageViewUrl, 'gi'), changeImageViewUrl);
		}
		
		if (checkByte(law, 1000, '법률', false)) {
			return false;
		}
		if (checkByte(lawClause, 1000, '조항', false)) {
			return false;
		}
		if (checkByte(dscr, 1000, '기타참고사항', false)) {
			return false;
		}
		
		$('#saveButton').prop('disabled', true);
		
		if (submitFlag) {
			submitFlag = false;
			
			global.ajax({
				url : '<c:url value="/tradeSOS/exp/insertAnswer.do" />'
				, dataType : 'json'
				, type : 'POST'
				, data : {
					pblcConsultId : $('#pblcConsultId').val()
					, answerContent : answerContent
					, law : law
					, lawClause : lawClause
					, dscr : dscr
				}
				, async : true
				, spinner : true
				, success : function(data){
					<c:choose>
						<c:when test="${empty user}">
							location.href = '<c:url value="/tradeSOS/exp/pblcConsultList.do" />';
						</c:when>
						<c:otherwise>
							alert('저장 하였습니다.');
							
							location.reload();
						</c:otherwise>
					</c:choose>
				}
			});
		}
	}
	
	// 본인답변수정
	function doUpdateAnswer(answerId) {		
		oEditors.getById['answerContent'].exec('UPDATE_CONTENTS_FIELD', []);
		
		var answerContent = $('#answerContent').val();
		var law = $('#law').val();
		var lawClause = $('#lawClause').val();
		var dscr = $('#dscr').val();
		
		// img태그 제외 모든 태그 삭제 후 &nbsp;제거
		var checkContent = $.trim(deleteTag(answerContent, ['img']).replace(new RegExp('&nbsp;', 'gi'), ''));
		
		if (checkContent == '') {
			alert('내용을 입력해 주세요.');
			
			// 에디터 내용초기화
			oEditors.getById['answerContent'].exec('SET_IR', ['']);
			
			return false; 
		}
		
		// 에디터 img 태그 url에 도메인 추가 (KITA에서 이미지 확인을 위해)
		var defaultImageViewUrl = '/utl/web/imageSrc.do';
		var domain = window.location.protocol + '//' + window.location.host;
		var changeImageViewUrl = domain + defaultImageViewUrl;
		
		if (answerContent.indexOf(defaultImageViewUrl) != -1) {
			// 도메인 모두 삭제 (이미지 잘라내기, 붙여넣기시 img url에 도메인이 추가된거 삭제)
			answerContent = answerContent.replace(new RegExp(domain, 'gi'), '');
			// 도메인 새로 붙이기
			answerContent = answerContent.replace(new RegExp(defaultImageViewUrl, 'gi'), changeImageViewUrl);
		}
		
		if (checkByte(law, 1000, '법률', false)) {
			return false;
		}
		if (checkByte(lawClause, 1000, '조항', false)) {
			return false;
		}
		if (checkByte(dscr, 1000, '기타참고사항', false)) {
			return false;
		}
		
		$('#updateButton').prop('disabled', true);
		
		global.ajax({
			url : '<c:url value="/tradeSOS/exp/updateAnswer.do" />'
			, dataType : 'json'
			, type : 'POST'
			, data :  {
				pblcConsultId : $('#pblcConsultId').val()
				, answerId : answerId
				, answerContent : answerContent
				, law : law
				, lawClause : lawClause
				, dscr : dscr
			}
			, async : true
			, spinner : true
			, success : function(data){
				<c:choose>
					<c:when test="${empty user}">
						location.href = '<c:url value="/tradeSOS/exp/pblcConsultList.do" />';
					</c:when>
					<c:otherwise>
						alert('수정 하였습니다.');
						
						location.reload();
					</c:otherwise>
				</c:choose>
			}
		});
	}
	
	// 바이트 체크
	function checkByte(str, n, text, sp) {
		var byteLength = 0;
		
		for (var inx = 0; inx < str.length; inx++) {
			var oneChar = escape(str.charAt(inx));
			
			if (oneChar.length == 1) {
				byteLength++;
			} else if (oneChar.indexOf('%u') != -1) {
				byteLength += 2;
			} else if (oneChar.indexOf('%') != -1) {
				byteLength += oneChar.length / 3;
			}
		}
		
		if ($.trim(str) == '' && sp) {
			alert(text + '을(를) 입력해 주세요.');
			
			return true;
		}
		
		if (byteLength > n) {
			alert(text + '을(를)' + n + 'byte 이하로 입력해 주세요.');
			
			return true;
		}
		
		return false;
	}
	
	//태그제거
	function deleteTag(input, allow) {
		var regExp;
		
		if (allow.length != 0) {
			regExp = '<\\/?(?!(' + allow.join('|') + '))\\b[^>]*>';
		} else {
			regExp = '<\/?[^>]*>';
		}
			
		return input.replace(new RegExp(regExp, 'gi'), '');
	}
	
	function showAlertSelfApplication() {
		alert('본인이 작성한 신청서에는 답변을 등록하실 수 없습니다.');
		
		return;
	}
	
	// AI자문 새탭 열기
	function openAiConsultPopup() {
		// 에디터 내용에 텍스트 없이 이미지만 등록이 가능한 상태라 내용에 이미지파일만 존재 할 경우 했을 경우 detail.pblcContentText 가 공백상태
		if ($('#reqContents').val() == '') {
			alert('이미지는 AI자문을 확인 할 수 없습니다.');
			
			return false;
		}
		
		timestamp = new Date().getTime();
		popupName = 'aiPopup_' + timestamp;
		
		window.open('', popupName);
		
		document.aiPopupForm.action = '<c:url value="/tradeSOS/com/aiConsultServiceList.do" />';
		document.aiPopupForm.target = popupName;
		document.aiPopupForm.submit();
	}
	
	// 목록
	function goList() {
		document.listForm.action = '<c:url value="/tradeSOS/exp/pblcConsultList.do" />';
		document.listForm.target = '_self';
		document.listForm.submit();
	}
</script>