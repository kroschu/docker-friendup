#!/bin/bash

if [ -f .initialized ]; then
  echo "FriendUP is already initialized."
else
  echo "Doing first-time initialization."
  echo
  echo "Writing configuration file."
cat << EOF |tee cfg/cfg.ini
[DatabaseUser]
login = $DB_USER
password = $DB_PASS
host = $DB_HOST
dbname = $DB_NAME
port = $DB_PORT

[FriendCore]
fchost = 127.0.0.1
port = 6502
fcupload = storage/

[Core]
port = 6502
SSLEnable = 0
EOF
  echo ""
  echo "Populating the database"
  mysql --host=$DB_HOST --port=$DB_PORT \
        --user=$DB_USER --password=$DB_PASS \
        --database=$DB_NAME \
        --execute "SOURCE ../db/FriendCoreDatabase.sql"
  touch .initialized
fi

echo "Starting FriendCore"
./FriendCore
