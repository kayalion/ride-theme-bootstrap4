{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.mail.templates"} | {/block}

{block name="taskbar_panels" append}
    {url id="system.mail.templates.locale" parameters=["locale" => "%locale%"] var="url"}
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
        <a class="breadcrumb-item" href="{url id="system.mail.templates.locale" parameters=["locale" => $locale]}">
            {translate key="title.mail.templates"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.mail.templates"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {* {include file="helper/table" table=$table tableForm=$form} *}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
