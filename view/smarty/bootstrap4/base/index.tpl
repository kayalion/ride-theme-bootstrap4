<!DOCTYPE html>
<html lang="{$app.locale|replace:"_":"-"}">
    <head>
{block name="head"}
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>{block name="head_title"}{if isset($app.taskbar)}{$app.taskbar->getTitle()|strip_tags}{/if}{/block}</title>
    {block name="styles"}
        {style src="bootstrap4/css/bootstrap.css" media="all"}
        {style src="bootstrap4/css/bootstrap-customize.css" media="all"}
        {style src="bootstrap4/css/font-awesome.css" media="all"}
    {/block}

    {block name="styles_app"}
        {if isset($app.styles)}
            {foreach $app.styles as $style => $dummy}
                {if substr($style, 0, 7) == 'http://' || substr(style, 0, 8) == 'https://' || substr($style, 0, 2) == '//'}
                    {style src=$style media="screen"}
                {else}
                    {style src="bootstrap4/`$style`" media="all"}
                {/if}
            {/foreach}
        {/if}
    {/block}

    {styles}
{/block}
    </head>
    <body{block name="body_attributes"}{/block}>
{block name="body"}
    {block name="taskbar"}
        {if isset($app.taskbar)}
            {include file="helper/taskbar" title=$app.taskbar->getTitle() applicationsMenu=$app.taskbar->getApplicationsMenu() settingsMenu=$app.taskbar->getSettingsMenu()}
        {/if}
    {/block}
    {block name="container"}
        <div class="container">
        {block name="content"}
            {block name="content_title"}{/block}
            {block name="messages"}
                {if isset($app.messages)}
                    {include file="helper/messages" messages=$app.messages}
                {/if}
            {/block}
            {block name="content_body"}{/block}
        {/block}
        </div>
    {/block}

    {block name="scripts"}
        {script src="bootstrap4/js/jquery.js"}
        {script src="bootstrap4/js/tether.js"}
        {script src="bootstrap4/js/bootstrap.js"}
        {script src="bootstrap4/js/common.js"}
    {/block}

    {block name="scripts_app"}
    {if isset($app.javascripts)}
        {foreach $app.javascripts as $script => $dummy}
            {if substr($script, 0, 7) == 'http://' || substr(script, 0, 8) == 'https://' || substr($script, 0, 2) == '//' || substr($script, 0, 7) == '<script'}
                {script src=$script}
            {else}
                {script src="bootstrap4/`$script`"}
            {/if}
        {/foreach}
    {/if}
    {/block}

    {scripts}

    {block name="scripts_inline"}
    {if isset($app.inlineJavascripts)}
        <script type="text/javascript">
            $(function() {
            {foreach $app.inlineJavascripts as $inlineJavascript}
                {$inlineJavascript}
            {/foreach}
            });
        </script>
    {/if}
    {/block}
{/block}
    </body>
</html>
