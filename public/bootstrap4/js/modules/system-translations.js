var rideApp = rideApp || {};

rideApp.systemTranslations = (function($, undefined) {
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
    $document.on('click', '.translation-value', this.handleValueClick);

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
// console.log($form.find('tbody').first('tr'));
    $form.find('tbody').first('tr').before($currentFormRow);
    $('input[name=key]', $currentFormRow).focus();
    $('textarea[name=translation]', $currentFormRow).attr('required', 'required');
  };

  var handleEdit = function(e) {
    e.preventDefault();

    _forceSingleRow();

    var $anchor = $(this);
    $currentRow = $anchor.closest('tr');

    var key = $anchor.html().trim();
    var translation = $anchor.closest('td').next().html().trim();

    $currentFormRow = $formRow.clone();
    $('input[name=key]', $currentFormRow).attr('readonly', 'readonly').val(key);

    $currentRow.after($currentFormRow);
    $currentRow.remove();

    $('textarea[name=translation]', $currentFormRow).val(rideApp.common.unescapeHtml(translation)).focus();
  };

  var handleSubmit = function(e) {
    e.preventDefault();

    var key = $('input[name=key]', $currentFormRow).val();
    var translation = $('textarea[name=translation]', $currentFormRow).val();

    var formAction = $form.attr('action');
    var formValues = $form.serialize();

    formAction += '/' + key;

    $.post(formAction, formValues, function() {
      if (translation != '') {
        if (!$currentRow) {
          $currentRow = $form.find('tr[data-translation="' + key + '"]');

          if ($currentRow.length == 0) {
            $currentRow = $('<tr><td><a class="btn-edit" href="#">' + key + '</a></td><td class="translation-value"></td></tr>');
            $currentRow.data('translation', key);

            $form.find('tbody').first('tr').before($currentRow);
          }
        }

        $('.translation-value', $currentRow).addClass('text-success').html(rideApp.common.escapeHtml(translation));

        $currentFormRow.after($currentRow);
      }

      $currentFormRow.remove();

      $currentRow = null;
      $currentFormRow = null;
    }).fail(function() {
      alert('Could not save the translation');
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
  rideApp.systemTranslations.initialize();
});
