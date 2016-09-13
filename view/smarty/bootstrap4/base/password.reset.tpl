{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.password.reset"} | {/block}

{block name="content_title"}
    <div class="page-header m-b-2 m-t-2">
        <h1>{translate key="title.password.reset"}</h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form row="user"}
        {call formActions referer=$referer}
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
