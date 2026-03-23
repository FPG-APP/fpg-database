CREATE TABLE IF NOT EXISTS ERROR_LOGS (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    source        VARCHAR(100),
    function_name VARCHAR(100),
    error_type    VARCHAR(100),
    error_message TEXT,
    round_id      INT,
    season        INT,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);
