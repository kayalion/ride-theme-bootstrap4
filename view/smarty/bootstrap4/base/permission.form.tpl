{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.permissions"} - {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security.role"}">
            {translate key="title.roles"}
        </a>
        {if $permission && $permission->getCode()}
        <a class="breadcrumb-item" href="{url id="system.security.permission.edit" parameters=["permission" => $permission->getCode()]}">
            {$permission->getCode()}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="system.security.permission.add"}">
            {translate key="title.permission.add"}
        </a>
        {/if}
    </nav>

    <div class="page-header mb-2">
        <h1>
            {translate key="title.permissions"}
            <small class="text-muted">
            {if $permission && $permission->getCode()}
                {$permission->getCode()}
            {else}
                {translate key="title.permission.add"}
            {/if}
            </small>
        </h1>
    </div>
{/block}
{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form}
        {call formActions referer=$referer}
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
