# API Entitlements Schema

This repo contains reference [JSON Schemas](https://json-schema.org/) for
policies used to represent entitlements to Acuris APIs:

* [API Entitlements Schema Version 1](v1.json) - this is the format used to represent API entitlements.
* [API Entitlements Backend Schema Version 1](v1.json) - this is the format for a subset of the data sent to an API backend after authentication and initial authorisation.

## Examples

* [policy-example.json](policy-example.json) - this is an example policy that grants access to two APIs, demonstrating the main features of the format.
* [api1-backend-example.json](api1-backend-example.json) - this is an example of the format sent with an API request to the api1 backend (from the above policy example) if all statements are currently valid.
* [api2-backend-example.json](api1-backend-example.json) - this is an example of the format sent with an API request to the api2 backend (from the above policy example).

## Description

### Top-level

At the top level there are `version` and `apis` keys:

```json
{
  "version": 1,
  "apis": {}
}
```

This policy includes no APIs so grants access to nothing.

### `apis`

Within the `apis` object keys repesent API identifiers and values represent access to that API

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan"
    }
  }
}
```

The only required field is that name of a plan. These are predefined plans that restrict the rate that an API can be accessed (e.g. 10 requests per second).

### Quota

Each API may have a quota that specifies how many requests are allowed within a period. This can include a soft limit (e.g. where a client may be notified of going over the quota) and/or a hard limit where access to the API is withdrawn for the remainder of the period.

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan",
      "quota": {
        "soft-limit": 10000,
        "hard-limit": 20000,
        "period": "MONTH"
      }
    }
  }
}
```

### Trial

Access to an API can be marked as trial access (default `false`). What this means in terms of access to data will be interpretted by the individual API.

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan",
      "trial": true
    }
  }
}
```

### Optional Data

An API may restrict access to certain data by default in responses - e.g. it may not include contact details.

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan",
      "optional-data": ["contact"]
    }
  }
}
```

### Statements

Statements define what datasets can be returned.

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan",
      "statements": [
        {
          "restrictions": {
            "field1": [ "foo", "bar" ],
            "field2": [ "baz" ]
          }
        },
        {
          "restrictions": {
            "field2": [ "baz" ],
            "field3": [ "quux" ]
          }
        }
      ]
    }
  }
}
```

Where a restriction includes multiple values for the same field, this means that you will be returned data where the field matches either of these values (i.e. is the union of the datasets - an OR is applied).

Where a restriction includes multiple fields, this means that data will be returned where all of the field values match (i.e. is the intersection fo the datasets - an AND is applied).

Where there are multiple statements the union of the datasets for each statement is returned (i.e. and OR is applied).

The field names and values are defined by and interpreted by the APIs. Note that specific APIs may not support multiple statements.

### Validity

Statements can have a validity period to facilitate limited time access to a dataset (e.g. trialing access).

```json
{
  "version": 1,
  "apis": {
    "myapi": {
      "plan": "name-of-api-plan",
      "statements": [
        {
          "restrictions": {
            "field1": [ "foo", "bar" ],
            "field2": [ "baz" ]
          },
          "validity": {
            "from": "2021-01-01",
            "days-after-first-use": 30
          }
        }
      ]
    }
  }
}
```

This should be interpreted as the client can access the API including the specified dataset from the `from` date. The first time the API is accessed after this date is recorded, and the statement is valid for 30 days from this date.