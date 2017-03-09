{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.users"} - {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security.user"}">
            {translate key="title.users"}
        </a>
        {if $user->getId()}
        <a class="breadcrumb-item" href="{url id="system.security.user.edit" parameters=["user" => $user->getId()]}">
            {$user->getDisplayName()}
        </a>
        {else}
        <a class="breadcrumb-item" href="{url id="system.security.user.add"}">
            {translate key="title.user.add"}
        </a>
        {/if}
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.users"}
            <small class="text-muted">
            {if $user->getId()}
                {$user->getDisplayName()}
            {else}
                {translate key="title.user.add"}
            {/if}
            </small>
        </h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
        <ul class="nav nav-tabs mb-2">
            <li class="nav-item">
                <a class="nav-link active" href="#credentials" data-toggle="tab">
                    {translate key="title.credentials"}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#details" data-toggle="tab">
                    {translate key="title.details"}
                </a>
            </li>
        </ul>

        <div class="tab-content">

        <div id="credentials" class="tab-pane active">
            {call formRow form=$form row="username"}
            {call formRow form=$form row="password"}
            {call formRow form=$form row="active"}
            {if $form->hasRow('superuser')}
                {call formRow form=$form row="superuser"}
            {/if}
            {if $form->hasRow('roles')}
                {call formRow form=$form row="roles"}
            {/if}
        </div>

        <div id="details" class="tab-pane">
            {call formRows form=$form}
        </div>
        </div>

        {call formActions referer=$referer}
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/tabs.js"}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
