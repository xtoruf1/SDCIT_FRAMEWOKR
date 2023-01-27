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

<form id="faqForm" name="faqForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<double-submit:preventer/>
<input type="hidden" id="articleSeq" name="articleSeq" value="<c:out value='${resultView.articleSeq}' default='0' />" />
<input type="hidden" id="groupId" name="groupId" value="<%=Constants.GROUP_ID_MEMBERSHIP%>" />
<input type="hidden" id="attachSeq" name="attachSeq" value="${resultView.attachSeq}" />
<input type="hidden" name="fileSeq" value="1" />

<!-- 첨부파일을 위한 Hidden -->
<input type="hidden" name="posblAtchFileNumber" id="posblAtchFileNumber" value="5">
<input type="hidden" name="answerCn" id="answerCn" value=""/>

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
</div>

<div class="contents">
	<div class="tbl_opt">
		<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
	</div>
	<table class="boardwrite formTable">
		<caption>FAQ 내용 등록</caption>
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th>분류 <strong class="point">*</strong></th>
				<td>
					<select name="qestnCd" id="qestnCd" onchange="qestnSelectBox();" class="form_select">
						<c:forEach items="${faqCdList}" var="code">
							<option value="<c:out value="${code.code }"/>"  <c:if test="${searchVO.searchCondition eq code.code}">selected="selected"</c:if> ><c:out value="${code.codeNm }"/></option>
						</c:forEach>
					</select>
					<select name="qestnSubCd" id="qestnSubCd" class="form_select">
						<option value="">세부분류</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">질문 제목</th>
				<td>
					<input type="text" name="qestnSj" maxlength="85" class="textType form_text w100p" />
				</td>
			</tr>
			<tr>
				<th class="dTitle">답변 내용 <strong class="point">*</strong></th>
				<td>
					<textarea id="contEditor" name="contEditor" rows="20" style="width:100%;"></textarea>
				</td>
			</tr>
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
		<button type="button" class="btn btn_primary" onclick="doInsert();">저장</button>
		<button type="button" class="btn btn_secondary" onclick="goList();">목록</button>
	</div>
</div>
</form>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		//질문제목 포커스
		f.qestnSj.focus();

		//세부분류 선택
		qestnSelectBox();
	});

	var f;
	var lf;
	f = document.faqForm;
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
	function doInsert(){
		if (isValid()) {
			if (confirm('해당 게시물을 등록하시겠습니까?')) {
				var sHTML = oEditors.getById["contEditor"].getIR();
				jQuery('#answerCn').val(sHTML);

				if (isStringEmpty($('#attachFile').val())) {
					$('#attachFile').prop('disabled', true);
				}

				global.ajaxSubmit($('#faqForm'), {
					type : 'POST'
					, url : '<c:url value="/uss/olh/faq/faqCnRegist.do" />'
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
		if (isStringEmpty(f.qestnSj.value)) {
			alert('질문제목은(는) 필수 입력값입니다.');
			f.title.focus();

			return false;
		}

		oEditors.getById['contEditor'].exec('UPDATE_CONTENTS_FIELD', []);
		if (isStringEmpty(f.contEditor.value)) {
			alert('답변내용은(는) 필수 입력값입니다.');
			f.contEditor.focus();

			return false;
		}

		return true;
	}

    //목록으로 가기
	function goList() {
		lf.action = '<c:url value="/uss/olh/faq/list.do" />';
		lf.target = '_self';
		lf.submit();
	}

	// 분류 선택
	function qestnSelectBox() {
		var pQestnCd= $('#qestnCd option:selected').val();
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/uss/olh/faq/faqSubCode.do" />'
			, data : { qestnCd : pQestnCd}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success:function( data){
				$("select[name=qestnSubCd]").empty();
				$("select[name=qestnSubCd]").append($("<option value=''>세부분류</option>"));
				var optionList = data.resultCodeList;
				for (let i = 0 ; i < optionList.length ; i++){
					var option = $("<option value='"+optionList[i].code+"'>"+optionList[i].codeNm+"</option>");
					$("select[name=qestnSubCd]").append(option);
				}
			}
		});
	}

</script>
