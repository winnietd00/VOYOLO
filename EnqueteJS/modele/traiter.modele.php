<?php

function selectAllQuestions() {
    global $bdd;
    $selectAll = $bdd->prepare("SELECT idquestion FROM questions");
    $selectAll->execute();
    return $selectAll->rowCount();
}

?>