CREATE TABLE IF NOT EXISTS REFRESH_TOKENS (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    player_id   INT NOT NULL,
    token_hash  VARCHAR(64) NOT NULL UNIQUE,
    expires_at  DATETIME NOT NULL,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP(2),
    INDEX idx_player (player_id),
    INDEX idx_hash (token_hash)
);
