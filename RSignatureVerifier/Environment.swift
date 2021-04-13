internal protocol EnvironmentSetupProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
    func deviceModel() -> String
    func osVersion() -> String
    func sdkName() -> String
    func sdkVersion() -> String
    func languageCode() -> String?
    func countryCode() -> String?
}

internal class Environment {
    let bundle: EnvironmentSetupProtocol
    static let etagKey = "com.rakuten.tech.SignatureVerifier.payloadETag"
    private var baseUrl: URL? {
        guard let endpointUrlString = bundle.value(for: "RSVKeyFetchEndpoint") else {
            Logger.e("Ensure RSVKeyFetchEndpoint value in plist is valid")
            return nil
        }
        return URL(string: "\(endpointUrlString)")
    }
    var subscriptionKey: String {
        return bundle.value(for: "RASProjectSubscriptionKey") ?? bundle.valueNotFound
    }
    var appId: String {
        return bundle.value(for: "RASApplicationIdentifier" as String) ?? bundle.valueNotFound
    }
    var appName: String {
        return bundle.value(for: "CFBundleIdentifier" as String) ?? bundle.valueNotFound
    }
    var appVersion: String {
        return bundle.value(for: "CFBundleShortVersionString" as String) ?? bundle.valueNotFound
    }
    var deviceModel: String {
        return bundle.deviceModel()
    }
    var osVersion: String {
        return bundle.osVersion()
    }
    var sdkName: String {
        return bundle.sdkName()
    }
    var sdkVersion: String {
        return bundle.sdkVersion()
    }
    var languageCode: String? {
        return bundle.languageCode()
    }
    var countryCode: String? {
        return bundle.countryCode()
    }
    var etag: String? {
        get {
            return UserDefaults.standard.string(forKey: Environment.etagKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Environment.etagKey)
        }
    }

    init(bundle: EnvironmentSetupProtocol = Bundle.main) {
        self.bundle = bundle
    }

    func keyUrl(with keyId: String) -> URL? {
        return baseUrl?.appendingPathComponent("/keys/\(keyId)")
    }
}
