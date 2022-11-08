/* GESTION DU NOM */
function traiterNom() {
    let nom = document.getElementById("nom").value;
    if (nom.length == 0) {
        alert("Veuillez saisir un nom.");
        document.getElementById("nom").style.backgroundColor = "red";
        document.getElementById("nom").style.color = "white";
    } else if (nom.length < 2) {
        alert("Le nom saisi est trop cour.");
        document.getElementById("nom").style.backgroundColor = "red";
        document.getElementById("prenom").style.color = "white";
    } else if (nom.length > 50) {
        alert("Le nom ne doit pas dépasser 50 caractères.");
        document.getElementById("nom").style.backgroundColor = "red";
        document.getElementById("nom").style.color = "white";
    } else {
        let chiffre=0, caractere=0;
        for (let i=0; i<nom.length; i++) {
            if (nom.charAt(i) == '0' || nom.charAt(i) == '1' || nom.charAt(i) == '2' || nom.charAt(i) == '3' || nom.charAt(i) == '4' || nom.charAt(i) == '5' || nom.charAt(i) == '6' || nom.charAt(i) == '7' || nom.charAt(i) == '8' || nom.charAt(i) == '9') {
                chiffre ++;
            } else if (nom.charAt(i) == '@' || nom.charAt(i) == '$' || nom.charAt(i) == '!' || nom.charAt(i) == '&' || nom.charAt(i) == '?' || nom.charAt(i) == ';' || nom.charAt(i) == '%' || nom.charAt(i) == ':' || nom.charAt(i) == '#' || nom.charAt(i) == '+' || nom.charAt(i) == '=' || nom.charAt(i) == '<' || nom.charAt(i) == '>' || nom.charAt(i) == '*' || nom.charAt(i) == '.' || nom.charAt(i) == '_' || nom.charAt(i) == '-' || nom.charAt(i) == '(' || nom.charAt(i) == ')' || nom.charAt(i) == '{' || nom.charAt(i) == '}' || nom.charAt(i) == '[' || nom.charAt(i) == ']') {
                caractere ++;
            }
        }
        if (chiffre >= 1) {
            alert("Le nom ne doit pas contenir de chiffres.");
            document.getElementById("nom").style.backgroundColor = "red";
            document.getElementById("nom").style.color = "white";
        } else if (caractere >= 1) {
            alert("Le nom ne doit pas contenir de caractères spéciaux.");
            document.getElementById("nom").style.backgroundColor = "red";
            document.getElementById("nom").style.color = "white";
        } else if (nom.substring(0,1) == 'a' || nom.substring(0,1) == 'b' || nom.substring(0,1) == 'c' || nom.substring(0,1) == 'd' || nom.substring(0,1) == 'e' || nom.substring(0,1) == 'f' || nom.substring(0,1) == 'g' || nom.substring(0,1) == 'h' || nom.substring(0,1) == 'i' || nom.substring(0,1) == 'j' || nom.substring(0,1) == 'k' || nom.substring(0,1) == 'l' || nom.substring(0,1) == 'm' || nom.substring(0,1) == 'n' || nom.substring(0,1) == 'o' || nom.substring(0,1) == 'p' || nom.substring(0,1) == 'q' || nom.substring(0,1) == 'r' || nom.substring(0,1) == 's' || nom.substring(0,1) == 't' || nom.substring(0,1) == 'u' || nom.substring(0,1) == 'v' || nom.substring(0,1) == 'w' || nom.substring(0,1) == 'x' || nom.substring(0,1) == 'y' || nom.substring(0,1) == 'z') {
            alert("Le nom doit commencer par une lettre majuscule.");
            document.getElementById("nom").style.backgroundColor = "red";
            document.getElementById("nom").style.color = "white";
        } else {
            document.getElementById("nom").style.backgroundColor = "lightgreen";
            document.getElementById("nom").style.color = "black";
        }
    }
}

/* GESTION DU PRENOM */
function traiterPrenom() {
    let prenom = document.getElementById("prenom").value;
    if (prenom.length == 0) {
        alert("Veuillez saisir un prénom.");
        document.getElementById("prenom").style.backgroundColor = "red";
        document.getElementById("prenom").style.color = "white";
    } else if (prenom.length < 2) {
        alert("Le prénom saisi est trop cour.");
        document.getElementById("prenom").style.backgroundColor = "red";
        document.getElementById("prenom").style.color = "white";
    } else if (prenom.length > 50) {
        alert("Le prénom ne doit pas dépasser 50 caractères.");
        document.getElementById("prenom").style.backgroundColor = "red";
        document.getElementById("prenom").style.color = "white";
    } else {
        let chiffre=0, caractere=0;
        for (let i=0; i<prenom.length; i++) {
            if (prenom.charAt(i) == '0' || prenom.charAt(i) == '1' || prenom.charAt(i) == '2' || prenom.charAt(i) == '3' || prenom.charAt(i) == '4' || prenom.charAt(i) == '5' || prenom.charAt(i) == '6' || prenom.charAt(i) == '7' || prenom.charAt(i) == '8' || prenom.charAt(i) == '9') {
                chiffre ++;
            } else if (prenom.charAt(i) == '@' || prenom.charAt(i) == '$' || prenom.charAt(i) == '!' || prenom.charAt(i) == '&' || prenom.charAt(i) == '?' || prenom.charAt(i) == ';' || prenom.charAt(i) == '%' || prenom.charAt(i) == ':' || prenom.charAt(i) == '#' || prenom.charAt(i) == '+' || prenom.charAt(i) == '=' || prenom.charAt(i) == '<' || prenom.charAt(i) == '>' || prenom.charAt(i) == '*' || prenom.charAt(i) == '.' || prenom.charAt(i) == '_' || prenom.charAt(i) == '-' || prenom.charAt(i) == '(' || prenom.charAt(i) == ')' || prenom.charAt(i) == '{' || prenom.charAt(i) == '}' || prenom.charAt(i) == '[' || prenom.charAt(i) == ']') {
                caractere ++;
            }
        }
        if (chiffre >= 1) {
            alert("Le prénom ne doit pas contenir de chiffres.");
            document.getElementById("prenom").style.backgroundColor = "red";
            document.getElementById("prenom").style.color = "white";
        } else if (caractere >= 1) {
            alert("Le prénom ne doit pas contenir de caractères spéciaux.");
            document.getElementById("prenom").style.backgroundColor = "red";
            document.getElementById("prenom").style.color = "white";
        } else if (prenom.substring(0,1) == 'a' || prenom.substring(0,1) == 'b' || prenom.substring(0,1) == 'c' || prenom.substring(0,1) == 'd' || prenom.substring(0,1) == 'e' || prenom.substring(0,1) == 'f' || prenom.substring(0,1) == 'g' || prenom.substring(0,1) == 'h' || prenom.substring(0,1) == 'i' || prenom.substring(0,1) == 'j' || prenom.substring(0,1) == 'k' || prenom.substring(0,1) == 'l' || prenom.substring(0,1) == 'm' || prenom.substring(0,1) == 'n' || prenom.substring(0,1) == 'o' || prenom.substring(0,1) == 'p' || prenom.substring(0,1) == 'q' || prenom.substring(0,1) == 'r' || prenom.substring(0,1) == 's' || prenom.substring(0,1) == 't' || prenom.substring(0,1) == 'u' || prenom.substring(0,1) == 'v' || prenom.substring(0,1) == 'w' || prenom.substring(0,1) == 'x' || prenom.substring(0,1) == 'y' || prenom.substring(0,1) == 'z') {
            alert("Le prénom doit commencer par une lettre majuscule.");
            document.getElementById("prenom").style.backgroundColor = "red";
            document.getElementById("prenom").style.color = "white";
        } else {
            // prenom = (prenom.substring(0, 1).toUpperCase()) + (prenom.substring(1)).toLowerCase();
            // document.getElementById("prenom").value = prenom;
            document.getElementById("prenom").style.backgroundColor = "lightgreen";
            document.getElementById("prenom").style.color = "black";
        }
    }
}

/* GESTION DE L'ADRESSE EMAIL */
function traiterEmail() {
    let email = document.getElementById("email").value;
    if (email.length == 0) {
        alert("Veuillez saisir une adresse email.");
        document.getElementById("email").style.backgroundColor = "red";
        document.getElementById("email").style.color = "white";
    } else if (email.length < 2) {
        alert("L'adresse email saisie est trop courte.");
        document.getElementById("email").style.backgroundColor = "red";
        document.getElementById("email").style.color = "white";
    } else if (email.length > 100) {
        alert("L'adresse email ne doit pas dépasser 100 caractères.");
        document.getElementById("email").style.backgroundColor = "red";
        document.getElementById("email").style.color = "white";
    } else {
        let cArobase=0, cPoint=0, espace=0;
        for (let i=0 ; i<email.length; i++) {
            if (email.charAt(i) == '@') { 
                cArobase ++ ;
            } else if (email.charAt(i) == '.') {
                cPoint ++ ;
            } else if (email.charAt(i) == ' ') {
                espace ++;
            }
        }
        if (cArobase < 1 || cArobase > 1) {
            alert("L'adresse email doit contenir un et un seul @.");
            document.getElementById("email").style.backgroundColor = "red";
            document.getElementById("email").style.color = "white";
        } else if (cPoint < 1) {
            alert("L'adresse email doit contenir un \".\"");
            document.getElementById("email").style.backgroundColor = "red";
            document.getElementById("email").style.color = "white";      
        } else if (espace >= 1) {
            alert("L'adresse email ne doit pas contenir d'espace.");
            document.getElementById("email").style.backgroundColor = "red";
            document.getElementById("email").style.color = "white";
        } else {
            document.getElementById("email").style.backgroundColor = "lightgreen";
            document.getElementById("email").style.color = "black";
        }
    }
}
