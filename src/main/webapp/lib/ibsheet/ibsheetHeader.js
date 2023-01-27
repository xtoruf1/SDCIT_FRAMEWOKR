var	IBHeader	=	function()
{
	this.cfg	=	{AutoFitColWidth:"search|resize|init|colhidden|rowtransaction|colresize",Page: 5, SearchMode: 1,UseHeaderActionMenu: false, MouseHoverMode: 2, SelectionRowsMode: false,FrozenCol: 0, DeferredVScroll: true, ToolTip: true, SizeMode: 4, NoFocusMode : 1, Alternate: 0, HeaderCheckSync: 1, SetSelectionMode: 1};
	this.headers	=	[];
	this.cols 		=	[];
	this.mode		=	{Sort: 0, ColResize: true, ColMove: true};
	this.headersRowMerge =	[];
}

IBHeader.prototype.setConfig	=	function(cfgInfo)
{
	/******
	 AutoFitColWidth : 특정 시점에서 컬럼의 너비를 자동으로 조정하는 FitColWidth()함수 호출 적용하고자 하는 시점을 구분자 "|"로 연결하여 사용. (Default : "")
	 예) AutoFitColWidth : "search | resize | init | colhidden | rowtransaction | colresize"
	 search : 조회 및 로드 시점
	 resize : 시트 Resize 시점
	 init : 초기화 및 removeAll 호출 시점
	 colhidden : 컬럼 숨김/보임 시점
	 rowtransaction : 로우 추가/삭제/숨김/보임 이후
	 colresize : 넓이가 변경된 컬럼을 제외한 나머지 컬럼의 FitColWidth
	 SearchMode : 조회방식 설정 (0 - 일반 조회 모드, 1 - 페이징 모드, 2 - Lazy Load 모드, 3 - 실시간 서버 처리 모드 (스크롤 방식), 4 - 실시간 서버 처리모드 (페이지 인덱스 방식))
	 UseHeaderActionMenu : 헤더 컨텍스트 메뉴 사용 여부 (Boolean)  (Default : false)
	 MouseHoverMode : 시트내의 행 또는 셀에 MouseOver에 대한 Hover 방식을 설정 (0 - 사용안함, 1 - 셀단위, 2 - 행단위) (Default : 0)
	 SelectionRowsMode : GetSelectionRows 메소드를 사용할 때 포커스행을 포함할지 여부를 설정. (Boolean) (Default : false)
	 FrozenCol : 좌측 고정컬럼의 수 (Default : 0)
	 DeferredVScroll : 세로 스크롤에 대한 지연 스크롤링 여부 (Default: false)
	 page : 한번에 표시할 행의 개수 (Default=20)
	 TreeNodeIcon : 트리 노드 아이콘 사용 여부 (Boolean)  (Default : false)
	 *******/
	if(cfgInfo && typeof cfgInfo == 'object') {
		for(var key in cfgInfo) {
			this.cfg[key] = cfgInfo[key];
		}
	}
	//this.cfg	=	cfgInfo;
}

IBHeader.prototype.setHeaderMode	=	function(modeInfo)
{
	/******
	 ColResize : 헤더의 마우스 드래그를 이용한 리사이즈 기능 여부 (Boolean)
	 ColMove : 헤더의 마우스 드래그를 이용한 헤더컬럼 이동 가능 여부 (Boolean)
	 Sort : 헤더 클릭을 통한 컬럼 Sort 사용 여부 ( 0 - 사용안함, 1 - Sort 기능 사용, 2 - Sort 아이콘만 표시, 3 - colSpan 설정이 아닌 헤더셀만 Sort 기능 사용)
	 *******/
	if(modeInfo && typeof modeInfo == 'object') {
		for(var key in modeInfo) {
			this.mode[key] = modeInfo[key];
		}
	}
	//this.mode	=	modeInfo;
}

IBHeader.prototype.addHeader	=	function(colInfo)
{

	/******
	 Type : Seq : 행의 생성 순서 값을 표현하는 데이터 타입
	 Text : Text 형태의 데이터 타입
	 DelCheck : 행에 대한 삭제 여부를 설정하는 CheckBox 형태의 데이터 타입
	 CheckBox : CheckBox 형태의 데이터타입
	 Date : 날짜 형태의 데이터 타입
	 Status : 행에 대한 트랜잭션 상태를 표현하는 데이터 타입
	 Int : 정수 형태의 데이터 타입
	 Float : 실수 형태의 데이터 타입
	 Radio : Radio 형태의 데이터 타입
	 COMBO : DROPDOWN 리스트 형태의 데이터 타입
	 DummyCheck: Event를 발생하지 않는 CheckBox 형태의 데이터 타입
	 ComboEdit : 편집 및 필터링이 가능한 DropDown 리스트 형태의 데이터 타입
	 AutoSum : 자동 합계를 표현하는 Number 형태의 데이터 타입
	 Image : Image 형태의 데이터 타입
	 Popup : 우측에 팝업 버튼을 갖는 Text 형태의 데이터 타입
	 Pass : Password 형태의 데이터 타입
	 Html : Html 형태의 데이터 타입
	 Result : 저장 처리 결과를 표현하는 데이터 타입
	 Sparkline : Sparkline 차트를 표현하는 데이터 타입
	 Button : Button 형태의 데이터 타입

	 Align : Left : 좌측 정렬
	 Center : 중앙 정렬
	 Right : 우측 정렬

	 ColSpan : 단위데이터행 구조에서 고정 셀병합 모드 사용시 ColSpan 범위 값

	 ComboCode : Combo 형태의 데이터 타입의 코드를 구분자 '|'로 연결한 문자열

	 ComboDisabled : Combo 형태의 데이터 타입의 선택 불가능 한 item을 구분자 '|'로 연결한 문자열

	 Edit : 편집 허용 여부 (boolean 기본값 1)

	 Ellipsis : 말줄임 사용 여부 (boolean 기본값 0)

	 Focus : 포커스 허용 여부 (boolean 기본값 1)

	 Format : 데이터 포멧 문자열 또는 문자열의 배열 집합 >> 하나의 컬럼내의 2개 이상의 포멧 설정이 필요한 경우 "Format" : ["IdNo","SaupNo"]와 같이 사용한다.
	 Ymd : yyyy/MM/dd 형태의 날짜 포맷 (Date Text Popup)
	 Ym : yyyy/MM 형태의 날짜 포맷 (Date Text Popup)
	 Md : MM/dd 형태의 날짜 포맷 (Date Text Popup)
	 Hms : HH:mm:ss 형태의 날짜 포맷 (Date Text Popup)
	 Hm : HH:mm 형태의 날짜 포맷 (Date Text Popup)
	 YmdHms : 'yyyy/MM/dd HH:mm:ss' 형태의 날짜 포맷 (Date Text Popup)
	 YmdHm : 'yyyy/MM/dd HH:mm' 형태의 날짜 포맷 (Date Text Popup)
	 Integer : 정수 형태의 숫자 포맷 (Int AutoSum)
	 NullInteger : 빈값을 허용하는 정수 형태의 숫자 포맷 (Int AutoSum)
	 Float : 실수 형태의 숫자 포맷 (Float AutoSum)
	 NullFloat : 빈값을 허용하는 실수 형태의 숫자 포맷 (Float AutoSum)
	 IdNo : 주민등록번호 포맷 (Text)
	 SaupNo : 사업자등록번호 포맷 (Text)
	 PostNo : 우편번호 포맷 (Text)
	 CardNo : 카드번호 포맷 (Text)
	 PhoneNo : 전화번호 포맷 (Text)
	 Number : 숫자 형태 (특정 포맷없이 숫자키만 입력 받는 형태) (Text)

	 Hidden : 컬럼 숨김 여부 (boolean 기본값 0)

	 KeyField : 필수 입력 여부 (boolean 기본값 0)

	 ToolTip : 데이터 영역에 대한 툴팁 사용 여부 또는 문자열 (boolean 기본값 0 / string);

	 ToolTipText : 헤더 영역에서의 툴팁에 표시할 문자열




	 *******/
	this.headers[colInfo.SaveName]	=	colInfo;
}

IBHeader.prototype.getHeadersArray = function(){
	var headers = this.headers;
	var arrayOfHeaders = new Array();

	for(var k in headers){
		arrayOfHeaders.push(headers[k]);
	}

	return arrayOfHeaders;
}


IBHeader.prototype.setHeaderRowMerge	=	function(pRowMerge)
{
	this.headersRowMerge = pRowMerge;
}

IBHeader.prototype.getHeadersInfo = function(){
	var	info	=	{};
	info.cfg	=	this.cfg;
	info.cols	=	this.getHeadersArray();
	info.headers =	[];
	info.mode	=	this.mode;

	if(info.cols[0].Header)
	{
		var	cols	=	info.cols;
		var	headers	=	new Array(cols[0].Header.split("|").length);

		for(var i=0; i<cols.length; i++)
		{
			var	col	=	cols[i];
			var header = col.Header.split("|");

			for(var j=0; j<header.length; j++)
			{
				if (!headers[j]) headers[j] = [];
				headers[j].push(header[j]?header[j]:"");
			}

			delete(col.Header);
		}

		for(var i=0; i<headers.length; i++)
		{
			var header = {};
			header.Text = headers[i].join("|");
			header.Align	=	"Center";
			header.RowMerge = 1;
			if(this.headersRowMerge && this.headersRowMerge.length > i){
				header.RowMerge = this.headersRowMerge[i];
			}
			info.headers.push(header);

		}
	}
	return info;
}

IBHeader.prototype.initSheet	=	function(sheetId)
{
	var	cInfo	=	this.getHeadersInfo();
	var sheet = eval(sheetId);
	sheet.SetConfig(cInfo.cfg);
	sheet.InitHeaders(cInfo.headers, cInfo.mode);
	sheet.InitColumns(cInfo.cols);
	sheet.SetFocusAfterProcess(false);
}

var	IBHeader2	=	function()
{
	this.Cfg	=	{AutoFitColWidth:"search|resize|init|colhidden|rowtransaction|colresize",Page: 5, SearchMode: 1,UseHeaderActionMenu: true, MouseHoverMode: 2, SelectionRowsMode: false,FrozenCol: 0, DeferredVScroll: true, ToolTip: true, SizeMode: 4, NoFocusMode : 1, Alternate: 0, HeaderCheckSync: 1, SetSelectionMode: 1};
	this.HeaderMode		=	{Sort: 0, ColResize: true, ColMove: true};
	this.Cols = [];
}

IBHeader2.prototype.setConfig	=	function(cfgInfo)
{
	if(cfgInfo && typeof cfgInfo == 'object') {
		for(var key in cfgInfo) {
			this.Cfg[key] = cfgInfo[key];
		}
	}
}

IBHeader2.prototype.setHeaderMode	=	function(modeInfo)
{
	/******
	 ColResize : 헤더의 마우스 드래그를 이용한 리사이즈 기능 여부 (Boolean)
	 ColMove : 헤더의 마우스 드래그를 이용한 헤더컬럼 이동 가능 여부 (Boolean)
	 Sort : 헤더 클릭을 통한 컬럼 Sort 사용 여부 ( 0 - 사용안함, 1 - Sort 기능 사용, 2 - Sort 아이콘만 표시, 3 - colSpan 설정이 아닌 헤더셀만 Sort 기능 사용)
	 *******/
	if(modeInfo && typeof modeInfo == 'object') {
		for(var key in modeInfo) {
			this.HeaderMode[key] = modeInfo[key];
		}
	}
	//this.mode	=	modeInfo;
}

IBHeader2.prototype.addHeader	=	function(colInfo)
{
	this.Cols.push(colInfo);
}

IBHeader2.prototype.initSheet	=	function(sheetId)
{
	var sheet = eval(sheetId);
	var initdata = {};
	//SetConfig
	initdata.Cfg = this.Cfg;
	//InitHeaders의 두번째 인자
	initdata.HeaderMode = this.HeaderMode;
	//InitColumns + Header Title
	initdata.Cols = this.Cols;

	console.log("initdata["+JSON.stringify(initdata)+"]");
	IBS_InitSheet(sheet, initdata);
}