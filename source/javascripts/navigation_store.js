window.NavigationStore = function() {
  function isSet(menu) {
    return localStorage["navigation_" + menu] !== undefined;
  }

  function fetch(menu) {
    return localStorage["navigation_" + menu] == "true" || false;
  }

  function set(menu, value) {
    localStorage["navigation_" + menu] = value;
  }

  return {
    isSet: isSet,
    fetch: fetch,
    set: set
  }
}();
