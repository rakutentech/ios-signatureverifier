extension URLRequest {
    mutating func setHeaders(from environment: Environment) {
        addHeader("apiKey", "ras-\(environment.subscriptionKey)")
    }

    mutating func addHeader(_ name: String, _ value: String) {
        if !value.isEmpty {
            addValue(value, forHTTPHeaderField: name)
        }
    }
}
