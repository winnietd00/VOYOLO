function question1() {
    let score = 0.0;
     let j = '';
    for (let i=1; i<=3; i++) {
        j  = i.toString();
        if (document.getElementById("q1rep"+j).checked == true) {
            score = score + score/3;
        }
    }
    stockerCookie("question1", score, 1);
}

/*
function question2() {
    let score = 0.0;
    for (let i=1; i<=3; i++) {
        i.toString(); // Parse du i, sinon affiche une valeur chelou
        if (document.getElementById("q2rep"+i).checked == true) {
            score = score + score/3;
        }
    }
    stockerCookie("question2", score, 1);
}
*/




// let score = document.write(parseInt(lireCookie("scorecandidat")));
// let score = 0;

// let score = parseInt(lireCookie("scorecandidat"));
// alert(parseInt(lireCookie("scorecandidat")));
// score = score + parseInt(lireCookie("scorecandidat"));
// alert(parseInt(lireCookie("scorecandidat")));


let q1rep = document.getElementById("q1rep").value;
let q1rep1 = document.getElementById("q1rep1").value;
let q1rep2 = document.getElementById("q1rep2").value;
let q1rep3 = document.getElementById("q1rep3").value;
let q1rep4 = document.getElementById("q1rep4").value;
lireCookie("scorecandidat");
/*
if (q1rep == q1rep1) {
    score = score + 1;
    //alert(score);
    alert("ok");
}
*/

function test() {
    let q1rep = document.getElementById("q1rep").value;
    stockerCookie("question1", q1rep, 2);
    //let q1rep1 = document.getElementById("q1rep1").value;
    let score = lireCookie("scorecandidat"); // égale à 0
    // alert(lireCookie("scorecandidat"));
    if (q1rep == "q1rep1") {
        score = score + 1;
        alert(lireCookie("scorecandidat"));
        //score = score + lireCookie("scorecandidat");
        //alert(score);
        //document.write(lireCookie("scorecandidat"));
    }
}

/*
function question1() {
    let score = 0.0;
    for (let i=1; i<=3; i++) {
        if (document.getElementById("q1rep"+i).checked == true) {
            score = score + score/4;
        }
    }
    stockerCookie("question1", score, 1);
}
*/

function test2(cle) {
    let valeur = 0;
    for(let i=1; i<=4; i++) {
        if(document.getElementById("q1rep"+i).value == "q1rep1") {
            alert("ok");
            valeur = document.getElementById("q1rep"+i).value;
            stockerCookie(cle, valeur, 1);
            alert(valeur);
        }
    }
}

function question5() {
    let score = 0.0;
    //
}

/*
function test2(cle) { checkbox (photo)
    let valeur = 0;
    for(let i=1; i<=3; i++) {
        if(document.getElementById("q5rep"+i).checked == true) {
            valeur = document.getElementById("q5rep"+i).value;
            StockerCookie(cle, valeur, 1);
            alert(valeur);
        }
    }
}
*/



/*
if (q1rep1) {
    score = score + 1;
    //alert(score);
    alert("ok");
}
*/


/* Fonction pour checkbox */
function q5checkbox(cle) {
    let valeur = 0;
    for(let i=1; i<=3; i++) {
        if(document.getElementById("q5rep"+i).checked == true) {
            valeur = document.getElementById("q5rep"+i).value;
            StockerCookie(cle, valeur, 1);
            alert(valeur);
        }
    }
}


let q2rep = document.getElementById("q2rep").value;
if (q2rep == "q2rep1" || q2rep == "q2rep2") {
    score = score + 1;
    alert(score);
}



function question1() {
    let score = 0;
    let q1rep = document.getElementById("q1rep").value;
    if (q1rep == "q1rep1" || q1rep == "q1rep2" || q1rep == "q1rep3" || q1rep == "q1rep4") {
        score = score + 1;
        document.cookie = "scorecandidat" + score;
    }
    alert(score);
    alert(parseInt(lireCookie("scorecandidat")));
    /*
    let q2rep = document.getElementById("q2rep").value;
    if (q2rep == "q2rep1" || q2rep == "q2rep2") {
        score = score + 1;
    }
    alert(score);
    console.log(score);
    */
}

function question2() {
    let q2rep = document.getElementById("q2rep").value;
    if (q2rep == "q2rep1" || q2rep == "q2rep2") {
        score = score + 1;
    }
    alert(score);
}

function calcScore() {
    let score = 0;

    let q1rep = document.getElementById("q1rep").value;
    let q2rep = document.getElementById("q2rep").value;

    // Question 1
    if (q1rep == "q1rep1" || q1rep == "q1rep2" || q1rep == "q1rep3" || q1rep == "q1rep4") {
        score = score + 1;
    }

    // Question 2
    if (q2rep == "q2rep1" || q2rep == "q2rep2") {
        score = score + 1;
        alert(score);
    }

}


