#!/bin/sh

set -e

id="api-entitlements-schema-validator"

echo building docker image... >&2
docker build -qt "$id" . >/dev/null
echo done. >&2

function ajv {
    echo "> ajv $@" >&2
    docker run \
        -i --rm --name "$id" \
        -v "$PWD:$PWD" -w "$PWD" \
        "$id" "$@"
}

ajv compile -s "schema/*"
ajv -s schema/policy-v1.json -d examples/policy.json 
ajv -s schema/backend-v1.json -d examples/api1-backend.json 
ajv -s schema/backend-v1.json -d examples/api2-backend.json 
