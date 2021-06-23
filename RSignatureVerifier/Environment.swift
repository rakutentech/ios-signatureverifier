internal protocol EnvironmentSettable {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
}

internal class Environment {
    let bundle: EnvironmentSettable
    var userDefaults = UserDefaults.standard

    var subscriptionKey: String {
        bundle.value(for: "RASProjectSubscriptionKey") ?? bundle.valueNotFound
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
        return baseUrl?.appendingPathComponent(keyId)
    }
}
