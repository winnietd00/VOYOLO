<?php 

function checkEmail($email) {
    global $bdd;
    $check = $bdd->prepare("SELECT email FROM enquetes WHERE email = :email");
    $check->bindParam(':email', $email, PDO::PARAM_STR);
    $check->execute();
    return $check->fetchAll(PDO::FETCH_OBJ);
}

function checkTel($tel) {
    global $bdd;
    $check = $bdd->prepare("SELECT tel FROM enquetes WHERE tel = :tel");
    $check->bindParam(':tel', $tel, PDO::PARAM_STR);
    $check->execute();
    return $check->fetchAll(PDO::FETCH_OBJ);
}

function insert($sexe, $nom, $prenom, $age, $datenaissance, $email, $tel, $adresse, $type) {
    global $bdd;
    $insertion = $bdd->prepare("INSERT INTO enquetes (sexe, nom, prenom, age, datenaissance, email, tel, adresse, type, score) VALUES (:sexe, :nom, :prenom, :age, :datenaissance, :email, :tel, :adresse, :type, '0')");
    $insertion->bindValue(':sexe', $sexe, PDO::PARAM_STR);
    $insertion->bindValue(':nom', $nom, PDO::PARAM_STR);
    $insertion->bindValue(':prenom', $prenom, PDO::PARAM_STR);
    $insertion->bindValue(':age', $age, PDO::PARAM_STR);
    $insertion->bindValue(':datenaissance', $datenaissance, PDO::PARAM_STR);
    $insertion->bindValue(':email', $email, PDO::PARAM_STR);
    $insertion->bindValue(':tel', $tel, PDO::PARAM_STR);
    $insertion->bindValue(':adresse', $adresse, PDO::PARAM_STR);
    $insertion->bindValue(':type', $type, PDO::PARAM_STR);
    return $insertion->execute();
}

function getQuestion($idquestion) {
    global $bdd;
    $select = $bdd->prepare("SELECT idquestion, enonce FROM questions WHERE idquestion = :idquestion");
    $select->bindValue(':idquestion', $idquestion, PDO::PARAM_INT);
    $select->execute();
    return $select->fetch();
}

?>