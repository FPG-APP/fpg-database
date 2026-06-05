-- depends: ADD_FK_RESULTS_FIXTURES

-- Remove the CHOICES/SCORES -> USERS foreign keys.
--
-- The game is moving to a re-signup model: legacy players live in PLAYERS and
-- keep their historical CHOICES/SCORES, but are deliberately NOT in USERS until
-- they re-register (reclaiming their old PLAYER_ID). A foreign key forbids those
-- intentionally-orphaned rows, so it is the wrong constraint for the transition.
--
-- DROP ... IF EXISTS so this converges every environment to the same state:
--   - dev/uat already applied the ADD_FK_* migrations -> the FK is dropped here.
--   - prod never applied them (orphan data blocked it) -> this is a no-op.
--
-- USERS keeps its PRIMARY KEY and UNIQUE(email/username): those guarantee one
-- account per PLAYER_ID, which is what makes reclaiming an old id unambiguous.

ALTER TABLE CHOICES DROP FOREIGN KEY IF EXISTS fk_choices_player_id;
ALTER TABLE SCORES  DROP FOREIGN KEY IF EXISTS fk_scores_user_id;
