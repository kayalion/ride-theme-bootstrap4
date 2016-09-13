<?php

namespace ride\selenium;

use \PHPUnit_Extensions_Selenium2TestCase;

class TestUserTest extends PHPUnit_Extensions_Selenium2TestCase {

    protected function setUp() {
        $this->setBrowser("firefox");
        $this->setBrowserUrl("http://ridboo.local.statik.be");
    }

    public function testLogin() {
        $this->url("http://ridboo.local.statik.be/");

        // open anonymous user menu
        $element = $this->byCssSelector("#taskbarDropdownRight");
        $this->assertEquals($element->text(), 'Anonymous user');
        $element->click();

        // click login
        $element = $this->byXPath("id('collapsingNavbar')/ul[2]/li/ul/li/a");
        $this->assertEquals($element->text(), 'Login');
        $element->click();

        // wait for page load
        $this->timeouts()->implicitWait(500);

        // fill in and submit form with test credentials
        $form = $this->byId('form-login');
        $form->byName('username')->value('test');
        $form->byName('password')->value('test');
        $form->byCssSelector('button.btn-primary')->click();

        // wait for page load
        $this->timeouts()->implicitWait(500);

        // assert user
        $element = $this->byCssSelector("#taskbarDropdownRight");
        $this->assertEquals($element->text(), 'test');
    }

    public function testLoginWithEmptyCredentials() {
        $this->url("http://ridboo.local.statik.be/login");

        // fill in and submit form with test credentials
        $form = $this->byId('form-login');
        $form->byName('username')->value('');
        $form->byName('password')->value('');
        $form->byCssSelector('button.btn-primary')->click();

        // assert errors
        $error = $this->byXPath("id('parsley-id-5')/li");
        $this->assertEquals($error->text(), 'This value is required.');

        $error = $this->byXPath("id('parsley-id-7')/li");
        $this->assertEquals($error->text(), 'This value is required.');
    }

    public function testLoginWithInvalidCredentials() {
        $this->url("http://ridboo.local.statik.be/login");

        // fill in and submit form with test credentials
        $form = $this->byId('form-login');
        $form->byName('username')->value('invalid');
        $form->byName('password')->value('invalid');
        $form->byCssSelector('button.btn-primary')->click();

        // wait for page load
        $this->timeouts()->implicitWait(500);

        // assert error
        $error = $this->byXPath("//form[@id='form-login']/div/ul/li");
        $this->assertEquals($error->text(), "Your credentials are invalid.");
    }

    /**
     * @depends testLogin
     */
    public function testLogout() {
        $this->testLogin();
        // $this->url("http://ridboo.local.statik.be/");

        // open test user menu
        $element = $this->byCssSelector("#taskbarDropdownRight");
        $this->assertEquals($element->text(), 'test');
        $element->click();

        // click logout
        $element = $this->byXPath("id('collapsingNavbar')/ul[2]/li/ul/li[5]/a");
        $this->assertEquals($element->text(), 'Logout');
        $element->click();

        // wait for page load
        $this->timeouts()->implicitWait(500); //1 seconds

        // check user
        $element = $this->byCssSelector("#taskbarDropdownRight");
        $this->assertEquals($element->text(), 'Anonymous user');
    }

}
