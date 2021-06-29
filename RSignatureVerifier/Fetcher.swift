protocol Fetchable {
    func fetchKey(with keyId: String, completionHandler: @escaping (KeyModel?) -> Void)
}

internal struct Fetcher: Fetchable {

    struct Config {
        let baseURL: URL
        let subscriptionKey: String
    }

    let apiClient: APIClientType
    let config: Config

    // MARK: Fetch Key
    func fetchKey(with keyId: String, completionHandler: @escaping (KeyModel?) -> Void) {
        let url = config.baseURL.appendingPathComponent(keyId)
        let keyRequest = request(for: url, config: config)

        apiClient.send(request: keyRequest, responseType: KeyModel.self) { (result) in
            switch result {
            case .success(let response):
                completionHandler(response.object as? KeyModel)
            case .failure(let error):
                Logger.e("Key fetch \(String(describing: keyRequest.url)) error occurred: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }

    private func request(for url: URL, config: Config) -> URLRequest {
        var request = URLRequest(url: url)
        request.setSubscriptionKey(config.subscriptionKey)
        return request
    }
}
