{*
    Prototype functions for the form rendering

    To override, create a file and recreate the functions you wish to override.
    At the end of your file, include this one to define the missing functions.
*}

{*
    Renders the rows of the form
*}
{function name="formRows" rows=null form=null rowClass=null}
    {if !$rows && $form}
        {$rows = $form->getRows()}
    {/if}

    {if $rows}
        {foreach $rows as $row}
            {if !$row->isRendered()}
                {call formRow form=$form row=$row class=$rowClass}
            {/if}
        {/foreach}
    {/if}
{/function}

{*
    Renders a simple row of the form
*}
{function name="formRow" form=null row=null part=null class=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {if $row}
        {$type = $row->getType()}
        {if $type == 'hidden'}
            {call formWidget form=$form row=$row part=$part}

            {$errors = $form->getValidationErrors($row->getName())}
            {if $errors}
            <div class="form-group has-error">
                {call formWidgetErrors form=$form row=$row}
            </div>
            {/if}
        {elseif $type == 'component' && $row->getOption('embed')}
            {call formWidgetComponent form=$form row=$row}
        {elseif $type == 'collection'}
            {$errors = $form->getValidationErrors($row->getName())}

            <div class="form-group row-{$row->getName()|replace:'[':''|replace:']':''}{if $row->isRequired()} required{/if}{if $row->isDisabled()} disabled{/if}{if $row->isReadOnly()} readonly{/if} clearfix{if $errors} has-danger{/if}{if $class} {$class}{/if}"{if $row->getOption('order')} data-order="true"{/if}>
                <label>
                    {if $row->getOption('localized')}
                        <span class="fa fa-language text-muted" title="{translate key="label.field.localized"}"></span>
                    {/if}
                    {$row->getLabel()}
                </label>

                {call formCollectionPrototype assign="prototype" form=$form row=$row part='%prototype%'}

                <div class="collection-controls" data-prototype="{$prototype|escape:"html"|trim|replace:"\n":''}">
                    {call formWidgetCollection form=$form row=$row part=$part}

                    {if $errors}
                        <ul class="list-unstyled text-danger m-b-0">
                        {foreach $errors as $error => $dummy}
                            <li>{$error}</li>
                        {/foreach}
                        </ul>
                    {/if}

                    {$description = $row->getDescription()}
                    {if $description}
                    <span class="form-text text-muted">{$description}</span>
                    {/if}
                </div>
            </div>
        {else}
            {$errors = $form->getValidationErrors()}
            {$widget = $row->getWidget()}
            {$rowName = $row->getName()}

            {$errorsName = $widget->getName()}
            {if $widget->isMultiple() && $part}
                {$errorsName = "`$errorsName`[`$part`]"}
            {/if}

            {if isset($errors.$errorsName)}
                {$errors = $errors.$errorsName}
            {elseif isset($errors.$rowName)}
                {$errors = $errors.$rowName}
            {else}
                {$errors = array()}
            {/if}

            <div class="form-group row-{$rowName|replace:'[':''|replace:']':''}{if $row->isRequired()} required{/if}{if $row->isDisabled()} disabled{/if}{if $row->isReadOnly()} readonly{/if} clearfix{if $errors} has-danger{/if}{if $class} {$class}{/if}">
                <label class="d-block" for="{$widget->getId()}">
                    {if $row->getOption('localized')}
                        <span class="fa fa-language text-muted" title="{translate key="label.field.localized"}"></span>
                    {/if}
                    {if $type != 'button'}{$row->getLabel()}{/if}
                </label>

                {call formWidget form=$form row=$row part=$part errors=$errors}

                {if $errors}
                    <ul class="list-unstyled text-danger m-b-0">
                    {foreach $errors as $error}
                        <li>{$error->getCode()|translate:$error->getParameters()}</li>
                    {/foreach}
                    </ul>
                {/if}

                {if $widget && $type == 'option'}
                    {$widgetOptions = $widget->getOptions()}
                {else}
                    {$widgetOptions = array()}
                {/if}

                {$description = $row->getDescription()}
                {if $description && $type !== 'checkbox' && ($type !== 'option' || ($type === 'option' && $widget && $widgetOptions))}
                    <small class="form-text text-muted">{$description}</small>
                {/if}

                {if $type == 'date'}
                    <small class="form-text text-muted">{translate key="label.date.example" example=time()|date_format:$row->getFormat() format=$row->getFormat()}</small>
                {elseif $type == 'select' && $widget->isMultiple()}
                    <small class="form-text text-muted">{translate key="label.multiselect"}</small>
                {/if}
            </div>
        {/if}

        {$row->setIsRendered(true)}
    {else}
        <div class="alert alert-danger">Could not render row: No row provided</div>
    {/if}
{/function}

{*
    Renders the errors of a single widget of the form
*}
{function name="formWidgetErrors" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {if $row}
        {$widget = $row->getWidget()}

        {if $widget}
            {$errors = $form->getValidationErrors()}
            {$errorsName = $widget->getName()}
            {if $widget->isMultiple() && $part !== null}
                {$errorsName = "`$errorsName`[`$part`]"}
            {/if}

            {if isset($errors.$errorsName)}
                {$errors = $errors.$errorsName}
            {else}
                {$errors = array()}
            {/if}

            {if $errors}
                <ul class="list-unstyled text-danger m-b-0">
                {foreach $errors as $error}
                    <li>{$error->getCode()|translate:$error->getParameters()}</li>
                {/foreach}
                </ul>
            {/if}
        {else}
            <span class="alert alert-danger">No widget set in row {$row->getName()}.</span>
        {/if}
    {else}
        <span class="alert alert-danger">Could not render widget errors: No row provided</span>
    {/if}
{/function}

{*
    Renders a single control of the form
*}
{function name="formWidget" form=null row=null part=null type=null errors=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {if $row}
        {if !$type}
            {$widget = $row->getWidget()}
            {$type = $widget->getType()}
        {/if}
        {$type = $type|ucfirst}

        {if !$type}
            <span class="alert alert-danger">Could not render widget: No type provided for row {$row->getName()}</span>
        {else}
            {call "formWidget`$type`" form=$form row=$row part=$part errors=$errors}

            {$row->setIsRendered(true)}
        {/if}
    {else}
        <span class="alert alert-danger">Could not render widget: No row provided</span>
    {/if}
{/function}

{function name="formWidgetHidden" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        <input type="hidden"
               name="{$widget->getName()}{if $part !== null}[{$part}]{/if}"
               value="{$widget->getValue($part)|escape}"
           {foreach $widget->getAttributes() as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         />
    {/if}
{/function}

{function name="formWidgetLabel" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {$attributes = $widget->getAttributes()}
        {if isset($attributes.class)}
            {$attributes.class = "`$attributes.class` form-control-static"}
        {else}
            {$attributes.class = 'form-control-static'}
        {/if}

        {$value = $widget->getValue($part)}
        <p
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         >{if $row->getOption('html')}{$value}{else}<i>{$value|escape}</i>{/if}</p>
    {/if}
{/function}

{function name="formWidgetButton" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {$attributes = $widget->getAttributes()}
        {if isset($attributes.class)}
            {$attributes.class = "`$attributes.class` btn btn-primary"}
        {else}
            {$attributes.class = 'btn btn-primary'}
        {/if}

        <button
            type="submit"
            name="{$widget->getName()}{if $widget->isMultiple() || $part !== null}[{$part}]{/if}"
            value="{$widget->getValue($part)|escape}"
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         >{$row->getLabel()}</button>
    {/if}
{/function}

{function name="formWidgetString" form=null row=null part=null errors=null}
    {call "formPrototypeInput" type="text" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetNumber" form=null row=null part=null errors=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {$widget->setAttribute('data-parsley-type', 'number')}

        {call "formInput" type='text' widget=$widget part=$part validators=$row->getValidators() errors=$errors}
    {/if}
{/function}

{function name="formWidgetEmail" form=null row=null part=null errors=null}
    {call "formPrototypeInput" type="email" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetDate" form=null row=null part=null errors=null}
    {call "formPrototypeInput" type="date" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetWebsite" form=null row=null part=null errors=null}
    {call "formPrototypeInput" type="website" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetPassword" form=null row=null part=null errors=null}
    {call "formPrototypeInput" type="password" form=$form row=$row part=$part errors=$errors omitValue=true}
{/function}

{function name="formWidgetText" form=null row=null part=null errors=$errors}
    {call "formPrototypeTextarea" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetWysiwyg" form=null row=null part=null errors=null}
    {call "formPrototypeTextarea" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetRichcontent" form=null row=null part=null}
    {call "formPrototypeTextarea" form=$form row=$row part=$part errors=$errors}
{/function}

{function name="formWidgetFile" form=null row=null part=null errors=null}
    {call "formPrototypeFile" form=$form row=$row part=$part errors=$errors}
    {/function}

{function name="formWidgetImage" form=null row=null part=null errors=null}
    {call "formPrototypeFile" form=$form row=$row part=$part errors=$errors preview="image"}
{/function}

{function name="formPrototypeInput" type=null form=null row=null part=null errors=null omitValue=false}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {call "formInput" type=$type widget=$widget part=$part validators=$row->getValidators() errors=$errors omitValue=$omitValue}
    {/if}
{/function}

{function name="formPrototypeTextarea" form=null row=null part=null errors=$errors}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {call "formTextarea" widget=$widget part=$part validators=$row->getValidators() errors=$errors}
    {/if}
{/function}

{function name="formPrototypeFile" form=null row=null part=null errors=$errors preview=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {call "formFile" widget=$widget part=$part validators=$row->getValidators() errors=$errors preview=$preview}
    {/if}
{/function}

{function name="formWidgetAssets" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {$tmpAttributes = $widget->getAttributes()}
        {$validators = $row->getValidators()}
        {if $validators}
            {parsleyAttributes type="assets" attributes=$tmpAttributes validators=$validators var="tmpAttributes"}
        {/if}

        {if $widget->isMultiple()}
            {$maximum = 999}
        {else}
            {$maximum = 1}
        {/if}

        {$attributes = []}
        {foreach $tmpAttributes as $attributeName => $attributeValue}
            {if $attributeName == 'minlength'}
                {continue}
            {/if}
            {if $attributeName == 'maxlength'}
                {$maximum = $attributeValue}
                {continue}
            {/if}
            {$attributes.$attributeName = $attributeValue}
        {/foreach}

        <div>
            <div class="form-assets clearfix" data-field="{$attributes.id}" data-max="{$maximum}">
                {$assets = $widget->getAssets()}
                {foreach $assets as $asset}
                    <div class="form-assets-asset" data-id="{$asset->getId()}">
                        <img class="img-rounded" src="{image src=$asset->getThumbnail() default="bootstrap4/img/asset-`$asset->getType()`.png" transformation="crop" width=100 height=100}" alt="{$asset->getName()|escape}" title="{$asset->getName()|escape}">
                        <a href="#" class="btn btn-secondary btn-xs form-assets-remove" title="{translate key="button.asset.remove"}">
                            <span class="fa fa-remove"></span>
                        </a>
                    </div>
                {/foreach}
            </div>
            <div class="clearfix">
                <button class="btn btn-secondary pull-sm-left m-b-1 m-r-2 form-assets-add">
                    <i class="fa fa-image"></i>
                    {'button.browse'|translate}
                </button>
            </div>
        </div>

        {$value = $widget->getValue($part)}

        <input type="hidden"
               name="{$widget->getName()}"
               value="{$value|escape}"
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         />

         {if !isset($locale)}
            {$locale = $app.locale}
         {/if}

        <div class="modal fade" id="modal-assets-{$widget->getName()}" tabindex="-1" role="dialog" aria-labelledby="modal-assets-{$widget->getName()}" aria-hidden="true">
            <div class="modal-dialog modal-full modal-assets">
                <div class="modal-content">
                    <div class="modal-body is-loading">
                        {if $widget->getFolderId()}
                            {url id="assets.folder.overview" parameters=["folder" => $widget->getFolderId(), "locale" => $locale] var="assetsUrl"}
                        {else}
                            {url id="assets.overview.locale" parameters=["locale" => $locale] var="assetsUrl"}
                        {/if}
                        <div class="loading">
                            <span class="fa fa-spinner fa-pulse fa-2x"></span>
                        </div>
                        <iframe id="{$attributes.id}-iframe" data-src="{$assetsUrl}?embed=1" frameborder="0" width="100%" height="500"></iframe>
                    </div>
                    <div class="modal-footer">
                        <div class="row">
                            <div class="col-xs-7 col-md-8">
                                <div class="form-assets clearfix" data-field="{$attributes.id}" data-max="{$maximum}">
                                </div>
                                {if $maximum != 999}
                                <small class="text-muted pull-left m-r-2">
                                    {translate n=$maximum key="label.assets.maximum"}
                                </small>
                                {/if}
                            </div>
                            <div class="col-xs-5 col-md-4 pull-xs-right">
                                <button type="button" class="btn btn-primary form-assets-done">
                                    {translate key="button.select"}
                                </button>
                                <button type="button" class="btn btn-link" data-dismiss="modal">
                                    {translate key="button.cancel"}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}
{/function}

{function name="formWidgetOption" form=null row=null part=null showLabel=true}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {if $widget->isMultiple()}
            {$type = "checkbox"}
        {else}
            {$type = "radio"}
        {/if}

        {$isDisabled = $row->isDisabled()}

        {$attributes = $widget->getAttributes()}
        {if isset($attributes.class)}
            {$attributes.class = "`$attributes.class` form-check-input"}
        {else}
            {$attributes.class = 'form-check-input'}
        {/if}

        {$value = $widget->getValue()}
        {$options = $widget->getOptions()}
        {if $part !== null}
            {if isset($options.$part)}
            <input type="{$type}"
                   name="{$widget->getName()}{if $type == 'checkbox'}[{$part}]{/if}"
                   value="{$part}"
                   {if (!is_array($value) && strcmp($value, $part) == 0) || (is_array($value) && isset($value[$part]))}checked="checked"{/if}
                   {foreach $attributes as $name => $attribute}
                       {if $name == 'id'}
                            {$attribute = "`$attribute`-`$part`"}
                       {/if}
                       {$name}="{$attribute|escape}"
                   {/foreach}
             />
             {/if}
        {else}
            {if is_array($options)}
                {foreach $options as $option => $label}
                    <div class="form-check {if $isDisabled} disabled{/if}">
                        <label class="form-check-label">
                            <input type="{$type}"
                                   name="{$widget->getName()}{if $part !== null}[{$part}]{elseif $type == 'checkbox'}[]{/if}"
                                   value="{$option}"
                                   {if (!is_array($value) && strcmp($value, $option) == 0) || (is_array($value) && isset($value[$option]))}checked="checked"{/if}
                                   {foreach $attributes as $name => $attribute}
                                       {if $name == 'id'}
                                            {$attribute = "`$attribute`-`$option`"}
                                       {/if}
                                       {$name}="{$attribute|escape}"
                                   {/foreach}
                             />
                            {$label}
                        </label>
                    </div>
                {/foreach}
            {else}
                <div class="form-check {if $isDisabled} disabled{/if}">
                    <label class="form-check-label">
                        <input type="checkbox" name="{$widget->getName()}" value="1"{if $value} checked="checked"{/if}
                            {foreach $attributes as $name => $attribute}
                                {$name}="{$attribute|escape}"
                            {/foreach}
                        />
                        {if $showLabel}
                            {$row->getDescription()}
                        {/if}
                    </label>
                </div>
            {/if}
        {/if}
    {/if}
{/function}

{function name="formWidgetSelect" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {$widget = $row->getWidget()}
    {if $widget}
        {$attributes = $widget->getAttributes()}
        {if isset($attributes.class)}
            {$attributes.class = "`$attributes.class` form-control"}
        {else}
            {$attributes.class = 'form-control'}
        {/if}

        {$value = $widget->getValue()}
        {$options = $widget->getOptions()}

        {if $options|@count > 25}
            {$attributes.class = "`$attributes.class` form-selectize"}
        {elseif !$widget->isMultiple()}
            {$attributes.class = "`$attributes.class` custom-select"}
        {/if}

        {$validators = $row->getValidators()}
        {if $validators}
            {parsleyAttributes type="collection" attributes=$attributes validators=$validators var="attributes"}
        {/if}

        {if $row->getOption('order')}
            {$attributes['data-order'] = 'true'}
        {/if}

        {$value = $widget->getValue()}

        <select name="{$widget->getName()}{if $part !== null}[{$part}]{elseif $widget->isMultiple()}[]{/if}"
           {if $widget->isMultiple()} multiple="multiple"{/if}
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         >


        {* Print selected items first *}
        {if !is_array($value) && isset($value)}
            {if !is_object($value) && isset($options.$value)}
                <option value="{$value|escape}" selected="selected">{$options[$value]}</option>
            {/if}
        {else}
            {foreach $value as $option}
                {if $option|array_key_exists:$options}
                    <option value="{$option|escape}" selected="selected">{$options[$option]}</option>
                {/if}
            {/foreach}
        {/if}

        {* Print other items *}
        {foreach $options as $option => $label}
            {if !isset($value) || (!is_array($value) && !strcmp($option, $value) == 0) || (is_array($value) && !isset($value[$option]))}
                {if is_array($label)}
                    <optgroup label="{$option|escape}">
                        {foreach $label as $o => $l}
                            <option value="{$o|escape}"{if (!is_array($value) && strcmp($o, $value) == 0) || (is_array($value) && isset($value[$o]))} selected="selected"{/if}>{$l}</option>
                        {/foreach}
                    </optgroup>
                {else}
                    <option value="{$option|escape}">{$label}</option>
                {/if}
            {/if}
        {/foreach}
         </select>
    {/if}
{/function}

{*
    Renders a component control of the form
*}
{function name="formWidgetComponent" form=null row=null class=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {if $row}
        {if $row->getType() == 'component'}
            {$component = $row->getComponent()}
            {$attributes = $row->getWidget()->getAttributes()}

            {if get_class($component) == "ride\\web\\base\\form\\DateTimeComponent"}
                {if $class}
                    {$class = "`$class` col-sm-4"}
                {else}
                    {$class = "col-sm-4"}
                {/if}

                {if isset($attributes.class)}
                    {$attributes.class = "`$attributes.class` row"}
                {else}
                    {$attributes.class = 'row'}
                {/if}
            {/if}
        <div
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
        >
            {call formRows form=$form rows=$row->getRows() rowClass=$class}
        </div>
        {else}
            <span class="error">No component row provided</span>
        {/if}
    {else}
        <span class="error">No row provided</span>
    {/if}
{/function}

{*
    Renders a collection control of the form
*}
{function name="formWidgetCollection" form=null row=null}
    {$attributes = $row->getOption('attributes')}
    {if isset($attributes.class)}
        {$attributes.class = "`$attributes.class` collection-control-group"}
    {else}
        {$attributes.class = 'collection-control-group'}
    {/if}

    {$validators = $row->getValidators()}
    {if $validators}
        {parsleyAttributes type="collection" attributes=$attributes validators=$validators var="attributes"}
    {/if}

    <div
       {foreach $attributes as $name => $attribute}
           {$name}="{$attribute|escape}"
       {/foreach}
     >
        {$widget = $row->getWidget()}
        {if $widget}
            {$values = $widget->getValue()}
            {foreach $values as $key => $value}
                {call formCollectionPrototype form=$form row=$row part=$key}
            {/foreach}
        {else}
            {$rows = $row->getRows()}
            {foreach $rows as $key => $r}
                {if $key !== '%prototype%'}
                    {call formCollectionPrototype form=$form row=$row part=$key}
                {/if}
            {/foreach}
        {/if}
    </div>

    {if !$row->getOption('disable_add')}
    <a href="#" class="btn btn-secondary prototype-add{if $row->isDisabled() || $row->isReadOnly()} disabled{/if}">
        <span class="fa fa-plus"></span>
        {translate key="button.add"}
    </a>
    {/if}
{/function}

{*
    Renders a single collection control of the form
*}
{function name="formCollectionPrototype" form=null row=null part=null}
    {if is_string($row) && $form}
        {$row = $form->getRow($row)}
    {/if}

    {if $row}
    <div class="collection-control clearfix card">
        <div class="card-header">
        <div class="row">
            <div class="col-xs-6">
        {if $row->getOption('order')}
                <span class="fa fa-arrows-v text-muted order-handle"></span>
        {/if}
            </div>
            <div class="col-xs-6">
            {if !$row->getOption('disable_remove')}
                <a href="#" title="{translate key="button.remove"}" class="btn btn-secondary btn-sm pull-right prototype-remove{if $row->isDisabled() || $row->isReadOnly()} disabled{/if}">
                    <span class="fa fa-remove"></span>
                </a>
            {/if}
            </div>
        </div>
       </div>
        <div class="card-block">
        {$widget = $row->getWidget()}
        {if $widget}
            {call formWidget form=$form row=$row part=$part type=$widget->getType()}
        {else}
            {call formRow form=$form row=$row->getRow($part)}
        {/if}
        </div>
    </div>
    {else}
        <span class="error">No row provided</span>
    {/if}
{/function}

{function name="formInput" type=null widget=null part=null validators=null errors=null omitValue=false}
    {$attributes = $widget->getAttributes()}
    {if isset($attributes.class)}
        {$attributes.class = "`$attributes.class` form-control"}
    {else}
        {$attributes.class = 'form-control'}
    {/if}

    {if $errors}
        {$attributes.class = "`$attributes.class` form-control-danger"}
    {/if}

    {if $type == "date"}
        {$attributes.class = "`$attributes.class` js-date"}
    {/if}

    {if $validators}
        {parsleyAttributes attributes=$attributes validators=$validators var="attributes" type=$type}
    {/if}

    {$value = $widget->getValue($part)}
    {if is_array($value)}
        {foreach $value as $part => $val}
        <input type="{$type}"
               name="{$widget->getName()}{if $widget->isMultiple() || $part !== null}[{$part}]{/if}"
           {if !$omitValue}
               value="{$val|escape}"
           {/if}
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         />
         {/foreach}
    {else}
        <input type="{$type}"
               name="{$widget->getName()}{if $widget->isMultiple() || $part !== null}[{$part}]{/if}"
           {if !$omitValue}
               value="{$value|escape}"
           {/if}
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
         />
    {/if}
{/function}

{function name="formTextarea" widget=null part=null validators=null errors=null}
    {$attributes = $widget->getAttributes()}
    {if isset($attributes.class)}
        {$attributes.class = "`$attributes.class` form-control"}
    {else}
        {$attributes.class = 'form-control'}
    {/if}

    {if $validators}
        {parsleyAttributes attributes=$attributes validators=$validators var="attributes"}
    {/if}

    {$value = $widget->getValue($part)}
    {if is_array($value)}
        {foreach $value as $part => $val}
            <textarea name="{$widget->getName()}{if $widget->isMultiple() || $part !== null}[{$part}]{/if}"
               {foreach $attributes as $name => $attribute}
                   {$name}="{$attribute|escape}"
               {/foreach}
            >{$val|escape}</textarea>
         {/foreach}
    {else}
        <textarea name="{$widget->getName()}{if $widget->isMultiple() || $part !== null}[{$part}]{/if}"
           {foreach $attributes as $name => $attribute}
               {$name}="{$attribute|escape}"
           {/foreach}
        >{$widget->getValue($part)|escape}</textarea>
    {/if}
{/function}

{function name="formFile" widget=null part=null validators=null errors=null preview=null}
    {$attributes = $widget->getAttributes()}
    {if isset($attributes.class)}
        {$attributes.class = "`$attributes.class` form-control"}
    {else}
        {$attributes.class = ' form-control'}
    {/if}
    {* {$attributes.class = "`$attributes.class` custom-file-input"} *}

    {$value = $widget->getValue($part)}

    {if $value}
    <input type="hidden"
           name="{$widget->getName()}{if $part !== null}[{$part}]{/if}"
           value="{$value}" />
    {/if}
    <input type="file"
           name="{$widget->getName()}{if $part !== null}[{$part}]{/if}"
       {foreach $attributes as $name => $attribute}
           {$name}="{$attribute|escape}"
       {/foreach}
     />
     {* <span class="custom-file-control"></span> *}

    {if $value}
    <div class="form-text text-muted m-t-1">
        {if $preview == 'image'}
            <img src="{image src=$value transformation="crop" width=100 height=100}" title="{$value}" />
        {else}
            {$value}
        {/if}
        <a href="#" class="btn-file-delete" data-message="{translate key="label.confirm.file.delete"}">
            <span class="fa fa-remove"></span>
            {translate key="button.delete"}
        </a>
    </div>
    {/if}
{/function}

{*
    Renders the form actions, if a referer is passed, a cancel button will be presented
*}
{function name="formActions" referer=null submit='button.save'}
    <div class="form-group form-actions">
        <hr>
        <div class="loading">
            <span class="fa fa-spinner fa-pulse fa-2x"></span>
        </div>

        <button type="submit" class="btn btn-primary">{$submit|translate}</button>
        {if $referer}
            <a href="{$referer}" class="btn">{'button.cancel'|translate}</a>
        {/if}
        <hr>
    </div>
{/function}
