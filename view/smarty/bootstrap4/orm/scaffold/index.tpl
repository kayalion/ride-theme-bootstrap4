{extends file="base/index"}

{block name="head_title" prepend}{$title} | {/block}

{block name="taskbar_panels" append}
    {if $localizeUrl}
        {call taskbarPanelLocales url=$localizeUrl locale=$locale locales=$locales}
    {/if}
{/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
    {if $meta->getOption('scaffold.expose')}
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {$title}
        </a>
    {elseif $meta->getName() == 'ImageStyle' || $meta->getName() == 'ImageTransformation'}
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        {if $meta->getName() == 'ImageTransformation'}
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => "ImageStyle", "locale" => $locale]}">
            {translate key="title.image.styles"}
        </a>
        {/if}
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {$title}
        </a>
    {else}
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm"}">
            {translate key="title.orm"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.model" parameters=["model" => $meta->getName()]}">
            {$meta->getName()}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {translate key="button.scaffold"}
        </a>
    {/if}
    </nav>

    <div class="page-header m-b-1">
        <h1>{$title}</h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/table" table=$table tableForm=$form tableActions=$actions}

    {if $exports}
        {translate key="label.export"}

        {foreach $exports as $extension => $url}
            <a href="{$url}" title="{translate key="label.export.to" format=$extension}">
                <img src="{image src="img/export/`$extension`.png"}" />
            </a>
        {/foreach}
    {/if}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
