#!/bin/bash
export PGPASSWORD="${password_db}"

BACKUP_PATH="$HOME/tmp"
BACKUP_DATE=$(date +"%Y_%m_%d")
echo "Creating directory \"$BACKUP_PATH\""
mkdir -p "$BACKUP_PATH"

LOG_DIRECTORY="$BACKUP_PATH/logs"
echo "Creating log directory \"$LOG_DIRECTORY\""
mkdir "$LOG_DIRECTORY"

echo "Creating backup of general database schema"
/usr/bin/pg_dump --file "$BACKUP_PATH/schemat_qa_$BACKUP_DATE" --host "${hostname}" --port "5432" --username  "${admin_name}"  --no-password --verbose --format=c --blobs --schema-only  --no-owner --no-privileges --schema "public"  "${database}" &> "$LOG_DIRECTORY/schematqa_$BACKUP_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Schema backup exited with error. See \"$LOG_DIRECTORY/schematqa_$BACKUP_DATE.log\" for details"
fi

echo "Creating backup of  database data"
/usr/bin/pg_dump --file "$BACKUP_PATH/data_qa_$BACKUP_DATE" --host "${hostname}" --port "5432" --username "${admin_name}"   --no-password --verbose --format=c --blobs --data-only  --no-owner --no-privileges --schema "public"  "${database}" &> "$LOG_DIRECTORY/dataqa_$BACKUP_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data backup exited with error. See \"$LOG_DIRECTORY/dataqa_$BACKUP_DATE.log\" for details"
fi