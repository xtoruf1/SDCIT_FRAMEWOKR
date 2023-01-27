<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="common" uri="/WEB-INF/META-INF/common.tld" %>
<form name="listForm" method="get" onsubmit="return false;">
<input type="hidden" name="searchYear" value="<c:out value="${param.searchYear}" />" />
<input type="hidden" name="searchTitle" value="<c:out value="${param.searchTitle}" />" />
</form>
<form id="registForm" name="registForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" id="svrId" name="svrId" value="<c:out value="${resultInfo.svrId}" />" />
<input type="hidden" id="spRecKind" name="spRecKind" value="" />
<input type="hidden" id="statusChk" name="statusChk" value="<c:out value="${empty resultInfo.svrId ? 'I' : 'U'}" />" />
<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<!-- 네비게이션 -->
	<div class="ml-auto">
		<button type="button" onclick="doSave();" class="btn_sm btn_primary btn_modify_auth">저장</button>
		<c:if test="${not empty resultInfo.svrId}">
			<button type="button" onclick="doDelete();" class="btn_sm btn_secondary btn_modify_auth">삭제</button>
		</c:if>
	</div>
	<div class="ml-15">
		<button type="button" onclick="goList();" class="btn_sm btn_secondary">목록</button>
	</div>
</div>
<!--검색 시작 -->
<div class="search">
	<div class="cont_block mb-20">
		<div class="tbl_opt">
			<span><strong class="point">*</strong> 는 필수 입력입니다.</span>
		</div>
		<table class="formTable">
			<colgroup>
				<col style="width: 15%;" />
				<col style="width: 15%;" />
				<col style="width: 25%;" />
				<col style="width: 15%;" />
				<col style="width: 30%;" />
			</colgroup>
			<tr>
				<th>포상명 <strong class="point">*</strong></th>
				<td colspan="4">
					<input type="text" id="bsnNm" name="bsnNm" value="<c:out value="${resultInfo.bsnNm}" />" maxlength="200" class="form_text w100p" title="포상명" required="required" />
				</td>
			</tr>
			<tr>
				<th>포상회차 <strong class="point">*</strong></th>
				<td colspan="2">
					<input type="text" id="bsnSeq" name="bsnSeq" value="<c:out value="${resultInfo.bsnSeq}" />" maxlength="3" class="form_text w100p" title="포상회차" required="required" numberOnly />
				</td>
				<th>상태</th>
				<td>
					<select id="state" name="state" class="form_select" title="상태" style="width: 150px;">
						<c:forEach var="item" items="${awd000}" varStatus="status">
							<option value="${item.detailcd}" <c:if test="${resultInfo.state eq item.detailcd}">selected="selected"</c:if>>${item.detailnm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th rowspan="3">담당자</th>
				<th>이름 <strong class="point">*</strong></th>
				<td>
					<span class="form_search" style="width: 100%;">
						<input type="text" id="wrkMembNm" name="wrkMembNm" value="<c:out value="${resultInfo.wrkMembNm}" />" maxlength="100" class="form_text" style="width: 80%;" title="담당자 이름" required="required" readonly="readonly" />
						<input type="hidden" id="wrkMembId" name="wrkMembId" value="<c:out value="${resultInfo.wrkMembId}" />" />
						<button type="button" onclick="searchUserPopup();" class="btn_icon btn_search" title="담당자검색"></button>
					</span>
				</td>
				<th>부서 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="wrkDeptNm" name="wrkDeptNm" value="<c:out value="${resultInfo.wrkDeptNm}" />" maxlength="50" class="form_text w100p" title="담당자 부서" required="required" readonly="readonly" />
					<input type="hidden" id="wrkDeptId" name="wrkDeptId" value="<c:out value="${resultInfo.wrkDeptId}" />" />
				</td>
			</tr>
			<tr>
				<th>전화 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="wrkMembPhone" name="wrkMembPhone" value="<c:out value="${resultInfo.wrkMembPhone}" />" maxlength="14" class="form_text w100p" title="담당자 전화" required="required" />
				</td>
				<th>팩스 <strong class="point">*</strong></th>
				<td>
					<input type="text" id="wrkMembFax" name="wrkMembFax" value="<c:out value="${resultInfo.wrkMembFax}" />" maxlength="14" class="form_text w100p" title="담당자 팩스" required="required" />
				</td>
			</tr>
			<tr>
				<th>E-Mail <strong class="point">*</strong></th>
				<td colspan="3">
					<input type="text" id="wrkMembEmail" name="wrkMembEmail" value="<c:out value="${resultInfo.wrkMembEmail}" />" maxlength="100" class="form_text w100p" title="담당자 E-Mail" required="required" />
				</td>
			</tr>
			<tr>
				<th rowspan="3">포상</th>
				<th>접수기간 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="bsnAplStartDt" name="bsnAplStartDt" value="<c:out value="${resultInfo.bsnAplStartDt}" />" maxlength="100" class="txt datepicker" title="접수기간 시작" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('bsnAplStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="bsnAplEndDt" name="bsnAplEndDt" value="<c:out value="${resultInfo.bsnAplEndDt}" />" maxlength="100" class="txt datepicker" title="접수기간 종료" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('bsnAplEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>배부기간 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="applDtbStartDt" name="applDtbStartDt" value="<c:out value="${resultInfo.applDtbStartDt}" />" maxlength="100" class="txt datepicker" title="배부기간 시작" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('applDtbStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="applDtbEndDt" name="applDtbEndDt" value="<c:out value="${resultInfo.applDtbEndDt}" />" maxlength="100" class="txt datepicker" title="배부기간 종료" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('applDtbEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>포상일 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="datepicker_box">
						<span class="form_datepicker">
							<input type="text" id="priDt" name="priDt" value="<c:out value="${resultInfo.priDt}" />" maxlength="100" class="txt datepicker" title="포상일" required="required" readonly="readonly" />
							<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
						</span>
						<button type="button" onclick="setDefaultPickerValue('priDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
					</div>
				</td>
			</tr>
			<tr>
				<th colspan="2">신청서 배부 및 접수처 <strong class="point">*</strong></th>
				<td colspan="3">
					<input type="text" id="applDtbPlace" name="applDtbPlace" value="<c:out value="${resultInfo.applDtbPlace}" />" maxlength="100" class="form_text w100p" title="신청서 배부 및 접수처" required="required" />
				</td>
			</tr>
			<tr>
				<th rowspan="3">수출실적인정기간</th>
				<th>당해년도 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expNowyearStartDt" name="expNowyearStartDt" value="<c:out value="${resultInfo.expNowyearStartDt}" />" maxlength="100" class="txt datepicker" title="당해년도 시작" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expNowyearStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expNowyearEndDt" name="expNowyearEndDt" value="<c:out value="${resultInfo.expNowyearEndDt}" />" maxlength="100" class="txt datepicker" title="당해년도 종료" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expNowyearEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>전년도 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expBefyearStartDt" name="expBefyearStartDt" value="<c:out value="${resultInfo.expBefyearStartDt}" />" maxlength="100" class="txt datepicker" title="전년도 시작" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expBefyearStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expBefyearEndDt" name="expBefyearEndDt" value="<c:out value="${resultInfo.expBefyearEndDt}" />" maxlength="100" class="txt datepicker" title="전년도 종료" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expBefyearEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>전전년도 <strong class="point">*</strong></th>
				<td colspan="3">
					<div class="group_datepicker">
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expTwoyearStartDt" name="expTwoyearStartDt" value="<c:out value="${resultInfo.expTwoyearStartDt}" />" maxlength="100" class="txt datepicker" title="전전년도 시작" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expTwoyearStartDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
						<div class="spacing">~</div>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="expTwoyearEndDt" name="expTwoyearEndDt" value="<c:out value="${resultInfo.expTwoyearEndDt}" />" maxlength="100" class="txt datepicker" title="전전년도 종료" required="required" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
							<button type="button" onclick="setDefaultPickerValue('expTwoyearEndDt');" class="dateClear"><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화" /></button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="4">
					<input type="hidden" id="attFileId" name="attFileId" value="<c:out value="${resultInfo.attFileId}" />" />
					<input type="hidden" id="fileId" name="fileId" />
					<input type="hidden" id="fileNo" name="fileNo" />
					<c:set var="attachCnt" value="${fn:length(attachList)}" />
					<div <c:if test="${attachCnt > 0}">style="padding-bottom: 20px;"</c:if>>
						<c:if test="${attachCnt > 0}">
							<c:forEach var="item" items="${attachList}" varStatus="status">
								<div id="fileNo_<c:out value="${item.fileNo}" />" class="addedFile">
									<a href="javascript:void(0);" onclick="doDownloadFile('<c:out value="${item.fileNo}" />');" class="filename"><c:out value="${item.fileName}" /></a>
									<a href="javascript:void(0);" onclick="doDeleteFile('<c:out value="${item.fileNo}" />');" class="btn_del">
										<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />
									</a>
								</div>
							</c:forEach>
						</c:if>
					</div>
					<div class="form_group">
						<div class="form_file">
							<p class="file_name">첨부파일을 선택하세요</p>
							<label class="file_btn">
								<input type="file" id="attachFile" name="attachFile" class="txt attachment" title="첨부파일" />
								<input type="hidden" name="attachFileSeq" value="1" />
								<span class="btn_tbl">찾아보기</span>
							</label>
						</div>
						<button type="button" onclick="doAddAttachField();" class="btn_tbl_border btn_modify_auth">추가</button>
					</div>
					<div id="attachFieldEdit"></div>
				</td>
			</tr>
		</table>
	</div>
</div>
<!--
<div class="cont_block mt-20 mb-40">
	<div style="width: 100%;height: 100%;display: flex;justify-content: space-between;">
		<div style="width: 52%;">
			<h3>특수유공 추천부문별 등급</h3>
		</div>
		<div style="width: 48%;">
			<h3>특수유공 추천기관별 순위</h3>
		</div>
	</div>
	<div style="width: 100%;height: 100%;margin-top: 20px;display: flex;justify-content: space-between;">
		<div id="registeList1" class="sheet"></div>
		<div id="registeList2" class="sheet"></div>
	</div>
</div>
-->
</form>
<script type="text/javascript">
	var	ibHeader1 = new IBHeader();
	ibHeader1.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader1.addHeader({Header: '추천부문', Type: 'Text', SaveName: 'detailnm', Width: 170, Align: 'Left', Edit: false, Cursor: 'Pointer'});
	ibHeader1.addHeader({Header: '사용여부', Type: 'Text', SaveName: 'useYn', Width: 60, Align: 'Center', Edit: false, Cursor: 'Pointer'});
	ibHeader1.addHeader({Header: '등급', Type: 'Int', SaveName: 'gradeCd', Width: 80, Align: 'Center', Cursor: 'Pointer'});

	ibHeader1.addHeader({Header: '무역포상 아이디', Type: 'Text', SaveName: 'svrId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader1.addHeader({Header: '추천부문코드1', Type: 'Text', SaveName: 'detailcd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader1.addHeader({Header: '추천부문코드2', Type: 'Text', SaveName: 'spRecKind', Width: 0, Align: 'Center', Hidden: true});

	ibHeader1.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader1.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	var	ibHeader2 = new IBHeader();
	ibHeader2.addHeader({Header: '상태', Type: 'Status', SaveName: 'status', Width: 20, Align: 'Center', Hidden: true});
	ibHeader2.addHeader({Header: '추천기관', Type: 'Text', SaveName: 'subDetailnm', Width: 170, Align: 'Left', Edit: false});
	ibHeader2.addHeader({Header: '순위', Type: 'Int', SaveName: 'rankNo', Width: 80, Align: 'Center'});

	ibHeader2.addHeader({Header: '무역포상 아이디', Type: 'Text', SaveName: 'svrId', Width: 0, Align: 'Center', Hidden: true});
	ibHeader2.addHeader({Header: '추천부문코드1', Type: 'Text', SaveName: 'masterDetailcd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader2.addHeader({Header: '추천기관코드1', Type: 'Text', SaveName: 'subDetailcd', Width: 0, Align: 'Center', Hidden: true});
	ibHeader2.addHeader({Header: '추천부문코드2', Type: 'Text', SaveName: 'spRecKind', Width: 0, Align: 'Center', Hidden: true});
	ibHeader2.addHeader({Header: '추천기관코드2', Type: 'Text', SaveName: 'spRecOrg', Width: 0, Align: 'Center', Hidden: true});

	ibHeader2.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 2, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode: 0, Ellipsis: 1});
	ibHeader2.setHeaderMode({Sort: 0, Editable: false, ColResize: true, ColMove: true, StatusColHidden: true});

	$(document).ready(function(){
		$('input:text[numberOnly]').on({
			keyup: function(){
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			},
			focusout: function() {
				$(this).val($(this).val().replace(/[^0-9]/g, ''));
			}
		});

		// 시작일 선택 이벤트
		datepickerById('bsnAplStartDt', bsnAplFromSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('bsnAplEndDt', bsnAplToSelectEvent);

		// 시작일 선택 이벤트
		datepickerById('applDtbStartDt', applDtbFromSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('applDtbEndDt', applDtbToSelectEvent);

		// 시작일 선택 이벤트
		datepickerById('expNowyearStartDt', expNowyearFromSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('expNowyearEndDt', expNowyearToSelectEvent);

		// 시작일 선택 이벤트
		datepickerById('expBefyearStartDt', expBefyearFromSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('expBefyearEndDt', expBefyearToSelectEvent);

		// 시작일 선택 이벤트
		datepickerById('expTwoyearStartDt', expTwoyearFromSelectEvent);
		// 종료일 선택 이벤트
		datepickerById('expTwoyearEndDt', expTwoyearToSelectEvent);

		/*
		var container1 = $('#registeList1')[0];
		createIBSheet2(container1, 'registeList1Sheet', '47%', '600px');
		ibHeader1.initSheet('registeList1Sheet');
		registeList1Sheet.SetSelectionMode(4);

		var container2 = $('#registeList2')[0];
		createIBSheet2(container2, 'registeList2Sheet', '48%', '600px');
		ibHeader2.initSheet('registeList2Sheet');
		registeList2Sheet.SetSelectionMode(4);

		registeList2Sheet.ShowFilterRow();    // 필터
		registeList2Sheet.SetRowHidden(1, 1); // 마스터 키 에따른 히든

		getAwdSpeGradeList();
		getAwdSpeRankList();
		*/

		var f = document.registForm;

		if (f.statusChk.value == 'I') {
			f.wrkMembId.value = '<c:out value="${memberInfo.memberId}" />';			// KITANET 아이디
			f.wrkMembNm.value = '<c:out value="${memberInfo.memberNm}" />';			// 성명
			f.wrkDeptId.value = '<c:out value="${memberInfo.deptCd}" />';			// 부서코드
			f.wrkDeptNm.value = '<c:out value="${memberInfo.deptNm}" />';			// 부서명
			f.wrkMembPhone.value = '<c:out value="${memberInfo.telNo}" />';			// 전화번호
			f.wrkMembFax.value = '<c:out value="${memberInfo.faxNo}" />';			// 팩스번호
			f.wrkMembEmail.value = '<c:out value="${user.email}" />';				// E-MAIL
		}

		// 전화번호 셋팅(회사 제외)
		setExpPhoneNumber(['#wrkMembPhone', '#wrkMembFax'], 'W');
	});

	function bsnAplFromSelectEvent() {
		var startymd = Date.parse($('#bsnAplStartDt').val());

		if ($('#bsnAplEndDt').val() != '') {
			if (startymd > Date.parse($('#bsnAplEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#bsnAplStartDt').val('');

				return;
			}
		}
	}

	function bsnAplToSelectEvent() {
		var endymd = Date.parse($('#bsnAplEndDt').val());

		if ($('#bsnAplStartDt').val() != '') {
			if (endymd < Date.parse($('#bsnAplStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#bsnAplEndDt').val('');

				return;
			}
		}
	}

	function applDtbFromSelectEvent() {
		var startymd = Date.parse($('#applDtbStartDt').val());

		if ($('#applDtbEndDt').val() != '') {
			if (startymd > Date.parse($('#applDtbEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#applDtbStartDt').val('');

				return;
			}
		}
	}

	function applDtbToSelectEvent() {
		var endymd = Date.parse($('#applDtbEndDt').val());

		if ($('#applDtbStartDt').val() != '') {
			if (endymd < Date.parse($('#applDtbStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#applDtbEndDt').val('');

				return;
			}
		}
	}

	function expNowyearFromSelectEvent() {
		var startymd = Date.parse($('#expNowyearStartDt').val());

		if ($('#expNowyearEndDt').val() != '') {
			if (startymd > Date.parse($('#expNowyearEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#expNowyearStartDt').val('');

				return;
			}
		}
	}

	function expNowyearToSelectEvent() {
		var endymd = Date.parse($('#expNowyearEndDt').val());

		if ($('#expNowyearStartDt').val() != '') {
			if (endymd < Date.parse($('#expNowyearStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#expNowyearEndDt').val('');

				return;
			}
		}
	}

	function expBefyearFromSelectEvent() {
		var startymd = Date.parse($('#expBefyearStartDt').val());

		if ($('#expBefyearEndDt').val() != '') {
			if (startymd > Date.parse($('#expBefyearEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#expBefyearStartDt').val('');

				return;
			}
		}
	}

	function expBefyearToSelectEvent() {
		var endymd = Date.parse($('#expBefyearEndDt').val());

		if ($('#expBefyearStartDt').val() != '') {
			if (endymd < Date.parse($('#expBefyearStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#expBefyearEndDt').val('');

				return;
			}
		}
	}

	function expTwoyearFromSelectEvent() {
		var startymd = Date.parse($('#expTwoyearStartDt').val());

		if ($('#expTwoyearEndDt').val() != '') {
			if (startymd > Date.parse($('#expTwoyearEndDt').val())) {
				alert('시작일은 종료일 이전이어야 합니다.');
				$('#expTwoyearStartDt').val('');

				return;
			}
		}
	}

	function expTwoyearToSelectEvent() {
		var endymd = Date.parse($('#expTwoyearEndDt').val());

		if ($('#expTwoyearStartDt').val() != '') {
			if (endymd < Date.parse($('#expTwoyearStartDt').val())) {
				alert('종료일은 시작일 이후여야 합니다.');
				$('#expTwoyearEndDt').val('');

				return;
			}
		}
	}

	// 첨부파일 목록 가져오기
	function getAttachList(attFileId) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectRegisteAttachList.do" />'
			, data : {
				fileId : attFileId
			}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#attachFieldList').empty();
				$('#attachFieldEdit').empty();

				if (data.attachList.length) {
					var attachList = data.attachList;

					for (var i = 0 ; i < attachList.length; i++) {
						var fileNo = attachList[i].fileNo;
						var fileName = attachList[i].fileName;

						if (fileNo != '') {
							var html = '';
							html += '<div id="fileNo_' + fileNo + '" class="addedFile">';
							html += '	<a href="javascript:void(0);" onclick="doDownloadFile(\'' + fileNo + '\');" class="filename">' + fileName + '</a>';
							html += '	<a href="javascript:void(0);" onclick="doDeleteFile(\'' + fileNo + '\');" class="btn_del">';
							html += '		<img src="<c:url value="/images/admin/ico_btn_delete.png" />" alt="삭제" />';
							html += '	</a>';
							html += '</div>';

							$('#attachFieldList').append(html);
							$('#attachFieldList').css('padding-bottom', '20px');
						}
					}
				}
			}
		});
	}

	// 첨부파일 필드 추가
	function doAddAttachField() {
		var attachCnt = 0;
		$('input[name="attachFileSeq"]').each(function(){
			attachCnt = $(this).val();
		});

		var attachFileSeq = parseInt(attachCnt) + 1;

		var html = '';
		html += '<div id="field' + attachFileSeq + '" class="mb5px flex mt-5">';
		html += '	<div class="form_file">';
		html += '		<p class="file_name">첨부파일을 선택하세요</p>';
		html += '		<label class="file_btn">';
		html += '			<input type="file" name="attachFile" class="txt" title="첨부파일" />';
		html += '			<input type="hidden" name="attachFileSeq" value="' + attachFileSeq + '" />';
		html += '			<span class="btn_tbl">찾아보기</span>';
		html += '		</label>';
		html += '	</div>';
		html += '	<button type="button" onclick="doDeleteAttachField(\'' + attachFileSeq + '\');" class="btn_tbl_border btn_modify_auth">삭제</button>';
		html += '</div>';

		$('#attachFieldEdit').append(html);
	}

	// 첨부파일 필드 삭제
	function doDeleteAttachField(attachFileSeq) {
		$('#field' + attachFileSeq).remove();
	}

	// 첨부파일 다운로드
	function doDownloadFile(fileNo) {
		var f = document.registForm;
		f.action = '<c:url value="/common/util/tradefundFileDownload.do" />';
		f.fileId.value = f.attFileId.value;
		f.fileNo.value = fileNo;
		f.target = '_self';
		f.submit();
	}

	// 첨부파일 삭제
	function doDeleteFile(fileNo) {
		if (confirm('해당 파일을 삭제하시겠습니까?')) {
			global.ajax({
				type : 'POST'
				, url : '<c:url value="/common/util/tradefundFileDelete.do" />'
				, data : {
					fileId : $('#attFileId').val()
					, fileNo : fileNo
				}
				, dataType : 'json'
				, async : true
				, spinner : true
				, success : function(data){
					$('#fileNo_' + fileNo).hide();
				}
			});
		}
	}

	// 저장
	function doSave() {
		var f = document.registForm;

		if (!doValidFormRequired(f)) {
			return;
		}

		/*
		var cnt = registeList2Sheet.RowCount();

		if (cnt) {
			for (var i = 2; i < cnt + 2; i++) {
				var rankNo = registeList2Sheet.GetCellValue(i, 'rankNo');

				if (rankNo != '') {
					if (rankNo > 100) {
						alert('순위는 100이하로 입력해 주세요.');

						return;
					}
				}
			}
		}

		var index = registeList2Sheet.FilteredRowIndex();

		var duprows = registeList2Sheet.ColValueDupRows('rankNo', {
			'IncludeEmpty' : 0
			, 'StartRow' : index[0]
			, 'EndRow' : index[index.length - 1]
		});

		if (duprows) {
			alert('순위에 중복이 존재합니다.');

			return;
		}

		$('#registForm input[name="masterSpRecKinds"]').remove();
		$('#registForm input[name="gradeCds"]').remove();
		$('#registForm input[name="subSpRecKinds"]').remove();
		$('#registForm input[name="spRecOrgs"]').remove();
		$('#registForm input[name="rankNos"]').remove();

		var sheet1 = registeList1Sheet.GetSaveJson({AllSave: 1});
		var sheet2 = registeList2Sheet.GetSaveJson({AllSave: 1});

		var form = $('#registForm');

		if (sheet1.data.length) {
			$.each(sheet1, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					var gradeCd = value2.gradeCd;

					if (gradeCd) {
						form.append($('<input/>', {type: 'hidden', name: 'masterSpRecKinds', value: value2.detailcd}));
						form.append($('<input/>', {type: 'hidden', name: 'gradeCds', value: gradeCd}));
					}
				});
			});
		}

		if (sheet2.data.length) {
			$.each(sheet2, function(key1, value1) {
				$.each(value1, function(key2, value2) {
					var rankNo = value2.rankNo;

					if (rankNo) {
						form.append($('<input/>', {type: 'hidden', name: 'subSpRecKinds', value: value2.masterDetailcd}));
						form.append($('<input/>', {type: 'hidden', name: 'spRecOrgs', value: value2.subDetailcd}));
						form.append($('<input/>', {type: 'hidden', name: 'rankNos', value: rankNo}));
					}
				});
			});
		}
		*/

		if (confirm('포상정보를 저장하시겠습니까?')) {
			global.ajaxSubmit($('#registForm'), {
				type : 'POST'
				, url : '<c:url value="/tdms/tdm/saveTradeDayRegiste.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					// alert('포상정보를 저장하였습니다.');

					goList();
		        }
			});
		}
	}

	function doDelete() {
		if (confirm('포상정보를 삭제하시겠습니까?')) {
			var f = document.registForm;
			f.statusChk.value = 'D';

			global.ajaxSubmit($('#registForm'), {
				type : 'POST'
				, url : '<c:url value="/tdms/tdm/deleteTradeDayRegiste.do" />'
				, enctype : 'multipart/form-data'
				, dataType : 'json'
				, async : false
				, spinner : true
				, success : function(data){
					if (data.result) {
						// alert('포상정보를 삭제하였습니다.');

						goList();
					} else {
						alert(data.message);
					}
		        }
			});
		}
	}

	function setDefaultPickerValue(objId) {
		$('#' + objId).val('');
	}

	// 담당자 팝업
	function searchUserPopup() {
		global.openLayerPopup({
			popupUrl : '<c:url value="/sycs/user/searchUserPopup.do" />'
			, params : {
				fundGb : 'A'
			}
			, callbackFunction : function(resultObj){
				if (resultObj != null) {
					var f = document.registForm;

			    	f.wrkMembId.value = resultObj.memberId;								// KITANET 아이디
			 	    f.wrkMembNm.value = resultObj.memberNm;								// 성명
			 	    f.wrkDeptId.value = resultObj.deptCd;								// 부서코드
			 	    f.wrkDeptNm.value = resultObj.deptNm;								// 부서명
			 	    f.wrkMembPhone.value = resultObj.telNo;								// 전화번호
			 	    f.wrkMembFax.value = resultObj.faxNo;								// 팩스번호
			 	    f.wrkMembEmail.value = '<c:out value="${user.email}" />';			// E-MAIL
			    }
			}
		});
	}

	function goList() {
		var lf = document.listForm;
		lf.action = '<c:url value="/tdms/tdm/tradeDayRegiste.do" />';
		lf.target = '_self';
		lf.submit();
	}

	function getAwdSpeGradeList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectAwdSpeGradeList.do" />'
			, data : $('#registForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				registeList1Sheet.LoadSearchData({Data: data.awdSpeGradeList});
			}
		});
	}

	function registeList1Sheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('codeListSheet_OnSearchEnd : ', msg);
    	} else {
    		// 추천부문에 볼드 처리
			registeList1Sheet.SetColFontBold('detailnm', 1);
			registeList1Sheet.SelectCell(1, 1);
    	}
    }

	function registeList1Sheet_OnRowSearchEnd(row) {
		if (row > 0) {
			var useYn = registeList1Sheet.GetCellValue(row, 'useYn');

			if (useYn == 'N') {
				registeList1Sheet.SetRowEditable(row, 0);
			}
		}
    }

	function registeList1Sheet_OnSelectCell(oldRow, oldCol, newRow, newCol, isDelete) {
		if (
			registeList1Sheet.ColSaveName(newCol) == 'detailnm'
			|| registeList1Sheet.ColSaveName(newCol) == 'useYn'
			|| registeList1Sheet.ColSaveName(newCol) == 'gradeCd'
		) {
			var index = registeList2Sheet.FilteredRowIndex();

			var duprows = registeList2Sheet.ColValueDupRows('rankNo', {
				'IncludeEmpty' : 0
				, 'StartRow' : index[0]
				, 'EndRow' : index[index.length - 1]
			});

			if (duprows) {
				alert('순위에 중복이 존재합니다.');

				registeList1Sheet.SelectCell(oldRow, oldCol);

				return;
			}

			var useYn = registeList1Sheet.GetCellValue(newRow, 'useYn');

			if (useYn == 'Y') {
				registeList2Sheet.SetFilterValue('masterDetailcd', registeList1Sheet.GetCellValue(registeList1Sheet.GetSelectRow(), 'detailcd'), 1);

				var gradeCd = registeList1Sheet.GetCellValue(newRow, 'gradeCd');

				if (gradeCd == '') {
					registeList2Sheet.SetEditable(0);
				} else {
					registeList2Sheet.SetEditable(1);
				}

				registeList2Sheet.RowTop(2);
			}
		}
	}

	function registeList1Sheet_OnChange(row, col, value, oldValue, raiseFlag) {
		var index = registeList2Sheet.FilteredRowIndex();

		var detailcd = registeList1Sheet.GetCellValue(row, 'detailcd');
		var masterDetailcd = registeList2Sheet.GetCellValue(index[0], 'masterDetailcd');

		if (detailcd == masterDetailcd) {
			if (value == '') {
				registeList2Sheet.SetEditable(0);

				if (index.length) {
					for (var i = 0; i < index.length; i++) {
						registeList2Sheet.SetCellValue(index[i], 'rankNo', '');
					}
				}
			} else {
				registeList2Sheet.SetEditable(1);
			}
		}
	}

	function getAwdSpeRankList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tdms/tdm/selectAwdSpeRankList.do" />'
			, data : $('#registForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				registeList2Sheet.LoadSearchData({Data: data.awdSpeRankList});
			}
		});
	}
</script>