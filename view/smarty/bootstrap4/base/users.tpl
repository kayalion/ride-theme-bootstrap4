{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.users"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security"}">
            {translate key="title.security"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security.user"}">
            {translate key="title.users"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.users"}</h1>
    </div>
{/block}

{block name="content" append}
    {$tableActions = []}
    {$referer = $app.url.request|escape}

    {url id="system.security.role" var="urlRoles"}
    {url id="system.security.user.add" var="urlUserAdd"}
    {url id="system.security.permission" var="urlPermissions"}

    {isGranted url=$urlUserAdd}
        {$urlUserAdd = "`$urlUserAdd`?referer=`$referer`"}
        {$tableActions.$urlUserAdd = "button.user.add"|translate}
    {/isGranted}
    {isGranted url=$urlRoles}
        {$tableActions.$urlRoles = "button.roles.manage"|translate}
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

{block name="scripts_inline" append}
    <script>
        $('tr.disabled').addClass('text-muted');
        $('tr.disabled input[type=checkbox]').attr('disabled', 'disabled');
        $('tr.disabled td.lock').each(function() {
            var $cell = $(this);

            $cell.html('<span class="fa fa-lock" title="' + $cell.html() + '"></i>');
        });
    </script>
{/block}
