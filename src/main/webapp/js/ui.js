window.addEventListener('DOMContentLoaded', function(){
	var menuToggle = document.querySelector('.btn_toggle_gnb');
	var wrapper = document.querySelector('.wrapper');

	if(menuToggle != undefined){
		menuToggle.addEventListener('click', function(){
			wrapper.classList.toggle('fullscreen');
		});
	}

	// gnb 2depth 메뉴 펼침
    var $btn_menu_folding = $('.btn_subMenu');

    $btn_menu_folding.on('click', function(e){
		e.preventDefault();
		var $this = $(this);
		if ($this.hasClass('opened')) {
			$this.removeClass('opened');
		} else {
			$this.addClass('opened');
		}
	});

	// 시스템 이동 레이어메뉴
    var btn_system = document.querySelector('.btn_show_system');

	if (btn_system) {
		btn_system.addEventListener('click', function(){
			btn_system.classList.toggle('opened');
		});
	}

	document.addEventListener('click', function(e){
		if (!e.target.classList.contains('btn_show_system') && !e.target.classList.contains('list_system') && $(e.target).parents('.list_system').length == 0) {
			btn_system.classList.remove('opened');
		}
	});

	// 테이블 간소화
	if (document.querySelectorAll('.btn_folding').length > 0) {
		var btnFold = document.querySelectorAll('.btn_folding');

		for (var i = 0; i < btnFold.length; i++) {
			btnFold[i].addEventListener('click', function(){
				this.parentElement.classList.toggle('fold');
			});
		}
	}

	// tab
	if (document.querySelectorAll('.tabGroup').length > 0) {
		var $btnTab = $('.tab');

		$btnTab.on('click', function(){
			var $this = $(this);

			if (!$this.hasClass('on')) {
				var $tabGroup = $this.parents('.tabGroup');
				var idx = $this.index();

				$this.siblings('.tab').removeClass('on');
				$this.addClass('on');

				$tabGroup.find('.tab_cont').removeClass('on');
				$tabGroup.find('.tab_cont').eq(idx).addClass('on');
			}
		});
	}

	// 첨부파일
	$(document).on('change', $('.form_file input'), function(e){
		var fileName = getFileName(e.target.value);
		var textfield = $(e.target).parents('.form_file').find('.file_name');

		if (fileName == "") {
			textfield.text('첨부파일을 선택하세요.');
		} else {
			textfield.text(fileName);
		}
	});

	function getFileName(elm) {
		return elm.match(/[^\\/]*$/)[0];		// remove C:\fakename;
	}

	$('.form_search .form_text').on('focus',function(){
		$(this).parent().addClass('is-focus');
	})
	$('.form_search .form_text').on('blur',function(){
		$(this).parent().removeClass('is-focus');
	})
});