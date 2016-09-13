<?php

namespace ride\theme\bootstrap\controller;

use ride\web\base\controller\AbstractController;

class IndexController extends AbstractController {

    public function indexAction() {
        $this->setTemplateView('base/dashboard.admin');
    }

    public function securityAction() {
        $this->setTemplateView('base/dashboard.security');
    }

    public function systemAction() {
        $this->setTemplateView('base/dashboard.system');
    }

    public function documentationAction() {
        $this->setTemplateView('base/dashboard.documentation');
    }

    public function contentAction() {
        $this->setTemplateView('base/dashboard.content');
    }

}
