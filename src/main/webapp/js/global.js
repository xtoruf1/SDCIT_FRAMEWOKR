var global = {};		// namespace 선언

global.ajax = function(paramObj) {
	/*
	if (paramObj.spinner) {
		$('#loading_wrapper').show();
	}
	*/

	$.ajax({
		type : paramObj.type
		, url : paramObj.url
		, traditional : paramObj.traditional ? paramObj.traditional : false
		, param : paramObj.param
		, contentType : paramObj.contentType ? paramObj.contentType : 'application/x-www-form-urlencoded; charset=UTF-8'
		, data : paramObj.data
		, dataType : paramObj.dataType
		, async : paramObj.async
		, success : function(data){
			if (typeof paramObj.success == 'function') {
				paramObj.success(data);
			}
		}
		, error : function(request, status, error){
			var message = '작업 중 에러가 발생했습니다.';
			if (request.responseJSON && request.responseJSON.errorInfo) {
				message = request.responseJSON.errorInfo.message;
			}
			if (typeof paramObj.error == 'function') {
				paramObj.error(request, status, error, message);
			} else {
				alert(message);
			}
		}
		, complete : function(){
			/*
			if (paramObj.spinner) {
				$('#loading_wrapper').hide();
			}
			*/
	    }
    });
};

/**
 * 함수명 : global.ajaxSubmit
 * 설명 : 공통 ajaxSubmit - jquery.form 플러그인을 이용해 form 객체를 submit
 */
global.ajaxSubmit = function($form, paramObj) {
	if (paramObj.spinner) {
		$('#loading_wrapper').show();
	}

	// 폼 내부의 onlynumber inputbox의 콤마 제거
	$form.find('input._bmFormatNumber').each(function(index){
		if ($(this).hasClass('_bmFormatNumber')) {
     		$(this).val($(this).val().replace(/,/g, ''));
     	}
	});

	$form.ajaxForm({
		type : paramObj.type
		, url : paramObj.url
		, enctype : paramObj.enctype
		, dataType : paramObj.dataType
		, contentType : paramObj.contentType ? paramObj.contentType : false
		, processData : paramObj.processData ? paramObj.processData : false
		, success: function(data){
			if (typeof paramObj.success == 'function') {
				paramObj.success(data);
			}
		}
		, error: function(request, status, error){
			var message = '작업 중 에러가 발생했습니다.';
			if (request.responseJSON && request.responseJSON.errorInfo) {
				message = request.responseJSON.errorInfo.message;
			}

			if (typeof paramObj.error == 'function') {
				paramObj.error(request, status, error, message);
			} else {
				alert(message);
			}
		}
		, complete : function(){
			if (paramObj.spinner) {
				$('#loading_wrapper').hide();
			}
		}
	}).submit();

	// submit 후 다시 마스킹
	$form.find('input._bmFormatNumber').each(function(index) {
		if ($(this).hasClass('_bmFormatNumber')) {
			$(this).val(global.numberWithCommas($(this).val()));
		}
	});
};

// 자바스크립트로 input에 값을 넣을 때 사용
global.numberWithCommas = function(n) {
	var parts = n.toString().split('.');
	return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',') + (parts[1] ? '.' + parts[1] : '');
}

/**
 * 문자열을 금액표기로 포맷을 적용한다.<br>
 * 입력된 amount값이 금액이 아닌 경우(문자를 포함한 경우) 빈 문자열을 반환한다.
 *
 * @param amount		금액
 * @param decimals		소수점 표기 위치(기본값 : 0)
 * @param decimal_sep	소수점 표기 문자(기본값 : .)
 * @param thousands_sep	콤마 표기 문자(기본값 : ,)
 * @returns
 */
global.formatCurrency = function(amount, decimals, decimal_sep, thousands_sep) {
	var n = (amount + '').replace(/,/g, '');
	var c = isNaN(decimals) ? 0 : Math.abs(decimals);
	var d = decimal_sep || '.';
	var t = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep;
	var sign = (n < 0) ? '-' : '';
	var i = parseInt(n = Math.abs(n).toFixed(c)) + '';
	var j = ((j = i.length) > 3) ? j % 3 : 0;

	return sign + (j ? i.substr(0, j) + t : '')
		+ i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t)
		+ (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
};

/**
 * 클라이언트 PC의 현재 시간(연월일시분초) 리턴
 */
global.thisTimestamp = function() {
	return global.formatToday('yyyyMMddHHmmss');
}

/**
 * format에 따른 오늘 날짜 구하기
 * f : format
 * ex) global.formatToday(new Date(), 'yyyy-MM-dd');
 */
global.formatToday = function (f) {
	return global.formatDay(new Date(), f);
}

/**
 * format에 따른 날짜 구하기
 * d : date() 객체
 * f : format
 * ex) global.formatDay(new Date(), 'yyyy-MM-dd');
 */
global.formatDay = function (d, f) {
	var weekKorName = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    var weekKorShortName = ['일', '월', '화', '수', '목', '금', '토'];
    var weekEngName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    var weekEngShortName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return f.replace(/(yyyy|yy|MM|dd|KS|KL|ES|EL|HH|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case 'yyyy': return d.getFullYear();										// 년 (4자리)
            case 'yy': return global.numLPad((d.getFullYear() % 1000), 2);				// 년 (2자리)
            case 'MM': return global.numLPad((d.getMonth() + 1), 2);					// 월 (2자리)
            case 'dd': return global.numLPad(d.getDate(), 2);							// 일 (2자리)
            case 'KS': return weekKorShortName[d.getDay()];								// 요일 (짧은 한글)
            case 'KL': return weekKorName[d.getDay()];									// 요일 (긴 한글)
            case 'ES': return weekEngShortName[d.getDay()];								// 요일 (짧은 영어)
            case 'EL': return weekEngName[d.getDay()];									// 요일 (긴 영어)
            case 'HH': return global.numLPad(d.getHours(), 2);							// 시간 (24시간 기준, 2자리)
            case 'hh': return global.numLPad(((h = d.getHours() % 12) ? h : 12), 2);	// 시간 (12시간 기준, 2자리)
            case 'mm': return global.numLPad(d.getMinutes(), 2);						// 분 (2자리)
            case 'ss': return global.numLPad(d.getSeconds(), 2);						// 초 (2자리)
            case 'a/p': return d.getHours() < 12 ? '오전' : '오후';						// 오전/오후 구분
            default: return $1;
        }
    });
}

/************************************
 * 숫자 앞에 0 붙이기
 * ex) global.numLPad(3, 2) -> '03'
************************************/
global.numLPad = function (n, width) {
    n = n + '';
    return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}

/**
 * 이메일 형식 체크
 *
 * @param 데이터
 */
global.isEmail = function(email) {
	var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;

	if (regExp.test(email) == false) {
		return false;
	}

	return true;
}

/**
 * 핸드폰번호 형식 체크
 *
 * @param 데이터
 */
global.isHpTel = function(phone) {
	var regExp = /^(01[016789])([0-9]{1}[0-9]{2,3})([0-9]{4})$/;
	if (regExp.test(phone) == false) {
		return false;
	}

	return true;
}

/**
 * 다중 레이어 팝업
 */
// 콜백펑션을 위한 변수
var popupConfig = [];
global.openLayerPopup = function(paramObj) {
	// 아이비시트 존재 여부
	if (Grids.length) {
		for (var i = 0; i < Grids.length; i++) {
			if (Grids[i]) {
				var sheetObj = (new Function ('return '+ Grids[i].id))();

				// IBSheet에 대한 blur 처리
				sheetObj.SetBlur(1);
			}
		}
	}

	var paramUrl = paramObj.popupUrl;
	var paramData = (paramObj.params || {});
	var paramCallback = paramObj.callbackFunction;

	var sameUrl = popupConfig.filter(function(element){
		return element.config.popupUrl == paramUrl;
	});

	// 더블클릭 방지(똑같은 url이 담겨져 있으면 실행시키지 않고 return)
	if (sameUrl.length) {
		return;
	}

	// 레이어팝업에 페이지권한을 넘긴다.
	paramData.popupModify = $('#popupModify').val();

	var timestamp = new Date().getTime();

	var popupConfigObj = {};

	// 레이어를 타임스탬프로 체킹
	popupConfigObj.timestamp = timestamp;
	if (paramCallback && typeof paramCallback == 'function') {
		popupConfigObj.callbackFunction = paramCallback;
	}
	popupConfigObj.config = paramObj;
	popupConfig.push(popupConfigObj);

	var targetId = 'modalLayerPopup' + timestamp;

	$('#modalLayerPopup').append('<div id="' + targetId + '" class="modal modal-pop">');
	$('#modalLayerPopup').append('</div>');

	var $target = $('#' + targetId);
	var popupLoadFunction = function() {
		$.ajax({
			type : 'POST'
			, url : paramUrl
			, cache : false
			, data : paramData
			, dataType : 'html'
			, async : true
			, spinner : true
			, success : function(data){
				$target.html(data);

				// 정보를 담았으면 레이어 오픈
				$target.addClass('open');
				$('body').addClass('hiddenScroll');

				$('#layerTarget' + timestamp).focus();
			}
			, error : function(request, status, error) {
				alert('작업 중 에러가 발생했습니다.');

				// 실패하면 popupConfig 의 마지막 요소 제거
				popupConfig.pop();
			}
	    });
	}

	popupLoadFunction();
};

/**
 *  byte 길이 체크
 */
global.chkByte = function(obj, max_byte) {
	var objStr = obj.value;
	// common
	var byteLength = 0;
	for (var i = 0; i < objStr.length; i++) {
		var oneChar = escape(objStr.charAt(i));
		if (oneChar.length == 1) {
			byteLength ++;
		} else if (oneChar.indexOf('%u') != -1) {
			byteLength += 2;
		} else if (oneChar.indexOf('%') != -1) {
			byteLength += oneChar.length / 3;
		}
	}

	// 전체길이를 초과하면
	// 입력된 > 맥스
	if (byteLength > max_byte) {
		alert(max_byte + ' 바이트를 초과 입력할수 없습니다. 현재 ' + byteLength + 'Byte입니다.');
		obj.focus();

		return false;
	}

	return true;
}