<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" 	uri="http://www.springframework.org/tags/form" %>

<form id="form1" name="form1" method="post" method="get" onsubmit="return false;">

<input type="hidden" id="svrId"     name="svrId"	value="" />
<input type="hidden" id="applyId"   name="applyId"	value="" />
<input type="hidden" id="bsNo"     	name="bsNo"    	value="" />

<!-- 페이지 위치 -->
<div class="location compact">
	<!-- 네비게이션 -->
   <jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
   <!-- 네비게이션 -->
	<div class="ml-auto">
		<a href="javascript:doExcel();" 		class="btn_sm btn_primary">엑셀 다운</a>
	</div>
	<div class="ml-15">
		<a href="javascript:doClear();" 		class="btn_sm btn_secondary">초기화</a>
		<a href="javascript:doSearch();" 		class="btn_sm btn_primary">검색</a>
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
				<th scope="row">기금융자 명</th>
				<td>
					<div class="field_set flex align_center">
						<span class="form_search w100p fundPopup">
							<input type="hidden" id="searchSvrId" name="searchSvrId" value="<c:out value="${searchSvrId}"/>" />
							<input type="text" class="form_text " placeholder="기금융자" title="기금융자" id="searchTitle" name="searchTitle" maxlength="150" readonly="readonly" onkeydown="onEnter(doSearch);" value="<c:out value="${searchTitle}"/>" />
							<button class="btn_icon btn_search" title="기금융자 검색" onclick="goFundPopup()"></button>
						</span>
						<button type="button" class="ml-8" onclick="setEmptyValue('.fundPopup')" ><img src="<c:url value='/images/admin/btn_clear.png' />" alt="초기화"></button>
					</div>
				</td>
				<th scope="row">지역본부</th>
				<td>
					<fieldset class="widget">
						<select id="searchTradeDept" name="searchTradeDept" class="form_select"  >
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="" >::: 전체 :::</option>
							</c:if>

							<c:forEach var="item" items="${COM001}" varStatus="status">
							<c:if test='${user.fundAuthType eq "ADMIN"}'>
								<option value="<c:out value="${item.chgCode01}"/>" ><c:out value="${item.detailnm}"/></option>
							</c:if>

							<c:if test='${user.fundAuthType ne "ADMIN"}'>
								<c:if test="${item.chgCode01 eq searchTradeDept}"> >
									<option value="<c:out value="${item.chgCode01}"/>" <c:if test="${item.chgCode01 eq searchTradeDept}">selected="selected"</c:if>><c:out value="${item.detailnm}"/></option>
								</c:if>
							</c:if>
							</c:forEach>
						</select>
					</fieldset>
				</td>
            </tr>
            <tr>
            	<th scope="row">표시항목</th>
				<td colspan="3">
					<label class="label_form">
						<input type="radio" class="form_radio" name="showDiv" value="1" checked>
						<span class="label">담당본부</span>
					</label>

					<label class="label_form">
						<input type="radio" class="form_radio"  name="showDiv" value="2">
						<span class="label">담보별</span>
					</label>

					<label class="label_form">
						<input type="radio" class="form_radio" name="showDiv" value="3" >
						<span class="label">은행별</span>
					</label>
				</td>
            </tr>
		</tbody>
	</table>
</div>
<!--검색 끝 -->

<div class="cont_block mt-20">
	<div class="tbl_opt">
		<!-- 전체 게시글 -->
		<div id="totalCnt" class="total_count"></div>
	</div>
	<div style="width: 100%;">
		<div id="sheet1" class="sheet"></div>
		<div id="sheet2" class="sheet" style="display:none"></div>
		<div id="sheet3" class="sheet" style="display:none"></div>
	</div>
	<div id="paging" class="paging ibs"></div>
</div>

</div>

</form>

<script type="text/javascript">

	$(document).ready(function(){
		initIBSheet();
		initAssuranceIBSheet();
		initBankIBSheet();
		doSearch();
	});

	// Sheet의 초기화 작업
	function initIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",      	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no"             });
		ibHeader.addHeader({Header:"",         	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"chk"            });
		ibHeader.addHeader({Header:"기금융자코드", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"applyId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당본부",    	Type:"Combo",     Hidden:false,  Width:130,  Align:"Center",  ColMerge:true,   SaveName:"tradeDept",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM001.chgCode01}"/>", ComboText: "<c:out value="${saCOM001.detailnm}"/>"  });
		ibHeader.addHeader({Header:"부서별업체수", 	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:false,  SaveName:"cnt",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"coNmKor",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"대표자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"ceoNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"무역업고유번호",	Type:"Text",      Hidden:true,   Width:250,  Align:"Center",  ColMerge:false,  SaveName:"bsNo",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"사업자번호",  	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  ColMerge:false,  SaveName:"industryNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"자금용도",    	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"moneyUse",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자희망은행", 	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"mainBankNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담보제공방식", 	Type:"Text",      Hidden:false,  Width:130,  Align:"Left",    ColMerge:false,  SaveName:"mortgage",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"membNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자전화",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membTel",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자팩스",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membFax",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"담당자EMAIL",	Type:"Text",      Hidden:false,  Width:200,  Align:"Left",    ColMerge:false,  SaveName:"membEmail",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true });
		ibHeader.addHeader({Header:"상태값",     	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"st",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"추천일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"신청일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"reqDate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"등급",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"금리",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"융자추천금액", 	Type:"AutoSum",   Hidden:false,  Width:100,  Align:"Right",   ColMerge:false,  SaveName:"mortgageAmount",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차융자금액", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"1차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차융자금액", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount2",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });
		ibHeader.addHeader({Header:"2차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt2",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden',UseHeaderActionMenu: false, Page: 50, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet1";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "570px");
		ibHeader.initSheet(sheetId);
		sheet1.SetSelectionMode(4);

		sheet1.ShowSubSum([{StdCol:"tradeDept", SumCols:"5|22", Sort:true, ShowCumulate:false, CaptionCol:0, OtherColText:"tradeDept=소    계;coNmKor=|cnt|"}]);

	}

	function initAssuranceIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",      	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no"             });
		ibHeader.addHeader({Header:"",          Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"chk"            });
		ibHeader.addHeader({Header:"기금융자코드", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"svrId",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"applyId",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담보제공방식", 	Type:"Text",      Hidden:false,  Width:130,  Align:"Center",  ColMerge:true,   SaveName:"mortgage",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당본부",    	Type:"Combo",     Hidden:false,  Width:130,  Align:"Center",  ColMerge:false,  SaveName:"tradeDept",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM001.chgCode01}"/>", ComboText: "<c:out value="${saCOM001.detailnm}"/>"    });
		ibHeader.addHeader({Header:"부서별업체수", 	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:false,  SaveName:"cnt",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"회사명",      Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"coNmKor",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , Ellipsis:true });
		ibHeader.addHeader({Header:"대표자",      Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"ceoNmKor",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"무역업고유번호",	Type:"Text",      Hidden:true,   Width:250,  Align:"Center",  ColMerge:false,  SaveName:"bsNo",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"사업자번호",  	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  ColMerge:false,  SaveName:"industryNo",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"자금용도",    	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"moneyUse",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true   });
		ibHeader.addHeader({Header:"융자희망은행", 	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"mainBankNm",    CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"membNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자전화",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membTel",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자팩스",   	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membFax",       CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자EMAIL", Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"membEmail",     CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"상태값",      Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"st",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"추천일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"신청일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"reqDate",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"등급",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"levelGb",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"금리",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"interestRate",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"융자추천금액", 	Type:"AutoSum",   Hidden:false,  Width:100,  Align:"Right",   ColMerge:false,  SaveName:"mortgageAmount",    CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"1차융자금액",  	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount",   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"1차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"2차융자금액", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount2",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"2차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt2",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden', Page: 50, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet2";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "570px");
		ibHeader.initSheet(sheetId);
		sheet2.SetSelectionMode(4);

		sheet2.ShowSubSum([{StdCol:"mortgage", SumCols:"6|22", Sort:true, ShowCumulate:false, CaptionCol:0, OtherColText:"mortgage=소    계;coNmKor=|cnt|"}]);
	}

	function initBankIBSheet(){
		var	ibHeader = new IBHeader();

		ibHeader.addHeader({Header:"No",     	Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"no"                });
		ibHeader.addHeader({Header:"",          Type:"Text",      Hidden:true,   Width:60,   Align:"Center",  ColMerge:true,   SaveName:"chk"               });
		ibHeader.addHeader({Header:"기금융자코드",  Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"svrId",             CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"접수번호",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:true,   SaveName:"applyId",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"융자희망은행", 	Type:"Text",      Hidden:false,  Width:100,  Align:"Center",  ColMerge:true,   SaveName:"mainBankNm",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"은행지점",    	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:true,   SaveName:"mainBankBranchNm",  CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당본부",    	Type:"Combo",     Hidden:false,  Width:130,  Align:"Center",  ColMerge:false,  SaveName:"tradeDept",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, ComboCode: "<c:out value="${saCOM001.chgCode01}"/>", ComboText: "<c:out value="${saCOM001.detailnm}"/>"    });
		ibHeader.addHeader({Header:"부서별업체수", 	Type:"Text",      Hidden:true,   Width:100,  Align:"Center",  ColMerge:false,  SaveName:"cnt",               CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"회사명",     	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"coNmKor",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 , Ellipsis:true });
		ibHeader.addHeader({Header:"대표자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"ceoNmKor",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"무역업고유번호",	Type:"Text",      Hidden:true,   Width:250,  Align:"Center",  ColMerge:false,  SaveName:"bsNo",              CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"사업자번호",  	Type:"Text",      Hidden:false,  Width:120,  Align:"Center",  ColMerge:false,  SaveName:"industryNo",        CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"자금용도",    	Type:"Text",      Hidden:false,  Width:150,  Align:"Left",    ColMerge:false,  SaveName:"moneyUse",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담보제공방식", 	Type:"Text",      Hidden:false,  Width:130,  Align:"Left",    ColMerge:false,  SaveName:"mortgage",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자",     	Type:"Text",      Hidden:false,  Width:80,   Align:"Center",  ColMerge:false,  SaveName:"membNm",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자전화",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membTel",           CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자팩스",  	Type:"Text",      Hidden:false,  Width:100,  Align:"Left",    ColMerge:false,  SaveName:"membFax",           CalcLogic:"",   Format:"PhoneNo",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"담당자EMAIL",	Type:"Text",      Hidden:false,  Width:210,  Align:"Left",    ColMerge:false,  SaveName:"membEmail",         CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30, Ellipsis:true  });
		ibHeader.addHeader({Header:"상태값",     	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"st",                CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"추천일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDate",          CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"신청일자",    	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"reqDate",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"등급",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"levelGb",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"금리",      	Type:"Text",      Hidden:false,  Width:50,   Align:"Center",  ColMerge:false,  SaveName:"interestRate",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"융자추천금액", 	Type:"AutoSum",   Hidden:false,  Width:100,  Align:"Right",   ColMerge:false,  SaveName:"mortgageAmount",        CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"1차융자금액",  	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount",       CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"1차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt",            CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"2차융자금액",  	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"defntAmount2",      CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30  });
		ibHeader.addHeader({Header:"2차융자일자", 	Type:"Text",      Hidden:true,   Width:250,  Align:"Left",    ColMerge:false,  SaveName:"recdDt2",           CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:false,   InsertEdit:true,   EditLen:30 });

		ibHeader.setConfig({AutoFitColWidth: 'colhidden', Page: 50, SearchMode: 4, DeferredVScroll: 1, SizeMode: 4, MouseHoverMode: 2, NoFocusMode : 0, MergeSheet: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var sheetId = "sheet3";
		var container = $("#"+sheetId)[0];
		createIBSheet2(container, sheetId, "100%", "570px");
		ibHeader.initSheet(sheetId);
		sheet3.SetSelectionMode(4);

		sheet3.ShowSubSum([{StdCol:"mainBankNm", SumCols:"7|23", Sort:true, ShowCumulate:false, CaptionCol:0, OtherColText:"mainBankNm=소    계;coNmKor=|cnt|"}]);
	}

	//초기화
	function doClear(){
		var f = document.form1;
		if( '<c:out value="${user.fundAuthType}"/>' == 'ADMIN' ){
			setSelect(f.searchTradeDept, '');
		}else {
			setSelect(f.searchTradeDept, '<c:out value="${searchTradeDept}"/>');
		}
		setSelect(f.searchSt, "");
	}

	//조회
	function doSearch() {

		var f = document.form1;

		$('#sheet1').hide();
		$('#sheet2').hide();
		$('#sheet3').hide();

		var showDiv = $("input[name='showDiv']:checked").val();

		if(showDiv == '1'){
			$('#sheet1').show();
			getList();
		}else if(showDiv == '2'){
			$('#sheet2').show();
			getAssuranceList()
		} else {
			$('#sheet3').show();
			getBankList();
		}
	}

	// 목록 가져오기
	function getList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectRecommendedList.do" />'
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

	function getAssuranceList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectRecommendedAssuranceList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet2.LoadSearchData({Data: data.resultList});
			}
		});
	}

	function getBankList() {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tfms/ssm/selectRecommendedBankList.do" />'
			, data : $('#form1').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				$('#totalCnt').html('총 <span>' + global.formatCurrency(data.resultCnt) + '</span> 건');
				sheet3.LoadSearchData({Data: data.resultList});
			}
		});
	}

	//기금융자 검색
	function goFundPopup(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tfms/lms/fundPopup.do" />'		//tfms/lms/popFundList.screen
// 			, params : {
// 				speChk : 'Y'
// 			}
			, callbackFunction : function(resultObj){
				$("input[name=searchSvrId]").val(resultObj.svrId);		//기금융자코드
				$("input[name=searchTitle]").val(resultObj.title);		//기금융자명
				doSearch();
			}
		});
	}

	//엑셀다운
	function doExcel(){
        var f = document.form1;

        var showDiv = $("input[name='showDiv']:checked").val();

		if(showDiv == "1"){
			var rowSkip = sheet1.LastRow();
	        if(sheet1.RowCount() > 0){
	        	downloadIbSheetExcel(sheet1, '추천명단_담당본부', '');
	        }else{
	        	alert("다운로드 할 항목이 없습니다.");
	        }
		}else if(showDiv == "2"){
			var rowSkip = sheet2.LastRow();
	        if(sheet2.RowCount() > 0){
	        	downloadIbSheetExcel(sheet2, '추천명단_담보별', '');
	        }else{
	        	alert("다운로드 할 항목이 없습니다.");
	        }
		} else {
			var rowSkip = sheet3.LastRow();
	        if(sheet3.RowCount() > 0){
	        	downloadIbSheetExcel(sheet3, '추천명단_은행별', '');
	        }else{
	        	alert("다운로드 할 항목이 없습니다.");
	        }
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
		if (Row == 0) {
			 return ;
		}
	}

	function sheet1_OnSearchEnd(code, msg) {
		sheet1.SetCellAlign(sheet1.LastRow(), 'coNmKor', "Right");
		sheet1.SetSumText(0,"coNmKor", global.formatCurrency(sheet1.RowCount('R')));
		sheet1.SetSumText(0,"tradeDept","총    계");
	}

	function sheet2_OnSearchEnd(code, msg) {
		sheet2.SetCellAlign(sheet2.LastRow(), 'coNmKor', "Right");
		sheet2.SetSumText(0,"coNmKor", global.formatCurrency(sheet2.RowCount('R')));
		sheet2.SetSumText(0,"mortgage","총    계");
	}

	function sheet3_OnSearchEnd(code, msg) {
		sheet3.SetCellAlign(sheet3.LastRow(), 'coNmKor', "Right");
		sheet3.SetSumText(0,"coNmKor", global.formatCurrency(sheet3.RowCount('R')));
		sheet3.SetSumText(0,"mainBankNm","총    계");
	}

</script>
