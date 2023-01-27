<%
 /**
  * @Class Name : NoticeCnRegist.jsp
  * @Description : NoticeCnRegist 화면
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2016.09.06   이인오              최초 생성
  *
  *  @author 이인오
  *  @since 2016.09.06
  *  @version 1.0
  *  @see
  *
  */
%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date"  %>
<%@ page import="egovframework.common.Constants" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="double-submit" uri="http://www.egovframe.go.kr/tags/double-submit/jsp" %>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>

<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${noticeManageVO.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${noticeManageVO.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>

<form id="sampleForm" name="sampleForm" method="post" enctype="multipart/form-data" onsubmit="return false;">

<%--<input type="hidden" id="attachSeq" name="attachSeq" value="${attachList.attachSeq}" />
<input type="hidden" name="fileSeq" value="1" />--%>
<!-- 첨부파일을 위한 Hidden -->
<input type="hidden" name="posblAtchFileNumber" id="posblAtchFileNumber" value="5">
<input type="hidden" name="cont" id="cont" value=""/>


<input id="noticeId" name="noticeId" type="hidden" value="<c:out value="${result.noticeId}"/>"/>
<input id="atchFileId" name="atchFileId" type="hidden" value="${result.atchFileId}"/>
<input id="fileSn" name="fileSn" type="hidden" value=""/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="contents">
	<table class="formTable">
		<caption>공지사항 수정</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>
					<input type="text" name="title" maxlength="85" value="<c:out value="${result.title}" escapeXml="false" />" class="textType form_text w100p" />
				</td>
			</tr>
			<tr>
				<th scope="row">공개여부</th>
				<td>
					<select name="viewYn" class="form_select">
						<option value="Y" <c:if test="${ result.viewYn == 'Y' }">selected</c:if>>공개</option>
						<option value="N" <c:if test="${ result.viewYn != 'Y' }">selected</c:if>>비공개</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td>
					<textarea id="contEditor" name="contEditor" rows="20" style="width:100%;"><c:out value="${result.cont}" escapeXml="false" /></textarea>
				</td>
			</tr>
			<c:if test="${result.atchFileId != ''}">
			<tr>
				<th>첨부파일 목록</th>
				<td>
					<c:if test="${not empty attachList}">
						<div id="attachFieldList">
						<c:forEach var="fileResult" items="${attachList}" varStatus="status">
							<div class="addedFile">
								<a href="javascript:doDownloadFile('${fileResult.attachSeq}', '${fileResult.fileSeq}');" class="filename">
									${fileResult.fileNm}
								</a>
								<a href="javascript:void(0);" onclick="doDeleteFile(this, '${fileResult.attachSeq}', '${fileResult.fileSeq}');" class="btn_del">
									<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
								</a>
								<button type="button" onclick="viewer.showFileContents('${serverName}/common/util/noticeFileDownload.do?atchFileId=${fileResult.attachSeq}&fileSn=${fileResult.fileSeq}', '${fileResult.fileNm}', 'membershipexpert_${profile}_${fileResult.attachSeq}_${fileResult.fileSeq}');" class="file_preview btn_tbl_border">
									<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
								</button>
							</div>
						</c:forEach>
						</div>
					</c:if>
				</td>
			</tr>
			</c:if>
			<c:if test="${result.atchFileId == null}">
				<input type="hidden" name="fileListCnt" id="fileListCnt" value="0" >
				<input name="atchFileAt" id="atchFileAt" type="hidden" value="N">
			</c:if>
			<c:if test="${result.atchFileId != null}">
				<input name="atchFileAt" id="atchFileAt" type="hidden" value="Y">
			</c:if>
			<tr>
				<th scope="row">첨부파일</th>
				<td>
					<div class="form_file">
						<p class="file_name">첨부파일을 선택하세요</p>
						<label class="file_btn">
							<input type="file" id="attachFile" name="attachFile" />
							<span class="btn_tbl">찾아보기</span>
						</label>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="btn_group mt-20 _center">
		<button type="button" class="btn btn_primary" onclick="doUpdate();">수정</button>
		<button type="button" class="btn btn_secondary" onclick="goList();">목록</button>
	</div>
</div>
</form>
</form>

<script type="text/javascript">
	var f;
	var lf;
	f = document.sampleForm;
	lf = document.listForm;
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "contEditor",
		sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />',
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			fOnBeforeUnload : function(){
				//alert("완료!");
			}
		}, //boolean
		fOnAppLoad : function(){
			//예제 코드
			//oEditors.getById["contEditor"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		},
		fCreator: "createSEditor2"
	});

	function pasteHTML() {
		var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>";
		oEditors.getById["contEditor"].exec("PASTE_HTML", [sHTML]);
	}

	function showHTML() {
		var sHTML = oEditors.getById["contEditor"].getIR();
	}

	function submitContents(elClickedObj) {
		oEditors.getById["contEditor"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.

		// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("contEditor").value를 이용해서 처리하면 됩니다.

		try {
			elClickedObj.form.submit();
		} catch(e) {}
	}

	function setDefaultFont() {
		var sDefaultFont = '궁서';
		var nFontSize = 24;
		oEditors.getById["contEditor"].setDefaultFont(sDefaultFont, nFontSize);
	}


	// 초기화
	function fn_egov_initl_noticecn(){

		// 첫 입력란에 포커스..
		//noticeManageVO.qestnSj.focus();

	}

    // 수정처리 화면
	function doUpdate(){

		if (isValid()) {
			if (confirm('해당 게시물을 수정하시겠습니까?')) {
				var sHTML = oEditors.getById["contEditor"].getIR();
				jQuery('#cont').val(sHTML);

				if (isStringEmpty($('#attachFile').val())) {
					$('#attachFile').prop('disabled', true);
				}

				global.ajaxSubmit($('#sampleForm'), {
					type : 'POST'
					, url : '<c:url value="/uss/olh/notice/noticeCnUpdt.do" />'
					, enctype : 'multipart/form-data'
					, dataType : 'json'
					, async : false
					, spinner : true
					, success : function(data){
						if( data.SUCCESS) {
							goList();
						} else {
							alert(data.MESSAGE);
						}
					}
				});
			}
		}


	}

	// 벨리데이션 체크
	function isValid() {
		if (isStringEmpty(f.title.value)) {
			alert('제목을 입력해 주세요.');
			f.title.focus();

			return false;
		}

		oEditors.getById['contEditor'].exec('UPDATE_CONTENTS_FIELD', []);
		if (isStringEmpty(f.contEditor.value)) {
			alert('내용을 입력해 주세요.');
			f.contEditor.focus();

			return false;
		}

		return true;
	}

    //목록으로 가기
	function goList() {
		lf.action = '<c:url value="/uss/olh/notice/list.do" />';
		lf.target = '_self';
		lf.submit();
	}

	//첨부파일 다운로드
	function doDownloadFile(fileSeq, fileSn) {
		f.action = '<c:url value="/common/util/noticeFileDownload.do" />';
		f.atchFileId.value = fileSeq;
		f.fileSn.value = fileSn;
		f.target = '_self';
		f.submit();
	}

	// 첨부파일 삭제
	function doDeleteFile(obj, fileSeq, fileSn) {
		if (confirm('삭제 하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/noticeFileDelete.do" />'
				, data : {
					  atchFileId :fileSeq
					, fileSn : fileSn
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
</script>

<script type="text/javaScript">
	document.onload=fn_egov_initl_noticecn();
</script>