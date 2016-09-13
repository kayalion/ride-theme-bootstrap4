var rideApp = rideApp || {};

rideApp.table = (function($, undefined) {
  var $document = $(document);
  var $tables = $('table.table');

  var _initialize = function() {
    $tables.each(function(index, table) {
      var $table = $(table);

      $table.closest('form').on('click', 'button[type=submit]:not([name=applyAction])', function(e) {
        return onApply($(this), e);
      });
      $table.on('click', 'button[name=applyAction]', function(e) {
        return onApplyAction($(this), e);
      });
      $table.find('td.action a').addClass('btn btn-secondary');
    });
  };

  var onApplyAction = function($button, e) {
		var willSubmit = true;

		var $form = $button.closest('form');
    var $select = $button.parent().prev();
		var messages = $form.data('confirm-messages');
		var action = $select.children(':selected').text();

    if (action == '---') {
      return false;
    }

		if (messages[action]) {
			willSubmit = confirm(messages[action]);
		}

		if (!willSubmit) {
			$select.val('0');
		}

    return willSubmit;
  };

  var onApply = function($button, e) {
		var $form = $button.closest('form');
    var $select = $form.find('select[name=action]');

		$select.val('0');
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
