-- depends: ADD_COLS_STANDINGS

CREATE TABLE MCP_TOKENS (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    player_id       INT NOT NULL,
    name            VARCHAR(64) NULL,
    token_hash      VARCHAR(64) NOT NULL UNIQUE,
    token_preview   VARCHAR(12) NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at    DATETIME NULL,
    revoked_at      DATETIME NULL,
    INDEX idx_mcp_tokens_player_active (player_id, revoked_at),
    CONSTRAINT fk_mcp_tokens_player FOREIGN KEY (player_id) REFERENCES PLAYERS(PLAYER_ID)
);

CREATE TABLE MCP_LOGS (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    player_id       INT NOT NULL,
    token_id        INT NOT NULL,
    tool_name       VARCHAR(64) NOT NULL,
    args_summary    VARCHAR(255) NULL,
    status          ENUM('success', 'error', 'auth_fail') NOT NULL,
    error_message   VARCHAR(255) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_mcp_logs_player_created (player_id, created_at),
    INDEX idx_mcp_logs_token (token_id)
);
