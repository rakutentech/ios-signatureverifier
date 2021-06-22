extension Bundle: EnvironmentSettable {
    var valueNotFound: String {
        "NONE"
    }

    func value(for key: String) -> String? {
        object(forInfoDictionaryKey: key) as? String
    }
}
