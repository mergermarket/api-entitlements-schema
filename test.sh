#!/bin/bash

set -e

id="api-entitlements-schema-validator"

echo building docker image... >&2
docker build -qt "$id" . >/dev/null
echo done. >&2

ajv() {
    echo "> ajv $@" >&2
    docker run \
        -i --rm --name "$id" \
        -v "$PWD:$PWD" -w "$PWD" \
        "$id" "$@"
}

ajv compile -c ajv-formats -s "schema/*"
ajv -c ajv-formats -s schema/policy-v1.json -d examples/policy.json
ajv -c ajv-formats -s schema/backend-v1.json -d examples/api1-backend.json
ajv -c ajv-formats -s schema/backend-v1.json -d examples/api2-backend.json
ajv -c ajv-formats -s schema/backend-v1.json -d examples/date-range-open-api-backend.json
ajv -c ajv-formats -s schema/backend-v1.json -d examples/date-range-fixed-api-backend.json
