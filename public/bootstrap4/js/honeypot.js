$.fn.honeyPot = function(options) {
    var $this = $(this);

    $(options.fields).each(function(index, value) {
        var $input = $('.row-' + value + ' input', $this);
        if ($input.length === 0) {
            return;
        }

        var defaultValue = $input.data('value');
        if (defaultValue) {
            $input.val(defaultValue);
        }

        $input.closest('.form-group').hide();
    });

    $this.on('submit', function() {
        var submitValue = '';

        $(options.fields).each(function(index, value) {
            var $input = $('.row-' + value + ' input', $this);
            var val = $input.val();

            if (val === '') {
                val = value;
            } else {
                val = value + ':' + val;
            }

            submitValue += (submitValue === '' ? '' : ',') + val;
        });

        $(options.submit, $this).val(submitValue);
    });
};
