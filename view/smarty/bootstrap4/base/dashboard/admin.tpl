{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.admin.home"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.admin.home"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include "helper/dashboard.prototype"}

    {$referer = "?referer=`$app.url.request|escape`"}

    {$applicationsMenu = $app.taskbar->getApplicationsMenu()}
    {$items = $applicationsMenu->getItems()}

    {foreach $items as $item}
    {if $item instanceof \ride\web\base\menu\Menu}
        {call "dashboardMenu" items=$item->getItems() title=$item->getLabel() referer=$referer}
    {/if}
    {/foreach}

    {$settingsMenu = $app.taskbar->getSettingsMenu()}
    {$items = $settingsMenu->getItems()}

    {foreach $items as $item}
    {if $item instanceof \ride\web\base\menu\Menu}
        {if $item->getId() == 'user.menu'}
            {continue}
        {/if}

        {call "dashboardMenu" items=$item->getItems() title=$item->getLabel() referer=$referer}
    {/if}
    {/foreach}
{/block}
