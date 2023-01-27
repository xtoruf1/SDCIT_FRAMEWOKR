<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="sendMsgPopupForm" name="sendMsgPopupForm" method="get" onsubmit="return false;">
<input type="hidden" id="deptGb" 			name="deptGb" 			value="<c:out value="${param.deptGb}"/>" />
<input type="hidden" id="searchDeptName" 	name="searchDeptName" 	value="" />
<input type="hidden" id="svrId" 			name="svrId" 			value="<c:out value="${param.svrId}"/>" />
<input type="hidden" id="applyId" 			name="applyId" 			value="<c:out value="${param.applyId}"/>" />
<input type="hidden" id="applyIdPw" 		name="applyIdPw" 		value="<c:out value="${param.applyIdPw}"/>" />
<input type="hidden" id="st" 				name="st" 				value="<c:out value="${param.st}"/>" />
<div style="max-width: 900px; max-height: 800pxpx;" class="fixed_pop_tit">
<!-- 팝업 타이틀 -->
<div class="flex popup_top">
	<h2 class="popup_title">문자,메일 발송</h2>
	<div class="ml-auto">
		<button type="button" onclick="doSendMsgSave();" class="btn_sm btn_primary">발송</button>
		<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
	</div>
</div>
<div class="popup_body">
	<table class="formTable">
		<colgroup>
			<col style="width:18%;">
			<col>
			<col style="width:18%;">
			<col>
		</colgroup>
		<tr>
			<th>전송분류<strong class="point">*</strong></th>
			<td>
				<select id="sendComCd" name="sendComCd"  class="form_select" style="width:30%;" required="required" title="구분" onchange="doCodeComSearch()" >
					<c:forEach var="item" items="${COM000}" varStatus="status">
						<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.sSendComCd}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
					</c:forEach>
				</select>
				<select id="msgGb" name="msgGb"  class="form_select" style="width:50%;" required="required" title="진행상태" onChange="doCodeSearch()" >
				</select>
			</td>
			<th>설명<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="note1" 	name="note1"  placeholder="설명" 	title="설명" maxlength="300"  readonly="readonly" style="width:80%;" />
			</td>
		</tr>
		<tr>
			<th>업체명<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="memberId" 	name="memberId"  placeholder="무역업번호" 	title="무역업번호" maxlength="50" required="required" value="<c:out value="${param.memberId}"/>" style="width:30%;" />
				<input type="text" class="form_text" id="coNm" 		name="coNm"  	 placeholder="업체명" 	title="업체명" 	maxlength="50" required="required" value="<c:out value="${param.coNm}"/>" style="width:50%;" />
			</td>
			<th>수신자 이름<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="userNm" 	name="userNm"  placeholder="수신자이름" 	title="수신자이름" maxlength="80" required="required" value="<c:out value="${param.membNm}"/>" style="width:80%;" />
			</td>
		</tr>
		<tr class="smsGb">
			<th>수신자 전화번호<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="userTelNo" name="userTelNo"  placeholder="수신자전화번호" 	title="수신자전화번호" maxlength="15"  value="<c:out value="${param.membHp}"/>" style="width:80%;" />
			</td>
			<th>발신자 전화번호<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="membTelNo" name="membTelNo"  placeholder="발신자전화번호" 	title="발신자전화번호" maxlength="15"  value="1566-5114" style="width:80%;" />
			</td>
		</tr>
		<tr class="mailGb">
			<th>수신자 이메일<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="userEmail" name="userEmail"  placeholder="수신자이메일" 	title="수신자이메일" maxlength="80"  value="<c:out value="${param.membEmail}"/>" style="width:80%;" />
			</td>
			<th>발신자 이메일<strong class="point">*</strong></th>
			<td>
				<input type="text" class="form_text" id="membEmail" name="membEmail"  placeholder="발신자이메일" 	title="발신자이메일" maxlength="80"  value="<c:out value="${email}"/>" style="width:80%;" />
			</td>
		</tr>
		<tr>
			<th>발송구분</th>
			<td>
				<label class="label_form">
					<input type="radio" class="form_radio" id="send_cd_a" name="sendCd"  value="A" />
					<span class="label">전체</span>
				</label>
				<label class="label_form">
					<input type="radio" class="form_radio" id="send_cd_m" name="sendCd" value="M" />
					<span class="label">문자</span>
				</label>
				<label class="label_form">
					<input type="radio" class="form_radio" id="send_cd_e" name="sendCd" value="E" />
					<span class="label">메일</span>
				</label>
			</td>
			<th>부서명</th>
			<td>
				<c:out value="${deptInfo.deptNm}"/>
			</td>
		</tr>
		<tr class="smsGb">
			<th>문자 제목<strong class="point">*</strong></th>
			<td colspan="3">
				<input type="text" class="form_text" id="mmsTitle" name="mmsTitle"  placeholder="문자제목" title="문자제목" maxlength="300"  style="width:80%;" /> 글자수:  <span id="byteSize"></span>
			</td>
		</tr>
		<tr class="smsGb">
			<th>문자 내용<strong class="point">*</strong></th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mmsMsg" name="mmsMsg" placeholder="문자내용" title="문자내용" style="height:99%; width:99%" onchange="doByteSearch()" ></textarea>
			</td>
		</tr>
		<tr class="mailGb">
			<th>메일 제목<strong class="point">*</strong></th>
			<td colspan="3">
				<input type="text" class="form_text" id="mailTitle" name="mailTitle"  placeholder="메일제목" 	title="메일제목" maxlength="300"  style="width:100%;" />
			</td>
		</tr>
		<tr class="mailGb">
			<th>메일 내용<strong class="point">*</strong></th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mailMsg" name="mailMsg" placeholder="문자내용" title="문자내용" style="height:99%; width:99%" ></textarea>
			</td>
		</tr>
		<tr>
			<th>비고2</th>
			<td >
				<input type="text" class="form_text" id="note2" name="note2"  placeholder="비고2" 	title="비고2" maxlength="300"   style="width:80%;" />
			</td>
			<th>비고3</th>
			<td >
				<input type="text" class="form_text" id="note3" name="note3"  placeholder="비고3" 	title="비고3" maxlength="300"    style="width:80%;" />
			</td>
		</tr>
	 </table>
</div>
</div>
</form>
<script type="text/javascript">
	var oEditors = [];
	$(document).ready(function(){
		setExpPhoneNumber(['#userTelNo', '#membTelNo'], 'W');

		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "mailMsg",
			sSkinURI: '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />',
			htParams : {
				bUseToolbar : true,									// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,							// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,								// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				// aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					// alert("완료!");
				}
			}, // boolean
			fOnAppLoad : function(){
				// 예제 코드
				// oEditors.getById["contEditor"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);

				doCodeComSearch();
			},
			fCreator: "createSEditor2"
		});

		// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
		$('.modal').on('click', function(e){
			if (!$(e.target).is($('.modal-content, .modal-content *'))) {
				closeLayerPopup();
			}
		});

		$("input[name='sendCd']").change(function(){
		 	var sendGb = $("input[name='sendCd']:checked").val();

	        if (sendGb == "M") {
	        	$(".smsGb").show();
	        	$(".mailGb").hide();
	        } else if (sendGb == "E") {
	        	$(".smsGb").hide();
	        	$(".mailGb").show();
	        } else {
	        	$(".smsGb").show();
	        	$(".mailGb").show();
	        }
		});
	});

	// 발송
	function doSendMsgSave() {
		var f = document.sendMsgPopupForm;

		var sendGb = jQuery('input[name=sendCd]:checked').val();

		if (sendGb == "A" || sendGb == "M" || sendGb == "E") {
		} else {
			alert("발송구분을 선택해 주세요.");
			return;
		}

		if (f.userNm.value == "" || f.userNm.value == null) {
			alert("수신자 이름을 입력해 주세요.");
			f.userNm.focus();

			return;
		}

		if (sendGb == "A" || sendGb == "M") {
			if (f.userTelNo.value == "" || f.userTelNo.value == null) {
				alert("수신자 전화번호를 입력해 주세요.");
				f.userTelNo.focus();

				return;
			}

			if (f.membTelNo.value == "" || f.membTelNo.value == null) {
				alert("발신자 전화번호를 입력해 주세요.");
				f.membTelNo.focus();

				return;
			}

			if (f.mmsTitle.value == "" || f.mmsTitle.value == null) {
				alert("문자 제목을 입력해 주세요.");
				f.mmsTitle.focus();

				return;
			}

			if (f.mmsMsg.value == "" || f.mmsMsg.value == null) {
				alert("문자 내용을 입력해 주세요.");
				f.mmsMsg.focus();

				return;
			}
		}

		if (sendGb == "A" || sendGb == "E") {
			if (f.userEmail.value == "" || f.userEmail.value == null) {
				alert("수신자 이메일을 입력해 주세요.");
				f.userEmail.focus();

				return;
			}

			if (f.membEmail.value == "" || f.membEmail.value == null) {
				alert("발신자 이메일을 입력해 주세요.");
				f.membEmail.focus();

				return;
			}

			if (f.mailTitle.value == "" || f.mailTitle.value == null) {
				alert("메일 제목을 입력해 주세요.");
				f.mailTitle.focus();

				return;
			}
		}

		if (!confirm("발송하시겠습니까?")) {
			return;
		}

		oEditors.getById["mailMsg"].exec("UPDATE_CONTENTS_FIELD", []);

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendMsgPopupSave.do" />'
			, data : $('#sendMsgPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("발송 되었습니다.");
				closeLayerPopup();
			}
		});
	}

	// 전송분류 : 구분 선택하면 진행상태 셀렉트 박스 값 가져오기
	function doCodeComSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendMsgPopupSearchComCode.do" />'
			, data : $('#sendMsgPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#msgGb').children().remove();

				var msgGbOption = "";
				for (var k in data.resultList) {
					var obj = data.resultList[k];
					var detailcd = obj.detailcd;
					var detailnm = obj.detailnm;

					msgGbOption = "<option value='" + detailcd + "'>" + detailnm + "</option>";
					$("#msgGb").append(msgGbOption);
				}

				if (data.resultCnt > 0) {
					doCodeSearch();
				}
			}
		});
	}

	// 전송분류 : 진행상태 선택하면 기본 값 가져오기
	function doCodeSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendMsgPopupSearchCode.do" />'
			, data : $('#sendMsgPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				doFormSelect(data.result);
			}
		});
	}

	// 값 세팅
	function doFormSelect(vo) {
		jQuery("#mmsTitle").val(vo.mmsTitle);
		jQuery("#mmsMsg").val(vo.mmsMsg);
		jQuery("#mailTitle").val(vo.mailTitle);
		jQuery("#note1").val(vo.note1);
		jQuery("#note2").val(vo.note2);
		jQuery("#note3").val(vo.note3);

		jQuery("#byteSize").text(vo.byteSize);

		setHTML(vo.mailMsg);
		jQuery("#mailMsg").val(vo.mailMsg);
	}

	// 에디터 값 세팅
	function setHTML(val) {
		oEditors.getById["mailMsg"].exec("SET_IR", [val]);
	}

	// 문자 바이트 길이 계산
	function doByteSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendMsgPopupSearchByte.do" />'
			, data : $('#sendMsgPopupForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				jQuery("#byteSize").text(data.byteSize);
			}
		});
	}
</script>