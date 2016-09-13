{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.roles"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security"}">
            {translate key="title.security"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security.role"}">
            {translate key="title.roles"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.roles"}</h1>
    </div>
{/block}

{block name="content" append}
    {$tableActions = []}
    {$referer = $app.url.request|escape}

    {url id="system.security.role.add" var="urlRoleAdd"}
    {url id="system.security.user" var="urlUsers"}
    {url id="system.security.permission" var="urlPermissions"}

    {isGranted url=$urlRoleAdd}
        {$urlRoleAdd = "`$urlRoleAdd`?referer=`$referer`"}
        {$tableActions.$urlRoleAdd = "button.role.add"|translate}
    {/isGranted}
    {isGranted url=$urlUsers}
        {$tableActions.$urlUsers = "button.users.manage"|translate}
    {/isGranted}
    {isGranted url=$urlPermissions}
        {$tableActions.$urlPermissions = "button.permissions.manage"|translate}
    {/isGranted}

    {include file="helper/table" table=$table tableForm=$form tableActions=$tableActions}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/table.js"}
{/block}
