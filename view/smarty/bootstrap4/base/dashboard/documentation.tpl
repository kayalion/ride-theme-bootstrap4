{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.documentation"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.documentation"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.documentation"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include "helper/dashboard.prototype"}

    {$settingsMenu = $app.taskbar->getSettingsMenu()}
    {$item = $settingsMenu->getItem('title.documentation'|translate)}
    {$referer = "?referer=`$app.url.request|escape`"}

    {call "dashboardMenu" items=$item->getItems() referer=$referer}
{/block}
