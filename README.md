# Shere LIST

This is a simple LIST sharing application.

## Getting start

At first, build and up docker containers.

```bash
$ docker-compose build
$ docker-compose up
```

Initialize database in other terminal

```bash
$ docker-compose exec web rake db:create
$ docker-compose exec web rake db:migrate
$ docker-compose exec web rake db:seed  # to create sample data.
```

And access to `http://localhost:3000/`

## Sample data

There are to users in Sample data.

- admin@email.com : Admin user.
- first@email.com : Normal user.

The password of these user is 'password'.

