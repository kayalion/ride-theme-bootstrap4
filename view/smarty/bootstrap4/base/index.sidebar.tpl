{extends file="base/index"}

{if !isset($enableSidebar)}
    {$enableSidebar = true}
{/if}

{if $enableSidebar}
    {block name="taskbar_title" prepend}
        <button type="button" class="nav-link btn btn-secondary btn-sidebar-toggle sidebar-sticky float-xs-left mr-1" data-target=".sidebar" data-canvas="container">
          <span class="fa fa-bars"></span>
        </button>
    {/block}
{/if}

{block name="container"}
<div class="container">
    {block name="content"}
        {block name="content_title"}{/block}
        {block name="messages"}
            {if isset($app.messages)}
                {include file="helper/messages" messages=$app.messages}
            {/if}
        {/block}
        {block name="content_body"}{/block}
    {/block}

    {if $enableSidebar}
    <div class="sidebar offcanvas offcanvas-fixed-left offcanvas-hidden">
        <div class="btn-group sidebar-actions">
            <button type="button" class="btn btn-link btn-sm btn-sidebar-sticky sidebar-sticky" data-target=".sidebar" data-canvas="container" title="{translate key="button.sidebar.sticky"}">
                <span class="fa fa-thumb-tack"></span>
            </button>
            <button type="button" class="btn btn-link btn-sm btn-sidebar-toggle" data-target=".sidebar" data-canvas="container" title="{translate key="button.close"}">
                <span class="fa fa-close"></span>
            </button>
        </div>
        {block name="sidebar"}{/block}
    </div>
    {/if}
</div>
{/block}

{if $enableSidebar}
    {block name="styles" append}
        {style src="bootstrap4/css/offcanvas.css" media="all"}
    {/block}

    {block name="scripts" append}
        {script src="bootstrap4/js/offcanvas.js"}
        {script src="bootstrap4/js/sidebar.js"}
    {/block}
{/if}
