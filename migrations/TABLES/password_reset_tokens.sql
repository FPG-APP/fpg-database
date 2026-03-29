CREATE TABLE IF NOT EXISTS PASSWORD_RESET_TOKENS (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    email       VARCHAR(255) NOT NULL,
    token_hash  VARCHAR(64) NOT NULL UNIQUE,
    expires_at  DATETIME NOT NULL,
    used        BOOLEAN DEFAULT FALSE,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP(2),
    INDEX idx_email (email),
    INDEX idx_hash (token_hash)
);
