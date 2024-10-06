<div align="center">
  <img src="https://github.com/shimastripe/InAppPurchaseViewer/assets/15936908/89f54830-47bb-4f6a-97a9-14d198ca68c1" width="160">
</div>

# InAppPurchaseViewer

[![CodeQL](https://github.com/shimastripe/InAppPurchaseViewer/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/shimastripe/InAppPurchaseViewer/actions/workflows/codeql-analysis.yml)

InAppPurchaseViewer is very friendly [Apple App Store Server API](https://developer.apple.com/documentation/appstoreserverapi) Viewer.
The App Store signs the transaction and subscription renewal information that this API returns using the [JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515) specification.

## It's App Store Server API Browser 🚀

<div align="center">
  <img alt="example_get_notification_history" src="https://github.com/shimastripe/InAppPurchaseViewer/assets/15936908/18f36a80-dba8-4138-a942-331506e9b4dc">
</div>

InAppPurchaseViewer is a tool that utilizes [Apple Root CA](https://www.apple.com/certificateauthority/) to verify the signature of API responses, allowing for a comprehensive view of valid data.
By using this tool, you can ensure the reliability and security of data returned from APIs, enabling easy access to verified information.

- __Requirement__: macOS 14 Sonoma or later
- __Languages__: English

## Install

- https://github.com/shimastripe/InAppPurchaseViewer/releases

## Usage

### Get Notification History

Get a list of notifications that the App Store server attempted to send to your server. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_notification_history)

<div align="center">
  <img alt="example_get_notification_history" src="https://github.com/shimastripe/InAppPurchaseViewer/assets/15936908/18f36a80-dba8-4138-a942-331506e9b4dc">
</div>

### Get Transaction History

Get a customer's in-app purchase transaction history for your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)

<div align="center">
  <img alt="example_get_transaction_history" src="https://github.com/shimastripe/InAppPurchaseViewer/assets/15936908/939c90c3-7549-4d9c-ae8c-4b907360e59f">
</div>

### Get All Subscription Status

Get the statuses for all of a customer’s auto-renewable subscriptions in your app. [Link](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)

<div align="center">
  <img alt="example_get_all_subscription_status" src="https://github.com/shimastripe/InAppPurchaseViewer/assets/15936908/fdbdc08f-e14c-4671-9191-dd8ffdee036a">
</div>

## How to contribute

- [Docs](https://shimastripe.com/InAppPurchaseViewer/documentation)

### Build Development scheme

```sh
$ open InAppPurchaseViewer.xcworkspace
```

### Development Environment

- macOS 15 Sequoia
- Xcode 16.0
- Swift 6.0
- Sandbox enabled
