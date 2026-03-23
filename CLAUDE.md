# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Manages database schema for the FPG MySQL database using [Yoyo Migrations](https://ollycope.com/software/yoyo/latest/). All schema changes are expressed as SQL migration files.

## Commands

```bash
uv run yoyo list    # show migration status (applied / pending)
uv run yoyo apply   # apply all pending migrations
```

`yoyo.ini` is gitignored (contains dev credentials). Create it locally:

```ini
[DEFAULT]
sources = migrations migrations/TABLES
database = mysql://user:pass@host/DEV_FPG
batch_mode = off
verbosity = 2
```

## Migration Authoring

- Place new migrations in `migrations/` (or `migrations/TABLES/` for net-new tables)
- Use `-- depends: <migration_name>` at the top of a file to enforce ordering rather than relying on alphabetical sort
- Yoyo tracks applied migrations in a `_yoyo_migration` table automatically
- CI runs with `batch_mode = on` (atomic); local dev uses `batch_mode = off`

## Schema Overview

Core tables: `USERS`, `PLAYERS`, `TEAMS`, `FIXTURES`, `RESULTS`, `ROUNDS`, `CURRENT_ROUND`, `CHOICES`, `SCORES`, `STANDINGS`, `TOKENS`, `LOGS`, `CALL_LOGS`, `NOTIFICATION_LOGS`.

Most tables have a `SEASON` column (integer year) added via migration to support multi-season data isolation. Player IDs start at 4001 via `SEQ_PLAYER_IDS`.

## Deployment

GitHub Actions handle deployments automatically:
- Push to `develop` → deploys to testing environment
- Push to `main` → deploys to production

Credentials are injected via GitHub environment secrets; the action generates `yoyo.ini` at runtime.

## Package Manager

Uses `uv` locally (`uv run yoyo ...`). The GitHub Action currently installs via `poetry` — if you update dependencies, you may need to align both.
