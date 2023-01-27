function searchFilterCodeList(codeList, searchId, appendId){
	var returnList = '';

	returnList = "<option value=\"\">전체</option>";
	$.each(codeList, function(i,item){
		returnList += '<option value="'+ item.cdId+'"'
		if(item.cdId == searchId){
			returnList += 'selected';
		}
		returnList += '>'+ item.cdNm +'</option>';
	});


	$('#'+appendId).empty();
	$('#'+appendId).append(returnList);
}

//전문분야 (계층형)
function itemStepList(tblSheet){
	var jsonListData = [];

	global.ajax({
		type:"post",
		url:"/tradeSOS/com/mtiCodeListAjax.do",
		data:$('#itemForm').serializeArray(),
		async:false,
		success:function(data){
			jsonListData = data.resultList;
			$('#itemPop .tab_cont .step').empty();
			$('#itemPop .tab_cont .step').append('<strong>총</strong> ' + ' '+data.cnt+' 건');

			tblSheet.LoadSearchData({Data: jsonListData}, {Wait: 0});
		}
	});


	//loadSearchDataGrid('mySheet', jsonListData);
}

//전문분야(키워드)
function itemKeyList(tblSheet2){
	var jsonListData = [];

	global.ajax({
		type:"post",
		url:"/tradeSOS/com/mtiCodeAllListAjax.do",
		data:$('#itemForm').serializeArray(),
		async:false,
		success:function(data){
			jsonListData = data.resultList;

			if(jsonListData != null) {
				tblSheet2.LoadSearchData({Data: jsonListData}, {Wait: 0});
				$('#itemPop .tab_cont .allItem').empty();
				$('#itemPop .tab_cont .allItem').append('<strong>총 </strong> ' + ' '+data.cnt+' 건');
			} else {																				//목록이 없는 경우
				tblSheet2.LoadSearchData({Data: ""}, {Wait: 0});
				$('#itemPop .tab_cont .allItem').empty();
				$('#itemPop .tab_cont .allItem').append('<strong>총 </strong> ' + ' '+0+' 건');
			}
		}
	});
	//loadSearchDataGrid('mySheet2', jsonListData);
}

//컨설턴트검색
function dataConsultList(tblSheet3){
	var jsonListData = [];

	global.ajax({
		type:"post",
		url:"/tradeSOS/com/consultantListAjax.do",
		data:$('#popForm').serializeArray(),
		async:false,
		success:function(data){
			jsonListData = data.resultList;
			tblSheet3.LoadSearchData({Data: jsonListData}, {Wait: 0});
		}
	});
	//loadSearchDataGrid('mySheet3', jsonListData);
}




//국가
function countryList(tblSheet4){
	var jsonListData = [];

	global.ajax({
		type:"post",
		url:"/tradeSOS/com/popup/ctrCodeListAjax.do",
		data:$('#countryForm').serializeArray(),
		async:false,
		success:function(data){
			jsonListData = data.resultList;
			//selectbox
			var selectHtml = '<option value="">전체</option>';
			$.each(data.relCodeList,function(i,item){
				selectHtml += '<option value="'+ item.relCode+'"'
				if(item.relCode == data.searchVO.searchRelCodePop){
					selectHtml += 'selected';
				}
				selectHtml += '>'+ item.relName +'</option>';
			});

			$('#searchRelCodePop').empty();
			$('#searchRelCodePop').append(selectHtml);
			//count
			$('#countryCount').empty();


			$('#searchPRelNmPop').val(data.searchVO.searchPRelNmPop);

			if(data.resultList != null)															//목록이 있는 경우
			{
				tblSheet4.LoadSearchData({Data: jsonListData}, {Wait: 0});
				$('#countryCount').html('총 <span style="color: orange;">' + global.formatCurrency(data.cnt) + '</span> 건');
			} else {																				//목록이 없는 경우
				tblSheet4.LoadSearchData({Data: ""}, {Wait: 0});
				$('#countryCount').html('총 <span style="color: orange;">' + global.formatCurrency(data.cnt) + '</span> 건');
			}

		}
	});
}

//외국어 통번역 > 컨설턴트검색
function expertList(){
	var jsonListData = [];

	$.ajax({
		type:"post",
		url:"/tradeSOS/com/expertListAjax.do",
		data:$('#expertForm').serializeArray(),
		async:false,
		success:function(data){
			if(data.flag){
				jsonListData = data.resultList;

				//selectbox
				searchFilterCodeList(data.languageList,data.searchVO.layerPopLanguage,'layerPopLanguage');
				searchFilterCodeList(data.regionList,data.searchVO.layerPopRegion,'layerPopRegion');
				loadSearchDataGrid('expertSearchPop', jsonListData);
			}

		}
	});

}

function fnNumber(){
	if((event.keyCode<45)||(event.keyCode>57 || event.keyCide > 45 || event.keyCode <48) || (event.keyCode == 47))
		event.returnValue=false;
}

// 숫자 3자리수마다 콤마(,) 찍기 ##################################################
function formatComma(num, pos) {

	if (!pos) pos = 0;  //소숫점 이하 자리수
	var re = /(-?\d+)(\d{3}[,.])/;

	var strNum = stripComma(num.toString());
	var arrNum = strNum.split(".");

	arrNum[0] += ".";

	while (re.test(arrNum[0])) {
		arrNum[0] = arrNum[0].replace(re, "$1,$2");
	}

	if (arrNum.length > 1) {
		if (arrNum[1].length > pos) {
			arrNum[1] = arrNum[1].substr(0, pos);
		}
		return arrNum.join("");
	}
	else {
		return arrNum[0].split(".")[0];
	}
}




function clearDate(targetId){
	$("#"+targetId).val("");
}
function fnResetForm(){
	location.reload();
}