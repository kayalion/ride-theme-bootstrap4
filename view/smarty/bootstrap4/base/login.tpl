{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.login"} | {/block}

{block name="content"}
    <div class="offset-md-3 col-md-4">
        <div class="page-header m-b-2 m-t-2">
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
            </fieldset>
        </form>

        {if $urls}
        <ul>
            {foreach $urls as $service => $url}
            <li><a href="{$url}">{translate key="button.login.`$service`"}</a></li>
            {/foreach}
        </ul>
        {/if}
    </div>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
