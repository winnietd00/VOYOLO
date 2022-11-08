function stockerCookie(cle, valeur, delai) {
    let chaine = "";
    // Récupérer la date système
    let uneDate = new Date();
    // Lui ajouter le delai (en milli-seconde)
    uneDate.setTime(uneDate.getTime() + delai * 24 * 3600 * 1000);
    // La transformer en chaîne
    let dt = uneDate.toUTCString();
    // Concatener le tout : cle = valeur ; expires = dt ; path =/
    chaine = cle + " = " + valeur + " ; expires = " + dt + " ; path=/";
    // Execution de la chaine
    document.cookie = chaine;
}

function saveCookie() {
    let nom = document.getElementById("nom").value;
    let prenom = document.getElementById("prenom").value;
    let age = document.getElementById("age").value;
    let email = document.getElementById("email").value;
    let tel = document.getElementById("tel").value;
    let datenaissance = document.getElementById("datenaissance").value;
    let type = document.getElementById("type").value;
    let score = 0;
    stockerCookie("nompers", nom, 2);
    stockerCookie("prenompers", prenom, 2);
    stockerCookie("agepers", age, 2);
    stockerCookie("emailpers", email, 2);
    stockerCookie("telpers", tel, 2);
    stockerCookie("datenaissancepers", datenaissance, 2);
    stockerCookie("typepers", type, 2);
    stockerCookie("scorepers", score, 2);
}

function lireCookie(cle) {
    // On récupère la chaîne Cookie
    let chaineCookies = document.cookie;
    // On split par ;
    let tab = chaineCookies.split(";");
    // On parcours le tableau résultat du split
    for (let i=0; i<tab.length; i++) {          
        // On split par égal chaque case du tableau
        let tab2 = tab[i].split("=");
        // On supprime les espaces
        while(tab2[0].charAt(0) == ' ') {
            tab2[0] = tab2[0].substring(1);
        }
        // On compare une clé 
        if (tab2[0] == cle) {
            // On récupère la valeur de la clé
            let valeur = tab2[1];
            // On retourne la valeur associé à la clé
            return valeur;
        }
    }
    return null;
}

function supprimerCookie(cle) {
    stockerCookie(cle, '', -1);
}
