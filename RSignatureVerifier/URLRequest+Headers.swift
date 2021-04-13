extension URLRequest {
    mutating func setHeaders(from environment: Environment) {
        addHeader("ras-app-id", environment.appId)
        addHeader("ras-device-model", environment.deviceModel)
        addHeader("ras-os-version", environment.osVersion)
        addHeader("ras-sdk-name", environment.sdkName)
        addHeader("ras-sdk-version", environment.sdkVersion)
        addHeader("ras-app-name", environment.appName)
        addHeader("ras-app-version", environment.appVersion)
        addHeader("apiKey", "ras-\(environment.subscriptionKey)")

        // If the ETag of the requested server config matches this header
        // the server will respond with 304 Not Modified and the OS will
        // give us the cached response
        if let eTag = environment.eTag {
            addHeader("If-None-Match", eTag)
        }
    }

    mutating func addHeader(_ name: String, _ value: String) {
        if !value.isEmpty {
            addValue(value, forHTTPHeaderField: name)
        }
    }
}
