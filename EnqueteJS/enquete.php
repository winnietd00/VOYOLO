<!DOCTYPE html>
<html lang="fr">
<head>
    <title>VOYOLO | Enquête de satisfaction</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
    <script src="assets/js/check.js"></script>
    <script src="assets/js/cookie.js"></script>
    <script src="assets/js/score.js"></script>
</head>
<body style="background-image: url(assets/img/bg.jpg); background-position: center center; background-repeat: no-repeat; background-attachment: fixed; background-size: cover;" onload="ready()">

<!-- TITRES STATISQUES -->
<?= $helpers->card_header("4", "success", "light", "h1", "VOYOLO"); ?>
<?= $helpers->card_header("4", "success", "light", "h2", "Enquête de satisfaction"); ?>

<!-- AFFICHAGE DES MESSAGES ALERTS -->
<?= Alerts::getAlert(); ?>

<!-- CONTENUS DES AUTRES PAGES QUI SERONT AFFICHER ICI -->
<?= $contenus; ?>
    
</body>
</html>