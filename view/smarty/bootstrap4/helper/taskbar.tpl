{function name="taskbarMenuItems" items=null itemClass=null anchorClass=null}
    {foreach $items as $item}
        {if $item === '-'}
            <li role="presentation" class="dropdown-divider"></li>
        {elseif is_string($item)}
            <li role="presentation" class="dropdown-header">{$item}</li>
        {elseif !method_exists( $item, 'hasItems')}
            <li><a class="{$anchorClass}" href="{$item->getUrl()}">{$item->getLabel()}</a></li>
        {else}
            {if $itemClass == "dropdown-menu"}
                <li role="presentation" class="dropdown-header">
                    {$item->getLabel()}
                </li>
                {call taskbarMenuItems items=$item->getItems() anchorClass=$anchorClass}
            {else}
                <li role="presentation" class="{$itemClass} btn-group">
                    {$id = \ride\library\StringHelper::safeString($item->getLabel())}
                    <a class="{$anchorClass} dropdown-toggle" href="#" id="taskbar{$id}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        {$item->getLabel()}
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="taskbar{$id}">
                    {call taskbarMenuItems items=$item->getItems() itemClass="dropdown-menu" anchorClass="dropdown-item"}
                    </ul>
                </li>
            {/if}
        {/if}
    {/foreach}
{/function}

{function name="taskbarPanelLocales" url=null locale=null locales=null}
    <li class="nav-item btn-group">
        <a href="#" class="nav-link btn btn-secondary dropdown-toggle" id="taskbarDropdownLocales" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            {$locale|upper}
        </a>
        <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="taskbarDropdownLocales">
        {foreach $locales as $code => $locale}
            <li>
                <a class="dropdown-item" href="{$url|replace:"%25locale%25":$code}">
                    {translate key="language.`$code`"}
                </a>
            </li>
        {/foreach}
        </ul>
    </li>
{/function}

{* <nav class="navbar navbar-fixed-top navbar-full navbar-dark navbar-taskbar bg-inverse"> *}
<nav class="navbar navbar-toggleable-md navbar-inverse bg-inverse fixed-top navbar-taskbar">
    <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#collapsingNavbar" aria-controls="collapsingNavbar" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
<div class="container">
{block name="taskbar_title"}
    <a class="navbar-brand" href="{$app.url.base}">
        {$title}
    </a>
{/block}
    <div class="collapse navbar-collapse" id="collapsingNavbar">
        <ul class="navbar-nav mr-auto">
    {block name="taskbar_applications"}
        {if $applicationsMenu->hasItems()}
            {call taskbarMenuItems items=$applicationsMenu->getItems() itemClass="nav-item" anchorClass="nav-link"}
        {/if}
    {/block}
        </ul>
        <ul class="navbar-nav float-xs-right">
            {block name="taskbar_panels"}{/block}
            {block name="taskbar_menu"}
            <li class="nav-item btn-group">
                <a href="#" class="nav-link dropdown-toggle" id="taskbarDropdownRight" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    {if !$app.user || !$app.user->getImage()}
                        <span class="fa fa-user"></span>
                    {/if}
                    {if $app.user}
                        {if $app.user->getImage()}
                           <img src="{image src=$app.user->getImage() transformation="crop" width=18 height=18}" />
                        {/if}
                        {$app.user->getDisplayName()}
                    {else}
                        {translate key="label.user.anonymous"}
                    {/if}
                </a>
                <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="taskbarDropdownRight">
                    {block name="taskbar_settings"}
                        {$userMenu = $settingsMenu->getItem('user.menu')}
                        {$logoutMenuItem = $userMenu->getItem('user.logout')}
                        {if $logoutMenuItem}
                            {$null = $userMenu->removeItem($logoutMenuItem)}
                        {/if}

                        {$items = $userMenu->getItems()}

                        {if $logoutMenuItem}
                            {$items[] = '-'}
                            {$items[] = $logoutMenuItem}
                        {/if}

                        {if $items}
                            {call taskbarMenuItems items=$items itemClass="dropdown-menu" anchorClass="dropdown-item"}
                        {/if}
                    {/block}
                </ul>
            </li>
            {/block}
        </ul>
    </div>
</div>
</nav>
