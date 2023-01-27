<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval var="loginUrl" expression="@variables.getProperty('variables.loginUrl')" />
<spring:eval var="serverName" expression="@variables.getProperty('variables.serverName')" />

<script>
	/**
	 * 로그아웃
	 * @param loginUrl
	 * @param serverName
	 */
	function doLogout(loginUrl, serverName) {
		global.ajax({
			type : 'POST'
			, url : '<c:url value="/processLogout.do" />'
			, data : $('#logoutForm').serialize()
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				alert('정상적으로 로그아웃 되었습니다.');
				location.href = '<c:url value="/login.do" />';
			}
		});
	}
</script>
<form name="logoutForm" method="post">
</form>
<div class="admin_content_top">
	<div class="top_tit">
		<button class="btn_toggle_gnb"><img src="<c:url value='/images/common/ico_hambug.png' />" alt="전체메뉴 열기 닫기" /></button>
		<h2 class="tit_admin">[${selectMenu.systemMenuName}] <span>권한으로 접속중</span></h2>
		<div class="top_utils_item ml-15">
			<button class="btn_show_system">보기<!-- ${selectMenu.systemMenuName} --></button>
			<div class="list_system">
				<p class="txt">접속 권한을 선택하세요.</p>
				<ul>
					<c:forEach var="menu" items="${systemMenuList}" varStatus="status">
						<li><a href="<c:url value='${menu.url}' />" <c:if test="${selectMenu.systemMenuId eq menu.systemMenuId}">class="on"</c:if> target="${menu.linkTarget}">${menu.systemMenuName}</a></li>
					</c:forEach>
				</ul>
			</div>
		</div>
	</div>
	<div class="top_utils">
		<div class="top_utils_item"><img class="mr-3" src="<c:url value='/images/common/ico_user.png' />" alt="" /><strong class="color_primary mr-5">${user.memberNm} 님</strong></div>
		<div class="top_utils_item"><a href="javascript:void(0);" onclick="doLogout('${loginUrl}', '${serverName}');">로그아웃 <img class="ml-8" src="<c:url value='/images/common/ico_logout.png' />" alt="로그아웃" /></a></div>
	</div>
</div>