ALTER TABLE RESULTS  ADD INDEX idx_results_season_status (season, game_status);
ALTER TABLE CHOICES  ADD INDEX idx_choices_season_player (season, player_id);
ALTER TABLE FIXTURES ADD INDEX idx_fixtures_season (season);
ALTER TABLE SCORES   ADD INDEX idx_scores_season_player_round (season, player_id, round);
ALTER TABLE PLAYERS  ADD INDEX idx_players_player_id (player_id);