<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% 
	pageContext.setAttribute("cn", "\n");
%>
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />
<c:set var="profile"><spring:eval expression="@environment.getProperty('spring.profiles.active')" /></c:set>
<form id="popupLogForm" name="popupLogForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="prvtConsultId" value="${result.prvtConsultId}" />
<div style="width: 900px;">
	<!-- 팝업 타이틀 -->
	<div class="flex">
		<h2 class="popup_title">상담일지 등록</h2>
		<div class="ml-auto">
			<button type="button" onclick="closeLayerPopup();" class="btn_sm btn_secondary">닫기</button>
		</div>
	</div>
	<!-- 팝업 내용 -->
	<div class="popup_body">
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col />
			</colgroup>
			<tr>
				<th>작성자</th>
				<td>${result.reqNm}</td>
			</tr>
			<tr>
				<th>예약일시</th>
				<td>
					${fn:substring(result.rsrvDate, 0, 4)}-${fn:substring(result.rsrvDate, 4, 6)}-${fn:substring(result.rsrvDate, 6, 8)}
					${fn:substring(result.rsrvTime, 0, 2)}:${fn:substring(result.rsrvTime, 2, 4)}
				</td>
			</tr>
			<tr>
				<th>상담분야</th>
				<td>${result.consultTypeNm}</td>
			</tr>
			<tr>
				<th>상담요지</th>
				<td>${fn:replace(result.consultText, cn, "<br />")}</td>
			</tr>
		</table>
		<div style="margin-top: 10px;">
			<table class="formTable">
				<colgroup>
					<col style="width: 15%;" />
					<col />
				</colgroup>
				<tr>
					<th>작성자</th>
					<td>${result.expertNm}</td>
				</tr>
				<c:set var="now" value="<%=new java.util.Date()%>" />
				<tr>
					<th>작성일자</th>
					<td><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<c:choose>
							<c:when test="${empty result.consultLog}">
								<textarea id="consultLog" name="consultLog" rows="5" maxlength="2000" class="form_textarea">[문의내용]


[상담 및 자문내용]
</textarea>					
							</c:when>
							<c:otherwise>
								<textarea id="consultLog" name="consultLog" rows="5" maxlength="2000" class="form_textarea">${result.consultLog}</textarea>
							</c:otherwise>
						</c:choose>		
					</td>
				</tr>
				<tr>
					<th>관리자 전달사항</th>
					<td><input type="text" id="notice" name="notice" value="${result.notice}" class="form_text w100p" placeholder="관리자만 볼수있는 전달사항을 작성해 주세요." /></td>
				</tr>
				<tr>
					<th>관련 법률(법률)</th>
					<td>
						<input type="text" id="law" name="law" value="${result.law}" maxlength="500" class="form_text w100p" placeholder="답변 관련 법률 Ex) 관세법" />
						<input type="hidden" id="logConsultId" name="logConsultId" />
						<input type="hidden" id="consultLogRsrvDate" name="consultLogRsrvDate" />
					</td>
				</tr>
				<tr>
					<th>관련 법률(조항)</th>
					<td><input type="text" id="lawClause" name="lawClause" value="${result.lawClause}" maxlength="500" class="form_text w100p" placeholder="답변 관련 법률 조항 Ex) 제32조 1항" /></td>
				</tr>
				<tr>
					<th>기타참고사항</th>
					<td><input type="text" id="dscr" name="dscr" value="${result.dscr}" maxlength="500" class="form_text w100p" placeholder="답변에 참고한 정보를 작성해주세요 (관련 문서명 및 사이트 주소)" /></td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="attachFieldList">
						<c:if test="${fn:length(fileList) > 0}">
							<c:forEach var="item" items="${fileList}" varStatus="status">
								<div class="addedFile" <c:if test="${status.first}">style="margin-top: 3px;"</c:if>>
									<a href="<c:url value="/tradeSOS/exp/expertFileDownload.do" />?fileId=${item.fileId}&fileSeq=${item.fileSeq}" class="filename">${item.orgFileNm}</a>
									<a href="javascript:void(0);" onclick="deleteExpertFile(this, ${item.fileId}, ${item.fileSeq});" class="btn_del">
										<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
									</a>
									<button type="button" onclick="viewer.showFileContents('${serverName}/tradeSOS/exp/expertFileDownload.do?fileId=${item.fileId}&fileSeq=${item.fileSeq}', '${item.orgFileNm}', 'membershipconsult_${profile}_${item.fileId}_${item.fileSeq}');" class="file_preview btn_tbl_border">
										<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
									</button>
								</div>
							</c:forEach>
							<input type="hidden" id="fileId" name="fileId" value="${fileList[0].fileId}" />
						</c:if>
						<div class="add_line">
							<div class="form_file" style="width: 700px;">
								<p class="file_name">첨부파일을 선택하세요</p>
								<label class="file_btn">
									<input type="file" id="param_file" name="param_file" class="form_text" />
									<input type="hidden" id="fileSeq" name="fileSeq" />
									<span class="btn_tbl">찾아보기</span>
								</label>
								<button type="button" onclick="addLine(this);" class="btn_tbl_border">추가</button>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- 팝업 버튼 -->
	<div class="btn_group mt-20 _center">
		<c:choose>
			<c:when test="${result.statusCd eq '04'}">
				<button type="button" id="btnConsultLogRegist" onclick="doRegistConsultLog();" class="btn btn_primary btn_modify_auth">일지 수정</button>
			</c:when>
			<c:otherwise>
				<button type="button" id="btnConsultLogTemp" onclick="doTempConsultLog()" class="btn btn_primary btn_modify_auth" style="background-color: #9c9c9c;">임시 등록</button>
				<button type="button" id="btnConsultLogRegist" onclick="doRegistConsultLog();" class="btn btn_primary btn_modify_auth">일지 등록</button>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		$('#consultLog').on('change', function(){
			if ($(this).val() != '' && $(this).val().length > 2000) {
				alert('내용을 2,000자 이하로 입력해 주세요.');
				
				$(this).val($(this).val().substring(0, 2000));
			}
		}).on('keypress', function(){
			if ($(this).val() != '' && $(this).val().length >= 2000) {
				alert('내용을 2,000자 이하로 입력해 주세요.');
				
				return false;
			}
		});

		$('#law').on('change', function(){
			if ($(this).val() != '' && $(this).val().length > 500) {
				alert('법률을 500 이하로 입력해 주세요.');
				
				$(this).val($(this).val().substring(0, 500));
			}
		}).on('keypress', function(){
			if ($(this).val() != '' && $(this).val().length >= 500) {
				alert('법률을 500자 이하로 입력해 주세요.');
				
				return false;
			}
		});

		$('#lawClause').on('change', function() {
			if ($(this).val() != '' && $(this).val().length > 500) {
				alert('조항을 500 이하로 입력해 주세요.');
				
				$(this).val($(this).val().substring(0, 500));
			}
		}).on('keypress', function(){
			if ($(this).val() != '' && $(this).val().length >= 500) {
				alert('조항을 500자 이하로 입력해 주세요.');
				
				return false;
			}
		});

		$('#dscr').on('change', function(){
			if ($(this).val() != '' && $(this).val().length > 500) {
				alert('기타참고사항을 500 이하로 입력해 주세요.');
				
				$(this).val($(this).val().substring(0, 500));
			}
		}).on('keypress', function(){
			if ($(this).val() != '' && $(this).val().length >= 500) {
				alert('기타참고사항을 500자 이하로 입력해 주세요.');
				
				return false;
			}
		});
	});

	function doRegistConsultLog() {
		global.ajaxSubmit($('#popupLogForm'), {
			type : 'POST'
			, url : '<c:url value="/tradeSOS/exp/registerExpertPrvtConsultLog.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if (data.result) {
					<c:choose>
						<c:when test="${result.statusCd eq '04'}">
							alert('일지를 수정하였습니다.');
						</c:when>
						<c:otherwise>
							alert('일지를 등록하였습니다.');
						</c:otherwise>
					</c:choose>
					
					layerPopupCallback();	
				} else {
					alert(data.message);	
				}
	        }
		});
	}
	
	// 임시 등록
	function doTempConsultLog() {
		global.ajaxSubmit($('#popupLogForm'), {
			type : 'POST'
			, url : '<c:url value="/tradeSOS/exp/tempExpertPrvtConsultLog.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				if (data.result) {
					alert('임시 등록하였습니다.');
					
					layerPopupCallback();	
				} else {
					alert(data.message);	
				}
	        }
		});
	}
	
	// 첨부파일 추가
	var childFileCnt = 1;
	function addLine(obj) {
		var addInput = $(obj).closest('#attachFieldList');
		if (childFileCnt > 0){
			childFileCnt ++;
		}
		childFileCnt = childFileCnt;
		addInput.append(
			'<div class="add_line">'	
			+ '	<div class="form_file" style="width: 700px;">'
			+ '		<p class="file_name">첨부파일을 선택하세요</p>'	
			+ '		<label class="file_btn">'
			+ '			<input type="file" id="param_file' + childFileCnt+ '" name="param_file' + childFileCnt+ '" class="form_text" />'
			+ '			<input type="hidden" id="fileSeq' + childFileCnt+ '" name="fileSeq' + childFileCnt+ '" />'
			+ '			<span class="btn_tbl">찾아보기</span>'
			+ '		</label>'
			+ '		<button type="button" onclick="deleteRow(this);" class="btn_tbl_border">삭제</button>'
			+ '	</div>'
			+ '</div>'
		);
	}
	
	function deleteRow(obj) {
		var clickedRow = $(obj).closest('.add_line');
		clickedRow.remove();
	}
	
	function deleteExpertFile(obj, fileId, fileSeq) {
		if (confirm('선택한 파일을 삭제하겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tradeSOS/exp/deleteExpertFile.do" />'
				, data : {
					fileId : fileId
					, fileSeq : fileSeq
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					alert('해당 파일을 삭제하겠습니다.');
					
					var clickedRow = $(obj).closest('.addedFile');
					clickedRow.remove();
				}
			});
		}
	}
</script>