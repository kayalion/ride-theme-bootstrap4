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
        <a class="breadcrumb-item" href="{url id="system.mail.templates.add" parameters=["locale" => $locale]}">
            {translate key="title.mail.templates.add"}
        </a>
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
        {call formRows form=$form}
        {call formActions referer=$referer submit="button.next"}
    </form>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
