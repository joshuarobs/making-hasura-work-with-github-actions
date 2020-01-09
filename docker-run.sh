#! /bin/bash
docker run -d --net=host \
       -e HASURA_GRAPHQL_DATABASE_URL=postgres://postgres:@localhost:5432/my-db \
       -e HASURA_GRAPHQL_ENABLE_CONSOLE=true \
       --name myserver \
       hasura/graphql-engine:v1.0.0
