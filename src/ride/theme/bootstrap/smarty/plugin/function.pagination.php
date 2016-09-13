<?php

use ride\library\html\Pagination;

function smarty_function_pagination($params, &$smarty) {
    $page = 0;
    $pages = null;
    $href = null;
    $onclick = null;
    $label = null;
    $class = null;

    foreach ($params as $k => $v) {
        switch ($k) {
            case 'label':
            case 'page':
            case 'pages':
            case 'href':
            case 'onclick':
            case 'class':
                $$k = $v;
                break;
        }
    }

    $pagination = new Pagination($pages, $page);
    $pagination->setHref($href);
    $pagination->setOnclick($onclick);
    if ($label) {
        $pagination->setLabel($label);
    }
    if ($class) {
        $pagination->setClass($class);
    }

    $anchors = $pagination->getAnchors();

    $html = '<nav><ul class="pagination">';
    foreach ($anchors as $anchor) {
        $anchor->addToClass('page-link');

        $class = '';
        if ($anchor->getLabel() == $page) {
            $class .= ' active';
        }

        $html .= '<li class="page-item' . $class . '">' . $anchor->getHtml() . '</li>';
    }
    $html .= '</ul></nav>';

    return $html;
}
