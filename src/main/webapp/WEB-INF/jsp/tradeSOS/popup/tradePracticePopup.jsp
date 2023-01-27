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
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">무역실무 이관</h2>
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="fnMoveConsult();">확인</button>
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>
	<!--무역실무 이관 팝업 -->
	<div id="transferPop" class="layerPopUpWrap">
		<div class="layerPopUp">
			<div class="layerWrap" style="width:500px;">
				<div class="box">
					<form id="consultForm">
						<input type="hidden" id="sosSeq" name="sosSeq" value="<c:out value="${resultData.sosSeq}"/>"/>
						<input type="hidden" name="eventSdcit" id="eventSdcit" value=""/>
						<table class="formTable">
							<colgroup>
								<col style="width:30%">
								<col>
							</colgroup>
							<tbody>
							<tr>
								<th scope="row">상담분류</th>
								<td>
									<select name="reqTp"class="form_select w100p">
										<option value="" selected="">선택</option>
										<c:forEach var="data" items="${code026}" varStatus="status">
											<option value="${data.cdId}">${data.cdNm}</option>
										</c:forEach>
									</select>
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
		var paramSeq = $('#sosSeq').val();
		$('#consultForm #sosSeq').val(paramSeq);
		$('#consultForm #eventSdcit').val('MoveConsult');
	});

	// 무역실무 이관
	var consultSubmitFlag = true;
	function fnMoveConsult(){

		var aUrl = '<c:out value="${param.ajaxUrl}"/>';
		var formData = new FormData($('#consultForm')[0]);
		if ($("select[name=reqTp]").val() == "") {
			alert('상담분류를 선택해 주세요.');
			$("select[name=reqTp]").focus();
			return;
		}

		$.ajax({
			type:"post",
			enctype: 'multipart/form-data',
			url:aUrl,
			data:formData,
			processData:false,
			contentType:false,
			async:false,
			success:function(data){
				alert(data.MESSAGE);
				window.opener.location.reload()
				window.close();
			},
			error:function(request,status,error) {
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});

	}
</script>