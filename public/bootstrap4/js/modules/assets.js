var rideApp = rideApp || {};

rideApp.assetDropzone = (function($, undefined) {
  var $dropzone = $("#asset-dropzone");
  var page = $dropzone.data('page') || 1;
  var maxItems = $dropzone.data('limit') || 24;
  var maxFilesize = $dropzone.data('max-filesize') || 16;
  var labelDefault = $dropzone.data('label-default') || "Drop files here to upload";
  var labelErrorFilesize = $dropzone.data('label-error-filesize') || "This file is too big.";
  var labelSuccess = $dropzone.data('label-success') || "%file% added";

  labelErrorFilesize = labelErrorFilesize.replace("%size%", "" + maxFilesize);

  Dropzone.options.assetDropzone = {
    maxFilesize: maxFilesize,
    parallelUploads : 1,
    dictDefaultMessage : labelDefault,
    dictFileTooBig : labelErrorFilesize,

    init: function() {
      this.on("sending", function(file, xhr, formData) {
        formData.append("resource", "file");
      });
      $("#dropzone-upload").click(function() {
        location.reload();
      });
    },

    success : function(file, html) {
      rideApp.common.notifySuccess(labelSuccess.replace("%file%", "" + file.name));

      var $form = $('#form-filter');

      var $total = $form.find('.total');
      var total = parseInt($total.html()) + 1;
      $total.html(total);

      var numItems = $('.asset-items .asset-item').length;

      if (numItems < maxItems) {
        $('.asset-items-assets').append($(html));

        var disableUnselected = $('.asset-item[data-id] input[type=checkbox]:not(:checked)').prop('disabled');

        rideApp.assets.updateSelected(disableUnselected);
      } else {
        var $pagination = $form.find('.pagination');
        var newPage = Math.ceil(total / maxItems);
        var $lastItem = $pagination.find('li:last');
        var $beforeLastItem = $lastItem.prev();

        if ($beforeLastItem.text() != newPage) {
          var newUrl = $pagination.find('.active a').attr('href').replace('page=' + page, 'page=' + newPage);

          if ($beforeLastItem.hasClass('active')) {
            $lastItem.find('a').attr('href', newUrl);
          }

          $pagination.parent().removeClass('hidden-xs-up');
          $lastItem.before('<li class="page-item"><a class="page-link" href="' + newUrl + '">' + newPage + '</a></li>');
        }
      }

      this.removeFile(file);
    },
  };
})(jQuery);

rideApp.assets = (function($, undefined) {
  var $document = $(document),
      $window = $(window),
      $html = $('html'),
      $body = $('body');

  var _initialize = function() {
    var $form = $('#form-filter');

    var page = $form.data('page');
    var limit = $form.data('limit');
    var labelSuccess = $form.data('label-success-order');
    var urlOrderFolder = $form.data('url-order-folder');
    var urlOrderAsset = $form.data('url-order-asset');

    $form.on('change', 'select[name=limit]', function(e) {
        var $select = $(this);

        $('input[name=_submit]', $select.closest('form')).val('limit');

        onApply($select, e);
    });
    $form.on('click', 'button:not([name=applyAction])', function(e) {
      var $button = $(this);

      $('input[name=_submit]', $button.closest('form')).val($button.val());

      return onApply($button, e);
    });
    $form.on('click', 'button[name=applyAction]', function(e) {
      var $button = $(this);

      $('input[name=_submit]', $button.closest('form')).val($button.val());

      return onApplyAction($button, e);
    });

    if (urlOrderFolder) {
      $(".asset-items-folders").sortable({
        cursor: "move",
        handle: ".order-handle",
        items: ".asset-item",
        select: false,
        scroll: true,
        update: function (event, ui) {
          var order = [];

          $('.asset-items-folders .asset-item').each(function() {
              var $this = $(this);

              order.push($this.data('id'));
          });

          $.post(urlOrderFolder, {order: order, page: page, limit: limit}, function() {
            rideApp.common.notifySuccess(labelSuccess);
          });
        }
      });
    }

    if (urlOrderAsset) {
      $(".asset-items-assets").sortable({
        cursor: "move",
        handle: ".order-handle",
        items: ".asset-item",
        select: false,
        scroll: true,
        update: function (event, ui) {
          var order = [];

          $('.asset-items-assets .asset-item').each(function() {
              var $this = $(this);

              order.push($this.data('id'));
          });

          $.post(urlOrderAsset, {order: order, page: page, limit: limit}, function() {
            rideApp.common.notifySuccess(labelSuccess);
          });
        }
      });
    }

    // embed modus
    $document.on('click', '.is-addable input[type=checkbox]', function(e) {
      var $this = $(this),
          $asset = $this.closest('.asset-item');
          id = $asset.data('id'),
          isSelected = $this.is(':checked');

      if (isSelected) {
        var name = $.trim($asset.find('.name').text()),
            thumb = $asset.find('.rounded').attr('src'),
            isAdded = parent.rideApp.form.assets.addAsset(id, name, thumb);

        if (!isAdded) {
          $this.prop('checked', false);
        }
      } else {
        parent.rideApp.form.assets.removeAsset(id);
      }
    });
  };

  var updateSelected = function(disableUnselected) {
      console.log(parent);
      console.log(disableUnselected);
    if (!parent) {
      return;
    }

    $('.asset-item[data-id] input[type=checkbox]').prop('checked', false);

    var selected = parent.rideApp.form.assets.getSelected();
    console.log(selected);
    for (i = 0; i < selected.length; i++) {
      $('.asset-item[data-id="' + selected[i] + '"] input[type=checkbox]').prop('checked', true);
    }

    if (disableUnselected) {
      $('.asset-items-assets .asset-item[data-id] input[type=checkbox]:not(:checked)').prop('disabled', true).parents('.asset-item').addClass('disabled');
    } else {
      $('.asset-items-assets .asset-item[data-id] input[type=checkbox]:not(:checked)').prop('disabled', false).parents('.asset-item').removeClass('disabled');
    }
  };

  var onApplyAction = function($button, e) {
    var willSubmit = true;

    var $form = $button.closest('form');
    var $select = $button.parent().prev();
    var messages = $form.data('confirm-messages');
    var action = $select.children(':selected').text();

    if (action == '---' || $select.val() == '') {
      return false;
    }

    if (messages[action]) {
      willSubmit = confirm(messages[action]);
    }

    if (!willSubmit) {
      $select.val($("option:first", $select).val());
      rideApp.form.cancelSubmit($form);
    }

    return willSubmit;
  };

  var onApply = function($element, e) {
    var $form = $element.closest('form');
    var $select = $form.find('select[name=action], select[name=order]');

    $select.val($("option:first", $select).val());

    if (rideApp.form.onSubmit($element)) {
      $form.submit();
    }
  };

  return {
    initialize: _initialize,
    onApplyAction: onApplyAction,
    onApply: onApply,
    updateSelected: updateSelected
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.assets.initialize();
});
