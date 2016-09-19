var rideApp = rideApp || {};

rideApp.calendar = (function($, undefined) {
  var $form = $('#form-event-performance');

  var _initialize = function() {
    if ($form.length != 0) {
      $form.on('change', 'input[name="date[isDay]"],input[name="date[isPeriod]"]', function() {
        handleDateFields($form);
      });
      $form.on('change', 'input[name="date[isRepeat]"],select[name="date[mode]"]', function() {
        handleRepeater($form);
      });

      handleDateFields($form);
      handleRepeater($form);
    }
  };

  var handleDateFields = function($form) {
    var isDay = $('input[name="date[isDay]"]', $form).prop('checked');
    var isPeriod = $('input[name="date[isPeriod]"]', $form).prop('checked');

    if (isDay) {
      $('.time', $form).hide();
    } else {
      $('.time', $form).show();
    }

    if (isPeriod) {
      $('input[name="date[dateStop]"]', $form).show();
    } else {
      $('input[name="date[dateStop]"]', $form).hide();
    }

    if (!isPeriod && isDay) {
      $('.until', $form).hide();
    } else {
      $('.until', $form).show();
    }
  };

  var handleRepeater = function($form) {
    var isRepeat = $('input[name="date[isRepeat]"]', $form).is(':checked');

    if (isRepeat) {
      $('.repeater', $form).show();

      var mode = $('select[name="date[mode]"]', $form).val();
      $('.step', $form).hide();
      $('.step-' + mode, $form).show();

      if (mode == 'weekly') {
        $('.row-weekly').show();
        $('.row-monthly').hide();
      } else if (mode == 'monthly') {
        $('.row-weekly').hide();
        $('.row-monthly').show();
      } else {
        $('.row-weekly').hide();
        $('.row-monthly').hide();
      }
    } else {
      $('.repeater', $form).hide();
    }
  };

  return {
    initialize: _initialize
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.calendar.initialize();
});
