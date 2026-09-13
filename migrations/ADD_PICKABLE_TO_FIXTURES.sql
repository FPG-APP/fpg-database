-- depends: ADD_ENGINE_RUN_METRICS

-- A round's deadline is MIN(KICKOFF) over its fixtures, with no buffer. That
-- breaks when a match is rescheduled far enough forward that the deadline
-- would land before the previous round has even finished: players would get no
-- window to pick at all.
--
-- PICKABLE marks a fixture the engine has ruled out of that calculation. A
-- fixture is unpickable when its kick-off is at or before the end of the
-- previous round, which is that round's last kick-off plus two hours. The
-- deadline then becomes the earliest kick-off among the fixtures that remain,
-- and fpg-api refuses to let anyone pick into one that is ruled out.
--
-- A match brought forward within its own round is NOT unpickable: the deadline
-- simply moves with it. Only a match pulled back past the previous round is.
--
-- Default TRUE, so every existing row and every reader that ignores the column
-- behaves exactly as it does today. The daily reconcile in fpg-engine sets the
-- real value; nothing is backfilled here, because the rule needs kick-off times
-- that have not been refreshed yet.
--
-- FPG-APP/fpg-docs#78, initiative 2026-09-fixture-reconciliation.

ALTER TABLE FIXTURES
    ADD COLUMN PICKABLE BOOLEAN NOT NULL DEFAULT TRUE;
