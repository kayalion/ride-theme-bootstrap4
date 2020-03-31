{$messageTypes = [
    "error" => "danger",
    "warning" => "warning",
    "success" => "success",
    "info" => "info",
    "information" => "info",
]}
{foreach $messageTypes as $messageType => $messageClass}
    {$typeMessages = $messages->getByType($messageType)}
    {if $typeMessages}
        <div class="alert alert-{$messageClass} alert-dismissible" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        {if $typeMessages|count == 1}
            {$message = $typeMessages|array_pop}
            {$message->getMessage()}
        {else}
            <ul>
            {foreach $typeMessages as $message}
                <li>{$message->getMessage()}</li>
            {/foreach}
            </ul>
        {/if}
        </div>
    {/if}
{/foreach}
