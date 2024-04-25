DROP DATABASE netflix;

CREATE DATABASE netflix;
USE netflix;

CREATE TABLE movie(
   id INT PRIMARY KEY AUTO_INCREMENT,
   title VARCHAR(255),
   release_year DATE,
   description LONGTEXT,
   country VARCHAR(100),
   director_id INT NOT NULL
);

CREATE TABLE director(
   id INT NOT NULL AUTO_INCREMENT,
   lastname VARCHAR(255) NOT NULL,
   firstname VARCHAR(255) NOT NULL,
   PRIMARY KEY(id)
);

ALTER TABLE movie 
	ADD CONSTRAINT FK_movie_director
    FOREIGN KEY movie(director_id)
    REFERENCES director(id);
    
CREATE TABLE actor (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	lastname VARCHAR(255),
	firstname VARCHAR(255)
);


CREATE TABLE actor_movie (
	actor_id INT NOT NULL,
    movie_id INT NOT NULL,
    PRIMARY KEY (actor_id, movie_id)
);

ALTER TABLE actor_movie 
	ADD CONSTRAINT FK_actor_movie_movie
    FOREIGN KEY actor_movie(movie_id)
    REFERENCES movie(id);
    
ALTER TABLE actor_movie 
	ADD CONSTRAINT FK_actor_movie_actor
    FOREIGN KEY actor_movie(actor_id)
    REFERENCES actor(id);
    
    
CREATE TABLE viewing (
	id INT PRIMARY KEY AUTO_INCREMENT,
    date DATETIME NOT NULL,
    movie_id INT NOT NULL,
    user_id INT NOT NULL
);

CREATE TABLE User (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(50) NOT NULL
);


ALTER TABLE viewing
	ADD CONSTRAINT FK_viewing_movie
    FOREIGN KEY viewing (movie_id)
    REFERENCES movie (id);
    
ALTER TABLE viewing
	ADD CONSTRAINT FK_viewing_user
    FOREIGN KEY viewing (user_id)
    REFERENCES user (id);
    
    
    

CREATE TABLE import_netflix (
	show_id VARCHAR(250),
	type VARCHAR(250),
	title VARCHAR(250),
	director VARCHAR(250),
	cast TEXT,
	country VARCHAR(250),
	date VARCHAR(250),
	year VARCHAR(250),
	release_year VARCHAR(250),
	rating VARCHAR(250),
	duration VARCHAR(250),
	listed_in TEXT,
	description TEXT
);




