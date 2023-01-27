<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
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
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>구분</th>
					<td>
						<select name="noticeGubun" id="noticeGubun" class="form_select">
							<c:forEach items="${gubunList}" var="gubunList" varStatus="status">
								<option value="<c:out value="${ gubunList.code}" />" label="<c:out value="${ gubunList.codeNm}" />" <c:out value="${ resultInfo.noticeGubun eq gubunList.code ? 'selected' : '' }" /> />
							</c:forEach>
						</select>
					</td>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" id="noticeTitle" name="noticeTitle" value="<c:out value="${resultInfo.noticeTitle}" escapeXml="false" />" class="form_text w100p" />
					</td>
				</tr>

				<tr>
					<th scope="row">작성일</th>
					<td>
						<c:out value="${resultInfo.regDate}"/>
					</td>
					<th scope="row">작성자</th>
					<td>
						<c:out value="${resultInfo.regName}"/>
					</td>
					<th scope="row">조회수</th>
					<td>
						<c:out value="${resultInfo.views}"/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">내용</h3>
		</div>
		<textarea id="noticeContent" name="noticeContent" rows="3" style="width:100%;"><c:out value="${resultInfo.noticeContent}"></c:out></textarea>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">사진첨부</h3>
			<div class="btnGroup ml-auto">
				<button type="button" class="btn_sm btn_primary" onclick="addPhoto();">추가</button>
			</div>
		</div>

		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">사진</th>
					<td id="photoList">
						<div id="attachFieldList">
							<c:forEach var="fileVO" items="${fileList}" varStatus="status">
							<c:if test="${status.last}">
								<c:set var="fileLastSeq" value="${fileVO.fileSeq}"/>
							</c:if>
								<div id="fileList_<c:out value="${fileVO.fileSeq}" />" class="addedFile">
									<input type="hidden" id="fileIdx<c:out value="${fileVO.fileSeq}"/>" value="<c:out value="${fileVO.fileSeq}"/>"/>
									<button type="button" id="repBtn<c:out value="${fileVO.fileSeq}"/>" name="repBtn" style="margin-right: 5px;" class="btn_sm btn_secondary" onclick="choiceRep(<c:out value="${fileVO.fileSeq}"/>);">대표</button>
									<a class="filename" id="fileNm<c:out value="${fileVO.fileSeq}"/>" href="javascript:doHanbitFileDown('<c:out value="${fileVO.attachSeq}"/>','<c:out value="${fileVO.fileSeq}"/>')">
										<c:out value="${fileVO.fileNm}"/> (<c:out value="${fileVO.fileSize}"/>byte)
									</a>
									<button type="button" onclick="deleteAttchFile('<c:out value="${fileVO.attachSeq}"/>','<c:out value="${fileVO.fileSeq}"/>','bankbookControl');">
										<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
									</button>
								</div>
							</c:forEach>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
<script type="text/javascript">

	var oEditors = [];
	var photoCnt = 0;

	$(document).ready(function(){

		setEditor();
		setRepFile();
	});

	function setEditor() {		// 에디터 생성

		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: 'noticeContent',
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
	}

	function setRepFile() {

		photoCnt = '${fileLastSeq}';

		var mainSeq = $('#mainFileSeq').val();
		$('#repBtn'+mainSeq).removeClass();
		$('#repBtn'+mainSeq).attr('class', 'btn_sm btn_primary');

	}

	function addPhoto() {

		var tag = '';

		photoCnt++;

		tag += '<div id="div'+photoCnt+'" style="margin-top: 5px;">';
		tag += '	<div class="form_file">';
		tag += '	<input type="hidden" name="fileSeq" value='+photoCnt+'>';
		tag += '	<button type="button" id="repBtn'+photoCnt+'" name="repBtn" style="margin-right: 5px;" class="btn_sm btn_secondary" onclick="choiceRep('+photoCnt+');">대표</button>';
		tag += '		<p id="fileNm'+photoCnt+'" class="file_name">첨부파일을 선택하세요</p>';
		tag += '		<label class="file_btn">';
		tag += '			<input type="file" id="fileIdx'+photoCnt+'" name="photoFile" title="파일첨부" accept="image/*"/>';
		tag += '			<span class="btn_tbl">찾아보기</span>';
		tag += '		</label>';
		tag += '		<button type="button" name="delBtn" onclick="cancelFile('+photoCnt+');">';
		tag += '			<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>';
		tag += '		</button>';
		tag += '	</div>';
		tag += '</div>';

		$('#photoList').append(tag);
	}

	function choiceRep(num) {

		var fileChk = $('#fileIdx'+num).val();

		if(!fileChk) {	// 파일이 없는 항목은 선택불가
			alert('파일이 존재하지 않습니다.');
			return;
		}

		if(!confirm('대표사진을 변경 하시겠습니까?')) {
			return;
		}

		$('#mainFileSeq').val(num);
		var noticeId = $('#noticeId').val();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitNoticeMng/updateMainPhotoSeq.do"
			, data : {'noticeId' : noticeId,
					  'mainFileSeq' : num
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				// 버튼 색 컨트롤
				$('button[name=repBtn]').removeClass();
				$('button[name=repBtn]').attr('class', 'btn_sm btn_secondary');

				$('#repBtn'+num).removeClass();
				$('#repBtn'+num).attr('class', 'btn_sm btn_primary');
			}
		});
	}

	function cancelFile(num) {
		var cnt = $('.btn_del').length;

		if(cnt <= 1) {
			alert('사진을 1장이상 등록하세요.');
			return;
		}

		$('#div'+ num).remove();
	}

	function isValid() {

		var chk = true;

		if($('#noticeTitle').val() == '') {
			alert('제목을 입력하세요.');
			$('#noticeTitle').focus();
			return false;
		}

		$('input[name=photoFile]').each(function(i) {
			if(!$(this).val()) {
				chk = false
				alert(i+1+'번째 파일을 첨부하세요.');
				return false;
			}
		})

		if($('#mainFileSeq').val() == '' && chk) {
			alert('대표사진을 선택하세요.');
			return false;
		}

		return chk;
	}

	function doSave(){	// 저장
		var fileChk = $('input[type=file]').length;

		var sHTML = oEditors.getById['noticeContent'].getIR();
		$('#noticeContent').val(sHTML);

		if(!isValid()) {
			return;
		}

		if(!confirm('저장 하시겠습니까?')) {
			return;
		}


		global.ajaxSubmit($('#frm'), {
			type : 'POST'
			, url : '/hanbit/hanbitNoticeMng/saveHanbitNoticeInfo.do'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if(data.result == 'false') {
					alert(data.message);
					$('button[name=repBtn]').removeClass();
					$('button[name=repBtn]').attr('class', 'btn_sm btn_secondary');
					return;
				} else {
					goList();
				}
	        }
		});
	}

	function goList() {
		$('#searchForm').attr('action', '/hanbit/hanbitNoticeMng/hanbitEventList.do');
		$('#searchForm').submit();
	}

	function deleteAttchFile(atchFileId, fileSeq) {

		var chkMainFileSeq = $('#mainFileSeq').val();

		if(fileSeq == chkMainFileSeq) {
			alert('대표사진은 삭제할 수 없습니다. \n대표사진 변경 후 삭제하세요.');
			return;
		}

		if(!confirm('파일을 삭제 하시겠습니까?')) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitNoticeMng/deleteHanbitPhoto.do"
			, data : {'attachSeq' : atchFileId,
					  'fileSeq' : fileSeq
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#fileList_' + fileSeq).remove();

				var cnt = $('.btn_del').length;
				if(cnt <= 0) {
					addPhoto();
					$('#mainFileSeq').val('');
				}
			}
		});
	}

	function doHanbitFileDown(attachSeq, fileSeq) {
		window.open("/hanbit/hanbitNoticeMng/HanbitNoticePhotoFileDownload.do?attachSeq="+attachSeq+"&fileSeq="+fileSeq+"");
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
