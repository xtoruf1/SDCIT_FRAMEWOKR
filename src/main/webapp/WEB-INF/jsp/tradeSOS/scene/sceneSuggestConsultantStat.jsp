<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->

	<div class="ml-auto">
		<%--<button type="button" class="btn_sm btn_primary" onclick="getMemberExcel();">엑셀 다운</button>--%>
		<button type="button" class="btn_sm btn_primary" onclick="downloadIbSheetExcel(tblGridSheet,'무역현장컨설턴트_자문통계', '');">엑셀 다운</button>
		<button type="button" class="btn_sm btn_secondary" onclick="javascript:window.location.reload(true);">초기화</button>
		<button type="button" class="btn_sm btn_primary" onclick="getMemberList();">검색</button>
	</div>
</div>

<!-- 무역현장 컨설팅 상세 -->
<div class="cont_block">
	<form id="memberFrm" name="memberFrm">
		<input type="hidden" id="expertId" name="expertId" value="<c:out value="${user.memberNm}"/>"/>
		<table class="formTable">
			<colgroup>
				<col style="width:12%">
				<col>
				<col style="width:12%">
				<col>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">연도</th>
					<td>
						<div class="form_row w50p">
							<select id="endYear2" name="recDateTo" class="form_select">
								<c:forEach var="i" begin="2010" end="${year}" step="1">
									<option value="${year - i + 2010}" <c:if test="${year - i + 2010 == year}">selected</c:if>>
											${year - i + 2010}
									</option>
								</c:forEach>
							</select>
						</div>
					</td>
					<th scope="row">항목구분</th>
					<td>
						<label class="label_form">
							<input type="radio" name="gubun" id="radio4_1" class="form_radio" value="001" checked>
							<span for="radio3_1" class="label">건별</span>
						</label>
						<label class="label_form">
							<input type="radio" name="gubun" id="radio4_2" class="form_radio" value="002">
							<span for="radio4_2" class="label">상담채널별</span>
						</label>
						<label class="label_form">
							<input type="radio" name="gubun" id="radio4_3" class="form_radio" value="003">
							<span for="radio4_3" class="label">업체별</span>
						</label>
					</td>
				</tr>
			</tbody>
		</table><!-- // 검색 테이블-->
	</form>
	<!-- 리스트 테이블 -->
	<div class="tbl_list mt-20">
		<div class="tbl_opt">
			<div id="totalCnt" class="total_count"></div>
		</div>
		<div style="width: 100%;height: 100%;">
			<div id='tblGridSheet' class="colPosi"></div>
		</div>
	</div>
</div> <!-- // page_tradesos -->


<script type="text/javascript">

	$(document).ready(function () {

		setMemberGrid(); //위원별 Sheet

	});

	// 위원별 통계 리스트 가져오기
	function getMemberList(){

		setMemberGrid();
	}

	// 위원별 통계 그리드 생성
	function setMemberGrid(){

		var ibHeader = new IBHeader();

		/** 리스트,헤더 옵션 */
		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 4, DeferredVScroll: 1, VScrollMode: 1, editable: false, ColResize: true, statusColHidden: true, NoFocusMode: 0, Ellipsis: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		if ($("#memberFrm input[name=gubun]:checked").val() == "001"){
			ibHeader.addHeader({Type: "Text", 		Header: "No", 		    SaveName: "vnum", 		Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "구분기간", 		SaveName: "regDate",   	Align: "Center", 	Width: 200, 	Edit: false});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 200, 	Edit: false, Hidden:true});
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Center", Width: 200, 	Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "002"){
			ibHeader.addHeader({Type: "Text", 		Header: "No", 		    SaveName: "vnum", 		Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 200, 	Edit: false, Hidden:true });
			ibHeader.addHeader({Type: "Text",		Header: "구분기간", 		SaveName: "regDate",   	Align: "Center", 	Width: 200, 	Edit: false});
			ibHeader.addHeader({Type: "Text",		Header: "상담채널", 		SaveName: "channelNm", 	Align: "Center", 	Width: 200, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Center", Width: 200, 	Edit: false });

		} else if ($("#memberFrm input[name=gubun]:checked").val() == "003"){
			ibHeader.addHeader({Type: "Text", 		Header: "No", 		    SaveName: "vnum", 		Align: "Center", Width: 40});
			ibHeader.addHeader({Type: "Text",		Header: "위원명", 		SaveName: "expertNm", 	Align: "Center", 	Width: 200, 	Edit: false, Hidden:true });
			ibHeader.addHeader({Type: "Text",		Header: "구분기간", 		SaveName: "regDate",   	Align: "Center", 	Width: 200, 	Edit: false});
			ibHeader.addHeader({Type: "Text",		Header: "업체명", 		SaveName: "company", 	Align: "Center", 	Width: 200, 	Edit: false });
			ibHeader.addHeader({Type: "Text",		Header: "사업자번호", 	SaveName: "companyNo", 	Align: "Center", 	Width: 200, 	Edit: false });
			ibHeader.addHeader({Type: "Int",		Header: "건수", 		    SaveName: "totCnt", 	Align: "Center", Width: 200, 	Edit: false });

		}

		if (typeof tblGridSheet !== "undefined" && typeof tblGridSheet.Index !== "undefined") {
			tblGridSheet.DisposeSheet();
		}

		var sheetId = "tblGridSheet";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "640px");
		ibHeader.initSheet(sheetId);

		// 편집모드 OFF
		tblGridSheet.SetEditable(0);

		memberList();
	}

	//위원별 조회
	function memberList() {
		global.ajax({
			 type : 'POST'
			, url : '<c:url value="/tradeSOS/scene/sceneSuggestStatMemberConsultantListAjax.do" />'
			, data : $('#memberFrm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				tblGridSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	// 위원별 엑셀다운로드
	function getMemberExcel(){
		var f;
		f = document.memberFrm;
		f.action = '<c:url value="/tradeSOS/scene/sceneSuggestStatMemberListExcelDown.do" />';
		f.method = 'POST'
		f.target = '_self';
		f.submit();

	}

	function setRound(val){
		return Math.round(val*10)/10;
	}

	function getNum(val){
		if (isNaN(val)) {
			return 0;
		}
		return val;
	}
</script>