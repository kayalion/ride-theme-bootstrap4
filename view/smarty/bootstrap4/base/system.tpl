{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.system.details"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.details"}">
            {translate key="title.details"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.system.details"}</h1>
    </div>
{/block}

{block name="content" append}
    <dl>
        <dt>{translate key="label.php.version"}</dt>
        <dd><a href="{url id="system.php"}">{$phpVersion}</a></dd>
        <dt>{translate key="label.environment"}</dt>
        <dd>{$environment}</dd>
        <dt>{translate key="label.directory.public"}</dt>
        <dd>{$publicDirectory}</dd>
        <dt>{translate key="label.directory.application"}</dt>
        <dd>{$applicationDirectory}</dd>
        <dt>{translate key="label.directories.include"}</dt>
        <dd>
            <ul>
            {foreach $includeDirectories as $directory}
                <li>{$directory}</li>
            {/foreach}
            </ul>
        </dd>
    </dl>
{/block}
