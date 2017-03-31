var rideApp = rideApp || {};

rideApp.assetDetail = (function($, undefined) {
  var $document = $(document),
      $window = $(window),
      $html = $('html'),
      $body = $('body');

  var _initialize = function() {
    var $form = $('form.asset-detail');
    var urlApi = $form.data('url-api');
    var client = new JsonApiClient(urlApi);
    var imageStyleSaved = $form.data('label-image-style-saved');
    var imageStyleDeleted = $form.data('label-image-style-deleted');
    var asset = null;

    $('.image-style').each(function() {
      var cropper;
      var $imageStyle = $(this);
      var $file = $imageStyle.find('.image-style-file');
      var $crop = $imageStyle.find('.image-style-crop');
      var assetId = $crop.data('asset');
      var imageStyleId = $crop.data('style');
      var ratio = $crop.data('ratio');

      $crop.find('.image-style-crop-enable').on('click', function(e) {
        e.preventDefault();

        var $this = $(this);
        var $image = $('.image-style-crop-image', $crop);

        $file.addClass('hidden-xs-up');
        $this.parent('p').addClass('hidden-xs-up');
        $image.removeClass('hidden-xs-up');

        cropper = new Cropper($('img', $image)[0], {
          aspectRatio: ratio,
          zoomOnWheel: false,
          movable: false
        });
      });

      $crop.find('.image-style-crop-cancel').on('click', function(e) {
        e.preventDefault();

        cropper.destroy();

        $('p', $crop).removeClass('hidden-xs-up');
        $file.removeClass('hidden-xs-up');
        $('.image-style-crop-image', $crop).addClass('hidden-xs-up');
      });

      $crop.find('.image-style-crop-save').on('click', function(e) {
        e.preventDefault();

        rideApp.common.setLoading(true, $imageStyle);

        if (!asset) {
          client.load('assets', assetId, function(data) {
            asset = data;

            loadImageStyle($imageStyle, cropper, asset, imageStyleId);
          }, function() {
            rideApp.common.setLoading(false, $imageStyle);
            rideApp.common.notifyError("Error: could not load the asset");
          });
        } else {
          loadImageStyle($imageStyle, cropper, asset, imageStyleId);
        }
      });
    });

    function loadImageStyle($container, cropper, asset, imageStyleId) {
      client.load('image-styles', imageStyleId, function(data) {
        saveImageForImageStyle($container, cropper, asset, data);
      }, function() {
          rideApp.common.setLoading(false, $container);
          rideApp.common.notifyError("Error: could not load the image style");
      });
    }

    function saveImageForImageStyle($container, cropper, asset, imageStyle) {
      var url = client.url + '/asset-image-styles?filter[exact][asset]=' + asset.id + '&filter[exact][style]=' + imageStyle.id + '&fields[asset-image-styles]=id';
      var dataUrl = cropper.getCroppedCanvas().toDataURL();

      client.sendRequest('GET', url, null, function(data) {
        var assetImageStyle = null;

        if (data.length) {
          // existing image style for asset, update
          data[0].setAttribute('image', dataUrl);

          assetImageStyle = data[0];
        } else {
          // create new image style for asset
          assetImageStyle = new JsonApiDataStoreModel('asset-image-styles');

          assetImageStyle.setRelationship('asset', asset);
          assetImageStyle.setRelationship('style', imageStyle);
          assetImageStyle.setAttribute('image', dataUrl);
        }

        client.save(assetImageStyle, function(data) {
          finishUpdate($container, cropper, dataUrl, data.id);
        }, function() {
          rideApp.common.setLoading(false, $container);
          rideApp.common.notifyError("Error: could not save the image of the image style");
        });
      }, function() {
          rideApp.common.setLoading(false, $container);
          rideApp.common.notifyError("Error: could not load current image of the image style");
      });
    }

    function finishUpdate($container, cropper, dataUrl, id) {
      var $crop = $container.find('.image-style-crop');
      var $file = $container.find('.image-style-file');

      var $preview = $('.form-image-style-preview', $file);
      if ($preview.length === 0) {
        $file.append($('.prototype-image-style-preview', $form).html());

        $preview = $('.form-image-style-preview', $file);
      }

      $('img', $preview).attr('src', dataUrl);
      $('.btn-image-style-delete', $preview).attr('data-id', id);

      $preview.removeClass('hidden-xs-up');

      cropper.destroy();

      $('p', $crop).removeClass('hidden-xs-up');
      $file.removeClass('hidden-xs-up');
      $('.image-style-crop-image', $crop).addClass('hidden-xs-up');

      rideApp.common.setLoading(false, $container);
      rideApp.common.notifySuccess(imageStyleSaved.replace('%data%', $('#asset-asset-name').val()));
    }

    $document.on('click', '.image-style .btn-image-style-delete', function(e) {
      e.preventDefault();

      var $link = $(this);
      if (confirm($link.data('message'))) {
        var id = $link.data('id');
        var $preview = $link.closest('.form-image-style-preview');

        var url = client.url + '/asset-image-styles/' + id;

        client.sendRequest('DELETE', url, null, function() {
          $('input[type=file]', $link.parents('.image-style-file')).prev().val('');
          $preview.remove();

          rideApp.common.notifySuccess(imageStyleDeleted.replace('%data%', $('#asset-asset-name').val()));
        });
      }
    });
  };

  return {
    initialize: _initialize,
  };
})(jQuery);

// Run the initializer
$(document).ready(function() {
  rideApp.assetDetail.initialize();
});
