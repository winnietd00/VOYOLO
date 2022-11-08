<?php

/* Permet d'appeler les classes automatiquement */
require_once("classes/Autoloader.php");
Autoloader::register();

$session = new Session();

/* Permet de se connecter à la base de données */
require_once("fonctions/functions.php");
require_once("constants.php");
$bdd = connectBDD(HOSTNAME, DATABASE, USERNAME, PASSWORD);

/* Permet d'appeler les fonctions de la classe Helpers */
require_once("classes/Helpers.php");
$helpers = new Helpers();

if (!isset($_GET['page']) || $_GET['page'] == "") {
    $page = "controleur/accueil.controleur.php";
} else {
    if (isset($_GET['page']) && $_GET['page'] == "edsjsv") {
        $page = "admin/connexion.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/profil") {
        $page = "admin/profil.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/editProfil") {
        $page = "admin/editProfil.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/admins") {
        $page = "admin/admins.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/questions") {
        $page = "admin/questions.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/editQuestion") {
        $page = "admin/editQuestion.php";
    } else if (isset($_GET['page']) && $_GET['page'] == "edsjsv/deconnexion") {
        $page = "admin/deconnexion.php";
    } else if (file_exists("vue/".$_GET['page'].".php")) {
        $page = "controleur/".$_GET['page'].".controleur.php";
    } else {
        $page = "controleur/404.controleur.php";
    }
}

ob_start();
require_once($page);
$contenus = ob_get_contents();
ob_get_clean();

require_once("enquete.php");

?>