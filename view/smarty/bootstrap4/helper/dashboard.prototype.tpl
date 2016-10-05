{function name="dashboardMenu" items=null title=null referer=null icons=null defaultIcon='cube'}
{$defaultIcons = [
    "api" => "code",
    "assets.image.styles" => "file-image-o",
    "assets.overview" => "image",
    "manual" => "book",
    "orm.events" => "calendar",
    "taxonomy.vocabulary.list" => "tags",
    "system.cache" => "gears",
    "system.calendar" => "calendar-check-o",
    "system.details" => "info-circle",
    "system.dependencies" => "code-fork",
    "system.exception" => "exclamation-triangle",
    "system.locales" => "language",
    "system.log" => "clipboard",
    "system.orm" => "database",
    "system.parameters" => "cog",
    "system.preferences" => "wrench",
    "system.routes" => "sitemap",
    "system.security.access" => "lock",
    "system.security.user" => "users",
    "varnish" => "flash"
]}
{if $icons === null}
    {$icons = $defaultIcons}
{/if}
{if $title}
    {$id = \ride\library\StringHelper::safeString($title)}
    <h2 class="m-b-2">
        <a data-toggle="collapse" href="#{$id}" aria-expanded="true" aria-controls="dashboard{$id}">
            {$title}
        </a>
    </h2>
    <div id="{$id}" class="collapse in">
{/if}

{$index = 0}
<div class="row">
{foreach $items as $item}
    {if is_string($item)}
        {continue}
    {/if}
    {if $index == 3}
    </div>
    <div class="row">
        {$index = 0}
    {/if}

    {$isOrm = false}
    {$label = $item->getLabel()}
    {$url = $item->getUrl()}

    {$id = $item->getRouteId()}
    {if $id == 'system.orm.scaffold.index'}
        {$safeLabel = \ride\library\StringHelper::safeString($label)}
        {$id = "orm.`$safeLabel`"}
        {$isOrm = true}
    {/if}
    <div class="media col-md-4 m-b-2">
        <a class="media-left text-xs-center" href="{$item->getUrl()}{$referer}" style="min-width: 4em;">
            <span class="fa fa-3x fa-{if isset($icons[$id])}{$icons[$id]}{else}{$defaultIcon}{/if}"></span>
        </a>
        <div class="media-body">
            <h3 class="media-heading h4">
                <a href="{$url}{$referer}">
                    {$label}
                </a>
            </h3>

            {translate key="dashboard.`$id`.description"}

            <div class="m-t-1">
            {if $isOrm}
                <a href="{$url}/add{$referer}">
                    {translate key="button.entry.add"}
                </a>
            {else}
                {if $id == 'system.security.user'}
                    <a href="{url id="system.security.user.add"}{$referer}">
                        {translate key="button.user.add"}
                    </a>
                {elseif $id == 'system.cache'}
                    <a href="{url id="system.cache.clear"}{$referer}">
                        {translate key="button.cache.clear"}
                    </a>
                {elseif $id == 'system.locales'}
                    {translate key="label.translations.manage"}
                    <ul class="m-t-1" role="navigation">
                    {foreach $app.locales as $localeCode => $locale}
                        <li>
                            <a href="{url id="system.translations.locale" parameters=["locale" => $localeCode]}{$referer}">
                                {$locale->getName()}
                            </a>
                        </li>
                    {/foreach}
                    </ul>
                {/if}
            {/if}
            </div>
        </div>
    </div>

    {$index = $index + 1}
{/foreach}
</div>

{if $title}
    </div>
{/if}

{/function}
