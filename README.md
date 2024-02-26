# InAppPurchaseViewer

[![CodeQL](https://github.com/shimastripe/InAppPurchaseViewer/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/shimastripe/InAppPurchaseViewer/actions/workflows/codeql-analysis.yml)

InAppPurchaseViewer is very friendly [Apple App Store Server API](https://developer.apple.com/documentation/appstoreserverapi) Viewer.
The App Store signs the transaction and subscription renewal information that this API returns using the [JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515) specification.
InAppPurchaseViewer is a tool that utilizes [Apple Root CA](https://www.apple.com/certificateauthority/) to verify the signature of API responses, allowing for a comprehensive view of valid data.
By using this tool, you can ensure the reliability and security of data returned from APIs, enabling easy access to verified information.

- __Requirement__: macOS 14 Sonoma or later
- __Languages__: English

### Development Environment

- macOS 14 Sonoma
- Xcode 15.2
- Swift 5.9
- Sandbox enabled
