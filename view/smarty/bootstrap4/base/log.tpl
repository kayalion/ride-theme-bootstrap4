{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.log"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.log"}">
            {translate key="title.log"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>{translate key="title.log"}</h1>
    </div>
{/block}

{block name="content" append}
    <table class="table table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th>{translate key="label.id"}</th>
            <th>{translate key="label.client"}</th>
            <th>{translate key="label.date"}</th>
            <th>{translate key="label.duration"}</th>
            <th>{translate key="label.title"}</th>
        </tr>
    </thead>
    <tbody>
    {foreach $logSessions as $logSession}
        <tr>
            <td><a href="{url id="system.log.detail" parameters=["id" => $logSession->getId()]}">{$logSession->getId()}</a></td>
            <td>{$logSession->getClient()}</td>
            <td>{$logSession->getDate()|date_format:"%Y-%m-%d %H:%M:%S"}</td>
            <td>{$logSession->getMicroTime()}s</td>
            <td>{$logSession->getTitle()}</td>
        </tr>
    {/foreach}
    </tbody>
    </table>

    {if $pagination->getPages() > 1}
    <nav class="align-center">
        {pagination page=$pagination->getPage() pages=$pagination->getPages() href=$pagination->getHref()}
    </nav>
    {/if}
{/block}
