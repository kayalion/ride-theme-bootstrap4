var rideApp = rideApp || {};

rideApp.sidebar = (function($, undefined) {
  var $document = $(document);
  var $sidebar = $document.find('.sidebar');
  var isToggled = false;
  var isSticky = true;

  var _initialize = function() {
    $sidebar.offcanvas({
      toggle: false,
      placement: "left",
      autohide: false,
      recalc: true,
      disableScrolling: false
    }).on('show.bs.offcanvas', function() {
      isToggled = true;
    }).on('hide.bs.offcanvas', function() {
      isToggled = false;
    });

    // implement autohide
    $document.on('click', function(e) {
      if (isSticky || $(this).hasClass('sidebar-sticky')) {
        return;
      }

      if ($(e.target).closest($sidebar).length === 0) {
        isToggled = false;
        $sidebar.offcanvas('hide');
      }
    });

    $sidebar.on('click', 'a', function() {
      if (isSticky || $(this).hasClass('sidebar-sticky')) {
        return;
      }

      $sidebar.offcanvas('hide');
    });

    $document.on('click', '.btn-sidebar-toggle', function() {
      if ($sidebar.hasClass('in')) {
        isToggled = false;
        $sidebar.offcanvas('hide');
      } else {
        isToggled = true;
        $sidebar.offcanvas('show');
      }
    });

    $document.on('click', '.btn-sidebar-sticky', function() {
      var $this = $(this);

      if (isSticky) {
        isSticky = false;
        rideApp.common.setToLocalStorage('sidebar.sticky', 0);

        $this.find('.fa').removeClass('text-primary');
      } else {
        isSticky = true;
        rideApp.common.setToLocalStorage('sidebar.sticky', 1);

        $this.find('.fa').addClass('text-primary');
      }
    });

    if (rideApp.common.getFromLocalStorage('sidebar.sticky', 1) != "1") {
      isSticky = false;
    } else {
      $('.btn-sidebar-sticky .fa').addClass('text-primary');
      $sidebar.removeClass('offcanvas-hidden').offcanvas('forceShow');
      isToggled = true;
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


