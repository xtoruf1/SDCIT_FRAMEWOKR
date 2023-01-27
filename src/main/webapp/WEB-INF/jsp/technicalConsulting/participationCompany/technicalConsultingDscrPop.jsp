<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="egovframework.common.Constants" %>

<%-- <div class="location">
	<jsp:include page="/WEB-INF/jsp/layouts/navigation.jsp" flush="true" />
</div> --%>

<div class="cont_block" style="max-width: 800px;">
    <!-- 타이틀 영역 -->
    <div class="tit_bar">
        <h3 class="tit_block">업체 메모 조회</h3>
        <div class="ml-auto">
            <button class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
        </div>
    </div>

    <table class="formTable">
        <tbody>
        <c:forEach var="data" items="${dscrList}" varStatus="status">
            <tr>
                <th colspan="2">
                    <div class="flex">
                        <p>${data.cfrcStartDate} ${data.cfrcName}</p><p class="ml-auto">${data.applDate}</p>
                    </div>
                </th>
            </tr>
            <tr>
                <td  colspan="2">
                    <p class="mt-40 mb-40">
                        <c:out value="${data.dscr}" />
                    </p>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<script type="text/javascript">


    $(document).ready(function(){
    });


</script>