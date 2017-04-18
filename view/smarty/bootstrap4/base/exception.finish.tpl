{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.exception"} | {/block}

{block name="content_title"}
    <div class="page-header mb-3 mt-2">
        <h1>{translate key="title.exception.report.finish"}</h1>
    </div>
{/block}

{block name="content" append}
    <p>{translate key="label.exception.report.finish"}</p>

    <a href="{$app.url.base}">{"button.back.home"|translate}</a>
{/block}
