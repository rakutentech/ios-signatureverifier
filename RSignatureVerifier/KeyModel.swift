internal struct KeyModel: Decodable {
    let identifier: String
    let key: String
    let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case key
        case createdAt
    }

    init(identifier: String, key: String, createdAt: String = "\(Date())") {
        self.identifier = identifier
        self.key = key
        self.createdAt = createdAt
    }
}
