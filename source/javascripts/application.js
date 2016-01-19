$(document).ready(function(){
  $('body').on('touchstart',function(){
    $('.mod-header_nav').removeClass('show');
  });
  $('.mod-header_nav').on('touchstart', function(){
    setTimeout(
      function(){
        $('.mod-header_nav').addClass('show');
      }, 30);
  });
  $(window).on('resize',function(){
    $('.mod-header_nav').removeClass('show');
  });
});
