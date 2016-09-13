var rideApp = rideApp || {};

rideApp.form = (function($, undefined) {
  var $document = $(document);
  var $forms = $('form[role=form]');
  var hasParsley = false;

  var _initialize = function() {
    if (window.Parsley != undefined) {
      hasParsley = true;
      initializeParsley();
    }

    $forms.each(function(index, form) {
      var $form = $(form);

      $form.on('click', '.btn-file-delete', function(e) {
        return onFileDelete($(this), e);
      });
      $form.on('click', 'button[type=submit]', function(e) {
        return onSubmit($(this), e);
      });

      if (hasParsley) {
        $form.parsley()
          .on('form:error', function() {
            handleValidation(this.$element);
          }).on('field:success', function() {
            handleValidation(this.$element.parents('form'), true);
          });
      }

      handleValidation($form, true);
    });

    handleSelectAll();
  };

  var initializeParsley = function() {
    $.extend(window.Parsley.options, {
      excluded: 'input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], .novalidate',
      errorsContainer: function (parsleyField) {
        return parsleyField.$element.closest('.form-group').find('parsley-errors-container');
      },
      errorsWrapper: '<ul class="parsley-errors-list text-danger list-unstyled"></ul>',
      errorClass: "form-control-danger",
      successClass: "form-control-success"
    });

    window.Parsley.setLocale(rideApp.common.getLanguage());
  };

  var onFileDelete = function($anchor, e) {
    e.preventDefault();

    if (confirm($anchor.data('message'))) {
      $anchor.closest('.form-group').find('input[type=hidden]').val('');
      $anchor.parent('div').remove();
    }
  };

  var onSubmit = function($anchor, e) {
    var $form = $anchor.closest('form');

    if ($form.data('is-submitted')) {
      return false;
    }

    if (hasParsley && !$form.parsley().isValid()) {
      $form.parsley().validate();

      return false;
    }

    $form
      .data('is-submitted', true)
      .addClass('is-submitted');

    $anchor.prepend('<span class="fa fa-spinner fa-pulse"></span> ');

    return true;
  };

  var cancelSubmit = function($form) {
    $form.data('is-submitted', false);
    $form.removeClass('is-submitted');

    $('button[type=submit]', $form).find('.fa-spinner').remove();
  };

  var handleValidation = function($form, willSelectTab) {
    var $tabs = $form.find('.nav-tabs .nav-link');
    var $firstTab = null;

    $tabs.removeClass('text-danger');
    if ($tabs.length) {
      $tabs.each(function() {
        var $tab = $(this);


        if ($($tab.attr('href')).find('.parsley-error,.form-control-danger').length) {
          if (!$firstTab) {
            $firstTab = $tab;
          }

          $tab.addClass('text-danger');
        }
      });

      if (willSelectTab && $firstTab) {
        $firstTab.tab('show');
      }
    }
  };

  var handleSelectAll = function() {
    $document.on('click', '.form-select-all', function(e) {
      var $option = $(this);
      var $isChecked = $option.prop('checked');

      $option.closest('form').find('input[type=checkbox]:not([disabled=disabled])').each(function() {
        $(this).prop('checked', $isChecked);
      });
    });
  };

  return {
    initialize: _initialize,
    onFileDelete: onFileDelete,
    onSubmit: onSubmit,
    cancelSubmit: cancelSubmit
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.form.initialize();
});


