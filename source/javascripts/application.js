//= require jquery
//= require navigation_store

$(document).ready(function() {
  var navigationElements = $(".mod-side_nav h2");

  // Open getting started on first visit
  if(!NavigationStore.isSet("getting-started")) {
    NavigationStore.set("getting-started", true);
  }

  // Make sure the section of the current page is open
  var currentMenu = $("#navigation a.active").parents(".section").find("h2").data("menu");
  if(currentMenu) {
    NavigationStore.set(currentMenu, true);
  }

  // Toggle open state on navigation heading click
  navigationElements.on("click", function() {
    var element = $(this);
    var state = !element.hasClass("open");

    element.toggleClass("open", state);
    NavigationStore.set(element.data("menu"), state);
  });

  // Open those elements that have been open by the user.
  navigationElements.each(function() {
    var element = $(this);
    if(NavigationStore.fetch(element.data("menu"))) {
      element.addClass("open");
    }
  });
});
