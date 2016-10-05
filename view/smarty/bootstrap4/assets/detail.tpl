{if $view == 'grid'}
    <div class="asset-item is-addable" data-type="{$item->getType()}" data-id="{$item->getId()}">
        <label>
            <input class="pull-xs-left m-r-1" type="checkbox" name="assets[]" value="{$item->getId()}" />
            <div class="image">
                <img src="{image src=$item->getThumbnail() default="bootstrap4/img/asset-`$item->getType()`.png" width=120 height=120 transformation="crop"}" class="img-rounded" />
            </div>
            <div class="name">
                <span class="order-handle text-muted fa fa-arrows"></span>
            {if !$embed}
                <a href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}" title="{$item->getName()|escape}">
                    {$item->getName()|escape|truncate:14}
                </a>
            {else}
                {$item->getName()|escape|truncate:14}
            {/if}
            </div>
        </label>
    </div>
{else}
    {$type = $item->getType()}
    <tr class="asset-item is-addable" data-type="{$type}" data-id="{$item->getId()}">
        <td class="option">
            <input type="checkbox" name="assets[]" value="{$item->getId()}" />
            <span class="order-handle text-muted fa fa-arrows"></span>
        </td>
        <td class="image">
            <img src="{image src=$item->getThumbnail() default="bootstrap4/img/asset-`$item->getType()`.png" width=50 height=50 transformation="crop"}" class="img-fluid img-rounded" />
        </td>
        <td>
            {if !$embed}
            <a href="{url id="assets.asset.edit" parameters=["locale" => $locale, "asset" => $item->getId()]}?embed={$embed}&referer={$app.url.request|urlencode}">
                {$item->getName()|escape}
            <a>
            {else}
                {$item->getName()|escape}
            {/if}
            <div class="text-muted">
                {translate key="label.type.`$type`"}
            </div>
        </td>
        <td>{$item->getDateAdded()|date_format}</td>
    </tr>

{/if}
