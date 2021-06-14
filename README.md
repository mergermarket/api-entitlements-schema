Reference [JSON Schemas](https://json-schema.org/) for policies used to represent entitlements to Acuris APIs.

![Unit tests](https://github.com/mergermarket/api-entitlements-schema/workflows/CI/badge.svg)

## Schemas

* [API Entitlements Schema Version 1](schema/policy-v1.json) - this is the format used to represent API entitlements.
* [API Entitlements Backend Schema Version 1](schema/backend-v1.json) - this is the format for a subset of the data sent to an API backend after authentication and initial authorisation.

## Examples

To test the examples run `./test.sh` in the root of the project (requires docker).

* [examples/policy.json](examples/policy.json) - this is an example policy that grants access to two APIs, demonstrating the main features of the format.
* [examples/api1-backend.json](examples/api1-backend.json) - this is an example of the format sent with an API request to the api1 backend (from the above policy example) if all statements are currently valid.
* [examples/api2-backend.json](examples/api1-backend.json) - this is an example of the format sent with an API request to the api2 backend (from the above policy example).

## Description

### Top-level

At the top level there are `$schema` and `apis` keys:

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {}
}
```

This policy includes no APIs so grants access to nothing.

### `apis`

Within `apis`, keys repesent APIs identified by their base URL (excluding the scheme/protocol) and values represent access to that API.

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
      "plan": "name-of-api-plan"
    }
  }
}
```

The only required field is the name of a plan. These are predefined plans that restrict the rate that an API can be accessed at (e.g. 10 requests per second).

### Trial Restrictions

Access to an API can be marked as `applyTrialRestrictions` so that the data that's returned is limited during the trial (for example). What this means will be defined and implemented by the API backend.

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
      "plan": "name-of-api-plan",
      "applyTrialRestrictions": true
    }
  }
}
```

### Response Exclude

An API may allow certain data to be excluded from responses - for example, contact details.

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
      "plan": "name-of-api-plan",
      "responseExclude": ["contact"]
    }
  }
}
```

### Filter Exclude

An API may allow certain filters to be blocked coming from request query parameters - for example, instrumentIsin filter.

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
      "plan": "name-of-api-plan",
      "filterExclude": ["instrumentIsin"]
    }
  }
}
```

The identifiers are defined and interpreted by the APIs.

### Statements

Statements define what datasets can be returned. There must be at least one statement (otherwise no access would be allowed).

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
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
            "field3": [ "quux" ],
            "field4": {
              "from": "2020-11-30T23:59:00.000Z"
            }
          }
        }
      ]
    }
  }
}
```

Where a restriction includes multiple values for the same field, this means that you will be returned data where the field matches either of these values (i.e. is the union of the datasets - an OR is applied).

Where a restriction includes multiple fields, this means that data will be returned where all of the field values match (i.e. is the intersection of the datasets - an AND is applied).

Where there are multiple statements, the union of the datasets for each statement is returned (i.e. an OR is applied).

The field names and values are defined by and interpreted by the APIs. Note that specific APIs may not support multiple statements.

Restrictions can be 1 of 2 types either a `string[]` or a range `{ from: string, to:string }`.

### Validity

Statements can have a validity period to facilitate limited time access to a dataset (e.g. trailing access).

```json
{
  "$schema": "https://mergermarket.github.io/api-entitlements-schema/schema/policy-v1.json#",
  "apis": {
    "example.com/myapi": {
      "plan": "name-of-api-plan",
      "statements": [
        {
          "restrictions": {
            "field1": [ "foo", "bar" ],
            "field2": [ "baz" ]
          },
          "validity": {
            "from": "2021-01-01",
            "daysAfterFirstUse": 30
          }
        }
      ]
    }
  }
}
```

This should be interpreted as the client can access the API including the specified dataset from the `from` date. The first time the API is accessed after this date is recorded, and the statement is valid for 30 days from this date.

<div style="position: absolute; top: 0; right: 0">
    <a href="https://github.com/mergermarket/api-entitlements-schema"><img loading="lazy" width="149" height="149" src="https://github.blog/wp-content/uploads/2008/12/forkme_right_white_ffffff.png?resize=149%2C149" class="attachment-full size-full" alt="Fork me on GitHub" data-recalc-dims="1"></a>
</div>
