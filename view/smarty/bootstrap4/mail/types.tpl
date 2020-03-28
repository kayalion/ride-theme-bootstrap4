{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.mail.types"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.mail.types"}">
            {translate key="title.mail.types"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.mail.types"}
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/table" table=$table tableForm=$form tableActions=$actions}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
