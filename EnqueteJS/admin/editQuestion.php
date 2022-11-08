<?php 

if (!isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv");</script>';
}

$mode_edition = 0;

if (isset($_GET['edit'])) {
    $mode_edition = 1;
    $idquestion = $_GET['edit'];
    $question = $bdd->prepare("SELECT idquestion, enonce FROM questions WHERE idquestion = :idquestion");
    $question->bindValue(':idquestion', $idquestion, PDO::PARAM_INT);
    $question->execute();
    if ($question->rowCount() == 1) {
        $question = $question->fetch();
    }
} else {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
}

if (isset($_POST['Retour'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
}

if (isset($_POST['Modifier'])) {
    $idquestion = $_GET['edit'];
    $enonce = $_POST['enonce'];
    if ($enonce !== "") {
        $exist = $bdd->prepare("SELECT enonce FROM questions WHERE enonce = :enonce");
        $exist->bindValue(':enonce', $enonce, PDO::PARAM_STR);
        $exist->execute();
        $exist = $exist->fetch();
        if (!$exist) {
            $update = $bdd->prepare("UPDATE questions SET enonce = :enonce WHERE idquestion = :idquestion");
            $update->bindValue(':enonce', $enonce, PDO::PARAM_STR);
            $update->bindValue(':idquestion', $idquestion, PDO::PARAM_INT);
            $update->execute();
            echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
        } else {
            Alerts::setAlert("Cette question existe déjà.", "danger");
        }
    } else {
        Alerts::setAlert("Veuillez saisir une question.");
    }
}

?>
<body class="bg-dark">

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <a href="profil" class="btn btn-lg btn-primary me-2">Profil</a>
            <a href="deconnexion" class="btn btn-lg btn-danger">Déconnexion</a>
        </div>
    </div>
</div>

<?= Alerts::getAlert(); ?>

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <div class="card">
                <div class="card-header">
                    <h3 class="text-center">Modification d'une question</h3>
                </div>
                <form method="post" action="">
                    <div class="card-body">
                        <div class="mb-3">
                            <input type="text" name="enonce" class="form-control" <?php if ($mode_edition == 1) { ?> value="<?= $question['enonce']; ?>" <?php } ?>>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row d-flex justify-content-center">
                            <div class="col-6">
                                <button type="submit" name="Retour" class="btn btn-secondary w-100">Retour</button>
                            </div>
                            <div class="col-6">
                                <button type="submit" name="Modifier" class="btn btn-primary w-100">Modifier</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>