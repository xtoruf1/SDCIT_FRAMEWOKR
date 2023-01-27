<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${param.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>
<form id="writeForm" name="writeForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="articleSeq" name="articleSeq" value="<c:out value='${resultView.articleSeq}' default='0' />" />
<input type="hidden" id="groupId" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" id="attachSeq" name="attachSeq" value="${resultView.attachSeq}" />
<input type="hidden" name="fileSeq" value="1" />
<input type="hidden" name="topMenuId" value="" />
<input type="hidden" name="procType" value="${searchVO.procType}" />
<c:if test="${searchVO.procType eq 'U'}">
	<input type="hidden" name="exId" value="${searchVO.exId}"/>
</c:if>
<div class="contents">
		<%-- 첨부파일 --%>
		<input type="hidden" name="attachDocumId" value="<c:out value='${resultData.attachDocumId}' default='0' />"/>
<%--		<input type="hidden" name="attachSeqNo" value="<c:out value='${resultData.attachSeqNo}' default='0' />"/>--%>

		<div class="location">
			<!-- 네비게이션 -->
			<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
			<!-- 네비게이션 -->
		<div class="ml-auto">
		<c:choose>
			<c:when test="${searchVO.procType eq 'I'}">
				<a href="javascript:doInsert();" class="btn_sm btn_primary btn_modify_auth">등록</a>
			</c:when>
			<c:otherwise>
				<a href="javascript:doUpdate();" class="btn_sm btn_primary btn_modify_auth">수정</a>
			</c:otherwise>
		</c:choose>
 			<button type="button" class="btn_sm btn_secondary btn_modify_auth" onclick="doDelete();">삭제</button>
		</div>
		<div class="ml-15">
			<a href="javascript:goList();" class="btn_sm btn_secondary">목록</a>
		</div>
	</div>
	<div class="tit_bar">
		<h3 class="tit_block">상담 우수사례 등록</h3>
	</div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formTable">
		<caption>등록/수정화면</caption>
		<colgroup>
				<col style="width:15%">
				<col>
				<col style="width:15%">
				<col>
			</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">
					<input type="text" id="title" name="title" class="form_text w100p" value="<c:out value="${resultData.title}"/>" maxlength="65">
				</td>
			</tr>
			<tr>
				<th scope="row">구분</th>
				<td>
					<input type="hidden" id="temp_sos_type" value="${resultData.sosType}"/>
					<select name="sosType" id="sosType" class="form_select w100p" onchange="setClass(this.value);">
						<option value="">전체</option>
						<c:forEach items="${code56}" var="item" varStatus="status">
							<option value="${item.cdId}" <c:if test="${resultData.sosType eq item.cdId}">selected</c:if>><c:out value="${item.cdNm}"/></option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">분야</th>
				<td>
					<select name="gubun" id="gubun" class="form_select w100p" value="${resultData.gubun}">
						<option value="">전체</option>
						<c:if test="${not empty resultData.gubun}">
							<option value="${resultData.gubun}" selected><c:out value="${resultData.gubunNm}"/></option>
						</c:if>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td colspan="3" >
					<textarea id="result" name="result" rows="35" style="width: 100%" maxlength="130000" onkeyup="return textareaMaxLength(this);"><c:out value="${resultData.result}" escapeXml="false" /></textarea>
<%--					<textarea id="contents" name="contents" rows="35" style="width: 100%"><c:out value="${resultData.contents}" escapeXml="false" /></textarea>--%>
				</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3" >
					<c:choose>
						<c:when test="${fn:length(resultData.file) > 0}">
							<c:forEach items="${fileList}" var="itemFile" varStatus="status">
								<div class="form_file">
									<p class="file_name"><c:out value="${itemFile.attachDocumNm}" /></p>
									<label class="file_btn">
										<input type="file" id="attachFile" name="attachFile" class="txt attachment"/>
										<span class="btn_tbl">찾아보기</span>
									</label>
								</div>
								<input type="hidden" name="attachSeqNo" value="<c:out value='${itemFile.attachSeqNo}' default='0' />"/>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="form_file">
								<p class="file_name">첨부파일을 선택하세요</p>
								<label class="file_btn">
									<input type="file" id="attachFile" name="attachFile" class="txt attachment"/>
									<span class="btn_tbl">찾아보기</span>
								</label>
							</div>
							<input type="hidden" name="attachSeqNo" value="<c:out value='${itemFile.attachSeqNo}' default='0' />"/>
						</c:otherwise>
					</c:choose>
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
		var changeIdNum = Number($('input[name="attachDocumId"]').val());
		$('input[name="attachDocumId"]').val(changeIdNum);

		// var changeSeqNum = Number($('input[name="attachSeqNo"]').val());
		// $('input[name="attachSeqNo"]').val(changeSeqNum);

		f = document.writeForm;
		lf = document.listForm;
		
		if($('#procType').val() === "U"){
			setClass($('#temp_sos_type').val());
		}
		
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : editorObject
			, elPlaceHolder : 'result'
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
	
	
	//목록
	function goList() {
		lf.action = '<c:url value="/tradeSOS/com/excellentCase.do" />';
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
		
		editorObject.getById['result'].exec('UPDATE_CONTENTS_FIELD', []);
		
		if (isStringEmpty(document.writeForm.result.value)) {
			alert('내용을 입력해 주세요.');
			document.writeForm.result.focus();
			
			return false;
		}

		if(isStringEmpty(document.writeForm.sosType.value)){
			alert('구분을 선택해 주세요.');
			document.writeForm.sosType.focus();

			return false;
		}
		
		return true;
	}	
	
	//추가
	function doInsert() {
		if (isValid() == false) return;							//validation 통과 못한 경우 끝
		
		if (confirm('등록 하시겠습니까?') == false) return;		//등록 alert 거절한 경우 끝
		if (isStringEmpty($('#attachFile').val())) {			//첨부파일
                	$('#attachFile').prop('disabled', true);
        }
				
		doSave();												//저장
	}
	
	//수정
	function doUpdate() {
		if (isValid() == false) return;							//validation 통과 못한 경우 끝
		
		if (confirm('수정 하시겠습니까?') == false) return;		//수정 alert 거절한 경우 끝
		if (isStringEmpty($('#attachFile').val())) {			//첨부파일
                	$('#attachFile').prop('disabled', true);
        }
				
		doSave();												//저장				
	}

	//삭제
	function doDelete() {
		if(confirm('삭제 하시겠습니까?') == false) return;
		$('input[name="procType"]').val("D");
		global.ajaxSubmit($('#writeForm'), {
			type : 'POST'
			, url : '<c:url value="/tradeSOS/com/excellentCaseProc.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.FLAG){
					goList();
				}else{
					alert(data.msg);
					return false;
				}
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	//저장 ajax
	function doSave() {
		global.ajaxSubmit($('#writeForm'), {
			type : 'POST'
			, url : '<c:url value="/tradeSOS/com/excellentCaseProc.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.FLAG){
					goList();
				}else{
					alert(data.msg);
					return false;
				}
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	//분야 조회
	function setClass(val){
		var returnList = '';
		var gubunVal = '${resultData.gubun}';
		global.ajax({
			type:"post",
			url:"/tradeSOS/com/excellentSearchClassAjax.do",
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

				$('#gubun').empty();
				$('#gubun').append(returnList);
			},error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
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



	//첨부파일 다운로드
	function doDownloadFile(fileSeq, fileSn) {
		f.action = '<c:url value="/tradeSOS/scene/tradeSOSFileDownload.do" />';
		f.attachDocumId.value = fileSeq;
		f.attachSeqNo.value = fileSn;
		// f.attachDocumFg.value = '014';
		f.target = '_self';
		f.submit();
	}

	$(document).ready(function() {
		$("input:file[name^='param_file']").change(function(){
			$(this).parents('div.inputFile').find("input:text[name^='fileName']").val($(this).val().substring($(this).val().lastIndexOf("\\")+1));
		});
	});

	//파일 삭제
	<%--function doDeleteFile(fileSeq, fileSn) {--%>
	<%--	if (confirm('해당 파일을 삭제하시겠습니까?')) {--%>
	<%--		global.ajax({--%>
	<%--			type : 'POST'--%>
	<%--			, url : '<c:url value="/tradeSOS/com/tradeSosDeleteFile.do" />'--%>
	<%--			, data : {--%>
	<%--				attachDocumId :fileSeq--%>
	<%--				, attachSeqNo : fileSn--%>
	<%--				// , attachDocumFg : fileFg--%>
	<%--			}--%>
	<%--			, dataType : 'json'--%>
	<%--			, async : true--%>
	<%--			, spinner : true--%>
	<%--			, success : function(data){--%>
	<%--				alert('해당 파일을 삭제하였습니다.');--%>
	<%--				$('#' + fileSn).hide();--%>
	<%--			}--%>
	<%--		});--%>
	<%--	}--%>
	<%--}--%>
</script>







