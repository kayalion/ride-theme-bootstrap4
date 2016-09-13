{extends file="api/index"}

{block name="title"}
    <h1>
        {translate key="title.api"}
        <small class="text-muted">{$shortName}</small>
    </h1>
{/block}

{block name="content_body" append}
    {$currentNamespace = $namespace}
    {$classDoc = $class->getDoc()}
    <div id="api">
        <div class="detail">
            <p class="namespace">{$namespace|replace:"/":"\\"}</p>
            <p>{$type} <strong>{$shortName}</strong></p>
            <p class="text-muted">{$classDoc->getDescription()}</p>
            {$classDoc->getLongDescription()}

            <h3 class="m-b-1">{translate key="title.hierarchy.class"}</h3>
            <ul class="hierarchy">
    {$margin = 0}
    {foreach $inheritance as $className => $methods}
                <li{if $methods@first} class="first"{/if} style="margin-left: {$margin}px;">
        {if $methods@last}
            {$className}
        {else}
            {apiType type=$className url=$urlClass namespace=$currentNamespace classes=$classes}
        {/if}
                </li>
        {$margin = $margin + 20}
    {/foreach}
            </ul>

    {if $interfaces}
            <h3>{translate key="title.interfaces.implemented"}</h3>
            <ul>
        {foreach $interfaces as $interface}
                <li>{apiType type=$interface url=$urlClass namespace=$currentNamespace classes=$classes}</li>
        {/foreach}
            </ul>
    {/if}

    {if $classDoc->isDeprecated()}
    <div class="deprecated">
        <h5>{translate key="title.deprecated"}</h5>
        {translate key="api.label.deprecated.class" var="defaultDeprecatedMessage"}
        {$classDoc->getDeprecatedMessage()|default:$defaultDeprecatedMessage}
    </div>
    {/if}

    {include file="api/helper/todo" todos=$classDoc->getTodos()}

    {if $inheritance}
            <h3 class="m-b-1">{translate key="title.overview.methods"}</h3>
        {if $inheritance.$name}
            <ul class="methods unstyled">
            {foreach $inheritance.$name as $method}
                <li>
                    {assign var="methodDoc" value=$method->getDoc()}

                    <code>
                        {$method->getTypeString()}
                        <a href="#method{$method->getName()}">{$method->getName()}</a>{apiMethodParameters method=$method url=$urlClass namespace=$currentNamespace classes=$classes}
                    </code>

                    <br />
                    <span class="text-muted">
                        {$methodDoc->getDescription()}
                    </span>
                </li>
            {/foreach}
            </ul>
        {/if}

        {foreach $inheritance as $className => $methods}
            {if $methods && $className != $name}
            <div class="inheritedMethods">
                {apiType type=$className url=$urlClass html="classLink"}
                <p>{translate key="label.methods.inherited" class=$classLink}: <br />
                {foreach $methods as $method}
                    {if !$method->isPrivate()}
                        {apiType type=$className url=$urlClass method=$method->getName()}{if !$method@last}, {/if}
                    {/if}
                {/foreach}
                </p>
            </div>
            {/if}
        {/foreach}
            <p class="top"><a href="#">{translate key="button.top"}</a></p>
    {/if}


    {if $properties}
            <h3 class="m-b-1">{translate key="title.properties"}</h3>
            <ul class="properties">
        {foreach $properties as $property}
            {$doc = $property->getDoc()}
            {$var = $doc->getVar()}
                <li>
                    <code>
                        {$property->getTypeString()}
                        {if $var}
                            {apiType type=$var url=$urlClass namespace=$currentNamespace classes=$classes}
                        {/if}
                        ${$property->getName()}
                    </code>

                    <br />
                    <span class="text-muted">
                        {$doc->getDescription()}
                    </span>

                    {$doc->getLongDescription()}

                    {if $doc->isDeprecated()}
                    <div class="deprecated">
                        <h5>{translate key="title.deprecated"}</h5>
                        {translate key="label.deprecated.property" var="defaultDeprecatedMessage"}
                        {$doc->getDeprecatedMessage()|default:$defaultDeprecatedMessage}
                    </div>
                    {/if}

                    {include file="api/helper/todo" todos=$doc->getTodos()}
                </li>
        {/foreach}
            </ul>
            <p class="top"><a href="#">{translate key="button.top"}</a></p>
    {/if}

    {if $constants}
            <h3>{translate key="title.constants"}</h3>
            <ul>
        {foreach $constants as $constant => $value}
                <li><code>{$constant} = '{$value|replace:' ':'&nbsp;'}'</code></li>
        {/foreach}
            </ul>
            <p class="top"><a href="#">{translate key="button.top"}</a></p>
    {/if}

    {if $inheritance.$name}
            <h3 class="m-b-1">{translate key="title.methods"}</h3>
        {foreach $inheritance.$name as $method}
            {assign var="methodDoc" value=$method->getDoc()}
            <a name="method{$method->getName()}"></a>

            <h4>{$method->getName()}</h4>

            {if $methodDoc->isDeprecated()}
            <div class="deprecated">
                <h5>{translate key="title.deprecated"}</h5>
                {translate key="label.deprecated.method" var="defaultDeprecatedMessage"}
                {$methodDoc->getDeprecatedMessage()|default:$defaultDeprecatedMessage}
            </div>
            {/if}

            <p>
                <code>
                {$method->getTypeString()}
                <a href="#method{$method->getName()}">{$method->getName()}</a>{apiMethodParameters method=$method url=$urlClass namespace=$currentNamespace classes=$classes}
                </code>
            </p>

            {if $method->getCode()}
            <p class="source-link">
                <a href="#" class="source-toggle">{translate key="button.toggle.source"}</a>
            </p>
            <div class="source">
                <pre class="p-a-1 prettyprint">{$method->getCode()|escape}</pre>
            </div>
            {/if}

            <p><span class="description">{$methodDoc->getDescription()}</span></p>
            {$methodDoc->getLongDescription()}

            {assign var="see" value=$methodDoc->getSee()}
            {if $see}
                <p><span class="description">{translate key="label.api.see"} {apiType type=$see url=$urlClass namespace=$currentNamespace classes=$classes}</span></p>
            {/if}

            {assign var="interface" value=$class->getMethodInterface($method->getName())}
            {if $interface}
                {apiType type=$interface url=$urlClass html="interfaceLink"}
                {apiType type=$interface method=$method->getName() url=$urlClass html="methodLink"}
                <p>{translate key="label.api.specified" interface=$interfaceLink method=$methodLink}</p>
            {/if}

            {assign var="parameters" value=$method->getParameters()}
            {if $parameters}
            <h5>{translate key="title.parameters"}</h5>
            <ul class="parameters">
                {foreach $parameters as $parameter}
                <li>
                    {assign var="parameterName" value=$parameter->getName()}
                    {assign var="parameterName" value="$`$parameterName`"}
                    {assign var="parameterDoc" value=$methodDoc->getParameter($parameterName)}
                    {assign var="type" value=$parameterDoc->getType()}
                    <code>
                    {if $type}
                        {apiType type=$type url=$urlClass namespace=$currentNamespace classes=$classes}
                    {/if}

                    {$parameterName}
                    </code>
                    <br />
                    <span class="text-muted">{$parameterDoc->getDescription()}</span>
                </li>
                {/foreach}
            </ul>
            {/if}

            {assign var="return" value=$methodDoc->getReturn()}
            {if $return}
                <h5>{translate key="title.return"}</h5>
                <p>
                    {apiType type=$return->getType() url=$urlClass namespace=$currentNamespace classes=$classes}
                    <br />
                    <span class="description">{$return->getDescription()}</span>
                </p>
            {/if}

            {assign var="exceptions" value=$methodDoc->getExceptions()}
            {if $exceptions}
            <h5>{translate key="title.exceptions"}</h5>
            <ul class="exceptions">
            {foreach $exceptions as $exception}
                <li>
                    {apiType type=$exception->getType() url=$urlClass namespace=$currentNamespace classes=$classes}
                    <br />
                    <span class="description">{$exception->getDescription()}</span>
                </li>
            {/foreach}
            </ul>
            {/if}

            {include file="api/helper/todo" todos=$methodDoc->getTodos()}

            <p class="top"><a href="#">{translate key="button.top"}</a></p>
        {/foreach}
    {/if}

        </div>
    </div>
{/block}

{block name="scripts" append}
    {script src="bootstrap4/js/jquery-scrollTo.js"}
    {script src="bootstrap4/js/modules/documentation-api.js"}
{/block}

{block scripts_app append}
    {script src="http://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?skin=desert"}
{/block}

