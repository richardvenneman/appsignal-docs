---
title: "JIRA"
---

[JIRA](https://www.atlassian.com/software/jira)  is the tracker for teams planning and building great products.

## Configuring JIRA

Before we can link AppSignal to JIRA we need to configure JIRA to accept our OAuth request.

Sign in to JIRA and open the "Hamburger" menu on the bottom of the sidebar. Then select "Edit".

![Administration navigation](/images/screenshots/jira/navigation.png)

On the "Applications administration" screen look for the "Application links" under the "Integrations" section in the navigation.

![Application links navigation](/images/screenshots/jira/application_links.png)

You'll be presented with a small form for a URL. Enter: `https://appsignal.com` in the field for a new Application Link.

If you receive a "No response was received from the URL you entered" error. Don't be alarmed, this is actually OK. Now click "continue".

### Application details

In the modal, only fill out the "Application Name".

![Application setup](/images/screenshots/jira/setup.png)

After saving the integration, click the "Edit" icon for the newly created integration and go to the "Incoming Authentication" tab in the new modal.

![OAuth navigation](/images/screenshots/jira/oauth_navigation.png)

### OAuth setup

In the "Incoming OAuth" tab, setup OAuth with the following values:

* Consumer Key: `7668c385bf3f09c0219ec178a50ff736`
* Consumer Name: `AppSignal`
* Public Key:

```
-----BEGIN CERTIFICATE-----
MIICsDCCAhmgAwIBAgIJAJGEAsDfksoFMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwNDAyMTIyMDEwWhcNMTUwNTAyMTIyMDEwWjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB
gQCoo3PzC3CIWEqXlLb7NDKRLqxp/M/88RevoOMAJq/UG/q4fJlhOkVoHK86IxV1
eZ+p6m1cqizWmnGp3KSqU1y+jhKj6+XqhPHfyXFOrRAGr//UGcIIXycPf5mKLftr
3PQ8F+Bloq7UGhkahtVP+u3CUcde6TCTGWYvAI47jVdyHwIDAQABo4GnMIGkMB0G
A1UdDgQWBBQYN5ucG+T1xBsPHkDSKKMg8KP1YDB1BgNVHSMEbjBsgBQYN5ucG+T1
xBsPHkDSKKMg8KP1YKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt
U3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAJGEAsDf
ksoFMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEANgUypdXrA41lt2P1
atA+hxT1jtmYeIyUbVrsS2K9HYZpdijHVXZGHdaf2c56x2d9O8uOpwsbQT+09WNR
KD4RHjXJPVCYaY1QFk0FHM+5yooD2H3XwNyzCWgSZZ1nc6ZuLXJKY8jtXH9cs0wZ
utPOCXiudsot4u0pDWHLfsBQr+o=
-----END CERTIFICATE-----
```

And finally, save the OAuth configuration.

## Configuring AppSignal

Now that the JIRA-end is setup up we can link it to AppSignal. Open the application in AppSignal you want to link JIRA to and go to "Integrations" (left-hand side navigation bar, "Configure" section).

Choose "JIRA" from the list of integrations. Enter in the "JIRA installation location" the root path of your JIRA app, e.g. `https://appsignal-test-1.atlassian.net`. Press "Link AppSignal to JIRA".

You'll be presented with an authentication confirmation screen.

![JIRA OAuth confirmation](/images/screenshots/jira/authentication.png)

Upon pressing "Allow" you'll be returned to AppSignal. Here you need to select which project and issue type you want to use for AppSignal issues.

If, upon selecting a issue type, you get an error, please read the ["Errors"](#errors) section for what to do.

## Errors

AppSignal requires a number of fields to be present when the integration is activated. If fields are missing, we will show an error message during the setup.

Required fields are:

* Labels
* Environment
* Summary
* Description

In order to fix these messages, you have to add the fields to the JIRA screens by going to the "Issues" tab in the "Settings" menu. First check which "screen" your issue type is using on the "Issue types" page, in the "Related Schemes" column for the issue type you selected in AppSignal.

Then navigate to the "Screens" page in the "Screens" section.

![Issues screens page](/images/screenshots/jira/screens.png)

Click on "Configure" in the "Actions" column for the relevant "Screen".

On this "Configure" page you'll be presented with a list of fields that are configured in this JIRA screen. Go to the bottom of the page where the new field dropdown is located and select the required fields, as listed in the ["Errors"](#errors) section, from the dropdown. Go back to AppSignal and relink the JIRA issue type.

![Issue fields](/images/screenshots/jira/fields.png)

Getting JIRA working can be a bit of a hassle, but it should work if you follow the above steps with care. If you run into any issues, don't hesitate to contact us at [support@appsignal.com](mailto:support@appsignal.com) if other errors occur.
