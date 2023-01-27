<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="addTemplate();">추가</button>
		<button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="doSave();">저장</button>
	</div>
</div>


<form id="frm" name="frm" method="post">
	<input type="hidden" id="listCnt" value='<c:out value="${resultCnt}"></c:out>'>
	<c:forEach items="${resultList}" var="resultList" varStatus="status">
		<div class="cont_block" id="tempDiv_<c:out value="${resultList.templateId}" />">
			<input type="hidden" name="templateId" value='<c:out value="${resultList.templateId}"></c:out>'>
			<input type="hidden" name="sortNo" value='<c:out value="${resultList.sortNo}"></c:out>'>
			<table class="formTable">
				<colgroup>
					<col style="width:15%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">순번</th>
						<td>
							<p class="sortNum textBox"><c:out value="${resultList.sortNo}"></c:out></p>
							<button type="button" name="btn_up" class="btn_sm btn_primary" onclick="templateUp(this);">▲ 위</button>
							<button type="button" name="btn_down" class="btn_sm btn_primary" onclick="templateDown(this);">▼ 아래</button>
							<button type="button" class="btn_sm btn_primary" style="float: right; background-color: red;" onclick="deleteTemplate(this);">항목 삭제</button>
						</td>
					</tr>
					<tr>
						<th scope="row">공적요약 항목</th>
						<td>
							<input type="text" name="templateTitle" value="<c:out value="${resultList.templateTitle}" escapeXml="false" />" class="form_text w100p" />
						</td>
					</tr>
					<tr>
						<th scope="row">예시</th>
						<td>
							<textarea id="exContent_<c:out value="${resultList.templateId}" />" name="exContent"  class="exCont" rows="1" style="width:100%;"><c:out value="${resultList.exContent}"></c:out></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</c:forEach>

</form>
<script type="text/javascript">

	var oEditors = [];

	$(document).ready(function(){

		setEditors();	// 목록전체 textarea 에디터 생성

		if($('#listCnt').val() == '0'){	// 데이터 있을경우 빈템플릿 삭제
			addTemplate();
		}

		setUpBtnColor();
		setDownBtnColor();

	});

	function setUpBtnColor() {

		$('button[name=btn_up]').each(function() {
			$(this).removeClass();
			$(this).addClass('btn_sm btn_primary');
		})

		$('button[name=btn_up]').first().removeClass();
		$('button[name=btn_up]').first().addClass('btn_sm btn_secondary');

	}

	function setDownBtnColor() {

		$('button[name=btn_down]').each(function(i) {
			$(this).removeClass();
			$(this).addClass('btn_sm btn_primary');
		})

		$('button[name=btn_down]').last().removeClass();
		$('button[name=btn_down]').last().addClass('btn_sm btn_secondary');
	}

	function setEditors() {	// 예시 textarea 에디터 생성

		var dataCnt = Number($('#listCnt').val());
		var txtAreaId = ''

		$('.exCont').each(function(){
			var areaId  = $(this)[0].id;
			addEditor(areaId);
		})
	}

	function templateUp(obj) {	// 순번 위로이동

		var frontDiv = $(obj).closest('div');
		var frontDivId = frontDiv[0].id;
		var sortNo = Number($('#'+frontDivId).find('.sortNum').text());

		if(sortNo == 1) {
			alert('더 이상 위로 갈 수 없습니다.');
			return;
		}

		var frontNo = sortNo;
		var backNo = sortNo;

		frontNo--;

		var backObjs = $('.sortNum').get();
		var backNum = 0;
		for(var i = 0; i < backObjs.length; i++) {
			var chkNum = Number(backObjs[i].innerText);

			if(frontNo == chkNum) {
				var backDiv = $(backObjs[i]).closest('div');
				break;
			}
		}

		var backDivId = backDiv[0].id;

		$('#'+ backDivId).before( $('#' + frontDivId) );

		$('#' + frontDivId ).find('input[name=sortNo]').val(frontNo);

		$('#' + frontDivId ).find('.sortNum').text(frontNo);

		$('#' + backDivId ).find('input[name=sortNo]').val(backNo);

		$('#' + backDivId ).find('.sortNum').text(backNo);

		setUpBtnColor();
		setDownBtnColor();

		$('#'+frontDivId).find('input[name=templateTitle]').focus();
	}

	function templateDown(obj) {	// 순번 아래로 이동

		var tempCnt = $('input[name=templateId]').length;
		var frontDiv = $(obj).closest('div');
		var frontDivId = frontDiv[0].id;
		var sortNo = Number($('#'+frontDivId).find('.sortNum').text());

		if(sortNo == tempCnt) {
			alert('더 이상 아래로 갈 수 없습니다.');
			return;
		}

		var frontNo = sortNo;
		var backNo = sortNo;

		frontNo++;

		var backObjs = $('.sortNum').get();
		var backNum = 0;
		for(var i = 0; i < backObjs.length; i++) {
			var chkNum = Number(backObjs[i].innerText);

			if(frontNo == chkNum) {
				var backDiv = $(backObjs[i]).closest('div');
				break;
			}
		}

		var backDivId = backDiv[0].id;

		$('#' + frontDivId).before( $('#'+ backDivId) );

		$('#' + frontDivId ).find('input[name=sortNo]').val(frontNo);

		$('#' + frontDivId ).find('.sortNum').text(frontNo);

		$('#' + backDivId ).find('input[name=sortNo]').val(backNo);

		$('#' + backDivId ).find('.sortNum').text(backNo);

		setUpBtnColor();
		setDownBtnColor();

		$('#'+frontDivId).find('input[name=templateTitle]').focus();
	}

	function addTemplate() {	//템플릿 추가

		var tempCnt = $('input[name=templateId]').length;

		tempCnt++;

		var objId = 'exContent_' + tempCnt;

		var upBtn = 'onclick="templateUp(this);"';
		var downBtn = 'onclick="templateDown(this);"';
		var deleteBtn = 'onclick="deleteTemplate(this);"';

		var html = '';
		html += '<div class="cont_block" id="tempDiv_'+ tempCnt +'">';
		html += '<input type="hidden" name="templateId" value="">';
		html += '<input type="hidden" name="sortNo" value="'+tempCnt+'">';
		html += 	'<table class="formTable">';
		html += 		'<colgroup>';
		html +=				'<col style="width:15%" />';
		html += 			'<col />';
		html += 		'</colgroup>';
		html += 		'<tbody>';
		html += 			'<tr>';
		html +=					'<th scope="row">순번</th>';
		html += 				'<td>';
		html += 					'<p class="sortNum textBox">' + tempCnt + '</p>';
		html += 					'<button type="button" name="btn_up" class="btn_tbl_primary" '+ upBtn +'>▲ 위</button>';
		html += 					'<button type="button" name="btn_down" class="btn_tbl_primary" '+ downBtn +'>▼ 아래</button>';
		html += 					'<button type="button" class="btn_tbl_primary" style="float: right; background-color: red;" '+ deleteBtn +'>항목 삭제</button>';
		html +=					'</td>';
		html += 			'</tr>';
		html += 			'<tr>';
		html += 				'<th scope="row">공적요약 항목</th>';
		html += 				'<td>';
		html +=						'<input type="text" name="templateTitle" value="" class="form_text w100p" />';
		html += 					'</td>';
		html +=				'</tr>';
		html += 			'<tr>';
		html +=					'<th scope="row">예시</th>';
		html += 				'<td>';
		html += 					'<textarea id="'+objId+'"name="exContent" rows="1" style="width:100%;"></textarea>';
		html += 				'</td>';
		html += 			'</tr>';
		html +=			'</tbody>';
		html += 	'</table>';
		html += '</div>';

		$('#frm').append(html);

		addEditor(objId);	// 에디터 설정

		setUpBtnColor();
		setDownBtnColor();

		$('#tempDiv_'+tempCnt).find('input[name=templateTitle]').focus();
	}

	function deleteTemplate(obj) {

		if(confirm('삭제하시겠습니까?')) {

			var objDiv = $(obj).closest('div');
			var objDivId = objDiv[0].id;

			var templateId = $('#' + objDivId ).find('input[name=templateId]').val();
			var sortNo = $('#' + objDivId ).find('input[name=sortNo]').val();

			if(templateId == '') {
				$('#' + objDivId ).remove();	// 템플릿 삭제

				$('.sortNum').each(function(){
					var numDiv = $(this).closest('div');
					var numDivId = numDiv[0].id;

					var numVal = Number($(this).text());

					if(sortNo < numVal) {
						numVal--;
						$(this).text(numVal);
						$('#'+numDivId).find('input[name=sortNo]').val(numVal);
					}
				})

			} else {

				global.ajax({
					type : 'POST'
					, url : "/hanbit/judgingMng/deleteFormMng.do"
					, data : {'templateId' : templateId,
							  'sortNo' : sortNo
					}
					, dataType : 'json'
					, async : true
					, spinner : true
					, success : function(data){

						$('#' + objDivId ).remove();	// 템플릿 삭제

						var tempCnt = $('input[name=sortNo]').length;

						$('.sortNum').each(function(){

							var numDiv = $(this).closest('div');
							var numDivId = numDiv[0].id;

							var numVal = Number($(this).text());

							if(sortNo < numVal) {
								numVal--;
								$(this).text(numVal);
								$('#'+numDivId).find('input[name=sortNo]').val(numVal);
							}
						})

						if(tempCnt <= 0) {
							addTemplate();
						}
					}
				});
			}

			setUpBtnColor();
			setDownBtnColor();
		}
	}

	function addEditor(objId) {		// 에디터 생성

		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: objId,
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

	function doSave(){	// 저장

		if(!isValid()) {	// 제목 공백 validation
			return;
		}

		if(confirm('저장하시겠습니까?')) {

			for(var i = 0; i < $('textarea[name=exContent]').length; i++) {		// 에디터 데이터 textarea에 삽입
				var exObj = $('textarea[name=exContent]').get(i);
				var exContentId = exObj.id;
				var sHTML = oEditors.getById[exContentId].getIR();
				$('#'+exContentId).val(sHTML);
			}

			var saveData = new Array();
			var formData = $('#frm').serializeObject();

			var saveObject = {};
			var templateIdArr = formData.templateId;
			var sortArr = formData.sortNo;
			var templateTitleArr = formData.templateTitle;
			var exContentArr = formData.exContent;


			for (var i = 0; i < sortArr.length; i++) {	// 데이터 가공

				if(sortArr.length <= 1) {

					saveObject = {'templateId' : templateIdArr,
							  'sortNo' : sortArr,
							  'templateTitle' : templateTitleArr,
							  'exContent' : exContentArr
					}
				} else {

					saveObject = {'templateId' : templateIdArr[i],
							  'sortNo' : sortArr[i],
							  'templateTitle' : templateTitleArr[i],
							  'exContent' : exContentArr[i]
					}
				}

				saveData.push(saveObject);
			}

			global.ajax({
				type : 'POST'
				, url : "/hanbit/judgingMng/saveFormMng.do"
				, contentType : 'application/json'
				, data : JSON.stringify(saveData)
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					location.reload();
				}
			});
		}
	}


	function isValid() {	// 벨리데이션 체크

		var chk = true;

		$('input[name=templateTitle]').each(function(){
			if(isStringEmpty(this.value)) {
				alert('제목을 입력해 주세요.');
				chk = false;
			}
		})

		return chk;
	}

</script>
