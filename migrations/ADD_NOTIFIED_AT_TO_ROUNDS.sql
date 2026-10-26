-- depends: ADD_MADE_AT_TO_CHOICES

-- NOTIFIED_AT is when the pushes that open a round went out: the previous
-- round's "Results are in" and, if rolled, this round's Double Points or Draw
-- Means More announcement. NULL means they are still owed.
--
-- The engine scores a round as soon as it ends, which is often around 3am UK
-- time, and used to push to every player there and then. It now holds those
-- pushes through quiet hours (11pm to 10am UK time) and sends them on the first
-- run after, so it needs to remember across runs that a round is still owed.
--
-- UTC, like ROUNDS.CUT_OFF. The engine's INSERT leaves the column out, so a new
-- round starts NULL. Every round that already exists has had its pushes, so it
-- is stamped here; without that the first run after deploy would resend the
-- current round's results to everyone.

ALTER TABLE ROUNDS
    ADD COLUMN NOTIFIED_AT DATETIME NULL;

UPDATE ROUNDS
    SET NOTIFIED_AT = UTC_TIMESTAMP();
