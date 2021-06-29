internal final class RealSignatureVerifier {

    let keyStore: KeyStore
    private var fetcher: Fetchable
    private let verifier: Verifiable

    init(fetcher: Fetchable,
         keyStore: KeyStore,
         verifier: Verifiable = Verifier()) {

        self.fetcher = fetcher
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
