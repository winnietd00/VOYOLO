<?php

require_once("modele/modele.class.php");

if (isset($_POST['Valider'])) {
    $sexe = $_POST['sexe'];
    $nom = $_POST['nom'];
    $prenom = $_POST['prenom'];
    $age = $_POST['age'];
    $datenaissance = $_POST['datenaissance'];
    $email = $_POST['email'];
    $tel = $_POST['tel'];
    $adresse = $_POST['adresse'];
    $type = $_POST['type'];
    if ($nom !== "" && $prenom !== "" && $email !== "" && $tel !== "" && $adresse != "") {
        if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
            if (preg_match("#^[a-zA-Z0-9._-]+@[a-z]+\.[a-zA-Z]{2,6}$#", $email)) {
                $verifEmail = checkEmail($email);
                if (!$verifEmail) {
                    $telLength = strlen($tel);
                    if ($telLength == 10) {
                        $verifTel = checkTel($tel);
                        if (!$verifTel) {
                            if ($datenaissance < date('Y-m-d')) {
                                $insertion = insert($sexe, $nom, $prenom, $age, $datenaissance, $email, $tel, $adresse, $type);
                                $nom_majuscule = $bdd->prepare("UPDATE enquetes SET nom = UPPER(nom)");
                                $nom_majuscule->execute(array($nom));
                                $prenom_majuscule = $bdd->prepare("UPDATE enquetes SET prenom = CONCAT(UCASE(LEFT(prenom,1)), LCASE(SUBSTRING(prenom,2)))");
                                $prenom_majuscule->execute(array($prenom));
                                echo '<script language="javascript">document.location.replace("questions");</script>';
                            } else {
                                Alerts::setAlert("La date de naissance ne peut pas être supérieur à la date du jour.");
                            }
                        } else {
                            Alerts::setAlert("Le numéro de téléphone est déjà utilisé.", "danger");
                        }
                    } else {
                        Alerts::setAlert("Le numéro de téléphone doit contenir 10 chiffres.");
                    }
                } else {
                    Alerts::setAlert("Adresse email déjà utilisée.", "danger");
                }
            } else {
                Alerts::setAlert("Format de l'adresse email invalide.");
            }
        } else {
            Alerts::setAlert("Format de l'adresse email invalide.");
        }
    } else {
        Alerts::setAlert("Veuillez remplir tous les champs.");
    }
}

$questionsParPage = 1;

$questionsTotales = $bdd->query("SELECT idquestion FROM questions")->rowCount();

$pagesTotales = ceil($questionsTotales / $questionsParPage);

if (isset($_GET['q']) and !empty($_GET['q']) and $_GET['q'] > 0) {
    $_GET['q'] = intval($_GET['q']);
    $pageCourante = $_GET['q'];
} else {
    $pageCourante = 1;
}

$pagePrecedente = $pageCourante - 1;

$pageSuivante = $pageCourante + 1;

$depart = ($pageCourante-1) * $questionsParPage;

function selectAllQuestions($depart, $questionsParPage) {
    global $bdd;
    $requete = "SELECT * FROM questions ORDER BY idquestion LIMIT :depart, :questionsParPage";
    $select = $bdd->prepare($requete);
    $select->bindValue(':depart', $depart, PDO::PARAM_INT);
    $select->bindValue(':questionsParPage', $questionsParPage, PDO::PARAM_INT);
    $select->execute();
    return $select->fetchAll();
}

$lesQuestions = selectAllQuestions($depart, $questionsParPage);

$question1 = getQuestion(1);
$question2 = getQuestion(2);
$question3 = getQuestion(3);
$question4 = getQuestion(4);
$question5 = getQuestion(5);
$question6 = getQuestion(6);
$question7 = getQuestion(7);
$question8 = getQuestion(8);
$question9 = getQuestion(9);
$question10 = getQuestion(10);
$question11 = getQuestion(11);
$question12 = getQuestion(12);
$question13 = getQuestion(13);
$question14 = getQuestion(14);
$question15 = getQuestion(15);
$question16 = getQuestion(16);

require_once("vue/questions.php");

?>