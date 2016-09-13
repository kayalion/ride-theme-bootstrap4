{extends file="base/index"}

{block name="taskbar_panels" append}
    {if $term->getId()}
        {url id="taxonomy.term.edit" parameters=["vocabulary" => $vocabulary->getId(), "locale" => "%locale%", "term" => $term->getId()] var="localizeUrl"}
    {else}
        {url id="taxonomy.term.add" parameters=["vocabulary" => $vocabulary->getId(), "locale" => "%locale%"] var="localizeUrl"}
    {/if}
    {call taskbarPanelLocales url=$localizeUrl locale=$locale locales=$locales}
{/block}

{block name="content_title"}
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
    {if $term->getId()}
        <a class="breadcrumb-item" href="{url id="taxonomy.term.edit" parameters=["vocabulary" => $vocabulary->getId(), "locale" => $locale, "term" => $term->getId()]}">
            {$term->getName()}
        </a>
    {else}
        <a class="breadcrumb-item" href="{url id="taxonomy.term.add" parameters=["vocabulary" => $vocabulary->getId(), "locale" => $locale] var="detailUrl"}">
            {translate key="button.term.add"}
        </a>
    {/if}
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.taxonomy"}
            <small class="text-muted">{translate key="title.terms"}</small>
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
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
