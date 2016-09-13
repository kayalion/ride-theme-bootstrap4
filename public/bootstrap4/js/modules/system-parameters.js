var rideApp = rideApp || {};

rideApp.systemParameters = (function($, undefined) {
  var $document = $(document);
  var $formRow;
  var $form;

  var $currentRow;
  var $currentFormRow;
  var $currentForm;

  var _initialize = function() {
    $formRow = $document.find('tr.form');
    $form = $formRow.closest('form');

    $formRow.removeClass('hidden-xs-up');
    $formRow.remove();

    $document.on('click', '.btn-add', this.handleAdd);
    $document.on('click', '.btn-edit', this.handleEdit);
    $document.on('click', '.btn-cancel', this.handleCancel);
    $document.on('click', '.parameter-value', this.handleValueClick);

    $form.on('submit', handleSubmit);
  };

  var handleValueClick = function(e) {
    $(this).closest('tr').find('a').click();
  };

  var _forceSingleRow = function() {
    rideApp.form.cancelSubmit($form);

    if ($currentFormRow) {
      if ($currentRow) {
        $currentFormRow.after($currentRow);
      }

      $currentFormRow.remove();

      $currentRow = null;
      $currentFormRow = null;
    }
  }

  var handleCancel = function(e) {
    e.preventDefault();

    _forceSingleRow();
  }

  var handleAdd = function(e) {
    e.preventDefault();

    _forceSingleRow();

    $currentFormRow = $formRow.clone();

    $form.find('tbody').first('tr').before($currentFormRow);
    $('input[name=parameter]', $currentFormRow).focus();
    $('textarea[name=value]', $currentFormRow).attr('required', 'required');
  };

  var handleEdit = function(e) {
    e.preventDefault();

    _forceSingleRow();

    var $anchor = $(this);
    $currentRow = $anchor.closest('tr');

    var parameter = $anchor.html().trim();
    var value = $anchor.closest('td').next().html().trim();

    $currentFormRow = $formRow.clone();
    $('input[name=parameter]', $currentFormRow).attr('readonly', 'readonly').val(parameter);

    $currentRow.after($currentFormRow);
    $currentRow.remove();

    $('textarea[name=value]', $currentFormRow).val(rideApp.common.unescapeHtml(value)).focus();
  };

  var handleSubmit = function(e) {
    e.preventDefault();

    var parameter = $('input[name=parameter]', $currentFormRow).val();
    var value = $('textarea[name=value]', $currentFormRow).val();

    var formAction = $form.attr('action');
    var formValues = $form.serialize();

    formAction += '/' + parameter;

    $.post(formAction, formValues, function() {
      if (value != '') {
        if (!$currentRow) {
          $currentRow = $form.find('tr[data-parameter="' + parameter + '"]');

          if ($currentRow.length == 0) {
            $currentRow = $('<tr><td><a class="btn-edit" href="#">' + parameter + '</a></td><td class="parameter-value"></td></tr>');
            $form.find('tbody').first('tr').before($currentRow);
          }
        }

        $('.parameter-value', $currentRow).addClass('text-success').html(rideApp.common.escapeHtml(value));

        $currentFormRow.after($currentRow);
      }

      $currentFormRow.remove();

      $currentRow = null;
      $currentFormRow = null;
    }).fail(function() {
      alert('Could not save the parameter');
    }).always(function() {
      rideApp.form.cancelSubmit($form);
    });

    return false;
  }

  return {
    initialize: _initialize,
    handleAdd: handleAdd,
    handleEdit: handleEdit,
    handleSubmit: handleSubmit,
    handleCancel: handleCancel,
    handleValueClick: handleValueClick
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.systemParameters.initialize();
});
