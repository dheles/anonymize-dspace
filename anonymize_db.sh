#!/usr/bin/env bash

#anonymize_db.sh

function usage
{
  echo "usage: anonymize_db [[[-dn DB_NAME] [-du DB_USER] [-bf BACKUP_FILENAME] [-af ANONYMIZED_FILENAME] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
DB_NAME="dspace_anon"
DB_USER="dspace"
BACKUP_FILENAME="production_dump.sql"
ANONYMIZED_FILENAME="anon_dump.sql"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -dn | --db_name )             shift
                                  DB_NAME=$1
                                  ;;
    -du | --db_user )             shift
                                  DB_USER=$1
                                  ;;
    -bf | --backup_filename )     shift
                                  BACKUP_FILENAME=$1
                                  ;;
    -af | --anonymized_filename ) shift
                                  ANONYMIZED_FILENAME=$1
                                  ;;
    -h | --help )                 usage
                                  exit
                                  ;;
    * )                           usage
                                  exit 1
  esac
  shift
done

# set remaining vars
ADMIN_HOME="/home/$ADMIN"
BACKUP_PATH="$ADMIN_HOME/db_backup"
BACKUP_FILE="$BACKUP_PATH/$BACKUP_FILENAME"
ANONYMIZED_FILE="$BACKUP_PATH/$ANONYMIZED_FILENAME"

sudo su - postgres bash -c "dropdb $DB_NAME"
sudo su - postgres bash -c "createdb -O $DB_USER --encoding=UNICODE $DB_NAME"
pg_restore -U $DB_USER -d $DB_NAME -O < $BACKUP_FILE
sudo su postgres bash -c "psql -U $DB_USER $DB_NAME < ./anonymize_db.sql"
pg_dump --format=custom --oids --no-owner --no-acl --ignore-version -U $DB_USER $DB_NAME > $ANONYMIZED_FILE
