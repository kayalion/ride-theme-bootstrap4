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
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {translate key=$meta->getOption('scaffold.title')}
        </a>
        <a class="breadcrumb-item" href="{url id="calendar.event.detail" parameters=["locale" => $locale, "id" => $entry->getId()]}">
            {$entry->getName()}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {$title}
            <small class="text-muted">
                {$subtitle}
            </small>
        </h1>
    </div>
{/block}

{block name="content" append}
    <div class="btn-group mb-3">
        <a href="{$editUrl}" class="btn btn-secondary">
            {translate key="button.event.edit"}
        </a>
    </div>
    {if $entry->getImage() || $entry->getDescription()}
    <div class="media mb-3">
        <span class="media-left text-xs-center" " style="min-width: 4em;">
            <img src="{image src=$entry->image transformation="crop" width=250 height=250}" class="img-fluid" />
        </span>
        <div class="media-body">
            {$entry->getDescription()}
        </div>
    </div>
    {/if}

    <h2 class="mb-3">
        {translate key="title.performances"}
    </h2>

    {$tableActions = ["`$addPerformanceUrl`" => "button.performance.add"|translate]}

    {include file="helper/table" table=$table tableForm=$form tableActions = $tableActions}
{/block}

{block name="scripts_app" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
