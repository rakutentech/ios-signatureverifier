protocol Fetchable {
    func fetchKey(with keyId: String, completionHandler: @escaping (KeyModel?) -> Void)
}

internal struct Fetcher: Fetchable {
    let apiClient: APIClientType
    let environment: Environment

    init(client: APIClientType, environment: Environment) {
        self.apiClient = client
        self.environment = environment
    }

    // MARK: Fetch Key
    func fetchKey(with keyId: String, completionHandler: @escaping (KeyModel?) -> Void) {
        guard let url = environment.keyUrl(with: keyId) else {
            return completionHandler(nil)
        }
        let keyRequest = request(for: url)

        apiClient.send(request: keyRequest, parser: KeyModel.self) { (result) in
            switch result {
            case .success(let response):
                completionHandler(response.object as? KeyModel)
            case .failure(let error):
                Logger.e("Key fetch \(String(describing: keyRequest.url)) error occurred: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }

    private func request(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setHeaders(from: environment)
        return request
    }
}
