<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<h2>멀티 커넥션</h2>
<div style="display: flex;justify-content: space-between;">
	<div style="width: 49%;">
		<div style="padding-top: 10px;font-size: 13px;font-weight: bold;">KMEMBER DB</div>
		<div id="kmemberList" style="padding-top: 10px;"></div>
	</div>
	<div style="width: 50%;">
		<div style="padding-top: 10px;font-size: 13px;font-weight: bold;">TRADE DB</div>
		<div id="tradeList" style="padding-top: 10px;"></div>
	</div>
</div>
<script type="text/javascript">
	var	ibHeaderKmember = new IBHeader();
	ibHeaderKmember.addHeader({Header: '위치', Type: 'Text', SaveName: 'location', Width: 70, Align: 'Center'});
	ibHeaderKmember.addHeader({Header: '등록일', Type: 'Text', SaveName: 'regDate', Width: 70, Align: 'Center'});
	
	ibHeaderKmember.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeaderKmember.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
	
	var	ibHeaderTrade = new IBHeader();
	ibHeaderTrade.addHeader({Header: '위치', Type: 'Text', SaveName: 'location', Width: 70, Align: 'Center'});
	ibHeaderTrade.addHeader({Header: '등록일', Type: 'Text', SaveName: 'regDate', Width: 70, Align: 'Center'});
	
	ibHeaderTrade.setConfig({AutoFitColWidth: 'search|resize|init|colhidden|rowtransaction|colresize', Page: 10, SearchMode: 4, DeferredVScroll: 1, SizeMode: 1, MouseHoverMode: 2});
	ibHeaderTrade.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});
	
	$(document).ready(function(){
		var kmemberContainer = $('#kmemberList')[0];
		createIBSheet2(kmemberContainer, 'kmemberListSheet', '100%', '100%');
		ibHeaderKmember.initSheet('kmemberListSheet');

		// KMEMBER DB 목록
		getKmemberList();
		
		var tradeContainer = $('#tradeList')[0];
		createIBSheet2(tradeContainer, 'tradeListSheet', '100%', '100%');
		ibHeaderTrade.initSheet('tradeListSheet');
		
		// TRADE DB 목록
		getTradeList();
	});
	
	function kmemberListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('kmemberListSheet_OnSearchEnd : ', msg);
    	} else {
    		kmemberListSheet.SetEllipsis(1);
    		kmemberListSheet.SetDataBackColor('#ffffff');
    		kmemberListSheet.SetMousePointer('default');
    		kmemberListSheet.SetMouseHoverMode(0);
    	}
    }
	
	function tradeListSheet_OnSearchEnd(code, msg) {
		if (code != 0) {
    		console.log('tradeListSheet_OnSearchEnd : ', msg);
    	} else {
    		tradeListSheet.SetEllipsis(1);
    		tradeListSheet.SetDataBackColor('#ffffff');
    		tradeListSheet.SetMousePointer('default');
    		tradeListSheet.SetMouseHoverMode(0);
    	}
    }
	
	// KMEMBER DB 목록
	function getKmemberList() {
		kmemberListSheet.DoSearch('<c:url value="/sample/multiconnection/selectKmemberList.do" />');
	}
	
	// TRADE DB 목록
	function getTradeList() {
		tradeListSheet.DoSearch('<c:url value="/sample/multiconnection/selectTradeList.do" />');
	}
</script>