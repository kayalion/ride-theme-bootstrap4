var rideApp = rideApp || {};

rideApp.common = (function($, undefined) {
  var $document = $(document);
  var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  var getLanguage = function() {
    var currentLocale = document.documentElement.lang;
    if (currentLocale == undefined) {
        currentLocale = 'sme';
    }

    return currentLocale.slice(0, 2);
  };

  var escapeId = function(string) {
    return "#" + String(string).replace(/(:|\.|\[|\]|\%|\<|\>|,)/g, "\\$1" );
  };

  var escapeHtml = function(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
      return entityMap[s];
    });
  };

  var unescapeHtml = function(string) {
    for (var char in entityMap) {
      string = string.replace(new RegExp(entityMap[char], 'g'), char);
    }

    return string;
  };

  var notifySuccess = function(message) {
    $.bootstrapGrowl(message, {
        type: 'success',
        offset: {from: 'bottom', amount: 20},
        align: 'center',
        width: 'auto',
        delay: 5000
    });
  };

  var notifyError = function(message) {
    $.bootstrapGrowl(message, {
      type: 'error',
      offset: {from: 'bottom', amount: 20},
      align: 'center',
      width: 'auto',
      delay: 5000
    });
  };

  return {
    getLanguage: getLanguage,
    escapeHtml: escapeHtml,
    escapeId: escapeId,
    unescapeHtml: unescapeHtml,
    notifySuccess: notifySuccess,
    notifyError: notifyError
  };
})(jQuery);

