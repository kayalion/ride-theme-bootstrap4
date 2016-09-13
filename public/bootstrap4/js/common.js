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

  return {
    getLanguage: getLanguage,
    escapeHtml: escapeHtml,
    unescapeHtml: unescapeHtml
  };
})(jQuery);

