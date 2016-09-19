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
      $form.on('click', '.prototype-add:not(.disabled)', function(e) {
        return onCollectionAdd($(this), e);
      });
      $form.on('click', '.prototype-remove:not(.disabled)', function(e) {
        return onCollectionRemove($(this), e);
      });
      $form.on('click', 'button[type=submit]', function(e) {
        return onSubmit($(this), e);
      });
      $form.on('change', '[data-toggle-dependant]', function() {
          toggleDependantRows($(this));
      });
      $form.find('input[data-toggle-dependant]:checked, select[data-toggle-dependant]').each(function() {
        toggleDependantRows($(this));
      });

      var $orderedCollection = $('[data-order=true] .collection-control-group', $form);
      if ($orderedCollection.length != 0) {
        $orderedCollection.sortable({
            axis: "y",
            cursor: "move",
            handle: ".order-handle",
            items: "> .collection-control",
            select: false,
            scroll: true
        });
      }

      if (hasParsley) {
        $form.parsley()
          .on('form:error', function() {
            handleValidation(this.$element);
          })
          .on('field:success', function() {
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

  var onCollectionAdd = function($anchor, e) {
    e.preventDefault();

    var parent = $anchor.closest('.collection-controls');

    var index = parent.attr('data-index');
    if (!index) {
        index = $('.collection-control', parent).length;
    }

    var prototype = parent.attr('data-prototype');
    prototype = prototype.replace(/%prototype%/g, 'prototype-' + index);

    $('.collection-control-group', parent).first().append(prototype);

    index++;
    parent.attr('data-index', index);
  };

  var onCollectionRemove = function($anchor, e) {
    e.preventDefault();

    if (confirm($anchor.attr('data-message-confirm'))) {
        $anchor.closest('.collection-control').remove();
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

  var toggleDependantRows = function($input) {
    var $parent = $input.parents('form');
    var $styleClass = $input.data('toggle-dependant');
    var $group = $parent.find('[name^="' + $input.attr('name') + '"]');
    var value = null;

    if ($group.prop('tagName') == 'SELECT') {
        value = $group.val();
    } else {
        value = $input.filter(':checked').length ? $input.val() : null;
    }

    $('.' + $styleClass, $parent).parents('.form-group').hide();
    $('.' + $styleClass + '-' + value, $parent).parents('.form-group').show();
  };

  return {
    initialize: _initialize,
    onCollectionAdd: onCollectionAdd,
    onCollectionRemove: onCollectionRemove,
    onFileDelete: onFileDelete,
    onSubmit: onSubmit,
    cancelSubmit: cancelSubmit
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.form.initialize();
});
