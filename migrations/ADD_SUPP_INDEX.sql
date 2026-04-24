CREATE INDEX idx_choices_round_season
  ON CHOICES (ROUND, SEASON);

CREATE INDEX idx_scores_round_season
  ON SCORES (ROUND, SEASON);

CREATE INDEX idx_results_round_season
  ON RESULTS (ROUND, SEASON);

CREATE INDEX idx_fixtures_round_season
  ON FIXTURES (ROUND, SEASON);