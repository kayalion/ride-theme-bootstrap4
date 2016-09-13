var rideApp = rideApp || {};

rideApp.security = (function($, undefined) {
  var $document = $(document);

  var _initialize = function() {
    $(".role a").click(function() {
      $(this).next().toggle();

      return false;
    }).next().hide();
  };

  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.security.initialize();
});


