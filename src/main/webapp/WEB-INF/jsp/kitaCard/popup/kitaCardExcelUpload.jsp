<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<form action="" id="form" name="form" method="post">
	<input type="hidden" id="uploadType" name="uploadType" value='<c:out value="${uploadType}"/>' />
	<div class="flex">
		<h3 class="popup_title">엑셀양식 업로드</h3>
		<div class="ml-auto">
			<c:if test="${uploadType eq 'issue'}">
				<button type="button" class="btn_sm btn_primary" onclick="doUploadExcelDownload();">업로드용 엑셀 다운</button>
			</c:if>
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>
	<div class="form_file">
		<p class="file_name">업로드 하고자 하는 엑셀 파일을 첨부해주세요.</p>
		<label class="file_btn">
			<input type="file" id="excelFile" name="excelFile" accept=".xls,.xlsx" />
			<span class="btn_tbl">찾아보기</span>
		</label>
	</div>

	<div class="btn_group mt-20 _center">
		<button type="button" class="btn btn_primary" onclick="doExcelUpload();">저장</a>
		<!-- <button type="button" class="btn btn_secondary" onclick="closeLayerPopup();">닫기</a> -->
	</div>
</form>


<script type="text/javascript">

	//레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function uploadfile_check(f2) {
		var  str_dotlocation,str_ext,str_low;
		str_value  = f2;

		str_low   = str_value.toLowerCase(str_value);
		str_dotlocation = str_low.lastIndexOf(".");
		str_ext   = str_low.substring(str_dotlocation+1);

	    switch (str_ext) {
			case "xlsx" :
				return true;
				break;
			case "xls" :
				return true;
				break;
			default:
				alert("엑셀 파일 양식에 맞지 않는 파일입니다.");
				return false;
		}
	}

	function doUploadExcelDownload() {
		$('#searchForm').attr('action','/kitaCard/kitaCardUploadFormExcelDown.do');
		$('#searchForm').submit();
	}

	function doExcelUpload(){
		var f = document.form;
		if(f.excelFile.value==""){
			alert("업로드 할 파일을 지정해 주세요");
			return;
		}

		// 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
		var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

		f2=f.excelFile.value;

		if(uploadfile_check(f2)){
			if(confirm('업로드 하시겠습니까?')){
				$("#form").ajaxSubmit({
					asyn: true,
					type: 'POST',
					dataType:"json",
					url:  '/kitaCard/saveExcelUpload.do',
					success : function(data) {
						if(data.status == 'false') {
							alert(data.msg);
							closeLayerPopup();
						} else {
							alert(data.msg);
							config.callbackFunction(data.status);
		            		closeLayerPopup();
						}
					}
				});
			}
		}
	}

</script>