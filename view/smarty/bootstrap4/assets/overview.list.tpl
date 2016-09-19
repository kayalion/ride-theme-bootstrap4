<table class="table table-bordered table-hover table-striped" data-order="true">
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
        <tr class="order-item" data-type="{$type}" data-id="{$item->getId()}">
            <td class="option{if !$isFiltered} order-handle{/if}">
                <input type="checkbox" name="folders[]" value="{$item->getId()}" />
            </td>
            <td class="preview">
                <a href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $item->id]}{$urlSuffix}">
                    <span class="fa fa-folder fa-3x"></span>
                </a>
            </td>
            <td>
                <a href="{url id="assets.folder.edit" parameters=["locale" => $locale, "folder" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                </a>
                <div class="text-muted">
                    {translate key="label.type.`$type`"}
                </div>
            </td>
            <td>{$item->getDateAdded()|date_format}</td>
        </tr>
    {/foreach}
    </tbody>
    <tbody class="asset-items-assets">
    {foreach $assets as $item}
        {$type = $item->getType()}
        <tr class="order-item" data-type="{$type}" data-id="{$item->getId()}">
            <td class="option{if !$isFiltered} order-handle{/if}">
                <input type="checkbox" name="assets[]" value="{$item->getId()}" />
            </td>
            <td class="preview">
                {if $item->getThumbnail()}
                    <img src="{image src=$item->getThumbnail() width=50 height=50 transformation="crop"}" class="img-responsive" />
                {/if}
            </td>
            <td>
                <a href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                    {$item->getName()}
                <a>
                <div class="text-muted">
                    {translate key="label.type.`$type`"}
                </div>
            </td>
            <td>{$item->getDateAdded()|date_format}</td>
        </tr>
    {/foreach}
    </tbody>

    <tfoot>
        <tr>
            <td class="option">
                <input type="checkbox" name="all" class="select-all" />
            </td>
            <td colspan="3">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="input-group add-on">
                            <select name="action" class="form-control form-action">
                                <option value="">---</option>
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
            </td>
        </tr>
    </tfoot>
</table>
