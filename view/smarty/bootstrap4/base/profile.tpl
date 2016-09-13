{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.profile"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="profile"}">
            {translate key="title.profile"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.profile"}</h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" enctype="multipart/form-data" role="form">
        <ul class="nav nav-tabs m-b-2">
        {foreach $hooks as $hookName => $hook}
            <li class="nav-item">
                <a class="nav-link{if $activeHook == $hookName} active{/if}" href="#{$hookName}" data-toggle="tab">
                    {translate key="profile.hook.`$hookName`"}
                </a>
            </li>
        {/foreach}
        {if $form->hasRow('submit-unregister')}
            <li class="nav-item">
                <a class="nav-link" href="#unregister" data-toggle="tab">
                    {translate key="button.unregister"}
                </a>
            </li>
        {/if}
        </ul>

        <div class="tab-content">
        {foreach $hooks as $hookName => $hook}
            <div id="{$hookName}" class="tab-pane{if $activeHook == $hookName} active{/if}">
                {$hookViews.$hookName}
            </div>
        {/foreach}
        {if $form->hasRow('submit-unregister')}
            <div id="unregister" class="tab-pane{if $activeHook == 'unregister'} active{/if}">
                <p>{translate key="label.unregister"}</p>

                {call formRow form=$form row="submit-unregister"}
            </div>
        {/if}
        </div>
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-ui.js"}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
{/block}
