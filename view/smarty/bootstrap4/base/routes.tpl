{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.routes"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.routes"}">
            {translate key="title.routes"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>
            {translate key="title.routes"}
        </h1>
    </div>
{/block}

{block name="content" append}
    <div class="row m-b-1">
        <div class="offset-sm-8 col-sm-4">
            <form class="form-inline" id="form-search" action="{$app.url.request}" role="search" method="GET">
                <div class="form-group pull-sm-right">
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

    <table class="table table-striped table-bordered table-hover">
        <thead class="hidden-md-down">
            <tr>
                <th>{translate key="label.path"}</th>
                <th>{translate key="label.id"}</th>
                <th>{translate key="label.methods"}</th>
                <th>{translate key="label.locale"}</th>
            </tr>
        </thead>
        <tbody>
    {foreach from=$routes item="route"}
        {$callback = $route->getCallback()}
        {$baseUrl = $route->getBaseUrl()}
        {$methods = $route->getAllowedMethods()}
        {$locale = $route->getLocale()}
        {if $methods}
            {$methods = $methods|@array_keys|@implode:', '}
        {else}
            {$methods = "*"}
        {/if}
            <tr>
                <td>
                    <a href="{if $baseUrl}{$baseUrl}{else}{$app.url.script}{/if}{$route->getPath()}">
                        {$route->getPath()}
                    </a>
                    {if $baseUrl}
                        <br />
                        <span class="help-block">{$baseUrl}</span>
                    {/if}
                    <br />
                    <small class="text-muted">{$callback[0]}->{$callback[1]}()</small>

                    <dl class="hidden-md-up m-b-0">
                        <dt>{translate key="label.id"}</dt>
                        <dd>{$route->getId()}</dd>
                        <dt>{translate key="label.methods"}</dt>
                        <dd>{$methods}</dd>
                        {if $locale}
                            <dt>{translate key="label.locale"}</dt>
                            <dd>{$locale}</dd>
                        {/if}
                    </dl>
                </td>
                <td class="hidden-md-down">{$route->getId()}</td>
                <td class="hidden-md-down">{$methods}</td>
                <td class="hidden-md-down">{$locale}</td>
            </tr>
    {/foreach}
        </tbody>
    </table>
{/block}
