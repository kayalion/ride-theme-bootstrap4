var rideApp = rideApp || {};

rideApp.documentationApi = (function($, undefined) {
  var $document = $(document);

  var _initialize = function() {
    initializeToggleSource();
    jumpToAnchor();
  };

  var initializeToggleSource = function() {
    $(".source-toggle").click(function() {
      $(this).parent().next().toggle();

      return false;
    });

    $(".source").css("display", "none");
  };

  var jumpToAnchor = function() {
    var hash = window.location.hash;
    if (!hash) {
      return;
    }

    hash = hash.substr(1);

    $document.scrollTo('a[name=' + hash + ']');;
    $document.scrollTo('-=60px');;
  };

  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.documentationApi.initialize();
});
