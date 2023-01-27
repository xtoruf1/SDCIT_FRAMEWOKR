<%@ page language="java" contentType="application/vnd.ms-word;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
	String scale = request.getParameter("scale");
	String prvPriType = request.getParameter("prvPriType");
	String coNmKr = request.getParameter("coNmKr");
	String userNmKor = request.getParameter("userNmKor");

	String docNm = "(" + scale + "_" + prvPriType + ")" + coNmKr + "_" + userNmKor + ".doc";

	response.setHeader("Content-Type", "application/vnd.ms-word;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment;filename=" + toENG(docNm));
	response.setHeader("Content-Description", "JSP Generated Data");
%>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<tiles:insertAttribute name="body" />
<%!
	public static String toENG(String str) {
		if (str == null) {
			return "";
		} else {
			return translate("KSC5601", "8859_1", str);
		}
	}

	public static String toKSC(String str) {
		if (str == null) {
			return "";
		} else {
			return translate("8859_1", "KSC5601", str);
		}
	}

	public static String translate(String origin, String target, String str) {
		String value = null;

		try {
			value = new String(str.getBytes(origin), target);
		} catch(UnsupportedEncodingException e) {
			value = str;
		}

		return value;
	}
%>