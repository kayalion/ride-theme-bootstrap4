{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.varnish"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="tools"}">
            {translate key="title.tools"}
        </a>
        <a class="breadcrumb-item" href="{url id="varnish"}">
            {translate key="title.varnish"}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>{translate key="title.varnish"}</h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" class="form-inline" action="{$app.url.request}" method="POST" role="form">
        <div class="form-group mr-3">
            <div class="input-group add-on">
                {call formWidget form=$form row="url"}
                <div class="input-group-btn">
                    <button type="submit" class="btn btn-secondary">
                        {translate key="button.ban"}
                    </button>
                </div>
            </div>
        </div>
        <div class="form-group">
            <span class="form-check">
                <label class="form-check-label" title="{translate key="label.force.varnish"}">
                    {call formWidget form=$form row="force"}
                    {translate key="label.force"}
                </label>
            </span>
        </div>
        {call formRows form=$form}
    </form>

    <hr />

    <h2 class="mb-2">
        {translate key="title.servers"}
    </h2>

    <p>
        <a class="btn btn-secondary" href="{url id="varnish.server.add"}?referer={$app.url.request|escape}">
            {translate key="button.varnish.add"}
        </a>
    </p>

    {if $servers}
    <table class="table table-hover table-bordered table-striped">
        <thead>
            <tr>
                <th>{translate key="label.server"}</th>
                <th>{translate key="label.status"}</th>
            </tr>
        </thead>
        <tbody>
    {foreach $servers as $server}
            <tr>
                <td>
                    <a href="{url id="varnish.server.edit" parameters=["server" => (string) $server]}">
                        {$server}
                    </a>
                </td>
                <td>
                    {if $server->isRunning()}
                        <span class="badge badge-success">{translate key="label.running"}</span>
                    {elseif $server->isConnected()}
                        <span class="badge badge-warning">{translate key="label.running.not"}</span>
                    {else}
                        <span class="badge badge-danger">{translate key="label.connect.unable"}</span>
                    {/if}
                </td>
            </tr>
    {/foreach}
        </tbody>
    </table>
    {/if}
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
{/block}
