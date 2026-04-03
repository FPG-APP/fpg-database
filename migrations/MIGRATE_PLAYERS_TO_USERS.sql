-- depends: users

-- Migrate existing player records from PLAYERS into USERS.
-- Only inserts rows where the PLAYER_ID does not already exist in USERS,
-- so it is safe to run against a USERS table that has partial data.
INSERT INTO USERS (PLAYER_ID, EMAIL, USERNAME, FAV_TEAM, CREATED_AT, IS_DISABLED)
SELECT  p.PLAYER_ID,
        p.EMAIL,
        p.USERNAME,
        p.FAV_TEAM,
        COALESCE(p.CREATED_AT, CURRENT_TIMESTAMP),
        FALSE
FROM    PLAYERS p
WHERE   NOT EXISTS (
            SELECT 1 FROM USERS u WHERE u.PLAYER_ID = p.PLAYER_ID
        );
