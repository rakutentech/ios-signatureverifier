extension URLRequest {
    mutating func setSubscriptionKey(_ key: String) {
        var keyValue = key
        if !key.hasPrefix("ras-") {
            keyValue = "ras-\(key)"
        }

        addValue(keyValue, forHTTPHeaderField: "apiKey")
    }
}
