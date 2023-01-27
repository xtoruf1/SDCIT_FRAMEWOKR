<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 페이지 위치 -->
<div class="location compact">
    <!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

    <div class="ml-auto">
        <button type="button" class="btn_sm btn_primary" onclick="doFileUpload();">엑셀 업로드</button>
        <button type="button" class="btn_sm btn_secondary" onclick="doInit();">초기화</button>
        <button type="button" class="btn_sm btn_primary" onclick="doSearch();">검색</button>
    </div>
</div>

<!-- 참가 신청 업체 리스트 -->
<div class="page_tradesos">

    <form name="searchForm" id="searchForm" method="get" onsubmit="return false;">
		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
        <input type="hidden" name="devCfrcId" id="devCfrcId" value="<c:out value="${searchVO.devCfrcId}"/>"/>
        <input type="hidden" name="applId" id="applId" value="0"/>
        <input type="hidden" id="totalCount" name="totalCount" value="0" default='0'>
        <div class="foldingTable fold">
            <div class="foldingTable_inner">
                <table class="formTable">
                    <colgroup>
                        <col style="width:8%">
                        <col style="width:23%">
                        <col style="width:8%">
                        <col>
                        <col style="width:8%">
                        <col style="width:23%">
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">상담회</th>
                        <td>
                            <div class="field_set flex align_center">
                                <span class="form_search w100p">
                                    <input class="form_text w100p" type="text" onkeydown="onEnter(doSearch);" id="searchKeyword" name="searchKeyword" value="<c:out value="${searchVO.searchKeyword}"/>" readonly />
                                    <button type="button" class="btnSchOpt find btn_icon btn_search" onclick="openLayerEventChngPop();" title="검색"></button>
                                </span>
                            </div>
                        </td>
                       <th scope="row">업체명</th>
                        <td>
                            <input type="text" name="companyName" class="form_text w100p" onkeydown="onEnter(doSearch);"  value="<c:out value="${searchVO.companyName}"/>">
                        </td>
                        <th scope="row">사업자번호</th>
                        <td>
                            <input type="text" name="businessNo" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.businessNo}"/>">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">대표자명</th>
                        <td>
                            <input type="text" name="ceoName" class="form_text w100p" onkeydown="onEnter(doSearch);" value="<c:out value="${searchVO.ceoName}"/>">
                        </td>
                        <th scope="row">업종</th>
                        <td>
                            <select name="businessType" class="form_select w100p">
                                <option value="">전체</option>
                                <c:forEach var="data" items="${businessType}" varStatus="status">
                                    <option value="<c:out value="${data.code}"/>"><c:out value="${data.codeNm}"/></option>
                                </c:forEach>
                            </select>
                        </td>
                        <th scope="row">신청상태</th>
                        <td>
                            <select name="searchKeyword2" class="form_select w100p">
                                <option value="">전체</option>
                                <option value="N" <c:if test="${searchVO.searchKeyword2 eq 'N'}">selected</c:if>>접수</option>
                                <option value="Y" <c:if test="${searchVO.searchKeyword2 eq 'Y'}">selected</c:if>>선정</option>
                                <option value="F" <c:if test="${searchVO.searchKeyword2 eq 'F'}">selected</c:if>>미선정</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">상담상태</th>
                        <td>
                            <select name="searchCondition" class="form_select w100p">
                                <option value="">전체</option>
                                <option value="N" <c:if test="${searchVO.searchCondition eq 'N'}">selected</c:if>>상담전</option>
                                <option value="C" <c:if test="${searchVO.searchCondition eq 'C'}">selected</c:if>>상담완료</option>
                                <option value="F" <c:if test="${searchVO.searchCondition eq 'F'}">selected</c:if>>후속상담</option>
                            </select>
                        </td>
                        <th scope="row">주의여부</th>
                        <td colspan="1" class="blindCheckbox">
                   <%--         <label class="label_form">
                                <input type="checkbox" name="ctnCmpny"  value="" class="form_checkbox uniqueCheck" onchange="blindCheck(this)">
                                <span class="label">전체</span>
                            </label>--%>
                            <label class="label_form">
                                <input type="checkbox" name="ctnCmpny"  value="Y" class="form_checkbox normalCheck" onchange="blindCheck(this)">
                                <span class="label">주의</span>
                            </label>
                        </td>
                        <th scope="row">일지등록</th>
                        <td colspan="1" class="blindCheckbox">
                            <label class="label_form">
                                <input type="checkbox" name="dryRgst"  value="" class="form_checkbox uniqueCheck" onchange="blindCheck(this)">
                                <span class="label">전체</span>
                            </label>
                            <label class="label_form">
                                <input type="checkbox" name="dryRgst"  value="Y" class="form_checkbox normalCheck" onchange="blindCheck(this)">
                                <span class="label">등록</span>
                            </label>
                            <label class="label_form">
                                <input type="checkbox" name="dryRgst"  value="N" class="form_checkbox normalCheck" onchange="blindCheck(this)">
                                <span class="label">미등록</span>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">참석여부</th>
                        <td class="blindCheckbox">
                            <label class="label_form">
                                <input type="checkbox"  value="" class="form_checkbox uniqueCheck" onchange="blindCheck(this)">
                                <span class="label">전체</span>
                            </label>
                            <label class="label_form">
                                <input type="checkbox" name="attendYn"  value="Y" class="form_checkbox normalCheck" onchange="blindCheck(this)">
                                <span class="label">참석</span>
                            </label>
                            <label class="label_form">
                                <input type="checkbox" name="attendYn"  value="N" class="form_checkbox normalCheck" onchange="blindCheck(this)">
                                <span class="label">미참석</span>
                            </label>
                        </td>
                        <th scope="row">신청일자</th>
                        <td colspan="3" class="blindCheckbox">
                            <div class="group_datepicker">
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchStartDate" name="searchStartDate" value="${searchVO.searchStartDate}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 시작" title="신청기간 시작" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>
									<button type="button" onclick="setDefaultPickerValue('searchStartDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
								<div class="spacing">~</div>
								<div class="datepicker_box">
									<span class="form_datepicker">
										<input type="text" id="searchEndDate" name="searchEndDate" value="${searchVO.searchEndDate}" class="txt datepicker" style="width: 110px;" placeholder="신청기간 종료" title="신청기간 종료" readonly="readonly" />
										<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
									</span>
									<button type="button" onclick="setDefaultPickerValue('searchEndDate');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
								</div>
							</div>
                        </td>
                    </tr>
                    </tbody>
                </table><!-- // 검색 테이블-->
            </div>
            <button type="button" class="btn_folding" id="btnFolding" title="테이블접기"></button>
        </div>

        <div class="cont_block mt-20">
            <div class="tbl_opt">
                <!-- 상담내역조회 -->
                <div id="totalCnt" class="total_count"></div>
                <div class="ml-auto">
                    <button type="button" class="btn_sm btn_primary" onclick="getExcelList();">엑셀 다운</button>
                </div>
                <fieldset class="ml-15">
                    <select id="pageUnit" name="pageUnit" onchange="doSearch();" title="목록수" class="form_select">
                        <c:forEach var="item" items="${pageUnitList}" varStatus="status">
                            <option value="${item.code}" <c:if test="${param.pageUnit eq item.code}">selected="selected"</c:if>>${item.codeNm}</option>
                        </c:forEach>
                    </select>
                </fieldset>
            </div>
            <!-- 리스트 테이블 -->
            <div style="width: 100%;height: 100%;">
                <div id='companySheet' class="sheet"></div>
            </div>
            <!-- .paging-->
            <div id="paging" class="paging ibs" style="margin-top: 35px;height: 20px;"></div>
            <!-- //.paging-->
        </div>
    </form>
</div>

<script type="text/javascript">
    $(document).ready(function () {

         $( "#searchForm input" ).keypress(function( event ) {
            if ( event.which == 13 ) {
                dataList(1);
                event.preventDefault();
            }
        });

      // 시작일 선택 이벤트
 		datepickerById('searchStartDate', fromDateSelectEvent);
 		// 종료일 선택 이벤트
 		datepickerById('searchEndDate', toDateSelectEvent);


        f_Init_companySheet();  //참가신청 Sheet
        getList(); // 조회

    });

    function fromDateSelectEvent() {
		var startymd = Date.parse($('#searchStartDate').val());
		if ($('#searchEndDate').val() != '') {
			if (startymd > Date.parse($('#searchEndDate').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#searchStartDate').val('');

				return;
			}
		}
	}

	function toDateSelectEvent() {
		var endymd = Date.parse($('#searchEndDate').val());

		if ($('#searchStartDate').val() != '') {
			if (endymd < Date.parse($('#searchStartDate').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#searchEndDate').val('');

				return;
			}
		}
	}


    function f_Init_companySheet() {
        var ibHeader = new IBHeader();

        /** 리스트,헤더 옵션 */
        ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
        ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

        ibHeader.addHeader({Type: "Text"    , Header: "devCfrcId"      , SaveName: "devCfrcId"       , Hidden:true});
        ibHeader.addHeader({Type: "Text"    , Header: "applId"      , SaveName: "applId"             , Hidden:true});
        ibHeader.addHeader({Type: "Text"    , Header: "No"          , SaveName: "vnum"                , Align: "Center" ,  Width: 50 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "개최년도"      , SaveName: "cfrcStartDate"       , Align: "Center" ,  Width: 60 , Cursor:"Pointer", Hidden:true});
        ibHeader.addHeader({Type: "Text"    , Header: "상담회명"      , SaveName: "cfrcName"            , Align: "Left"   , Width: 160,  Ellipsis:1, Cursor:"Pointer", Hidden:true});
        ibHeader.addHeader({Type: "Text"    , Header: "업체명"        , SaveName: "companyName"         , Align: "Left"   , Width: 150, Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "사업자번호"     , SaveName: "businessNo"          , Align: "Center" , Width: 100 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "대표자명"       , SaveName: "ceoName"             , Align: "Center" , Width: 80 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "업종"          , SaveName: "businessType"        , Align: "Left" , Width: 150 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "신청일"       , SaveName: "applDate"           	, Align: "Center"  , Width: 80 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "신청상태"       , SaveName: "statusCd"           , Align: "Center"  , Width: 80 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "발송여부"       , SaveName: "sendYn"           	, Align: "Center"  , Width: 80 , Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "참석여부"       , SaveName: "attendYn"           , Align: "Center"  , Width: 80, Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "상담상태"       , SaveName: "resultCd"           , Align: "Center"  , Width: 80, Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Text"    , Header: "일지등록"       , SaveName: "dryRgst"            , Align: "Center"  , Width: 80, Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Html"    , Header: "주의"          , SaveName: "ctnCmpny"           , Align: "Center"  , Width: 34, Cursor:"Pointer"});
        ibHeader.addHeader({Type: "Html"    , Header: "메모"          , SaveName: "dscr"               , Align: "Center"  , Width: 60,  Cursor:"Pointer"});

        var sheetId = "companySheet";
        var container = $("#"+sheetId)[0];
        createIBSheet2(container, sheetId, "100%", "100%");
        ibHeader.initSheet(sheetId);
        // 편집모드 OFF
        companySheet.SetEditable(0);
        companySheet.ShowToolTip(0);

    };

    function companySheet_OnRowSearchEnd(row) {
        // 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
        notEditableCellColor('companySheet', row);
    }

    function doSearch() {
        goPage(1);
    }

    function goPage(pageIndex) {
        document.searchForm.pageIndex.value = pageIndex;
        getList();
    }

    // 검색
    function getList(){
        global.ajax({
            url: '/participationCompany/technicalConsultingListAjax.do',
            dataType: 'json',
            type: 'POST',
            data: $('#searchForm').serialize(),
            success: function (data) {
                $('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
                setPaging(
                    'paging'
                    , goPage
                    , data.paginationInfo.currentPageNo
                    , data.paginationInfo.totalRecordCount
                    , data.paginationInfo.recordCountPerPage
                    , data.paginationInfo.pageSize
                );

                companySheet.LoadSearchData({Data: data.resultList});
            },
            error:function(request,status,error) {
                alert('참가 신청 업체 조회에 실패했습니다.');
            }
        });

    }

    /**
	 * 행사 변경(팝업)
	 */
	function openLayerEventChngPop(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/technicalConsulting/eventChngPopup.do" />'
			, callbackFunction : function(resultObj) {
				$("input[name=devCfrcId]").val(resultObj.devCfrcId);
				$("input[name=searchKeyword]").val(resultObj.cfrcName);
				doSearch();

			}
		});

	}

    //조회 이후 이미지 설정
    function companySheet_OnSearchEnd() {
        var ctn = "";
        var applId = "";
        var businessNo = "";
        var dscr = ""

        for (var i = 1; i <= companySheet.RowCount(); i++ ){
            // 주의 업체 이미지 표시
            ctn = companySheet.CellSearchValue(i,'ctnCmpny');       //주의 업체
            dscr = companySheet.CellSearchValue(i,'dscr');          // 메모
            applId = companySheet.CellSearchValue(i,'applId');
            businessNo =  companySheet.CellSearchValue(i,'businessNo'); // 사업자번호
            if((ctn != null) && (ctn != "")){
                companySheet.SetCellValue(i,'ctnCmpny','<img src="<c:url value="/images/common/alert.png" />" alt="주의" style="width: 30px;"/>');
            }
            // 메모 팝업
            if((dscr != null) && (dscr != "")){
                var btn = '<img src="<c:url value="/images/admin/ico_btn_apply.png" />" alt="메모" style="width: 30px;"/>'
                var html = '<button type="button"onclick="goMemo(' + applId +',' + businessNo + ')">'+btn+'</button>';

                companySheet.SetCellValue(i,'dscr',html);
            }
        }
    }

    //메모 클릭시
    function goMemo(applId,businessNo) {
        global.openLayerPopup({
            popupUrl : '/participationCompany/technicalConsultingDscrPop.do?businessNo='+businessNo
            , param : applId
        });
    }

    // 상세
    function companySheet_OnClick(Row, Col, Value) {
        if(companySheet.ColSaveName(Col) != "dscr" && Row > 0) {
            var applId = companySheet.GetCellValue(Row, "applId");
            var devCfrcId = companySheet.GetCellValue(Row, "devCfrcId");
            fn_detail(applId, devCfrcId);
        }

    };

    // 상담내역 조회 상세
    function fn_detail( applId, devCfrcId) {
        $("#applId").val( applId);
        $("#devCfrcId").val( devCfrcId);

        document.searchForm.action = '<c:url value="/participationCompany/companyInfoDetail.do" />';
        document.searchForm.target = '_self';
        document.searchForm.submit();
    }

    //엑셀다운로드
    function getExcelList(){
        var f;
        var totalCount = $("#totalCnt").val();

        if(totalCount < 5000) { //최대 5,000건 다운로드 가능

            document.searchForm = document.searchForm;
            document.searchForm.action = '<c:url value="/participationCompany/technicalConsultingExcelDown.do" />';
            document.searchForm.method = 'POST'
            document.searchForm.target = '_self';
            document.searchForm.submit();
        } else {
            alert("5,000건 이상 엑셀다운로드가 불가능 합니다.");
        }
    }

    //파일업로드
    function doFileUpload() {
        global.openLayerPopup({
            // 레이어 팝업 URL
            popupUrl : '<c:url value="/participationCompany/popup/technicalConsultingFileUploadPopup.do" />'
            , callbackFunction : function(resultObj){
                if (resultObj == '0000') {
                    getList();
                } else {
                    return;
                }
            }
        });
    }

    /**
	 * value 초기화 버튼
	 * @param targetId
	 */
	function mtiClearDate( targetId){
		$("#"+targetId).val("");
	}

    function doInit() {
		location.href = '<c:url value="/participationCompany/technicalConsultingList.do" />';
	}

</script>