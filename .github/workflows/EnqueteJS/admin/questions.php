<?php

if (!isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv");</script>';
}

$lesQuestions = $bdd->query("SELECT idquestion, enonce FROM questions ORDER BY idquestion DESC");

// Ajout d'une question
if (isset($_POST['Ajouter'])) {
    $enonce = $_POST['enonce'];
    if ($enonce !== "") {
        $exist = $bdd->prepare("SELECT enonce FROM questions WHERE enonce = :enonce");
        $exist->bindValue(':enonce', $enonce, PDO::PARAM_STR);
        $exist->execute();
        $exist = $exist->fetch();
        if (!$exist) {
            $insert = $bdd->prepare("INSERT INTO questions (enonce) VALUES (:enonce)");
            $insert->bindValue(':enonce', $enonce, PDO::PARAM_STR);
            $insert->execute();
            echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
        } else {
            Alerts::setAlert("Cette question existe déjà.", "danger");
        }
    } else {
        Alerts::setAlert("Veuillez saisir une question.");
    }
}

// Suppression d'une question
if (isset($_GET['idquestion'])) {
    $idquestion = $_GET['idquestion'];
    $delete = $bdd->prepare("DELETE FROM questions WHERE idquestion = :idquestion");
    $delete->bindValue(':idquestion', $idquestion, PDO::PARAM_INT);
    $delete->execute();
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
}

// Suppression de toutes les questions
if (isset($_POST['Supprimer'])) {
    $delete = $bdd->prepare("DELETE FROM questions");
    $delete->execute();
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/questions");</script>';
}

?>
<body class="bg-dark">

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <a href="profil" class="btn btn-lg btn-primary me-2">Profil</a>
            <a href="admins" class="btn btn-lg btn-light me-2">Admins</a>
            <a href="deconnexion" class="btn btn-lg btn-danger">Déconnexion</a>
        </div>
    </div>
</div>

<?= Alerts::getAlert(); ?>

<div class="container mt-4 mb-5">
    <div class="row d-flex justify-content-center">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3>Liste des questions</h3>
                </div>
                <div class="card-body bg-secondary">
                    <table class="table table-dark">
                        <thead>
                            <tr>
                                <th scope="col">N°</th>
                                <th scope="col">Enonce</th>
                                <th scope="col">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <form method="post" action="">
                                <tr>
                                    <td></td>
                                    <td><input type="text" name="enonce" class="form-control"></td>
                                    <td><button type="submit" name="Ajouter" class="btn btn-success">Ajouter</button></td>
                                </tr>
                            </form>
                            <?php foreach ($lesQuestions as $uneQuestion) { ?>
                            <tr>
                                <th scope="row"><?= $uneQuestion['idquestion']; ?></th>
                                <td><?= $uneQuestion['enonce']; ?></td>
                                <td>
                                    <a href="editQuestion?edit=<?= $uneQuestion['idquestion']; ?>" class="btn btn-primary">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                        </svg>
                                    </a>
                                    <a href="questions?idquestion=<?= $uneQuestion['idquestion']; ?>" class="btn btn-danger" onclick="return(confirm('Voulez-vous supprimer cette question ?'))">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                                            <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                                        </svg>
                                    </a>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container mt-4 mb-5">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <form method="post" action="">
                <button type="submit" name="Supprimer" class="btn btn-lg btn-danger active" onclick="return(confirm('Voulez-vous vraiment supprimer toutes les questions ?'))">
                    Supprimer toutes les questions
                </button>
            </form>
        </div>
    </div>
</div>

</body>