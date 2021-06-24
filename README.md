![Build Status](https://app.bitrise.io/app/645745d7672035ad/status.svg?token=VB-AbZcna-9V20YrJXafbg)
[![codecov](https://codecov.io/gh/rakutentech/ios-signatureverifier/branch/main/graph/badge.svg)](https://codecov.io/gh/rakutentech/ios-signatureverfier)

# RSignatureVerifier

Signature Verifier module provides a security feature to verify any signed blob of data's authenticity after it has been downloaded.

This module supports iOS 11.0 and above. It has been tested with iOS 11.1 and above.

# **How to install**

RSignatureVerifier SDK is distributed as a Cocoapod.  
More information on installing pods: [https://guides.cocoapods.org/using/getting-started.html](https://guides.cocoapods.org/using/getting-started.html)

1. Include the following in your application's Podfile

```ruby
pod 'RSignatureVerifier'
```
**Note:** RSignatureVerifier SDK requires `use_frameworks!` to be present in the Podfile.

2. Run the following in the terminal

```
pod install
```

# **Configuring**

**Note:** Currently we do not host any public APIs but you can create your own APIs and configure the SDK to use those.

To use the module you must set the following values in your app's `Info.plist`:

| Key     | Value     |
| :---:   | :---:     |
| `RSVKeyFetchEndpoint` | Endpoint for fetching public key |
| `RASProjectSubscriptionKey` | Key needed to authenticate requests to the endpoint |


# **Using the SDK**

The SDK provides one public method `verify()` that takes 4 arguments:

1. `signature: String` - Signature to be verified encoded in base64.
2. `keyId: String` - ID of public key to be fetched.
3. `data: Data` - Data to be verified.
4. `resultHandler: (_ verified: Bool) -> Void` - Handler called when verification is complete with `verified` representing verification status.

Example of usage:
```swift
let data = "{"signed": "data"}".data(using: .utf8)!
RSignatureVerifier.verify(signature: "YSBzaWduYXR1cmUK",
                         keyId: "aac02fc3-1111-1111-1111-22baf9c5a281",
                         data: data) { verified in
    print(verified)
}
```

The SDK is compatible with Objective-C.
