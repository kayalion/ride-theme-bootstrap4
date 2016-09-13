{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.phpinfo"} | {/block}

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
        <a class="breadcrumb-item" href="{url id="system.php"}">
            {translate key="title.phpinfo"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.phpinfo"}</h1>
    </div>
{/block}

{block name="content" append}
    <div class="phpinfo">
        {$phpinfo|replace:"<table":"<table class=\"table table-bordered table-striped table-hover table-condensed\""}
    </div>
{/block}
