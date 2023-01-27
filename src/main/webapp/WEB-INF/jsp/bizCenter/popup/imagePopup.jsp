<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="loading_wrapper" class="loading_wrapper" style="display: none;">
		<img src="/images/common/loading.gif" class="loading_image">
</div>

<div class="flex">
	<h2 class="popup_title">사진 등록</h2>
	<div class="ml-auto">
		<button type="button" onclick="fnSubmit()" class="btn_sm btn_primary bnt_modify_auth">저장</a>
	</div>
	<div class="ml-15">
		<button type="button" onclick="closeLayerPopup()" 	class="btn_sm btn_secondary">닫기</a>
	</div>
</div>

<form name="submitForm" id="submitForm" method="post" enctype="multipart/form-data" >
<input type="hidden" id="fileId" name="fileId" value="<c:out value="${bizCenterSeq}"/>">
<input type="hidden" id="regStatus" name="regStatus" value="<c:if test="${empty fileList}"><c:out value="NEW"/></c:if>">
<input type="hidden" id="topHeight" name="topHeight" value="0" />
<input type="hidden" id="mainYn" name="mainYn"  />


<div class="popup_body">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
		</colgroup>
		<tr>
			<th>회의실</th>
			<td>
				<c:forEach var="data" items="${resultList}" varStatus="status">
					<c:if test="${status.index eq 0 and data.location eq 0 }"> 트레이트 타워 / <c:out value="${data.roomNumber}"/> </c:if>
					<c:if test="${status.index eq 0 and data.location eq 1 }"> 코엑스 / <c:out value="${data.roomNumber}" /> </c:if>
				</c:forEach>
				<div id="photoBox"></div>
			</td>
		</tr>
		<c:if test="${not empty fileList}">
		<tr>
			<th>회의실 사진</th>
			<td>
				<c:forEach var="fileResult" items="${fileList}" varStatus="status">
					<div class="addedFile" id="file_<c:out value="${fileResult.fileId }" />_<c:out value="${fileResult.fileSeq }" />" >

						<c:if test="${fileResult.mainYn eq 'Y' }">
							<button type="button" id="mainYn_<c:out value="${fileResult.fileId }" />_<c:out value="${fileResult.fileSeq }"/>" name="mainYn_<c:out value="${fileResult.fileId }" />_<c:out value="${fileResult.fileSeq}" />" style="margin-right: 5px;" class="btn_sm btn_primary">대표</button>
						</c:if>
						<c:if test="${fileResult.mainYn ne 'Y' }">
							<button type="button" id="mainYn_<c:out value="${fileResult.fileId }"/>_<c:out value="${fileResult.fileSeq }"/>" name="mainYn_<c:out value="${fileResult.fileId }" />_<c:out value="${fileResult.fileSeq}" />" style="margin-right: 5px;" class="btn_sm btn_secondary">대표</button>
						</c:if>

						<a href="javascript:doDownloadFile('<c:out value="${fileResult.fileId }"/>', '<c:out value="${fileResult.fileSeq}"/>');" >
							<img src="<c:url value='/images/icon/icon_file.gif' />" alt="첨부파일" /> <c:out value="${fileResult.fileNm}" />
						</a>
						<a href="javascript:doDeleteFile('<c:out value="${fileResult.fileId }"/>', '<c:out value="${fileResult.fileSeq}"/>');">
							<img src="<c:url value="/images/icon/icon_close.gif" />" alt="" />
						</a>
					</div>
				</c:forEach>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>첨부파일</th>
			<td >
				<div class="mb5px flex">
					<div class="form_file">
						<p class="file_name">첨부파일을 선택하세요</p>
						<label class="file_btn">
							<input type="file" id="attachFile" name="attachFile" class="txt attachment"  title="첨부파일" accept="image/*" />
							<input type="hidden" name="attachFileSeq" value="1" />
							<span class="btn_tbl">찾아보기</span>
						</label>
					</div>
					<button type="button" onclick="doAddAttachField('<c:out value="${bizCenterSeq}"/>');" class="btn_tbl_border">추가</button>
				</div>
				<div id="attachFieldEdit"></div>
			</td>
		</tr>
	</table>
</div>
</form>

<form name="fileForm" id="fileForm" method="post" >
	<input type="hidden" id="fileId" name="fileId" />
	<input type="hidden" id="fileSeq" name="fileSeq" />
</form>

<script type="text/javascript">
	// 레이어팝 업업 크기조정
	$(".modal-content").css("height", "auto");
	$(".modal-content").css("max-width", "50%");
	// 로딩 이미지 위치
	$(".loading_image").css({top: "-50%", left: "30%" });


	$(document).ready(function(){

		$("button[id^=mainYn_]").each(function(index, item) {
			var firstId = $(this).attr("id");
			if($(this).hasClass("btn_primary")) {
				$("#mainYn").val(firstId);
			}
		});

		// 미리보기 이미지 닫기 사용 안함
		$('#photoBox').on("click",function(){
			$('#photoBox').empty();
	    });

		var fileForm = document.frmFile;
		jQuery.ajaxSetup({cache:false});

		// 파일첨부 클릭시 로딩
		$('input[name=attachFile]').on('click' , function(){
			$("#loading_wrapper").show();
			initialize();
		});

		// 파일첨부 선택 후
		$('input[name=attachFile]').change(function() {
			var fileName = $(this).val();
			fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
			$('#fileTxt').val(fileName);
			initialize();
		});


		$("button[id^=mainYn_]").click(function() {
			var selectId = $(this).attr("id");
			var buttonCnt =   $("button[id^=mainYn_]").length;

			if ( buttonCnt > 1){
			    if($(this).hasClass("btn_primary")) {
			        $(this).addClass("btn_secondary").removeClass("btn_primary");
			    } else {
			        $(this).addClass("btn_primary").removeClass("btn_secondary");
			    }

				$("button[id^=mainYn_]").each(function(index, item) {
					var compId = $(this).attr("id");
					if ( selectId == compId){
						$(this).addClass("btn_primary").removeClass("btn_secondary");
					}else{
						$(this).addClass("btn_secondary").removeClass("btn_primary");
					}
				});
			}else{
				alert("하나의 대표이미지는 필수 입니다.");
				return false;
			}

			$("#mainYn").val(selectId);
		});

	});

	function chkLoading() {
		$("#loading_wrapper").show();
		initialize();
	}

	function initialize(event) {
	    document.body.onfocus = checkIt;
	}

	function checkIt() {
	  document.body.onfocus = null;
	  $("#loading_wrapper").hide();
	}

	// 업로드 시 미리보기 사용안함
	 function addFile(event) {
		 	$('#photoBox').empty();
		 	$('#attachFile').empty();
		 	var file = event.target.files[0];
			var reader = new FileReader();
			reader.readAsDataURL(file);

			reader.onload = function(e) {
				var img = document.createElement("img");
				img.setAttribute("src", e.target.result);
				img.setAttribute("style", "width: 100px;height: 100px;");
				$('#photoBox').append(img);
				e.target.value = "";
			};
	}

		// 첨부파일 필드 추가
		function doAddAttachField(fileId) {
			var attachCnt = 0;
			var preH = 0;
			var changeH = 0;
			var topSize=0;

			$('input[name="attachFileSeq"]').each(function(){
				attachCnt = $(this).val();
			});

			var attachFileSeq = parseInt(attachCnt) + 1;

			var html = '';
			html += '<div id="addFile_'+fileId+'_'+attachFileSeq+'" class="mb5px flex mt-5" >';
			html += '	<div class="form_file">';
			html += '		<p class="file_name">첨부파일을 선택하세요</p>';
			html += '		<label class="file_btn" onclick="chkLoading()">';
			html += '			<input type="file" name="attachFile" class="txt" title="첨부파일" accept="image/*" />';
			html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
			html += '			<span class="btn_tbl" >찾아보기</span>';
			html += '		</label>';
			html += '	</div>';
			html += '	<button type="button" onclick="doDeleteAttachField(\''+fileId+'\',\''+attachFileSeq+'\');" class="btn_tbl_border">삭제</button>';
			html += '</div>';

			var nowTop = parseInt($('.loading_image ').css("top"));

			if ($("#topHeight").val().length > 1){
				topSize += parseInt($("#topHeight").val()) + 10;
				changeH = topSize+"%"
				$("#topHeight").val(topSize);
			}else{
				preH = (nowTop+10);
				changeH = preH+"%";
				$("#topHeight").val(preH);
			}

			$('.loading_image').css("top", changeH );

			$('#attachFieldEdit').append(html);
		}

		// 추가 첨부파일 input 필드 삭제
		function doDeleteAttachField(fileId,attachFileSeq) {
			$('#addFile_'+fileId+'_'+attachFileSeq).remove();
		}

		//파일 다운로드
		function doDownloadFile(fileId , fileSeq ) {
			var f;
			f = document.fileForm;
			f.action = '<c:url value="/bizCenter/management/bizCenterFileDownload.do" />'
			f.fileId.value = fileId;
			f.fileSeq.value = fileSeq;
			f.target = '_self';
			f.submit();
		}

		// 파일 삭제
		function doDeleteFile(fileId, fileSeq) {
			var chkMain =  "mainYn_"+fileId+"_"+fileSeq;

			if ( $("#mainYn").val() ==  chkMain ){
				alert("대표 이미지를 변경후 삭제해주세요.");
				return false;
			}else{
				if (confirm('해당 파일을 삭제하시겠습니까?')) {
					global.ajax({
						type : 'POST'
						, url : '<c:url value="/bizCenter/management/bizCenterFileDelete.do" />'
						, data : {
							fileId :fileId
							, fileSeq : fileSeq
						}
						, dataType : 'json'
						, async : true
						, spinner : true
						, success : function(data){
							layerPopupCallback("delete");
						}
					});
				}
			}
		}

	// 저장

	function fnSubmit(){

		if ( $("tbody").hasClass("addedFile") == true) {
			if ( $('#mainYn').val() == null ||  $('#mainYn').val() == "" ) {
				alert("대표 이미지를 선택해주세요.");
				return false;
			}
		}

		global.ajaxSubmit($('#submitForm'), {
			type : 'POST'
			, url : '<c:url value="/bizCenter/management/imageProc.do" />'
			, enctype : 'multipart/form-data'
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){
				layerPopupCallback(data);
			}
		});
	}
</script>