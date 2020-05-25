# making-hasura-work-with-github-actions
## Trying to make Hasura work with GitHub Actions

This one uses instructions for setup from here:
https://docs.hasura.io/1.0/graphql/manual/deployment/docker/index.html

This is by running a `docker-run.sh` file, instead of running `docker-compose`.

## How do I use this?

Look at the code in `.github/workflows/nodejs.yml` and use that for your GitHub actions workflow

## Other notes
At some point I also tried to run `docker exec myserver psql -U admin -d my-db -a -f START.sql` in the workflow (`nodejs.yml`). This is because this page (https://docs.hasura.io/1.0/graphql/manual/deployment/docker/index.html) says:

`Hasura GraphQL engine needs access permissions to your Postgres database as described in Postgres permissions`

The contents of `START.sql` come from this page (https://docs.hasura.io/1.0/graphql/manual/deployment/postgres-permissions.html), which was hyperlinked in the quote above.

I'm not exactly sure if you even need to run that SQL code after creating the Hasura server. But you can insert the docker exec command somewhere and try it out for yourself.

I tried and it didn't work.
