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

<%--<script type="text/javascript" src="/js/egovframework/com/cmm/fms/EgovMultiFile.js" ></script>--%>
<%--<script type="text/javascript" src="/validator.do"></script>--%>
<%--<<validator:javascript formName="noticeManageVO" staticJavascript="false" xhtml="true" cdata="false"/>--%>

<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchCondition" value="${searchVO.searchCondition}" />
<input type="hidden" name="searchKeyword" value="${searchVO.searchKeyword}" />
<input type="hidden" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1'/>" />
</form>

<form id="sampleForm" name="sampleForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<double-submit:preventer/>
<input type="hidden" name="fileSeq" value="1" />

<!-- 첨부파일을 위한 Hidden -->
<input type="hidden" name="posblAtchFileNumber" id="posblAtchFileNumber" value="5">
<input type="hidden" name="cont" id="cont" value=""/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="contents">
	<table class="formTable">
		<caption>공지사항 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">제목</th>
				<td>
					<input type="text" name="title" value="<c:out value="${resultView.title}" escapeXml="false" />" maxlength="85" class="textType form_text w100p" />
				</td>
			</tr>
			<tr>
				<th scope="row">공개여부</th>
				<td>
					<select name="viewYn" class="form_select">
						<option value="Y">공개</option>
						<option value="N">비공개</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">내용</th>
				<td style="padding-left: 31px;">
					<textarea id="contEditor" name="contEditor" rows="20" style="width:100%;"></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">첨부파일 목록</th>
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
		<button type="button" class="btn btn_primary" onclick="fn_egov_regist_noticecn();">저장</button>
		<button type="button" class="btn btn_secondary" onclick="goList();">목록</button>
	</div>
</div>
</form>
</form>
<!--첨부파일 업로드 가능화일 설정 Start..-->
<script type="text/javascript">
/*var maxFileNum = document.getElementById('posblAtchFileNumber').value;

   if(maxFileNum==null || maxFileNum==""){

     maxFileNum = 3;

    }

   var multi_selector = new MultiSelector( document.getElementById( 'egovComFileList' ), maxFileNum );

   multi_selector.addElement( document.getElementById( 'egovComFileUploader' ) );*/

</script>
<!-- 첨부파일 업로드 가능화일 설정 End.-->

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

    // 저장처리 화면
	function fn_egov_regist_noticecn(){

		if (isValid()) {
			if (confirm('해당 게시물을 등록하시겠습니까?')) {
				var sHTML = oEditors.getById["contEditor"].getIR();
				jQuery('#cont').val(sHTML);

				console.log( $('#cont').val());
				if (isStringEmpty($('#attachFile').val())) {
					$('#attachFile').prop('disabled', true);
				}

				global.ajaxSubmit($('#sampleForm'), {
					type : 'POST'
					, url : '<c:url value="/uss/olh/notice/noticeCnRegist.do" />'
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
</script>
