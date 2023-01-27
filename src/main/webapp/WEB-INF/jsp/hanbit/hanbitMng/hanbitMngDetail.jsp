<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="location compact">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
	<div class="btnGroup ml-auto">
		<button type="button" class="btn_sm btn_primary" onclick="doSave();">저장</button>
	</div>
	<div class="ml-15">
		<button type="button" class="btn_sm btn_secondary" onclick="goList();">목록</button>
	</div>
</div>


<form id="frm" name="frm" method="post">
	<div class="cont_block">
		<input type="hidden" id="traderId" name="traderId" value='<c:out value="${resultInfo.traderId}"></c:out>'>
		<input type="hidden" name="searchAwardRound" value='<c:out value="${pParams.searchAwardRound}"></c:out>'>
		<input type="hidden" name="searchSelectStartDt" value='<c:out value="${pParams.searchSelectStartDt}"></c:out>'>
		<input type="hidden" name="searchSelectEndDt" value='<c:out value="${pParams.searchSelectEndDt}"></c:out>'>
		<input type="hidden" id="nowSelectCount" name="nowSelectCount" value='<c:out value="${pParams.nowSelectCount}"></c:out>'>
		<input type="hidden" id="awardRound" name="awardRound" value='<c:out value="${resultInfo.awardRound}"></c:out>'>
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col/>
				<col style="width:15%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><strong class="point">*</strong> 회차</th>
					<td>
						<input type="text" class="form_text" value='<c:out value="${resultInfo.awardRound}"></c:out>' disabled>
					</td>
					<th scope="row"><strong class="point">*</strong> 사업명</th>
					<td>
						<input type="text" class="form_text w100p" id="awardTitle" name="awardTitle" value='<c:out value="${resultInfo.awardTitle}"></c:out>'>
					</td>
				</tr>
				<tr>
					<th scope="row"><strong class="point">*</strong> 신청기한</th>
					<td>
						<fieldset class="form_group  group_item">
							<div class="datepicker_box group_item">
								<span class="form_datepicker">
									<input type="text" name="regDate" id="regDate" value='<c:out value="${resultInfo.regDate}"></c:out>' class="txt datepicker regDate" title="신청기한" readonly="readonly" />
									<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
								</span>
							</div>

							<select name="regTime" id="regTime" class="form_select group_item">
								<c:set var="timeNm" value="시" />
								<c:forEach items="${timeList}" var="timeList" varStatus="status">
									<option value="<c:out value="${ timeList.code}" />" label="<c:out value="${ timeList.code}${timeNm }" />" <c:if test="${ timeList.code eq resultInfo.regTime}" > selected</c:if> />
								</c:forEach>
							</select>
						</fieldset>
					</td>

					<th scope="row"><strong class="point">*</strong> 선정일</th>
					<td>
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" name="selectionDate" id="selectionDate" value="${resultInfo.selectionDate}" oninput="this.value = this.value.replace(/[^0-9]/g, '');" class="txt datepicker" title="선정일" readonly="readonly" />
								<img src="<c:url value='/images/icon_calender.png' />" class="ui-datepicker-trigger" alt="캘린더" title="캘린더" />
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><strong class="point">*</strong> 수출실적기준</th>
					<td>
						<!-- monthpicker -->
						<div class="datepicker_box">
							<span class="form_datepicker">
								<input type="text" id="exptBaseMonth" name="exptBaseMonth" value="${resultInfo.exptBaseMonth}" class="txt monthpicker" title="수출실적기준" readonly="readonly" />
								<img src="/images/icon_calender.png" onclick="showMonthpicker('exptBaseMonth');" class="ui-monthpicker-trigger" alt="캘린더" title="캘린더" />
							</span>
						</div>
					</td>
					<th scope="row"><strong class="point">*</strong> 선정업체수</th>
					<td>
						<input type="text" class="form_text" id="selectCount" name="selectCount" value="${resultInfo.selectCount}" maxlength="5" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="cont_block">
		<div class="tit_bar">
			<h3 class="tit_block">신청 안내</h3>
		</div>

		<textarea id="infoDscr" name="infoDscr" rows="20" style="width:100%;"><c:out value="${resultInfo.infoDscr}"></c:out></textarea>
	</div>

</form>
<script type="text/javascript">

	var oEditors = [];

	$(document).ready(function(){

		$('.regDate').datepicker({
			dateFormat : 'yy-mm-dd'
			, showMonthAfterYear : true
			// , yearSuffix : '년'
			, dayNamesMin : ['일', '월', '화', '수', '목', '금', '토']
			, monthNamesShort : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
			, monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
			, showOn : 'both'
			, changeYear : true
			, changeMonth : true
			, onSelect : function(dateString, inst) {

				var param = new Date(dateString);
				var paramDate = new Date(param.setMonth(param.getMonth() - 2));
				var getYear = paramDate.getFullYear();
				var getMonth = paramDate.getMonth();

				if(getMonth < 10) {
					getMonth = '0'+ getMonth;
				}

				$('#exptBaseMonth').val(getYear + '-' + getMonth);

			}
		}).next('button').button({
			icons : {
				primary : 'ui-icon-calendar'
			}
			, text : false
		});

		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: infoDscr,
			sSkinURI : '<c:url value="/lib/smarteditor2/SmartEditor2Skin.html" />',
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//예제 코드
				//oEditors.getById["contEditor"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
			},
			fCreator: "createSEditor2"
		});
	});

	function goList() {
		$('#frm').attr('action', '/hanbit/hanbitMng/hanbitMngList.do');
		$('#frm').submit();
	}

	function doSave(){	// 저장

		if(!isValid()) {	// 공백 validation
			return;
		}

		if(!confirm('저장하시겠습니까?')) {
			return;
		}

		var sHTML = oEditors.getById['infoDscr'].getIR();
		$('#infoDscr').val(sHTML);

		var saveData = $('#frm').serializeObject();

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitMng/updateHanbitInfo.do"
			, contentType : 'application/json'
			, data : JSON.stringify(saveData)
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				location.reload();
			}
		});
	}

	function valueChk() {

		var chk = true;

		global.ajax({
			type : 'POST'
			, url : "/hanbit/hanbitMng/selectValueChk.do"
			, data : {'traderId' : $('#traderId').val(),
					  'awardRound' : $('#awardRound').val(),
					  'exptBaseMonth' : $('#exptBaseMonth').val(),
					  'selectCount' : $('#selectCount').val(),
			}
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){

				if(data.statDataCnt <= 0) {
					alert('수출입실적 데이터가 없는 기간입니다.');
					$('#exptBaseMonth').focus();
					chk = false;
					return;
				}

				if(data.chkSelectedYn == 'N') {
					alert('현재 선정된 업체 수보다 기준 업체 수가 적습니다.');
					$('#selectCount').focus();
					chk = false;
					return;
				}
			}
		});

		return chk;
	}

	function isValid() {	// 벨리데이션 체크

		var numChk = /[^0-9]/;

		if($('#awardTitle').val() == '') {
			alert('사업명을 입력해 주세요.');
			$('#awardTitle').focus();
			return false;
		}

		if($('#regDate').val() == '' || $('#regTime').val() == '') {

			alert('신청기한을 입력해 주세요.');

			if($('#regDate').val() == '') {
				$('#regDate').focus();
			}

			if($('#regTime').val() == '') {
				$('#regTime').focus();
			}

			return false;
		}

		if($('#selectionDate').val() == '') {
			alert('선정일을 입력해 주세요.');
			$('#selectionDate').focus();
			return false;
		}

		var regDate = new Date($('#regDate').val());
		var selectionDate = new Date($('#selectionDate').val());

		if(regDate > selectionDate) {
			alert('선정일은 신청기한보다 빠를 수 없습니다.');
			return false;
		}

		if($('#exptBaseMonth').val() == '') {
			alert('수출실적기준을 입력해 주세요.');
			$('#exptBaseMonth').focus();
			return false;
		}

		if($('#selectCount').val() == '') {
			alert('선정인원을 입력해 주세요.');
			$('#selectCount').focus();
			return false;
		} else {
			if(numChk.test($('#selectCount').val())) {
				alert('숫자만 입력해 주세요.');
				$('#selectCount').focus();
				return false;
			}
		}

		if(!valueChk()) {
			return false;
		}

// 		if($('#nowSelectCount').val() > $('#selectCount').val()) {
// 			alert('현재 선정된 업체 수 보다 기준 업체 수가 적습니다.');
// 			return false;
// 		}

		return true;
	}

</script>
