{extends file="base/index"}

{block name="container"}
    <div class="container">
        <div class="row">
            <div class="col-md-9">
    {block name="content"}
        {block name="content_title"}{/block}
        {block name="messages"}
            {if isset($app.messages)}
                {include file="helper/messages" messages=$app.messages}
            {/if}
        {/block}
        {block name="content_body"}{/block}
    {/block}
            </div>
            <div class="col-md-3 sidebar">
                {block name="sidebar"}{/block}
            </div>
        </div>
    </div>
{/block}


