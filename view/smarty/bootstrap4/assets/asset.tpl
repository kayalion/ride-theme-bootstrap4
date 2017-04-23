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
<form
    id="{$form->getId()}"
    class="asset-detail mb-2"
    action="{$app.url.request}"
    method="POST"
    role="form"
    enctype="multipart/form-data"
    data-url-api="{$app.url.base}/api/v1"
    data-label-image-style-saved="{"success.data.saved"|translate}"
    data-label-image-style-deleted="{"success.data.saved"|translate}"
>
    <div class="row">
        <div class="col-md-{if $asset->getId()}6{else}12{/if}">
            {call formRow form=$form row="asset"}
            {call formActions referer=$referer}
        </div>
        {if $asset->getId()}
        <div class="col-md-6">
            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <a class="nav-link active" href="#original" data-toggle="tab">
                        {translate key="label.original"}
                    </a>
                </li>
            {foreach $styles as $style}
                {if $style->isExposed()}
                <li class="nav-item">
                    <a class="nav-link" href="#{$style->getSlug()}" data-toggle="tab">
                        {$style->getFriendlyName()}
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
                        <dd>{$dimension->getWidth()}px &times; {$dimension->getHeight()}px</dd>
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
                {$cropRatio = null}
                <div id="{$style->getSlug()}" class="tab-pane image-style">
                    <p>{translate key="label.image.style.transformations.applied"}</p>
                    <ul>
                    {foreach $style->getTransformations() as $transformation}
                        {$dimension = null}
                        {$width = null}
                        {$height = null}

                        {$options = $transformation->getOptions()}
                        {foreach $options as $option}
                            {if $option->getKey() == 'width'}
                                {$width = $option->getValue()}
                            {/if}
                            {if $option->getKey() == 'height'}
                                {$height = $option->getValue()}
                            {/if}
                        {/foreach}

                        {if $width && $height}
                            {$cropRatio["width"] = $width}
                            {$cropRatio["height"] = $height}
                            {$dimension = "`$width`px &times; `$height`px"}
                        {/if}

                        <li>{$transformation->getName()}{if $dimension} ({$dimension}){/if}</li>
                    {/foreach}
                    </ul>

                    <div class="image-style-crop" data-asset="{$asset->getId()}" data-style="{$style->getId()}"{if $cropRatio} data-ratio="{$cropRatio['width'] / $cropRatio['height']}"{/if}>
                        <h4>{translate key="title.image.crop"}</h4>
                        <p>
                            <a href="#" class="btn btn-secondary image-style-crop-enable">
                                {translate key="button.crop.image"}
                            </a>
                        </p>

                        <div class="image-style-crop-image hidden-xs-up">
                            {* Use a scaled image to 2500px width for performance... *}
                            <div class="mb-3">
                                <img class="img-fluid" src="{image src=$asset->getImage() width=2500 transformation='resize'}" />
                            </div>

                            <div class="form-group form-actions mb-3">
                                <div class="loading">
                                    <span class="fa fa-spinner fa-pulse fa-2x"></span>
                                </div>

                                <a href="#" class="btn btn-primary image-style-crop-save">{translate key="button.crop"}</a>
                                <a href="#" class="btn btn-link image-style-crop-cancel">{translate key="button.cancel"}</a>
                            </div>
                        </div>
                    </div>

                    <div class="image-style-file">
                        <div class="form-group hidden-xs-up">
                            {call formWidget form=$form row="style-`$style->slug`"}
                            {call formWidgetErrors form=$form row="style-`$style->slug`"}
                        </div>

                        {$imageStyle = $asset->getStyle($style->getName())}
                        {if $imageStyle}
                        <div class="form-text form-image-style-preview text-muted mt-1">
                            <img src="{image src=$imageStyle->getImage() transformation="resize" width=100}" />
                            <a href="#" class="btn-image-style-delete" data-id="{$imageStyle->getId()}" data-message="{translate key="label.confirm.file.delete"}">
                                <span class="fa fa-remove"></span>
                                {translate key="button.delete"}
                            </a>
                        </div>
                        {/if}
                    </div>
                </div>
            {/if}
            {/foreach}
            </div>
        </div>
        {/if}
    </div>
    <div class="prototype-image-style-preview hidden-xs-up">
        <div class="form-text form-image-style-preview text-muted mt-1">
            <img src=""/>
            <a href="#" class="btn-image-style-delete" data-message="{translate key="label.confirm.file.delete"}">
                <span class="fa fa-remove"></span>
                {translate key="button.delete"}
            </a>
        </div>
    </div>
</form>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/cropper.css" media="all"}
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {* {script src="bootstrap4/js/jquery-ui.js"} *}
    {script src="bootstrap4/js/jquery-bootstrap-growl.js"}
    {script src="bootstrap4/js/tabs.js"}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/jsonapi.js"}
    {script src="bootstrap4/js/cropper.js"}
    {script src="bootstrap4/js/modules/assets-detail.js"}
{/block}
