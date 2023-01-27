<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
.qr_page .container{padding:0;}
.qr_header{display:flex; align-items:center; height:8rem; padding:3rem 3rem 1.8rem; border-bottom:1px solid #EFF1F6;}
.qr_header .btn_back{display:block; width:4.4rem; margin-right:3rem;}
.qr_header .btn_back img{width:100%;}
.qr_body{padding-top:10rem; padding-bottom:10rem; font-size:1.6rem;}

.popup .form_search_icon{flex-shrink:0;}

.tit_qr{font-size:3rem; font-weight:700; line-height: 1;}

.qr_terms li{padding-left:1.5rem; text-indent:-1.5rem;}
.qr_terms li+li{margin-top:2rem;}
.qr_terms strong{font-weight:400;}

@media screen and (max-width:767px){
  .qr_header{min-height:10.5rem; padding:4.2rem 3.4rem 2.7rem; }
  .qr_body{padding-top:5rem; padding-bottom:5rem; font-size:3rem;}

  .tit_qr{font-size:3.4rem;}

  .qr_terms li{padding-left:3rem; text-indent:-3rem;}
}


/*참석 확인 QR 코드*/
.qr_code .qr_header{flex-direction: column; justify-content: center; height: 17.7rem;}
.qr_code .qr_header .tit_qr{font-size: 4.2rem;}
.qr_code .qr_header .date{font-size: 3.4rem; margin-top: 1.4rem; color: #767676; font-weight: 500;}
.qr_code .qr_body{padding: 6rem 3.5rem 5rem;}
.qr_body .confirm{text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center;}
.qr_body .confirm .confirm_tit{font-size: 4.6rem; font-weight: 700; color: #4E83EB; margin-bottom: 3rem;}
.confirm .code_area{width: 35rem; height: 35rem; background-color: #cbcbcb; margin-bottom: 3rem;}
.confirm .code_area img{width: 100%;}

.btn_qrcode.icon_download{font-size: 2.4rem; font-weight: 700;}
.btn_qrcode.icon_download:after{width: 2.6rem; height: 2.6rem; background: url(../img/ico_btn_qrdown.png) no-repeat top left / contain; margin-left: 1.4rem;}
.confirm_text{font-size: 3.4rem; margin-top: 5rem;}
.btn_qrcode{color: #DD7777; min-width: 60rem; border: 0.3rem solid #DD7777; border-radius: 2rem; height: 8rem;}
.qr_body .bottom_btn_group{margin-top: 8rem;}

@media screen and (max-width:767px){
  .btn_qrcode.icon_download{font-size: 3rem;}
}

/* 행사장 위치 안내 */
.event_location{margin-bottom: 3rem;}
.event_location p{font-size: 2.2rem; padding-left: 1.6rem;}

@media screen and (max-width:767px){
  .event_location p{font-size: 3rem; padding-left: 2rem;}
}

.qr_page .map_area{margin-top: 0;}
.qr_page .use_subway .subway_box{display: flex; flex-wrap: wrap;}
.qr_page .use_subway .subway_box li{width: 50%; display: inline-flex;}
.qr_page .use_subway .subway_box li strong{width: 10rem; min-width: 10rem; height: 4rem; display: inline-flex; align-items: center; justify-content: center; border-radius: 2rem; color: #fff; font-size: 2rem;}
.qr_page .use_subway .subway_box li p{font-size: 2.2rem; margin-left: 2rem;}
.qr_page .use_subway .subway_box .color01{background-color: #00910a;}
.qr_page .use_subway .subway_box .color02{background-color: #bf9e31;}
.qr_page .use_subway .subway_box .text_color01{color: #00910a;}
.qr_page .use_subway .subway_box .text_color02{color: #bf9e31;}
.qr_page .use_bus+.use_bus{margin-top: 5rem;}
.qr_page .use_bus .tit{font-size: 2.8rem; font-weight: 500; margin-bottom: 3rem;}
.qr_page .use_bus .bus_box{display: flex; flex-wrap: wrap;}
.qr_page .use_bus .bus_box li{display: flex; align-items: center; width: 100%;}
.qr_page .use_bus .bus_box li+li{margin-top: 1.4rem;}
.qr_page .use_bus .bus_box li p{font-size: 2rem; padding-left: 2.4rem;}
.qr_page .use_bus .bus_box li strong{width: 10rem; height: 4rem; border: 2px solid #ccc; display: inline-flex; align-items: center; justify-content: center; border-radius: 2rem;}
.qr_page .use_bus .bus_box .color01{color: #3055a2; border-color: #3055a2;}
.qr_page .use_bus .bus_box .color02{color: #00910a; border-color: #00910a;}
.qr_page .use_bus .bus_box .color03{color: #6cb113; border-color: #6cb113;}
.qr_page .use_bus .bus_box .color04{color: #d80714; border-color: #d80714;}
.qr_page .use_bus .bus_box .color05{color: #5a9fd0; border-color: #5a9fd0;}

@media screen and (max-width:767px){
  .qr_page .use_subway {padding-top: 2rem;}
  .qr_page .use_subway .subway_box li{width: 100%;}
  .qr_page .use_subway .subway_box li+li{margin-top: 8rem;}
  .qr_page .use_subway .subway_box li strong{width: 14rem; height: 5.4rem; min-width: 14rem; border-radius: 4rem; font-size: 2.8rem;}
  .qr_page .use_subway .subway_box li p{text-align: left; font-size: 3rem; margin-left: 3rem;}
  .qr_page .use_bus{text-align: left;}
  .qr_page .use_bus .tit{font-size: 3.4rem; font-weight: 700;}
  .qr_page .use_bus .bus_box li{display: inline-flex; align-items: flex-start;}
  .qr_page .use_bus .bus_box li+li{margin-top: 3.6rem;}
  .qr_page .use_bus .bus_box li p{font-size: 3rem;}
  .qr_page .use_bus .bus_box li strong{width: 14rem; height: 5.4rem; min-width: 14rem; border-radius: 4rem; font-size: 2.8rem;}
}

</style>

<c:if test="${bizSeq ne '0' }" >
  <div class="qr_page">
    <div class="container qr_code">
      <!-- 페이지 타이틀 -->
      <div class="qr_header">
        <h2 class="tit_qr">비즈니스 센터 예약</h2>
        <fmt:parseDate value="${result.useYmd}" var="dateValue" pattern="yyyyMMdd"/>
        <p class="date">예약일 : <fmt:formatDate value="${dateValue}" pattern="yyyy-MM-dd"/> </p>
      </div>
      <div class="cont_inner qr_body">
        <div class="confirm">
            <p class="confirm_tit">예약확인 QR코드</p>
            <!-- QR코드 영역 -->
            <div class="code_area">
            <img src="<c:out value="/bizCenter/reservation/getImage.do?qrCode=${qrCode}" />"  alt="QR코드" title="QR코드" />
            </div>
            <!-- //QR코드 영역 -->
            <p class="confirm_text">비즈니스 센터 이용 시 QR코드를 제시해주시기 바랍니다.</p>
        </div>
        <!-- //bottom_btn_group -->
      </div>
      <!-- //cont_inner -->
    </div>
  </div>
</c:if>
<c:if test="${bizSeq eq '0' }" >
  <div class="qr_page">
    <div class="container qr_code">
      <div class="qr_header">
        <h2 class="tit_qr">비즈니스 센터 예약</h2>
      </div>
      <div class="cont_inner qr_body">
        <div class="confirm">
            <p class="confirm_tit">예약확인 QR코드</p>
            <!-- QR코드 영역 -->
            <div class="code_area"></div>
            <!-- //QR코드 영역 -->
            <p class="confirm_text">비즈니스 센터 이용 시 QR코드를 제시해주시기 바랍니다.</p>
        </div>
        <!-- //bottom_btn_group -->
      </div>
      <!-- //cont_inner -->
    </div>
  </div>
</c:if>

<script>
history.replaceState({}, null, location.pathname);
</script>