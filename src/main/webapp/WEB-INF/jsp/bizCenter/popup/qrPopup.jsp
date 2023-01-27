<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="<c:url value='/js/jsQR.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/inko.min.js' />"></script>
<style>

input:focus::-webkit-input-placeholder,
textarea:focus::-webkit-input-placeholder { color:transparent; }

input:focus:-moz-placeholder,
textarea:focus:-moz-placeholder { color:transparent; }

input:focus::-moz-placeholder,
textarea:focus::-moz-placeholder { color:transparent; }

input:focus:-ms-input-placeholder,
textarea:focus:-ms-input-placeholder {  color:transparent; }

.noFocus {border: 0px; opacity: 0}
</style>

<div id="loading_wrapper" class="loading_wrapper" style="display: none;">
		<img src="/images/common/loading.gif" class="loading_image">
</div>

<div>
<input type="text" class="noFocus" id="scanner" name="scanner" />

<div class="qrCheck_box" style="margin-bottom: 0px;">
	<p>
		<span class="qrCheck_txt m_hidden">QR 확인 대기 중 입니다.</span>
	</p>
	<a href="javascript:startQrMeida();" onclick="showQRCamara('mobile')">
		<span class="qrCheck_txt pc_hidden">QR 코드 확인</span>
	</a>
	<div class="qrCode_btn">
		<button type="button" class="btn" onclick="closePopup();">취소</button>
	</div>
</div>

<!-- QR 코드 확인 -->
<div class="qrCode" id="qrCode" style="display: none;" >
	<div class="qrCode_box">
		<div id="loadingMessage"></div>
		<canvas id="canvas" hidden></canvas>
		<div id="output" hidden>
			<div id="outputMessage">No QR code detected.</div>
			<div hidden><b>Data:</b> <span id="outputData"></span></div>
	    </div>

	</div>
	<div class="qrCode_btn">
		<button type="button" class="btn" onclick="closePopup();">취소</button>
	</div>
</div>

</div>


<script type="text/javascript">
// 로딩 이미지 위치
$(".loading_image").css({top: "-25%", left: "23%" });

$(document).ready(function () {
	$("#scanner").focus();

	$("#scanner").on("blur",function() {
		$("#scanner").focus()
	});

	$("#scanner").on("keydown",function() {
		$("#loading_wrapper").show();
		var qrCode = $('#scanner').val();
		if(event.keyCode == 13) {
			fnAttendCheck(inko.ko2en(qrCode));
		}
	});

});

// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
$('.modal').on('click', function(e){
	if (!$(e.target).is($('.modal-content, .modal-content *'))) {
		closeLayerPopup();
	}
});

function closePopup() {
	closeLayerPopup();
}

/**
 * QR코드 값 확인 및 참석 확인
 * @param qrCode
 */
function fnAttendCheck(qrCode) {
	//데이터 확인

	global.ajax({
		type : 'POST'
		, url : '<c:url value="/bizCenter/reservation/qrInfoConfirm.do" />'
		, data : {
				  qrData : qrCode
		         }
		, dataType : 'json'
		, async : false
		, spinner : true
		, success : function(data){
			var returnObj = data.searchVO;
			if (data.SUCCESS){
				layerPopupCallback(returnObj);
				closeLayerPopup();
			}
		}
	});
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
	   $("#qrCode").show();

   	navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

   	if (navigator.getUserMedia) {
   		   navigator.getUserMedia({ video: { facingMode: "environment" } },
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

   			navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
   		        video.srcObject = stream;
   		        video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
   		        video.play();
   		        requestAnimationFrame(tick);
   			});
   		}

   }

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

          outputData.innerHTML = code.data;
          fnAttendCheck(code.data);
          video.pause();
          return;

        } else {
          outputMessage.hidden = false;
          outputData.parentElement.hidden = true;
        }
      }
      requestAnimationFrame(tick);
    }

</script>
