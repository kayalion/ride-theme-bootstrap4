{extends file="base/index"}

{block name="content_title"}
<div class="page-header mb-3">
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="taxonomy.vocabulary.list"}">
            {translate key="title.taxonomy"}
        </a>
        {if $vocabulary->getId()}
        <a class="breadcrumb-item" href="{url id="taxonomy.vocabulary.edit" parameters=["vocabulary" => $vocabulary->getId()]}">
            {$vocabulary->getName()}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="taxonomy.vocabulary.add"}">
            {translate key="button.vocabulary.add"}
        </a>
        {/if}
    </nav>

    <h1>
        {translate key="title.taxonomy"}
        <small class="text-muted">
            {translate key="button.vocabulary.add"}
        </small>
    </h1>
</div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
        {call formRows form=$form}
        {call formActions referer=$referer}
    </form>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
