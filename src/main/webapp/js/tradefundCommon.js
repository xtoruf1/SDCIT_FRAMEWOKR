
/*
	Text : 기본 문자열 데이터 타입
	Status : 행에 대한 트랜잭션 상태를 표현하는 데이터 타입
	DelCheck : 행에 대한 삭제여부를 설정하는 CheckBox 형태 데이터 타입
	CheckBox : CheckBox 데이터 타입
	DummyCheck : 이벤트를 발생하지 않는 CheckBox 데이터 타입
	Radio : 데이터 행 중 하나의 데이터만 선택하는 Radio 데이터 타입
	Combo  :  DropDown 리스트 데이터 타입
	ComboEdit : 편집 및 필터링이 가능한 DropDown 리스트 데이터 타입 (모바일지원안함)
	AutoSum : 합계행에 합계를 표현하는 숫자형 데이터 타입으로, 포맷이 “Integer”, “#,###”, “#,##0” 등의 경우에 한해 소수점 자리를 버림
	Image : 이미지 형태의 데이터 타입
	Int : 정수형 숫자 데이터 타입으로, 값이 실수인 경우 소수점 자리를 버림
	Float : 실수형 숫자 데이터 타입
	Date : 날짜 데이터 타입
	Popup : 우측에 팝업 버튼을 갖는 읽기 전용 문자열 데이터 타입
	Pass: Password 데이터 타입
	Seq: 행의 생성 순서값을 표현하는 데이터 타입
	Html: Html 태그형태를 표현하는 데이터 타입
	Result: 저장 처리 결과를 표시하는 데이터 타입
	Sparkline: 스파크라인 차트를 표현하는 데이터 타입
	Button: 버튼 형태를 표현하는 데이터 타입


	dtData  0   일반 데이터
	dtCheckBox  4   선택 체크 박스
	dtHidden  5   숨겨진 데이터
	dtCombo  6   콤보 형 데이터
	dtComboEdit  7   콤보 형 데이터 + Edit가능
	dtPopup  8   팝업 버튼 형 데이터 + OnPopup 이벤트 발생 + 값에 대한 포멧기능무시
	dtPopupEdit  9   팝업 버튼 형 데이터 + OnPopup 이벤트 발생 + Edit 가능 + 값에 대한 포멧기능무시
	dtAutoSum  12  자동 계산 컬럼
	dtAutoSumEx  13  자동 계산 + 삭제된 행 계산 제외
	dtAutoAvg  14  자동 평균 컬럼
	dtAutoAvgEx  15  자동 평균 + 삭제된 행 계산 제외
	dtPopupFormat  22  팝업 버튼 형 데이터 + OnPopup 이벤트 발생 + 값에대한포멧기능사용
	dtPopupEditFormat 23  팝업 버튼 형 데이터 + OnPopup 이벤트 발생 + Edit 가능 + 값에 대한 포멧기능사용
	dtDummyCheck  24  Dummy 체크박스
 */
	function setFormFromSheet() {
		  var args = arguments;
		  var pNode = args[0];
		  var sheetObj = args[1];
		  var sheetRow = args[2];
		  var valueType = (args[3] != undefined) ? args[3] : true;
// 		  var sheetDt = '0|4|5|6|7|8|9|12|13|14|15|22|23|25';
// 		  var sheetDt = 'Status|DelCheck|Image|Seq|Result|Sparkline|Button';
		  var sheetDt = 'Text|CheckBox|DummyCheck|Radio|Combo|ComboEdit|AutoSum|Int|Float|Date|Html';
		  var saveName, dataType, cellValue, cNode, cNodes;
		  for(var sheetCol = 0; sheetCol <= sheetObj.LastCol(); sheetCol++) {
		    dataType = sheetObj.GetCellProperty(sheetRow, sheetCol, "Type");
		    saveName = sheetObj.ColSaveName(sheetCol);

		    if(!eval('/\\\|?' + dataType + '\\\|?/').test(sheetDt)) {
		      continue;
		    } else if(!saveName) {
		      continue;
		    }

		    if(valueType) {
		      cellValue = sheetObj.GetCellValue(sheetRow, sheetCol);
		    } else {
		      cellValue = sheetObj.GetCellText(sheetRow, sheetCol);
		    }
		    if(saveName == 'BSN_START_DT'){
		    	alert(cellValue);
		    }
		    cNode = getChildNode(pNode, saveName);
		    if(cNode) {
		      //type별 입력
		      switch(cNode.type) {
		        case 'reset':
		        case 'submit':
		        case 'button':
		        case 'hidden':
		        case 'text':
		        case 'password':
		        case 'file':
		        case 'textarea':
		          cNode.value = cellValue;
		          break;

		        case 'checkbox':
		        case 'radio':
		          cNodes = document.getElementsByName(cNode.name);
		          for(var cnt = 0; cnt < cNodes.length; cnt++) {
		          	cNodes[cnt].checked = false;
		          }
		          for(var cnt = 0; cnt < cNodes.length; cnt++) {
		            if(cNodes[cnt].value == cellValue) {
		              cNodes[cnt].checked = true;
		            }
		          }
		          break;

		        case 'select-one':
		          selectOptions = cNode.options;
		          for(var oCnt = 0; oCnt < selectOptions.length; oCnt++) {
		            if(selectOptions[oCnt].value == cellValue) {
		              selectOptions[oCnt].selected = true;
		            }
		          }
		          break;

		        case 'select-multiple':
		          selectOptions = cNode.options;
		          for(var oCnt = 0; oCnt < selectOptions.length; oCnt++) {
		            if(eval('/\\\|?' + selectOptions[oCnt].value + '\\\|?/g').test(cellValue)) {
		              selectOptions[oCnt].selected = true;
		            }
		          }
		          break;

		        default:
		          if(/IBSheet/ig.test(cNode.codeBase)) {
		            //IBSheet
		          } else if(/IBMultiCombo/ig.test(cNode.codeBase)) {
		            //IBMultiCombo
		            if(cNode.GetCount() > 0) {
		              cNode.Code = cellValue;
		            } else {
		              //item이 없을경우 item으로 추가
		              cNode.InsertItem(-1, cellValue, cellValue);
		              cNode.index2 = 0;
		            }

		          } else if(/IBMaskEdit/ig.test(cNode.codeBase)) {
					//IBMaskEdit
		        	  cNode.value = cellValue;

		          } else if(/IBTab/ig.test(cNode.codeBase)) {
		            //IBTab
		          } else if(/IBTree/ig.test(cNode.codeBase)) {
		            //IBTree
		          } else if(/IBUpload/ig.test(cNode.codeBase)) {
		            //IBUpload
		          } else if(cNode.tagName == 'DIV') {
		            //DIV
		            cNode.innerText = cellValue;

		          } else if(cNode.tagName == 'SPAN') {
		            //SPAN
		            cNode.innerText = cellValue;
		          } else if(cNode.tagName == 'TD') {
		            //TD
		            cNode.innerText = cellValue;
		          }
		          break;
		      }//end of switch
		    }//end of if
		  }//end of for
		}



	function getChildNode() {
	  var args = arguments;
	  var pObj = args[0];
	  var cName = args[1];
	  var cNodes, cObj;

	  cObj = document.getElementById(cName);

	  if(!cObj) {
	    cObj = document.getElementsByName(cName)[0];

	    if(!cObj) {
	      cObj = document.getElementsByTagName(cName)[0];
	    }
	  }

	  return cObj;
	}



/**
 * Form안에 속하는 필수항목(Object)들이 모두 입력되었는지를 체크
 * return true : 필수 항목이 입력되지 않은 항목이 존재
 * return false : 필수 항목이 입력되지 않은 항목이 없음
 */
function doValidFormRequired(formObject) {
	var firstValidatedElement = null;
	var isExistValidatedElement = false;
	var msg = '필수항목을 입력 바랍니다.\n\n항목명 : ';
	var ischk = '';

	try {
		for (var i = 0 ; i < formObject.elements.length ; i++) {
	        var formElement = formObject.elements[i];
			var formElementValue = '';

	        switch (formElement.type) {
				case 'text' :
					formElementValue = formElement.value;
					ischk = doCheckMaxSize(formElement);

					break;
	            case 'hidden' :
	            case 'password' :
	            case 'textarea' :
	            	formElementValue = formElement.value;

	            	break;
	            case 'select-one' :
	            	formElementValue = getSelectedValue(formElement);

	            	break;
	            case 'radio' :
	            	formElementValue = getCheckedValue(formElement);

	            	break;
	            case 'checkbox' :
	            	formElementValue = isChecked(formElement);

	            	break;
	            case 'select-multiple' :
	            	formElementValue = isSelected(formElement);

	            	break;
	        }

	        if (formElement.getAttribute('requiredChk') != '' && formElement.getAttribute('required') != null) {
				if (formElementValue == '') {
					isExistValidatedElement = true;
					msg = '필수항목을 입력 바랍니다.\n\n항목명 : ';

		       		if (formElement.title == null)
		       			msg += formElement.name;
		       		else
		       			msg += formElement.title;

		       		alert(msg);
		       		formElement.focus();

			    	return false;
				}
	        }
	        if (ischk != '') {
	        	msg = '항목의 길이를 확인 바랍니다.\n\n항목명 : ';
	        	isExistValidatedElement = true;

	        	if (firstValidatedElement == null)
	        		firstValidatedElement = formElement;

	        	if (formElement.title == null)
	       			msg += formElement.name;
	       		else
	       			msg += formElement.title;

	        	msg += ischk;

	        	alert(msg);
	        	formElement.focus();

	        	return false;
	        }
	    }

	    return true;
	} catch(errorObject) {
		showErrorDlg('common_js.doValidFormRequired()', errorObject);
    }
}

function doCheckMaxSize(obj){
	var max_length = obj.getAttribute("maxlength");
	var real_length = doValidLength(obj.value);
	var msg = "";

	if( max_length == null ){
		return "";
	}

	if(real_length > max_length){
		msg = "\n   => 최대: " + max_length + "\n   => 현재: " +real_length;
	}
	return msg;
}

/**
 * 한글, 영문 포함해서 byte수 계산
 */
function doValidLength(str) {

	var i = 0;
	var li_byte = 0;
	var ls_one_char = "";

	for(i=0 ; i<str.length ; i++) {
		ls_one_char = str.charAt(i);
		if(escape(ls_one_char).length > 4)
			li_byte += 2;
		else
			li_byte += 1;
	}

	return li_byte;
}


/**
 * 선택된 콤보박스의 값을 리턴한다.
 * 파라미터)>obj: 객체 이름
 * 사용예)> getSelectedValue(f.selected);
 */
function getSelectedValue(obj) {
    if( obj != null && obj.options != null && obj.selectedIndex != -1 ) {
		return obj.options[obj.selectedIndex].value;
    }
    else {
    	return "";
    }
}

/**
 * 선택된 라디오 버튼값을 리턴한다.
 * 파라미터)> obj:객체이름
 * 사용예)> getCheckedValue(f.radiobt);
 */
function getCheckedValue(obj) {

    if( obj != null ) {
        for( var i = 0 ; i < obj.length ; i++ ) {
            if( obj[i].checked == true ) {
				return obj[i].value;
            }
        }
        return "";
    }
    return "";
}

/**
 * 체크박스에 체크된 항목이 있는지 여부를 리턴한다.
 * 파라미터)> obj, row개수(화면상의 타이틀), row위치
 * 사용예)> isChecked(f.checked);
 */
function isChecked(obj) {
	try {
		if (obj == null)
			return false;

		var isChecked = false;

		if (obj.length == null) {
			isChecked = obj.checked;
		} else {
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked) {
					isChecked = true;

					break;
				}
			}
		}

		return isChecked;
	} catch(errorObject) {
		showErrorDlg(errorObject);
	}
}

function isSelected(obj) {
    if( obj != null ) {
        for( var i = 0 ; i < obj.length ; i++ ) {
            if( obj.options[i].selected == true ) {
				return true;
            }
        }
    }
    return false;
}


function doKeyPressEvent(obj, type, ev) {
	ev = (window.netscape) ? ev : event;
	var evCode = (window.netscape) ? ev.which : ev.keyCode;

	try {
		if (evCode == 13) {
			return;
		}

		if (type == 'NUMBER') {
			if ((evCode < 48) || (evCode > 57)) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'NUMBER_MINUS') {
			if (((evCode < 48) || (evCode > 57)) && ((evCode != 45))) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
			if (evCode == 45 && obj.value.indexOf('-') > 0) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'FLOAT') {
			if (((evCode < 48) || (evCode > 57)) && ((evCode != 46))) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
			if (evCode == 46 && obj.value.indexOf('.') > 0) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'FLOAT_MINUS') {
			if (((evCode < 48) || (evCode > 57)) && ((evCode != 46) && (evCode != 45))) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
			if (evCode == 46 && obj.value.indexOf('.') > 0) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
			if (evCode == 45 && obj.value.indexOf('-') > 0) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'ID') {
			if ((evCode < 48) || ((evCode > 57) && ((evCode < 65) || (evCode > 128)))) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'TEL') {
			if (((evCode < 48) || (evCode > 57)) && (evCode != 45)) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		} else if (type == 'ENGLISH') {
			if (evCode < 65) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			} else if (((evCode > 90) && (evCode < 97)) || (evCode > 122)) {
				if (window.netscape)
					ev.preventDefault();
				else
					ev.returnValue = false;
			}
		}
	} catch(errorObject) {
		showErrorDlg(errorObject);
	}
}

function getSaveDataSheetList(formId, saveJson, listName){

	if(!listName){
		listName = 'dataList';
	}

	var ccf = $('#' + formId ).serializeObject();
	//var saveJson = sheetObj.GetSaveJson();

	if (saveJson.data.length) {
		var map = {};
		var list = [];
		$.each(saveJson, function(key1, value1) {
			map = {};
			$.each(value1, function(key2, value2) {
				map = value2;
				list.push(map);
			});

			ccf[listName] = list;
		});
	}

	return ccf;
}

function dlgLastDay(sYM)
{
  if(sYM.length != 6)
  {
    alert("정확한 년월을 입력하십시오.");
    return;
  }

  daysArray = new makeArray(12);    // 배열을 생성한다.
  for (var i=1; i<8; i++)
  {
    daysArray[i] = 30 + (i%2);
  }
  for (var i=8; i<13; i++)
  {
    daysArray[i] = 31 - (i%2);
  }
  var sYear = sYM.substring(0, 4) * 1;
  var sMonth = sYM.substring(4, 6) * 1;

  if (((sYear % 4 == 0) && (sYear % 100 != 0)) || (sYear % 400 == 0))
  {
  daysArray[2] = 29;
  }
  else
  {
  daysArray[2] = 28;
  }
 //alert(daysArray[sMonth].toString());
  return daysArray[sMonth].toString();
}


function setEmptyValue(targetNm){
	$(targetNm).find('input').val('')

}


/**
 * 년월일을 얻는다.
 * 사용예)> var timeval = getDate();
 */
function getDate() {

	var date = new Date();

	var year  = date.getYear();
	var month = date.getMonth() + 1;
	var day   = date.getDate();

	if( year < 1000 ) {
		year += 1900;
	}

	if( month < 10 ) {
		month = "0" + month;
	}

	if( day < 10 ) {
		day = "0" + day;
	}

	return "" + year + month+ day;
}

/**
 * 콤보박스의 특정 Value를 선택
 * 파라미터)> obj : 객체 이름, val : 값
 * 사용예)> setSelect(f.selected, '123');
 */
function setSelect(obj, val) {
	if (obj != null && val != null) {
		for (var i = 0; i < obj.length; i++) {
			if (obj.options[i].value == val) {
				obj.options[i].selected = true;
				if (document.createEventObject) {
					obj.fireEvent('onchange');
				} else {
					var evt = document.createEvent('HTMLEvents');
					evt.initEvent('onchange', true, true);
					!obj.dispatchEvent(evt);
                }

                break;
            }
        }
    }
}

/**
 * 라디오 버튼 선택한다.
 * 파라미터)> obj : 객체이름, val : 값
 * 사용예)> getCheckedValue(f.radiobt, 5);
 */
function setRadio(obj, val) {
	if (obj != null && val != null) {
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].value == val) {
				obj[i].checked = true;
				if (document.createEventObject) {
					obj[i].fireEvent('onClick');
				} else {
					var evt = document.createEvent('HTMLEvents');
					evt.initEvent('onClick', true, true);
					!obj[i].dispatchEvent(evt);
                }

                break;
			}
		}
	}
}

/**
 * 선택된 항목만 읽게
 * 파라미터)> obj:객체이름
 * 사용예)> setReadOnlySelect(f.selected);
 */
function setReadOnlySelect(obj) {
	if (obj != null) {
		var options = obj.options[obj.selectedIndex];

		for (var i = obj.length - 1; i >= 0; i--) {
			obj.options[i] = null;
        }

		obj.options[0] = options;
	}
}

/**
 * 모든 라디오 버튼 Disabled 속성 조정
 * 파라미터)> obj:객체이름, disValue: true,false
 * 사용예)> setRadioDisabledAll(f.radiobt,true);
 */
function setRadioDisabledAll(obj, disValue) {
	setCheckDisabledAll(obj, disValue);
}

/**
 * 모든 체크박스 Disabled 속성 조정
 * 파라미터)> obj:객체이름, disValue: true,false
 * 사용예)> setCheckDisabledAll(f.checked, true);
 */
function setCheckDisabledAll(obj, disValue) {
	if (obj != null) {
		if (obj.length == null) {
			obj.disabled = disValue;
		} else {
			for (var i = 0 ; i < obj.length ; i++) {
				obj[i].disabled = disValue;
			}
		}
	}
}

/**
 * 라디오 버튼 Disabled 속성 조정
 * 파라미터)> obj:객체이름, val:값, disValue: true,false
 * 사용예)> setRadioDisabled(f.radiobt,5,true);
 */
function setRadioDisabled(obj, val, disValue) {
	if (obj != null && val != null) {
		if (obj.length == null) {
			if (obj.value == val) {
				obj.disabled = disValue;
			}
		} else {
			for (var i = 0 ; i < obj.length ; i++) {
				if (obj[i].value == val) {
					obj[i].disabled = disValue;
				}
			}
		}
	}
}

/**
 * 선택된 콤보박스의 Text를  리턴한다.
 * 파라미터)> obj: 객체 이름
 * 사용예)> getSelectedText(f.selected);
 */
function getSelectedText(obj) {
	if (obj != null) {
		return obj.options[obj.selectedIndex].text;
	}
}

function fnIbsheetExcelDown(sheetObj, typeno, exceltitle, head_cnt, paper_size, column_skip, RowSkipList, pMode, pMerge) {
	if (sheetObj.RowCount() <= 0) {
		alert('다운로드할 데이터가 없습니다.');

		return;
	}

	if (column_skip == null || column_skip == undefined) {
		column_skip = '';
	}

	if (RowSkipList == null || RowSkipList == undefined) {
		RowSkipList = '';
	}

	var downCols = '';

	if (column_skip) {
		downCols = fnGetExcelDownCols(sheetObj, pMode, column_skip);
	}

	// RowSkipList 변수는 어떤 역할을 하는지 명확히 알 수 없어 일단 로직에서 스킵
	var param = 'exceltitle=' + exceltitle + '&head_cnt=' + head_cnt + '&paper_size=' + paper_size + '&data_cnt=' + sheetObj.RowCount();

	var today = new Date();

	var year = today.getFullYear();			// 년도
	var month = today.getMonth() + 1;		// 월
	var date = today.getDate();				// 날짜
	var todayStr = year + '-' + (month > 9 ? month : '0' + month) + '-' + (date > 9 ? date : '0' + date);

	var excelOpt = {
		FileName : exceltitle + '_' + todayStr + '.xlsx'
		, Mode : pMode
		, Merge : pMerge ? 1 : 0
		// , ReportXMLURL : '/excel/excelDown"+typeno+".do?' + encodeURI(param)
		, TreeLevel : false
		, DownCols : downCols
		, AutoSizeColumn : true
		, CheckBoxOnValue :'Y'
		, CheckBoxOffValue : ' '
		, SheetDesign : 1
	};

	sheetObj.Down2Excel(excelOpt);
}

/**
 *	엑셀 다운로드시 skip column 목록을 받아 down columns 목록을 리턴한다(구분자 '|')
 *  Param :
 *  sheetObj - 시트 객체
 *  pSkipCols - 스킵 컬럼 목록('|' 로 연결된 문자열(savename))
 *  pHideColDown - 숨긴 컬럼 다운로드 여부(true / false)
 */
function fnGetExcelDownCols(sheetObj, pMode, pSkipCols){
	var downCols = "";
	var hideColDown = true;

	debugger;

	if(pMode == -1 || pMode == 2){
		hideColDown = false;
	}

	for (var i = 0; i <= sheetObj.LastCol(); i++) {

		if(!hideColDown && sheetObj.GetColHidden(i)){	//숨긴 열은 다운로드 하지 않음
			continue;
		}

		downCols += "|" + sheetObj.ColSaveName(i);
	}


	if(downCols == ""){
		return "";
	}

	downCols += "|";	//문자열의 마지막을 파이프로 막아 앞뒤가 파이프로 막힌 형태의 문자열을 생성


	//스킵 컬럽 목록 처리
	if(pSkipCols){
		var skipColsArr = pSkipCols.split("|");

		for (var i = 0; i < skipColsArr.length; i++) {
			downCols = downCols.replace("|" + skipColsArr[i] + "|", "|");
		}

	}


	//양쪽 끝 '|' 제거
	downCols = downCols.substr(1);
	downCols = downCols.slice(0, -1);


	return downCols;

}

/*
	1) 회사전화 또는 회사팩스인경우는 그대로 입력(이 함수를 사용하지 않는다.)
	2) 1)을 제외한 경우 정규식을 통과한 경우는 '-' 가 있던 없던 그대로 입력
	3) 2) 정규식을 통과하지 못한 경우는 숫자만 남겨놓고(replace) 입력

	obj : 인풋박스 또는 조회객체의 ID 또는 클래스명
	objGb : 인풋박스인지 조회객체인지 여부(W : 인풋박스, R : 조회객체)
*/
function setExpPhoneNumber(obj, objGb) {
	var regExp =/^(02|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064|010|011|012|016|017|018|019)(\d{3,4})(\d{4})$/;

	obj.forEach(function(data, idx){
		if (objGb == 'W') {
			// 포커스가 주어지면 숫자만 남긴다.
			$(document).on('focus', data, function(){
				var replaceObj = $(this).val().replace(/[^0-9]/g, '');
				$(this).val(replaceObj);
			});

			$(document).on('blur', data, function(){
				var replaceObj = $(this).val().replace(/[^0-9]/g, '');

				// 1544-8282 등등
				if (replaceObj.length == 8) {
					$(this).val(replaceObj.replace(/^(\d{4})(\d{4})$/, '$1-$2'));
				} else {
					if (regExp.test(replaceObj)) {
						$(this).val(replaceObj.replace(regExp, '$1-$2-$3'));
					} else {
						$(this).val(replaceObj);
					}
				}
			});

			$(data).trigger('blur');
		} else if (objGb == 'R') {
			$(document).on('keyup', data, function(){
				var replaceObj = $(this).text().replace(/[^0-9]/g, '');

				// 1544-8282 등등
				if (replaceObj.length == 8) {
					$(this).text(replaceObj.replace(/^(\d{4})(\d{4})$/, '$1-$2'));
				} else {
					if (regExp.test(replaceObj)) {
						$(this).text(replaceObj.replace(regExp, '$1-$2-$3'));
					} else {
						$(this).text(replaceObj);
					}
				}
			});

			$(data).trigger('keyup');
		}
	});
}