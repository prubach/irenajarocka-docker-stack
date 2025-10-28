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
  if mysql -u"$DB_USER" -p"$DB_PASS" -h 127.0.0.1 -e "USE \`$DB_NAME\`;" 2>/dev/null; then
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$(date +%Y%m%d_%H%M%S).sql"
    echo "💾 Creating backup: $BACKUP_FILE ..."
    mysqldump -u"$DB_USER" -p"$DB_PASS" -h 127.0.0.1 "$DB_NAME" > "$BACKUP_FILE"
    echo "✅ Backup saved at: $BACKUP_FILE"
  else
    echo "⚠️  Database '$DB_NAME' does not exist — skipping backup."
  fi
}

drop_and_recreate_database() {
  echo "🧨 Dropping existing database '$DB_NAME' (if exists)..."
  mysql -u"$DB_USER" -p"$DB_PASS" -h 127.0.0.1 -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;"

  echo "🆕 Creating new database '$DB_NAME'..."
  mysql -u"$DB_USER" -p"$DB_PASS" -h 127.0.0.1 -e "CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
}

import_dump() {
  echo "📦 Importing data from '$SQL_DUMP'..."
  mysql -u"$DB_USER" -p"$DB_PASS" -h 127.0.0.1 "$DB_NAME" < "$SQL_DUMP"
  echo "✅ Database '$DB_NAME' restored successfully from '$SQL_DUMP'."
}

# ---- Parse arguments ----
while getopts "d:u:p:f:" opt; do
  case "$opt" in
    d) DB_NAME="$OPTARG" ;;
    u) DB_USER="$OPTARG" ;;
    p) DB_PASS="$OPTARG" ;;
    f) SQL_DUMP="$OPTARG" ;;
    *) usage ;;
  esac
done

if [[ -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASS" || -z "$SQL_DUMP" ]]; then
  usage
fi

if [[ ! -f "$SQL_DUMP" ]]; then
  echo "❌ Error: SQL dump file '$SQL_DUMP' not found."
  exit 1
fi

# ---- Main process ----
echo "🚀 Starting restore process for database: $DB_NAME"

backup_database
drop_and_recreate_database
import_dump

echo "🎉 All done!"
