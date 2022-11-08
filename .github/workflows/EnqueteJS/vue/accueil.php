<div class="container mt-4 mb-5">
    <div class="row d-flex justify-content-center">
        <div class="card" style="max-width: 35rem; background-color: #ADD8E6; border: 5px solid #556B2F!important;">
            <div class="card-header" style="background-color: #ADD8E6;">
                <h3 class="text-center">IDENTIFICATION</h3>
            </div>
            <form method="post" action="questions" onsubmit="saveCookie()">
                <div class="card-body" style="background-color: #ADD8E6;">
                    <div class="mb-3">
                        <select id="sexe" name="sexe" class="form-select">
                            <option selected>Vous êtes une femme ou un homme ?</option>
                            <option value="Femme">Femme</option>
                            <option value="Homme">Homme</option>
                            <option value="Non préciser">Non préciser</option>
                        </select>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" id="nom" name="nom" placeholder="Nom" class="form-control" onblur="traiterNom()">
                        <label for="nom">Nom</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" id="prenom" name="prenom" placeholder="Prénom" class="form-control" onblur="traiterPrenom()">
                        <label for="prenom">Prénom</label>
                    </div>
                    <div class="mb-3">
                        <select id="age" name="age" class="form-select">
                            <option selected>Dans quelle tranche d'age vous situez-vous ?</option>
                            <option value="0-18">0-18 ans</option>
                            <option value="19-35">19-35 ans</option>
                            <option value="36-62">36-62 ans</option>
                            <option value="63 ans et plus">63 ans et plus</option>
                        </select>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="date" id="datenaissance" name="datenaissance" class="form-control">
                        <label for="datenaissance">Date de naissance</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="email" id="email" name="email" placeholder="Adresse email" class="form-control" onblur="traiterEmail()">
                        <label for="email">Adresse email</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="tel" id="tel" name="tel" maxlength="10" placeholder="Téléphone" class="form-control">
                        <label for="tel">Téléphone</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" id="adresse" name="adresse" placeholder="Où vivez-vous ?" class="form-control">
                        <label for="adresse">Où vivez-vous ?</label>
                    </div>
                    <div class="mb-3">
                        <select id="type" name="type" class="form-select">
                            <option value="visiteur">Je suis visiteur</option>
                            <option value="client">Je suis client</option>
                            <option value="admin">Je suis administrateur</option>
                        </select>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <button type="reset" class="btn btn-danger w-100">Annuler</button>
                        </div>
                        <div class="col-6">
                            <button type="submit" name="Valider" class="btn btn-primary w-100">Valider</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>