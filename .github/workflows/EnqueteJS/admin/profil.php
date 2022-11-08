<?php

if (!isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv");</script>';
}

if (isset($_GET['idu']) && isset($_GET['email'])) {
    $idu = $_GET['idu'];
    $email = $_GET['email'];
    $delete = $bdd->prepare("DELETE FROM users WHERE idu = :idu AND email = :email");
    $delete->bindValue(':idu', $idu, PDO::PARAM_INT);
    $delete->bindValue(':email', $email, PDO::PARAM_STR);
    $delete->execute();
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/deconnexion");</script>';
}

?>
<!-- <body style="background-image: url(assets/img/bg.jpg); background-position: center center; background-repeat: no-repeat; background-attachment: fixed; background-size: cover;"> -->
<body class="bg-dark">

<div class="container mt-5">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <div class="card">
                <div class="card-header bg-primary" style="border-radius: .25rem!important;">
                    <h2 class="text-center text-light">
                        Bienvenue sur votre profil <?= $_SESSION['prenom']; ?> <?= $_SESSION['nom']; ?> !
                    </h2>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <a href="questions" class="btn btn-lg btn-info me-2">Questions</a>
            <a href="admins" class="btn btn-lg btn-light me-2">Admins</a>
            <a href="deconnexion" class="btn btn-lg btn-danger">Déconnexion</a>
        </div>
    </div>
</div>

<?= Alerts::getAlert(); ?>

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="card" style="max-width: 40rem;">
            <div class="card-header">
                <h3>Mes informations</h3>
            </div>
            <div class="card-body">
                <p class="card-text"><b>Mon nom :</b> <?= $_SESSION['nom']; ?></p>
                <p class="card-text"><b>Mon prénom :</b> <?= $_SESSION['prenom']; ?></p>
                <p class="card-text"><b>Mon adresse email :</b> <?= $_SESSION['email']; ?></p>
                <p class="card-text"><b>Mon rôle :</b> <?= $_SESSION['role']; ?></p>
                <p class="card-text"><b>Mon nombre de connexion :</b> <?= $_SESSION['nbConnexion']; ?> 
                    <?php if (isset($_SESSION['nbConnexion']) && $_SESSION['nbConnexion'] < 2) { ?>
                        connexion
                    <?php } else { ?>
                        connexions
                    <?php } ?>
                </p>
                <p class="card-text"><b>Ma dernière connexion :</b> <?= $_SESSION['last_connexion']; ?></p>
                <p class="card-text"><b>Ma date de création du compte :</b> <?= $_SESSION['date_creation_compte']; ?></p>
            </div>
            <div class="card-footer">
                <div class="row d-flex justify-content-center">
                    <div class="col-6">
                        <a href="editProfil?edit=<?= $_SESSION['idu']; ?>" class="btn btn-primary w-100" onclick="return(confirm('Vous devrez modifier votre adresse email'))">Modifier mon profil</a>
                    </div>
                    <div class="col-6">
                        <a href="profil?idu=<?= $_SESSION['idu']; ?>&email=<?= $_SESSION['email']; ?>" class="btn btn-danger w-100" onclick="return(confirm('Voulez-vous vraiment supprimer votre compte'))">Supprimer mon compte</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>