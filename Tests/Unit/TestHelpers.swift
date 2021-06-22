@testable import RSignatureVerifier

class BundleMock: EnvironmentSettable {

    var mockSubKey: String?
    var mockEndpoint: String?

    func value(for key: String) -> String? {
        switch key {
        case "RSVKeyFetchEndpoint":
            return mockEndpoint
        case "RASProjectSubscriptionKey":
            return mockSubKey
        default:
            return nil
        }
    }

    var valueNotFound: String {
        Bundle.main.valueNotFound
    }
}

class FetcherMock: Fetchable {
    var fetchConfigCalledNumTimes = 0
    var fetchKeyCalledNumTimes = 0
    var fetchedKey: KeyModel? = KeyModel(identifier: "", key: "")

    func fetchKey(with keyId: String, completionHandler: @escaping (KeyModel?) -> Void) {
        fetchKeyCalledNumTimes += 1
        completionHandler(fetchedKey)
    }
}

class VerifierMock: Verifiable {
    var verifyOK = true
    var lastUsedKey: String?

    func verify(signatureBase64: String, objectData: Data, keyBase64: String) -> Bool {
        lastUsedKey = keyBase64
        return verifyOK
    }
}

class APIClientMock: APIClientType {
    var data: Data?
    var headers: [String: String]?
    var error: Error?
    var request: URLRequest?

    func send<T>(request: URLRequest,
                 responseType: T.Type,
                 completionHandler: @escaping (Result<Response, Error>) -> Void) where T: Decodable {
        self.request = request

        guard let data = data, let url = request.url else {
            return completionHandler(.failure(error ?? NSError(domain: "Test", code: 0, userInfo: nil)))
        }
        if let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: headers),
           let object = try? JSONDecoder().decode(responseType.self, from: data) {
            return completionHandler(.success(Response(object, httpResponse)))
        }
    }
}
