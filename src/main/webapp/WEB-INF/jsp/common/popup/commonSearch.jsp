<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="modal-content">
	<div class="popContinent">
		<div class="popTit">
			<h4>전문분야 찾기</h4>
			<span>(복수선택 가능합니다.)</span>
		</div>
		<div class="modalWrap">
			<div class="regCtg">
				<div class="inner continent">
					<h5>대륙 선택</h5>
					<section>
						<ul id="articleData1">
							<c:forEach var="item" items="${continentList}" varStatus="status">
								<li>
									<label class="cstChk">
										<input type="checkbox" id="popupContinentCd_${item.attr1}" name="popupContinentCd" value="${item.attr1}" onclick="showCountryList(this);" /><span>${item.codeNm}</span>
									</label>
								</li>
							</c:forEach>
							<li>
								<label class="cstChk">
									<input type="checkbox" id="allSelect" name="allSelect" value="ALL" onclick="showCountryList(this);" /><span>전세계</span>
								</label>
							</li>
						</ul>
					</section>
				</div>
				<div class="inner nation">
					<h5>국가 선택</h5>
					<section class="scroll mCustomScrollbar _mCS_16 mCS-autoHide">
						<div id="mCSB_16" class="mCustomScrollBox mCS-minimal mCSB_vertical mCSB_outside" >
							<div id="mCSB_16_container" class="mCSB_container">
							</div>
						</div>
					</section>
				</div>
			</div>
			<div id="completeBtn" class="btnAlign">
				<span class="aCenter">
					<button type="button" onclick="saveSelectObject();" class="btnBlue">선택완료</button>
				</span>
			</div>
		</div>
	</div>
	<button type="button" onclick="closePopup();" class="btnClose" style="border: 0px;">닫기</button>
</div>
<div class="overlay"></div>
<script type="text/javascript">
	function showCountryList(checkObj) {
		var checkedVal = $(checkObj).val();

		if (checkObj.checked) {
			if (checkedVal == 'ALL') {
				$('#mCSB_16_container').children().remove();

				$('input[name="popupContinentCd"]').each(function(){
					$(this).prop('checked', false);
					$(this).prop('disabled', true);
				});
			} else {
				var listUrl = '';
				<c:choose>
					<c:when test="${param.openGb eq 'report'}">
						listUrl = '<c:url value="/common/popup/report/selectCountryList.do" />';
					</c:when>
					<c:when test="${param.openGb eq 'market'}">
						listUrl = '<c:url value="/common/popup/market/selectCountryList.do" />';
					</c:when>
				</c:choose>
				global.ajax({
					type : 'POST'
					, url : listUrl
					, data : {
						continentCd : checkedVal
					}
					, dataType : 'json'
					, async : true
					, spinner : false
					, success : function(data){
						var list = '';

						list += '<dl id="resultCd_' + checkedVal + '">';
						list += '	<dt>';
						list += '		<span>' + $(checkObj).next('span').text() + '</span>';
						list += '	</dt>';
						list += '	<dd>';
						list += '		<ul>';

						var resultList = data.resultList;
						for (var i = 0; i < resultList.length; i++) {
							list += '			<li>';
							list += '				<label class="cstChk">';
							list += '					<input type="checkbox" id="popupCountryCd_' + resultList[i].code + '" name="popupCountryCd" value="' + resultList[i].code + '"><span>' + resultList[i].codeNm + '</span>';
							list += '				</label>';
							list += '			</li>';
						}

						list += '		</ul>';
						list += '	</dd>';
						list += '</dl>';

						$('#mCSB_16_container').append(list);
						$('#mCSB_16').mCustomScrollbar();
					}
				});
			}
		} else {
			if (checkedVal == 'ALL') {
				$('input[name="popupContinentCd"]').each(function(){
					$(this).prop('disabled', false);
				});
			} else {
				$('#resultCd_' + checkedVal).remove();
			}
		}
	}

	function saveSelectObject() {
		if ($('#allSelect').is(':checked')) {
			$('#continentNm').val('전체');
			$('#continentCd').val($('#allSelect').val());

			$('#countryNm').val('전체');
			$('#countryCd').val($('#allSelect').val());
		} else {
			var continentNms = $('input[name="popupContinentCd"]:checked').map(function(){
				return $(this).next('span').text();
			}).get().join(',');

			$('#continentNm').val(continentNms);

			var continentCds = $('input[name="popupContinentCd"]:checked').map(function(){
				return this.value;
			}).get().join(',');

			$('#continentCd').val(continentCds);

			var countryNms = $('input[name="popupCountryCd"]:checked').map(function(){
				return $(this).next('span').text();
			}).get().join(',');

			$('#countryNm').val(countryNms);

			var countryCds = $('input[name="popupCountryCd"]:checked').map(function(){
				return this.value;
			}).get().join(',');

			$('#countryCd').val(countryCds);
		}

		closePopup();
	}

	function closePopup() {
		$('#${param.targetPopup}').children().remove();
		$('#${param.targetPopup}').removeClass('open');
	}
</script>