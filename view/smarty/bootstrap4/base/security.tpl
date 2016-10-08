{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.security"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security"}">
            {translate key="title.security"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.security.access"}">
            {translate key="title.access-control"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.access-control"}</h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        <ul class="nav nav-tabs m-b-2" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" href="#paths" data-toggle="tab" role="tab">
                    {translate key="label.paths"}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#permissions" data-toggle="tab" role="tab">
                    {translate key="label.permissions"}
                </a>
            </li>
        </ul>

        <div class="tab-content">
            <div id="paths" class="tab-pane active">
                <p>{$form->getRow('secured-paths')->getDescription()}</p>
                {call formWidget form=$form row="secured-paths"}
                <small class="form-text text-muted m-b-2">{translate key="label.path.security.description"}</small>

                {if $form->hasRow('allowed-paths')}
                    <h3>{$form->getRow('allowed-paths')->getLabel()}</h3>
                    <p>{$form->getRow('allowed-paths')->getDescription()}</p>

                    <ul>
                    {foreach $roles as $role}
                        <li class="role role-{$role->getId()}">
                            <a href="#">{$role->getName()}</a>
                            {call formWidget form=$form row="allowed-paths" part=$role->getId()}
                            {call formWidgetErrors form=$form row="allowed-paths" part=$role->getId()}
                        </li>
                    {/foreach}
                    </ul>
                {/if}
            </div>

            <div id="permissions" class="tab-pane">
            {if $roles && $permissions}
                {$permissionGroups = [
                    "default" => [],
                    "cms.region" => [],
                    "cms.widget" => [],
                    "cms" => [],
                    "taxonomy" => []
                ]}
                {$null = ksort($permissions)}

                {foreach $permissions as $permissionCode => $permission}
                    {$isAdded = false}
                    {foreach $permissionGroups as $permissionGroup => $null}
                        {if $permissionCode|strpos:$permissionGroup === 0}
                            {$permissionGroups.$permissionGroup.$permissionCode = $permission}
                            {$isAdded = true}
                            {break}
                        {/if}
                    {/foreach}

                    {if !$isAdded}
                        {$permissionGroups["default"].$permissionCode = $permission}
                    {/if}
                {/foreach}

                <p>{translate key="label.permissions.description"}</p>
                <table class="table table-bordered table-hover table-striped">
                    <thead>
                        <tr>
                            <th></th>
                    {foreach $roles as $role}
                            <th>{$role->getName()}</th>
                    {/foreach}
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $permissionGroups as $permissionGroup => $permissions}
                        {if !$permissions}
                            {continue}
                        {/if}

                        <tr>
                            <th colspan="{$roles|count + 1}">
                                <h4>{translate key="permission-group.`$permissionGroup`"}</h4>
                            </th>
                        </tr>

                        {foreach $permissions as $permission}
                            <tr>
                                <th>
                                    {translate key="permission.`$permission`"}
                                    <small class="form-text text-muted">{$permission}</small>
                                </th>
                            {foreach $roles as $role}
                                <td>
                                    {call formWidget form=$form row="role_`$role->getId()`" part=$permission->getCode()}
                                </td>
                            {/foreach}
                            </tr>
                        {/foreach}
                    {/foreach}
                    </tbody>
                </table>
            {else}
                <div class="alert alert-warning">
                    {translate key="label.permissions.none.description"}
                </div>
            {/if}
            </div>
        </div>

        <div class="form-group">
            <button type="submit" class="btn btn-primary">{translate key="button.save"}</button>
            <a href="{url id="system.security.user"}" class="btn">{translate key="button.users.manage"}</a>
        </div>
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/tabs.js"}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/modules/security.js"}
{/block}
