internal protocol EnvironmentSettable {
    var valueNotFound: String { get }
    var deviceModel: String { get }
    var osVersion: String { get }
    var sdkName: String { get }
    var sdkVersion: String { get }
    var languageCode: String? { get }
    var countryCode: String? { get }
    func value(for key: String) -> String?
}

internal class Environment {
    static let eTagKey = "com.rakuten.tech.SignatureVerifier.payloadETag"

    let bundle: EnvironmentSettable
    var userDefaults = UserDefaults.standard

    var subscriptionKey: String {
        bundle.value(for: "RASProjectSubscriptionKey") ?? bundle.valueNotFound
    }
    var appId: String {
        bundle.value(for: "RASApplicationIdentifier" as String) ?? bundle.valueNotFound
    }
    var appName: String {
        bundle.value(for: "CFBundleIdentifier" as String) ?? bundle.valueNotFound
    }
    var appVersion: String {
        bundle.value(for: "CFBundleShortVersionString" as String) ?? bundle.valueNotFound
    }
    var deviceModel: String {
        bundle.deviceModel
    }
    var osVersion: String {
        bundle.osVersion
    }
    var sdkName: String {
        bundle.sdkName
    }
    var sdkVersion: String {
        bundle.sdkVersion
    }
    var languageCode: String? {
        bundle.languageCode
    }
    var countryCode: String? {
        bundle.countryCode
    }
    var eTag: String? {
        get {
            return userDefaults.string(forKey: Environment.eTagKey)
        }
        set {
            userDefaults.set(newValue, forKey: Environment.eTagKey)
        }
    }
    private var baseUrl: URL? {
        guard let endpointUrlString = bundle.value(for: "RSVKeyFetchEndpoint"),
              let url = URL(string: endpointUrlString) else {
            Logger.e("Ensure RSVKeyFetchEndpoint value in plist is valid")
            return nil
        }
        return url
    }

    init(bundle: EnvironmentSettable = Bundle.main) {
        self.bundle = bundle
    }

    func keyUrl(with keyId: String) -> URL? {
        return baseUrl?.appendingPathComponent("/keys/\(keyId)")
    }
}
