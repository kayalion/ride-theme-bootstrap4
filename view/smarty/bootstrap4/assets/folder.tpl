{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="taskbar_panels" append}
    {if $folder->getId()}
        {url id="assets.folder.edit" parameters=["locale" => "%locale%", "folder" => $folder->getId()] var="url"}
    {else}
        {url id="assets.folder.add" parameters=["locale" => "%locale%"] var="url"}
    {/if}

    {call taskbarPanelLocales url=$url locale=$locale locales=$locales}
{/block}

{block name="content_title" append}
    <div class="page-header m-b-2">
        <h1>
            {translate key="title.assets"}
            <small>
    {if $folder->getId()}
        {$folder->getName()}
    {else}
        {translate key="button.add.folder"}
    {/if}
            </small>
        </h1>
    </div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form">
        {call formRows form=$form}
        {call formActions referer=$referer}
    </form>
{/block}
