<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
	function goMenu(url, target) {
		if (url == null) {
			alert('아직 생성되지 않은  URL');

			return;
		} else {
			if (target == '_blank') {
				window.open('${pageContext.request.contextPath}' + url, '_blank');
			} else {
				location.href = '${pageContext.request.contextPath}' + url;
			}
		}
	}
</script>
<header class="header">
	<!-- logo -->
	<h1 class="logo">
		<a href="<c:url value='/' />"><img src="<c:url value='/images/common/logo_ci_02.png' />" style="width: 90%;height: 70%;" alt="SDCIT" /></a>
	</h1>
	<!-- logo end -->
	<!--  gnb -->
	<nav class="gnb_wrap">
		<div class="gnb_wrap_scroll">
			<ul>
				<%-- 임시 하드코딩_김용세 --%>
				<li>
					<a href="javascript:void(0);" onclick="goMenu('/menu/system/systemList.do', '_self');" class="on">시스템관리</a>
				</li>
				<li>
					<a href="javascript:void(0);" onclick="goMenu('/menu/admin/program/adminProgramList.do', '_self');" class="on">프로그램관리</a>
				</li>
				<li>
					<a href="javascript:void(0);" onclick="goMenu('/sample/board/sampleList.do', '_self');" class="on">샘플게시판</a>
				</li>
				<c:set var="menuDepth" value="1" />
				<c:forEach var="item" items="${leftList}" varStatus="status">
					<c:choose>
						<c:when test="${item.menuDepth eq 1}">
							<c:choose>
								<c:when test="${item.menuDepth ne menuDepth}">
											</ul>
										</div>
									</li>
									<li>
								</c:when>
								<c:otherwise>
									<li>
								</c:otherwise>
							</c:choose>
							<a href="javascript:void(0);" <c:if test="${not empty item.url}">onclick="goMenu('${item.url}', '${item.linkTarget}');"</c:if>
								<c:choose>
									<c:when test="${item.leaf eq 0}">
										class="btn_subMenu opened"
									</c:when>
									<c:when test="${item.leaf eq 1}">
										<c:if test="${item.url eq currentMenu}">
											class="on"
										</c:if>
									</c:when>
								</c:choose>
							>${item.pgmName}</a>
							<c:set var="menuDepth" value="1" />
						</c:when>
						<c:when test="${item.menuDepth eq 2}">
							<c:if test="${item.menuDepth ne menuDepth}">
								<div class="sub_depth">
									<ul class="sub_depth_inner">
							</c:if>
							<li>
								<a href="javascript:void(0);" <c:if test="${not empty item.url}">onclick="goMenu('${item.url}', '${item.linkTarget}');"</c:if> <c:if test="${item.url eq currentMenu}">class="on"</c:if>>${item.pgmName}</a>
							</li>
							<c:set var="menuDepth" value="2" />
						</c:when>
					</c:choose>
					<c:if test="${menuDepth eq 1 and item.leaf eq 1}">
						</li>
					</c:if>
				</c:forEach>
				<c:if test="${menuDepth eq 2}">
							</ul>
						</div>
					</li>
				</c:if>
			</ul>
		</div>
	</nav>
	<!-- gnb end -->
</header>