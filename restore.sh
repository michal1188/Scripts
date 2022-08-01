#!/bin/bash
export PGHOST="${hostname}"
export PGUSER="${admin_name}"
export PGPORT=5432
export PGPASSWORD="${password_db}"


RESTORE_PATH="$HOME/tmp"
RESTORE_DATE=$(date +"%Y_%m_%d")
LOG_DIRECTORY="$RESTORE_PATH/logs"


echo "Rename and archive public production schema"
psql  -d "${database}" -c "ALTER SCHEMA public RENAME TO public_$RESTORE_DATE;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Restore production public schema"
/usr/bin/pg_restore --host "${hostname}" --port "5432" --username "${admin_name}" --no-password --dbname "${database}" --no-owner --no-privileges --schema-only --verbose "$RESTORE_PATH/schemat_qa_$RESTORE_DATE" &>"$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Restore production public data"
/usr/bin/pg_restore --host "${hostname}" --port "5432" --username "${admin_name}" --no-password --dbname "${database}"   --no-owner --no-privileges --data-only --verbose "$RESTORE_PATH/data_qa_$RESTORE_DATE"  &>"$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "GRANT ALL ON SCHEMA public"
psql  -d  "${database}" -c "GRANT ALL ON SCHEMA public TO PUBLIC; GRANT ALL ON SCHEMA public TO azure_superuser;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Change Owner public.product_managers"
psql  -d  "${database}" -c "ALTER TABLE IF EXISTS public.product_managers OWNER TO web_price_app_user; GRANT ALL ON TABLE public.product_managers TO web_price_app_user;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Change Owner public.price_maintenance"
psql  -d  "${database}" -c "ALTER TABLE IF EXISTS public.price_maintenance OWNER TO web_price_app_user; GRANT ALL ON TABLE public.price_maintenance TO web_price_app_user;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Change Owner public.databasechangelog"
psql  -d  "${database}" -c "ALTER TABLE IF EXISTS public.databasechangelog OWNER TO web_price_app_user; GRANT ALL ON TABLE public.databasechangelog TO web_price_app_user;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Change Owner public.databasechangeloglock"
psql  -d  "${database}" -c "ALTER TABLE IF EXISTS public.databasechangeloglock OWNER TO web_price_app_user; GRANT ALL ON TABLE public.databasechangeloglock TO web_price_app_user;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Change Owner public.cv_pricing_0002"
psql  -d  "${database}" -c "ALTER TABLE IF EXISTS public.cv_pricing_0002 OWNER TO sap_import_user; GRANT ALL ON TABLE public.cv_pricing_0002 TO sap_import_user; GRANT SELECT ON TABLE public.cv_pricing_0002 TO web_price_app_user;" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi

echo "Delete data from price_maintenance"
psql  -d  "${database}" -c "DELETE FROM public.price_maintenance" &> "$LOG_DIRECTORY/restoreProd_$RESTORE_DATE.log"

if [ "$?" != 0 ]
then
	echo "Warning: Data restore exited with error. See \"$LOG_DIRECTORY/dataqa_$RESTORE_DATE.log\" for details"
fi