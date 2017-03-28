{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="taskbar_panels" append}
    {if $asset->getId()}
        {url id="assets.asset.edit" parameters=["locale" => "%locale%", "asset" => $asset->getId()] var="url"}
    {else}
        {url id="assets.asset.add" parameters=["locale" => "%locale%"] var="url"}
        {if $folder && $folder->getId()}
            {$folderId = $folder->getId()}
            {$url = "`$url`?folder=`$folderId`"}
        {/if}
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
            <a class="breadcrumb-item" href="{$app.url.request}">
            {if $asset->getId()}
                {$asset->getName()}
            {else}
                {translate key="button.add.asset"}
            {/if}
            </a>
        </nav>
    {if !$embed}
        <h1>
            {translate key="title.assets"}
            <small class="text-muted">
        {if $asset->getId()}
            {$asset->getName()}
        {else}
            {translate key="button.add.asset"}
        {/if}
            </small>
        </h1>
    {/if}
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}
    <form id="{$form->getId()}" class="mb-2" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
    <div class="row">
        <div class="col-md-{if $asset->getId()}6{else}12{/if}">
            {call formRow form=$form row="asset"}
            {call formActions referer=$referer}
        </div>
        {if $asset->getId()}
        <div class="col-md-6">
            <ul class="nav nav-tabs mb-2">
                <li class="nav-item">
                    <a class="nav-link active" href="#original" data-toggle="tab">
                        {translate key="label.original"}
                    </a>
                </li>
            {foreach $styles as $style}
                {if $style->isExposed()}
                <li class="nav-item">
                    <a class="nav-link" href="#{$style->getSlug()}" data-toggle="tab">
                        {$style->getName()}
                    </a>
                </li>
                {/if}
            {/foreach}
            </ul>
            <div class="tab-content">
            <div id="original" class="tab-pane active">
                <dl>
                    <dt>{translate key="label.url"}</dt>
                    <dd>
                        {url id="assets.value" parameters=["asset" => $asset->getId()] var="valueUrl"}
                        <a href="{$valueUrl}">{$valueUrl}</a>
                    </dd>
                    <dt>{translate key="label.type"}</dt>
                    <dd>{$asset->getType()}</dd>
                    {if $dimension}
                        <dt>{translate key="label.dimension"}</dt>
                        <dd>{$dimension->getWidth()} x {$dimension->getHeight()}</dd>
                    {/if}
                </dl>

                {if $media}
                    <iframe width="560" height="315" src="{$media->getEmbedUrl()}" frameborder="0" allowfullscreen></iframe>
                {elseif $asset->isAudio()}
                     <audio controls>
                          <source src="{url id="assets.value" parameters=["asset" => $asset->getId()]}" type="{$asset->getMime()}">
                    </audio>
                {else}
                    {$image = $asset->getImage()}
                    {if $image}
                        <img class="img-fluid" src="{image src=$asset->getImage()}" />
                    {/if}
                {/if}
            </div>

            {foreach $styles as $style}
                {if $style->isExposed()}
                <div id="{$style->getSlug()}" class="tab-pane">
                    <ul>
                    {foreach $style->getTransformations() as $transformation}
                        <li>{$transformation->getName()}</li>
                    {/foreach}
                    </ul>
                    <div class="col-md-12">
                    <div class="form-group">
                        {call formWidget form=$form row="style-`$style->slug`"}
                        {call formWidgetErrors form=$form row="style-`$style->slug`"}
                    </div>
                    </div>
                </div>
            {/if}
            {/foreach}
            </div>
        </div>
        {/if}
    </div>
    </form>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {* {script src="bootstrap4/js/jquery-ui.js"} *}
    {script src="bootstrap4/js/tabs.js"}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
