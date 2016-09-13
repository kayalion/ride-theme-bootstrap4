{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.cache"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.cache"}">
            {translate key="title.cache"}
        </a>
    {if $action != "enable"}
        <a class="breadcrumb-item" href="{url id="system.cache.clear"}">
          {translate key="label.`$action`"}
        </a>
    {/if}
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.cache"}
        {if $action != "enable"}
            <small class="text-muted">{translate key="button.cache.clear"}</small>
        {/if}
        </h1>
    </div>
{/block}

{block name="content" append}
    {if $action == "enable"}
    <div class="btn-group m-b-2">
        <a href="{url id="system.cache.clear"}" class="btn btn-secondary">{translate key="button.cache.clear"}</a>
    </div>
    {/if}

    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST">
        <table class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th class="option"></th>
                    <th>
                        {translate key="label.cache"}
                    </th>
                </tr>
            </thead>
            <tbody>
        {foreach $controls as $name => $control}
            {$row = $form->getRow($name)}
            <tr{if $row->isDisabled()} class="disabled"{/if}>
                <td class="option">
                    {call formWidgetOption form=$form row=$row showLabel=false}
                </td>
                <td>
                    <label for="{$row->getWidget()->getId()}">{$row->getDescription()}</label>
                </td>
            </tr>
        {/foreach}
            </tbody>
            <tfoot>
                <tr>
                    <td class="option">
                        <input type="checkbox" id="form-select-all" class="form-select-all" />
                    </td>
                    <td>
                        <button type="submit" name="submit" class="btn btn-primary">{"label.`$action`"|translate}</button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </form>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/form.js"}
{/block}
