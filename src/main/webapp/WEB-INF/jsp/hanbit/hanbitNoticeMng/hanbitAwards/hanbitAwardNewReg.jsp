<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>


<form id="searchForm" name="searchForm" method="post" ></form>

<form id="frm" name="frm" method="post" enctype="multipart/form-data">
	<div class="cont_block">
	<input type="hidden" id="repFileName" name="repFileName" value=""/>
	<input type="hidden" id="noticeId" name="noticeId" value=""/>
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">제목</th>
					<td colspan="5">
						<input type="text" id="noticeTitle" name="noticeTitle" value="<c:out value="${resultList.templateTitle}" escapeXml="false" />" class="form_text w100p" />
					</td>
				</tr>

				<tr>
					<th scope="row">작성일</th>
					<td id="regDate">
					</td>
					<th scope="row">작성자</th>
					<td>
						<c:out value="${regName}"/>
					</td>
					<th scope="row">조회수</th>
					<td>
						0
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">내용</h3>
		</div>
		<textarea id="noticeContent" name="noticeContent" rows="3" style="width:100%;"></textarea>
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
						<div id="div1">
							<div class="form_file">
								<input type="hidden" name="fileSeq" value="1"/>
								<button type="button" id="repBtn1" name="repBtn" style="margin-right: 5px;" class="btn_sm btn_secondary" onclick="choiceRep(1);">대표</button>
								<p id="fileNm1" class="file_name">첨부파일을 선택하세요</p>
								<label class="file_btn">
									<input type="file" id="fileIdx1" name="photoFile" title="파일첨부" accept="image/*"/>
									<span class="btn_tbl">찾아보기</span>
								</label>
								<button type="button" name="delBtn" onclick="cancelFile(1);">
									<a class="btn_del"><img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" /></a>
								</button>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
<script type="text/javascript">

	var oEditors = [];
	var photoCnt = 1;

	$(document).ready(function(){

		var nowTiem = global.formatToday('yyyy-MM-dd');

		$('#regDate').text(nowTiem);

		setEditor();
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

		var fileNm = $('#fileNm'+num).text();	// 대표사진 파일명
		$('#repFileName').val(fileNm);

		// 버튼 색 컨트롤
		$('button[name=repBtn]').removeClass();
		$('button[name=repBtn]').attr('class', 'btn_sm btn_secondary');

		$('#repBtn'+num).removeClass();
		$('#repBtn'+num).attr('class', 'btn_sm btn_primary');

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

		if($('#repFileName').val() == '' && chk) {
			alert('대표사진을 선택하세요.');
			return false;
		}

		return chk;
	}

	function doSave(){	// 저장

		var sHTML = oEditors.getById['noticeContent'].getIR();
		$('#noticeContent').val(sHTML);

		if(!isValid()) {
			return;
		}

		if(!confirm('저장 하시겠습니까?')) {
			return;
		}

		$('#loading_image').show(); // 로딩이미지 시작

		global.ajaxSubmit($('#frm'), {
			type : 'POST'
			, url : '/hanbit/hanbitNoticeMng/saveHanbitNoticeInfo.do'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){

				$('#loading_image').hide();	// 로딩이미지 종료

				if(data.result == 'false') {
					alert(data.message);
					$('button[name=repBtn]').removeClass();
					$('button[name=repBtn]').attr('class', 'btn_sm btn_secondary');
					$('#repFileName').val('');
					return;
				} else {
					goList();
				}
	        }
		});
	}

	function goList() {
		$('#searchForm').attr('action', '/hanbit/hanbitNoticeMng/hanbitAwardList.do');
		$('#searchForm').submit();
	}

</script>
