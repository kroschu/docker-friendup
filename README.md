# Docker Container for the [Friend Unifying Platform][1]

This container allows to run FriendUP in a Docker container. When you build it
for yourself, it pulls the latest source code from their [Github page][2]
and builds it.

## Building

Just clone the repository and execute:

```sh
docker build -t friendup .
```

## Running

### MySQL database

You need to have a MySQL server running with a previously prepared, empty
database and a respective user that has full read and write access to this
database.

#### Running a database in Docker

You can run the [sameersbn/mysql][3] container which can automatically set up
a database for use with FriendUP. The Docker container was tested with this
approach.

Note down the database user, name and password, you will need it later.

To run the database, just enter:

```sh
docker run -d --name friend-database \
              -e DB_NAME=friend-db-name \
              -e DB_USER=friend-db-user \
              -e DB_PASS=friend-db-password \
              sameersbn/mysql
```

This will pull the container (if needed) and run an appropriately
preconfigured database for you to use. You can pick any value for the
database name, user and password.

### The container

```sh
docker run -d --name friendup
           --link database-container-name:frienddbhost \
           -e DB_NAME=friend-db-name \
           -e DB_USER=friend-db-user \
           -e DB_PASS=friend-db-password \
           -e DB_HOST=frienddbhost \
           -p 6500-6504:6500-6504 \
           windfisch/friendup:latest
```

This runs the FriendUP container using a pre-created MySQL container.
You can also use another source for the MySQL database, but the database
and user must both exist and the user must have both read and write rights.

## Using

When the container is started, point your webbrowser to http://localhost:6502
and log in with:

```text
Username: fadmin
Password: securefassword
```

Have fun!

[1]: https://friendup.cloud
[2]: https://github.com/FriendSoftwareLabs/friendup
[3]: https://hub.docker.com/r/sameersbn/mysql/
