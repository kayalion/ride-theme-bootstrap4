{extends file="base/index"}

{block name="head_title" prepend}{if $server}{$server}{else}{translate key="title.server.add"}{/if} | {translate key="title.varnish"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="tools"}">
            {translate key="title.tools"}
        </a>
        <a class="breadcrumb-item" href="{url id="varnish"}">
            {translate key="title.varnish"}
        </a>
        {if $server}
        <a class="breadcrumb-item" href="{url id="varnish.server.edit" parameters=["server" => (string) $server]}">
            {$server}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="varnish.server.add"}">
            {translate key="title.server.add"}
        </a>
        {/if}
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.varnish"}
            <small class="text-muted">
            {if $server}
                {$server}
            {else}
                {translate key="title.server.add"}
            {/if}
            </small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form}
        {call formActions referer=$referer}
    </form>
    {if $server}

    <h2 class="m-b-2">
        {translate key="button.delete"}
    </h2>
    <form class="form-horizontal" action="{url id="varnish.server.delete" parameters=["server" => (string) $server]}" method="POST" role="form">
        <div class="form-group">
            <button type="submit" class="btn btn-danger">
                {translate key="button.delete"}
            </button>
        </div>
    </form>
    {/if}
{/block}
