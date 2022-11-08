<?php 

if (!isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv");</script>';
}

$mode_edition = 0;

if (isset($_GET['edit'])) {
    $mode_edition = 1;
    $idu = $_GET['edit'];
    if (isset($_SESSION['idu']) || isset($_SESSION['email'])) {
        if ($idu == $_SESSION['idu']) {
            $admin = $bdd->prepare("SELECT idu, nom, prenom, email FROM users WHERE idu = :idu");
            $admin->bindValue(':idu', $idu, PDO::PARAM_INT);
            $admin->execute();
            if ($admin->rowCount() == 1) {
                $admin = $admin->fetch();
            }
        } else {
            echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
        }
    } else {
        echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
    }
} else {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
}

if (isset($_POST['Retour'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
}

if (isset($_POST['Modifier'])) {
    $idu = $_GET['edit'];
    $nom = $_POST['nom'];
    $prenom = $_POST['prenom'];
    $email = $_POST['email'];
    $mdp = sha1($_POST['mdp']);
    if ($nom !== "" && $prenom !== "" && $email !== "" && $mdp !== "") {
        $exist = $bdd->prepare("SELECT email FROM users WHERE email = :email");
        $exist->bindValue(':email', $email, PDO::PARAM_STR);
        $exist->execute();
        $exist = $exist->fetch();
        if (!$exist) {
            $update = $bdd->prepare("UPDATE users SET nom = :nom, prenom = :prenom, email = :email, mdp = :mdp WHERE idu = :idu");
            $update->bindValue(':nom', $nom, PDO::PARAM_STR);
            $update->bindValue(':prenom', $prenom, PDO::PARAM_STR);
            $update->bindValue(':email', $email, PDO::PARAM_STR);
            $update->bindValue(':mdp', $mdp, PDO::PARAM_STR);
            $update->bindValue(':idu', $idu, PDO::PARAM_INT);
            $update->execute();
            echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/deconnexion");</script>';
        } else {
            Alerts::setAlert("Cette adresse email existe déjà.", "danger");
        }
    } else {
        Alerts::setAlert("Veuillez remplir tous les champs.");
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
                    <h3 class="text-center">Modification de mon profil</h3>
                </div>
                <form method="post" action="">
                    <div class="card-body">
                        <div class="mb-3">
                            <input type="text" name="nom" class="form-control" <?php if ($mode_edition == 1) { ?> value="<?= $admin['nom']; ?>" <?php } ?>>
                        </div>
                        <div class="mb-3">
                            <input type="text" name="prenom" class="form-control" <?php if ($mode_edition == 1) { ?> value="<?= $admin['prenom']; ?>" <?php } ?>>
                        </div>
                        <div class="mb-3">
                            <input type="email" name="email" class="form-control" <?php if ($mode_edition == 1) { ?> value="<?= $admin['email']; ?>" <?php } ?>>
                        </div>
                        <div class="mb-3">
                            <input type="password" name="mdp" class="form-control">
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