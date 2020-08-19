# API Entitlements Schema

This repo contains reference [JSON Schemas](https://json-schema.org/) for
policies used to represent entitlements to Acuris APIs:

* [API Entitlements Schema Version 1](v1.json) - this is the format used to represent API entitlements.
* [API Entitlements Backend Schema Version 1](v1.json) - this is the format for a subset of the data sent to an API backend after authentication and initial authorisation.

## Examples

* [policy-example.json](policy-example.json) - this is an example policy that grants access to two APIs, demonstrating the main features of the format.
* [api1-backend-example.json](api1-backend-example.json) - this is an example of the format sent with an API request to the api1 backend (from the above policy example) if all statements are currently valid.
* [api2-backend-example.json](api1-backend-example.json) - this is an example of the format sent with an API request to the api2 backend (from the above policy example).
