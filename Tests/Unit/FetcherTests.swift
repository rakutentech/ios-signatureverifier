import Quick
import Nimble
@testable import RSignatureVerifier

class FetcherSpec: QuickSpec {
    override func spec() {
        describe("key fetch function") {
            var apiClientMock: APIClientMock!
            var fetcher: Fetcher!
            let config = Fetcher.Config(baseURL: URL(string: "https://www.endpoint.com")!, subscriptionKey: "my-subkey")

            beforeEach {
                apiClientMock = APIClientMock()
                fetcher = Fetcher(apiClient: apiClientMock, config: config)
            }

            afterEach {
                UserDefaults.standard.removePersistentDomain(forName: "FetcherSpec")
            }

            it("will call the send function of the api client passing in a request") {
                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request).toEventually(beAnInstanceOf(URLRequest.self))
            }

            it("will pass nil in the completion handler when environment is incorrectly configured") {
                var testResult: Any?

                fetcher.fetchKey(with: "key", completionHandler: { (result) in
                    testResult = result
                })

                expect(testResult).to(beNil())
            }

            it("will prefix ras- to the request's subscription key header") {
                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })
                expect(apiClientMock.request?.allHTTPHeaderFields!["apiKey"]).toEventually(equal("ras-my-subkey"))
            }

            it("will not add (another) ras- prefix to the subscription key, if it already exists") {
                fetcher = Fetcher(apiClient: apiClientMock,
                                  config: .init(baseURL: URL(string: "https://www.endpoint.com")!, subscriptionKey: "ras-my-subkey"))

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })
                expect(apiClientMock.request?.allHTTPHeaderFields!["apiKey"]).toEventually(equal("ras-my-subkey"))
            }

            context("when valid key model is received as the result from the api client") {
                beforeEach {
                    let dataString = """
                        {"id":"foo","ecKey":"myKeyId","pemKey":"myPemKey"}
                        """
                    apiClientMock.data = dataString.data(using: .utf8)
                }

                it("will set the config dictionary in the result passed to the completion handler") {
                    var testResult: Any?

                    fetcher.fetchKey(with: "key", completionHandler: { (result) in
                        testResult = result
                    })

                    expect((testResult as? KeyModel)?.key).toEventually(equal("myKeyId"))
                }
            }

            context("when error is received as the result from the api client") {
                beforeEach {
                    apiClientMock.error = NSError(domain: "Test", code: 123, userInfo: nil)
                }

                it("will pass nil in the completion handler") {
                    var testResult: Any?

                    fetcher.fetchKey(with: "key", completionHandler: { (result) in
                        testResult = result
                    })

                    expect(testResult).to(beNil())
                }
            }
        }
    }
}
