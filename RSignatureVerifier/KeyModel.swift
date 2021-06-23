internal struct KeyModel: Decodable {
    let identifier: String
    let key: String

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case key = "ecKey"
    }

    init(identifier: String, key: String) {
        self.identifier = identifier
        self.key = key
    }
}
