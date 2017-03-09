{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.dependencies"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.dependencies"}">
            {translate key="title.dependencies"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>{translate key="title.dependencies"}</h1>
    </div>
{/block}

{block name="content" append}
    <div class="row mb-1">
        <div class="offset-sm-8 col-sm-4">
            <form class="form-inline" id="form-search" action="{$app.url.request}" role="search" method="GET">
                <div class="form-group float-sm-right">
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

    {foreach $dependencies as $interface => $interfaceDependencies}
        {if $urlClass}
    <h3><a href="{$urlClass}/{$interface|replace:'\\':'/'}">{$interface}</a></h3>
        {else}
    <h3>{$interface}</h3>
        {/if}
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th class="col-md-2">{translate key="label.id"}</th>
                <th class="col-md-5">{translate key="label.class"}</th>
                <th class="col-md-5">{translate key="label.calls"}</th>
            </tr>
        </thead>
        <tbody>
        {foreach $interfaceDependencies as $dependency}
            <tr>
                <td class="col-md-2">{$dependency->getId()}</td>
                <td class="col-md-5">
            {if $urlClass}
                    <a href="{$urlClass}/{$dependency->getClassName()|replace:'\\':'/'}">{$dependency->getClassName()}</a>
            {else}
                    {$dependency->getClassName()}
            {/if}
                </td>
                <td class="col-md-5">
            {assign var="arguments" value=$dependency->getConstructorArguments()}
            {assign var="calls" value=$dependency->getCalls()}
            {if $arguments || $calls}
                    <ul class="list-unstyled">
                {if $arguments}
                        <li>
                    {if $urlClass}
                            <a href="{$urlClass}/{$dependency->getClassName()|replace:'\\':'/'}#method__construct">
                                <span class="method">__construct()</span>
                            </a>
                    {else}
                            <span class="method">__construct()</span>
                    {/if}
                            <ul>
                    {foreach $arguments as $argument}
                        {assign var="properties" value=$argument->getProperties()}
                                <li>${$argument->getName()} ({$argument->getType()})
                        {if $properties}
                                    <ul>
                            {foreach $properties as $key => $value}
                                {if is_array($value)}
                                    <li>{$key}:
                                    {if $value}
                                        [{foreach $value as $k => $v}{$k}: {$v}{if !$v@last}, {/if}{/foreach}]
                                    {else}
                                        []
                                    {/if}
                                    </li>
                                {else}
                                    <li>{$key}: {$value}</li>
                                {/if}
                            {/foreach}
                                    </ul>
                        {/if}
                                </li>
                    {/foreach}
                            </ul>
                        </li>
                {/if}
                {foreach $calls as $call}
                        <li>
                    {if $urlClass}
                            <a href="{$urlClass}/{$dependency->getClassName()|replace:'\\':'/'}#method{$call->getMethodName()}">
                                <span class="method">{$call->getMethodName()}()</span>
                            </a>
                    {else}
                            <span class="method">{$call->getMethodName()}()</span>
                    {/if}

                    {assign var="arguments" value=$call->getArguments()}
                    {if $arguments}
                            <ul>
                        {foreach $arguments as $argument}
                            {assign var="properties" value=$argument->getProperties()}
                                <li>${$argument->getName()} ({$argument->getType()})
                            {if $properties}
                                    <ul>
                                {foreach $properties as $key => $value}
                                    {if is_array($value)}
                                        <li>{$key}:
                                        {if $value}
                                            [{foreach $value as $k => $v}{$k}: {$v}{if !$v@last}, {/if}{/foreach}]
                                        {else}
                                            []
                                        {/if}
                                        </li>
                                    {else}
                                        <li>{$key}: {$value}</li>
                                    {/if}
                                {/foreach}
                                    </ul>
                            {/if}
                                </li>
                        {/foreach}
                            </ul>
                    {/if}
                        </li>
                {/foreach}
                    </ul>
            {/if}
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
    {/foreach}
{/block}
