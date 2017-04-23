{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.parameters"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.parameters"}">
            {translate key="title.parameters"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>{translate key="title.parameters"}</h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <div class="row">
        <div class="col-6 mb-3">
            <a href="#" class="btn btn-secondary btn-add">
                {translate key="button.parameter.add"}
            </a>
        </div>
        <div class="col-6">
            <form class="form" id="form-search" action="{$app.url.request}" role="search" method="GET">
                <div class="form-group float-right">
                    <div class="input-group add-on">
                        <input type="text" name="query" class="form-control" placeholder="{translate key="label.search.query"}" value="{$query|escape}" />
                        <div class="input-group-btn">
                            <button type="submit" name="submit" class="btn btn-secondary" title="{"button.search"|translate}">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

<form id="{$form->getId()}"
      action="{$app.url.request}"
      method="POST"
      role="form"
      data-message-success-save="{"success.parameter.saved"|translate|escape}"
      data-message-success-delete="{"success.parameter.deleted"|translate|escape}"
      data-message-error-save="{"error.parameter.saved"|translate|escape}"
      data-message-error-delete="{"error.parameter.deleted"|translate|escape}">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr>
                <th>{translate key="label.parameter"}</th>
                <th>{translate key="label.value"}</th>
            </tr>
        </thead>
        <tbody>
            <tr class="form hidden-xs-up">
                <td>
                    <div class="form-group">
                        {call formWidget form=$form row="parameter"}
                        {call formWidgetErrors form=$form row="parameter"}
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        {call formWidget form=$form row="value"}
                        {call formWidgetErrors form=$form row="value"}
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            {translate key="button.save"}
                        </button>
                        <a href="#" class="btn btn-cancel">
                            {translate key="button.cancel"}
                        </a>
                    </div>

                    {call formRows form=$form}
                </td>
            </tr>
    {foreach $parameters as $key => $value}
            <tr data-parameter="{$key}">
                <td class="parameter-key">
                    <a class="btn-edit" href="{url id="system.parameters.edit" parameters=["key" => $key]}">{$key}</a>
                </td>
                <td class="parameter-value">{$value|escape}</td>
            </tr>
    {/foreach}
        </tbody>
    </table>
</form>
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/jquery-bootstrap-growl.js"}
    {script src="bootstrap4/js/modules/system-parameters.js"}
{/block}
