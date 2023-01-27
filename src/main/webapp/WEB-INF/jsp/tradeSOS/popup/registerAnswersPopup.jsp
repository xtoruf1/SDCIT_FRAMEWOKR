<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 답변 등록 레이어팝업 -->
<div id="resultPop" class="layerPopUpWrap">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:700px;">
			<!-- 팝업 타이틀 -->
			<div class="flex">
				<c:choose>
					<c:when test="${not empty resultAnswerData}">
						<h2 class="popup_title">답변 수정</h2>
					</c:when>
					<c:otherwise>
						<h2 class="popup_title">답변 등록</h2>
					</c:otherwise>
				</c:choose>
				<div class="ml-auto">
					<c:choose>
						<c:when test="${not empty resultAnswerData}">
							<button type="button" class="btn_sm btn_primary" onclick="fnAnswerSubmit()">답변 수정</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn_sm btn_primary" onclick="fnAnswerSubmit()">답변 등록</button>
						</c:otherwise>
					</c:choose>
					<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
				</div>
			</div>
			<div class="box">
				<form name="answerFrm" id="answerFrm" action ="" method="post">
					<input type="hidden" id="reqId" name="reqId" value="<c:out value="${resultData.reqId}"/>"/>
					<input type="hidden" name="answerId" value="<c:out value="${resultAnswerData.answerId}"/>"/>
					<input type="hidden" name="topMenuId" value="" />
					<input type="hidden" name="eventSdcit" id="eventSdcit" value="AnswerProc"/>
					<table class="formTable">
						<colgroup>
							<col style="width:12%">
							<col style="width:12%">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row" colspan="2">답변 제목</th>
							<td>
								<input type="text" name="answerTitle" class="form_text w100p" value="<c:out value="${resultAnswerData.answerTitle}"/>">
							</td>
						</tr>
						<tr>
							<th scope="row" colspan="2">답변 내용</th>
							<td>
								<textarea name="answerContent" rows="5" class="form_textarea"><c:out value="${resultAnswerData.answerContent}"/></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row" rowspan="2">관련<br>법률</th>
							<th scope="row">법률</th>
							<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률   Ex) 관세법" name="law" maxlength="1000" value="<c:out value="${resultAnswerData.law}"/>"></td>
						</tr>
						<tr>
							<th scope="row">조항</th>
							<td><input type="text" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" name="lawClause" maxlength="1000" value="<c:out value="${resultAnswerData.lawClause}"/>"></td>
						</tr>
						<tr>
							<th scope="row" colspan="2">기타참고사항</th>
							<td><input type="text" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" name="dscr" maxlength="1000" value="<c:out value="${resultAnswerData.dscr}"/>"></td>
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


<script type="text/javascript">

	$(document).ready(function()
	{
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function fnAnswerSubmit(){
		let form = document.answerFrm;
		if(isStringEmpty(form.answerTitle.value)){
			alert("답변 제목을 입력해 주세요.");
			form.answerTitle.focus();
			return;
		}

		if(isStringEmpty(form.answerContent.value)){
			alert("답변 내용을 입력해 주세요.");
			form.answerContent.focus();
			return;
		}

		var pReqId = $('#frm #reqId').val();
		$('#answerFrm #reqId').val(pReqId);
		var formData = new FormData($('#answerFrm')[0]);

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url:"/tradeSOS/area/areaSuggestDetailProc.do",
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

</script>