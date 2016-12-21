var rideApp = rideApp || {};

rideApp.common = (function($, undefined) {
  var $document = $(document);
  var _hasLocalStorage = undefined;
  var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  }
  var latinMap = {
    "ã": "a",
    "á": "a",
    "à": "a",
    "ä": "a",
    "â": "a",
    "ẽ": "e",
    "é": "e",
    "è": "e",
    "ë": "e",
    "ê": "e",
    "ĩ": "i",
    "ì": "i",
    "í": "i",
    "ï": "i",
    "î": "i",
    "õ": "o",
    "ò": "o",
    "ó": "o",
    "ö": "o",
    "ô": "o",
    "ù": "u",
    "ú": "u",
    "ũ": "u",
    "ù": "u",
    "ü": "u",
    "û": "u",
    "ç": "c"
  }

  var hasLocalStorage = function() {
    if (_hasLocalStorage !== undefined) {
        return _hasLocalStorage;
    }

	try {
      var x = "--local storage test--"
      localStorage.setItem(x, x);
      localStorage.removeItem(x);

      _hasLocalStorage = true;
	} catch(e) {
      _hasLocalStorage = false;
	}

    return _hasLocalStorage;
  };

  var getFromLocalStorage = function(key, defaultValue) {
    if (!hasLocalStorage()) {
      return defaultValue;
    }

    var value = localStorage.getItem(key);
    if (value === null) {
      value = defaultValue;
    }

    return value;
  };

  var setToLocalStorage = function(key, value) {
    if (!hasLocalStorage()) {
      return false;
    }

    localStorage.setItem(key, value);

    return true;
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

  var escapeLatinChars = function(string) {
    var escapedString = '';

    for (var i = 0, l = string.length; i < l; i++) {
      var char = string.charAt(i);

      if (latinMap[char] !== undefined) {
        escapedString += latinMap[char];
      } else {
        escapedString += char;
      }
    }

    return escapedString;
  }

  var convertToSlug = function(string) {
    string = string.toString().toLowerCase();
    string = escapeLatinChars(string);
    string = string
      .replace(/\s+/g, '-')           // Replace spaces with -
      .replace(/\-\-+/g, '-')         // Replace multiple - with single -
      .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
      .replace(/^-+/, '')             // Trim - from start of text
      .replace(/-+$/, '')             // Trim - from end of text
    ;

    return string
  };

  var notifySuccess = function(message) {
    notifyMessage('success', message);
  };

  var notifyWarning = function(message) {
    notifyMessage('warning', message);
  };

  var notifyError = function(message) {
    notifyMessage('danger', message);
  };

  var notifyMessage = function(type, message) {
    $document.find('.bootstrap-growl').remove();

    $.bootstrapGrowl(message, {
      type: type,
      offset: {from: 'bottom', amount: 20},
      align: 'center',
      width: 'auto',
      delay: 5000
    });
  };

  var setLoading = function(isLoading, $element) {
    if ($element === undefined) {
      $element = $('body');
    }

    if (isLoading) {
      $element.addClass('is-loading');
      $element.find('.btn').prop('disabled', true).addClass('disabled');
    } else {
      $element.removeClass('is-loading');
      $element.find('.btn').prop('disabled', false).removeClass('disabled');
    }
  };

  return {
    hasLocalStorage: hasLocalStorage,
    getFromLocalStorage: getFromLocalStorage,
    setToLocalStorage: setToLocalStorage,
    getLanguage: getLanguage,
    escapeHtml: escapeHtml,
    escapeId: escapeId,
    unescapeHtml: unescapeHtml,
    notifySuccess: notifySuccess,
    notifyWarning: notifyWarning,
    notifyError: notifyError,
    setLoading: setLoading,
    convertToSlug: convertToSlug
  };
})(jQuery);

