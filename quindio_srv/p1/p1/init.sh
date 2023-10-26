#!/bin/bash

# Clone etl repo
git clone https://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@github.com/TalentumLAB/etl_aulas_quindio.git /scripts/etl_aulas_quindio

# Change database structure
mysql -h localhost -u root -p%Aqrme3020 --execute="DROP DATABASE simat_db"
mysql -h localhost -u root -p%Aqrme3020 --execute="CREATE DATABASE simat_db"
mysql -h localhost -u root -p%Aqrme3020 --execute="ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '%Aqrme3020'"
mysql -h localhost -u root -p%Aqrme3020 --execute="FLUSH PRIVILEGES"
mysql -u root -p%Aqrme3020 simat_db < /syncthing/patch/p1/quindio-db.sql

# Program cronjob to execute etl in container
echo "* */1 * * *   /bin/bash docker compose -f /scripts/etl_aulas_quindio/docker-compose.yml up" >> /var/spool/cron/crontabs/root

# Execute app updater
/bin/bash /syncthing/apps-updater.sh

