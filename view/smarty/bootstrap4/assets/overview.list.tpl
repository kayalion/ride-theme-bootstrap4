<table class="table table-striped table-hover table-bordered">
    <thead>
        <tr>
            <th class="option"></th>
            <th class="preview">{translate key="label.preview"}</th>
            <th>{translate key="label.asset"}</th>
            <th>{translate key="label.date.added"}</th>
        </tr>
    </thead>

    <tbody class="asset-items-folders">
    {foreach $folders as $item}
        {$type = $item->getType()}
        <tr class="asset-item" data-type="{$type}" data-id="{$item->getId()}">
        <label>
            <td class="option">
            {if !$embed}
                <input type="checkbox" name="folders[]" value="{$item->getId()}" />
            {/if}
            {if !$isFiltered}
                <span class="order-handle text-muted fa fa-arrows"></span>
            {/if}
            </td>
            <td class="image">
                <a href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $item->id]}{$urlSuffix}">
                    <span class="fa fa-folder-open-o fa-3x"></span>
                </a>
            </td>
            <td>
            {if !$embed}
                <a href="{url id="assets.folder.edit" parameters=["locale" => $locale, "folder" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                </a>
            {else}
                {$item->getName()}
            {/if}
                <div class="text-muted">
                    {translate key="label.type.`$type`"}
                </div>
            </td>
            <td>{$item->getDateAdded()|date_format}</td>
        </label>
        </tr>
    {/foreach}
    </tbody>
    <tbody class="asset-items-assets">
    {foreach $assets as $item}
        {$type = $item->getType()}
        <tr class="asset-item{if $embed} is-addable{/if}" data-type="{$type}" data-id="{$item->getId()}">
            <td class="option">
                <input type="checkbox" name="assets[]" value="{$item->getId()}" />
            {if !$isFiltered}
                <span class="order-handle text-muted fa fa-arrows"></span>
            {/if}
            </td>
            <td class="image">
                <img src="{image src=$item->getThumbnail() default="bootstrap4/img/asset-`$item->getType()`.png" width=50 height=50 transformation="crop"}" class="rounded" />
            </td>
            <td>
                {if !$embed}
                <a href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                <a>
                {else}
                <span class="name">
                    {$item->getName()}
                </span>
                {/if}
                <div class="text-muted">
                    {translate key="label.type.`$type`"}
                </div>
            </td>
            <td>{$item->getDateAdded()|date_format}</td>
        </tr>
    {/foreach}
    </tbody>

    {if !$embed}
    <tfoot>
        <tr>
            <td class="option">
                <input type="checkbox" name="all" class="select-all" />
            </td>
            <td colspan="3">
                <div class="row">
                    <div class="col-sm-6">
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
                     <div class="col-sm-6">
                        <span class="float-right pt-1">
                            {translate key="label.table.rows.total" rows="<span class=\"total\">`$numItems`</span>"}
                        </span>
                    </div>
                </div>
            </td>
        </tr>
    </tfoot>
    {else}
    <span class="hidden-xs-up total">{$numItems}</span>
    {/if}
</table>
