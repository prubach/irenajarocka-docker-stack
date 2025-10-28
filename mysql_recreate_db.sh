#!/usr/bin/env bash
# restore_mysql_db.sh
# Safely drop and recreate a MySQL/MariaDB database from a .sql dump file,
# automatically backing up the old database first.

set -euo pipefail

# ---- Configuration ----
DB_NAME=""
DB_USER="root"
DB_PASS=""
SQL_DUMP=""
BACKUP_DIR="./mysql_backups"

# ---- Helper Functions ----

usage() {
  echo "Usage: $0 -d <database_name> -u <user> -p <password> -f <dump.sql>"
  echo "Example: $0 -d mydb -u root -p mypass -f /path/to/dump.sql"
  exit 1
}

backup_database() {
  echo "🔹 Checking if database '$DB_NAME' exists for backup..."
  if mysql -u"$DB_USER" -p"$DB_PASS" -e "USE \`$DB_NAME\`;" 2>/dev/null; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$(date +%Y%m%d_%H%M%S).sql"
    echo "💾 Creating backup: $BACKUP_FILE ..."
    mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE"
    echo "✅ Backup saved at: $BACKUP_FILE"
  else
    echo "⚠️  Database '$DB_NAME' does not exist — skipping backup."
  fi
}

drop_and_rec
