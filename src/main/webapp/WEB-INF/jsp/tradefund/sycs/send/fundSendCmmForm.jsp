<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<form id="sendCmmFormForm" name="sendCmmFormForm" method="get" onsubmit="return false;">
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
	</div>
	<div class="ml-15">
		<a href="javascript:doClear();" class="btn_sm btn_secondary">초기화</a>
	</div>
</div>
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:18%;">
			<col>
			<col style="width:18%;">
			<col>
		</colgroup>
		<tr>
			<th>전송분류</th>
			<td>
				<select id="sendComCd" name="sendComCd"  class="form_select" style="width:30%;" required="required" title="구분" onchange="doCodeComSearch()" >
					<c:forEach var="item" items="${COM000}" varStatus="status">
						<c:if test="${item.detailcd ne '5'}">
							<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchSendComCd}">selected="selected"</c:if> ><c:out value="${item.detailnm}"/></option>
						</c:if>
					</c:forEach>
				</select>
				<select id="msgGb" name="msgGb"  class="form_select" style="width:50%;" required="required" title="진행상태" onChange="doCodeSearch()" >
				</select>
			</td>
			<th>설명</th>
			<td>
				<input type="text" class="form_text" id="note1" 	name="note1"  placeholder="설명" 	title="설명" maxlength="300" required="required"  style="width:80%;"  />
			</td>
		</tr>
		<tr>
			<th>문자 제목</th>
			<td colspan="3">
				<input type="text" class="form_text" id="mmsTitle" name="mmsTitle"  placeholder="문자제목" title="문자제목" maxlength="300" required="required" style="width:80%;" /> 글자수:  <span id="byteSize"></span>
			</td>
		</tr>
		<tr>
			<th>문자 내용</th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mmsMsg" name="mmsMsg" placeholder="문자내용" title="문자내용" style="height:99%; width:99%" required="required"
				 onchange="doByteSearch()" ></textarea>
			</td>
		</tr>
		<tr>
			<th>메일 제목</th>
			<td colspan="3">
				<input type="text" class="form_text" id="mailTitle" name="mailTitle"  placeholder="메일제목" 	title="메일제목" maxlength="300" required="required" style="width:100%;"  />
			</td>
		</tr>
		<tr>
			<th>메일 내용</th>
			<td colspan="3">
				<textarea rows="10" class="form_textarea" id="mailMsg" name="mailMsg" placeholder="문자내용" title="문자내용" style="height:99%; width:99%" required="required"></textarea>
			</td>
		</tr>
		<tr>
			<th>발신자 전화번호</th>
			<td>
				<input type="text" class="form_text" id="membTelNo" name="membTelNo"  placeholder="발신자전화번호" 	title="발신자전화번호" maxlength="15" required="required"  style="width:80%;" />
			</td>
			<th>발신자 이메일</th>
			<td>
				<input type="text" class="form_text" id="membEmail" name="membEmail"  placeholder="발신자이메일" 	title="발신자이메일" maxlength="80" required="required"  style="width:80%;" />
			</td>
		</tr>
		<tr>
			<th>비고2</th>
			<td >
				<input type="text" class="form_text" id="note2" name="note2"  placeholder="비고2" 	title="비고2" maxlength="300" required="required"   style="width:80%;" />
			</td>
			<th>비고3</th>
			<td >
				<input type="text" class="form_text" id="note3" name="note3"  placeholder="비고3" 	title="비고3" maxlength="300" required="required"   style="width:80%;"  />
			</td>
		</tr>
	</table>
</div>
</form>
<script type="text/javascript">
	var oEditors = [];
	$(document).ready(function () {
		setExpPhoneNumber(['#membTelNo'], 'W');

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
	});

	// 발송
	function doSave() {
		var f = document.sendCmmFormForm;

// 		if (!doValidFormRequired(f)) {
// 			return;
// 		}

		if (!confirm("저장하시겠습니까?")) {
			return;
		}

		oEditors.getById["mailMsg"].exec("UPDATE_CONTENTS_FIELD", []);

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/insertSendCmmForm.do" />'
			, data : $('#sendCmmFormForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("저장 되었습니다.");
			}
		});
	}

	function doDel() {
		var f = document.sendCmmFormForm;

		if (!confirm("삭제하시겠습니까?")) {
			return;
		}

		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/deleteSendCmmForm.do" />'
			, data : $('#sendCmmFormForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert("삭제 되었습니다.");
			}
		});
	}

	// 전송분류 : 구분 선택하면 진행상태 셀렉트 박스 값 가져오기
	function doCodeComSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendCmmFormSearchComCodeFund.do" />'
			, data : $('#sendCmmFormForm').serialize()
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
			, url : '<c:url value="/sycs/send/sendCmmFormSearchCode.do" />'
			, data : $('#sendCmmFormForm').serialize()
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
// 		jQuery("#membEmail").val(vo.membEmail);
// 		jQuery("#membTelNo").val(vo.membTelNo);
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
// 		oEditors.getById["MAIL_CNTT"].exec("PASTE_HTML", [val]);
	}

	// 문자 바이트 길이 계산
	function doByteSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/send/sendCmmFormSearchByte.do" />'
			, data : $('#sendCmmFormForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				jQuery("#byteSize").text(data.byteSize);
			}
		});
	}

	// 초기화
	function doClear() {
		location.reload();
	}
</script>