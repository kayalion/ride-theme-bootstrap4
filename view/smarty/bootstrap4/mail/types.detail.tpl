{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.mail.types"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.mail.types"}">
            {translate key="title.mail.types"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.mail.types.detail" parameters=["id" => $mailType->getName()]}">
            {$mailType->getName()}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>
            {translate key="title.mail.types"}
            <small class="text-muted">{$mailType->getName()}</small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    <h2 class="mb-3">{translate key="title.variables.available"}</h2>
    <table class="table table-bordered table-striped">
    {foreach $mailType->getContentVariables() as $key => $translation}
        <tr>
            <td>{$key}</td>
            <td>{$translation|translate}</td>
        </tr>
    {/foreach}
    </table>

    <h2 class="mb-3">{translate key="title.recipients.available"}</h2>
    <table class="table table-bordered table-striped">
    {foreach $mailType->getRecipientVariables() as $key => $translation}
        <tr>
            <td>{$key}</td>
            <td>{$translation|translate}</td>
        </tr>
    {/foreach}
    </table>
{/block}
