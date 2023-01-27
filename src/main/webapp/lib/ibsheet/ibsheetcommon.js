var	IBSheetConfig = function() {
    /*
        AutoFitColWidth: 컬럼 너비 자동 조정 시점 설정
        DeferredVScroll: 세로 스크롤에 대한 지연 처리
        VscrollMode: 세로스크롤바 표시 설정
        SearchMode: 조회 모드(0 일반, 1 클라이언트페이징, 2 lazy, 3 실시간(스크롤) 4 서버페이징
        SizeMode: 0 설정된 높이값, 1 스크롤없이 높이자동설정, 2 스크롤없이 너비자동설정, 3 스크롤없이 높이/너비자동설정, 4 설정한 높이 이전까지 스크롤없이 자동설정
    */
	this.cfg	=	{
        AutoFitColWidth: "resize|init|colhidden|rowtransaction|colresize",
        DeferredVScroll: 1,
        DeferredHScroll: 1,
        VscrollMode : 0,
        ColResize: false,
        SelectionRowsMode: 1,
        SearchMode: 2,
        SizeMode: 0,
        UseHeaderActionMenu: false,
        MouseHoverMode: 2,
        NoFocusMode : false,
        FrozenCol: 0
    };
    /*
        HeaderCheck: 전체체크표시여부
    */
	this.mode	=	{Sort: 0, ColResize: false, ColMove: false, HeaderCheck: true};
}

function initGrid(obj, sheetId, width, height) {
    var gridWidth = '';
    var gridHeight = '';
    if(typeof width == 'number') {
        gridWidth = String(width)+'px';
    } else if(typeof width == 'string' && width.toString().indexOf('px') < 0 && width.toString().indexOf('%') < 0) {
        gridWidth = String(width)+'px'; 
    } else {
        gridWidth = width;
    }
    if(typeof height == 'number' && height.toString().indexOf('px') < 0 && width.toString().indexOf('%') < 0) {
        gridHeight = String(height)+'px';
    } else {
        gridHeight = height;
    }
    createIBSheet2(obj, sheetId, gridWidth, gridHeight);
}

function setGridConfig(sheetId, pHeaders, pConfig, pMode, pTopHeader) {
    var headers = [];
    pHeaders.forEach(function(item) {
        headers.push(item['Header']);
    });

    var	iBSheetConfig = new IBSheetConfig();
    var mode = iBSheetConfig.mode;
    if(pMode != null && typeof pMode == 'object') {
        for(var key in pMode) {
            mode[key] = pMode[key];
        }
    }
    var sheetObj = (new Function ('return '+sheetId))();
    var initHeaders = [];
    if(pTopHeader!=null && pTopHeader.length > 0) {
        pTopHeader.forEach(function(item){
            var arrTopHeader = [];
            item.forEach(function(innerItem){
                arrTopHeader.push(innerItem['Header']);
            });
            initHeaders.push({Text: arrTopHeader.join('|'), Align: "Center", ColMove: mode['ColMove'], ColResize: mode['ColResize']});
        });
    }
    initHeaders.push({Text: headers.join('|'), Align: "Center", ColMove: mode['ColMove'], ColResize: mode['ColResize']});
    sheetObj.InitHeaders(initHeaders, mode);
    sheetObj.InitColumns(pHeaders);

    var config = iBSheetConfig.cfg;
    if(pConfig != null && typeof pConfig == 'object') {
        for(var key in pConfig) {
            config[key] = pConfig[key];
        }
    }
    sheetObj.SetConfig(config);

    if(pMode.hasOwnProperty('editable')) {
        sheetObj.SetEditable(pMode['editable']);
    }
    sheetObj.SetFocusEditMode(false);
    if(pConfig != null && pConfig.hasOwnProperty('MergeSheet')) {
        sheetObj.SetMergeSheet(pConfig['MergeSheet']);
    }
}

/**
 * IBSHeet 생성
 * 상태 컬럼 추가(pMode['statusColHidden'] hidden 여부)
 * @param {*} obj 
 * @param {*} sheetId 
 * @param {*} pHeaders 
 * @param {*} width 
 * @param {*} height 
 * @param {JSON} pConfig 
 * @param {JSON} pMode      editable(수정가능), statusHidden(상태컬럼Hidden), statusWidth(상태컬럼너비), delCheckName(삭제체크컬럼명), delCheckWidth(삭제체크컬럼너비)
 */
function createGrid(obj, sheetId, pHeaders, width, height, pConfig, pMode) {
    var addHeader = [];
    var topHeader = [];
    var statusHidden = (pMode.hasOwnProperty('statusColHidden') && pMode['statusColHidden'])?true:false;
    var statusWidth = (pMode.hasOwnProperty('statusColWidth'))?pMode['statusColWidth']:30;
    addHeader.push({Type: "Status", 	Header: "상태", 	SaveName: "STATUS", 	Align: "Center", 	Width: statusWidth,      Hidden: statusHidden});
    if(Array.isArray(pHeaders[0])) {    // 헤더가 2차원 이상인 경우
        var sliceHeader = pHeaders.slice(0, pHeaders.length-1);
        sliceHeader.forEach(function(item, index){
            item.splice(0, 0, {Header: "상태"});
            topHeader.push(item);
        });
        for (var i = 0; i < pHeaders[pHeaders.length-1].length; i++) {
            addHeader.push(pHeaders[pHeaders.length-1][i]);
        }
    } else {
        for (var i = 0; i < pHeaders.length; i++) {
            addHeader.push(pHeaders[i]);
        }
    }
    initGrid(obj, sheetId, width, height);
    setGridConfig(sheetId, addHeader, pConfig, pMode, topHeader);
}

function createCheckGrid(obj, sheetId, pHeaders, width, height, pConfig, pMode) {
    var addHeader = [];
    var topHeader = [];
    var statusHidden = (pMode.hasOwnProperty('statusColHidden') && pMode['statusColHidden'])?true:false;
    var statusWidth = (pMode.hasOwnProperty('statusColWidth'))?pMode['statusColWidth']:30;
    var delCheckName = (pMode.hasOwnProperty('delCheckName'))?pMode['delCheckName']:'';
    var delCheckWidth = (pMode.hasOwnProperty('delCheckWidth'))?pMode['delCheckWidth']:30;
    addHeader.push({Type: "DelCheck", 	Header: delCheckName,   SaveName: "delCheck", 	Align: "Center", 	Width: delCheckWidth});
    addHeader.push({Type: "Status", 	Header: "상태", 	    SaveName: "STATUS", 	Align: "Center", 	Width: statusWidth,      Hidden: statusHidden});
    if(Array.isArray(pHeaders[0])) {    // 헤더가 2차원 이상인 경우
        var sliceHeader = pHeaders.slice(0, pHeaders.length-1);
        sliceHeader.forEach(function(item, index){
            item.splice(0, 0, {Header: delCheckName});
            item.splice(0, 0, {Header: "상태"});
            topHeader.push(item);
        });
        for (var i = 0; i < pHeaders[pHeaders.length-1].length; i++) {
            addHeader.push(pHeaders[pHeaders.length-1][i]);
        }
    } else {
        for (var i = 0; i < pHeaders.length; i++) {
            addHeader.push(pHeaders[i]);
        }
    }
    initGrid(obj, sheetId, width, height);
    setGridConfig(sheetId, addHeader, pConfig, pMode);
}

/**
 * 데이터 바인딩
 * @param {string} sheetId 
 * @param {ARRAY(JSON)} jsonListData  
 */
function loadSearchDataGrid(sheetId, jsonListData) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.LoadSearchData({'Data': jsonListData});
}

/**
 * ROW 추가
 * @param {string} sheetId 
 * @param {number} rowIndex     추가위치(-1: 마지막라인) 
 * @param {JSON} jsonData       기본 값 
 */
function dataInsertGrid(sheetId, rowIndex, jsonData) {
    var sheetObj = (new Function ('return '+sheetId))();
    var dataIndex = sheetObj.DataInsert(rowIndex);
    for (var key in jsonData) {
        sheetObj.SetCellValue(dataIndex, key, jsonData[key]);
    }
}

/**
 * ROW 삭제
 * rowIndex 없는 경우, selection 을 이용
 * @param {string} sheetId 
 * @param {number|string} rowIndex  2건 이상 삭제 시 1|3|5, null: 선택ROW
 * @param {Boolean} forceDelete     row 삭제여부(기본값: 삭제상태처리) 
 */
function rowDeleteGrid(sheetId, rowIndex, forceDelete) {
    var sheetObj = (new Function ('return '+sheetId))();
    if(sheetObj.GetColWidth('rowCheck') > -1) { // rowCheck 컬럼의 존재여부 확인
        rowIndex = sheetObj.FindCheckedRow('rowCheck');
    } else if(typeof rowIndex == undefined || rowIndex == null) {
        rowIndex = sheetObj.GetSelectRow();
    }
    if(typeof rowIndex == 'string' && rowIndex.indexOf('|') > -1) {
        if(typeof forceDelete == 'boolean' && forceDelete) {
            sheetObj.RowDelete(rowIndex);
        } else {
            rowIndex.split('|').forEach(function(item) {
                sheetObj.SetCellValue(item, 'STATUS', 'D');
            });
        }
    } else {
        if((typeof forceDelete == 'boolean' && forceDelete) || sheetObj.GetCellValue(rowIndex, 'rowStatus')=='I') {
            sheetObj.RowDelete(rowIndex);
        } else {
            sheetObj.SetCellValue(rowIndex, 'STATUS', 'D');
            sheetObj.SetCellFont("FontStrike", rowIndex, 1, rowIndex, sheetObj.LastCol(), true);
        }
    }
}

/**
 * 체크 선택된 row를 삭제 상태로 변경
 * @param sheetId
 * @param checkCol
 */
function setCheckedRowStatusDelete(sheetId, checkCol) {
    var sheetObj = (new Function ('return '+sheetId))();
    var rowIndex = sheetObj.FindCheckedRow(checkCol);
    rowIndex.split('|').forEach(function(row) {
        sheetObj.SetCellValue(row, 'STATUS', 'D');
    });
}

/**
 * Cell 값 변경
 * @param {string} sheetId 
 * @param {JSON} jsonData 
 * @param {number} rowIndex 대상 ROW INDEX, null: 선택ROW 
 */
function setCellValueGrid(sheetId, jsonData, rowIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    if(typeof rowIndex == undefined || rowIndex == null) {
        rowIndex = sheetObj.GetSelectRow();
    }
    for (var key in jsonData) {
        sheetObj.SetCellValue(rowIndex, key, jsonData[key]);
    }
}

/**
 * Cell 값 조회
 * @param {string} sheetId 
 * @param {number} rowIndex 
 * @param {string} saveNAme 컬럼명 
 * @returns 
 */
function getCellValueGrid(sheetId, rowIndex, saveNAme) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.GetCellValue(rowIndex, saveNAme);
}

/**
 * 선택한 row data 조회
 * @param {string} sheetId 
 * @param {number} rowIndex 
 * @returns {Array<JSON>} Array
 */
function getSelectRowData(sheetId, rowIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    if(sheetObj.GetColWidth('rowCheck') > -1) { // rowCheck 컬럼의 존재여부 확인
        rowIndex = sheetObj.FindCheckedRow('rowCheck');
    } else if(typeof rowIndex == undefined || rowIndex == null) {
        rowIndex = sheetObj.GetSelectRow();
    }
    var rowList = [];
    if(typeof rowIndex == 'string' && rowIndex.indexOf('|')) {
        rowIndex.split('|').forEach(function(item) {
            rowList.push(sheetObj.GetRowData(item));
        });
    } else {
        rowList.push(sheetObj.GetRowData(rowIndex));
    }
    return rowList;
}

/**
 * ROW 상태 
 * @param {string} sheetId 
 * @param {string} status 상태 I, D, U, D|U: 삭제,수정 모두
 * @returns 
 */
function getStatusRow(sheetId, status) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.FindStatusRow(status);
}

/**
 * Row 상태로 데이터 조회
 * @param {string} sheetId 
 * @param {string} status 
 * @returns 
 */
function getStatusRowData(sheetId, status) {
    var sheetObj = (new Function ('return '+sheetId))();
    var rowIndex = getStatusRow(sheetId, status);
    var rowList = [];
    if(typeof rowIndex == 'string' && rowIndex.indexOf(';')) {
        rowIndex.split(';').forEach(function(item) {
            rowList.push(sheetObj.GetRowData(item));
        });
    } else {
        rowList.push(sheetObj.GetRowData(rowIndex));
    }
    return rowList;
}

/**
 * 저장 목록 조회(validation 호출)
 * @param sheetId
 * @returns {string|array} string: 에러코드, array: 저장데이터
 */
function getSaveJsonGrid(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    var result = sheetObj.GetSaveJson();
    if(result.hasOwnProperty('Code')) {
        return [];
    }
    return result['data'];
}

/**
 * 선택취소
 * (rowCheck 유무에 따라 방식이 다름)
 * @param {string} sheetId 
 */
function clearSelectionGrid(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    if(sheetObj.GetColWidth('rowCheck') > -1) { // rowCheck 컬럼의 존재여부 확인
        var rowIndex = sheetObj.FindCheckedRow('rowCheck');
        rowIndex.split('|').forEach(function(item) {
            sheetObj.SetCellValue(item, 'rowCheck', 0);
        });
    } else {
        sheetObj.ClearSelection();
    }
}

/**
 * 선택 지정
 * @param {string} sheetId 
 * @param {string} rowIndex 
 * @param {string/number} colIndex 인덱스번호 / 컬럼명(SaveName)
 */
function setSelectCellGrid(sheetId, rowIndex, colIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.SelectCell(rowIndex, colIndex);
}

function findTextGrid(sheetId, colIndex, searchText) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.FindText(colIndex,searchText);
}

/**
 * 행 카운트
 * @param {string} sheetId 
 * @returns row count
 */
function getSearchRowCount(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.SearchRows();
}

/**
 * 그리드 행 초기화
 * @param {string} sheetId
 * @param {number} Row
 */
function setResetRowGrid(sheetId, Row) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.ReturnData(Row);
}

/**
 * 그리드 초기화
 * @param {string} sheetId 
 */
function setResetGrid(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    var updateRows = getStatusRow(sheetId, "U|D");
    if(updateRows != null) {
        updateRows.split(';').forEach(function(item) {
            sheetObj.ReturnData(item);
        });
    }
    var insertRows = getStatusRow(sheetId, "I");
    if(insertRows != null) {
        sheetObj.RowDelete(insertRows.replace(/;/g, '|'));
    }
}

/**
 * 수정여부 확인
 * @param {string} sheetId 
 * @returns 
 */
function isDataModifiedGrid(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    return (sheetObj.IsDataModified() > 0);
}

/**
 * col index 로 savename을 조회
 * @param sheetId
 * @param colIndex
 * @returns {*}
 */
function colSaveNameGrid(sheetId, colIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.ColSaveName(colIndex);
}

/**
 * row 데이터 조회
 * @param sheetId
 * @param rowIndex
 * @returns {*}
 */
function getRowDataGrid(sheetId, rowIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    return sheetObj.GetRowData(rowIndex);
}

/**
 * validate 시 실패처리
 * @param sheetObj
 */
function setValidateFail(sheetId) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.ValidateFail(1);
}

/**
 *
 * @param {string} sheetId
 * @param {number|string} colIndex
 * @returns {boolean} 중복항목이 있는 경우 true
 */
function colValueDupGrid(sheetId, colIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    return (sheetObj.ColValueDup(colIndex))==-1?false:true;
}

/**
 * 편집 가능/불가능 수정
 * @param sheetId
 * @param rowIndex
 * @param colIndex
 * @param editable
 */
function setCellEditableGrid(sheetId, rowIndex, colIndex, editable) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.SetCellEditable(rowIndex, colIndex, editable);
}

/**
 *
 * @param sheetId
 * @param colIndex
 */
function colDeleteGrid(sheetId, colIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    sheetObj.ColDelete(colIndex);
}

/**
 * 지정한 col index 에 언더라인, 커서를 처리한다.
 * @param sheetId
 * @param colIndex
 */
function setCellLink(sheetId, colIndex) {
    var sheetObj = (new Function ('return '+sheetId))();
    var rowCount = sheetObj.GetDataLastRow();
    for(var i=1; i <= rowCount; i++) {
        sheetObj.SetCellCursor(i, colIndex, 'Pointer');
        sheetObj.SetCellFontUnderline(i, colIndex, 1);
    }
}

/**
 * JSON -> urlencoded, form 전송을 위한 변환
 * @param {JSON} jsonData 
 * @returns 
 */
function jsonToUrlencoded(jsonData) {
    var result = [];
    if(Array.isArray(jsonData)) {
        jsonData.forEach(function(rows){
            for (var key in rows) {
                result.push(key + "=" + encodeURIComponent(rows[key]));
            }
        });
    } if(typeof jsonData == 'object') {
        for (var key in jsonData) {
            if (jsonData.hasOwnProperty(key)) {
                result.push(key + "=" + encodeURIComponent(jsonData[key]));
            }                  
        }
    }
    return result.join("&");
}

/**
 * URL 합치는 기능
 * @param {string} url 
 * @param {string} addUrl 
 * @returns 
 */
function urlAppend(url, addUrl) {
    if(addUrl == null || addUrl==undefined || addUrl=='') {
        return url;
    }
    if(typeof url == 'string' && url.length > 1) {
        url = url + '&' + addUrl;
    } else {
        url = addUrl;
    }
    return url;
}

/**
* JSON body request
* @param {string} actionUrl 
* @param {string} event
* @param {JSON|ARRAY} jsonData
* @param {Function|string} callBack
 */
function submitJsonRequest(actionUrl, event, jsonData, callBack) {
    var paramJsonData = {};
    if(event != null && event != '') {
        paramJsonData['event_sdcit'] = event;
    }
    for(key in jsonData) {
        paramJsonData[key] = jsonData[key];
    }
    $.ajax({
        url: actionUrl,
        contentType: "application/x-www-form-urlencoded;",
        type: "post",
        data: JSON.stringify(paramJsonData),
        dataType: "json",
        success: function (data) {
            console.log(data);
            if(typeof callBack=='function') {
                callBack(data);
            } else if(typeof callBack=='string') {
                window[callBack](data);
            }
        },
        error: function (jqXHR, textStatus) {
            console.log(jqXHR.status, textStatus)
        }
    });
}

/**
 * form, json 통합전송
 * @param actionUrl
 * @param event
 * @param formObject
 * @param jsonData
 * @param {Function|string} callBack
 */
function submitFormNJsonRequest(actionUrl, event, formObject, jsonData, callBack) {
    var paramJsonData = {};
    if(event != null && event != '') {
        paramJsonData['event_sdcit'] = event;
    }
    var formJsonData = formDataToJson(formObject);
    for(key in formJsonData) {
        paramJsonData[key] = formJsonData[key];
    }
    for(key in jsonData) {
        paramJsonData[key] = jsonData[key];
    }
    $.ajax({
        url: actionUrl,
        contentType: "application/json;",
        type: "post",
        data: JSON.stringify(paramJsonData),
        dataType: "json",
        success: function (data) {
            console.log(data);
            if(typeof callBack=='function') {
                callBack(data);
            } else if(typeof callBack=='string') {
                window[callBack](data);
            }
        },
        error: function (jqXHR, textStatus) {
            console.log(jqXHR.status, textStatus)
        }
    });
}

function formDataToJson(formObject) {
    if( formObject == null ) {
        return "";
    }
    var formElement = '';
    var jsonData = {};
    try {
        for( i = 0 ; i < formObject.elements.length ; i++ ) {
            formElement = formObject.elements[i];

            if( formElement.name == "event" )
                continue;

            switch( formElement.type ) {
                case 'text' :
                case 'select-one' :
                case 'hidden' :
                case 'password' :
                case 'textarea' :
                    jsonData[formElement.name] = formElement.value;
                    break;
                case 'radio' :
                    if(formElement.checked) {
                        jsonData[formElement.name] = formElement.value;
                    }
                    break;
                case 'checkbox' :
                    if(formElement.checked) {
                        jsonData[formElement.name] = formElement.value;
                    }
                    break;
                case 'select-multiple' :
                    var multiValue = '';
                    for( var j = 0 ; j < formElement.length ; j++ ) {
                        if( formElement.options[j].selected == true ) {
                            multiValue = multiValue + '|' + formElement.options[j].value;
                        }
                    }
                    jsonData[formElement.name] = multiValue.substring(1);
                    break;
            }
        }
        return jsonData;
    }
    catch(errorObject) {
        showErrorDlg("formData2QueryString()", errorObject);
    }
}

/**
 * AJAX용 페이징
 * @param divId
 * @param callback
 * @param currentPageNo
 * @param totalRecordCount
 * @param recordCountPerPage
 * @param pageSize
 */
function gSetPaging(divId, callback, currentPageNo, totalRecordCount, recordCountPerPage, pageSize) {
    if(totalRecordCount==0) {
        $('#'+divId).html('');
        return;
    }
    var totalPage = Math.ceil(totalRecordCount/recordCountPerPage);    // 총 페이지 수
    var pageGroup = Math.ceil(currentPageNo/pageSize);    // 페이지 그룹

    var last = pageGroup * pageSize;    // 화면에 보여질 마지막 페이지 번호

    if(last > totalPage)
        last = totalPage;

    var first = pageGroup * pageSize - (pageSize - 1);    // 화면에 보여질 첫번째 페이지 번호

    if(first < 1)
        first = 1;

    var next = (first+pageSize)>totalPage?currentPageNo+1:first+pageSize;

    var prev = (first-pageSize)<1?1:first-pageSize;

    var divPage = "<ul class=\"clearfix\">";
    divPage += "<li class=\"page\"><button type=\"button\" onclick=\"goPage(1);\" class=\"page_first\">처음으로</button></li>";
    if(first-pageSize > 0)
        divPage += "<li class=\"page\"><button type=\"button\" href=\"javascript:;\" onclick=\"goPage("+prev+");\" class=\"page_prev\">앞으로</button></li>";
    else
        divPage += "<li class=\"page\"><button type=\"button\" href=\"javascript:;\" class=\"page_prev\">앞으로</button></li>";

    divPage += "<span>";
    for(var i=first; i <= last; i++){
        if(currentPageNo == i)
            divPage += " <li class=\"on\"><a href=\"javascript:;\">"+i+"</a></li>";
        else
            divPage += " <li><a href=\"javascript:;\" onclick=\"goPage("+i+");\">"+i+"</a></li>";
    }
    divPage += "</span>";

    if((first+pageSize) < totalPage)
        divPage += "<li class=\"page\"><button type=\"button\" href=\"javascript:;\" onclick=\"goPage("+next+");\" class=\"page_next\">뒤로</></li>";
    else
        divPage += "<li class=\"page\"><button type=\"button\" href=\"javascript:;\" class=\"page_next\">뒤로</button></li>";

    divPage += "<li class=\"page\"><button type=\"button\" href=\"javascript:;\" onclick=\"goPage("+totalPage+");\" class=\"page_last\">끝으로</button></li>";
    divPage += "</ul>";

    goPage = function(pageIndex) {
        if(typeof callback=='function') {
            callback(pageIndex);
        } else if(typeof callback=='string') {
            window[callback](pageIndex);
        }
    }

    $('#'+divId).html(divPage);    // 페이지 목록 생성
}

/**
 * Ibsheet Excel Download
 * @param sheetName
 * @param fileName
 * @param params
 */
function gIbSheetExcel(sheetName,fileName,params){
    let today = new Date();

    let year = today.getFullYear(); // 년도
    let month = today.getMonth() + 1;  // 월
    let date = today.getDate();  // 날짜
    let todayStr = year + '-' + month + '-' + date;
    if (typeof fileName == "undefined"  || fileName == ""){
        fileName="excel"
    }
    if (typeof params == "undefined" || params == ""){
        params = {
            "FileName": fileName+"_"+todayStr+".xlsx",
            "SheetName": "Sheet1",
            "SheetDesign": 1,
            "Merge": 1,
            "CheckBoxOnValue": "Y",
            "CheckBoxOffValue": "N",
            "HiddenColumn" : 1
        };
    }

    sheetName.Down2Excel(params);
}

/**
 * 편집할 수 없는 컬럼 색 변경(시트에 편집 여부가 동일하지 않고 혼재 되어 있을시)
 * @param {string} sheetId 
 */
function notEditableCellColor(sheetId, rowObj) {
	var sheetObj = (new Function ('return ' + sheetId))();
    
    var index = sheetObj.LastCol();
	
	var temp = 0;
	var colorYn = false;
	for (var i = 0; i <= index; i++) {
		// 컬럼이 히든이면 계산에서 제외
		if (sheetObj.GetColHidden(i)) {
			continue;
		}
		
		var type = sheetObj.GetCellProperty(rowObj, i, 'Type');
		
		// 컬럼 타입이 삭제는 계산에서 제외
		if (type == 'DelCheck' || type == 'CheckBox') {
			continue;
		}
		
		var edit = sheetObj.GetCellEditable(rowObj, i);
		
		if (i > 0 && edit != temp) {
			colorYn = true;
		}
		
		temp = edit;
	}
	
	if (colorYn) {
		for (var i = 0; i <= index; i++) {
			var edit = sheetObj.GetCellEditable(rowObj, i);
		
			if (!edit) {
				sheetObj.SetColBackColor(i, '#f6f6f6');
			}
		}
	}
}