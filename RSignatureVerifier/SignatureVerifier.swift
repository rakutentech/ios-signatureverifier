/// Signature Verifier Config public API functions
@objc public final class SignatureVerifier: NSObject {

    @objc public func verify(signature: String,
                             keyId: String,
                             data: Data,
                             resultHandler: @escaping (Bool) -> Void) {
        RealSignatureVerifier.shared.verify(signature: signature,
                                            keyId: keyId,
                                            data: data,
                                            resultHandler: resultHandler)
    }
}
