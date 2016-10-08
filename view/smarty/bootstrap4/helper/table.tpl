{$hasTableActions = isset($tableActions) && $tableActions}
{if $hasTableActions || $table->hasRows() || $table->hasSearch()}
    {tableVars}
    {include file="helper/form.prototype"}

    {$tableMessages = json_encode($table->getActionConfirmationMessages())}
    <form id="{$tableForm->getId()}" action="{if isset($tableAction)}{$tableAction}{else}{$table->getFormUrl()}{/if}" method="POST" class="table form-inline" role="form" data-confirm-messages="{$tableMessages|escape}">
        {call formWidget form=$tableForm row=$tableNameField}

        {if $hasTableActions || $table->hasSearch()}
        <div class="row">
            {if $hasTableActions}
            <div class="col-md-6 m-b-1">
                <div class="btn-group">
                {if $tableActions|count <= 2}
                    {foreach $tableActions as $url => $dataAction}
                    <a href="{$url}" class="btn btn-secondary">{$dataAction}</a>
                    {/foreach}
                {else}
                    {foreach $tableActions as $url => $dataAction}
                    {if $dataAction@index < 2}
                    <a class="btn btn-secondary" href="{$url}" >{$dataAction}</a>
                    {elseif $dataAction@index == 2}
                      <div class="btn-group" role="group">
                        <button id="btnTableActions" type="button" class="btn btn-secondary btn-empty dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        </button>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="btnTableActions">
                            <a class="dropdown-item" href="{$url}" >{$dataAction}</a>
                    {else}
                    <a class="dropdown-item" href="{$url}" >{$dataAction}</a>
                    {/if}
                    {/foreach}
                    </div>
                  </div>
                {/if}
                </div>
            </div>
            {/if}
            {if $table->hasSearch()}
            <div class="{if !$hasTableActions}offset-md-6 {/if}col-md-6 m-b-1 clearfix">
                <div class="form-group form-group-search pull-sm-right">
                    {$row = $tableForm->getRow($tableSearchQueryField)}
                    {$widget = $row->getWidget()}
                    {$widget->setAttribute('placeholder', "label.search.query"|translate)}

                    <div class="input-group add-on">
                        {call formWidget form=$tableForm row=$row}
                        <div class="input-group-btn">
                            <button type="submit" name="applySearch" class="btn btn-secondary" title="{"button.search"|translate}">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            {/if}
        </div>
        {/if}

        {if $table->hasOrderMethods()}
        <div class="row">
            <div class="col-xs-12">
                <div class="form-group form-group-order m-b-1 pull-xs-right">
                    <div class="input-group">
                        <span class="input-group-addon hidden-xs-down">
                            {translate key="label.table.order"}
                        </span>
                        {call formWidget form=$tableForm row=$tableOrderField}
                        <div class="input-group-btn add-on">
                            <div class="btn-group" data-toggle="buttons">
                              <label class="btn btn-secondary{if $table->getOrderDirection() == 'asc'} active{/if}">
                                <input type="radio" name="order-direction" id="asc" value="asc" autocomplete="off"{if $table->getOrderDirection() == 'asc'} checked{/if}>
                                <span class="fa fa-sort-amount-asc"></span>
                              </label>
                              <label class="btn btn-secondary{if $table->getOrderDirection() == 'desc'} active{/if}">
                                <input type="radio" name="order-direction" id="desc" value="desc" autocomplete="off"{if $table->getOrderDirection() == 'desc'} checked{/if}>
                                <span class="fa fa-sort-amount-desc"></span>
                              </label>
                            </div>
                       </div>
                    </div>
                </div>
            </div>
        </div>
        {/if}

        {if $table->hasRows()}
            <table class="table table-striped table-hover table-bordered">
            {block name="table.content"}
                {$table->getHtml('_content_')}
            {/block}
                <tfoot>
            {$hasTableActions = $table->hasActions() && $tableForm->hasRow($tableActionField)}
                {block name="table.actions"}
                    <tr>
                        {if $hasTableActions}
                        <td class="option">
                            <input type="checkbox" id="form-select-all" class="form-select-all" />
                        </td>
                        <td colspan="{$table->countColumns() - 1}">
                            <div class="row">
                                {if $hasTableActions}
                                <div class="col-sm-6">
                                    <div class="input-group add-on">
                                        {$row = $tableForm->getRow($tableActionField)}
                                        {$widget = $row->getWidget()}
                                        {$widget->setAttribute('class', 'col-xs-3')}
                                        {$bulk = "label.actions.bulk"|translate}
                                        {$options = $widget->getOptions()}
                                        {$options[0] = "- `$bulk` -"}
                                        {$widget->setOptions($options)}

                                        {call formWidget form=$tableForm row=$row}
                                        <div class="input-group-btn">
                                            <button name="applyAction" type="submit" class="btn btn-secondary">
                                                {"button.apply"|translate}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                {/if}
                                {if $table->hasPaginationOptions()}
                                <div class="col-sm-6">
                                    <span class="pull-xs-right p-t-1">
                                        {translate key="label.table.rows.total" rows=$table->countRows()}
                                    </span>
                                </div>
                                {/if}
                            </div>
                        </td>
                    </tr>
                        {/if}
                {/block}
                </tfoot>
            </table>

            {if $table->hasPaginationOptions()}
                {block name="table.pagination"}
            <div class="row">
                {if $table->getRowsPerPage() || $table->getPaginationOptions()}
                    <div class="col-md-7">
                        {if $table->getPages() > 1}
                            {pagination page=$table->getPage() pages=$table->getPages() href=$table->getPaginationUrl()}
                        {/if}
                    </div>

                    {if $table->getPaginationOptions()}
                    <div class="col-md-5">
                        <div class="form-group form-group-pagination pull-xs-right">
                            {$row = $tableForm->getRow($tablePageRowsField)}
                            {$widget = $row->getWidget()}
                            {$widget->setAttribute('class', 'custom-select col-xs-1')}

                            {call formWidget form=$tableForm row=$row}

                            <label>&nbsp;{translate key="label.table.rows.page"}</label>
                        </div>
                    </div>
                    {/if}
                {/if}
            </div>
                {/block}
            {/if}
        {/if}
    </form>
{else}
    <p>No rows</p>
{/if}
