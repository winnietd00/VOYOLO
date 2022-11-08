<?php

require_once("modele/traiter.modele.php");

if (isset($_POST['Envoyer'])) {
    $f = fopen("donnees.txt", "a");
    $nom = $_COOKIE['nompers'];
    $prenom = $_COOKIE['prenompers'];
    $age = $_COOKIE['agepers'];
    $email = $_COOKIE['emailpers'];
    $type = $_COOKIE['typepers'];
    $score = $_COOKIE['scorepers'];
    fprintf($f, "%s ; %s ; %d ; %s ; %s", $nom, $prenom, $age, $email, $type);
    fclose($f);
}

$f = fopen("donnees.txt", "r");
$tabLabels = array();
while (!feof($f)) {
	$ligne = fgets($f, 4096);
	$tab = explode(";", $ligne);
	$tabLabels[] = $tab[2];
	/*
	for ($i=0; $i<count($tab); $i++) {
	 	echo $tab[$i]." -- ";
	}
	*/
} 
$label = "['".implode("','", $tabLabels)."']";
fclose($f);

$lesQuestions = selectAllQuestions();

require_once("vue/traiter.php");

?>