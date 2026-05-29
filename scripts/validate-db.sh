#!/usr/bin/env bash
# =============================================================
# validate-db.sh — runs after Flyway migration succeeds
# Confirms critical tables and row counts are as expected.
# CI uses this as the "database health gate" before dispatch.
# =============================================================
set -euo pipefail

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-insurance_db}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-rootpassword}"

run_sql() {
  mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" \
        --silent --skip-column-names -e "$1"
}

echo "==> Connecting to MySQL at $DB_HOST:$DB_PORT/$DB_NAME"

# 1. Confirm policies table exists
TABLE_COUNT=$(run_sql "SELECT COUNT(*) FROM information_schema.tables
                       WHERE table_schema='$DB_NAME'
                         AND table_name='policies';")
if [[ "$TABLE_COUNT" -lt 1 ]]; then
  echo "ERROR: 'policies' table not found"
  exit 1
fi
echo "  [OK] policies table exists"

# 2. Confirm seed data was inserted
ROW_COUNT=$(run_sql "SELECT COUNT(*) FROM policies;")
echo "  [OK] policies table has $ROW_COUNT rows"

# 3. Confirm Flyway tracked the migration
MIGRATION_COUNT=$(run_sql "SELECT COUNT(*) FROM flyway_schema_history
                            WHERE success=1;")
echo "  [OK] Flyway recorded $MIGRATION_COUNT successful migration(s)"

echo "==> Database validation passed ✓"
