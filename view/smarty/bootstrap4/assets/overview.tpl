{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="taskbar_panels" append}
    {url id="assets.folder.overview" parameters=["locale" => "%locale%", "folder" => $folder->id] var="url"}
    {$url = "`$url``$urlSuffix`"}
    {call taskbarPanelLocales url=$url locale=$locale locales=$locales}
{/block}

{block name="content_title"}
<div class="page-header m-b-2">
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="assets.overview.locale" parameters=["locale" => $locale]}?view={$view}&embed={$embed}&limit={$limit}">
            {translate key="title.assets"}
        </a>
        {foreach $breadcrumbs as $id => $name}
            <a class="breadcrumb-item" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $id]}?view={$view}&embed={$embed}&limit={$limit}">
                {$name}
            </a>
        {/foreach}
    </nav>

    <h1>
        {translate key="title.assets"}
        {if $folder->getId()}
            <small class="text-muted">
                {$folder->getName()}
            </small>
        {/if}
    </h1>
</div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}
    <form id="{$form->getId()}" class="form-inline form-filter" action="{$app.url.request}" method="POST" role="form">
        <div class="row">
            <div class="col-md-6 m-b-1">
                <div class="btn-group">
                    <a class="btn btn-secondary" href="{url id="assets.asset.add" parameters=["locale" => $locale]}?folder={$folder->id}&embed={$embed}&referer={$app.url.request|urlencode}">
                       {translate key="button.add.asset"}
                    </a>
                    <a class="btn btn-secondary" href="{url id="assets.folder.add" parameters=["locale" => $locale]}?folder={$folder->id}&embed={$embed}&referer={$app.url.request|urlencode}">
                       {translate key="button.add.folder"}
                    </a>
                </div>
            </div>
            <div class="col-md-6 m-b-1 clearfix">
                <div class="form-group form-group-search pull-sm-right">
                    {$row = $form->getRow('query')}
                    {$widget = $row->getWidget()}
                    {$widget->setAttribute('placeholder', "label.search.query"|translate)}

                    <div class="input-group add-on">
                        {call formWidget form=$form row=$row}
                        <div class="input-group-btn">
                            <button type="submit" name="applySearch" class="btn btn-secondary" title="{"button.search"|translate}">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row m-b-1">
            <div class="col-md-6">
                <div class="form-group">
                    {call formWidget form=$form row="type"}
                </div>
                <div class="form-group">
                    <div class="input-group add-on">
                        {call formWidget form=$form row="date"}
                        <div class="input-group-btn add-on">
                            <button name="submit" value="filter" type="submit" class="btn btn-secondary btn-filter">
                                {translate key="button.filter"}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 m-b-1">
                <div class="btn-group pull-xs-right">
                    <a class="btn btn-secondary{if $view == "grid"} active{/if}" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $folder->id]}?view=grid&type={$filter.type}&date={$filter.date}&limit={$limit}&embed={$embed}">
                        <span class="fa fa-th"></span>
                    </a>
                    <a class="btn btn-secondary{if $view == "list"} active{/if}" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $folder->id]}?view=list&type={$filter.type}&date={$filter.date}&limit={$limit}&embed={$embed}">
                        <span class="fa fa-th-list"></span>
                    </a>
                </div>
            </div>
        </div>

    {if $folder->description}
        <div class="description">{$folder->description}</div>
    {/if}

        <div class="assets assets-{$view}">
            <div class="asset-items clearfix">
                {include file="assets/overview.`$view`" inline}
            </div>
        </div>

        <div class="row">
            <div class="col-md-7">
            {if $pages > 1}
                {pagination pages=$pagination->getPages() page=$pagination->getPage() href=$pagination->getHref()}
            {/if}
            </div>
            <div class="col-md-5">
                <button name="applyPagination" value="limit" type="submit" class="btn btn-secondary pull-xs-right">
                    {"button.apply"|translate}
                </button>
                <div class="form-group form-group-pagination pull-xs-right">
                    <select name="limit" class="form-control col-xs-1">
                        <option value="12"{if $limit == 12} selected="selected"{/if}>12</option>
                        <option value="18"{if $limit == 18} selected="selected"{/if}>18</option>
                        <option value="24"{if $limit == 24} selected="selected"{/if}>24</option>
                        <option value="48"{if $limit == 48} selected="selected"{/if}>48</option>
                        <option value="96"{if $limit == 96} selected="selected"{/if}>96</option>
                    </select>
                    <label class="m-l-1 m-r-1">{translate key="label.table.rows.page"}</label>
                </div>
            </div>
        </div>

        <div class="row text-center">
            <br />
            <select name="order" class="form-control form-order">
                <option value="">- {translate key="label.actions.order"} -</option>
                <option value="asc">{translate key="label.order.asc"}</option>
                <option value="desc">{translate key="label.order.desc"}</option>
                <option value="newest">{translate key="label.order.newest"}</option>
                <option value="oldest">{translate key="label.order.oldest"}</option>
            </select>
            <button name="submit" value="order" type="submit" class="btn btn-default btn-order">{translate key="button.order"}</button>
        </div>
    </form>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/modules/assets.css" media="screen"}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-ui.js"}
{/block}

{block name="scripts_inline" append}
    <script type="text/javascript">
        $(function () {
            $('.select-all').click(function() {
                $('.order-item input[type=checkbox]').prop('checked', $(this).prop('checked'));
            });

            $('.form-limit').on('change', function() {
                $('.btn-limit').trigger('click');
            });
            $('.btn-limit').hide();

        {if !$isFiltered}
            var sortFolderUrl = "{url id="assets.folder.sort" parameters=["locale" => $locale, "folder" => $folder->getId()]}";
            var sortAssetUrl = "{url id="assets.asset.sort" parameters=["locale" => $locale, "folder" => $folder->getId()]}";

            $(".asset-items-folders").sortable({
                cursor: "move",
                handle: ".order-handle",
                items: ".order-item",
                select: false,
                scroll: true,
                update: function (event, ui) {
                    var order = [];

                    $('.asset-items-folders .order-item').each(function() {
                        var $this = $(this);

                        order.push($this.data('id'));
                    });

                    $.post(sortFolderUrl, {ldelim}order: order, page: {$page}, limit: {$limit}});
                }
            });

            $(".asset-items-assets").sortable({
                cursor: "move",
                handle: ".order-handle",
                items: ".order-item",
                select: false,
                scroll: true,
                update: function (event, ui) {
                    var order = [];

                    $('.asset-items-assets .order-item').each(function() {
                        var $this = $(this);

                        order.push($this.data('id'));
                    });

                    $.post(sortAssetUrl, {ldelim}order: order, page: {$page}, limit: {$limit}});
                }
            });
        {/if}
        });
    </script>
{/block}
