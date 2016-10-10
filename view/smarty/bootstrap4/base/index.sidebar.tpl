{extends file="base/index"}

{block name="taskbar_title" prepend}
    <button type="button" class="nav-link btn btn-secondary btn-sidebar pull-left m-r-1" data-target=".sidebar" data-canvas="container">
      <span class="fa fa-bars"></span>
    </button>
{/block}

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

    <div class="sidebar offcanvas offcanvas-fixed-left offcanvas-hidden">
      <button type="button" class="close btn-sidebar" data-target=".sidebar" data-canvas="container" title="{translate key="button.close"}">
          &times;
      </button>
       {block name="sidebar"}{/block}
    </div>
</div>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/offcanvas.css" media="all"}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/offcanvas.js"}
    {script src="bootstrap4/js/sidebar.js"}
{/block}
