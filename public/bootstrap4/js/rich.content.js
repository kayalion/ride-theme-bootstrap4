window.rideApp = window.rideApp || {};

rideApp.content = (function ($, undefined) {
  var locale;
  var apiClient = new JsonApiClient('/api/v1');
  var labels = {};

  function htmlEscape(str) {
    // http://stackoverflow.com/questions/1219860/html-encoding-in-javascript-jquery
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }

  var _initialize = function () {
    var $richContent = $('.js-rich-content');
    var $element;
    var options;
    var redactorOptions;

    locale = $richContent.data('locale');
    labels['button-browse'] = $richContent.data('label-button-browse') || 'Browse';
    labels['button-cancel'] = $richContent.data('label-button-cancel') || 'Cancel';
    labels['button-remove'] = $richContent.data('label-button-remove') || 'Remove';
    labels['button-select'] = $richContent.data('label-button-select') || 'Select';
    labels['code'] = $richContent.data('label-code') || 'Code';
    labels['credit'] = $richContent.data('label-credit') || 'Credit';
    labels['embed'] = $richContent.data('label-embed') || 'Embed';
    labels['file'] = $richContent.data('label-file') || 'File';
    labels['quote'] = $richContent.data('label-quote') || 'Quote';
    labels['image-center'] = $richContent.data('label-image-center') || 'Center';
    labels['image-left'] = $richContent.data('label-image-left') || 'Left';
    labels['image-position'] = $richContent.data('label-image-position') || 'Image position';
    labels['image-right'] = $richContent.data('label-image-right') || 'Right';
    labels['image-stretch'] = $richContent.data('label-image-strectch') || 'Stretch';

    SirTrevor.Blocks.Heading = customBlocks.heading();
    SirTrevor.Blocks.Asset = customBlocks.asset();
    SirTrevor.Blocks.Tweet = customBlocks.tweet();
    SirTrevor.Blocks.Quote = customBlocks.quote();
    SirTrevor.Blocks.Wysiwyg = customBlocks.wysiwyg();
    SirTrevor.Blocks.Embed = customBlocks.embed();
    SirTrevor.Blocks.Code = customBlocks.code();

    $richContent.each(function () {
      $element = $(this);
      options = $element.data('rich-content-properties');
      redactorOptions = $element.data('redactor-properties');

      options = $.extend(options, {
        "el": $element
      });

      new SirTrevor.Editor(options);

      $(this.form).find('[type="submit"]').on('click', function (e) {
        var editor = SirTrevor.getInstance($(e.target.form).find('.js-rich-content').closest('[id^="st-editor-"]').attr('id'));
        $.each(editor.block_manager.blocks, function () {
          if (!this.valid()) {
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
            return false;
          }
        });
      });

    });

  };

  var customBlocks = {

    //  START WYSIWYG
    wysiwyg: function () {
      return SirTrevor.Block.extend({
        type: "Wysiwyg",

        title: function () {
          return 'Wysiwyg';
        },

        icon_name: 'text',

        editorHTML: function() {
          var redactorProperties = SirTrevor.getInstance(this.instanceID).$el.data('redactor-properties');
          return '<textarea class="wysiwyg" data-redactor-properties="' + htmlEscape(JSON.stringify(redactorProperties)) + '"></textarea>';
        },

        loadData: function (data) {
          var $editor = $(this.$editor);
          $editor.html(data.text);
        },

        save: function () {
          var dataObj = {};
          dataObj.text = this.$editor.val();

          if (!_.isEmpty(dataObj)) {
            this.setData(dataObj);
          }
        },

        onBlockRender: function (data){
          var textarea = this.$editor;

          //  Initialize redactor
          $(document).trigger('collectionAdded');
        }
      });
    },
    //  END WYSIWYG

    //  START HEADING
    heading: function () {
      var _template = _.template('<<%- tagName %> class="st-required st-text-block st-text-block--heading" contenteditable="true"><%= text %></<%- tagName %>>');
      var _setHeading = function(tag) {
        return function() {
          this.$('.st-block-control-ui-btn--active').removeClass('st-block-control-ui-btn--active');

          var textBlock = this.$('.st-text-block');

          textBlock.replaceWith(_template({
            tagName: tag,
            text: textBlock.html()
          }));

          this.$('.st-block-control-ui-btn--setHeading' + tag[1]).addClass('st-block-control-ui-btn--active');
        };
      };

      return SirTrevor.Blocks.Heading.extend({
        editorHTML: function() {
          return _template({
            tagName: 'h2',
            text: ''
          });
        },

        controllable: true,

        controls: {
          setHeading2: _setHeading('h2'),
          setHeading3: _setHeading('h3'),
          setHeading4: _setHeading('h4')
        },

        loadData: function(data) {
          _setHeading(data.tagName);
          this.$('.st-text-block').html(data.text);
        },

        toData: function() {
          var dataObj = {};

          dataObj.text = SirTrevor.toHTML(this.getTextBlock().html(), this.type);
          dataObj.tagName = this.getTextBlock().prop('tagName');

          this.setData(dataObj);
        }

      });
    },
    // END HEADING

    //  START ASSET
    asset: function () {
      var assetCounter = 0;
      var origin = window.location.origin;

      var assetTemplate = [
        '<div class="row form-group st-assets-block">',
          '<div class="col-sm-6">',
            '<label for="%assetId%" class="d-block">' + labels['file'] + '</label>',
            '<div>',
              '<div class="form-assets clearfix" data-field="%assetId%" data-max="1"></div>',
              '<div class="clearfix" data-field="%assetId%" data-max="1">',
                '<a class="btn btn-secondary float-sm-left mb-1 mr-2 form-assets-add" href="#">',
                  '<i class="fa fa-image"></i> ' + labels['button-browse'],
                '</a>',
              '</div>',
            '</div>',
            '<input type="hidden" name="%assetId%" id="%assetId%" data-name="%assetName%" class="st-id-input st-required" />',
          '</div>',
          '<div class="col-sm-6">',
            '<label for="assetClass" class="d-block">' + labels['image-position'] + '</label>',
            '<select name="className" id="assetClass" class="st-className-input custom-select selectized">',
              '<option value="left">' + labels['image-left'] + '</option>',
              '<option value="center">' + labels['image-center'] + '</option>',
              '<option value="right">' + labels['image-right'] + '</option>',
              '<option value="stretch" selected>' + labels['image-stretch'] + '</option>',
            '</select>',
          '</div>',

          '<div class="modal fade" id="%assetName%" tabindex="-1" role="dialog" aria-labelledby="%assetName%" aria-hidden="true">',
              '<div class="modal-dialog modal-full modal-assets">',
                  '<div class="modal-content">',
                      '<div class="modal-body is-loading">',
                          '<div class="loading">',
                              '<span class="fa fa-spinner fa-pulse fa-2x"></span>',
                          '</div>',
                          '<iframe id="%assetId%-iframe" data-src="' + origin + '/admin/assets/' + locale + '?embed=1&amp;selected=" frameborder="0" width="100%" height="500"></iframe>',
                      '</div>',
                      '<div class="modal-footer">',
                        '<div class="container">',
                            '<div class="row">',
                                '<div class="col-xs-7 col-md-8">',
                                    '<div class="form-assets" data-field="%assetId%" data-max="1">',
                                    '</div>',
                                '</div>',
                                '<div class="col-xs-5 col-md-4 text-right">',
                                    '<button type="button" class="btn btn-primary form-assets-done">',
                                        labels['button-select'],
                                    '</button>',
                                    '<button type="button" class="btn btn-link" data-dismiss="modal">',
                                        labels['button-cancel'],
                                    '</button>',
                                '</div>',
                            '</div>',
                        '</div>',
                      '</div>',
                  '</div>',
              '</div>',
          '</div>',
        '</div>'
      ].join('\n');

      var thumbTemplate = [
        '<div class="form-assets-asset" data-id="%assetId%">',
            '<img class="rounded" src="%assetSrc%" width="100" height="100">',
            '<a href="#" class="btn btn-secondary btn-xs form-assets-remove" title="' + labels['button-remove'] + '">',
                '<span class="fa fa-remove"></span>',
            '</a>',
        '</div>'
      ].join('\n');

      return SirTrevor.Block.extend({
        type: 'asset',
        icon_name: 'image',
        editorHTML: function() {
          var html = assetTemplate;
          html = rideApp.common.replaceAll(html, '%assetId%', 'rich-content-asset-' + assetCounter);
          html = rideApp.common.replaceAll(html, '%assetName%', 'modal-assets-' + assetCounter);

          assetCounter++;

          return html;
        },
        getIdInput: function() {
          return this.$('.st-id-input');
        },
        getClassNameInput: function() {
          return this.$('.st-className-input');
        },
        getAssetBlock: function() {
          return this.$('.st-assets-block');
        },
        onBlockRender: function() {
          // console.log($('.form-assets-add', $(document)));
          // rideApp.form.selectize();
        },
        renderAndAddThumbnailWrapper: function($element, data) {
          var html = thumbTemplate;
          html = rideApp.common.replaceAll(html, '%assetId%', data.id);
          html = rideApp.common.replaceAll(html, '%assetSrc%', data.thumb);

          $('.form-assets', $element).append(html);
        },
        loadData: function(data) {
          if (!data.id) {
            return;
          }
          var self = this;

          self.getIdInput().val(data.id);
          var $assetBlock = self.getAssetBlock();

          if (!data.thumb) {
            var url = apiClient.url + '/assets/' + data.id + '?fields[assets]=&url=true';
            apiClient.sendRequest('GET', url, null, function(apiData) {
              data.thumb = apiData._meta.url;

              self.renderAndAddThumbnailWrapper($assetBlock, data);
            });
          } else {
            self.renderAndAddThumbnailWrapper($assetBlock, data);
          }

          if (data.className) {
            self.getClassNameInput().find('option[value=' + data.className + ']').prop('selected', 'selected');
          }
        },
        save: function() {
          var self = this;
          var dataObj = {};
          var $assetThumb = self.getAssetBlock().find('img');

          dataObj.id = self.getIdInput().val();
          dataObj.thumb = $assetThumb.attr('src');
          dataObj.className = self.getClassNameInput().val();

          // if (dataObj.id !== '' && dataObj.assetEntry === undefined) {
          //   var url = apiClient.url + '/assets/' + dataObj.id + '?fields[assets]=id,name,alt,copyright,embedUrl,mime&url=true&images=true';
          //   apiClient.sendRequest('GET', url, null, function(data) {
          //     dataObj.assetEntry = data;
          //     self.toData(dataObj);
          //   });
          // } else {
            self.toData(dataObj);
          // }
        },
        toData: function(data) {
          this.setData(data);
        }

      });
    },
    //  END ASSET

    //  START QUOTE
    quote: function () {
      return SirTrevor.Block.extend({
        type: 'quote',

        title: function () {
          return 'Quote';
        },

        icon_name: 'quote',

        editorHTML: [
          '<div class="form-group">',
          '<label class="d-block">' + labels['quote'] + '</label>',
          '<textarea name="text" class="form-control st-required st-quote-text" cols="90" rows="4"></textarea>',
          '</div>',
          '<div class="form-group">',
          '<label class="d-block">' + labels['credit'] + '</label>',
          '<input type="text" name="cite" class="form-control st-cite-input"/>',
          '</div>',
        ].join('\n'),

        loadData: function (data) {
          this.$('.st-quote-text').html(data.text);

          if (data.cite) {
            this.$('.st-cite-input').val(data.cite);
          }
        }
      });
    },
    //  END QUOTE

    //  START TWEET
    tweet: function () {
      return SirTrevor.Block.extend({
        type: 'tweet',

        icon_name: 'twitter',

        title: function () {
          return 'Tweet';
        },

        editorHTML: [
          '<div class="form-group">',
          '<label for="st-tweet-embed" class="d-block">' + labels['embed'] + '</label>',
          '<textarea name="st-tweet-embed" class="form-control st-required" cols="90" rows="4"></textarea>',
          '<div class="st-tweet-preview mt-3"></div>',
          '</div>'
        ].join('\n'),

        getEmbedInput: function () {
          return this.$('textarea');
        },

        getPreviewElement: function () {
          return this.$('.st-tweet-preview');
        },

        loadData: function (data) {
          this.getPreviewElement().html(data.embedCode);
          this.getEmbedInput().text(data.embedCode);
        },

        onBlockRender: function () {
          var self = this;
          this.getEmbedInput().on('keyup', function (e) {
            self.setAndLoadData({
              embedCode: e.target.value
            });
          });
        }

      });

    },
    //  END TWEET

    //  START EMBED
    embed: function () {
      return SirTrevor.Block.extend({
        type: 'embed',

        icon_name: 'iframe',

        title: function () {
          return 'Embed';
        },

        editorHTML: [
          '<div class="form-group">',
          '<label for="st-embed" class="d-block">' + labels['embed'] + '</label>',
          '<textarea name="st-embed" class="form-control st-required" cols="90" rows="4"></textarea>',
          '<div class="st-embed-preview mt-3"></div>',
          '</div>'
        ].join('\n'),

        getEmbedInput: function () {
          return this.$('textarea');
        },

        getPreviewElement: function () {
          return this.$('.st-embed-preview');
        },

        loadData: function (data) {
          this.getPreviewElement().html(data.embedCode);
          this.getEmbedInput().text(data.embedCode);
        },

        onBlockRender: function () {
          var self = this;
          this.getEmbedInput().on('keyup', function (e) {
            self.setAndLoadData({
              embedCode: e.target.value
            });
          });
        }
      });
    },
    //  END EMBED

    //  START CODE
    code: function () {
      return SirTrevor.Block.extend({
        type: 'code',

        title: function () {
          return 'Code';
        },

        icon_name: 'iframe',

        editorHTML: [
          '<div class="form-group">',
          '<label class="d-block">' + labels['code'] + '</label>',
          '<textarea name="code" class="form-control st-required st-code" cols="80" rows="10"></textarea>',
          '</div>'
        ].join('\n'),

        loadData: function (data) {
          if (data.code) {
            this.$('.st-code').val(data.code);
          }
        }
      })

    }
    //  END CODE

  };

  return {
    init: _initialize
  };
})(jQuery);

$(document).ready(function() {
  rideApp.content.init();
});
