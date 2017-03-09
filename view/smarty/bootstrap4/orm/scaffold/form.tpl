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
    {if $entry->getId()}
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.action" parameters=["model" => $meta->getName(), "locale" => $locale, "action" => "edit", "id" => $entry->getId()]}">
            {$subtitle}
        </a>
    {else}
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.action" parameters=["model" => $meta->getName(), "locale" => $locale, "action" => "add"]}">
            {translate key="button.add"}
        </a>
    {/if}
    </nav>

    <div class="page-header mb-3">
        <h1>
            {$title}
        {if $subtitle}
            <small class="text-muted">{$subtitle}</small>
        {/if}
        </h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form class="form-selectize" id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
    {if $tabs}
        <ul class="nav nav-tabs mb-2">
        {foreach $tabs as $tabName => $tab}
            <li class="nav-item">
                <a class="nav-link{if $tabName == $activeTab} active{/if}" href="#{$tabName}" data-toggle="tab">
                    {translate key=$tab.translation}
                </a>
            </li>
        {/foreach}
        </ul>

        <div class="tab-content">
        {foreach $tabs as $tabName => $tab}
            <div id="{$tabName}" class="tab-pane{if $tabName == $activeTab} active{/if}">
            {foreach $tab.rows as $row}
                {call formRow form=$form row=$row}
            {/foreach}
            </div>
        {/foreach}
        </div>
    {/if}

        {call formRows form=$form}
        {call formActions referer=$referer submit=$translationSubmit|default:"button.save"}
    </form>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/bootstrap-datepicker.css" media="all"}
    {style src="bootstrap4/css/selectize.css" media="all"}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-ui.js"}
    {script src="bootstrap4/js/bootstrap-datepicker.js"}
    {script src="bootstrap4/js/selectize.js"}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
        {if $tabs}
        {script src="bootstrap4/js/tabs.js"}
    {/if}
{/block}
