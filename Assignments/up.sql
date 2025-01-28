CREATE DATABASE social_media_feed;
\c social_media_feed
CREATE TYPE gender_enum AS enum('male', 'female');
CREATE TYPE language_enum AS enum('en', 'fr');
CREATE TYPE status_enum AS enum('active', 'banned');
CREATE TYPE reaction_enum AS enum('like', 'dislike');
CREATE TYPE state_enum AS enum('active', 'deleted');
CREATE TYPE type_enum AS enum(picture, video, text);

CREATE TABLE "users" (
  id SERIAL PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  gender  gender_enum,
  email  varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  language  language_enum,
  proffession varchar(50),
  location  varchar(50) NOT NULL,
  status status_enum,
  number_of_post integer,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (id,name,gender,email ,password,language ,proffession,location ,status, number_of_post,created_at )
VALUES
  (1,'lois','female','ultrices.vivamus.rhoncus@protonmail.org','TDX64OPZ4HN','en','doctor','North','active',7, CURRENT_TIMESTAMP),
  (2,'desmond','male','egestas.hendrerit.neque@icloud.com','SUD12TTD7RH','en','cook','west','banned',50, CURRENT_TIMESTAMP),
  (3,'fiath','female','eros.nam.consequat@google.net','LXN75TFA8PW','en','teacher','south','banned',32, CURRENT_TIMESTAMP),
  (4,'joy','female','imperdiet.non@yahoo.net','QST27OTL8YP','fr','student','south','banned',39, CURRENT_TIMESTAMP),
  (5,'james','male','consectetuer.ipsum@protonmail.net','KIV42EGP4LY','fr','student','east','active',12, CURRENT_TIMESTAMP);

CREATE TABLE "following"(
   id SERIAL PRIMARY KEY NOT NULL, 
   user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id),  
   follower_id INT NOT NULL,  FOREIGN KEY(follow_id) REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

INSERT INTO following(id, user_id, follower_id, created_at )
VALUES
   (1, 5, 4, CURRENT_TIMESTAMP),
   (2, 4, 5, CURRENT_TIMESTAMP),
   (3, 1, 2, CURRENT_TIMESTAMP),
   (4, 2, 3, CURRENT_TIMESTAMP),
   (5, 1, 1, CURRENT_TIMESTAMP);   

CREATE TABLE "interest"(
    id SERIAL PRIMARY NOT NULL,
    interest VARCHAR(150)
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);

INSERT INTO interest(id, interest, created_at)
VALUES
    (1, 'coding', CURRENT_TIMESTAMP),
    (2, 'games', CURRENT_TIMESTAMP);
    (3, 'dance', CURRENT_TIMESTAMP);
    (4, 'fun', CURRENT_TIMESTAMP);
    (5, 'science', CURRENT_TIMESTAMP);    

CREATE TABLE "category"(
    id SERIAL PRIMARY KEY NOT NULL, 
    user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id),
    interest_id INT NOT NULL,  FOREIGN KEY(interest_id) REFERENCES interest(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO category(id, user_id, interest_id, created_at)
VALUES
   (1, 5, 4, CURRENT_TIMESTAMP),
   (2, 4, 3, CURRENT_TIMESTAMP),
   (3, 3, 5 CURRENT_TIMESTAMP),
   (4, 2, 2, CURRENT_TIMESTAMP),
   (5, 1, 1, CURRENT_TIMESTAMP);

CREATE TABLE "post"(
 id SERIAL PRIMARY KEY NOT NULL, 
 user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id), 
 interest_id INT NOT NULL,  FOREIGN KEY(interest_id) REFERENCES interest(id),
 description VARCHAR(150), 
 type type_enum, 
 number_of_shares INT NOT NULL, 
 number_of_likes INT NOT NULL, 
 number_of_comment INT DEFAULT 0, 
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO post(id, user_id , interest_id, description, type, number_of_shares,number_of_likes,number_of_comment, created_at )
VALUES
  (1,5,4,'male ','picture',33,30,99, CURRENT_TIMESTAMP),
  (2,4,5,'male ','text',19,32,73, CURRENT_TIMESTAMP),
  (3,2,3,'male ','picture',46,72,17, CURRENT_TIMESTAMP),
  (4,3,1,'male ','video',26,34,25,CURRENT_TIMESTAMP),
  (5,1,2,'male ','picture',16,7,48,CURRENT_TIMESTAMP);

  CREATE TABLE "comments"(id SERIAL PRIMARY KEY NOT NULL, 
   user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id), 
   post_id INT NOT NULL, FOREIGN KEY(post_id) REFERENCES post(id), 
   number_of_likes INT DEFAULT 0, 
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  INSERT INTO comments(id,user_id ,post_id,number_of_likes,created_at )
VALUES
  (1,1,1,30,CURRENT_TIMESTAMP),
  (2,2,2,32,CURRENT_TIMESTAMP),
  (3,3,2,72,CURRENT_TIMESTAMP),
  (4,4,4,34,CURRENT_TIMESTAMP),
  (5,1,3,7,'Aug 30, 2025');

  CREATE TABLE "reaction"(
    id SERIAL PRIMARY KEY NOT NULL, 
    user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id), 
    post_id INT NOT NULL, FOREIGN KEY(post_id) REFERENCES post(id), 
    comment_id INT NOT NULL, FOREIGN KEY(comment_id) REFERENCES comments(id), 
    reaction reaction_enum, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  INSERT INTO reaction (id,user_id ,post_id,comment_id,reaction,created_at)
VALUES
  (1,1,1,30,'like',CURRENT_TIMESTAMP),
  (2,3,2,32,'like',CURRENT_TIMESTAMP),
  (3,3,4,72,'like',CURRENT_TIMESTAMP),
  (4,4,5,34,'dislike',CURRENT_TIMESTAMP),
  (5,1,3,7,'like',CURRENT_TIMESTAMP);

CREATE TABLE post_state(id SERIAL PRIMARY KEY NOT NULL, 
 user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id), 
 post_id INT NOT NULL, FOREIGN KEY(post_id) REFERENCES post(id), 
 state state_enum, 
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO post_state(id,user_id ,post_id,state,created_at)
VALUES
  (1,1,4,'active',CURRENT_TIMESTAMP),
  (2,4,5,'deleted',CURRENT_TIMESTAMP),
  (3,5,1,'deleted',CURRENT_TIMESTAMP),
  (4,3,2,'deleted',CURRENT_TIMESTAMP),
  (5,3,3,'deleted',CURRENT_TIMESTAMP);

CREATE TABLE shared(
 id SERIAL PRIMARY KEY NOT NULL, 
 user_id INT NOT NULL,  FOREIGN KEY(user_id) REFERENCES users(id), 
 post_id INT NOT NULL, FOREIGN KEY(post_id) REFERENCES post(id), 
 platform VARCHAR(100),
 dest_user_id INT ,  FOREIGN KEY(dest_user_id) REFERENCES users(id), 
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO shared(id,user_id ,post_id,platform,dest_user_id,created_at)
VALUES
  (1,3,5,'Donec',4,CURRENT_TIMESTAMP),
  (2,4,4,'fames',10,CURRENT_TIMESTAMP),
  (3,1,1,'justo',3,CURRENT_TIMESTAMP),
  (4,2,2,'auctor',10,CURRENT_TIMESTAMP),
  (5,5,3,'tristique',1,CURRENT_TIMESTAMP);

CREATE TABLE repost(
 id SERIAL PRIMARY KEY NOT NULL, 
 user_id INT NOT NULL, FOREIGN KEY(user_id) REFERENCES users(id), 
 post_id INT NOT NULL, FOREIGN KEY(post_id) REFERENCES post(id), 
 type type_enum,
 number_of_shares INT NOT NULL, 
 number_of_likes INT NOT NULL, 
 number_of_comment INT DEFAULT 0, 
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

NSERT INTO repost (id,user_id ,post_id,type,number_of_shares,number_of_likes,number_of_comment,created_at)
VALUES
  (1,2,3,'video,',10,3,1,CURRENT_TIMESTAMP),
  (2,4,5,'picture,',9,1,4,CURRENT_TIMESTAMP),
  (3,1,1,'video,',1,2,8,CURRENT_TIMESTAMP),
  (4,5,4,'video,',5,10,0,CURRENT_TIMESTAMP),
  (5,3,2,'picture,',3,4,9,CURRENT_TIMESTAMP);

