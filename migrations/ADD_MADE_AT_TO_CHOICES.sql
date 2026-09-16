-- depends: ADD_PICKABLE_TO_FIXTURES

-- MADE_AT is when the pick a player currently holds was made. Before this there
-- was no record of it at all, so reviewing a late pick meant reconstructing it
-- from CALL_LOGS, which holds only an endpoint and a time.
--
-- UTC, like FIXTURES.KICKOFF and ROUNDS.CUT_OFF, and unlike the London
-- wall-clock audit columns filled by NOW(): its main use is comparing a pick
-- with the deadline, and this server cannot convert zones in SQL.
--
-- Picks made before this migration stay NULL, meaning unknown. That is why the
-- column is added first with no default and only then given one. MariaDB fills
-- existing rows with a new column's default when both arrive in one ALTER, so
-- the one-step form would claim every historic pick was made at migration time.
--
-- New rows get UTC_TIMESTAMP() from the default: fpg-api's first pick and
-- fpg-engine's auto-assigned pick both leave the column out of their INSERT. A
-- change of pick is an UPDATE, which a default does not touch, and ON UPDATE
-- accepts only CURRENT_TIMESTAMP (London time here), so fpg-api sets MADE_AT
-- itself when the team changes.
--
-- FPG-APP/fpg-docs#91, initiative 2026-09-choices-made-at.

ALTER TABLE CHOICES
    ADD COLUMN MADE_AT DATETIME NULL;

ALTER TABLE CHOICES
    ALTER COLUMN MADE_AT SET DEFAULT (UTC_TIMESTAMP());
