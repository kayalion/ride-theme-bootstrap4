{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.taxonomy"} | {/block}

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
    </nav>

    <h1>
        {translate key="title.taxonomy"}
    </h1>
</div>
{/block}

{block name="content_body" append}
    {$tableActions = []}
    {$referer = $app.url.request|escape}

    {if $vocabularyUrl}
        {$tableActions.$vocabularyUrl = "button.vocabulary.add"|translate}
    {/if}

    {include file="helper/table" table=$table tableForm=$form tableActions=$tableActions}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
