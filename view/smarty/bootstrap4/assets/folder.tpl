{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="taskbar_panels" append}
    {if $folder->getId()}
        {url id="assets.folder.edit" parameters=["locale" => "%locale%", "folder" => $folder->getId()] var="url"}
    {else}
        {url id="assets.folder.add" parameters=["locale" => "%locale%"] var="url"}
    {/if}

    {call taskbarPanelLocales url=$url locale=$locale locales=$locales}
{/block}

{block name="content_title" append}
    <div class="page-header mb-3">
        <nav class="breadcrumb">
        {if !$embed}
            <a class="breadcrumb-item" href="{url id="admin"}">
                {translate key="title.admin.home"}
            </a>
            <a class="breadcrumb-item" href="{url id="content"}">
                {translate key="title.content"}
            </a>
        {/if}
            <a class="breadcrumb-item" href="{url id="assets.overview.locale" parameters=["locale" => $locale]}?embed={$embed}">
                {translate key="title.assets"}
            </a>
            {foreach $breadcrumbs as $id => $name}
                <a class="breadcrumb-item" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $id]}?embed={$embed}">
                    {$name}
                </a>
            {/foreach}
            {if !$folder->getId()}
            <a class="breadcrumb-item" href="{$app.url.request}">
                {translate key="button.add.folder"}
            </a>
            {/if}
        </nav>
    {if !$embed}
        <h1>
            {translate key="title.assets"}
            <small>
    {if $folder->getId()}
        {$folder->getName()}
    {else}
        {translate key="button.add.folder"}
    {/if}
            </small>
        </h1>
    {/if}
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form}
        {call formActions referer=$referer}
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
