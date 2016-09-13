{extends file="base/index"}

{block name="content_title"}
    <div class="page-header m-b-2 m-t-2">
        <h1>
            {$title}
            <small class="text-muted">{$statusCode}</small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {if $message}
        <p>{$message}</p>
    {/if}
{/block}
