var rideApp = rideApp || {};

rideApp.tabs = (function($, undefined) {
  var $document = $(document);

  var _initialize = function() {
    var hash = window.location.hash;
    hash && $('ul.nav a[href="' + hash + '"]', $document).tab('show');

    $document.on('click', '.nav-tabs a', function (e) {
        $(this).tab('show');
        var scrollmem = $('body').scrollTop() || $('html').scrollTop();
        window.location.hash = this.hash;
        $('html,body').scrollTop(scrollmem);
    });
  };


  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.tabs.initialize();
});
