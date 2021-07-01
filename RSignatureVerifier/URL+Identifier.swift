extension URL {
    /// Replaces groups of non-alphanumeric characters in URL with '.'
    /// ex. https://endpoint.com/v2/keys/ -> https.endpoint.com.v2.keys
    var identifier: String {
        absoluteString
            .components(separatedBy: .alphanumerics.inverted)
            .filter({ !$0.isEmpty })
            .joined(separator: ".")
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
    }
}
