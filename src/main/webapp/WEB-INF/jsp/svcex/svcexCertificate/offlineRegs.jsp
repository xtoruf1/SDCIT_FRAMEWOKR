<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<form id="viewForm" name="viewForm" method="get" onsubmit="return false;">
	<input type="hidden" name="event" value="">

	<!-- 페이지 위치 -->
	<div class="location compact">
		<!-- 네비게이션 -->
		<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
		<!-- 네비게이션 -->
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_primary" onclick="doSearch();">추가</button>
		</div>
	</div>
	<div class="cont_block">
		<table class="formTable">
			<colgroup>
				<col style="width:15%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>무역업고유번호</th>
					<td>
						<input class="form_text w100p" name="memberId" id="memberId" onkeyup="numCheck(this);" onkeypress="doEnter();" type="text" maxlength="8" value="">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

</form>

<script type="text/javascript">
	var f;

	$(document).ready(function(){
		f = document.viewForm;
	});

	//숫자만 입력 가능
	function numCheck(obj){
		var num = obj.value;
		var pattern = /\D/gi;

		if( pattern.test(num)==true ){

			alert("숫자만 입력 가능합니다.");
			obj.value = num.replace(/\D/gi, "");
			obj.focus();
		}
	}//end numCheck

	function doEnter(){
		if( event.keyCode == 13 ) {
			doSearch();
	    }
	}//end doEnter

	function doSearch() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/svcex/svcexCertificate/offlineRegsProcessView.do" />'
			, data : $('#viewForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				if( data.resultView.chkCnt > 0 ){
					f.action = '<c:url value="/svcex/svcexCertificate/offlineRegs2View.do" />';
					f.target = '_self';
					f.submit();
				}else{
					alert("존재하지 않는 무역업 고유번호 입니다.");
				}

			}
		});
	}

</script>
