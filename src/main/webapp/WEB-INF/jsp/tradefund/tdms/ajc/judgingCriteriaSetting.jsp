<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<form id="judgeForm" name="judgeForm" method="get" onsubmit="return false;">
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<button type="button" onclick="doCopy();" class="btn_sm btn_primary btn_modify_auth">전년도복사</button>
	</div>
	<div class="ml-15">
		<button type="button" onclick="clearForm('search');" class="btn_sm btn_secondary">초기화</button>
		<button type="button" onclick="doSearch();" class="btn_sm btn_primary">검색</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<table class="formTable">
		<colgroup>
			<col style="width:15%" />
			<col />
			<col style="width:15%" />
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">기준년도</th>
				<td>
					<fieldset class="widget">
						<select id="searchPriYear" name="searchPriYear" class="form_select" title="기준년도" style="width: 100px;">
							<c:forEach var="item" items="${yearList}" varStatus="status">
								<option value="<c:out value="${item.searchYear}"/>" <c:if test="${param.searchPriYear eq item.searchYear}">selected="selected"</c:if>>${item.searchYear}</option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
				<th scope="row">심사구분</th>
				<td>
					<fieldset class="widget">
						<select id="searchJudgingGbn" name="searchJudgingGbn" class="form_select" title="심사구분" style="width: 100px;">
							<option value="">전체</option>
							<c:forEach var="item" items="${awd023}" varStatus="status">
								<option value="${item.detailcd}" <c:if test="${param.searchJudgingGbn eq item.detailcd}">selected="selected"</c:if>>${item.detailnm}</option>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->
<div class="cont_block mt-20">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="judgeList" class="sheet"></div>
	</div>
</div>
</form>
<script type="text/javascript">
	$(document).ready(function(){
		initIBSheet();
	});

	// Sheet의 초기화 작업
	function initIBSheet() {
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header: '상태', Type: 'Status', Hidden: true, Width: 100, Align: 'Center', ColMerge: 1, SaveName: 'status', Wrap: 1 });
		ibHeader.addHeader({Header: '구분명', Type: 'Text', Hidden: false, Width: 100, Align: 'Left', ColMerge: 1, SaveName: 'priNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap:1, BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '심사항목명', Type: 'Text', Hidden: false, Width: 100, Align: 'Left', ColMerge: 1, SaveName: 'priGbnNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap: 1, BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '심사세부항목명', Type: 'Text', Hidden: false, Width: 120, Align: 'Left', ColMerge: 1, SaveName: 'scoreTypeNm', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 130, Wrap: 1, BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '최대점수', Type: 'Text', Hidden: false, Width: 80, Align: 'Right', ColMerge: 1, RowMerge: 0, SaveName: 'maxScore', CalcLogic: '', Format: 'Float', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 30, Wrap: 1 });
		ibHeader.addHeader({Header: '최소', Type: 'Int', Hidden: false, Width: 100, Align: 'Right', ColMerge: 0, SaveName: 'basisStart', CalcLogic: '', Format: 'NullInteger', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 9, Wrap: 1 });
		ibHeader.addHeader({Header: '최대', Type: 'Int', Hidden: false, Width: 100, Align: 'Right', ColMerge: 0, SaveName: 'basisEnd', CalcLogic: '', Format: 'NullInteger', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 10, Wrap: 1 });
		ibHeader.addHeader({Header: '기준점수', Type: 'Int', Hidden: false, Width: 100, Align: 'Right', ColMerge: 0, RowMerge: 0, SaveName: 'basisScore', KeyField: 1, CalcLogic: '', Format: 'NullInteger', PointCount: 0, UpdateEdit: 1, InsertEdit: 1, EditLen: 9, Wrap: 1 });
		ibHeader.addHeader({Header: '가중치', Type: 'Float', Hidden: false, Width: 100, Align: 'Right', ColMerge: 0, SaveName: 'weightScore', CalcLogic: '', Format: '#,##0.00', PointCount: 2, UpdateEdit: 1, InsertEdit: 1, EditLen: 30, Wrap: 1 });
		ibHeader.addHeader({Header: '추가', Type: 'Text', Hidden: false, Width: 40, Align: 'Center', ColMerge: 0, SaveName: 'addBtn', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap: 1, BackColor: '#F6F6F6' });
		ibHeader.addHeader({Header: '삭제', Type: 'Text', Hidden: false, Width: 40, Align: 'Center', ColMerge: 0, SaveName: 'delBtn', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap: 1, BackColor: '#F6F6F6' });

		ibHeader.addHeader({Header: '기준년도', Type: 'Text', Hidden: true, Width: 100, Align: 'Center', ColMerge: 1, SaveName: 'priGbn', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap:1 });
		ibHeader.addHeader({Header: '항목구분', Type: 'Text', Hidden: true, Width: 100, Align: 'Center', ColMerge: 1, SaveName: 'scoreType', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap: 1 });
		ibHeader.addHeader({Header: '순번', Type: 'Text', Hidden: true, Width: 100, Align: 'Center', ColMerge: 0, RowMerge: 0, SaveName: 'seqNo', CalcLogic: '', Format: '', PointCount: 0, UpdateEdit: 0, InsertEdit: 0, EditLen: 30, Wrap: 1 });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 50, SearchMode: 2, DeferredVScroll: 1, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = 'judgeList';
		var container = $('#' + sheetId)[0];
		if (typeof judgeListSheet !== 'undefined' && typeof judgeListSheet.Index !== 'undefined') {
			judgeListSheet.DisposeSheet();
		}

		createIBSheet2(container, 'judgeListSheet', '100%', '600px');
		ibHeader.initSheet('judgeListSheet');

		judgeListSheet.SetEditable(true);

		getList();
	}

	// 조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/ajc/selectJudgingCriteriaSettingList.do" />'
			, data : $('#judgeForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');

				judgeListSheet.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function judgeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
			console.log('judgeListSheet_OnSearchEnd : ', msg);
		} else {
			judgeListSheet.SetColFontColor('addBtn', 'rgb(204, 102, 0)');
			judgeListSheet.SetColFontColor('delBtn', 'rgb(204, 102, 0)');
		}
	}

	function judgeListSheet_OnClick(Row, Col, Value) {
 		if (Row > 0) {
			if (judgeListSheet.ColSaveName(Col) == 'addBtn') {
				var newRow = judgeListSheet.DataInsert();
				judgeListSheet.SetCellValue(newRow, 'priGbn', judgeListSheet.GetCellValue(Row, 'priGbn'));
				judgeListSheet.SetCellValue(newRow, 'priNm', judgeListSheet.GetCellValue(Row, 'priNm')) ;
				judgeListSheet.SetCellValue(newRow, 'priGbnNm', judgeListSheet.GetCellValue(Row, 'priGbnNm')) ;
				judgeListSheet.SetCellValue(newRow, 'scoreTypeNm', judgeListSheet.GetCellValue(Row, 'scoreTypeNm')) ;
				judgeListSheet.SetCellValue(newRow, 'maxScore', judgeListSheet.GetCellValue(Row, 'maxScore')) ;
				judgeListSheet.SetCellValue(newRow, 'scoreType', judgeListSheet.GetCellValue(Row, 'scoreType'));
				judgeListSheet.SetCellValue(newRow, 'addBtn', '+');
				judgeListSheet.SetCellValue(newRow, 'delBtn', '-');
				judgeListSheet.SetDataMerge(newRow);
			} else if (judgeListSheet.ColSaveName(Col) == 'delBtn') {
				judgeListSheet.SetRowHidden(Row, true);
				judgeListSheet.SetCellValue(Row, 'status', 'D');
			}
		}
	}

	function isValid() {
		var maxScore01 = '${maxScore.maxVal01}';
		var maxScore02 = '${maxScore.maxVal02}';
		var maxScore04 = '${maxScore.maxVal04}';
		var score01 = 0;
		var score02 = 0;
		var score04 = 0;
		var tempScoreType01 = '';
		var tempScoreType02 = '';
		var tempScoreType04 = '';

		for (var i = 1; i <= judgeListSheet.RowCount(); i++) {
			if (judgeListSheet.GetCellValue(i, 'status') != 'D') {
				/* 대기업 대표자 */
				if (judgeListSheet.GetCellValue(i, 'scoreType').substring(0, 2) == '10') {
					if (tempScoreType01 != judgeListSheet.GetCellValue(i, 'scoreType')) {
						tempScoreType01 = judgeListSheet.GetCellValue(i, 'scoreType');
						score01 = score01 + parseFloat(judgeListSheet.GetCellValue(i, 'maxScore'));
					}
				/* 중소기업 대표자 */
				} else if (judgeListSheet.GetCellValue(i, 'scoreType').substring(0, 2) == '20') {
					if (tempScoreType02 != judgeListSheet.GetCellValue(i, 'scoreType')) {
						tempScoreType02 = judgeListSheet.GetCellValue(i, 'scoreType');
						score02 = score02 + parseFloat(judgeListSheet.GetCellValue(i, 'maxScore'));
					}
				/* 종업원 */
				} else if (judgeListSheet.GetCellValue(i, 'scoreType').substring(0, 2) == '30') {
					if (tempScoreType04 != judgeListSheet.GetCellValue(i, 'scoreType')) {
						tempScoreType04 = judgeListSheet.GetCellValue(i, 'scoreType');
						score04 = score04 + parseFloat(judgeListSheet.GetCellValue(i, 'maxScore'));
					}
				}
			}
		}

		if (parseFloat(maxScore01) != score01) {
			alert('대기업 최대점수 값이 틀립니다.\n' + '협회기준 : ' + parseFloat(maxScore01) + '\n' + '현재값 : ' + score01);

			return false;
		} else if (parseFloat(maxScore02) != score02) {
			alert('중소기업 최대점수 값이 틀립니다.\n' + '협회기준 : ' + parseFloat(maxScore02) + '\n' + '현재값 : ' + score02);

			return false;
		} else if (parseFloat(maxScore04) != score04) {
			alert('종업원 최대점수 값이 틀립니다.\n' + '협회기준 : ' + parseFloat(maxScore04) + '\n'+'현재값 : ' + score04);

			return false;
		}

		return true;
	}

	function doSave() {
		if (confirm('심사기준설정 정보를 저장하시겠습니까?')) {
			if (isValid()) {
				var saveJson = judgeListSheet.GetSaveJson();

				// 대상목록의 정보
				if (saveJson.Message == 'KeyFieldError') {
					return false;
				}

				if (saveJson.Message == 'InvalidInputError') {
					return false;
				}

				if (saveJson.data.length) {
					var jf = $('#judgeForm').serializeObject();

					var map = {};
					var list = [];
					$.each(saveJson, function(key1, value1) {
						map = {};
						$.each(value1, function(key2, value2) {
							map = value2;
							list.push(map);
						});

						jf['settingList'] = list;
					});

					global.ajax({
						type : 'POST'
						, url : '<c:url value="/tdms/ajc/saveJudgingCriteriaSettingList.do" />'
						, data : JSON.stringify(jf)
						, contentType : 'application/json'
						, dataType : 'json'
						, async: false
						, spinner : true
						, success : function(data){
							// alert('심사기준설정 정보를 저장 하였습니다.');

							getList();
						}
					});
				}
			}
		}
	}

	function doCopy() {
		if (confirm('전년도 데이터를 복사하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/tdms/ajc/saveJudgingCriteriaSettingCopy.do" />'
				, dataType : 'json'
				, async: false
				, spinner : true
				, success : function(data){
					if (data.result) {
						// alert('복사 하였습니다.');

						getList();
					} else {
						alert(data.message);

						return false;
					}
				}
			});
		}
	}
</script>