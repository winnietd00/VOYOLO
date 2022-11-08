Drop database if exists voyolo;
Create database if not exists voyolo;
Use voyolo;

Drop table if exists users;
Create table if not exists users (
	idu int(11) not null auto_increment,
	nom varchar(30) not null,
	prenom varchar(30) not null,
	email varchar(50) not null UNIQUE,
	mdp varchar(255) not null,
	role enum("client", "admin"),
	nbTentatives int not null default 0,
	nbConnexion int not null default 0,
	bloque int not null default 0,
	last_connexion datetime,
	last_deconnexion datetime,
	date_creation_compte datetime,
	primary key (idu)
) ENGINE=InnoDB, CHARSET=utf8;
-- En savoir plus sur InnoDB -> https://sql.sh/1548-mysql-innodb-myisam

/* Création d'une view afin de convertir les dates au format FR */
Create or replace view vusers (idu, nom, prenom, email, mdp, role, nbTentatives, nbConnexion, bloque, last_connexion, last_deconnexion, date_creation_compte)
as select idu, nom, prenom, email, mdp, role, nbTentatives, nbConnexion, bloque, date_format(last_connexion, '%d/%m/%Y %H:%i'), date_format(last_deconnexion, '%d/%m/%Y %H:%i'), date_format(date_creation_compte, '%d/%m/%Y %H:%i')
from users;

/* Création d'une table d'archive / d'historisation des utilisateurs */
# sysdate() dateHeureAction : variable 'sysdate()' renommé en 'dateHeureAction' => Date & heure de l'action
# user() user : variable 'user()' renommé en user => utilisateur de MySQL / MariaDB
# '__________' action : '__________' renommé en action => Action effectué sur la table user (INSERT/UPDATE/DELETE)
Create table histoUsers as select *, sysdate() dateHeureAction, user() user, '__________' action
From users
Where 2=0;

/* Trigger qui permet de savoir quel utilisateur à été insérer dans la table user après chaque insertion. */
Drop trigger if exists HistoInsertUser;
Delimiter //
Create trigger HistoInsertUser
After insert on users
For each row
Begin
	insert into histoUsers select *, sysdate(), user(), 'INSERT'
	from users
	where idu = new.idu;
End //
Delimiter ;

/* Trigger qui permet de savoir quel utilisateur à été modifié sur la table user après chaque modification. */
Drop trigger if exists HistoUpdateUser;
Delimiter //
Create trigger HistoUpdateUser
Before update on users
For each row
Begin
	insert into histoUsers select *, sysdate(), user(), 'UPDATE'
	from users
	where idu = old.idu;
End //
Delimiter ;

/* Trigger qui permet de savoir quel utilisateur à été supprimé sur la table user après chaque suppression. */
Drop trigger if exists HistoDeleteUser;
Delimiter //
Create trigger HistoDeleteUser
Before delete on users
For each row
Begin
	insert into histoUsers select *, sysdate(), user(), 'DELETE'
	from users
	where idu = old.idu;
End //
Delimiter ;

/* Fonction qui permet de voir le nombre de doublons de l'adresse email saisi (si elle n'est pas déjà utilisée) lors de l'insertion */
Drop function if exists countEmailUser;
Delimiter //
Create function countEmailUser(newemail varchar(50))
returns int
Begin
	select count(*) from users where email = newemail into @result;
	return @result;
End //
Delimiter ;

/* Trigger qui permet de savoir si l'adresse email est déjà utilisée ou non  */
Drop trigger if exists checkEmailUser;
Delimiter //
Create trigger checkEmailUser
Before insert on users
For each row
Begin
	if countEmailUser(new.email)
		then signal sqlstate '45000'
		set message_text = 'Adresse email déjà utilisée !';
	end if ;
End //
Delimiter ;

/* Procédure qui permet d'insérer un utilisateur plus rapidement */
Drop procedure if exists insertUser;
Delimiter //
Create procedure insertUser(in u_nom varchar(30), in u_prenom varchar(30), in u_email varchar(50), in u_mdp varchar(255), in u_role enum("client", "admin"))
Begin
	insert into users values (null, u_nom, u_prenom, u_email, u_mdp, u_role, 0, 0, 0, sysdate(), sysdate(), sysdate());
End //
Delimiter ;

-- Test de la procédure (Exemple)
call insertUser('BRUAIRE', 'Tom', 'tom@gmail.com', '123', 'client');
# call : appeler une procédure

/* Procédure qui permet d'éditer les informations d'un utilisateur plus rapidement */
Drop procedure if exists updateUser;
Delimiter //
Create procedure updateUser(in u_nom varchar(30), in u_prenom varchar(30), in u_email varchar(50), in u_mdp varchar(255), in u_role enum("client", "admin"))
Begin
	update users set nom = u_nom, prenom = u_prenom, email = u_email, mdp = u_mdp, role = u_role
	where email = u_email;
End //
Delimiter ;

/* Procédure qui permet de supprimer un utilisateur en fonction de son email (vu qu'il est UNIQUE) */
Drop procedure if exists deleteUser;
Delimiter //
Create procedure deleteUser(in u_email varchar(50))
Begin
	delete from users where email = u_email;
End //
Delimiter ;

Drop table if exists trains;
Create table if not exists trains (
	numt int(11) not null auto_increment,
	nom varchar(50) not null UNIQUE,
	nbwagon int(2) not null,
	nbplaces int(11) not null,
	date_creation_train date,
	primary key (numt)
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin de convertir les dates au format FR */
Create or replace view vtrains (numt, nom, nbwagon, nbplaces, date_creation_train)
as select numt, nom, nbwagon, nbplaces, date_format(date_creation_train, '%d/%m/%Y')
from trains;

/* Création d'une table d'archive / d'historisation des trains */
Create table histoTrains as select *, sysdate() dateHeureAction, user() user, '__________' action
From trains
Where 2=0;

/* Trigger qui permet de savoir quel train à été insérer dans la table trains après chaque insertion. */
Drop trigger if exists HistoInsertTrain;
Delimiter //
Create trigger HistoInsertTrain
After insert on trains
For each row
Begin
	insert into histoTrains select *, sysdate(), user(), 'INSERT'
	from trains
	where numt = new.numt;
End //
Delimiter ;

/* Trigger qui permet de savoir quel train à été modifié sur la table trains après chaque modification. */
Drop trigger if exists HistoUpdateTrain;
Delimiter //
Create trigger HistoUpdateTrain
Before update on trains
For each row
Begin
	insert into histoTrains select *, sysdate(), user(), 'UPDATE'
	from trains
	where numt = old.numt;
End //
Delimiter ;

/* Trigger qui permet de savoir quel train à été supprimé sur la table trains après chaque suppression. */
Drop trigger if exists HistoDeleteTrain;
Delimiter //
Create trigger HistoDeleteTrain
Before delete on trains
For each row
Begin
	insert into histoTrains select *, sysdate(), user(), 'DELETE'
	from trains
	where numt = old.numt;
End //
Delimiter ;

/* Fonction qui permet de voir le nombre de doublons de nom de train saisi (si il n'est pas déjà utilisé) lors de l'insertion */
Drop function if exists countTrainName;
Delimiter //
Create function countTrainName(newnom varchar(50))
returns int
Begin
	select count(*) from users where nom = newnom into @result;
	return @result;
End //
Delimiter ;

/* Trigger qui permet de savoir si le nom est déjà utilisé ou non  */
Drop trigger if exists checkNameTrain;
Delimiter //
Create trigger checkNameTrain
Before insert on trains
For each row
Begin
	if countTrainName(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Nom de train déjà utilisé !';
	end if ;
End //
Delimiter ;

/* Procédure qui permet d'insérer un train plus rapidement */
Drop procedure if exists insertTrain;
Delimiter //
Create procedure insertTrain(in t_nom varchar(50), in t_nbwagon int(2), in t_nbplaces int(11))
Begin
	insert into users values (null, t_nom, t_nbwagon, t_nbplaces, curdate());
End //
Delimiter ;

/* Procédure qui permet d'éditer les informations d'un train plus rapidement */
Drop procedure if exists updateTrain;
Delimiter //
Create procedure updateTrain(in t_nom varchar(50), in t_nbwagon int(2), in t_nbplaces int(11))
Begin
	update trains set nom = t_nom, nbwagon = t_nbwagon, nbplaces = t_nbplaces
	where nom = t_nom;
End //
Delimiter ;

/* Procédure qui permet de supprimer un train en fonction de son email (vu qu'il est UNIQUE) */
Drop procedure if exists deleteTrain;
Delimiter //
Create procedure deleteTrain(in t_nom varchar(50))
Begin
	delete from trains where nom = t_nom;
End //
Delimiter ;

Drop table if exists trajets;
Create table if not exists trajets (
	idt int(11) not null auto_increment,
	numt int(11) not null,
	depart varchar(30) not null,
	date_depart date,
	heure_depart time,
	destination varchar(30) not null,
	date_arrive date,
	heure_arrive time,
	duree_trajet time,
	prix decimal(6,2) not null,
	quai varchar(30) not null,
	primary key (idt),
	foreign key (numt) references trains (numt)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin de convertir les dates au format FR */
Create or replace view vtrajets (idt, numt, depart, date_depart, heure_depart, destination, date_arrive, heure_arrive, duree_trajet, prix, quai)
as select idt, numt, depart, date_format(date_depart, '%d/%m/%Y'), date_format(heure_depart, 'H:i'), destination, date_format(date_arrive, '%d/%m/%Y'), date_format(heure_arrive, 'H:i'), date_format(duree_trajet, 'H:i'), prix, quai
from trajets;

/* Création d'une table d'archive / d'historisation des trajets */
Create table histoTrajets as select *, sysdate() dateHeureAction, user() user, '__________' action
From trajets
Where 2=0;

/* Trigger qui permet de savoir quel trajet à été insérer dans la table trajets après chaque insertion. */
Drop trigger if exists HistoInsertTrajet;
Delimiter //
Create trigger HistoInsertTrajet
After insert on trajets
For each row
Begin
	insert into histoTrajets select *, sysdate(), user(), 'INSERT'
	from trajets
	where idt = new.idt;
End //
Delimiter ;

/* Trigger qui permet de savoir quel trajet à été modifié sur la table trajets après chaque modification. */
Drop trigger if exists HistoUpdateTrajet;
Delimiter //
Create trigger HistoUpdateTrajet
Before update on trajets
For each row
Begin
	insert into histoTrajets select *, sysdate(), user(), 'UPDATE'
	from trajets
	where idt = old.idt;
End //
Delimiter ;

/* Trigger qui permet de savoir quel trajet à été supprimé sur la table trajets après chaque suppression. */
Drop trigger if exists HistoDeleteTrajet;
Delimiter //
Create trigger HistoDeleteTrajet
Before delete on trajets
For each row
Begin
	insert into histoTrajets select *, sysdate(), user(), 'DELETE'
	from trajets
	where idt = old.idt;
End //
Delimiter ;

/* Procédure qui permet d'insérer un trajet plus rapidement */
Drop procedure if exists insertTrajet;
Delimiter //
Create procedure insertTrajet(in trj_numt int(11), in trj_depart varchar(30), in trj_date_depart date, in trj_heure_depart time, in trj_destination varchar(30), in trj_date_arrive date, in trj_heure_arrive time, in trj_duree_trajet time, in trj_prix decimal(6,2), in trj_quai varchar(30))
Begin
	insert into trajets values (null, trj_numt, trj_depart, trj_date_depart, trj_heure_depart, trj_destination, trj_date_arrive, trj_heure_arrive, trj_duree_trajet, trj_prix, trj_quai);
End //
Delimiter ;

/* Procédure qui permet d'éditer les informations d'un trajet plus rapidement */
Drop procedure if exists updateTrajet;
Delimiter //
Create procedure updateTrajet(in trj_idt int(11), in trj_numt int(11), in trj_depart varchar(30), in trj_date_depart date, in trj_heure_depart time, in trj_destination varchar(30), in trj_date_arrive date, in trj_heure_arrive time, in trj_duree_trajet time, in trj_prix decimal(6,2), in trj_quai varchar(30))
Begin
	update trajets set numt = trj_numt, depart = trj_depart, date_depart = trj_date_depart, heure_depart = trj_heure_depart, destination = trj_destination, date_arrive = trj_date_arrive, heure_arrive = trj_heure_arrive, duree_trajet = trj_duree_trajet, prix = trj_prix, quai = trj_quai
	where idt = trj_idt;
End //
Delimiter ;

/* Procédure qui permet de supprimer un trajet en fonction de son id */
Drop procedure if exists deleteTrajet;
Delimiter //
Create procedure deleteTrajet(in trj_idt int(11))
Begin
	delete from trajets where idt = trj_idt;
End //
Delimiter ;

Drop table if exists reservations;
Create table if not exists reservations (
	idr int(11) not null auto_increment,
	idu int(11) not null,
	numt int(11) not null,
	date_reservation datetime,
	primary key (idr),
	foreign key (idu) references users (idu)
	on update cascade
	on delete cascade,
	foreign key (numt) references trains (numt)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin de convertir les dates au format FR */
Create or replace view vreservations (idr, idu, numt, date_reservation)
as select idr, idu, numt, date_format(date_reservation, '%d/%m/%Y H:i')
from reservations;

/* Création d'une table d'archive / d'historisation des réservations */
Create table histoReservations as select *, sysdate() dateHeureAction, user() user, '__________' action
From reservations
Where 2=0;

/* Trigger qui permet de savoir quelle réservation à été insérer dans la table reservations après chaque insertion. */
Drop trigger if exists HistoInsertReservation;
Delimiter //
Create trigger HistoInsertReservation
After insert on reservations
For each row
Begin
	insert into histoReservations select *, sysdate(), user(), 'INSERT'
	from reservations
	where idr = new.idr;
End //
Delimiter ;

/* Trigger qui permet de savoir quelle réservation à été modifiée sur la table reservations après chaque modification. */
Drop trigger if exists HistoUpdateReservation;
Delimiter //
Create trigger updateReservation
Before update on reservations
For each row
Begin
	insert into histoReservations select *, sysdate(), user(), 'UPDATE'
	from reservations
	where idr = old.idr;
End //
Delimiter ;

/* Trigger qui permet de savoir quelle réservation à été supprimée sur la table reservations après chaque suppression. */
Drop trigger if exists HistoDeleteReservation;
Delimiter //
Create trigger deleteReservation
Before delete on reservations
For each row
Begin
	insert into histoReservations select *, sysdate(), user(), 'DELETE'
	from reservations
	where idr = old.idr;
End //
Delimiter ;

/* Procédure qui permet d'insérer une réservation plus rapidement */
Drop procedure if exists insertReservation;
Delimiter //
Create procedure insertReservation(in r_idu int(11), in r_numt int(11), in r_date_reservation datetime)
Begin
	insert into reservations values (null, r_idu, r_numt, r_date_reservation);
End //
Delimiter ;

/* Procédure qui permet d'éditer les informations d'une réservation plus rapidement */
Drop procedure if exists updateReservation;
Delimiter //
Create procedure updateReservation(in r_idr int(11), in r_idu int(11), in r_numt int(11), in r_date_reservation datetime)
Begin
	update reservations set idu = r_idu, numt = r_numt, date_reservation = r_date_reservation
	where idr = r_idr;
End //
Delimiter ;

/* Procédure qui permet de supprimer une réservation en fonction de son id */
Drop procedure if exists deleteReservation;
Delimiter //
Create procedure deleteReservation(in r_idr int(11))
Begin
	delete from reservations where idr = r_idr;
End //
Delimiter ;

Drop table if exists energies;
Create table if not exists energies (
	numt int(11),
	energie int(11),
	primary key (numt),
	foreign key (numt) references trains (numt)
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin d'afficher le nom du train */
Create or replace view venergies (numt, energie, train)
as select e.numt, e.energie, t.nom
from energies e inner join trains t
on e.numt = t.numt;

/* Création d'une table d'archive / d'historisation des énergies consommées par les trains */
Create table histoEnergies as select *, sysdate() dateHeureAction, user() user, '__________' action
From energies
Where 2=0;

/*** Triggers qui permet de savoir quelle train à consommer combien d'énergie ***/

Drop trigger if exists HistoInsertEnergie;
Delimiter //
Create trigger HistoInsertEnergie
After insert on energies
For each row
Begin
	insert into histoEnergies select *, sysdate(), user(), 'INSERT'
	from energies
	where numt = new.numt;
End //
Delimiter ;

Drop trigger if exists HistoUpdateEnergies;
Delimiter //
Create trigger HistoUpdateEnergies
Before update on energies
For each row
Begin
	insert into histoEnergies select *, sysdate(), user(), 'UPDATE'
	from energies
	where numt = old.numt;
End //
Delimiter ;

Drop trigger if exists HistoDeleteEnergie;
Delimiter //
Create trigger HistoDeleteEnergie
Before delete on energies
For each row
Begin
	insert into histoEnergies select *, sysdate(), user(), 'DELETE'
	from energies
	where numt = old.numt;
End //
Delimiter ;

Drop procedure if exists insertEnergie;
Delimiter //
Create procedure insertEnergie(in e_numt int(11), in e_energie int(11))
Begin
	insert into energies values (null, e_numt, e_energie);
End //
Delimiter ;

Drop procedure if exists updateEnergie;
Delimiter //
Create procedure updateEnergie(in e_numt int(11), in e_energie int(11))
Begin
	update energies set energie = e_energie where numt = e_numt;
End //
Delimiter ;

Drop procedure if exists deleteEnergie;
Delimiter //
Create procedure deleteEnergie(in e_numt int(11))
Begin
	delete from energies where numt = e_numt;
End //
Delimiter ;

Drop table if exists enquetes;
Create table if not exists enquetes (
	ide int(11) not null auto_increment,
	nom varchar(30) not null,
	prenom varchar(30) not null,
	age int(2) not null,
	email varchar(50) not null UNIQUE,
	score int(2) not null,
	primary key (ide)
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une table d'archive / d'historisation des enquêtes */
Create table histoEnquetes as select *, sysdate() dateHeureAction, user() user, '__________' action
From enquetes
Where 2=0;

Drop trigger if exists HistoInsertEnquete;
Delimiter //
Create trigger HistoInsertEnquete
After insert on enquetes
For each row
Begin
	insert into histoEnquetes select *, sysdate(), user(), 'INSERT'
	from enquetes
	where ide = new.ide;
End //
Delimiter ;

Drop trigger if exists HistoUpdateEnquete;
Delimiter //
Create trigger HistoUpdateEnquete
Before update on enquetes
For each row
Begin
	insert into histoEnquetes select *, sysdate(), user(), 'UPDATE'
	from enquetes
	where ide = old.ide;
End //
Delimiter ;

Drop trigger if exists HistoDeleteEnquete;
Delimiter //
Create trigger HistoDeleteEnquete
Before delete on enquetes
For each row
Begin
	insert into histoEnquetes select *, sysdate(), user(), 'DELETE'
	from enquetes
	where ide = old.ide;
End //
Delimiter ;

/* Fonction qui permet de voir le nombre de doublons de l'adresse email saisi (si elle n'est pas déjà utilisée) lors de l'insertion */
Drop function if exists countEmailEnquete;
Delimiter //
Create function countEmailEnquete(newemail varchar(50))
returns int
Begin
	select count(*) from enquetes where email = newemail into @result;
	return @result;
End //
Delimiter ;

/* Trigger qui permet de savoir si l'adresse email est déjà utilisée ou non  */
Drop trigger if exists checkEmailEnquete;
Delimiter //
Create trigger checkEmailEnquete
Before insert on enquetes
For each row
Begin
	if countEmailEnquete(new.email)
		then signal sqlstate '45000'
		set message_text = 'Adresse email déjà utilisée !';
	end if ;
End //
Delimiter ;

Drop procedure if exists insertEnquete;
Delimiter //
Create procedure insertEnquete(in en_nom varchar(30), in en_prenom varchar(30), in en_age int(2), in en_email varchar(50), in en_score int(2))
Begin
	insert into enquetes values (null, en_nom, en_prenom, en_age, en_email, en_score);
End //
Delimiter ;

Drop procedure if exists updateEnquete;
Delimiter //
Create procedure updateEnquete(in en_ide int(11), in en_nom varchar(30), in en_prenom varchar(30), in en_age int(2), in en_email varchar(50), in en_score int(2))
Begin
	update enquetes set nom = en_nom, prenom = en_prenom, age = en_age, email = en_email, score = en_score 
	where ide = en_ide;
End //
Delimiter ;

Drop procedure if exists deleteEnquete;
Delimiter //
Create procedure deleteEnquete(in en_ide int(11))
Begin
	delete from enquetes where ide = en_ide;
End //
Delimiter ;

Drop table if exists livres;
Create table if not exists livres (
	refl int(11) not null auto_increment,
	nom varchar(30) not null UNIQUE,
	auteur varchar(30) not null,
	disponible boolean,
	numt int(11),
	primary key (refl)
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin d'afficher le nom du train */
Create or replace view vlivres (refl, nom, auteur, disponible, numt, train)
as select l.refl, l.nom, l.auteur, l.disponible, l.numt, t.nom
from livres l inner join trains t
on l.numt = t.numt;

/* Création d'une table d'archive / d'historisation des livres */
Create table histoLivres as select *, sysdate() dateHeureAction, user() user, '__________' action
From livres
Where 2=0;

Drop trigger if exists HistoInsertLivre;
Delimiter //
Create trigger HistoInsertLivre
After insert on livres
For each row
Begin
	insert into histoLivres select *, sysdate(), user(), 'INSERT'
	from livres
	where refl = new.refl;
End //
Delimiter ;

Drop trigger if exists HistoUpdateLivre;
Delimiter //
Create trigger HistoUpdateLivre
Before update on livres
For each row
Begin
	insert into histoLivres select *, sysdate(), user(), 'UPDATE'
	from livres
	where refl = old.refl;
End //
Delimiter ;

Drop trigger if exists HistoDeleteLivre;
Delimiter //
Create trigger HistoDeleteLivre
Before delete on livres
For each row
Begin
	insert into histoLivres select *, sysdate(), user(), 'DELETE'
	from livres
	where refl = old.refl;
End //
Delimiter ;

/* Fonction qui permet de voir le nombre de doublons de nom saisi (si il n'est pas déjà utilisé) lors de l'insertion */
Drop function if exists countNomLivre;
Delimiter //
Create function countNomLivre(newnom varchar(30))
returns int
Begin
	select count(*) from livres where nom = newnom into @result;
	return @result;
End //
Delimiter ;

/* Trigger qui permet de savoir si le nom du livre existe ou non  */
Drop trigger if exists checkNomLivre;
Delimiter //
Create trigger checkNomLivre
Before insert on livres
For each row
Begin
	if countNomLivre(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Ce livre existe déjà';
	end if ;
End //
Delimiter ;

Drop procedure if exists insertLivre;
Delimiter //
Create procedure insertLivre(in l_nom varchar(30), in l_auteur varchar(30), in l_disponible boolean, in l_numt int(11))
Begin
	insert into livres values (null, l_nom, l_auteur, l_disponible, l_numt);
End //
Delimiter ;

Drop procedure if exists updateLivre;
Delimiter //
Create procedure updateLivre(in l_refl int(11), in l_nom varchar(30), in l_auteur varchar(30), in l_disponible boolean, in l_numt int(11))
Begin
	update livres set nom = l_nom, auteur = l_auteur, disponible = l_disponible, numt = l_numt
	where refl = l_refl;
End //
Delimiter ;

Drop procedure if exists deleteLivre;
Delimiter //
Create procedure deleteLivre(in l_nom varchar(30))
Begin
	delete from livres where nom = l_nom;
End //
Delimiter ;

Drop table if exists films;
Create table if not exists films (
	reff int(11) not null auto_increment,
	nom varchar(30) not null UNIQUE,
	realisateur varchar(30) not null,
	disponible boolean,
	numt int(11),
	primary key (reff)
) ENGINE=InnoDB, CHARSET=utf8;

/* Création d'une view afin d'afficher le nom du train */
Create or replace view vfilms (reff, nom, realisateur, disponible, numt, train)
as select f.reff, f.nom, f.realisateur, f.disponible, f.numt, t.nom
from films f inner join trains t
on f.numt = t.numt;

/* Création d'une table d'archive / d'historisation des films */
Create table histoFilms as select *, sysdate() dateHeureAction, user() user, '__________' action
From films
Where 2=0;

Drop trigger if exists HistoInsertFilm;
Delimiter //
Create trigger HistoInsertFilm
After insert on films
For each row
Begin
	insert into histoFilms select *, sysdate(), user(), 'INSERT'
	from films
	where reff = new.reff;
End //
Delimiter ;

Drop trigger if exists HistoUpdateFilm;
Delimiter //
Create trigger HistoUpdateFilm
Before update on films
For each row
Begin
	insert into histoFilms select *, sysdate(), user(), 'UPDATE'
	from films
	where reff = old.reff;
End //
Delimiter ;

Drop trigger if exists HistoDeleteFilm;
Delimiter //
Create trigger HistoDeleteFilm
Before delete on films
For each row
Begin
	insert into histoFilms select *, sysdate(), user(), 'DELETE'
	from films
	where reff = old.reff;
End //
Delimiter ;

Drop function if exists countNomFilm;
Delimiter //
Create function countNomFilm(newnom varchar(30))
returns int
Begin
	select count(*) from films where nom = newnom into @result;
	return @result;
End //
Delimiter ;

Drop trigger if exists checkNomFilm;
Delimiter //
Create trigger checkNomFilm
Before insert on films
For each row
Begin
	if countNomFilm(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Ce film existe déjà';
	end if ;
End //
Delimiter ;

Drop procedure if exists insertFilm;
Delimiter //
Create procedure insertFilm(in f_nom varchar(30), in f_realisateur varchar(30), in f_disponible boolean, in f_numt int(11))
Begin
	insert into films values (null, f_nom, f_realisateur, f_disponible, f_numt);
End //
Delimiter ;

Drop procedure if exists updateFilm;
Delimiter //
Create procedure updateFilm(in f_reff int(11), in f_nom varchar(30), in f_realisateur varchar(30), in f_disponible boolean, in f_numt int(11))
Begin
	update films set nom = f_nom, realisateur = f_realisateur, disponible = f_disponible, numt = f_numt
	where reff = f_reff;
End //
Delimiter ;

Drop procedure if exists deleteFilm;
Delimiter //
Create procedure deleteFilm(in f_nom varchar(30))
Begin
	delete from films where nom = f_nom;
End //
Delimiter ;
