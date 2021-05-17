@testable import RSignatureVerifier

class BundleMock: EnvironmentSettable {

    var mockAppId: String?
    var mockAppName: String?
    var mockAppVersion: String?
    var mockEndpoint: String?
    var mockSubKey: String?
    var mockDeviceModel: String?
    var mockOsVersion: String?
    var mockSdkName: String?
    var mockSdkVersion: String?
    var mockLanguageCode: String?
    var mockCountryCode: String?
    var mockNotFound: String?
    var mockDelay: TimeInterval?

    func value(for key: String) -> String? {
        switch key {
        case "RASApplicationIdentifier":
            return mockAppId
        case "RSVKeyFetchEndpoint":
            return mockEndpoint
        case "RASProjectSubscriptionKey":
            return mockSubKey
        case "CFBundleIdentifier":
            return mockAppName
        case "CFBundleDisplayName":
            return mockAppName
        case "CFBundleShortVersionString":
            return mockAppVersion
        default:
            return nil
        }
    }

    var valueNotFound: String {
        mockNotFound ?? ""
    }

    var deviceModel: String {
        mockDeviceModel ?? valueNotFound
    }

    var appVersion: String {
        mockAppVersion ?? valueNotFound
    }

    var osVersion: String {
        mockOsVersion ?? valueNotFound
    }

    var sdkName: String {
        mockSdkName ?? valueNotFound
    }

    var sdkVersion: String {
        mockSdkVersion ?? valueNotFound
    }

    var languageCode: String? {
        mockLanguageCode ?? valueNotFound
    }

    var countryCode: String? {
        mockCountryCode ?? valueNotFound
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
