import Quick
import Nimble
import CommonCrypto
@testable import RSignatureVerifier

class IntegrationSpec: QuickSpec {
    override func spec() {

        describe("Integration Tests") {

            let bundle = Bundle(for: type(of: self))
            let bundleVersion = bundle.object(forInfoDictionaryKey: "TESTS_BUNDLE_VERSION") as? String
            let bundleURLString = bundle.object(forInfoDictionaryKey: "TESTS_BUNDLE_URL") as? String
            let bundleSignature = bundle.object(forInfoDictionaryKey: "TESTS_BUNDLE_SIGNATURE") as? String
            let keyId = bundle.object(forInfoDictionaryKey: "TESTS_KEY_ID") as? String

            beforeEach {
                RealSignatureVerifier.shared.keyStore.empty()
            }

            it("will download and verify bundle's signature") {
                guard let bundleVersion = bundleVersion,
                      let bundleURLString = bundleURLString,
                      let bundleURL = URL(string: bundleURLString),
                      let bundleSignature = bundleSignature,
                      let keyId = keyId else {
                    fail("Missing environment variables")
                    return
                }

                waitUntil(timeout: .seconds(10)) { done in
                    URLSession.shared.dataTask(with: bundleURL, completionHandler: { data, response, error in
                        guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                            fail("Unexpected bundle download error: \(String(describing: error))")
                            return
                        }

                        RSignatureVerifier.verify(signature: bundleSignature,
                                                  keyId: keyId,
                                                  data: (bundleVersion + self.sha256(data: data)).data(using: .ascii)!) { verified in
                            expect(verified).to(beTrue())
                            done()
                        }
                    }).resume()
                }
            }
        }
    }

    func sha256(data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).hexString
    }
}

extension Data {
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
