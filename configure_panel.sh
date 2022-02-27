#!/bin/bash
PANEL_COMMAND="docker exec -it panel_test2"
ARTISAN="php artisan"


#Refresh materialized views

declare -a VIEWS=("panel.ure_prices" "common.contract_summary" "common.meter_parameter_view" "common.tariff_hours" "common.tariff_hours_2")
export PGPASSWORD='xxx'

echo "Refrshing materialized views"

for view in "${VIEWS[@]}"
        do
                psql --host "0.0.0.0" --port "5557" --dbname "test2" --username "postgres"  -c "refresh materialized view $view with data;"
                RESULT=$?
                if [ $RESULT -eq 0 ] ;then
                         echo " REFRESH MATERIALIZED VIEW: $view SUCCESS" 
                else
                         echo "Missing REFRESH MATERIALIZED VIEW: $view"
                         exit 1
                fi
        done

# Perform migrations
echo "Performing migrations"
$PANEL_COMMAND $ARTISAN migrate

# Clear caches
echo "Clearing views"
$PANEL_COMMAND $ARTISAN view:clear

echo "Clearing configurations"
$PANEL_COMMAND $ARTISAN config:clear

echo "Clearing cache"
$PANEL_COMMAND $ARTISAN cache:clear

# Create storage link
echo "Creating storage link"
$PANEL_COMMAND $ARTISAN storage:link

echo "Updating vuesources.php"
if [ -e ~/panel_vuesources.info ]
then
	vuesources_contents="$(cat ~/panel_vuesources.info)"
	$PANEL_COMMAND sh -c "printf \"%s\" \"$vuesources_contents\" > public/vue/vuesources.php"
else
	echo "Missing ~/panel_vuesources.php"
fi

echo "Updating vuePDFSources.php"
if [ -e ~/panel_vuePDFSources.info ]
then
	vuepdfsources_contents="$(cat ~/panel_vuePDFSources.info)"
	$PANEL_COMMAND sh -c "printf \"%s\" \"$vuepdfsources_contents\" > public/vue/vuePDFSources.php"
else
	echo "Missing ~/panel_vuePDFSources.info"
fi

