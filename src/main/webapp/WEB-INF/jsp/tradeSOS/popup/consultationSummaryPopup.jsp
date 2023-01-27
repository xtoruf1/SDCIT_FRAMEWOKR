<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	 * @Class Name : cpSearchLayer.jsp
	 * @Description : 무역업체 검색 레이어
	 * @Modification Information
	 * @consultantMemberDetail
	 * @ 수정일			수정자		수정내용
	 * @ ----------	----	------
	 * @ 2021.10.13	양지환		최초 생성
	 *
	 * @author 양지환
	 * @since 2021.10.13
	 * @version 1.0
	 * @see
	 *
	 */
%>

<!-- 상담 요약  레이어팝업 -->
<div id="summaryPop" class="layerPopUpWrap">
	<div class="layerPopUp">
		<div class="layerWrap" style="width:900px;">
			<div class="flex">
				<h2 class="popup_title">상담 요약 내역</h2>
				<div class="ml-auto">
					<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
				</div>
			</div>
			<div class="box">
				<form id="summaryFrm" name="summaryFrm" method="post">
					<input type="hidden" id="reqId" name="reqId" value='<c:out value="${param.reqId}"/>'/>
				<table class="formTable">
					<colgroup>
						<col style="width:20%">
						<col>
					</colgroup>
					<tbody>
					<tr>
						<th scope="row">신청 제목</th>
						<td id="popReqTitle"></td>
					</tr>
					<tr>
						<th scope="row">신청 내용</th>
						<td id="popReqContent"></td>
					</tr>
					<tr>
						<th scope="row">담당 전문가</th>
						<td id="popAdmNm"></td>
					</tr>
					<tr>
						<th scope="row">답변 제목</th>
						<td id="popAnswerTitle"></td>
					</tr>
					<tr>
						<th scope="row">답변 내용</th>
						<td id="popAnswerContent">

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

<script type="text/javascript">

	$(document).ready(function()
	{
		doSearch();
	});

	function doSearch(){
		var reqId = $('#summaryFrm #reqId').val();
		$.ajax({
			type:"post",
			url:"/tradeSOS/area/areaSuggestCompactDetailAjax.do",
			data:{ "reqId" : reqId},
			async:false,
			success:function(data){
				$("#popReqTitle").text("");
				$("#popReqContent").html("");
				$("#popAdmNm").text("");
				$("#popAnswerTitle").text("");
				$("#popAnswerContent").html("");
				//신청제목
				$("#popReqTitle").text(data.resultData.reqTitle);
				//신청 내용
				$("#popReqContent").html(data.resultData.reqContent.replace(/\n/g, '<br/>'));
				if (data.resultAnswerData != null){
					//담당 전문가
					$("#popAdmNm").text(data.resultAnswerData.admNm);
					//답변 제목
					$("#popAnswerTitle").text(data.resultAnswerData.answerTitle);
					//답변 내용
					$("#popAnswerContent").html(data.resultAnswerData.answerContent.replace(/\n/g, '<br/>'));
				}
			}
		});
		//openLayer('summaryPop');
	}

</script>