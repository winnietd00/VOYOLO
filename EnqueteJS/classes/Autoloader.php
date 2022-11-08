<?php

class Autoloader {

    public static function register() {
        spl_autoload_register(array('Autoloader', 'load'));
    }

    public static function load($className) {
        if (file_exists("classes/".$className.".php")) {
            require_once("classes/".$className.".php");
        }
    }
    
}

?>