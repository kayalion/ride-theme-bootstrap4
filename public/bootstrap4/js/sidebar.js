var rideApp = rideApp || {};

rideApp.sidebar = (function($, undefined) {
  var $document = $(document);
  var $sidebar = $document.find('.sidebar');

  var _initialize = function() {

    $sidebar.offcanvas({
      toggle: false,
      placement: "left",
      autohide: false,
      recalc: true,
      disableScrolling: false
    });
    $sidebar.on('show.bs.offcanvas', function() {
      rideApp.common.setToLocalStorage('sidebar.toggled', 1);
    });
    $sidebar.on('hide.bs.offcanvas', function() {
      rideApp.common.setToLocalStorage('sidebar.toggled', 0);
    });

    $document.on('click', '.btn-sidebar', function() {
      if ($sidebar.hasClass('in')) {
        $sidebar.offcanvas('hide');
      } else {
        $sidebar.offcanvas('show');
      }
    });

    if (rideApp.common.getFromLocalStorage('sidebar.toggled', 1) == "1") {
      $sidebar.removeClass('offcanvas-hidden').offcanvas('forceShow');
    }
  };

  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.sidebar.initialize();
});


