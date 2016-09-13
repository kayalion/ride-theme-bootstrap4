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
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {$title}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.action" parameters=["model" => $meta->getName(), "locale" => $locale, "id" => $entry->getId(), "action" => "detail"]}">
            {$entry->getName()}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{$title}</h1>
    </div>
{/block}

{block name="content" append}

    <h2 class="m-b-2">
        {translate key="title.details"}
    </h2>
    <div class="btn-group m-b-2">
        <a href="{$editUrl}" class="btn btn-secondary">
            {translate key="button.event.edit"}
        </a>
    </div>
    {if $entry->getImage() || $entry->getDescription()}
    <div class="media m-b-2">
        <span class="media-left text-xs-center" " style="min-width: 4em;">
            <img src="{image src=$entry->image transformation="crop" width=250 height=250}" class="img-responsive" />
        </span>
        <div class="media-body">
            {$entry->getDescription()}
        </div>
    </div>
    {/if}

    <h2 class="m-b-2">
        {translate key="title.performances"}
    </h2>
    {$tableActions = [(string) $addPerformanceUrl => "button.performance.add"|translate]}

    {include file="helper/table" table=$table tableForm=$form tableActions = $tableActions}
{/block}

{block name="scripts_app" append}
    {script src="bootstrap/js/jquery-ui.js"}
    {script src="bootstrap/js/form.js"}
    {script src="bootstrap/js/table.js"}
{/block}
