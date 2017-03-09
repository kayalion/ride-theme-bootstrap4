{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.security"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security"}">
            {translate key="title.security"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.security"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include "helper/dashboard.prototype"}

    {$settingsMenu = $app.taskbar->getSettingsMenu()}
    {$item = $settingsMenu->getItem('security.menu')}
    {$referer = "?referer=`$app.url.request|escape`"}

    {call "dashboardMenu" items=$item->getItems() referer=$referer}
{/block}
