$(document).ready(function() {

  // Toggle the navigation
  $(".mod-header .toggle").click(function(e) {
    e.preventDefault();
    $("body").toggleClass("canvas-menu");

    // $("ul.subnav").appendTo(".tour-toggle");

    $('.mod-header .fa').toggleClass("fa-navicon fa-close");

  });

  // Toggle the navigation
  $(".mod-header .tour-toggle > a").click(function(e) {
    e.preventDefault();
    $(this).toggleClass("show");
    $(".mod-header .subnav-large").toggleClass("show");
  });

  $(document).click(function(e) {
    if($(e.target).parents('.mod-header').length == 0) {
      $(".mod-header .tour-toggle > a").toggleClass("show", false);
      $(".mod-header .subnav-large").toggleClass("show", false);
    }
  });

  $(window).on('load, resize', function() {
    var viewportWidth = $(window).width();
    if (viewportWidth > 600) {
        $("body").removeClass("canvas-menu");
        $('.mod-header .fa').removeClass("fa-close").addClass("fa-navicon");
    }
  });

});
