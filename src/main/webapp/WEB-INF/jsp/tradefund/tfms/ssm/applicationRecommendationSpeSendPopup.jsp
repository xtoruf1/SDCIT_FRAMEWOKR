<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="fundFaxSendPopupForm" name="fundFaxSendPopupForm" method="get" onsubmit="return false;">

<!-- 팝업 타이틀 -->
<h2 class="popup_title">추천서 발송</h2>


<div class="popup_body" style="max-width: 700px;">
	<!--검색 시작 -->
	<div class="search">
		<table class="formTable">
			<colgroup>
				<col style="width:15%">
				<col >
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">발송구분</th>
					<td>
						<label class="label_form" >
							<input type="checkbox" class="form_radio" id="sendAll" name="sendAll" value="Y" onclick="chkSendAll()" >
							<span class="label">전체</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_radio sendType" id="sendAlimtalk" name="sendAlimtalk" value="Y">
							<span class="label">알림톡</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_radio sendType" id="sendFax" name="sendFax" value="Y">
							<span class="label">팩스</span>
						</label>
						<label class="label_form">
							<input type="checkbox" class="form_radio sendType" id="sendEamil" name="sendEamil" value="Y">
							<span class="label">이메일</span>
						</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!--검색 끝 -->
</div>

<div class="btn_group mt-20 _center " id="btn_group">
		<a href="javascript:doSend();" 	class="btn btn_primary">발송</a>
		<a href="javascript:doClear();" class="btn btn_secondary">닫기</a>
	</div>

</form>

<script type="text/javascript">

	$(document).ready(function () {

	});

	//전체 체크
	function chkSendAll(){
		if($("#sendAll").is(":checked")){ //대상이 체크 되어 있을 때
	    	//모든 체크박스 체크
	        $(".sendType").prop("checked", true);
	    }else{ //대상이 체크 해제 되어 있을 때
	    	//모든 체크박스 체크해제
	        $(".sendType").prop("checked", false);
	    }
	}

	//발송
	function doSend(){

		var saveJson = sheet1.GetSaveJson({StdCol:'chk'});
		var ccf = getSaveDataSheetList('fundFaxSendPopupForm' , saveJson);

		if( saveJson.data.length == 0 ){
			alert('선택된것이 없습니다. 확인후 진행 바랍니다.');
			return ;
		}

		var chkAllCnt 		= 0;
		var chkAlimtalkCnt 	= 0;
		var chkFaxCnt 		= 0;
		var chkEmailCnt 	= 0;

		if($("#sendAll").is(":checked")){
			chkAllCnt++;
		}

		if($("#sendAlimtalk").is(":checked")){
			chkAlimtalkCnt++;
		}

		if($("#sendFax").is(":checked")){
			chkFaxCnt++;
		}

		if($("#sendEamil").is(":checked")){
			chkEmailCnt++;
		}


		if( (chkAllCnt + chkAlimtalkCnt + chkFaxCnt + chkEmailCnt) == 0 ){
			alert('발송구분을 선택해주세요.')
			return ;
		}

		//알림톡 전화번호 체크
		if( chkAlimtalkCnt > 0){
			for( var i = 1 ; i <= sheet1.RowCount(); i++){

				if(sheet1.GetCellValue(i, "chk") == "1"){
					if(sheet1.GetCellValue(i, "membHp") == "" || sheet1.GetCellValue(i, "membHp") == null){
						alert("발송 할 연락처가 없습니다.");
						sheet1.SelectCell(i);
						return;
					}
				}
			}
		}

		//메일 체크
		if( chkEmailCnt > 0){
			for( var i = 1 ; i <= sheet1.RowCount(); i++){

				if(sheet1.GetCellValue(i, "chk") == "1"){
					if(sheet1.GetCellValue(i, "membEmail") == "" || sheet1.GetCellValue(i, "membEmail") == null){
						alert("발송 할 메일정보가 없습니다.");
						sheet1.SelectCell(i);
						return;
					}
				}
			}
		}

		if(!confirm("발송하시겠습니까?")){
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/applicationRecommendationSpeSendPopupTotal.do" />'
			, data : JSON.stringify(ccf)
			, contentType : 'application/json'
			, dataType : 'json'
			, async: false
			, spinner : true
			, success : function(data){

				var msg = '';
				if( chkAllCnt > 0 || chkAlimtalkCnt > 0 ){
					msg = '알림톡 : ' + data.reuslt.alimtalkCnt + '건';
				}

				if( chkAllCnt > 0 || chkFaxCnt > 0 ){
					if( msg != ''){
						msg = msg + ',';
					}
					msg = msg + '팩스 : ' + data.reuslt.faxCnt + '건';
				}

				if( chkAllCnt > 0 || chkEmailCnt > 0 ){
					if( msg != ''){
						msg = msg + ',';
					}
					msg = msg + '이메일 : ' + data.reuslt.eamilCnt + '건';
				}

				alert("총 "+saveJson.data.length+"건 중 "+msg+"을 발송하였습니다.");
				doClear();
			}
		});

	}


	//닫기
	function doClear(){
		closeLayerPopup();
	}
</script>