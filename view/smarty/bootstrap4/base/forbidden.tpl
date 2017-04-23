{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.forbidden"} | {/block}

{block name="messages"}{/block}

{block name="content_title"}
    <div class="page-header mb-3 mt-2">
        <h1>
            {translate key="title.forbidden"}
            <small class="text-muted">403</small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    <p>{translate key="label.forbidden.description"}</p>
{/block}
