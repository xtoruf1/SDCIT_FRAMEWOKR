<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<form id="form" name="form" method="post">
    <input type="hidden" id="uploadType" name="uploadType" value="<c:out value="${uploadType}"/>" />
    <div class="flex">
        <h3 class="popup_title">엑셀 양식 업로드</h3>
        <div class="ml-auto">
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
    <div>
       <br>
       <p>
            1. 신청상태 / 상담상태만 업로드 가능합니다.<br>
           <br>
            2. 상태값<br>
             -  신청상태 : 접수 / 선정 / 미선정<br>
             -  상담상태 : 상담전 / 후속상담 / 상담완료<br>
           <br>
            <strong class="point">*</strong> 상태값은 위와 같이 입력해주세요.<br>
        </p>
    </div>
    <div class="btn_group mt-20 _center">
        <button type="button" onclick="doExcelUpload();" class="btn btn_primary">저장</button>
    </div>
</form>
<script type="text/javascript">
    function uploadFileCheck(f2) {
        var str_dotlocation, str_ext, str_low;
        str_value = f2;

        str_low = str_value.toLowerCase(str_value);
        str_dotlocation = str_low.lastIndexOf('.');
        str_ext = str_low.substring(str_dotlocation + 1);

        switch (str_ext) {
            case 'xlsx' :
                return true;

                break;
            case 'xls' :
                return true;

                break;
            default:
                alert('엑셀 파일 양식에 맞지 않는 파일입니다.');

                return false;
        }
    }

    function doExcelUpload() {
        var f = document.form;
        if (f.excelFile.value == ''){
            alert('업로드 할 파일을 지정해 주세요.');

            return;
        }

        // 레이어 팝업 셋팅 목록에서 timestamp로 내림차순 중 첫번째 요소를 가져온다.
        var config = sortFirstObject(popupConfig, 'desc', 'timestamp');

        f2 = f.excelFile.value;

        if (uploadFileCheck(f2)) {
            if (confirm('업로드 하시겠습니까?')) {
                $('#form').ajaxSubmit({
                    asyn : true
                    , type : 'POST'
                    , dataType : 'json'
                    , url :  '<c:url value="/participationCompany/saveExcelUpload.do" />'
                    , success : function(data){
                        if (data.status == '') {
                            alert('등록에 실패 하였습니다.');

                            closeLayerPopup();
                        } else {
                            var excelRow = data.status.split('&')[1];
                            var excelCell = data.status.split('&')[2];
                            var excelCellName = data.status.split('&')[3];

                            if (data.status == '0000') {
                                alert('정상 등록 되었습니다.');

                                config.callbackFunction(data.status);

                                closeLayerPopup();
                            } else if (data.status.split('&')[0] == '9004') {
                                alert('엑셀 형식이 잘못되었습니다.');

                                closeLayerPopup();
                            } else if (data.status.split('&')[0]  == '9000') {
                                alert(excelRow + '번째 Row에 ' + excelCell + '번째 Cell의 ' + '"' + excelCellName + '"' + ' 가 없습니다.');

                                closeLayerPopup();
                            } else if (data.status == '9999') {
                                alert('시스템 에러가 발생하였습니다. 잠시 후 다시 시도해 주세요.');

                                closeLayerPopup();
                            }
                        }
                    }
                });
            }
        }
    }
</script>