{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.locales"} | {/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="system"}">
            {translate key="title.system"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.locales"}">
            {translate key="title.locales"}
        </a>
    </nav>

    <div class="page-header m-b-2">
        <h1>{translate key="title.locales"}</h1>
    </div>
{/block}

{block name="content" append}
    <p>{translate key="label.locales.information"}</p>

    <div class="locales m-b-2" data-url-order="{url id="system.locales.order"}">
    {foreach $locales as $locale}
        {$code = $locale->getCode()}
        {$properties = $locale->getProperties()}

        <div class="locale locale-{$code} m-b-2" id="locales-{$code}">
            <h3>{translate key="language.`$code`"}</h3>
            <dl>
                <dt>{translate key="label.name.native"}</dt>
                <dd>{$locale->getName()}</dd>
                <dt>{translate key="label.code"}</dt>
                <dd>{$code}</dd>
            </dl>
            <div class="btn-group">
                <a class="btn btn-secondary" href="{url id="system.translations.locale" parameters=["locale" => $code]}?referer={$app.url.request|escape}">
                    {translate key="button.translations.manage"}
                </a>
            {if $properties}
                <button type="button" class="btn btn-secondary btn-toggle-properties" data-toggle="button" aria-pressed="false" data-target=".locale-{$code} .properties">
                    {translate key="button.properties.toggle"}
                </button>
            {/if}
            </div>

            {if $properties}
            <div class="properties m-t-2">
                <h4>{translate key="title.properties"}</h4>
                <table class="table table-bordered table-hover table-striped">
                    <thead>
                        <tr>
                            <th class="col-md-4">{translate key="label.property"}</th>
                            <th class="col-md-8">{translate key="label.value"}</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $properties as $key => $value}
                    <tr>
                        <td class="col-md-4">{$key}</td>
                        <td class="col-md-8">{$value}</td>
                    </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>
            {/if}
        </div>
    {/foreach}
    </div>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-ui.js"}
    {script src="bootstrap4/js/modules/system-locales.js"}
{/block}
