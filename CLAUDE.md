# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo does

Manages the schema of the FPG MySQL database via [Yoyo Migrations](https://ollycope.com/software/yoyo/latest/). All schema changes are plain SQL files, tracked and applied by Yoyo, deployed automatically through GitHub Actions on push to `develop` or `main`.

Currently holds **47 schema-change migrations** in `migrations/` and **21 table-creation migrations** in `migrations/TABLES/`.

## Commands

```bash
uv run yoyo list                              # show applied / pending migrations
uv run yoyo apply                             # apply all pending migrations
uv run yoyo reapply --revision <migration>    # re-run a specific migration (e.g. for a data backfill)
```

`uv` is the package manager — used locally and in CI. After dependency changes, `uv add <pkg>` then commit `uv.lock`.

## Configuration

`yoyo.ini` is gitignored (it holds connection credentials). Create it locally before running any command:

```ini
[DEFAULT]
sources = migrations migrations/TABLES
database = mysql://user:pass@host/DEV_FPG
batch_mode = off
verbosity = 2
```

CI sets `batch_mode = on` so deployments are atomic.

## Layout

```
.
├── migrations/             # 47 ALTER / index / FK / constraint migrations
│   └── TABLES/             # 21 CREATE TABLE migrations
├── .github/
│   ├── workflows/
│   │   ├── deploy_db_testing.yml   # runs on push to develop
│   │   └── deploy_db_prod.yml      # runs on push to main
│   └── actions/yoyo_deploy/        # composite action shared by both workflows
├── pyproject.toml
├── uv.lock
└── README.md
```

## Authoring a migration

- Schema changes go in `migrations/`.
- Brand-new tables go in `migrations/TABLES/`.
- Filenames are descriptive (no dates or sequence numbers) — e.g. `ADD_COL_ACTIVE_TO_TOKENS.sql`, `CREATE_TABLE_LEAGUES.sql`.
- Use a `-- depends:` header line to enforce ordering instead of relying on alphabetical sort. Example:

  ```sql
  -- depends: ADD_COL_CREATED_AT_TO_TOKENS

  ALTER TABLE TOKENS ADD COLUMN ACTIVE TINYINT(1) DEFAULT 1;
  ```

- Yoyo records applied migrations in a `_yoyo_migration` table; do not edit that table by hand.

## Schema overview

The core domain tables are:

| Table | What it holds |
|---|---|
| `USERS` | Auth + profile (email, hashed password, username, full name, etc.) |
| `PLAYERS` | Game-side player metadata (player_id, joined-season, etc.) |
| `TEAMS` | Premier League teams |
| `FIXTURES` | Per-round match schedule |
| `RESULTS` | Per-round match results (A / B / draw) |
| `ROUNDS` | Round metadata, including DP (double points) and DMM (draw means more) flags |
| `CURRENT_ROUND` | Singleton: current active round + season |
| `CHOICES` | A player's pick for a given round |
| `SCORES` | A player's score for a given round |
| `STANDINGS` | Aggregated season standings |
| `LEAGUES` / `LEAGUE_MEMBERS` | Mini-league membership |
| `TOKENS` | Refresh-token storage + push-notification tokens |
| `CALL_LOGS` / `NOTIFICATION_LOGS` / `LOGS` / `ERROR_LOGS` | Operational logs |

Most tables carry a `SEASON` column (integer year) for multi-season isolation. New player IDs are issued from the `SEQ_PLAYER_IDS` sequence (starts at 4001).

## Deployment

| Branch | Workflow | Target |
|---|---|---|
| `develop` | `deploy_db_testing.yml` | testing DB |
| `main` | `deploy_db_prod.yml` | production DB |

Both wrap the composite action in `.github/actions/yoyo_deploy/`, which:
1. Installs `uv` via `astral-sh/setup-uv`.
2. Runs `uv sync --locked`.
3. Generates `yoyo.ini` from the workflow's env (host / db / user / password injected from GitHub secrets and vars).
4. Runs `uv run yoyo list` (visibility) then `uv run yoyo apply` with `batch_mode = on`.

No manual `kubectl` or SSH steps — pushing to the right branch is the deploy.

## Dependencies

- Python ≥ 3.11
- `yoyo-migrations` ≥ 9
- `pymysql` ≥ 1.1
