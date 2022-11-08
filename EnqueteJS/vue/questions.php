<div class="container mt-4">
    <div class="row d-flex justify-content-center">
        <div class="col-auto">
            <div class="card">
                <div class="card-header bg-success text-light">
                    <h2>Mes informations</h2>
                    <p class="fs-5">Mon nom : <script>document.write(lireCookie("nompers"));</script></p>
                    <p class="fs-5">Mon prénom : <script>document.write(lireCookie("prenompers"));</script></p>
                    <p class="fs-5">Mon email : <script>document.write(lireCookie("emailpers"));</script></p>
                    <p class="fs-5">Je suis : <script>document.write(lireCookie("typepers"));</script></p>
                    <p class="fs-5">Mon score : <script>document.write(lireCookie("scorepers"));</script></p>
                </div>
            </div>
        </div>
    </div>
</div>

<?php foreach ($lesQuestions as $uneQuestion) { ?>
<div class="container mt-5">
    <div class="row d-flex justify-content-center">
        <div class="card" style="max-width: 45rem;">
            <div class="card-header">
                <h3 class="text-center">Question <?= $uneQuestion['idquestion']; ?></h3>
            </div>
            <form method="post" action="">
                <div class="card-body">
                    <p class="fs-5"><?= $uneQuestion['enonce']; ?></p>
                    <?php if ($uneQuestion['idquestion'] == 1) { ?>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q1rep1" class="form-check-input" value="">
                        <label for="q1rep1" class="form-check-label">
                            Le S.A.V. qui donne toujours des réponses rapidement
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q1rep2" class="form-check-input" value="">
                        <label for="q1rep2" class="form-check-label">
                            Les promotions auxquelles vous pouvez bénéficier
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q1rep3" class="form-check-input" value="">
                        <label for="q1rep3" class="form-check-label">
                            Les services qu'on propose aux bords des trains
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-12">
                            <a href="?q=2" class="btn btn-primary w-100" onclick="question1()">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 2) { ?>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q2rep1" class="form-check-input" value="">
                        <label for="q2rep1" class="form-check-label">
                            La possibilitée de parler avec des voyageurs qui font les mêmes trajets
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q2rep2" class="form-check-input" value="">
                        <label for="q2rep2" class="form-check-label">
                            Une fonctionnalitée permettant de vous dirigez dans la gare
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q2rep3" class="form-check-input" value="">
                        <label for="q2rep3" class="form-check-label">
                            Un service qui vous ramène de la nourriture dans le train à votre place assise
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="/EnqueteJS/questions" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=3" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 3) { ?>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q3rep1" class="form-check-input" value="">
                        <label for="q3rep1" class="form-check-label">
                            Pas du tout
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q3rep2" class="form-check-input" value="">
                        <label for="q3rep2" class="form-check-label">
                            Parfois
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="q3rep3" class="form-check-input" value="">
                        <label for="q3rep3" class="form-check-label">
                            Tout le temps
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=2" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=4" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 4) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q4rep1" class="form-check-input">
                        <label for="q4rep1" class="form-check-label">
                            Bouche à oreille
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q4rep2" class="form-check-input">
                        <label for="q4rep2" class="form-check-label">
                            Publicité
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q4rep3" class="form-check-input">
                        <label for="q4rep3" class="form-check-label">
                            Journaux
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=3" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=5" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 5) { ?>
                    <div class="mb-3">
                        <input type="range" id="q5rep" min="0" max="10" value="0" class="form-range"
                            oninput="this.nextElementSibling.value = this.value">
                        <output>0</output>/10
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=4" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=6" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 6) { ?>
                    <div class="mb-3">
                        <input type="range" id="q6rep" min="0" max="10" value="0" class="form-range"
                            oninput="this.nextElementSibling.value = this.value">
                        <output>0</output>/10
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=5" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=7" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 7) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q7rep1" class="form-check-input">
                        <label for="q7rep1" class="form-check-label">
                            Service assistance en gare
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q7rep2" class="form-check-input">
                        <label for="q7rep2" class="form-check-label">
                            Service divertissement
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q7rep3" class="form-check-input">
                        <label for="q7rep3" class="form-check-label">
                            Service nutrition
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=6" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=8" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 8) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q8rep1" class="form-check-input">
                        <label for="q8rep1" class="form-check-label">
                            Oui
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q8rep2" class="form-check-input">
                        <label for="q8rep2" class="form-check-label">
                            Non
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=7" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=9" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 9) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q9rep1" class="form-check-input">
                        <label for="q9rep1" class="form-check-label">
                            Très satisfait
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q9rep2" class="form-check-input">
                        <label for="q9rep2" class="form-check-label">
                            Ça peut être mieux
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q9rep3" class="form-check-input">
                        <label for="q9rep3" class="form-check-label">
                            Pas satisfait
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=8" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=10" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 10) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q10rep1" class="form-check-input">
                        <label for="q10rep1" class="form-check-label">
                            Oui
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q10rep2" class="form-check-input">
                        <label for="q10rep2" class="form-check-label">
                            Non
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=9" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=11" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 11) { ?>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q11rep1" class="form-check-input">
                        <label for="q11rep1" class="form-check-label">
                            Des trajets en groupe
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q11rep2" class="form-check-input">
                        <label for="q11rep2" class="form-check-label">
                            Des trajets seul
                        </label>
                    </div>
                    <div class="form-check mb-3">
                        <input type="radio" name="flexRadioDefault" id="q11rep3" class="form-check-input">
                        <label for="q11rep3" class="form-check-label">
                            Aucun
                        </label>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=10" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <a href="?q=12" class="btn btn-primary w-100">Suivant</a>
                        </div>
                    </div>
                    <?php } else if ($uneQuestion['idquestion'] == 12) { ?>
                    <div class="mb-3">
                        <textarea id="q12rep" rows="5" class="form-control"></textarea>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-6">
                            <a href="?q=11" class="btn btn-secondary w-100">Précédent</a>
                        </div>
                        <div class="col-6">
                            <form method="post" action="traiter">
                                <button type="submit" name="Envoyer" id="valider" class="btn btn-success w-100"
                                    onclick="">Valider</button>
                            </form>
                        </div>
                    </div>
                    <?php } ?>
                </div>
            </form>
        </div>
    </div>
</div>
<?php } ?>
