{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.content"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.content"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include "helper/dashboard.prototype"}

    {$menu = $app.taskbar->getApplicationsMenu()}
    {$item = $menu->getItem('content.menu')}
    {$referer = "?referer=`$app.url.request|escape`"}

    {call "dashboardMenu" items=$item->getItems() referer=$referer}
{/block}
