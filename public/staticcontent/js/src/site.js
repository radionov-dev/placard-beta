// check JS
var htmlTag = document.getElementsByTagName('html')[0];
htmlTag.className = htmlTag.className.replace('no-js', 'is-js');

// jQuery (on document ready)
$(function(){
	// ready
	if ($('.headerUserBar__toogle').length) {
		$('.headerUserBar__toogle').click(function() {
			$('.headerUserBar__container').slideToggle();
			return	false;
		})
	};
	
	if ($('.headerSearchToogleOpen').length) {
		$('.headerSearchToogleOpen').click(function() {
			$('.headerSearch').slideToggle();
			return	false;
		})
		$('.headerSearchToogleClose').click(function() {
			$('.headerSearch').slideToggle();
			return	false;
		})
		
	}
	
	
	if($('.js-nav').length){
		$('.js-nav-toogle').click(function() {
			$(this).closest('.js-nav-container').find('.js-nav-content').slideToggle();
		})
		
		$('.js-nav-link').click(function() {
			$('.js-nav-link').removeClass('active');
			$('.js-nav-toogle').removeClass('active');
			$(this).addClass('active');
			$(this).closest('.js-nav-container').find('.js-nav-toogle').addClass('active');
		});
	};
	
	
	if ($('.js-slider').length) {
		$('.js-slider').owlCarousel({
			margin: 33,
			nav: true,
			responsive: {
				0: {
				  items: 1
				},
				480: {
					items: 2
				},
				640: {
					items: 3
				},
				1024: {
					items: 4
				}
			}
		});
	};
	
	var popoverMenuFadeTime = 200,
		popoverMenuFadeFlag = false,
		popoverClassActive = 'js-popover_active';
	$('.js-popover__toggle').on('click', function(event){
		event.preventDefault();
		var $wrap = $(this).parent('.js-popover');
		if( !$wrap.hasClass(popoverClassActive) ){
			var $container = $(this).siblings('.js-popover__container');
			$('.js-popover__container').not($container).hide();
			$('.js-popover').removeClass( popoverClassActive );
			$wrap.addClass( popoverClassActive );
			$container.fadeIn( popoverMenuFadeTime );
			return false;
		}
	});
	$('.js-popover__container').mouseover(function() {
		popoverMenuFadeFlag = true;
	}).mouseout(function() {
		popoverMenuFadeFlag = false;
	});
	$(document).on('click', function(){
		if(!popoverMenuFadeFlag){
			$('.js-popover__container').fadeOut( popoverMenuFadeTime, function(){
				$('.js-popover').removeClass( popoverClassActive );
			} );
		}
	});
	
	
	if ($('.js-check-groups').length) {
		var checkInput = $('.js-check-input');
		function validateGroup() {
			var checkGroup = $(this).closest('.js-check-group');
			if (checkGroup.hasClass('js-check-group1')) {
				$('.js-check-group2').find('.js-check-input').removeAttr("checked");
				if ($('.js-check-group1').find('.js-check-input:checked').prop('checked')) {
					$('.js-check-group1').removeClass('disabled');
					$('.js-check-group2').addClass('disabled');
				} else {
					$('.js-check-group2').removeClass('disabled');
				}
			}
			if (checkGroup.hasClass('js-check-group2')) {
				$('.js-check-group1').find('.js-check-input').removeAttr("checked");
				if ($('.js-check-group2').find('.js-check-input:checked').prop('checked')) {
					$('.js-check-group2').removeClass('disabled');
					$('.js-check-group1').addClass('disabled');
				} else {
					$('.js-check-group1').removeClass('disabled');
				}
			}
		}
		checkInput.change(validateGroup);
	};
	
	if ($('.js-main-checkbox').length) {
		var checkboxs = $('.js-checkbox');
		var checkboxMain = $('.js-main-checkbox');
		var flag = false;
		function toogleCheckboxMain() {
			if (checkboxMain.prop('checked')) {
				checkboxs.each(function () {
					$(this).prop('checked', true)
				});
			} else {
				checkboxs.each(function () {
					$(this).prop('checked', false)
				});
			}
		}
		function toogleCheckbox() {
			flag = false;
			checkboxs.each(function () {
				if ($(this).prop('checked')) {
					flag = true;
				}
				if (flag) {
					checkboxMain.prop('checked', true);
				} else {
					checkboxMain.prop('checked', false);
				}
			});
		}
		checkboxs.change(toogleCheckbox);
		checkboxMain.change(toogleCheckboxMain);
	}

	if ($('.chat').length) {
		var chat = $('.chat');
		var chatToogle = $('.chat__toogle');
		var openChat = function() {
			chat.toggleClass('chat--open');
		}
		chatToogle.click(openChat);
	}
});
