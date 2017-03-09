{extends file="base/index"}

{block name="head_title" prepend}{$model->getName()} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm"}">
            {translate key="title.orm"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.model" parameters=["model" => $model->getName()]}">
            {$model->getName()}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.orm"}
            <small class="text-muted">{$model->getName()}</small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    <div class="btn-group mb-3">
        <a class="btn btn-secondary" href="{url id="system.orm.scaffold" parameters=["model" => $model->getName()]}">
            {translate key="button.scaffold"}
        </a>
    </div>

    <dl>
        <dt>{translate key="label.class.model"}</dt>
        <dd>{if $hasApi}<a href="{url id="api.class"}/{$modelClass|replace:'\\':'/'}">{$modelClass}</a>{else}{$modelClass}{/if}</dd>
        <dt>{translate key="label.class.entry"}</dt>
        <dd>{if $hasApi}<a href="{url id="api.class"}/{$entryClass|replace:'\\':'/'}">{$entryClass}</a>{else}{$entryClass}{/if}</dd>
        <dt>{translate key="label.class.proxy"}</dt>
        <dd>{if $hasApi}<a href="{url id="api.class"}/{$proxyClass|replace:'\\':'/'}">{$proxyClass}</a>{else}{$proxyClass}{/if}</dd>
        <dt>{translate key="label.model.delete.block"}</dt>
        <dd>{if $modelTable->willBlockDeleteWhenUsed()}{"label.yes"|translate}{else}{"label.no"|translate}{/if}</dd>
    </dl>

    <h2 class="mb-3">
        {"label.fields"|translate}
    </h2>
    <div class="mb-3">
        {include "helper/table" table=$tableFields tableForm=$tableFieldsForm}
    </div>

    <h2 class="mb-3">
        {"label.formats"|translate}
    </h2>
    <table class="table table-hover table-striped table-bordered mb-2">
        <thead>
            <tr>
                <th>{translate key="label.name"}</th>
                <th>{translate key="label.format"}</th>
            </tr>
        </thead>
        <tbody>
            {$formats = $modelTable->getFormats()}
            {foreach $formats as $name => $format}
                <tr>
                    <td>{$name}</td>
                    <td>{$format}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>

    <h2 class="mb-3 mt-3">
        {"label.indexes"|translate}
    </h2>
    {if $modelTable->getIndexes()}
        {$tableIndexes->getHtml()}
    {else}
        <p>{"label.index.none"|translate}</p>
    {/if}

    {$options = $modelTable->getOptions()}
    <h2 class="mb-3">
        {"label.options"|translate}
    </h2>
    <table class="table table-hover table-striped table-bordered mb-2">
        <thead>
            <tr>
                <th>{translate key="label.name"}</th>
                <th>{translate key="label.value"}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $options as $name => $value}
                <tr>
                    <td>{$name}</td>
                    <td>{$value|escape}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
{/block}
