{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.translations"} | {/block}

{block name="taskbar_panels" append}
    {url id="system.translations.locale" parameters=["locale" => "%locale%"] var="url"}
    {if $query}
        {$url = "`$url`?query=`$query|escape`"}
    {/if}
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
        <a class="breadcrumb-item" href="{url id="system.locales"}">
            {translate key="title.locales"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.translations" parameters=["locale" => $locale]}">
            {translate key="title.translations"}
            ({translate key="language.`$locale`"})
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.translations"}
            <small class="text-muted">{translate key="language.`$locale`"}</small>
        </h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <div class="row mb-1">
        <div class="col-6">
            <a href="#" class="btn btn-secondary btn-add">
                {translate key="button.translation.add"}
            </a>
        </div>
        <div class="col-6">
            <form class="form" id="form-search" action="{$app.url.request}" role="search" method="GET">
                <div class="form-group float-right">
                    <div class="input-group add-on">
                        <input type="text" name="query" class="form-control" placeholder="{translate key="label.search.query"}" value="{$query|escape}" />
                        <div class="input-group-btn">
                            <button type="submit" name="submit" class="btn btn-secondary" title="{"button.search"|translate}">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

<form id="{$form->getId()}"
      action="{$app.url.request}"
      method="POST"
      role="form"
      data-message-success-save="{"success.translation.saved"|translate|escape}"
      data-message-success-delete="{"success.translation.deleted"|translate|escape}"
      data-message-error-save="{"error.translation.saved"|translate|escape}"
      data-message-error-delete="{"error.translation.deleted"|translate|escape}">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr>
                <th>{translate key="label.key"}</th>
                <th>{translate key="label.translation"}</th>
            </tr>
        </thead>
        <tbody>
            <tr class="form hidden-xs-up">
                <td>
                    <div class="form-group">
                        {call formWidget form=$form row="key"}
                        {call formWidgetErrors form=$form row="key"}
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        {call formWidget form=$form row="translation"}
                        {call formWidgetErrors form=$form row="translation"}
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            {translate key="button.save"}
                        </button>
                        <a href="#" class="btn btn-cancel">
                            {translate key="button.cancel"}
                        </a>
                    </div>

                    {call formRows form=$form}
                </td>
            </tr>
    {foreach $translations as $key => $value}
            <tr data-translation="{$key}">
                <td class="translation-key">
                    <a class="btn-edit" href="{url id="system.translations.edit" parameters=["locale" => $locale, "key" => $key]}{if $referer}?referer={$referer|escape}{/if}">
                        {$key}
                    </a>
                </td>
                <td class="translation-value">{$value|escape}</td>
            </tr>
    {/foreach}
        </tbody>
    </table>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/jquery-bootstrap-growl.js"}
    {script src="bootstrap4/js/modules/system-translations.js"}
{/block}
