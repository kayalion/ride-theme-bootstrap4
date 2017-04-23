{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.system"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.system"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include "helper/dashboard.prototype"}

    {$settingsMenu = $app.taskbar->getSettingsMenu()}
    {$item = $settingsMenu->getItem('system.menu')}
    {$referer = "?referer=`$app.url.request|escape`"}

    {call "dashboardMenu" items=$item->getItems() referer=$referer}
{/block}
