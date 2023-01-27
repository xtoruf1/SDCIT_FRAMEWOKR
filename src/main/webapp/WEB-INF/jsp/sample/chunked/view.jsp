<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<style type="text/css">
	.ui-progressbar { position: relative; }
	.progress-label {
		position: absolute;
		left: 50%;
		top: 6px;
		font-weight: bold;
		margin-left: -40px;
	}
</style>
<h2>CHUNKED 업로드</h2>
<div class="contents">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="boardwrite">
		<caption>등록/수정화면</caption>
		<colgroup>
			<col width="15%" />
			<col width="75%" />
			<col width="10%" />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">첨부파일</th>
			<td>
				<input type="file" id="file" name="file" style="width: 99%;" />
			</td>
			<td align="center">
				<button id="startBtn">시작 업로드</button>
			</td>
		</tr>
		<tr>
			<th scope="row">진행률</th>
			<td>
				<div class="progressbar"><div class="progress-label"></div></div>
			</td>
			<td align="center">
				<div id="mergeStatus" style="text-align: center;margin-top: 3px;"></div>
			</td>
		</tr>
		</tbody>
	</table>
</div>
<script type="text/javascript">
	var barProgress;
	$(document).ready(function(){
		page.init();
		
		barProgress = jQuery('.progressbar');
		barProgress.eq(0).progressbar({value: 0});
		barProgress.eq(0).find('.progress-label').html('0%');
		barProgress.eq(0).find('.ui-progressbar-value').css({'background': '#ffcc66'});
	});

	var status = 0;
	var page = {
		init : function(){
			$('#startBtn').click($.proxy(this.upload, this));
		}
		, upload : function(){
			status = 0;
			var guid = this.guid();
			var file = $('#file')[0].files[0]				// 파일 객체
			, name = file.name								// 파일 이름
			, size = file.size;								// 총합 크기
			
			var shardSize = 1 * 1024 * 1024					// 슬라이스 조각(MB)
			, shardCount = Math.ceil(size / shardSize);		// 조각의 총 수
			
			for (var i = 0; i < shardCount; ++i) {
				// 시작과 끝 위치 각각에 대해 계산
				var start = i * shardSize
				, end = Math.min(size, start + shardSize);
				
				var partFile = file.slice(start, end);
				
				this.partUpload(guid, partFile, name, shardCount, i);
			}
		}
		, partUpload : function(guid, partFile, name, chunks, chunk) {
			var now = this;
			var form = new FormData();
			form.append('guid', guid);
			form.append('file', partFile);					// slice 파일의 일부를 절단하는 방법
			form.append('name', name);						// 파일명
			form.append('chunks', chunks);					// 조각의 총 수
			form.append('chunk', chunk);					// 몇 번째 조각
			
			$.ajax({
				url : '<c:url value="/common/chunkedUpload.do" />'
				, type : 'POST'
				, data : form
				, async: true
				, processData : false
				, contentType : false
				, success : function(data){
					status++;
					
					if (data.code == 200) {
						if (chunks != 0) {
							var percent = parseInt((status * 100) / chunks);
							
							barProgress.eq(0).progressbar({value: percent});
							barProgress.eq(0).find('.progress-label').html(percent + '%');
							barProgress.eq(0).find('.ui-progressbar-value').css({'background': '#ffcc66'});
						}
					}
					if (status == chunks) {
						now.mergeFile(guid, name);
					}
				}
			});
		}
		, mergeFile : function(guid, name){
			var form = new FormData();
			form.append('guid', guid);
			form.append("name", name);						// 파일명
			
			$('#mergeStatus').html('병합중...');
			
			$.ajax({
				url : '<c:url value="/common/chunkedFileMerge.do" />'
				, type : 'POST'
				, data: form
				, processData : false
				, contentType : false
				, success: function(data){
					$('#mergeStatus').html(data.message);
				}
			});
		}
		, guid : function(prefix){
			var counter = 0;
			var guid = (+new Date()).toString(32);
			
			for (i = 0; i < 5; i++) {
				guid += Math.floor(Math.random() * 65535).toString(32);
			}
			
			return (prefix || 'wu_') + guid + (counter++).toString(32);
		}
	};
</script>