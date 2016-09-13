{extends file="base/index.sidebar"}

{block name="styles" append}
    {style src="bootstrap4/css/modules/documentation.css" media="all"}
{/block}

{block name="head_title" prepend}{translate key="title.manual"} | {/block}

{block name="content_title"}
<div class="page-header m-b-2">
    <h1>{translate key="title.manual"}</h1>
</div>
{/block}

{block name="sidebar"}
    {foreach $pages as $path => $pathPages}
        {assign var="path" value=$path|trim:"/"}
        {if $path}
            <h3>{$path}</h3>
        {else}
            <h3>General</h3>
        {/if}

        <nav class="m-b-2">
            <ul class="nav nav-pills nav-stacked nav-documentation">
        {foreach $pathPages as $page}
                <li class="nav-item">
                    <a class="nav-link" href="{$page->getUrl()}">
                        {$page->getTitle()}
                    </a>
                </li>
        {/foreach}
            </ul>
        </nav>
    {/foreach}
{/block}
