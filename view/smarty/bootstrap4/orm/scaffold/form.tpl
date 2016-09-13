{extends file="base/index"}

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

    <div class="page-header m-b-2">
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

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
    {if $tabs}
        <ul class="nav nav-tabs m-b-2">
        {foreach $tabs as $tabName => $tab}
            <li class="nav-item">
                <a class="nav-link{if $tabName == $activeTab} active{/if}" href="#tab{$tabName}" data-toggle="tab">
                    {translate key=$tab.translation}
                </a>
            </li>
        {/foreach}
        </ul>

        <div class="tab-content">
        {foreach $tabs as $tabName => $tab}
            <div id="tab{$tabName}" class="tab-pane{if $tabName == $activeTab} active{/if}">
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

{block name="scripts" append}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
