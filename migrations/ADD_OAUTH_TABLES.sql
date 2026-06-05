-- depends: ADD_MCP_TOKENS_AND_LOGS

CREATE TABLE OAUTH_CLIENTS (
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    client_id           CHAR(43) NOT NULL UNIQUE,
    client_secret_hash  CHAR(64) NULL,
    client_name         VARCHAR(120) NOT NULL,
    redirect_uris       JSON NOT NULL,
    registered_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revoked_at          DATETIME NULL,
    INDEX idx_oauth_clients_active (client_id, revoked_at)
);

CREATE TABLE OAUTH_AUTH_CODES (
    code_hash               CHAR(64) PRIMARY KEY,
    client_id               CHAR(43) NOT NULL,
    player_id               INT NOT NULL,
    redirect_uri            VARCHAR(255) NOT NULL,
    code_challenge          VARCHAR(128) NOT NULL,
    code_challenge_method   ENUM('S256','plain') NOT NULL,
    scope                   VARCHAR(64) NOT NULL,
    expires_at              DATETIME NOT NULL,
    consumed_at             DATETIME NULL,
    INDEX idx_oauth_auth_codes_client (client_id),
    CONSTRAINT fk_oauth_codes_player FOREIGN KEY (player_id) REFERENCES PLAYERS(PLAYER_ID)
);

CREATE TABLE OAUTH_ACCESS_TOKENS (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    token_hash  CHAR(64) NOT NULL UNIQUE,
    client_id   CHAR(43) NOT NULL,
    player_id   INT NOT NULL,
    scope       VARCHAR(64) NOT NULL,
    issued_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at  DATETIME NOT NULL,
    revoked_at  DATETIME NULL,
    INDEX idx_oauth_access_player_active (player_id, revoked_at),
    INDEX idx_oauth_access_client (client_id),
    CONSTRAINT fk_oauth_access_player FOREIGN KEY (player_id) REFERENCES PLAYERS(PLAYER_ID)
);

CREATE TABLE OAUTH_REFRESH_TOKENS (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    token_hash      CHAR(64) NOT NULL UNIQUE,
    client_id       CHAR(43) NOT NULL,
    player_id       INT NOT NULL,
    scope           VARCHAR(64) NOT NULL,
    issued_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at      DATETIME NOT NULL,
    rotated_to_id   INT NULL,
    revoked_at      DATETIME NULL,
    INDEX idx_oauth_refresh_player_active (player_id, revoked_at),
    INDEX idx_oauth_refresh_chain (rotated_to_id),
    CONSTRAINT fk_oauth_refresh_player FOREIGN KEY (player_id) REFERENCES PLAYERS(PLAYER_ID)
);
