{extends file="base/index"}

{block name="head_title" prepend}{translate key="title.assets"} | {/block}

{block name="taskbar_panels" append}
    {url id="assets.folder.overview" parameters=["locale" => "%locale%", "folder" => $folder->id] var="url"}
    {$url = "`$url``$urlSuffix`"}
    {call taskbarPanelLocales url=$url locale=$locale locales=$locales}
{/block}

{block name="content_title"}
<div class="page-header{if !$embed} mb-3{/if}">
    <nav class="breadcrumb">
    {if !$embed}
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
    {/if}
        <a class="breadcrumb-item" href="{url id="assets.overview.locale" parameters=["locale" => $locale]}?view={$view}&embed={$embed}&limit={$limit}">
            {translate key="title.assets"}
        </a>
        {foreach $breadcrumbs as $id => $name}
            <a class="breadcrumb-item" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $id]}?view={$view}&embed={$embed}&limit={$limit}">
                {$name}
            </a>
        {/foreach}
    </nav>
    {if !$embed}
    <h1>
        {translate key="title.assets"}
        {if $folder->getId()}
            <small class="text-muted">
                {$folder->getName()}
            </small>
        {/if}
    </h1>
    {/if}
</div>
{/block}

{block name="content_body" append}
    {include file="helper/form.prototype"}

    {if $folder->getDescription()}
        <div class="mb-3">{$folder->getDescription()}</div>
    {/if}

    <form action="{url id="assets.asset.add" parameters=["locale" => $locale]}?folder={$folder->id}&view={$view}&embed={$embed}"
        class="dropzone mb-3"
        id="asset-dropzone"
        data-label-default="{translate key="label.dropzone"}"
        data-label-error-filesize="{translate key="error.filesize"}"
        data-label-success="{translate key="success.asset.saved"}"
        data-page="{$page}"
        data-limit="{$limit}"
        data-max-filesize="{$maxFileSize}">

        <div class="fallback">
            <input name="file" type="file" multiple />
        </div>
    </form>

    {$tableMessages = json_encode(["button.delete"|translate => "label.confirm.item.delete"|translate])}
    <form action="{$app.url.request}"
        class="form-filter mb-1"
        id="{$form->getId()}"
        method="POST"
        role="form"
        data-page="{$page}"
        data-limit="{$limit}"
    {if !$isFiltered}
        data-url-order-folder="{url id="assets.folder.sort" parameters=["locale" => $locale, "folder" => $folder->getId()]}"
        data-url-order-asset="{url id="assets.asset.sort" parameters=["locale" => $locale, "folder" => $folder->getId()]}"
        data-label-success-order="{translate key="success.asset.ordered"}"
    {/if}
        data-confirm-messages="{$tableMessages|escape}">

        {call formWidget form=$form row="_submit"}

        <div class="row">
            <div class="col-md-6">
                <div class="btn-group">
                    <a class="btn btn-secondary" href="{url id="assets.asset.add" parameters=["locale" => $locale]}?folder={$folder->id}&embed={$embed}&referer={$app.url.request|urlencode}">
                       {translate key="button.add.asset"}
                    </a>
                    <a class="btn btn-secondary" href="{url id="assets.folder.add" parameters=["locale" => $locale]}?folder={$folder->id}&embed={$embed}&referer={$app.url.request|urlencode}">
                       {translate key="button.add.folder"}
                    </a>
                    {if !$embed}
                    <a href="#" class="btn btn-link" data-toggle="modal" data-target="#modal-assets-order">
                        {translate key="button.assets.order"}
                    </a>
                    {/if}
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group form-group-search float-right">
                    {$row = $form->getRow('query')}
                    {$widget = $row->getWidget()}
                    {$widget->setAttribute('placeholder', "label.search.query"|translate)}

                    <div class="input-group add-on">
                        {call formWidget form=$form row=$row}
                        <div class="input-group-btn">
                            <button type="submit" value="filter" name="applySearch" class="btn btn-secondary" title="{"button.search"|translate}">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-8">
                <div class="form-group">
                    {$row = $form->getRow('type')}
                    {$widget = $row->getWidget()}
                    {$widget->setAttribute('class', 'w-25 float-left mr-2')}

                    {call formWidget form=$form row=$row}
                    <div class="input-group add-on w-50 float-left">
                        {call formWidget form=$form row="date"}
                        <div class="input-group-btn add-on">
                            <button name="applyFilter" value="filter" type="submit" class="btn btn-secondary btn-filter">
                                {translate key="button.filter"}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4 mb-1">
                <div class="btn-group float-right">
                    <a class="btn btn-secondary{if $view == "grid"} active{/if}" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $folder->id]}?view=grid&type={$filter.type}&date={$filter.date}&limit={$limit}&embed={$embed}">
                        <span class="fa fa-th"></span>
                    </a>
                    <a class="btn btn-secondary{if $view == "list"} active{/if}" href="{url id="assets.folder.overview" parameters=["locale" => $locale, "folder" => $folder->id]}?view=list&type={$filter.type}&date={$filter.date}&limit={$limit}&embed={$embed}">
                        <span class="fa fa-th-list"></span>
                    </a>
                </div>
            </div>
        </div>

        <div class="assets assets-{$view}">
            <div class="asset-items clearfix">
                {include file="assets/overview.`$view`" inline}
            </div>
        </div>

        <div class="row mt-2">
            <div class="col-md-7">
                {$paginationClass = null}
                {if $pagination->getPages() == 1}
                    {$paginationClass = "hidden-xs-up"}
                {/if}
                {pagination pages=$pagination->getPages() page=$pagination->getPage() href=$pagination->getHref() class=$paginationClass}
            </div>
            <div class="col-md-5">
                <div class="form-group form-group-pagination text-right">
                    <select name="limit" class="form-control w-25 custom-select">
                        <option value="12"{if $limit == 12} selected="selected"{/if}>12</option>
                        <option value="18"{if $limit == 18} selected="selected"{/if}>18</option>
                        <option value="24"{if $limit == 24} selected="selected"{/if}>24</option>
                        <option value="48"{if $limit == 48} selected="selected"{/if}>48</option>
                        <option value="96"{if $limit == 96} selected="selected"{/if}>96</option>
                    </select>
                    <label>&nbsp;{translate key="label.table.rows.page"}</label>
                </div>
            </div>
        </div>
    {if !$embed}
        <div class="modal fade" id="modal-assets-order" tabindex="-1" role="dialog" aria-labelledby="modal-assets-order-label" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                          <span aria-hidden="true">&times;</span>
                        </button>
                         <h4 class="modal-title" id="modal-assets-order-label">{"button.order"|translate}</h4>
                    </div>
                    <div class="modal-body">
                        <select name="order" class="form-control form-order custom-select">
                            <option value="">- {translate key="label.actions.order"} -</option>
                            <option value="asc">{translate key="label.order.asc"}</option>
                            <option value="desc">{translate key="label.order.desc"}</option>
                            <option value="newest">{translate key="label.order.newest"}</option>
                            <option value="oldest">{translate key="label.order.oldest"}</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button name="applyOrder" value="order" type="submit" class="btn btn-primary btn-order">
                            {translate key="button.order"}
                        </button>
                        <button type="button" class="btn btn-link" data-dismiss="modal">
                            {translate key="button.cancel"}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    {/if}
    </form>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/dropzone.css" media="all"}
    {style src="bootstrap4/css/modules/assets.css" media="all"}
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-bootstrap-growl.js"}
    {script src="bootstrap4/js/jquery-ui.js"}
    {script src="bootstrap4/js/parsley.js"}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/dropzone.js"}
    {script src="bootstrap4/js/modules/assets.js"}
{/block}
