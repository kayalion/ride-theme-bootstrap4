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
        <a class="breadcrumb-item" href="{$app.url.request}">
            {$logSession->getId()}
        </a>
    </nav>

    <div class="page-header">
        <h1>
            {translate key="title.log"}
            <small class="text-muted">{$logSession->getId()}</small>
        </h1>
    </div>
{/block}

{block name="content" append}
    {function name="logTable" id=null messages=null active=false}
        {if $messages}
        <div id="{$id|lower}" class="tab-pane{if $active} active{/if}">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{translate key="label.time"}</th>
                        <th>{translate key="label.source"}</th>
                        <th>{translate key="label.description"}</th>
                    </tr>
                </thead>
                <tbody>
            {foreach $messages as $message}
                {call logTableRow message=$message}
            {/foreach}
                </tbody>
            </table>
        </div>
        {/if}
    {/function}

    {function name="logTableRow" message=null}
        <tr{if $message->isError()} class="text-danger"{elseif $message->isWarning()} class="text-warning"{/if}>
            <td>{$message->getMicroTime()}s</td>
            <td>{$message->getSource()}</td>
            <td>{$message->getTitle()}
                <br>
                <span class="text-muted">{$message->getDescription()|nl2br}</span>
            </td>
        </tr>
    {/function}

    {function name="headerTable" headers=null}
        {if $headers}
        <table class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th class="col-md-4">{translate key="label.header"}</th>
                    <th class="col-md-8">{translate key="label.value"}</th>
                </tr>
            </thead>
            <tbody>
            {foreach $headers as $header}
                <tr>
                    <td class="col-md-4">{$header.name}</td>
                    <td class="col-md-8">{$header.value}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        {/if}
    {/function}

    <dl>
        <dt>{translate key="label.id"}</dt>
        <dd>{$logSession->getId()}</dd>
        <dt>{translate key="label.date"}</dt>
        <dd>{$logSession->getDate()}</dd>
        <dt>{translate key="label.duration"}</dt>
        <dd>{$logSession->getMicroTime()}</dd>
        <dt>{translate key="label.client"}</dt>
        <dd>{$logSession->getClient()}</dd>
    </dl>

    <ul class="nav nav-tabs m-b-2" role="tablist">
        <li class="nav-item">
            <a class="nav-link{if !$response && !$request && !$session} active{/if}" href="#all" data-toggle="tab" role="tab">
                {translate key="title.all"}
            </a>
        </li>
    {if $application}
        <li class="nav-item">
            <a class="nav-link" href="#application" data-toggle="tab" role="tab">
                {translate key="title.application"}
            </a>
        </li>
    {/if}
    {if $database}
        <li class="nav-item">
            <a class="nav-link" href="#database" data-toggle="tab" role="tab">
                {translate key="title.database"}
            </a>
        </li>
    {/if}
    {if $mail}
        <li class="nav-item">
            <a class="nav-link" href="#mail" data-toggle="tab" role="tab">
                {translate key="title.mail"}
            </a>
        </li>
    {/if}
    {if $response || $request || $session}
        <li class="nav-item">
            <a class="nav-link active" href="#http" data-toggle="tab" role="tab">
                {translate key="title.http"}
            </a>
        </li>
    {/if}
    {if $i18n}
        <li class="nav-item">
            <a class="nav-link" href="#i18n" data-toggle="tab" data-toggle="tab" role="tab">
                I18n
            </a>
        </li>
    {/if}
    {if $security}
        <li class="nav-item">
            <a class="nav-link" href="#security" data-toggle="tab" role="tab">
                {translate key="title.security"}
            </a>
        </li>
    {/if}
    </ul>

    <div class="tab-content">
        {call logTable id="All" messages=$logSession->getLogMessages() active=(!$response && !$request && !$session)}

        {call logTable id="Mail" messages=$mail}

        {call logTable id="Application" messages=$application}

        {call logTable id="Database" messages=$database}

        {call logTable id="Security" messages=$security}

        {call logTable id="I18n" messages=$i18n}

    {if $response || $request || $session}
        <div id="http" class="tab-pane active">
        {if $response}
            <h4>
                {translate key="title.response"}
                <small>
                    <span class="tag tag-{if $response.status < 300}success{elseif $response.status < 400}warning{else}danger{/if}">
                        {$response.status} {$response.statusPhrase}
                    </span>
                </small>
            </h4>
            {call headerTable headers=$response.headers}
        {/if}

        {if $request}
            <h4>{translate key="title.request"} <small>{$request.method} {$request.path}</small></h4>
            {call headerTable headers=$request.headers}
        {/if}

        {if $response && $session.variables}
            <h4>{translate key="title.session"} <small>{$session.id}</small></h4>
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{translate key="label.variable"}</th>
                        <th>{translate key="label.value"}</th>
                    </tr>
                </thead>
                <tbody>
                {foreach $session.variables as $variable => $value}
                <tr>
                    <td>{$variable}</td>
                    <td>{$value|nl2br}</td>
                </tr>
                {/foreach}
                </tbody>
            </table>
        {/if}
        </div>
    {/if}
    </div>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/tabs.js"}
{/block}
