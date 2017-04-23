{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.roles"} - {/block}

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
        {if $role->getId()}
        <a class="breadcrumb-item" href="{url id="system.security.role.edit" parameters=["role" => $role->getId()]}">
            {$role->getName()}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="system.security.role.add"}">
            {translate key="title.role.add"}
        </a>
        {/if}
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.roles"}
            <small class="text-muted">
            {if $role->getId()}
                {$role->getName()}
            {else}
                {translate key="title.role.add"}
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
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
