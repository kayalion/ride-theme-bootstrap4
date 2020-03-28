{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.mail.templates"} | {/block}

{block name="taskbar_panels" append}
    {url id="system.mail.templates.locale" parameters=["locale" => "%locale%"] var="url"}
    {call taskbarPanelLocales url=$url locale=$locale locales=$locales}
{/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.mail.templates.locale" parameters=["locale" => $locale]}">
            {translate key="title.mail.templates"}
        </a>
        {if $mailTemplate->getId()}
        <a class="breadcrumb-item" href="{url id="system.mail.templates.add" parameters=["locale" => $locale]}">
            {translate key="title.mail.templates.add"}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="system.mail.templates.add" parameters=["locale" => $locale]}">
            {translate key="title.mail.templates.add"}
        </a>
        {/if}
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.mail.templates"}
            <small class="text-muted">{translate key="title.mail.templates.add"}</small>
        </h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form class="form-selectize" id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
        <div class="row">
            <div class="col-8">
                {call formRows form=$form}
            </div>
            <div class="col-4">
                <div class="sticky-top pt-10">
                    <div class="card mb-3">
                        <div class="card-header">{translate key="title.mail.variables.content"}</div>
                        <div class="bard-block">
                            <p class="pt-2 pl-2 pr-2">{translate key="label.mail.variables.content.description"}</p>
                            <table class="ml-2 mr-2 mb-2">
                            {foreach $contentVariables as $variableName => $variableDescription}
                                <tr>
                                    <td class="pr-1">
                                        <span class="badge badge-default js-content-variable-drag" data-variable="[[{$variableName}]]">{$variableName}</span>
                                    </td>
                                    <td>
                                        {$variableDescription|translate}
                                    </td>
                                </tr>
                            {/foreach}
                            </table>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">{translate key="title.mail.variables.recipient"}</div>
                        <div class="bard-block">
                            <p class="pt-2 pl-2 pr-2">{translate key="label.mail.variables.recipient.description"}</p>
                            <table class="ml-2 mr-2 mb-2">
                            {foreach $recipientVariables as $variableName => $variableDescription}
                                <tr>
                                    <td class="pr-1">
                                        <span class="badge badge-default js-recipient-variable-drag" data-variable="[[{$variableName}]]">{$variableName}</span>
                                    </td>
                                    <td>
                                        {$variableDescription|translate}
                                    </td>
                                </tr>
                            {/foreach}
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        {call formActions referer=$referer submit="button.save"}
    </form>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/jquery-ui.js"}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/modules/mail-templates.js"}
{/block}
