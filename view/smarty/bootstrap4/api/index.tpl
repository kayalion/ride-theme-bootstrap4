{extends file="base/index.sidebar"}

{block name="styles" append}
    {style src="bootstrap4/css/modules/documentation.css" media="all"}
{/block}

{block name="head_title" prepend}{translate key="title.api"} | {/block}

{block name="sidebar"}
    <div class="row mb-2">
        <div class="col-md-12">
            <form class="form-inline" id="form-search" action="{url id="api.search"}" role="search" method="GET">
                <div class="input-group add-on">
                    <input type="text" name="query" class="form-control" placeholder="{translate key="label.search.query"}" value="{$searchQuery|escape}" />
                    <div class="input-group-btn">
                        <button type="submit" name="submit" class="btn btn-secondary" title="{"button.search"|translate}">
                            <span class="fa fa-search"></span>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    {if $classes}
        <h3>{translate key="title.classes"}</h3>
        <nav class="mb-2">
            <ul class="nav nav-pills flex-column nav-documentation">
        {foreach $classes as $c}
                <li class="nav-item">
                    <a class="nav-link{if $shortName == $c} active{/if}" href="{$urlClass}/{$namespace}/{$c}">
                        {$c}
                    </a>
                </li>
        {/foreach}
            </ul>
        </nav>
    {/if}
    {if $namespaces}
        <h3>{translate key="title.namespaces"}</h3>
        <nav class="mb-2">
            <ul class="nav nav-pills flex-column nav-documentation">
        {foreach $namespaces as $ns}
                <li class="nav-item">
                    <a class="nav-link" href="{$urlNamespace}/{$ns}">
                        {$ns}
                    </a>
                </li>
        {/foreach}
            </ul>
        </nav>
    {/if}
{/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="documentation"}">
            {translate key="title.documentation"}
        </a>
    {foreach $breadcrumbs as $url => $label}
        <a class="breadcrumb-item" href="{$url}">{$label}</a>
    {/foreach}
    </nav>

    <div class="page-header mb-3">
        {block name="title"}<h1>{translate key="title.api"}</h1>{/block}
    </div>
{/block}
