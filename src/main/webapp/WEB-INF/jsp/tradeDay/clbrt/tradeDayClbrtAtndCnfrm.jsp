<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="<c:url value='/js/jsQR.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/inko.min.js' />"></script>
<%-- QR카메라 스타일--%>
<style>
     #canvas {
	  width: 640px;
      height: 480px;
    }
</style>

<div class="page_tradesos">

	<form name="searchForm" id="searchForm" action ="" method="get" onsubmit="return false;">
		<input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${param.pageIndex}' default='1' />" />
		<input type="hidden" name="svrId" id="svrId" value="<c:out value='${searchVO.svrId}'/>"/>
		<input type="hidden" id="totalCount" name="totalCount" value="0" default='0'>
		<input type="hidden" id="qrData" name="qrData" value=""/>
		<div class="page_tradeDay_wrapper">
			<!-- 퍼블리싱 위치 -->
			<div class="tradeDay_header">
				<div class="inner">
					<h1 class="logo">
						<a href="/main.do">
							<img src="/images/common/logo_tradeday.png" alt="무역지원서비스">
						</a>
					</h1>
					<span class="pc_hidden">무역의 날 기념식 참석자 확인</span>
				</div>
			</div>
			<input type="text" class="m_hidden" id="scanner" name="scanner" size="20" autofocus/>
			<!-- 참석자 확인 -->
			<div class="tradeDay_body" id="tradeDay_body">
				<div class="tradeDay_tit m_hidden">
					<h2>행사QR확인 : ${resultData.tradeDayTitle}</h2>
					<button type="button" class="btn_sm btn_tbl" onclick="openLayerEventChngPop();">행사 변경</button>
				</div>
				<div class="qrCheck_box">
					<a onclick="showQRCamara('pc')">
						<span class="qrCheck_txt m_hidden">QR 확인 대기 중 입니다.</span>
					</a>
					<a href="javascript:startQrMeida();" onclick="showQRCamara('mobile')">
						<span class="qrCheck_txt pc_hidden">QR 코드 확인</span>
					</a>
				</div>
				<div class="tradeDay_cont">
					<ul>
						<li>
							<div class="inner">
								<span class="num">${resultData.attendTrgtCnt}</span>
								<span class="txt">참석대상자</span>
							</div>
						</li>
						<li>
							<div class="inner">
								<span class="num blu">${resultData.attendCnt}</span>
								<span class="txt">참석자</span>
							</div>
						</li>
						<li>
							<div class="inner">
								<span class="num red">${resultData.attendRate}%</span>
								<span class="txt">참석율</span>
							</div>
						</li>
					</ul>
				</div>
				<div class="tradeDay_btn">
					<button type="button" class="btn_tbl_border" onclick="openLayerMnlatPrcsnPop();">수동 참석처리</button>
					<button type="button" class="btn_tbl_primary" onclick="javascript:window.location.reload(true);">새로고침</button>
				</div>
			</div>
			<!-- //참석자 확인 -->

			<!-- QR 코드 확인 -->
			<div class="qrCode" id="qrCode" style="display:none;">
				<div class="qrCode_box">
					<div id="loadingMessage"></div>
					<canvas id="canvas" hidden></canvas>
					<div id="output" hidden>
						<div id="outputMessage">No QR code detected.</div>
						<div hidden><b>Data:</b> <span id="outputData"></span></div>
				    </div>

				</div>
				<div class="qrCode_btn">
					<button type="button" class="btn" onclick="fn_cencel();">취소</button>
				</div>
			</div>
			<!-- //QR 코드 확인 -->
			<!-- //퍼블리싱 위치 -->
		</div>
	</form>
</div> <!-- // .page_tradesos -->

<script type="text/javascript">
	$(document).ready(function () {
		$('#scanner').focus();

	});

	/**
	 * 행사 변경(팝업)
	 */
	function openLayerEventChngPop(){

		global.openLayerPopup({
			popupUrl : '<c:url value="/tradeDay/clbrt/eventChngPopup.do" />'
			, callbackFunction : function(resultObj) {
				$("input[name=svrId]").val(resultObj.svrId);
				document.searchForm.action = '<c:url value="/tradeDay/clbrt/tradeDayClbrtAtndCnfrm.do" />';
				document.searchForm.target = '_self';
				document.searchForm.submit();

			}
		});

	}

	/**
	 * 수동참석 처리(팝업)
	 */
	function openLayerMnlatPrcsnPop(){

		var svrId = $('#svrId').val();

		global.openLayerPopup({
			  popupUrl : '<c:url value="/tradeDay/clbrt/mnlatPrcsnPopup.do" />'
			, params : {
							svrId : svrId
						}
			, callbackFunction : function(resultObj) {

			}
		});
	}

	/**
	 * 카메라 CSS
	 * @param objId
	 */
	function showQRCamara(objId) {

		if (objId == 'mobile') {
			$('#tradeDay_body').css('display', 'none');
			$('#qrCode').css('display', 'flex');
		} else {
			alert("모바일에서만 가능합니다.");
		}

	}

	/**
	 * QR코드 값 확인 및 참석 확인
	 * @param qrCode
	 */
	function fnAttendCheck(qrCode, scanner) {

		//데이터 확인
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/tradeDay/clbrt/attendeeInfoConfirm.do" />'
			, data : {
					  qrData : qrCode
			         }
			, dataType : 'json'
			, async : false
			, spinner : true
			, success : function(data){

				if( data.SUCCESS ) {

				    //레이어 팝업 오픈
					global.openLayerPopup({
						popupUrl : '<c:url value="/tradeDay/clbrt/attendeeInfoPopup.do" />'
					  , params : {
							  svrId : data.resultData.svrId
						    , applySeq : data.resultData.applySeq
							, attendId : data.resultData.attendId
						    , attendTypeCd : data.resultData.attendTypeCd
						    , attendTypeNm : data.resultData.attendTypeNm
							, awardTypeNm : data.resultData.awardTypeNm
							, companyName : data.resultData.companyName
							, laureateName : data.resultData.laureateName
							, attendName : data.resultData.attendName
							, attendJuminNo : data.resultData.attendJuminNo
							, attendPhone : data.resultData.attendPhone
							, attendYn : data.resultData.attendYn
							, qrCheckYn : 'Y'
							, scanner : scanner
						 }
						 , callbackFunction : function(resultObj){

						 }
					 });

				} else {
					$('#scanner').val("");
					$('#scanner').focus();
					alert(data.MESSAGE);
				}

			}
		});

	}

	/**
	 * 바코드 스캐너 값 전달
	 * @param value
	 */
	document.querySelector("#scanner").onkeydown = function (event) {
		var qrCode = $('#scanner').val();
		if(event.keyCode == 13) {
			fnAttendCheck(inko.ko2en(qrCode) , 'Y');
		}
	}

	/**
	 * 스캐너 input 포커싱 유지
	 */
    document.querySelector("#scanner").onblur = function() {

		if($('#modalLayerPopup').children('div').length == 0 ) {
			$('#scanner').focus();
		} else {
		}
	};

	function fn_cencel() {
		document.searchForm.action = '<c:url value="/tradeDay/clbrt/tradeDayClbrtAtndCnfrm.do" />';
		document.searchForm.target = '_self';
		document.searchForm.submit();
	}

</script>


<%-- QR 카메라 스크립트 --%>
<script>

	var video = document.createElement("video");
    var canvasElement = document.getElementById("canvas");
    var canvas = canvasElement.getContext("2d");
    var loadingMessage = document.getElementById("loadingMessage");
    var outputContainer = document.getElementById("output");
    var outputMessage = document.getElementById("outputMessage");
    var outputData = document.getElementById("outputData");

    function drawLine(begin, end, color) {
      canvas.beginPath();
      canvas.moveTo(begin.x, begin.y);
      canvas.lineTo(end.x, end.y);
      canvas.lineWidth = 4;
      canvas.strokeStyle = color;
      canvas.stroke();
    }

    /**
     * 미디어 호출
   */
   function startQrMeida() {

   	navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

   	if (navigator.getUserMedia) {
   		   navigator.getUserMedia({ video: { facingMode: "environment", width: 640, height: 480  } },
   		      function(stream) {
   				video.srcObject = stream;
   				video.setAttribute("playsinline", true);      // iOS 사용시 전체 화면을 사용하지 않음을 전달
   				video.play();
   				requestAnimationFrame(tick);
   		      },
   		      function(err) {
   		         console.log("The following error occurred: " + err.name);
   		      }
   		   );
   		} else {

   			navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment", width: 640, height: 480 } }).then(function(stream) {
   		        video.srcObject = stream;
   		        video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
   		        video.play();
   		        requestAnimationFrame(tick);
   			});
   		}

   }

    // Use facingMode: environment to attemt to get the front camera on phones
//     navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
//       video.srcObject = stream;
//       video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
//       video.play();
//       requestAnimationFrame(tick);
//     });

    function tick() {
      loadingMessage.innerText = "⌛ Loading video..."
      if (video.readyState === video.HAVE_ENOUGH_DATA) {
       loadingMessage.hidden = true;
        canvasElement.hidden = false;
        outputContainer.hidden = false;

        canvasElement.height = video.videoHeight;
        canvasElement.width = video.videoWidth;
        canvasElement.style.width ='100%';
        canvasElement.style.height='100%';
        canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
        var imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height);
        var code = jsQR(imageData.data, imageData.width, imageData.height, {
          inversionAttempts: "dontInvert",
        });

        if (code) {
          drawLine(code.location.topLeftCorner, code.location.topRightCorner, "#FF3B58");
          drawLine(code.location.topRightCorner, code.location.bottomRightCorner, "#FF3B58");
          drawLine(code.location.bottomRightCorner, code.location.bottomLeftCorner, "#FF3B58");
          drawLine(code.location.bottomLeftCorner, code.location.topLeftCorner, "#FF3B58");
          outputMessage.hidden = true;
          outputData.parentElement.hidden = false;

          if(outputData.innerText != code.data) {

			  if(code.date =! null ) {
			  	 var qrCode = code.data;
				 fnAttendCheck(qrCode);
			  }
          }

        } else {
          outputMessage.hidden = false;
          outputData.parentElement.hidden = true;
        }
      }
      requestAnimationFrame(tick);
    }

</script>