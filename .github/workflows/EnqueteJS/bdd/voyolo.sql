DROP DATABASE IF EXISTS voyolo;
CREATE DATABASE IF NOT EXISTS voyolo;
USE voyolo;

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (
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

CREATE OR REPLACE VIEW vusers (idu, nom, prenom, email, mdp, role, nbTentatives, nbConnexion, bloque, last_connexion, last_deconnexion, date_creation_compte)
AS SELECT idu, nom, prenom, email, mdp, role, nbTentatives, nbConnexion, bloque, date_format(last_connexion, '%d/%m/%Y %H:%i'), date_format(last_deconnexion, '%d/%m/%Y %H:%i'), date_format(date_creation_compte, '%d/%m/%Y %H:%i')
FROM users;

CREATE TABLE histoUsers AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM users
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertUser;
DELIMITER //
CREATE TRIGGER HistoInsertUser
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO histoUsers select *, sysdate(), user(), 'INSERT'
	FROM users
	WHERE idu = new.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateUser;
DELIMITER //
CREATE TRIGGER HistoUpdateUser
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
	INSERT INTO histoUsers select *, sysdate(), user(), 'UPDATE'
	FROM users
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteUser;
DELIMITER //
CREATE TRIGGER HistoDeleteUser
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
	INSERT INTO histoUsers select *, sysdate(), user(), 'DELETE'
	FROM users
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countEmailUser;
DELIMITER //
CREATE FUNCTION countEmailUser(newemail varchar(50))
RETURNS INT
BEGIN
	select count(*) FROM users WHERE email = newemail into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkEmailUser;
DELIMITER //
CREATE TRIGGER checkEmailUser
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	if countEmailUser(new.email)
		then signal sqlstate '45000'
		set message_text = 'Adresse email déjà utilisée !';
	end if ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS connexion;
DELIMITER //
CREATE PROCEDURE connexion(uemail varchar(50), mdp varchar(255))
BEGIN
	if (select mdp from users u where u.email = uemail) = mdp
		then
			update users u
			set u.nbConnexion = u.nbConnexion + 1,
			u.last_connexion = NOW()
			where u.email = uemail; 
	end if;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertUser;
DELIMITER //
CREATE PROCEDURE insertUser(in u_nom varchar(30), in u_prenom varchar(30), in u_email varchar(50), in u_mdp varchar(255), in u_role enum("client", "admin"))
BEGIN
	INSERT INTO users VALUES (null, u_nom, u_prenom, u_email, u_mdp, u_role, 0, 0, 0, sysdate(), sysdate(), sysdate());
END //
DELIMITER ;

call insertUser('BRUAIRE', 'Tom', 'tom@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', 'admin');
call insertUser('DESERT', 'Anais', 'anais@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', 'admin');
call insertUser('TAPI-DIMO', 'Winnie', 'winnie@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', 'admin');
call insertUser('TEST', 'Test', 'test@gmail.com', '107d348bff437c999a9ff192adcb78cb03b8ddc6', 'client');

DROP PROCEDURE IF EXISTS updateUser;
DELIMITER //
CREATE PROCEDURE updateUser(in u_nom varchar(30), in u_prenom varchar(30), in u_email varchar(50), in u_mdp varchar(255), in u_role enum("client", "admin"))
BEGIN
	UPDATE users SET nom = u_nom, prenom = u_prenom, email = u_email, mdp = u_mdp, role = u_role
	WHERE email = u_email;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteUser;
DELIMITER //
CREATE PROCEDURE deleteUser(in u_email varchar(50))
BEGIN
	delete FROM users WHERE email = u_email;
END //
DELIMITER ;

DROP TABLE IF EXISTS client;
CREATE TABLE IF NOT EXISTS client (
	idu int(11) not null,
	numcarte int(12) not null UNIQUE,
	date_expiration date not null,
	cvc int(3) not null,
	carte_avantage enum("Avantage Famille", "Avantage Week-End", "Avantage Jeune 12-27", "Avantage Senior 60+"),
	primary key (idu),
	foreign key (idu) references users (idu)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

CREATE TABLE histoClients AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM client
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertClient;
DELIMITER //
CREATE TRIGGER HistoInsertClient
AFTER INSERT ON client
FOR EACH ROW
BEGIN
	INSERT INTO histoClients select *, sysdate(), user(), 'INSERT'
	FROM client
	WHERE idu = new.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateClient;
DELIMITER //
CREATE TRIGGER HistoUpdateClient
BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
	INSERT INTO histoClients select *, sysdate(), user(), 'UPDATE'
	FROM client
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteClient;
DELIMITER //
CREATE TRIGGER HistoDeleteClient
BEFORE DELETE ON client
FOR EACH ROW
BEGIN
	INSERT INTO histoClients select *, sysdate(), user(), 'DELETE'
	FROM client
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countNumCarteClient;
DELIMITER //
CREATE FUNCTION countNumCarteClient(newnumcart varchar(50))
RETURNS INT
BEGIN
	select count(*) FROM client WHERE numcarte = newnumcart into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkNumCarteClient;
DELIMITER //
CREATE TRIGGER checkNumCarteClient
BEFORE INSERT ON client
FOR EACH ROW
BEGIN
	if countNumCarteClient(new.numcarte)
		then signal sqlstate '45000'
		set message_text = 'Numéro de carte déjà utilisée !';
	end if ;
END //
DELIMITER ;

DROP TABLE IF EXISTS admin;
CREATE TABLE IF NOT EXISTS admin (
	idu int(11) not null,
	email varchar(50) not null UNIQUE,
	mdp varchar(255) not null,
	date_connexion date,
	primary key (idu),
	foreign key (idu) references users (idu)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

CREATE TABLE histoAdmins AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM admin
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertAdmin;
DELIMITER //
CREATE TRIGGER HistoInsertAdmin
AFTER INSERT ON admin
FOR EACH ROW
BEGIN
	INSERT INTO histoAdmins select *, sysdate(), user(), 'INSERT'
	FROM admin
	WHERE idu = new.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateAdmin;
DELIMITER //
CREATE TRIGGER HistoUpdateAdmin
BEFORE UPDATE ON admin
FOR EACH ROW
BEGIN
	INSERT INTO histoAdmins select *, sysdate(), user(), 'UPDATE'
	FROM admin
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteAdmin;
DELIMITER //
CREATE TRIGGER HistoDeleteAdmin
BEFORE DELETE ON admin
FOR EACH ROW
BEGIN
	INSERT INTO histoAdmins select *, sysdate(), user(), 'DELETE'
	FROM admin
	WHERE idu = old.idu;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countEmailAdmin;
DELIMITER //
CREATE FUNCTION countEmailAdmin(newemail varchar(50))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM admin WHERE email = newemail into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkEmailAdmin;
DELIMITER //
CREATE TRIGGER checkEmailAdmin
BEFORE INSERT ON admin
FOR EACH ROW
BEGIN
	if countEmailAdmin(new.email)
		then signal sqlstate '45000'
		set message_text = 'Adresse email déjà utilisée !';
	end if ;
END //
DELIMITER ;

INSERT INTO admin VALUES
(1, "tom@gmail.com", "107d348bff437c999a9ff192adcb78cb03b8ddc6", sysdate()),
(2, "anais@gmail.com", "107d348bff437c999a9ff192adcb78cb03b8ddc6", sysdate()),
(3, "winnie@gmail.com", "107d348bff437c999a9ff192adcb78cb03b8ddc6", sysdate());

DROP TABLE IF EXISTS commentaires;
CREATE TABLE IF NOT EXISTS commentaires (
	idcom int(11) not null auto_increment,
	contenu varchar(255) not null,
	idu int(11) not null,
	date_heure_post datetime,
	lu int not null default 0,
	primary key (idcom),
	foreign key (idu) references users (idu)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

CREATE TABLE histoCommentaires AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM commentaires
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertCommentaire;
DELIMITER //
CREATE TRIGGER HistoInsertCommentaire
AFTER INSERT ON commentaires
FOR EACH ROW
BEGIN
	INSERT INTO histoCommentaires select *, sysdate(), user(), 'INSERT'
	FROM commentaires
	WHERE idcom = new.idcom;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateCommentaire;
DELIMITER //
CREATE TRIGGER HistoUpdateCommentaire
BEFORE UPDATE ON commentaires
FOR EACH ROW
BEGIN
	INSERT INTO histoCommentaires select *, sysdate(), user(), 'UPDATE'
	FROM commentaires
	WHERE idcom = old.idcom;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteCommentaire;
DELIMITER //
CREATE TRIGGER HistoDeleteCommentaire
BEFORE DELETE ON commentaires
FOR EACH ROW
BEGIN
	INSERT INTO histoCommentaires select *, sysdate(), user(), 'DELETE'
	FROM commentaires
	WHERE idcom = old.idcom;
END //
DELIMITER ;

DROP TABLE IF EXISTS trains;
CREATE TABLE IF NOT EXISTS trains (
	numtrain int(11) not null auto_increment,
	nom varchar(50) not null UNIQUE,
	nbwagon int(2) not null,
	nbplaces int(11) not null,
	date_creation_train date,
	primary key (numtrain)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW vtrains (numtrain, nom, nbwagon, nbplaces, date_creation_train)
AS SELECT numtrain, nom, nbwagon, nbplaces, date_format(date_creation_train, '%d/%m/%Y')
FROM trains;

CREATE TABLE histoTrains AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM trains
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertTrain;
DELIMITER //
CREATE TRIGGER HistoInsertTrain
AFTER INSERT ON trains
FOR EACH ROW
BEGIN
	INSERT INTO histoTrains select *, sysdate(), user(), 'INSERT'
	FROM trains
	WHERE numtrain = new.numtrain;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateTrain;
DELIMITER //
CREATE TRIGGER HistoUpdateTrain
BEFORE UPDATE ON trains
FOR EACH ROW
BEGIN
	INSERT INTO histoTrains select *, sysdate(), user(), 'UPDATE'
	FROM trains
	WHERE numtrain = old.numtrain;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteTrain;
DELIMITER //
CREATE TRIGGER HistoDeleteTrain
BEFORE DELETE ON trains
FOR EACH ROW
BEGIN
	INSERT INTO histoTrains select *, sysdate(), user(), 'DELETE'
	FROM trains
	WHERE numtrain = old.numtrain;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countTrainName;
DELIMITER //
CREATE FUNCTION countTrainName(newnom varchar(50))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM users WHERE nom = newnom into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkNameTrain;
DELIMITER //
CREATE TRIGGER checkNameTrain
BEFORE INSERT ON trains
FOR EACH ROW
BEGIN
	if countTrainName(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Nom de train déjà utilisé !';
	end if ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertTrain;
DELIMITER //
CREATE PROCEDURE insertTrain(in t_nom varchar(50), in t_nbwagon int(2), in t_nbplaces int(11))
BEGIN
	INSERT INTO users VALUES (null, t_nom, t_nbwagon, t_nbplaces, curdate());
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateTrain;
DELIMITER //
CREATE PROCEDURE updateTrain(in t_nom varchar(50), in t_nbwagon int(2), in t_nbplaces int(11))
BEGIN
	UPDATE trains SET nom = t_nom, nbwagon = t_nbwagon, nbplaces = t_nbplaces
	WHERE nom = t_nom;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteTrain;
DELIMITER //
CREATE PROCEDURE deleteTrain(in t_nom varchar(50))
BEGIN
	DELETE FROM trains WHERE nom = t_nom;
END //
DELIMITER ;

DROP TABLE IF EXISTS pays;
CREATE TABLE IF NOT EXISTS pays (
	idPays int(20) NOT NULL AUTO_INCREMENT,
	nomPays varchar(50) NOT NULL,
	energiePays varchar(50) NOT NULL,
	PRIMARY KEY(idPays)
)ENGINE=innodb DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS trajets;
CREATE TABLE IF NOT EXISTS trajets (
	idtrajet int(11) not null auto_increment,
	numtrain int(11) not null,
	depart varchar(30) not null,
	date_depart date,
	heure_depart time,
	destination varchar(30) not null,
	date_arrive date,
	heure_arrive time,
	duree_trajet time,
	prix decimal(6,2) not null,
	quai varchar(30) not null,
	idPays int(20) not null,
	primary key (idtrajet),
	foreign key (numtrain) references trains (numtrain)
	on update cascade
	on delete cascade,
	foreign key (idPays) references pays (idPays)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW vtrajets (idtrajet, numtrain, depart, date_depart, heure_depart, destination, date_arrive, heure_arrive, duree_trajet, prix, quai, idPays)
AS SELECT idtrajet, numtrain, depart, date_format(date_depart, '%d/%m/%Y'), date_format(heure_depart, 'H:i'), destination, date_format(date_arrive, '%d/%m/%Y'), date_format(heure_arrive, 'H:i'), date_format(duree_trajet, 'H:i'), prix, quai, idPays
FROM trajets;

CREATE TABLE histoTrajets AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM trajets
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertTrajet;
DELIMITER //
CREATE TRIGGER HistoInsertTrajet
AFTER INSERT ON trajets
FOR EACH ROW
BEGIN
	INSERT INTO histoTrajets select *, sysdate(), user(), 'INSERT'
	FROM trajets
	WHERE idtrajet = new.idtrajet;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateTrajet;
DELIMITER //
CREATE TRIGGER HistoUpdateTrajet
BEFORE UPDATE ON trajets
FOR EACH ROW
BEGIN
	INSERT INTO histoTrajets select *, sysdate(), user(), 'UPDATE'
	FROM trajets
	WHERE idtrajet = old.idtrajet;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteTrajet;
DELIMITER //
CREATE TRIGGER HistoDeleteTrajet
BEFORE DELETE ON trajets
FOR EACH ROW
BEGIN
	INSERT INTO histoTrajets select *, sysdate(), user(), 'DELETE'
	FROM trajets
	WHERE idtrajet = old.idtrajet;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertTrajet;
DELIMITER //
CREATE PROCEDURE insertTrajet(in trj_numtrain int(11), in trj_depart varchar(30), in trj_date_depart date, in trj_heure_depart time, in trj_destination varchar(30), in trj_date_arrive date, in trj_heure_arrive time, in trj_duree_trajet time, in trj_prix decimal(6,2), in trj_quai varchar(30), in trj_idPays int(20))
BEGIN
	INSERT INTO trajets VALUES (null, trj_numtrain, trj_depart, trj_date_depart, trj_heure_depart, trj_destination, trj_date_arrive, trj_heure_arrive, trj_duree_trajet, trj_prix, trj_quai, trj_idPays);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateTrajet;
DELIMITER //
CREATE PROCEDURE updateTrajet(in trj_idt int(11), in trj_numtrain int(11), in trj_depart varchar(30), in trj_date_depart date, in trj_heure_depart time, in trj_destination varchar(30), in trj_date_arrive date, in trj_heure_arrive time, in trj_duree_trajet time, in trj_prix decimal(6,2), in trj_quai varchar(30), in trj_idPays int(20))
BEGIN
	UPDATE trajets SET numtrain = trj_numtrain, depart = trj_depart, date_depart = trj_date_depart, heure_depart = trj_heure_depart, destination = trj_destination, date_arrive = trj_date_arrive, heure_arrive = trj_heure_arrive, duree_trajet = trj_duree_trajet, prix = trj_prix, quai = trj_quai,
	idPays = trj_idPays
	WHERE idtrajet = trj_idt;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteTrajet;
DELIMITER //
CREATE PROCEDURE deleteTrajet(in trj_idt int(11))
BEGIN
	DELETE FROM trajets WHERE idtrajet = trj_idt;
END //
DELIMITER ;

DROP TABLE IF EXISTS reservations;
CREATE TABLE IF NOT EXISTS reservations (
	idr int(11) not null auto_increment,
	idu int(11) not null,
	numtrain int(11) not null,
	date_reservation datetime,
	primary key (idr),
	foreign key (idu) references users (idu)
	on update cascade
	on delete cascade,
	foreign key (numtrain) references trains (numtrain)
	on update cascade
	on delete cascade
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW vreservations (idr, idu, numtrain, date_reservation)
AS SELECT idr, idu, numtrain, date_format(date_reservation, '%d/%m/%Y H:i')
FROM reservations;

CREATE TABLE histoReservations AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM reservations
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertReservation;
DELIMITER //
CREATE TRIGGER HistoInsertReservation
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
	INSERT INTO histoReservations select *, sysdate(), user(), 'INSERT'
	FROM reservations
	WHERE idr = new.idr;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateReservation;
DELIMITER //
CREATE TRIGGER updateReservation
BEFORE UPDATE ON reservations
FOR EACH ROW
BEGIN
	INSERT INTO histoReservations select *, sysdate(), user(), 'UPDATE'
	FROM reservations
	WHERE idr = old.idr;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteReservation;
DELIMITER //
CREATE TRIGGER deleteReservation
BEFORE DELETE ON reservations
FOR EACH ROW
BEGIN
	INSERT INTO histoReservations select *, sysdate(), user(), 'DELETE'
	FROM reservations
	WHERE idr = old.idr;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertReservation;
DELIMITER //
CREATE PROCEDURE insertReservation(in r_idu int(11), in r_numtrain int(11), in r_date_reservation datetime)
BEGIN
	INSERT INTO reservations VALUES (null, r_idu, r_numtrain, r_date_reservation);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateReservation;
DELIMITER //
CREATE PROCEDURE updateReservation(in r_idr int(11), in r_idu int(11), in r_numtrain int(11), in r_date_reservation datetime)
BEGIN
	UPDATE reservations SET idu = r_idu, numtrain = r_numtrain, date_reservation = r_date_reservation
	WHERE idr = r_idr;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteReservation;
DELIMITER //
CREATE PROCEDURE deleteReservation(in r_idr int(11))
BEGIN
	DELETE FROM reservations WHERE idr = r_idr;
END //
DELIMITER ;

DROP TABLE IF EXISTS energies;
CREATE TABLE IF NOT EXISTS energies (
	numtrain int(11),
	energie int(11),
	primary key (numtrain),
	foreign key (numtrain) references trains (numtrain)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW venergies (numtrain, energie, train)
AS SELECT e.numtrain, e.energie, t.nom
FROM energies e INNER JOIN trains t
ON e.numtrain = t.numtrain;

CREATE TABLE histoEnergies AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM energies
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertEnergie;
DELIMITER //
CREATE TRIGGER HistoInsertEnergie
AFTER INSERT ON energies
FOR EACH ROW
BEGIN
	INSERT INTO histoEnergies select *, sysdate(), user(), 'INSERT'
	FROM energies
	WHERE numtrain = new.numtrain;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateEnergies;
DELIMITER //
CREATE TRIGGER HistoUpdateEnergies
BEFORE UPDATE ON energies
FOR EACH ROW
BEGIN
	INSERT INTO histoEnergies select *, sysdate(), user(), 'UPDATE'
	FROM energies
	WHERE numtrain = old.numtrain;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteEnergie;
DELIMITER //
CREATE TRIGGER HistoDeleteEnergie
BEFORE DELETE ON energies
FOR EACH ROW
BEGIN
	INSERT INTO histoEnergies select *, sysdate(), user(), 'DELETE'
	FROM energies
	WHERE numtrain = old.numtrain;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertEnergie;
DELIMITER //
CREATE PROCEDURE insertEnergie(in e_numtrain int(11), in e_energie int(11))
BEGIN
	INSERT INTO energies VALUES (null, e_numtrain, e_energie);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateEnergie;
DELIMITER //
CREATE PROCEDURE updateEnergie(in e_numtrain int(11), in e_energie int(11))
BEGIN
	UPDATE energies SET energie = e_energie WHERE numtrain = e_numtrain;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteEnergie;
DELIMITER //
CREATE PROCEDURE deleteEnergie(in e_numtrain int(11))
BEGIN
	DELETE FROM energies WHERE numtrain = e_numtrain;
END //
DELIMITER ;

DROP TABLE IF EXISTS enquetes;
CREATE TABLE IF NOT EXISTS enquetes (
	ide int(11) not null auto_increment,
	sexe enum("Femme", "Homme", "Non préciser"),
	nom varchar(30) not null,
	prenom varchar(30) not null,
	age enum("0-18", "19-35", "36-62", "63 ans et plus"),
	datenaissance varchar(10) not null,
	email varchar(50) not null UNIQUE,
	tel varchar(10) not null UNIQUE,
	adresse varchar(100) not null,
	type enum("visiteur", "client", "admin"),
	score decimal(6,2) not null default 0,
	primary key (ide)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE TABLE histoEnquetes AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM enquetes
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertEnquete;
DELIMITER //
CREATE TRIGGER HistoInsertEnquete
AFTER INSERT ON enquetes
FOR EACH ROW
BEGIN
	INSERT INTO histoEnquetes select *, sysdate(), user(), 'INSERT'
	FROM enquetes
	WHERE ide = new.ide;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateEnquete;
DELIMITER //
CREATE TRIGGER HistoUpdateEnquete
BEFORE UPDATE ON enquetes
FOR EACH ROW
BEGIN
	INSERT INTO histoEnquetes select *, sysdate(), user(), 'UPDATE'
	FROM enquetes
	WHERE ide = old.ide;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteEnquete;
DELIMITER //
CREATE TRIGGER HistoDeleteEnquete
BEFORE DELETE ON enquetes
FOR EACH ROW
BEGIN
	INSERT INTO histoEnquetes select *, sysdate(), user(), 'DELETE'
	FROM enquetes
	WHERE ide = old.ide;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countEmailEnquete;
DELIMITER //
CREATE FUNCTION countEmailEnquete(newemail varchar(50))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM enquetes WHERE email = newemail into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkEmailEnquete;
DELIMITER //
CREATE TRIGGER checkEmailEnquete
BEFORE INSERT ON enquetes
FOR EACH ROW
BEGIN
	if countEmailEnquete(new.email)
		then signal sqlstate '45000'
		set message_text = 'Adresse email déjà utilisée !';
	end if ;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countTelEnquete;
DELIMITER //
CREATE FUNCTION countTelEnquete(newtel varchar(50))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM enquetes WHERE tel = newtel into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkTelEnquete;
DELIMITER //
CREATE TRIGGER checkTelEnquete
BEFORE INSERT ON enquetes
FOR EACH ROW
BEGIN
	if countTelEnquete(new.tel)
		then signal sqlstate '45000'
		set message_text = 'Numéro de téléphone déjà utilisé !';
	end if ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertEnquete;
DELIMITER //
CREATE PROCEDURE insertEnquete(in en_nom varchar(30), in en_prenom varchar(30), in en_age int(2), in en_email varchar(50), in en_tel varchar(10), in en_datenaissance varchar(10), in en_type enum("visiteur", "client", "admin"), in en_score int(2))
BEGIN
	INSERT INTO enquetes VALUES (null, en_nom, en_prenom, en_age, en_email, en_tel, en_datenaissance, en_type, en_score);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateEnquete;
DELIMITER //
CREATE PROCEDURE updateEnquete(in en_ide int(11), in en_nom varchar(30), in en_prenom varchar(30), in en_age int(2), in en_email varchar(50), in en_tel varchar(10), in en_datenaissance varchar(10), in en_type enum("visiteur", "client", "admin"), in en_score int(2))
BEGIN
	UPDATE enquetes SET nom = en_nom, prenom = en_prenom, age = en_age, email = en_email, tel = en_tel, datenaissance = en_datenaissance, type = en_type, score = en_score 
	WHERE ide = en_ide;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteEnquete;
DELIMITER //
CREATE PROCEDURE deleteEnquete(in en_ide int(11))
BEGIN
	DELETE FROM enquetes WHERE ide = en_ide;
END //
DELIMITER ;

DROP TABLE IF EXISTS livres;
CREATE TABLE IF NOT EXISTS livres (
	refl int(11) not null auto_increment,
	nom varchar(30) not null UNIQUE,
	auteur varchar(30) not null,
	disponible boolean,
	numtrain int(11),
	primary key (refl)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW vlivres (refl, nom, auteur, disponible, numtrain, train)
AS SELECT l.refl, l.nom, l.auteur, l.disponible, l.numtrain, t.nom
FROM livres l INNER JOIN trains t
ON l.numtrain = t.numtrain;

CREATE TABLE histoLivres AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM livres
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertLivre;
DELIMITER //
CREATE TRIGGER HistoInsertLivre
AFTER INSERT ON livres
FOR EACH ROW
BEGIN
	INSERT INTO histoLivres select *, sysdate(), user(), 'INSERT'
	FROM livres
	WHERE refl = new.refl;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateLivre;
DELIMITER //
CREATE TRIGGER HistoUpdateLivre
BEFORE UPDATE ON livres
FOR EACH ROW
BEGIN
	INSERT INTO histoLivres select *, sysdate(), user(), 'UPDATE'
	FROM livres
	WHERE refl = old.refl;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteLivre;
DELIMITER //
CREATE TRIGGER HistoDeleteLivre
BEFORE DELETE ON livres
FOR EACH ROW
BEGIN
	INSERT INTO histoLivres select *, sysdate(), user(), 'DELETE'
	FROM livres
	WHERE refl = old.refl;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countNomLivre;
DELIMITER //
CREATE FUNCTION countNomLivre(newnom varchar(30))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM livres WHERE nom = newnom into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkNomLivre;
DELIMITER //
CREATE TRIGGER checkNomLivre
BEFORE INSERT ON livres
FOR EACH ROW
BEGIN
	if countNomLivre(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Ce livre existe déjà';
	end if ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertLivre;
DELIMITER //
CREATE PROCEDURE insertLivre(in l_nom varchar(30), in l_auteur varchar(30), in l_disponible boolean, in l_numtrain int(11))
BEGIN
	INSERT INTO livres VALUES (null, l_nom, l_auteur, l_disponible, l_numtrain);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateLivre;
DELIMITER //
CREATE PROCEDURE updateLivre(in l_refl int(11), in l_nom varchar(30), in l_auteur varchar(30), in l_disponible boolean, in l_numtrain int(11))
BEGIN
	UPDATE livres SET nom = l_nom, auteur = l_auteur, disponible = l_disponible, numtrain = l_numtrain
	WHERE refl = l_refl;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteLivre;
DELIMITER //
CREATE PROCEDURE deleteLivre(in l_nom varchar(30))
BEGIN
	DELETE FROM livres WHERE nom = l_nom;
END //
DELIMITER ;

DROP TABLE IF EXISTS films;
CREATE TABLE IF NOT EXISTS films (
	reff int(11) not null auto_increment,
	nom varchar(30) not null UNIQUE,
	realisateur varchar(30) not null,
	disponible boolean,
	numtrain int(11),
	primary key (reff)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE OR REPLACE VIEW vfilms (reff, nom, realisateur, disponible, numtrain, train)
AS SELECT f.reff, f.nom, f.realisateur, f.disponible, f.numtrain, t.nom
FROM films f INNER JOIN trains t
ON f.numtrain = t.numtrain;

CREATE TABLE histoFilms AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM films
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertFilm;
DELIMITER //
CREATE TRIGGER HistoInsertFilm
AFTER INSERT ON films
FOR EACH ROW
BEGIN
	INSERT INTO histoFilms select *, sysdate(), user(), 'INSERT'
	FROM films
	WHERE reff = new.reff;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateFilm;
DELIMITER //
CREATE TRIGGER HistoUpdateFilm
BEFORE UPDATE ON films
FOR EACH ROW
BEGIN
	INSERT INTO histoFilms select *, sysdate(), user(), 'UPDATE'
	FROM films
	WHERE reff = old.reff;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteFilm;
DELIMITER //
CREATE TRIGGER HistoDeleteFilm
BEFORE DELETE ON films
FOR EACH ROW
BEGIN
	INSERT INTO histoFilms select *, sysdate(), user(), 'DELETE'
	FROM films
	WHERE reff = old.reff;
END //
DELIMITER ;

DROP FUNCTION IF EXISTS countNomFilm;
DELIMITER //
CREATE FUNCTION countNomFilm(newnom varchar(30))
RETURNS INT
BEGIN
	SELECT COUNT(*) FROM films WHERE nom = newnom into @result;
	return @result;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS checkNomFilm;
DELIMITER //
CREATE TRIGGER checkNomFilm
BEFORE INSERT ON films
FOR EACH ROW
BEGIN
	if countNomFilm(new.nom)
		then signal sqlstate '45000'
		set message_text = 'Ce film existe déjà';
	end if ;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS insertFilm;
DELIMITER //
CREATE PROCEDURE insertFilm(in f_nom varchar(30), in f_realisateur varchar(30), in f_disponible boolean, in f_numtrain int(11))
BEGIN
	INSERT INTO films VALUES (null, f_nom, f_realisateur, f_disponible, f_numtrain);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateFilm;
DELIMITER //
CREATE PROCEDURE updateFilm(in f_reff int(11), in f_nom varchar(30), in f_realisateur varchar(30), in f_disponible boolean, in f_numtrain int(11))
BEGIN
	UPDATE films SET nom = f_nom, realisateur = f_realisateur, disponible = f_disponible, numtrain = f_numtrain
	WHERE reff = f_reff;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteFilm;
DELIMITER //
CREATE PROCEDURE deleteFilm(in f_nom varchar(30))
BEGIN
	DELETE FROM films WHERE nom = f_nom;
END //
DELIMITER ;

DROP TABLE IF EXISTS transports;
CREATE TABLE IF NOT EXISTS transports (
	idtransport int(11) not null auto_increment,
	typetransport enum("routier", "ferroviaire", "fluvial", "maritime", "multimodal"),
	-- à compléter...
	primary key (idtransport)
) ENGINE=InnoDB, CHARSET=utf8;

CREATE TABLE histoTransports AS SELECT *, sysdate() dateHeureAction, user() user, '__________' action
FROM transports
WHERE 2=0;

DROP TRIGGER IF EXISTS HistoInsertTransport;
DELIMITER //
CREATE TRIGGER HistoInsertTransport
AFTER INSERT ON transports
FOR EACH ROW
BEGIN
	INSERT INTO histoTransports select *, sysdate(), user(), 'INSERT'
	FROM transports
	WHERE idtransport = new.idtransport;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoUpdateTransport;
DELIMITER //
CREATE TRIGGER HistoUpdateTransport
BEFORE UPDATE ON transports
FOR EACH ROW
BEGIN
	INSERT INTO histoTransports select *, sysdate(), user(), 'UPDATE'
	FROM transports
	WHERE idtransport = old.idtransport;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS HistoDeleteTransport;
DELIMITER //
CREATE TRIGGER HistoDeleteTransport
BEFORE DELETE ON transports
FOR EACH ROW
BEGIN
	INSERT INTO histoTransports select *, sysdate(), user(), 'DELETE'
	FROM transports
	WHERE idtransport = old.idtransport;
END //
DELIMITER ;


/*** Anais ***/
DROP TABLE IF EXISTS groupe;
CREATE TABLE IF NOT EXISTS groupe (
    grp_id INT(11) NOT NULL AUTO_INCREMENT,
    nom_grp VARCHAR (40) NOT NULL,
    prenom_grp VARCHAR(40) NOT NULL,
    type_grp TEXT,
    date_heure_depart DATETIME,
    PRIMARY KEY (grp_id)
) ENGINE=InnoDB, CHARSET=utf8;

DROP TABLE IF EXISTS factures;
CREATE TABLE IF NOT EXISTS factures (
    fac_id INT(11) NOT NULL AUTO_INCREMENT,
    numero_facture BIGINT,
    date_facture DATETIME,
    PRIMARY KEY (fac_id)
) ENGINE=InnoDB, CHARSET=utf8;

DROP TABLE IF EXISTS promotions;
CREATE TABLE IF NOT EXISTS promotions (
    promo_id INT(11) NOT NULL AUTO_INCREMENT,
    pourcentage_promo int(2),
    PRIMARY KEY (promo_id)
) ENGINE=InnoDB, CHARSET=utf8;

/*** Winnie ***/
DROP TABLE IF EXISTS gare;
CREATE TABLE IF NOT EXISTS gare (
	idGare int (20) NOT NULL AUTO_INCREMENT,
	typeGare varchar(50)NOT NULL,  
	nomGare varchar(50)NOT NULL,
	paysGare varchar(50)NOT NULL,
	villeGare varchar(50)NOT NULL,       
	PRIMARY KEY(idGare)
)ENGINE=innodb DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS promotions;
CREATE TABLE IF NOT EXISTS promotions (
	numPromotion int(15) NOT NULL AUTO_INCREMENT,
	datedebutPromotion date NOT NULL,
	datefinPromotion date NOT NULL,
	pourcentagePromotion int (10)NOT NULL,   
	PRIMARY KEY (numPromotion)
)ENGINE=innodb DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS services;
CREATE TABLE IF NOT EXISTS services (
	idServices int(15) NOT NULL AUTO_INCREMENT,
	nomServices varchar (30) NOT NULL,
	typeServices varchar (30) NOT NULL,
	reff int(11) not null, -- films
	refl int(11) not null, -- livres
	idtransport int(11) not null, -- transports
	PRIMARY KEY (idServices),
	foreign key (reff) references films (reff)
	on update cascade
	on delete cascade,
	foreign key (refl) references livres (refl)
	on update cascade
	on delete cascade,
	foreign key (idtransport) references transports (idtransport)
	on update cascade
	on delete cascade
)ENGINE=innodb DEFAULT CHARSET=latin1;

/*
delimiter //
create trigger HeServices
before insert on services
for each row
begin
declare L int ;
declare F int ;
declare C int;
select count(*) into L
from livre
where idservcie = new.idservice;
if a = 0
then
insert into adherent values (new.idservice, new.nom, new.type ...);
end if ;
select count(*) into F
from film
where idfilm = new.idfilm ;
if F > 0
then
signal sqlstate '45000'
set message_text = 'ce service existe déja';
end if;
select count(*) into C
from consommation
where idconsommation = new.idconsommation ;
if C > 0
then
signal sqlstate '45000'
set message_text = 'ce service existe déja';
end if;
end//
*/

DROP TABLE IF EXISTS questions;
CREATE TABLE IF NOT EXISTS questions (
	idquestion int(11) not null auto_increment,
	enonce varchar(255) not null UNIQUE,
	primary key (idquestion)
) ENGINE=InnoDB, CHARSET=utf8;

INSERT INTO questions VALUES
(1, "Qu'aimez vous le plus dans notre service ?"),
(2, "Quelles fonctionnalitées pourrions-nous rajouter pour l'améliorer ?"),
(3, "A quelle fréquence reservez vous des trains ?"),
(4, "Comment nous avez vous connu ?"),
(5, "Sur une échelle de 0 à 10, quelle est note attribuez-vous à nos service ?"),
(6, "Sur une échelle de 0 à 10, quelle est la probabilité que vous recommandiez notre entreprise à un ami / à un collègue / à votre famile ?"),
(7, "Quelles services est indispensable selon vous ?"),
(8, "Toutes les informations dans le site sont-t-elle en accord avec la réalité ?"),
(9, "Êtes-vous satisfait des réductions et offres porposés ?"),
(10, "Êtes-vous satisfait du voyage effectué ?"),
(11, "Quelle type de trajet préférez-vous réserver ?"),
(12, "Votre avis sur le service nous intéresse");


