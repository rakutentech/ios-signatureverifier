extension Bundle: EnvironmentSettable {
    var valueNotFound: String {
        "NONE"
    }

    var osVersion: String {
        UIDevice.current.systemVersion
    }

    var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    var sdkName: String {
        "Signature Verifier"
    }

    var sdkVersion: String {
        Bundle(for: Environment.self).value(for: "CFBundleShortVersionString") ?? self.valueNotFound
    }

    var languageCode: String? {
        // Use the device's preferred languages rather than Locale.current
        // because 'current' depends on the languages an app has been localized into
        guard let language = Locale.preferredLanguages.first else {
            return Locale.current.languageCode
        }
        return Locale(identifier: language).languageCode
    }

    var countryCode: String? {
        return Locale.current.regionCode
    }

    func value(for key: String) -> String? {
        return self.object(forInfoDictionaryKey: key) as? String
    }
}
