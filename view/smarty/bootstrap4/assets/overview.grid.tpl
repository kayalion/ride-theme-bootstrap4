<div class="row" data-order="true">
    <div class="asset-items-folders">
    {foreach $folders as $item}
        <div class="col-md-2 order-item" data-type="{$item->getType()}" data-id="{$item->getId()}">
            <div class="image">
                <a href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $item->id]}{$urlSuffix}">
                    <span class="fa fa-folder-open-o fa-5x"></span>
                </a>
            </div>
            <div class="name">
                <div class="option{if !$isFiltered} order-handle{/if}">
                    <input type="checkbox" name="folders[]" value="{$item->getId()}" />
                </div>
                <a href="{url id="assets.folder.edit" parameters=["locale" => $locale, "folder" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                </a>
            </div>
        </div>
    {/foreach}
    </div>

    <div class="asset-items-assets">
    {foreach $assets as $item}
        <div class="col-md-2 order-item" data-type="{$item->getType()}" data-id="{$item->getId()}">
            <div class="image">
            {if $item->getThumbnail()}
                <img src="{image src=$item->getThumbnail() width=150 height=150 transformation="crop"}" class="data img-responsive" />
            {/if}
            </div>
            <div class="name">
                <div class="option{if !$isFiltered} order-handle{/if}">
                    <input type="checkbox" name="assets[]" value="{$item->getId()}" />
                </div>
                <a href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                </a>
            </div>
        </div>
    {/foreach}
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="pull-xs-left m-r-1">
            <input type="checkbox" name="all" class="select-all" />
        </div>
        <div class="pull-xs-left">
            <div class="input-group add-on">
                <select name="action" class="form-control form-action">
                    <option value="">- {translate key="label.actions.bulk"} -</option>
                    <option value="delete">{translate key="button.delete"}</option>
                </select>
                <div class="input-group-btn">
                    <button name="submit" value="bulk-action" type="submit" class="btn btn-secondary btn-bulk">
                        {"button.apply"|translate}
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
