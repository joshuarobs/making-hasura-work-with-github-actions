# making-hasura-work-with-github-actions
## Trying to make Hasura work with GitHub Actions

This one uses instructions for setup from here:
https://docs.hasura.io/1.0/graphql/manual/deployment/docker/index.html

This is by running a `docker-run.sh` file, instead of running `docker-compose`.

## How do I use this?

Look at the code in `.github/workflows/nodejs.yml` and use that for your GitHub actions workflow

Or if you're lazy:

````
name: Node CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:12.1
        env:
          POSTGRES_USER: postgres
          POSTGRES_DB: postgres
        ports:
        # will assign a random free host port
        - 5432:5432
        # needed because the postgres container does not provide a healthcheck
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5
      hasura:
        image: hasura/graphql-engine:latest
        env:
          HASURA_GRAPHQL_DATABASE_URL: postgres://postgres:@postgres:5432/postgres
        ports:
          - 8080:8080

    strategy:
      matrix:
        node-version: [12.x]

    steps:
    - uses: actions/checkout@v1
    - name: Install Hasura cli
      run: curl -L https://github.com/hasura/graphql-engine/raw/master/cli/get.sh | bash
    - name: Start up the Docker containers and migrate to the latest version of the database
      run: |
        docker ps
        cd docker
        hasura migrate status --skip-update-check --endpoint http://localhost:8080
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - name: npm install, build, and test
      run: |
        node index.js
      env:
        CI: true
````

## Other notes
At some point I also tried to run `docker exec myserver psql -U admin -d my-db -a -f START.sql` in the workflow (`nodejs.yml`). This is because this page (https://docs.hasura.io/1.0/graphql/manual/deployment/docker/index.html) says:

`Hasura GraphQL engine needs access permissions to your Postgres database as described in Postgres permissions`

The contents of `START.sql` come from this page (https://docs.hasura.io/1.0/graphql/manual/deployment/postgres-permissions.html), which was hyperlinked in the quote above.

I'm not exactly sure if you even need to run that SQL code after creating the Hasura server. But you can insert the docker exec command somewhere and try it out for yourself.

I tried and it didn't work.
