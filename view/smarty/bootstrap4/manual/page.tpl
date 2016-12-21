{extends file="manual/index"}

{block name="head_title" prepend}{$title} | {/block}

{block name="content_title"}
<div class="page-header m-b-2">
    <h1>
        {translate key="title.manual"}
        <small class="text-muted">{$title}</small>
    </h1>
</div>
{/block}

{block name="content_body" append}
    {$content}
{/block}
