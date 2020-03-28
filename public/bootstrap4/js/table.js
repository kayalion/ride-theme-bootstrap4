var rideApp = rideApp || {};

rideApp.table = (function($, undefined) {
  var $document = $(document);
  var $tables = $('table.table');

  var _initialize = function() {
    $tables.each(function(index, table) {
      var $table = $(table);

      $table.find('td.action a').addClass('btn btn-secondary');
      $table.find('td img').addClass('img-rounded');

      var $form = $table.closest('form');

      $form.on('click', '.form-group-order .btn', function(e) {
        var $element = $(this);

        $('input', $element).attr('checked', 'checked');

        return onApply($element, e);
      });
      $form.on('change', 'select:not(.js-action)', function(e) {
          onApply($(this), e);
      });
      $table.on('click', 'button[name=applyAction]', function(e) {
        return onApplyAction($(this), e);
      });
    });
  };

  var onApplyAction = function($button, e) {
    var willSubmit = true;

    var $form = $button.closest('form');
    var $select = $button.parent().prev();
    var messages = $form.data('confirm-messages');
    var action = $select.children(':selected').text();

    if (action == '---' || $select.val() == '' || action == $form.data('bulk')) {
      return false;
    }

    if (messages[action]) {
      willSubmit = confirm(messages[action]);
    }

    if (!willSubmit) {
      $select.val($("option:first", $select).val());
    }

    return willSubmit;
  };

  var onApply = function($element, e) {
    var $form = $element.closest('form');
    var $select = $form.find('select[name=action]');

    $select.val($("option:first", $select).val());

    if (rideApp.form.onSubmit($element)) {
      $form.submit();
    }
  };

  return {
    initialize: _initialize,
    onApplyAction: onApplyAction,
    onApply: onApply
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.table.initialize();
});
