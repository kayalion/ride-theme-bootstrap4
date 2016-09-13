{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.taxonomy"} | {/block}

{block name="taskbar_panels" append}
    {url id="taxonomy.term.list.locale" parameters=["vocabulary" => $vocabulary->getId(), "locale" => "%locale%"] var="localizeUrl"}
    {call taskbarPanelLocales url=$localizeUrl locale=$locale locales=$locales}
{/block}

{block name="content_title"}
<div class="page-header m-b-2">
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
        <a class="breadcrumb-item" href="{url id="taxonomy.vocabulary.edit" parameters=["vocabulary" => $vocabulary->getId()]}?referer={$app.url.request|escape}">
            {$vocabulary->getName()}
        </a>
        <a class="breadcrumb-item" href="{url id="taxonomy.term.list" parameters=["vocabulary" => $vocabulary->getId()]}">
            {translate key="title.terms"}
        </a>
    </nav>

    <h1>
        {translate key="title.taxonomy"}
        <small class="text-muted">
            {translate key="title.terms.vocabulary" vocabulary=$vocabulary->getName()}
        </small>
    </h1>
</div>
{/block}

{block name="content_body" append}
    {url id="taxonomy.term.add" parameters=["vocabulary" => $vocabulary->getId(), "locale" => $locale] var="urlTermAdd"}
    {url id="taxonomy.vocabulary.list" var="urlVocabularies"}

    {$referer = $app.url.request|escape}
    {$urlTermAdd = "`$urlTermAdd`?referer=`$referer`"}

    {$tableActions = []}
    {$tableActions.$urlTermAdd = "button.term.add"|translate}
    {$tableActions.$urlVocabularies = "button.vocabularies.manage"|translate}

    {include file="helper/table" table=$table tableForm=$form tableActions=$tableActions}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
