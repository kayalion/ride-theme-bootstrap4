{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="content_title"}
<div class="page-header{if !$embed} mb-3{/if}">
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="assets.overview.locale" parameters=["locale" => $locale]}">
            {translate key="title.assets"}
        </a>
    </nav>
    <h1>
        {translate key="title.assets"}
        <small class="text-muted">
            {translate key="button.move"}
        </small>
    </h1>
</div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" class="form" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form}
        {call formActions referer=$referer submit="button.move"}
    </form>

    <hr  />

<div class="assets assets-grid">
    <div class="asset-items clearfix">

    <div class="row" data-order="true">
        <div class="asset-items-folders">
        {foreach $folders as $item}
            <div class="asset-item">
                <span class="float-left mr-3">&nbsp;</span>
                <div class="image">
                    <span class="fa fa-folder-open-o fa-6x"></span>
                </div>
                <div class="name">
                    {$item->getName()|escape|truncate:14}
                </div>
            </div>
        {/foreach}
        </div>

        <div class="asset-items-assets">
        {foreach $assets as $item}
            <div class="asset-item">
                <span class="float-left mr-3">&nbsp;</span>
                <div class="image">
                    <img src="{image src=$item->getThumbnail() default="bootstrap4/img/asset-`$item->getType()`.png" width=120 height=120 transformation="crop"}" class="rounded" />
                </div>
                <div class="name">
                    {$item->getName()|escape|truncate:14}
                </div>
            </div>
        {/foreach}
        </div>
    </div>
</div>
</div>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/dropzone.css" media="screen"}
    {style src="bootstrap4/css/modules/assets.css" media="screen"}
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
