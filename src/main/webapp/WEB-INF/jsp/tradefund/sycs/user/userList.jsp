<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">
<input type="hidden" id="acctId" name="acctId" value="" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:goRegProc();" 	class="btn_sm btn_primary btn_modify_auth">신규</a>
	</div>

	<div class="ml-15">
		<a href="javascript:doClear();" 	class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 	class="btn_sm btn_primary">검색</a>
	</div>
</div>

<div class="cont_block">
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
					<th >부서</th>
					<td>
						<fieldset class="widget">
							<select id="searchDeptCd" name="searchDeptCd" class="form_select"  >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${COM005}" varStatus="status">
									<option value="<c:out value="${item.detailcd}"/>" <c:if test="${item.detailcd eq param.searchDeptCd}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
								</c:forEach>
							</select>
						</fieldset>
					</td>
					<th >권한</th>
					<td>
						<fieldset class="widget">
							<select id="searchAcctTypeId" name="searchAcctTypeId" class="form_select"  >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${acctTypeUseList}" varStatus="status">
									<option value="<c:out value="${item.acctTypeId}"/>" <c:if test="${item.acctTypeId eq param.searchAcctTypeId}">selected="selected"</c:if>><c:out value="${item.acctTypeName}"/></option>
								</c:forEach>
							</select>
						</fieldset>
						<%-- <fieldset class="widget">
							<select id="rightId" name="rightId" class="form_select"  >
								<option value="" >::: 전체 :::</option>
								<c:forEach var="item" items="${rightList}" varStatus="status">
									<option value="<c:out value="${item.rightId}"/>" <c:if test="${item.rightId eq param.acctTypeId}">selected="selected"</c:if>><c:out value="${item.rightName}"/></option>
								</c:forEach>
							</select>
						</fieldset> --%>
					</td>
	            </tr>
				<tr>
					<th >ID</th>
					<td>
						<fieldset class="widget">
							<input type="text" id="searchUserSabun" name="searchUserSabun" value="<c:out value="${param.searchUserSabun}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="사원번호" maxlength="50"  />
						</fieldset>
					</td>
					<th >이름</th>
					<td>
						<fieldset class="widget">
							<input type="text" id="searchUserName" name="searchUserName" value="<c:out value="${param.searchUserName}"/>" onkeydown="onEnter(doSearch);" class="textType form_text w100p" title="이름" maxlength="50" />
						</fieldset>
					</td>
	            </tr>

			</tbody>
		</table>
	</div>
</div>
<!--검색 끝 -->

<div class="cont_block">
	<div class="tbl_opt">
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div>
		<div id="sheet1" class="sheet"></div>
	</div>
<!-- 	<div id="paging" class="paging ibs"></div> -->
</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		getList();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

        ibHeader.addHeader({Header:"Del",          	Type:"Text",     Hidden:1,  Width:50,   Align:"Center",  SaveName:"delCheck" ,   UpdateEdit:false,   InsertEdit:false   });
        ibHeader.addHeader({Header:"Status",       	Type:"Status",   Hidden:1,  Width:80,   Align:"Center",  SaveName:"status"   ,   UpdateEdit:false,   InsertEdit:false   });
        ibHeader.addHeader({Header:"No",          	Type:"Seq",      Hidden:0,  Width:50,   Align:"Center",  SaveName:"no"       ,   UpdateEdit:false,   InsertEdit:false   });
        ibHeader.addHeader({Header:"ID",       		Type:"Text",     Hidden:0,  Width:80,   Align:"Left",    SaveName:"userSabun",   UpdateEdit:false,   InsertEdit:false  });
        ibHeader.addHeader({Header:"Password",     	Type:"Text",     Hidden:1,  Width:80,   Align:"Center",  SaveName:"userPw"   ,   UpdateEdit:false,   InsertEdit:false  });
        ibHeader.addHeader({Header:"☞이름",       	Type:"Text",     Hidden:0,  Width:100,  Align:"Center",  SaveName:"userName" ,   UpdateEdit:false,   InsertEdit:false  });
        ibHeader.addHeader({Header:"ProjectName",  	Type:"Text",     Hidden:1,  Width:150,  Align:"Left",    SaveName:"buseoNm"  ,   UpdateEdit:false,   InsertEdit:false  });
        ibHeader.addHeader({Header:"부서명",       	Type:"Text",     Hidden:0,  Width:90,   Align:"Center",  SaveName:"deptNm"   ,   UpdateEdit:false,   InsertEdit:false , Ellipsis: true  });
        ibHeader.addHeader({Header:"전화번호",     	Type:"Text",     Hidden:0,  Width:100,  Align:"Left",    SaveName:"telNo"    ,   UpdateEdit:false,   InsertEdit:false, Format:"PhoneNo"  });
        ibHeader.addHeader({Header:"휴대폰번호",   		Type:"Text",     Hidden:0,  Width:100,  Align:"Left",    SaveName:"handTelNo",   UpdateEdit:false,   InsertEdit:false , Format:"PhoneNo"  });
        ibHeader.addHeader({Header:"☞E-mail",     	Type:"Text",     Hidden:0,  Width:150,  Align:"Left",    SaveName:"email"    ,   UpdateEdit:false,   InsertEdit:false, Ellipsis: true  });
        ibHeader.addHeader({Header:"등록신청일",   		Type:"Text",     Hidden:0,  Width:130,  Align:"Center",  SaveName:"creDate"  ,   UpdateEdit:false,   InsertEdit:false  });
        ibHeader.addHeader({Header:"acct_id",      	Type:"Text",     Hidden:1,  Width:0,    Align:"Left",    SaveName:"acctId"   ,   UpdateEdit:false,   InsertEdit:false  });
//         ibHeader.addHeader({Header:"승인여부",     	Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  SaveName:"acctTypeNm",   UpdateEdit:false,   InsertEdit:false });

		ibHeader.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "548px");
		ibHeader.initSheet(sheetId);

		sheet1.SetSelectionMode(4);			// 셀 선택 모드 설정

		sheet1.SetColFontBold("userName", 	true);
		sheet1.SetColFontBold("email", 		true);

		sheet1.SetDataLinkMouse("userName", true);
		sheet1.SetDataLinkMouse("email", 	true);

	}

	//초기화
	function doClear(){
		var f = document.form1;
		f.searchUserSabun.value = "";
		f.searchUserName.value = "";
		f.searchDeptCd.options[0].selected = true;
		f.searchAcctTypeId.options[0].selected = true;
	}

	//조회
	function doSearch() {
		getList();
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/sycs/user/selectUserList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet1.LoadSearchData({Data: data.resultList});

			}
		});
	}

	// 사용자 등록 화면 이동
    function goRegProc() {

    	var f = document.form1;
	    f.acctId.value 	= '';

		var url = '<c:url value="/sycs/user/userForm.do" />';

		f.action = url;
		f.target = "_self";
		f.submit();
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}

		var sName = sheet1.ColSaveName(Col);

		if(sName == "userName" ){

		    var f = document.form1;
		    f.acctId.value 	= sheet1.GetCellValue(Row, "acctId");

			var url = '<c:url value="/sycs/user/userFormDetail.do" />';

			f.action = url;
			f.target = "_self";
			f.submit();
		} else if(sName == "email" ){
			if(sheet1.GetCellValue(Row, "email") != ""){
		        location.href = "mailto:" + sheet1.GetCellValue(Row,'email');
		     }
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		for( var i = 1 ; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "cnt") == "미생성"){
				sheet1.SetCellFontColor(i,"cnt",'#ff0000');
			}
		}

		sheet1.ReNumberSeq("desc");
    }

</script>