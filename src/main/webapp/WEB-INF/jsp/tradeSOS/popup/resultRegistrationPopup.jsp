<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">결과 등록</h2>

		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="fnResult();">결과 등록</button>
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>

	<!-- 결과등록 레이어팝업 -->
	<div id="resultPop" class="layerPopUpWrap" >
		<div class="layerPopUp">
			<div class="layerWrap" style="width:800px;">
				<div class="box">
					<form id="resultForm" enctype="multipart/form-data">
						<input type="hidden" name="eventSdcit" id="eventSdcit" value="Result"/>
						<input type="hidden" id="sosSeq" name="sosSeq" value="${param.pSosSeq}"/>
						<table class="formTable">
							<colgroup>
								<col style="width:10%">
								<col style="width:10%">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" colspan="2">건의구분</th>
									<td>
										<c:forEach var="data" items="${code133}" varStatus="status">
											<label class="label_form">
												<input type="radio" class="form_radio" name="reqTypeCd" id="reqTypeCd${status.index}" value="${data.cdId}" <c:out value="${status.index == 0 ? 'checked' : ''}"/>><label class="label" for="reqTypeCd${status.index}">${data.cdNm}</label>
											</label>
										</c:forEach>
									</td>
								</tr>
								<tr>
									<th scope="row" colspan="2">수용여부</th>
									<td>
										<label class="label_form" for="accept">
											<input type="checkbox" class="form_checkbox" id="accept" name="agreeYn" value="Y">
											<span class="label">수용</span>
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row" colspan="2">답변내용</th>
									<td>
										<textarea id="reqCompAns" name="reqCompAns" rows="3" style="width: 100%;height: 200px" ></textarea>
									</td>
								</tr>
								<tr>
									<th scope="row" colspan="2">비망록 [업체비공개]</th>
									<td>
										<textarea id="recComment" name="recComment" rows="3" class="form_textarea"></textarea>
									</td>
								</tr>

								<tr>
									<th scope="row" rowspan="2">관련<br>법률</th>
									<th scope="row">법률</th>
									<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률   Ex) 관세법" name="law" maxlength="1000"></td>
								</tr>
								<tr>
									<th scope="row">조항</th>
									<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" name="lawClause" maxlength="1000"></td>
								</tr>
								<tr>
									<th scope="row" colspan="2">기타참고사항</th>
									<td><input type="text" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" name="dscr" maxlength="1000"></td>
								</tr>
								<tr>
									<th scope="row" colspan="2">첨부파일</th>
									<td>
										<div class="form_file">
											<p class="file_name">첨부파일을 선택하세요</p>
											<label class="file_btn">
												<input type="file" name="adminAttach" id="adminAttach" >
												<span class="btn_tbl">찾아보기</span>
											</label>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</form>

				</div>
				<button type="button" class="btn_pop_close" onclick="closeLayerPopup();"></button>
			</div>
			<div class="layerFilter"></div>
		</div>
	</div>

<script type="text/javascript" src="/js/tradeSosComm.js"></script>
<script type="text/javascript">
	var editorObject = [];
	$(document).ready(function()
	{

		nhn.husky.EZCreator.createInIFrame({
			oAppRef : editorObject
			, elPlaceHolder : 'reqCompAns'
			, sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />'
			, htParam : {
				// 툴바 사용 여부 (true: 사용 / false : 사용하지 않음)
				bUseToolbar : true
				// 입력창 크기 조절바 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseVerticalResizer : true
				// 모드 탭 (Editor | HTML | TEXT) 사용 여부 (true: 사용 / false : 사용하지 않음)
				, bUseModeChanger : true
			},
			fOnAppLoad : function(){
				let temp = "";
				temp += "■ 업계 요청사항<br>ㅇ<br><br>";
				temp += "■ 현황 및 문제점<br>ㅇ<br><br>";
				temp += "■ 검토 및 조치사항<br>ㅇ<br><br>";
				temp += "■ 소관부처/담당자<br>ㅇ<br><br>";
				temp += "붙임1.";
				//예제 코드
				editorObject.getById["reqCompAns"].exec("PASTE_HTML", [temp]);
			},
			fCreator: "createSEditor2"
		})
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	//결과등록
	var resultSubmitFlag = true;
	function fnResult(){
		if (confirm('결과등록 하시겠습니까?')) {
		editorObject.getById["reqCompAns"].exec("UPDATE_CONTENTS_FIELD", []);

		//var sHTML = oEditors.getById["result"].getIR();
		var sHTML = $('#reqCompAns').val();
		//에디터 img 태그 url에 도메인 추가 (KITA에서 이미지 확인을 위해)
		var defaultImageViewUrl = '/utl/web/imageSrc.do';
		var changeImageViewUrl = window.location.protocol + '//' + window.location.host + defaultImageViewUrl;
		if (sHTML.indexOf(defaultImageViewUrl) != -1) {
			sHTML = sHTML.replaceAll(defaultImageViewUrl, changeImageViewUrl);
		}
		var checkContent = $.trim(deletetag(sHTML, ['img']).replaceAll('&nbsp;',''));//img태그 제외 모든 태그 삭제 후 &nbsp;제거
		$('#reqCompAns').val(sHTML);
		var form = $("#resultForm");
		if (check_byte($("#recComment").val()) > 2000) {

			alert('비망록은 2000byte 이하로 입력하세요.');

			$("#recComment").focus();

			return;

		}

		var aUrl = '<c:out value="${param.ajaxUrl}"/>';
		var formData = new FormData($('#resultForm')[0]);

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url: aUrl,
			data:formData,
			processData:false,
			contentType:false,
			async:false,
			success:function(data){
				closeLayerPopup();
				window.location.reload();
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		}
	}

</script>