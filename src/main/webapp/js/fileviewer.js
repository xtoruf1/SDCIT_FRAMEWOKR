var viewer = {};		// namespace 선언

/**
 * 파일 뷰어 솔루션
 * @param url  		: 다운로드 URL
 * @param fileName	: 파일명
 */
viewer.showFileContents = function(url, fileName, docId) {
	// kitanet 사이트 내부 다운로드의 경우 protocol 및 host 정보 추가
	if (url.indexOf('http') == -1) {
		url = window.location.protocol + '//' + window.location.host + url;
	}

	var fileExt = getExt(fileName);

	// TODO : 양지환 미리보기 파일 허용 확장자 체크 로직 추가해야 함
	if (fileExt == '') {

	}
	
	/**
	 * formData 생성
	 * mode		: url,upload (필수)
	 * doc_id	: 파일 고유키 (필수)
	 * file_url	: 파일 다운로드 url (url 방식만 필수)
	 * file_ext	: 파일 확장자명 (url 방식만 필수)
	 */
	var fileForm = $('<form></form>');
	fileForm.attr('encType', 'multipart/form-data');
	fileForm.attr('method', 'post')
	fileForm.append($('<input/>', {type: 'hidden', name: 'mode', value: 'url' }));
	fileForm.append($('<input/>', {type: 'hidden', name: 'doc_id', value: docId }));
	fileForm.append($('<input/>', {type: 'hidden', name: 'file_url', value: url }));
	fileForm.append($('<input/>', {type: 'hidden', name: 'file_name', value: fileName }));
	fileForm.append($('<input/>', {type: 'hidden', name: 'file_ext', value: fileExt }));
	
	var fileFormData = new FormData(fileForm[0]);
	
	console.log("파일 미리보기 URL 설정을 위한 파라미터 확인 중");
	
	var vProtocol = location.protocol;
	var vHost = location.host;
	vHost = vHost.substring(0, vHost.indexOf(':') + 1);
	var vUrl = vProtocol + '//' + vHost + '265/api/upload';
	
	// 'http://localhost:265/api/upload'
	// 파일 뷰어 솔루션 url 호출
	$.ajax({
		// 파일뷰어 서버 테스트용
		url : '/api/fileViewer.do'
		, type : 'POST'
		, data : fileFormData
		, dataType : 'json'
		, contentType : false
		, processData : false
		, success : function (data) {
			console.log(data);
			
			if (data && data.result.error && data.result.error == -1) {
				var options = 'top=10, left=10, width=500, height=600, status=no, menubar=no, toolbar=no';
				window.open(data.result.url, '', options);
			} else if (data && data.result.message) {
				console.log(data.result.message);
			}
		}
		, error:function(p_xhr, p_status, p_error) {
			console.log(p_xhr)
			console.log(p_status)
			console.log(p_error)
		}
	});
	
	/**
	 * 확장자명 추출
	 * @param filename
	 * @returns {string}
	 */
	function getExt(fileName) {
		var fileLength = fileName.length;
		var lastIndex = fileName.lastIndexOf('.');
		var fileExt = fileName.substring(lastIndex, fileLength).toLowerCase().replace('.', '');
	
		return fileExt;
	}
	
	/**
	 * 고유 ID 생성
	 * @param filename
	 * @returns {string}
	 */
	function setDocId(fileName) {
		var docId = '';
		var pathName = window.location.pathname;
		docId = pathName + '/' + fileName;
		
		return docId;
	}
}