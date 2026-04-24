-- depends: standings

-- Rename OVERALL_TOTAL → SCORE to match the API field name
ALTER TABLE STANDINGS
  CHANGE COLUMN OVERALL_TOTAL SCORE INT DEFAULT 0;

-- Add SEASON first (needs a DEFAULT for the ALTER since InnoDB won't allow NOT NULL
-- without a default on a non-empty table; STANDINGS is empty in practice)
ALTER TABLE STANDINGS
  ADD COLUMN SEASON INT NOT NULL DEFAULT 0;

-- Add remaining columns, promote all key columns to NOT NULL, and add composite PK
ALTER TABLE STANDINGS
  ADD COLUMN GOAL_DIFF          INT         NOT NULL DEFAULT 0,
  ADD COLUMN MOVEMENT_INDICATOR VARCHAR(10) DEFAULT NULL,
  ADD COLUMN LAST_UPDATED       DATETIME    DEFAULT CURRENT_TIMESTAMP
                                            ON UPDATE CURRENT_TIMESTAMP,
  MODIFY COLUMN PLAYER_ID       INT         NOT NULL,
  MODIFY COLUMN ROUND           INT         NOT NULL,
  ADD PRIMARY KEY (PLAYER_ID, ROUND, SEASON);

CREATE INDEX idx_standings_season_round ON STANDINGS (SEASON, ROUND);
