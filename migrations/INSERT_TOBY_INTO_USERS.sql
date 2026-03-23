-- depends: users

INSERT INTO USERS (PLAYER_ID, 
                   EMAIL, 
                   FULL_NAME, 
                   USERNAME, 
                   FAV_TEAM, 
                   HASHED_PASSWORD, 
                   IS_DISABLED) 
VALUES
(1, 
'Toby96@sky.com', 
'Toby Gaskell', 
'MrFPG', 
'Manchester United', 
'$argon2id$v=19$m=65536,t=3,p=4$WfNGHfkmrisU3PUA7Wo4eA$Is2LqX5Z+ZgCqpAg10MecN+8AOmgNDDcfVbNqdY9DYY', 
FALSE);