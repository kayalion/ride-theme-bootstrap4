<div class="row" data-order="true">
    <div class="asset-items-folders">
    {foreach $folders as $item}
        <div class="asset-item" data-type="{$item->getType()}" data-id="{$item->getId()}">
            {if !$embed}
                <input class="float-left mr-1" type="checkbox" name="folders[]" value="{$item->getId()}" />
            {else}
                <span class="float-left mr-1">&nbsp;</span>
            {/if}
            <a href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $item->id]}{$urlSuffix}"
               title="{translate key="button.asset.into" folder=$item->getName()|escape}">
                <div class="image">
                    <span class="fa fa-folder-open-o fa-6x"></span>
                </div>
            </a>
            <div class="name">
            {if !$isFiltered}
                <span class="order-handle text-muted fa fa-arrows"></span>
            {/if}
                <a href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $item->id]}{$urlSuffix}"
                   title="{translate key="button.asset.into" folder=$item->getName()|escape}">
                    {$item->getName()|escape|truncate:12}
                </a>
            {if !$embed}
                <a class="float-right"
                   href="{url id="assets.folder.edit" parameters=["locale" => $locale, "folder" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}"
                   title="{translate key="button.asset.edit" asset=$item->getName()|escape}">
                    <span class="fa fa-pencil"></span>
                </a>
            {/if}
            </div>
        </div>
    {/foreach}
    </div>

    <div class="asset-items-assets">
    {foreach $assets as $item}
        <div class="asset-item{if $embed} is-addable{/if}" data-type="{$item->getType()}" data-id="{$item->getId()}">
            <label>
                <input class="float-left mr-1" type="checkbox" name="assets[]" value="{$item->getId()}" />
                <div class="image">
                    <img src="{image src=$item->getThumbnail() default="bootstrap4/img/asset-`$item->getType()`.png" width=120 height=120 transformation="crop"}" class="rounded" title="{$item->getName()|escape}" />
                </div>
                <div class="name">
                {if !$isFiltered}
                    <span class="order-handle text-muted fa fa-arrows"></span>
                {/if}
                    {$item->getName()|escape|truncate:11}
                {if !$embed}
                    <a class="float-right"
                       href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}"
                       title="{translate key="button.asset.edit" asset=$item->getName()|escape}">
                        <span class="fa fa-pencil"></a>
                    </a>
                {/if}
                </div>
            </label>
        </div>
    {/foreach}
    </div>
</div>

{if !$embed}
<div class="row">
    <div class="col-md-6">
        <div class="float-left mr-1">
            <input type="checkbox" name="all" class="form-select-all" />
        </div>
        <div class="float-left">
            <div class="input-group add-on">
                <select name="action" class="form-control form-action custom-select">
                    <option value="">- {translate key="label.actions.bulk"} -</option>
                    <option value="move">{translate key="button.move"}</option>
                    <option value="delete">{translate key="button.delete"}</option>
                </select>
                <div class="input-group-btn">
                    <button name="applyAction" value="bulk-action" type="submit" class="btn btn-secondary btn-bulk">
                        {"button.apply"|translate}
                    </button>
                </div>
            </div>
        </div>
    </div>
     <div class="col-sm-6">
        <span class="float-right">
            {translate key="label.table.rows.total" rows="<span class=\"total\">`$numItems`</span>"}
        </span>
    </div>
</div>
{else}
<span class="hidden-xs-up total">{$numItems}</span>
{/if}
