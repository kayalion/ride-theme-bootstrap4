{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.login"} | {/block}

{block name="content"}
    <div class="offset-md-3 col-md-4">
        <div class="page-header mb-3 mt-2">
            <h1>{translate key="title.login"}</h1>
        </div>

        {$smarty.block.parent}

        {include file="helper/form.prototype"}

        <form id="{$form->getId()}" action="{url id="login"}{if $referer}?referer={$referer|urlencode}{/if}" method="POST" role="form">
            {call formRows form=$form}
            <p>
                <a href="{url id="profile.password.request"}?referer={$app.url.request|escape}">
                    {translate key="button.password.reset"}
                </a>
            </p>
            {call formActions submit="button.login"}
        </form>

        {if $urls}
        <div class="list-group">
            {foreach $urls as $service => $url}
            <a href="{$url}" class="list-group-item list-group-item-action">
                <span class="fa fa-{$service} mr-2"></span>
                {translate key="button.login.`$service`"}
            </a>
            {/foreach}
        </div>
        {/if}
    </div>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
