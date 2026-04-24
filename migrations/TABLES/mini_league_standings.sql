CREATE TABLE IF NOT EXISTS MINI_LEAGUE_STANDINGS (
    LEAGUE_ID           INT         NOT NULL,
    PLAYER_ID           INT         NOT NULL,
    ROUND               INT         NOT NULL,
    SEASON              INT         NOT NULL,
    POSITION            INT         NOT NULL,
    SCORE               INT         NOT NULL DEFAULT 0,
    GOAL_DIFF           INT         NOT NULL DEFAULT 0,
    MOVEMENT_INDICATOR  VARCHAR(10) DEFAULT NULL,
    LAST_UPDATED        DATETIME    DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (LEAGUE_ID, PLAYER_ID, ROUND, SEASON),
    INDEX idx_mini_league_standings_league_season_round (LEAGUE_ID, SEASON, ROUND)
);
