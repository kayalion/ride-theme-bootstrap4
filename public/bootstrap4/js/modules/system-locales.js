var rideApp = rideApp || {};

rideApp.systemLocales = (function($, undefined) {
  var $document = $(document);

  var _initialize = function() {
    $(".locales").sortable({
      axis: 'y',
      handle: 'h3',
      helper: 'clone',
      opacity: 0.5,
      update: function() {
        $.post($('.locales').data('url-order'), $(this).sortable('serialize'));
      }
    });
    $('.locales h3').css('cursor', 'move');

    $(".btn-toggle-properties").click(function() {
      var $button = $(this);

      $button.toggleClass('active');
      $($button.data('target')).toggle();

      return false;
    });
    $('.locales .properties').hide();
  };

  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.systemLocales.initialize();
});


