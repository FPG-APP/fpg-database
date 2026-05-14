-- depends: ADD_OAUTH_TABLES

ALTER TABLE MCP_LOGS
  ADD COLUMN token_kind ENUM('pat','oauth') NOT NULL DEFAULT 'pat';
