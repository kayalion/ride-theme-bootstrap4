{extends file="base/index"}

{block name="head_title" prepend}{$title} | {/block}

{block name="taskbar_panels" append}
    {if $localizeUrl}
        {call taskbarPanelLocales url=$localizeUrl locale=$locale locales=$locales}
    {/if}
{/block}

{block name="content_title"}
    <nav class="breadcrumb">
        <a class="breadcrumb-item" href="{url id="admin"}">
            {translate key="title.admin.home"}
        </a>
        <a class="breadcrumb-item" href="{url id="content"}">
            {translate key="title.content"}
        </a>
        <a class="breadcrumb-item" href="{url id="system.orm.scaffold.index" parameters=["model" => $meta->getName(), "locale" => $locale]}">
            {translate key=$meta->getOption('scaffold.title')}
        </a>
        <a class="breadcrumb-item" href="{url id="calendar.event.detail" parameters=["locale" => $locale, "id" => $entry->getId()]}">
            {$entry->getName()}
        </a>
    </nav>

    <div class="page-header mb-3">
        <h1>{$title}</h1>
    </div>
{/block}

{block name="content" append}
    {include file="helper/form.prototype"}

    <form id="{$form->getId()}" action="{$app.url.request}" method="POST" role="form" enctype="multipart/form-data">
        {$allowDay = $form->getRow('date')->hasRow('isDay')}
        {$allowPeriod = $form->getRow('date')->hasRow('isPeriod')}
        {$allowRepeat = $form->getRow('date')->hasRow('isRepeat')}

        <div class="form-group row-date">
            <div>
                <label for="form-event-dateStart">
                    {translate key="label.date"}
                </label>
            </div>
            {call formWidget form=$form row=$form->getRow('date')->getRow('dateStart')}
            {call formWidget form=$form row=$form->getRow('date')->getRow('timeStart')}
            <span class="until">&nbsp;{"label.until"|translate|lower}&nbsp;</span>
        {if $allowPeriod}
            {call formWidget form=$form row=$form->getRow('date')->getRow('dateStop')}
        {/if}
            {call formWidget form=$form row=$form->getRow('date')->getRow('timeStop')}
        </div>
        <div class="form-group">
            {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('dateStart')}
            {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('timeStart')}
        {if $allowPeriod}
            {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('dateStop')}
        {/if}
            {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('timeStop')}
        </div>
        {if $allowDay || $allowPeriod || $allowRepeat}
        <div class="form-group row-date">
            {if $allowDay}
                {call formWidget form=$form row=$form->getRow('date')->getRow('isDay')}
                {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('isDay')}
            {/if}
            {if $allowPeriod}
                {call formWidget form=$form row=$form->getRow('date')->getRow('isPeriod')}
                {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('isPeriod')}
            {/if}
            {if $allowRepeat}
                {call formWidget form=$form row=$form->getRow('date')->getRow('isRepeat')}
                {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('isRepeat')}
            {/if}
        </div>
        {/if}

        {if $allowRepeat}
        <div class="repeater">
            <div class="form-group row-step clearfix">
                <div>
                    <label for="form-event-step">
                        {translate key="label.mode"}
                    </label>
                </div>
                {call formWidget form=$form row=$form->getRow('date')->getRow('mode')}
                &nbsp;{"label.event.every"|translate|lower}&nbsp;
                {call formWidget form=$form row=$form->getRow('date')->getRow('step')}
                <span class="step step-daily">{"label.days"|translate|lower}</span>
                <span class="step step-weekly">{"label.weeks"|translate|lower}</span>
                <span class="step step-monthly">{"label.months"|translate|lower}</span>
                <span class="step step-yearly">{"label.years"|translate|lower}</span>
            </div>

            {call formRow form=$form row=$form->getRow('date')->getRow('weekly')}
            {call formRow form=$form row=$form->getRow('date')->getRow('monthly')}

            <div class="form-group row-until clearfix">
                <label for="form-event-performance-until">
                    {translate key="label.until"}
                </label>
                <div class="form-check">
                    <label class="form-check-label">
                        {call formWidget form=$form row=$form->getRow('date')->getRow('until') part="date"}
                        {"label.date"|translate}&nbsp;
                    </label>
                    {call formWidget form=$form row=$form->getRow('date')->getRow('dateUntil')}
                    {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('dateUntil')}
                </div>
                <div class="form-check">
                    <label class="form-check-label" for="date[occurences]">
                        {call formWidget form=$form row=$form->getRow('date')->getRow('until') part="occurences"}
                        {call formWidget form=$form row=$form->getRow('date')->getRow('occurences')}
                        &nbsp;{"label.occurences"|translate|lower}
                    </label>
                    {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('occurences')}
                </div>
                {call formWidgetErrors form=$form row=$form->getRow('date')->getRow('until')}
            </div>
        </div>
        {/if}

        <div class="edit-confirm hidden-xs-up">
            {call formRow form=$form row="editMode"}
            {call formRow form=$form row="ignoreEdited"}
        </div>

        {call formRows form=$form}
        {call formActions referer=$referer}
    </form>
{/block}

{block name="styles" append}
    {style src="bootstrap4/css/bootstrap-datepicker.css"}
    {style src="bootstrap4/css/modules/calendar.css" media="all"}
{/block}

{block name="scripts" append}
    {$locale = substr($app.locale, 0, 2)}
    {script src="bootstrap4/js/bootstrap-datepicker.js"}
    {script src="bootstrap4/js/parsley.js"}
    {if $locale != 'en'}
        {script src="bootstrap4/js/locales/parsley-`$locale`.js"}
    {/if}
    {script src="bootstrap4/js/form.js"}
    {script src="bootstrap4/js/modules/calendar.js"}
{/block}
