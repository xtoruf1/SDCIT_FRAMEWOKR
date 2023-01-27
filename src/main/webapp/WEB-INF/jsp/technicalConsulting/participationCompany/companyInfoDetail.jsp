<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="location">
    <!-- 네비게이션 -->
    <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
    <!-- 네비게이션 -->
    <div class="ml-auto">
        <button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="fn_save();">저장</button>
        <button type="button" class="btn_sm btn_primary btn_modify_auth" onclick="indvdQRRsend();">개별QR발송</button>
    </div>
    <div class="ml-15">
        <button type="button" class="btn_sm btn_secondary" onclick="fn_list();">목록</button>
    </div>
</div>

<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
	<input type="hidden" name="searchKeyword" value="<c:out value="${searchVO.searchKeyword}"/>"/>
	<input type="hidden" name="devCfrcId" value="<c:out value="${searchVO.devCfrcId}"/>"/>
	<input type="hidden" name="companyName" value="<c:out value="${searchVO.companyName}"/>"/>
	<input type="hidden" name="businessNo" value="<c:out value="${searchVO.businessNo}"/>"/>
	<input type="hidden" name="ceoName" value="<c:out value="${searchVO.ceoName}"/>"/>
	<input type="hidden" name="searchKeyword2" value="<c:out value="${searchVO.searchKeyword2}"/>"/>
	<input type="hidden" name="searchCondition" value="<c:out value="${searchVO.searchCondition}"/>"/>
</form>

<div class="page_voucher">
    <form id="participationForm" name="participationForm" method="post">
        <input type="hidden" id="applId" name="applId" value="<c:out value="${companyInfo.applId}"/>"/>
        <input type="hidden" id="devCfrcId" name="devCfrcId" value="<c:out value="${companyInfo.devCfrcId}"/>"/>
        <input type="hidden" id="businessNo" name="businessNo" value="<c:out value="${companyInfo.businessNo}"/>"/>
        <input type="hidden" name="cnfCnt" value="<c:out value="${companyInfo.cnfCnt}"/>"/>               <%-- 참가_확정_수 --%>
        <input type="hidden" name="qrYn" value="<c:out value="${companyInfo.qrYn}"/>"/>                   <%-- QR코드 전송 여부 --%>
        <div class="cont_block">
            <div class="tabGroup">
                <div class="tab_header">
                    <button type="button" id="infoTab" class="tab on">기본정보</button>
                    <button type="button" id="resultTab" class="tab">상담일지</button>
                </div>
                <div class="tab_body">
                    <div id="infoTabCnt" class="tab_cont on">
                        <div class="cont_block">
                            <table class="formTable">
                                <colgroup>
                                    <col style="width:15%;" />
                                    <col/>
                                    <col style="width:15%;" />
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>업체명</th>
                                    <td>
                                        <c:out value="${companyInfo.companyName}"/>
                                    </td>
                                    <th>사업자등록번호</th>
                                    <td>
                                        <c:out value="${companyInfo.businessNo}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>대표자</th>
                                    <td>
                                        <c:out value="${companyInfo.ceoName}"/>
                                    </td>
                                    <th>홈페이지</th>
                                    <td>
                                        <c:out value="${companyInfo.homepage}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>설립일</th>
                                    <td>
                                       <c:out value="${companyInfo.sinceDate}"/>
                                    </td>
                                    <th>매출액</th>
                                    <td>
                                  <%--      <c:out value="${companyInfo.salesAmt}"/>--%>
                                        <fmt:formatNumber type="number" maxFractionDigits="3" value="${companyInfo.salesAmt}" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>임직원수</th>
                                    <td>
                                       <fmt:formatNumber type="number" maxFractionDigits="3" value="${companyInfo.employCount}" /> 명
                                    </td>
                                    <th>소재지</th>
                                    <td>
                                       <c:out value="${companyInfo.addressNm}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>업종</th>
                                    <td>
                                        <c:out value="${businessType}"/>
                                    </td>
                                    <th>주생산품</th>
                                    <td>
                                        <c:out value="${companyInfo.mainProduct}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>부설연구소</th>
                                    <td colspan="3">
                                        <c:out value="${companyInfo.researchYn eq 'Y' ? '있음' : '없음'}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><strong class="point">*</strong> 담당자명 / 직위</th>
                                    <td>
                                        <input type="text" class="form_text" name="chargeName" id="chargeName" maxlength="50" value="<c:out value="${companyInfo.chargeName}"/>"/>
                                        /
                                        <input type="text" class="form_text" name="chargePosition" id="chargePosition" maxlength="50" value="<c:out value="${companyInfo.chargePosition}"/>"/>
                                    </td>
                                    <th><strong class="point">*</strong> 담당자 전화</th>
                                    <td>
                                        <input type="text" class="form_text w100p" name="chargeTel" id="chargeTel" maxlength="12" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="<c:out value="${companyInfo.chargeTel}"/>"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><strong class="point">*</strong> 담당자 이메일</th>
                                    <td>
                                        <input type="text" class="form_text w100p" name="chargeEmail" id="chargeEmail" maxlength="50" value="<c:out value="${companyInfo.chargeEmail}"/>"/>
                                    </td>
                                    <th><strong class="point">*</strong> 담당자 휴대전화</th>
                                    <td>
                                        <input type="text" class="form_text w100p" name="chargePhone" id="chargePhone" maxlength="12" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="<c:out value="${companyInfo.chargePhone}"/>"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>신청일시</th>
                                    <td>
                                        <c:out value="${companyInfo.applDate}"/>
                                    </td>
                                    <th><strong class="point">*</strong> 신청상태</th>
                                    <td>
                                        <select name="statusCd" id="statusCd" class="form_select w50p">
                                            <option value="N" <c:if test="${'N' eq companyInfo.statusCd}">selected="selected"</c:if>>접수</option>
                                            <option value="Y" <c:if test="${'Y' eq companyInfo.statusCd}">selected="selected"</c:if>>선정</option>
                                            <option value="F" <c:if test="${'F' eq companyInfo.statusCd}">selected="selected"</c:if>>미선정</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><strong class="point">*</strong> 상담상태</th>
                                    <td>
                                        <select name="resultCd" id="resultCd" class="form_select w50p">
                                            <option value="N" <c:if test="${'N' eq companyInfo.resultCd}">selected="selected"</c:if>>상담전</option>
                                            <option value="C" <c:if test="${'C' eq companyInfo.resultCd}">selected="selected"</c:if>>상담완료</option>
                                            <option value="F" <c:if test="${'F' eq companyInfo.resultCd}">selected="selected"</c:if>>후속상담</option>
                                        </select>
                                    </td>
                                    <th><strong class="point">*</strong> 참석여부</th>
                                    <td>
                                        <select name="attendYn" id="attendYn" class="form_select w50p">
                                            <option value="Y" <c:if test="${'Y' eq companyInfo.attendYn}">selected="selected"</c:if>>참석</option>
                                            <option value="N" <c:if test="${'N' eq companyInfo.attendYn}">selected="selected"</c:if>>미참석</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주의</th>
                                    <td colspan="3">
                                        <input type="checkbox" class="form_checkbox normalCheck" id="ctnCmpny" name="ctnCmpny" value="0"  <c:if test="${companyInfo.ctnCmpny eq 'O'}">checked="checked"</c:if> >
                                    </td>
                                </tr>
                                <tr>
                                    <th>메모</th>
                                    <td colspan="3">
                                        <textarea id="dscr" name="dscr" rows="5" maxlength="1300" class="form_textarea" value=""><c:out value="${companyInfo.dscr}"/></textarea>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="cont_block">
                            <!-- 타이틀 영역 -->
                            <div class="tit_bar">
                                <h3 class="tit_block">객관식 항목</h3>
                            </div>
                            <table class="formTable">
                                <c:forEach var="data" items="${questionList}" varStatus="status">
                                    <tr>
                                        <th colspan="2">
                                            <div class="flex">
                                                <p>${status.count}. ${data.questionText}</p>
                                            </div>
                                        </th>
                                    </tr>
                                    <tr>
                                        <td  colspan="2">
                                            <p class="mt-10 mb-10">
                                                <c:out value="${data.itemText}" />
                                            </p>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>

                        </div>
                        <div class="cont_block">
                            <div class="tit_bar">
                                <h3 class="tit_block">주관식 항목</h3>
                            </div>
                            <textarea  name="etcTemplate" rows="10" readonly class="form_textarea"><c:out value="${companyInfo.etcAnswer}" escapeXml="false"/></textarea>
                        </div>
                        <div class="cont_block">
                            <div class="tit_bar">
                                <h3 class="tit_block">다른 상담회 신청이력</h3>
                            </div>
                            <div>
                                <div id="otherHistorySheet" class="sheet"></div>
                            </div>
                        </div>
                    </div>

                    <div id="resultCnt" class="tab_cont">
                       <table class="formTable">
                            <colgroup>
                                <col style="width:15%;" />
                                <col/>
                                <col style="width:15%;" />
                                <col/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>상담일자</th>
                                    <td colspan="3">
                                        <div class="datepicker_box">
                                            <span class="form_datepicker">
                                                <input type="text" name="consultDate" id="consultDate" class="txt datepicker" title="접수시작일" readonly="readonly" value="<c:out value="${companyInfo.consultDate}"/>" />
                                                <img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
                                            </span>

                                            <!-- clear 버튼 -->
                                            <button class="dateClear" type="button" onclick="clearPickerValue('consultDate')"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상담결과 및 향후 계획</th>
                                    <td colspan="3">
                                        <textarea id="resultText" name="resultText" maxlength="1300" rows="5" class="form_textarea" value=""><c:out value="${companyInfo.resultText}"/></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th>만족한점</th>
                                    <td colspan="3">
                                        <textarea id="satisfyText" name="satisfyText" maxlength="1300" rows="5" class="form_textarea" value=""><c:out value="${companyInfo.satisfyText}"/></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th>개선할점</th>
                                    <td colspan="3">
                                        <textarea id="improveText" name="improveText" maxlength="1300" rows="5" class="form_textarea" value=""><c:out value="${companyInfo.improveText}"/></textarea>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script type="text/javascript">

    var addChk = "";

    $(document).ready(function(){
        var pAmt = $('#salesAmt').val();
        $('#salesAmt').val(global.formatCurrency(pAmt));        //매출액 숫자 포맷
        setSheetHeaderOtherHistorySheet();	// 리스트 헤더
        getOtherList();					    // 다른 상담회 신청이력 조회


       //선정상태에 따른 변경
       if ($("select[name=statusCd] option:selected").val() != 'Y') {
            $("select[name=resultCd]").attr("disabled", true);
            $("select[name=attendYn]").attr("disabled", true);
        }


        $("select[name=statusCd]").on("change",function() {
            if ($("select[name=statusCd] option:selected").val() == "Y") {
                $("#resultCd").removeAttr("disabled");
                $("#attendYn").removeAttr("disabled");

            } else {
                $("select[name=resultCd]").attr("disabled", true);
                $("select[name=attendYn]").attr("disabled", true);
            }
        });

    });

    function setSheetHeaderOtherHistorySheet() {	// 헤더

        var	ibHeader = new IBHeader();
        ibHeader.addHeader({Type: "Text"    , Header: "applId"      , SaveName: "applId"             , Hidden:true});
        ibHeader.addHeader({Type: "Text"    , Header: "No"          , SaveName: "vnum"               , Align: "Center" ,  Width: 50});
        ibHeader.addHeader({Type: "Text"    , Header: "개최년도"      , SaveName: "cfrcStartDate"      , Align: "Center" ,  Width: 60});
        ibHeader.addHeader({Type: "Text"    , Header: "상담회명"      , SaveName: "cfrcName"           , Align: "Left"   , Width: 150      ,  Ellipsis:1});
        ibHeader.addHeader({Type: "Text"    , Header: "담당자명"      , SaveName: "chargeName"         , Align: "Center"  , Width: 80});
        ibHeader.addHeader({Type: "Text"    , Header: "신청상태"      , SaveName: "statusCd"           , Align: "Center"  , Width: 80});
        ibHeader.addHeader({Type: "Text"    , Header: "참석여부"      , SaveName: "attendYn"           , Align: "Center"  , Width: 80});
        ibHeader.addHeader({Type: "Text"    , Header: "상담상태"      , SaveName: "resultCd"           , Align: "Center"  , Width: 80});
        ibHeader.addHeader({Type: "Text"    , Header: "일지등록"      , SaveName: "dryRgst"            , Align: "Center"  , Width: 80});
        ibHeader.addHeader({Type: "Html"    , Header: "메모"         , SaveName: "dscr"               , Align: "Center"  , Width: 80});
        ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
        ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

        var container = $('#otherHistorySheet')[0];
        createIBSheet2(container, 'otherHistorySheet', '100%', '100%');
        ibHeader.initSheet('otherHistorySheet');

        // 편집모드 OFF
        otherHistorySheet.SetEditable(0);
    }

    function goPage(pageIndex) {	// 페이징 함수
        $('#pageIndex').val(pageIndex);
        getOtherList();
    }

    function doSearch() {
        $('#pageIndex').val(1);
        getOtherList();
    }

    function chgPageCnt() {
        doSearch();
    }

    /**
     * 목록 가기
     */
    function fn_list() {
        $('#searchForm').attr('action', '/participationCompany/technicalConsultingList.do');
        $('#searchForm').submit();

    }

    function otherHistorySheet_OnSearchEnd() {
        // 제목에 볼드 처리
        otherHistorySheet.SetColFontBold('cfrcName', 1);

        var businessNo = $("#businessNo").val(); // 사업자번호
        var dscr = "";
        var applId = $("#applId").val();
        var btn = '<img src="<c:url value="/images/admin/ico_btn_apply.png" />" alt="메모" style="width: 30px;"/>'
        var html = '<button type="button"onclick="goMemo(' + applId +',' + businessNo + ')">'+btn+'</button>';

        for (var i = 1; i <= otherHistorySheet.RowCount(); i++ ){
            // 주의 업체 이미지 표시
            dscr = otherHistorySheet.CellSearchValue(i,'dscr');          // 메모
            // 메모 팝업
            if((dscr != null) && (dscr != "")){
                otherHistorySheet.SetCellValue(i,'dscr',html);
            }
        }
    }

    /**
     * 메모 클릭시
     * @param applId
     * @param businessNo
     */
    function goMemo(applId,businessNo) {
        global.openLayerPopup({
            popupUrl : '/participationCompany/technicalConsultingDscrPop.do?businessNo='+businessNo
            , param : applId
        });
    }

    /**
     * 다른 상담회 신청이력 조회
     */
    function getOtherList() {
        global.ajax({
            url: '/participationCompany/otherTechnicalConsultingListAjax.do',
            dataType: 'json',
            type: 'POST',
            data: $('#participationForm').serialize(),
            success: function (data) {
                otherHistorySheet.LoadSearchData({Data: data.resultList});

            },
            error:function(request,status,error) {
                alert('신청이력 조회에 실패했습니다.');
            }
        });
    }

    /**
     * 상담회 신청이력 클릭이벤트
     * @param Row
     * @param Col
     * @param Value
     */
    function otherHistorySheet_OnClick(Row, Col, Value) {
        if(otherHistorySheet.ColSaveName(Col) == "cfrcName" && Row > 0) {
            var applId = otherHistorySheet.GetCellValue(Row, "applId");
            fn_detail(applId);
        }
    };

    /**
     * 상담회 신청이력 상세
     * @param applId
     */
    function fn_detail( applId) {
        $("#applId").val( applId);

        document.participationForm.action = '<c:url value="/participationCompany/companyInfoDetail.do" />';
        document.participationForm.target = '_block';
        document.participationForm.submit();
    }

    /**
     * 참가신청업체 저장 프로세스
     */
    var submitFlag = true;
    function fn_save() {
        var form = document.participationForm;

        //chargeName 담당자명   chargePosition 직위  chargeTel 전화 chargeEmail 이메일  chargePhone 휴대전화

        if ($("input[name=chargeName]").val().trim() == ""){
            alert("담당자명을 입력해주세요.");
            $("input[name=chargeName]").focus();
            return;
        }

        if (fc_chk_byte2(form.chargeName, 100, "담당자명은") == false){
            return;
        }

        if ($("input[name=chargePosition]").val().trim() == ""){
            alert("직위를 입력해주세요.");
            $("input[name=chargePosition]").focus();
            return;
        }

        if (fc_chk_byte2(form.chargePosition, 100, "직위는") == false) {
            return;
        }

        if ($("input[name=chargeTel]").val().trim() == ""){
            alert("담당자 전화를 입력해주세요.");
            $("input[name=chargeTel]").focus();
            return;
        }

        if ($("input[name=chargePhone]").val().trim() == ""){
            alert("담당자 휴대전화를 입력해주세요.");
            $("input[name=applyTel]").focus();
            return;
        }

        if ($("input[name=chargeEmail]").val().trim() == ""){
            alert("담당자 이메일을 입력해주세요.");
            $("input[name=chargeEmail]").focus();
            return;
        }

        if(!checkEmail($("input[name=chargeEmail]").val().trim())){
            alert("이메일을 형식에 맞게 입력해 주세요.");
            $("input[name=chargeEmail]").focus();
            return;
        }else{
            $("input[name=chargeEmail]").val($("input[name=chargeEmail]").val().trim());
        }

        if (confirm('저장 하시겠습니까?')) {
            if (submitFlag) {
			submitFlag = false;

				global.ajax({
					type: 'POST'
						, url: '<c:url value="/participationCompany/companyInfoSave.do" />'
					, data: $('#participationForm').serialize()
					, dataType: 'json'
					, async: true
					, spinner: true
					, success: function (data) {
						window.location.reload(true);
					}
				});
			}
		}
    }

    /**
     * QR 재발급
     */
    function indvdQRRsend() {
    	if( '<c:out value="${companyInfo.allQrYn}"/>' != 'Y' ){
    		alert('아직 전체 QR이 발급되지 않았습니다.\n[상담회관리]에서 QR발급 후 개별QR발급이 가능합니다.');
    		return false;
    	}
        var qrYn = $('input[name=qrYn]').val();
		var cnfCnt = $('input[name=cnfCnt]').val();
		var statusCd = $("select[name=statusCd] option:selected").val();
        var msg = "";

        if( statusCd != 'Y') {
            alert("선정된 업체가 아닙니다.");
			return false;
        }

		if( cnfCnt == 0) {  // 참석 확정자가 있을때(Y)
			alert("참석 확정된 인원이 없습니다.");
			return false;
        }

        if(qrYn == 'Y') { //전송한 이력 체크
            msg = "QR코드 발급한 이력이 있습니다. 다시 발급하시겠습니까?";
        } else {
            msg = "QR코드를 발급 하시겠습니까?";
        }

		if (confirm(msg)) {
			$('#loading_image').show(); // 로딩이미지 시작
			global.ajax({
				type: 'POST'
					, url: '<c:url value="/participationCompany/companyInfoSave.do" />'
				, data: $('#participationForm').serialize()
				, dataType: 'json'
				, async: true
				, spinner: true
				, success: function (data) {
					sendQrCode();
				}
			});
		}

    }

    function sendQrCode(){
    	global.ajax({
            type: 'POST'
            , url: '<c:url value="/participationCompany/companyInfoQrCodeReSend.do" />'
            , data: $('#participationForm').serialize()
            , dataType: 'json'
            , async: true
            , spinner: true
            , success: function (data) {
                $('#loading_image').hide(); // 로딩이미지 종료
                alert(data.MESSAGE);
                window.location.reload(true);
            }
        });
    }

    function fnPhoneValidation(value) {
		if (/^[0-9]{2,3}[0-9]{3,4}[0-9]{4}/.test(value)) {
			return true;
		}
		return false;
	}
</script>