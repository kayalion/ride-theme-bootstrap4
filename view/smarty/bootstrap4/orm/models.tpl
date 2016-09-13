{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.orm"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm"}">
            {translate key="title.orm"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.orm"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/table" table=$table tableForm=$form}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
