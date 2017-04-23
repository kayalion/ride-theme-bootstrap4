{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.exception"} | {/block}

{block name="content_title"}
    <div class="page-header mb-3 mt-2">
        <h1>{translate key="title.exception"}</h1>
    </div>
{/block}

{block name="content" append}
    <p>{translate key="label.exception.report.description"}</p>

    {if $form}
        <p>{translate key="label.exception.report.form"}</p>
        {include file="helper/form.prototype"}

        <form id="{$form->getId()}" action="{url id="exception" parameters=["id" => $id]}" method="POST" role="form">
            <div class="form-group">
                {call formWidget form=$form row="comment"}
            </div>

            {call formRows form=$form}
            {call formActions submit="button.submit.report"}
        </form>
    {/if}
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
