<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>
<form id="writeForm" name="writeForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="articleSeq" name="articleSeq" value="<c:out value='${resultView.articleSeq}' default='0' />" />
<input type="hidden" id="groupId" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" id="attachSeq" name="attachSeq" value="${resultView.attachSeq}" />
<input type="hidden" id="noticeId" name="noticeId" value="${resultData.noticeId}" />
	<input type="hidden" name="fileId" value="${resultData.fileId}">
<input type="hidden" name="topMenuId" value="" />
<%-- <input type="hidden" name="procType" value="${searchVO.procType}" /> --%>
<%-- <c:if test="${searchVO.procType eq 'U'}"> --%>
<%-- 	<input type="hidden" name="exId" value="${searchVO.exId}"/> --%>
<%-- </c:if> --%>
	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->

		<div class="ml-auto">
			<c:choose>
				<c:when test="${empty resultData.noticeId}">
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doInsert();">저장</button>
				</c:when>
				<c:otherwise>
					<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doUpdate();">저장</button>
				</c:otherwise>
			</c:choose>
			<button type="button" class="btn_sm btn_secondary btn_modify_auth"  onclick="doDelete();" >삭제</button>
		</div>
		<div class="ml-15">
			<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
		</div>
	</div>


<div class="contents">
	<table class="boardwrite formTable">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col style="width:12%">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">
					<input type="text" id="title" name="title" class="form_text w100p" maxlength="330" value="<c:out value="${resultData.title}"/>">
				</td>
				<th scope="row">구분</th>
				<td>
					<select name="noticeTypeCd" id="noticeTypeCd" class="form_select w100p" >
						<option value="">선택</option>
						<c:forEach items="${codeList}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${resultData.noticeTypeCd eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td colspan="5">
					<textarea id="contents" name="contents" style="width:100%;" rows="25" maxlength="21000" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.contents}" escapeXml="false" /></textarea>
				</td>
			</tr>
			<c:if test="${not empty fileList}">
			<tr>
				<th scope="row">첨부파일 목록</th>
				<td  colspan="5" id="attachFieldList">
					<c:if test="${not empty fileList}">
						<c:forEach var="result" items="${fileList}" varStatus="status">
						<div class="addedFile" <c:if test="${status.first}">style="margin-top: 10px;"</c:if>>
								<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${result.fileId}&fileSeq=${result.fileSeq}" class="filename">
									${result.orgFileNm}
								</a>
								<a href="javascript:void(0);" onclick="deleteExpertFile(this, ${result.fileId}, ${result.fileSeq});">
									<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" class="btn_del"/>
								</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${result.fileId}&fileSeq=${result.fileSeq}', '${result.orgFileNm}', 'membershipboard_${profile}_${result.fileId}_${result.fileSeq}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
						</div>
							<input type="hidden" name="fileSeq"  value="<c:out value='${result.fileSeq}' default='1' />"/>
						</c:forEach>
					</c:if>
				</td>
			</tr>
			</c:if>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="5">
					<div class="mb5px flex">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
								<input type="hidden" name="attachFileSeq" value="1" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<button type="button" onclick="doAddAttachField();" class="btn_tbl_border">추가</button>
					</div>
					<div id="attachFieldEdit"></div>
				</td>
			</tr>
		</tbody>
	</table>

</div>
</form>
<script type="text/javascript">
	var editorObject = [];
	var f;
	var lf;
	
	$(document).ready(function (){
		f = document.writeForm;
		lf = document.listForm;
		
		if($('#procType').val() === "U"){
			setClass($('#temp_sos_type').val());
		}
		
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : editorObject
			, elPlaceHolder : 'contents'
			, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
			, htParam : {
				// 툴바 사용 여부 (true: 사용 / false : 사용하지 않음)
				bUseToolbar : true
				// 입력창 크기 조절바 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseVerticalResizer : true
				// 모드 탭 (Editor | HTML | TEXT) 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseModeChanger : true
			}
		})
	});
	


	function setClass(val){
		var returnList = '';
		var gubunVal = '${resultData.noticeTypeCd}';
		$.ajax({
			type:"post",
			url:"/tradeSOS/com/getTradeSOSNotice.do",
			data:{'sosType':val},
			success:function(data){
				returnList = "<option value=\"\">전체</option>";
				$.each(data.codeList, function(i,item){
					returnList += '<option value="'+ item.codeId+'"'
					if(gubunVal != ''){
						if(item.codeId == gubunVal){
							returnList += 'selected';
						}
					}
					/*if(item.cd_id == searchId){
						returnList += 'selected';
					}*/
					returnList += '>'+ item.codeNm +'</option>';
				});
	
				$('#noticeTypeCd').empty();
				$('#noticeTypeCd').append(returnList);
			},error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	
	//목록
	function goList() {
		lf.action = '<c:url value="/tradeSOS/notice/noticeList.do" />';
		lf.target = '_self';
		lf.submit();
	}

	//validation
	function isValid() {
		if (isStringEmpty(f.title.value)) {
			alert('제목을 입력해 주세요.');
			f.title.focus();
			
			return false;
		}
		
		editorObject.getById['contents'].exec('UPDATE_CONTENTS_FIELD', []);
		
		if (isStringEmpty(document.writeForm.contents.value)) {
			alert('내용을 입력해 주세요.');
			document.writeForm.contents.focus();
			
			return false;
		}

		if (isStringEmpty(document.writeForm.noticeTypeCd.value)) {
			alert('구분을 선택해 주세요.');
			document.writeForm.noticeTypeCd.focus();

			return false;
		}
		
		return true;
	}	
	
	//추가
	function doInsert() {
		if (isValid() == false) return;							//validation 통과 못한 경우 끝
		
		if (confirm('저장 하시겠습니까?') == false) return;	//등록 alert 거절한 경우 끝
		if (isStringEmpty($('input[name=attachFile]').val())) {			//첨부파일
                	$('input[name=attachFile]').prop('disabled', true);
        }
				
		doSave();												//저장
	}
	
	//수정
	function doUpdate() {
		if (isValid() == false) return;							//validation 통과 못한 경우 끝
		
		if (confirm('수정 하시겠습니까?') == false) return;	//수정 alert 거절한 경우 끝
		if (isStringEmpty($('input[name=attachFile]').val())) {			//첨부파일
                	$('input[name=attachFile]').prop('disabled', true);
        }
				
		doSave();												//저장				
	}

	//삭제
	function doDelete() {
		if (confirm('삭제 하시겠습니까?') == false) return;	//수정 alert 거절한 경우 끝
		global.ajaxSubmit($('#writeForm'), {
			type: 'POST'
			, url: '<c:url value="/tradeSOS/notice/removeTradeSOSNotice.do" />'
			, enctype: 'multipart/form-data'
			, dataType: 'json'
			, async: false
			, spinner: true
			, success: function (data) {
				if( data.code == 'Fail' ) {
					return false;
				} else {
					goList();
				}
			}
		});
	}
	
	//저장 ajax
	function doSave() {	

		global.ajaxSubmit($('#writeForm'), {
			type: 'POST'
			, url: '<c:url value="/tradeSOS/notice/saveNotice.do" />'
			, enctype: 'multipart/form-data'
			, dataType: 'json'
			, async: false
			, spinner: true
			, success: function (data) {
				if( data.code == 'Fail' ) {
					alert(data.msg);
					return false;
				} else {
					goList();
				}
			}
		});
	}
	
// 	//태그제거
// 	function deletetag(input, allow) {
// 		var regExp;
// 		if (allow.length != 0)
// 			regExp = "<\\/?(?!(" + allow.join('|') + "))\\b[^>]*>";
// 		else
// 			regExp = "<\/?[^>]*>";
// 		return input.replace(new RegExp(regExp, "gi"), "");
// 	}
	
	//파일 다운로드
	function doDownloadFile(fileSeq) {
		document.writeForm.action = '<c:url value="/common/fileDownload.do" />';
		document.writeForm.fileSeq.value = fileSeq;
		document.writeForm.target = '_self';
		document.writeForm.submit();
	}

	function deleteExpertFile(obj, fileId, fileSeq) {
		if (confirm('선택한 파일을 삭제하겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/exp/deleteExpertFile.do" />'
				, data : {
					fileId : fileId
					, fileSeq : fileSeq
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					var clickedRow = $(obj).closest('.addedFile');
					clickedRow.remove();
				}
			});
		}
	}

	// 첨부파일 필드 추가
	function doAddAttachField() {
		var attachCnt = 0;
		$('input[name="attachFileSeq"]').each(function(){
			attachCnt = $(this).val();
		});

		var attachFileSeq = parseInt(attachCnt) + 1;

		var html = '';
		html += '<div id="field' + attachFileSeq + '" class="mb5px flex mt-5">';
		html += '	<div class="form_file">';
		html += '		<p class="file_name">첨부파일을 선택하세요</p>';
		html += '		<label class="file_btn">';
		html += '			<input type="file" name="attachFile' +attachFileSeq + '" class="txt" title="첨부파일" />';
		html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
		html += '			<span class="btn_tbl">찾아보기</span>';
		html += '		</label>';
		html += '	</div>';
		html += '	<button type="button" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
	}
</script>







