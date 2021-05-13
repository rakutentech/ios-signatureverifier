/// Signature Verifier Config public API functions
internal final class RealSignatureVerifier {
    static let shared = RealSignatureVerifier()

    private let environment: Environment
    private let apiClient: APIClientType
    private var fetcher: Fetcher
    private let keyStore: KeyStore
    private let verifier: Verifier

    init(environment: Environment = Environment(),
         apiClient: APIClientType = APIClient(),
         fetcher: Fetcher? = nil,
         keyStore: KeyStore = KeyStore(),
         verifier: Verifier = Verifier()) {

        self.environment = environment
        self.apiClient = apiClient
        self.fetcher = fetcher ?? Fetcher(client: apiClient, environment: environment)
        self.keyStore = keyStore
        self.verifier = verifier
    }

    func verify(signature: String,
                keyId: String,
                data: Data,
                resultHandler: @escaping (Bool) -> Void) {

        if let key = keyStore.key(for: keyId) {
            let result = verifier.verify(signatureBase64: signature,
                                         objectData: data,
                                         keyBase64: key)
            resultHandler(result)
        } else {
            fetcher.fetchKey(with: keyId) { (keyModel) in
                guard let key = keyModel?.key, keyModel?.identifier == keyId else {
                    return resultHandler(false)
                }
                self.keyStore.addKey(key: key, for: keyId)
                let verified = self.verifier.verify(signatureBase64: signature,
                                                    objectData: data,
                                                    keyBase64: key)
                resultHandler(verified)
            }
        }
    }
}
