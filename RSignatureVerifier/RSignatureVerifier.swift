/// Signature Verifier public API functions
@objc public final class RSignatureVerifier: NSObject {

    /// Verifies signature of given data using public key with given id
    /// - Parameter signature: Signature to be verified encoded in base64
    /// - Parameter keyId: ID of public key to be fetched
    /// - Parameter data: Data to be verified
    /// - Parameter resultHandler: Handler called when verification is complete
    /// - Parameter verified: if `true` then verification was successful.
    ///     If `false` then keyId and/or signature doesn't match the data, or public key couldn't be fetched.
    @objc public static func verify(signature: String,
                                    keyId: String,
                                    data: Data,
                                    resultHandler: @escaping (_ verified: Bool) -> Void) {
        RealSignatureVerifier.shared.verify(signature: signature,
                                            keyId: keyId,
                                            data: data,
                                            resultHandler: resultHandler)
    }
}
