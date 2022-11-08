<?php

if (isset($_SESSION['email'])) {
    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
}

/* Connexion en interrogeant la table user */
if (isset($_POST['connexion'])) {
    $email = $_POST['email'];
    $mdp = sha1($_POST['mdp']);
    if ($email !== "" && $mdp !== "") {
        $user = $bdd->prepare("SELECT idu, nom, prenom, email, role, nbConnexion, bloque, last_connexion, date_creation_compte FROM vusers WHERE email = :email AND mdp = :mdp");
        $user->bindValue(':email', $email, PDO::PARAM_STR);
        $user->bindValue(':mdp', $mdp, PDO::PARAM_STR);
        $user->execute();
        $user = $user->fetch();
        if ($user) {
            $session->setVar('idu', $user['idu']);
            $session->setVar('nom', $user['nom']);
            $session->setVar('prenom', $user['prenom']);
            $session->setVar('email', $user['email']);
            $session->setVar('role', $user['role']);
            $session->setVar('nbConnexion', $user['nbConnexion']);
            $session->setVar('bloque', $user['bloque']);
            $session->setVar('last_connexion', $user['last_connexion']);
            $session->setVar('date_creation_compte', $user['date_creation_compte']);
            if ($user['role'] == "admin") { // Si l'utilisateur est administrateur
                if ($user['bloque'] == 0) { // Si l'utilisateur n'est pas bloqué
                    $procedure = $bdd->prepare("call connexion(:email, :mdp)");
                    $procedure->bindValue(':email', $email, PDO::PARAM_STR);
                    $procedure->bindValue(':mdp', $mdp, PDO::PARAM_STR);
                    $procedure->execute();
                    echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
                } else {
                    Alerts::setAlert("Votre compte est bloqué.", "danger");
                }
            } else {
                Alerts::setAlert("Vous n'êtes pas administrateur.", "danger");
            }
        } else {
            Alerts::setAlert("Identifiants inccorects.", "danger");
        }
    } else {
        Alerts::setAlert("Veuillez remplir tous les champs.");
    }
}

/* Connexion en interrogeant la table admin */
/* NE PAS L'UTILISER
if (isset($_POST['connexion'])) {
    $email = $_POST['email'];
    $mdp = sha1($_POST['mdp']);
    if ($email !== "" && $mdp !== "") {
        $admin = $bdd->prepare("SELECT * FROM admin WHERE email = :email AND mdp = :mdp");
        $admin->bindValue(':email', $email, PDO::PARAM_STR);
        $admin->bindValue(':mdp', $mdp, PDO::PARAM_STR);
        $admin->execute();
        $admin = $admin->fetch();
        if ($admin) {
            $session->setVar('idu', $admin['idu']);
            $session->setVar('email', $admin['email']);
            $session->setVar('date_connexion', $admin['date_connexion']);
            echo '<script language="javascript">document.location.replace("/EnqueteJS/edsjsv/profil");</script>';
        } else {
            Alerts::setAlert("Identifiants inccorects.", "danger");
        }
    } else {
        Alerts::setAlert("Veuillez remplir tous les champs.");
    }
}
*/

?>
<div class="container mt-5">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <a href="/EnqueteJS/" class="btn btn-lg btn-info fw-bold">Enquête</a>
        </div>
    </div>
</div>

<div class="container mt-5">
    <div class="row d-flex justify-content-center">
        <div class="col-lg-4 mt-5 mt-lg-0">
            <?= Alerts::getAlert(); ?>
            <div class="card">
                <div class="card-header">
                    <h3 class="text-center">Veuillez-vous identifier.</h3>
                </div>
                <form method="post" action="">
                    <div class="card-body">
                        <div class="form-floating mb-3">
                            <input type="text" name="email" id="email" placeholder="Adresse email" class="form-control">
                            <label for="email">Adresse email</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="password" name="mdp" id="mdp" placeholder="Mot de passe" class="form-control">
                            <label for="mdp">Mot de passe</label>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row d-flex justify-content-center">
                            <div class="col-6">
                                <button type="reset" class="btn btn-danger w-100">Annuler</button>
                            </div>
                            <div class="col-6">
                                <button type="submit" name="connexion" class="btn btn-primary w-100">Connexion</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>