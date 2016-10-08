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
        toggleDependantRows($(this), false);
      });
      $form.find('input[data-toggle-dependant], select[data-toggle-dependant]').each(function() {
        toggleDependantRows($(this), true);
      });
      $form.find('.collection-control-group').each(function() {
        handleCollectionState($(this));
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

    this.autocomplete();
    this.selectize();
    this.assets.initialize();

    handleSelectAll();
  };

  var initializeParsley = function() {
    $.extend(window.Parsley.options, {
      excluded: 'input[type=button], input[type=submit], input[type=reset], [disabled], .novalidate',
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

    var $parent = $anchor.parents('.collection-controls');

    var index = $parent.attr('data-index');
    if (!index) {
        index = $('.collection-control', parent).length;
    }

    var prototype = $parent.attr('data-prototype');
    prototype = prototype.replace(/%prototype%/g, 'prototype-' + index);

    var $group = $('.collection-control-group', $parent).first();

    $group.append(prototype);

    index++;
    $parent.attr('data-index', index);
    $parent.trigger('collectionAdded');

    handleCollectionState($group);
  };

  var onCollectionRemove = function($anchor, e) {
    e.preventDefault();

    var isConfirmed = true;
    var message = $anchor.attr('data-message-confirm');

    if (message) {
      isConfirmed = confirm(message);
    }

    if (isConfirmed) {
      var $group = $anchor.parents('.collection-control-group');
      var $parent = $anchor.closest('.collection-control');

      $parent.trigger('collectionRemoved');
      $parent.remove();

      handleCollectionState($group);
    }
  };

  var handleCollectionState = function($group) {
    var maxItems = $group.attr('maxlength');
    if (!maxItems) {
      return;
    }

    if ($group.find('.collection-control').length >= maxItems) {
      $group.parents('.collection-controls').find('.prototype-add').prop('disabled', true).addClass('disabled');
    } else {
      $group.parents('.collection-controls').find('.prototype-add').prop('disabled', false).removeClass('disabled');
    }
  };

  var onSubmit = function($anchor, e) {
    var $form = $anchor.closest('form');

    if ($form.data('is-loading')) {
      return false;
    }

    if (hasParsley && !$form.parsley().isValid()) {
      $form.parsley().validate();

      return false;
    }

    $form.find('.modal').remove();
    $form
      .data('is-loading', true)
      .addClass('is-loading');

    $anchor.prepend('<span class="fa fa-spinner fa-pulse"></span> ');

    return true;
  };

  var cancelSubmit = function($form) {
    $form.data('is-loading', false);
    $form.removeClass('is-loading');

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

      if (willSelectTab && $firstTab && document.activeElement.tagName == 'BUTTON') {
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

  var toggleDependantRows = function($input, initialize) {
    var $form = $input.parents('form');
    var $row = null;
    var styleClass = $input.data('toggle-dependant');
    var value = null;

    if (initialize) {
      var $row = $input.parents('.form-group');

      if ($row.hasClass('toggle-dependant-initialized')) {
        return;
      }

      $row.addClass('toggle-dependant-initialized');
    }

    if ($input.prop('tagName') == 'SELECT') {
        value = $input.val();
    } else {
        if (initialize) {
          $input = $row.find('[name^="' + $input.attr('name') + '"]');
        }

        value = $input.filter(':checked').length ? $input.val() : null;
    }

    $('.' + styleClass, $form).parents('.form-group').addClass('hidden-xs-up');

    if (value !== null && value.constructor === Array) {
      for (i in value) {
        $('.' + styleClass + '-' + value[i], $form).parents('.form-group').removeClass('hidden-xs-up');
      }
    } else {
      $('.' + styleClass + '-' + value, $form).parents('.form-group').removeClass('hidden-xs-up');
    }
  };

  var _selectize = function() {
    if (!jQuery.fn.selectize) {
      return;
    }

    var $form = $('form.form-selectize');
    var defaultSelectizeOptions = {
      highlight: false,
      plugins: ['remove_button']
    };

    initSelectize();

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      initSelectize();
    });

    $document.on('collectionAdded', function() {
      initSelectize();
    });

    function initSelectize() {
      var $selects = $form.find('select.form-selectize:visible:not(.selectized)');

      $selects.each(function(i, select){
        var selectizeOptions = $.extend(true, {}, defaultSelectizeOptions);
        var $select = $(select);

        if ($select.data('order') === true) {
          selectizeOptions.plugins.push('drag_drop');
        }

        $select.removeClass('custom-select');

        var maxItems = $select.attr('maxlength');
        if (maxItems) {
          selectizeOptions.maxItems = maxItems;
          $select.removeAttr('maxlength');
        }

        $(select).selectize(selectizeOptions).addClass('selectized');
      });
    }
  };

  var _autocomplete = function() {
    if (jQuery.fn.selectize) {
      $('[data-autocomplete-url]').each(function() {
        enableAutocomplete($(this));
      });
    }

    function enableAutocomplete($field) {
      var url = $field.data('autocomplete-url');
      var maxItems = $field.data('autocomplete-max-items');
      var minLength = $field.data('autocomplete-min-length');
      var type = $field.data('autocomplete-type');
      var locale = $field.data('autocomplete-locale');
      var headers = {};
      var plugins = [];

      $field.removeAttr('maxlength');

      if (locale) {
          headers['Accept-Language'] = locale;
      }

      if (maxItems != 1) {
          plugins.push('drag_drop', 'remove_button');
      }

      var autocompleteSettings = {
        valueField: 'name',
        labelField: 'name',
        searchField: 'name',
        plugins: plugins,
        create: $field.hasClass('js-tags') ? true : false,
        load: function(query, callback) {
          if (!query.length || (minLength && query.length < minLength)) return callback();
          var fetchUrl = url;
          fetchUrl = fetchUrl.replace(/%25term%25/g, query);
          fetchUrl = fetchUrl.replace(/%term%/g, query);

          // Don't show ajax overlay
          window.overlaySelector = undefined;

          $.ajax({
            url: fetchUrl,
            headers: headers,
            success: function(data) {
              if (type === 'jsonapi') {
                res = data.meta.list;
              } else {
                res = data;
              }
              var map = $.map(res, function(value) {
                return {name: value};
              });
              callback(map);
            }
          });
        }
      };

      if (maxItems != 0) {
        autocompleteSettings.maxItems = maxItems;
      }

      $field.selectize(autocompleteSettings);
    }
  };

  var _assets = {
    activeModal: null,
    initialize: function() {
      $(window).on('resize', function() {
        rideApp.form.assets.resizeIframe($('.modal.in iframe'));
      });

      $document.on('click', '.form-assets-add', function(e) {
        e.preventDefault();

        var $button = $(this);

        if ($button.attr('disabled') === 'disabled') {
          return;
        }

        var $formGroup = $button.parents('.form-group');
        var $formAssets = $formGroup.find('.form-assets').first();
        var $modal = $formGroup.find('.modal');
        var $iframe = $modal.find('iframe');

        rideApp.form.assets.activeModal = $modal;
        rideApp.form.assets.resizeIframe($iframe);

        $('.form-assets', $modal).html($formAssets.html());

        if (!$iframe.attr('src')) {
          $iframe.on('load', function (e) {
            var $iframe = $(this);

            rideApp.form.assets.isLoading(false);

            var iframeId = $iframe.attr('id');
            var iframe = document.getElementById(iframeId);
            if (iframe && iframe.contentWindow) {
              iframe.contentWindow.onbeforeunload = function() {
                parent.rideApp.form.assets.isLoading(true);
              };
            }

            rideApp.form.assets.updateSelected($iframe);
          });

          $iframe.attr('src', $iframe.data('src'));

          $modal.on('show.bs.modal', function () {
              rideApp.form.assets.updateSelected($(this).find('iframe'));
          });
        }

        $modal.modal('show');
      });

      $document.on('click', '.form-assets-remove', function(e) {
        e.preventDefault();

        var $button = $(this);
        var $group = $button.parents('.form-assets');
        var id = $button.parent().data('id');

        rideApp.form.assets.removeAsset(id, $group);

        if ($group.parents('.modal').length == 0) {
          rideApp.form.assets.updateField($group);
        }
      });

      $document.on('click', '.form-assets-done', function(e) {
        e.preventDefault();

        var $modal = $(this).parents('.modal');
        var $group = $modal.find('.form-assets');

        rideApp.form.assets.updateField($group);

        $modal.modal('hide');
      });

      var $formAssets = $('.form-assets');
      if ($formAssets.length) {
        $('.form-assets').sortable({
          items: '.form-assets-asset'
        }).on('sortstop', function(event, ui) {
          var $assets = $(event.target);

          if ($assets.parents('.modal').length == 0) {
            rideApp.form.assets.updateField($assets);
          }
        }).disableSelection();
      }
    },
    isLoading: function(flag) {
      var $container = $('.modal.in .modal-body');
      if (flag === undefined) {
        return $container.hasClass('is-loading');
      } else if (flag) {
        $container.addClass('is-loading');

        return true;
      } else {
        $container.removeClass('is-loading');

        return false;
      }
    },
    resizeIframe: function($iframe) {
      $iframe.height($(window).height() - 220);
    },
    getSelected: function() {
      if (!rideApp.form.assets.activeModal) {
        return [];
      }

      var $group = rideApp.form.assets.activeModal.find('.form-assets'),
          values = [];

      $group.find('.form-assets-asset').each(function() {
        values.push($(this).data('id'));
      });

      return values;
    },
    hasReachedLimit: function() {
      var $group = rideApp.form.assets.activeModal.find('.form-assets'),
          $assets = $group.find('.form-assets-asset'),
          max = $group.data('max');

      return $assets.length >= max;
    },
    updateField: function($group) {
      var $field = $('#' + $group.data('field'));
          order = $group.sortable('toArray', {attribute: 'data-id'});

      $field.val(order.join(','));
      if (hasParsley && $field.parents('.form-group').hasClass('has-danger')) {
        var $form = $field.parents('form');

        if (!$form.parsley().isValid()) {
          $form.parsley().validate();
        }
      }

      if ($group.parents('.modal').length) {
        $field.prev().find('.form-assets').html($group.html());
      }
    },
    updateSelected: function($iframe) {
      var iframeId = $iframe.attr('id');
      var iframe = document.getElementById(iframeId);

      if (iframe && iframe.contentWindow.rideApp && iframe.contentWindow.rideApp.assets) {
        iframe.contentWindow.rideApp.assets.updateSelected(rideApp.form.assets.hasReachedLimit());
      }
    },
    addAsset: function(id, name, thumb) {
      var $openModal = $('.modal.in'),
          $group = $openModal.find('.form-assets'),
          $assets = $group.find('.form-assets-asset'),
          $asset = $group.find('[data-id="' + id + '"]'),
          max = $group.data('max');

      // check if the image is already added or the limit is exceded
      if ($asset.length || $assets.length >= max) {
        return false;
      }

      $asset = $('<div class="form-assets-asset" data-id="' + id + '"><img class="img-rounded" src="' + thumb + '" alt="' + name + '" title="' + name + '"><a href="#" class="btn btn-secondary btn-xs form-assets-remove"><span class="fa fa-remove"></span></a></div>');
      if ($assets.length) {
        $asset.insertAfter($assets.last());
      } else {
        $asset.prependTo($group);
      }

      rideApp.form.assets.updateSelected($('.modal.in iframe'));

      return true;
    },
    removeAsset: function(id, $group) {
      if (!$group) {
        $group = $('.modal.in').find('.form-assets');
      }

      $selectedAsset = $('[data-id="' + id + '"]', $group);
      $selectedAsset.remove();

      rideApp.form.assets.updateSelected($('.modal.in iframe'));
    },
  };

  return {
    initialize: _initialize,
    onCollectionAdd: onCollectionAdd,
    onCollectionRemove: onCollectionRemove,
    onFileDelete: onFileDelete,
    onSubmit: onSubmit,
    cancelSubmit: cancelSubmit,
    selectize: _selectize,
    autocomplete: _autocomplete,
    assets: _assets
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.form.initialize();
});
