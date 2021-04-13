protocol Parsable {
    init?(data: Data)
}

internal struct KeyModel: Decodable, Parsable {
    let identifier: String
    let key: String
    let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case key
        case createdAt
    }

    init?(data: Data) {
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
            let identifier = dictionary["id"],
            let key = dictionary["key"],
            let createdAt = dictionary["createdAt"] else {
            return nil
        }
        self.identifier = identifier
        self.key = key
        self.createdAt = createdAt
    }
}
