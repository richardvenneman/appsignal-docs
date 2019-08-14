---
title: "Sourcemaps API"
---

Sourcemaps are used to get the original line and column number from a minified backtrace.

This API provides an easy way to upload private sourcemaps for use with [frontend errors](/front-end/sourcemaps.html)

## Table of Contents

- Endpoints
  - [Sourcemap create - POST sourcemaps](#sourcemap-create)

## Sourcemap create

This endpoint enables the creation of private sourcemaps.

<table>
  <tr>
    <td>Endpoint</td>
    <td>/api/sourcemaps</td>
  </tr>
  <tr>
    <td>Request method</td>
    <td>POST</td>
  </tr>
    <tr>
    <td>Content-Type</td>
    <td>multipart/form-data</td>
  </tr>
  <tr>
    <td>Requires authentication?</td>
    <td>Yes (PUSH API key)</td>
  </tr>
  <tr>
    <td>Response formats</td>
    <td>JSON</td>
  </tr>
</table>

### Params

All parameters, except for `file` can be sent either in the POST body or as GET params. All parameters are required

<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Type</th>
      <th>Description</th>
    <tr>
  </thead>
  <tbody>
    <tr>
      <td>api_key</td>
      <td>String</td>
      <td>Your organisation's PUSH API key.</td>
    </tr>
    <tr>
      <td>app_name</td>
      <td>String</td>
      <td>Name of application the sourcemap is meant for.</td>
    </tr>
    <tr>
      <td>environment</td>
      <td>String</td>
      <td>Environment of application the sourcemap is meant for.</td>
    </tr>
    <tr>
      <td>revision</td>
      <td>String</td>
      <td>Git revision reference.</td>
    </tr>
    <tr>
      <td>name</td>
      <td>Array of Strings</td>
      <td>List of filenames that the sourcemap covers, should be a full url to the minified Javascript file.</td>
    </tr>
    <tr>
      <td>file</td>
      <td>File</td>
      <td>Sourcemap to upload.</td>
    </tr>
  </tbody>
</table>

#### CURL example

```bash
curl -k -X POST -H 'Content-Type: multipart/form-data' \
  -F 'name[]=https://localhost:3000/application.min.js' \
  -F 'revision=abcdef' \
  -F 'file=@/~project/application.js.map' \
  'https://appsignal.com/api/sourcemaps?push_api_key=xxx&app_name=AppSignal&environment=development'
```

The API will return a `201` if successful, or a JSON object `{ errors => ["message"] }` when an error has occurred.
