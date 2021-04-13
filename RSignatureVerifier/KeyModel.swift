protocol Parsable {
    init?(data: Data)
}

internal struct KeyModel: Decodable, Parsable {
    // swiftlint:disable:next identifier_name
    let id: String // use CodingKeys
    let key: String
    let createdAt: String

    init?(data: Data) {
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
            let identifier = dictionary["id"],
            let key = dictionary["key"],
            let createdAt = dictionary["createdAt"] else {
            return nil
        }
        self.id = identifier
        self.key = key
        self.createdAt = createdAt
    }
}
