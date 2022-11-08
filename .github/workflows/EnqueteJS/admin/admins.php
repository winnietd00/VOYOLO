<?php

if (!isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv");</script>';
}

$lesAdmins = $bdd->query("SELECT nom, prenom FROM users WHERE role = 'admin' ORDER BY nom;");

?>
<body class="bg-dark">

<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <a href="profil" class="btn btn-lg btn-primary me-2">Profil</a>
            <a href="questions" class="btn btn-lg btn-info me-2">Questions</a>
            <a href="deconnexion" class="btn btn-lg btn-danger">Déconnexion</a>
        </div>
    </div>
</div>

<div class="container mt-4 mb-5">
    <div class="row d-flex justify-content-center">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3>Liste des admins</h3>
                </div>
                <div class="card-body bg-secondary">
                    <table class="table table-dark">
                        <thead>
                            <tr>
                                <th scope="col">Prénom</th>
                                <th scope="col">NOM</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($lesAdmins as $unAdmin) { ?>
                            <tr>
                                <td><?= $unAdmin['prenom']; ?></td>
                                <td><?= $unAdmin['nom']; ?></td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>