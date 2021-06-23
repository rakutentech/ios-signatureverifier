import Quick
import Nimble
@testable import RSignatureVerifier

class FetcherSpec: QuickSpec {
    override func spec() {
        describe("key fetch function") {
            let bundleMock = BundleMock()
            let userDefaults = UserDefaults(suiteName: "FetcherSpec")!
            var apiClientMock: APIClientMock!

            bundleMock.mockEndpoint = "https://www.endpoint.com"

            func getEnvironment() -> Environment {
                let env = Environment(bundle: bundleMock)
                env.userDefaults = userDefaults
                return env
            }

            beforeEach {
                apiClientMock = APIClientMock()
            }

            afterEach {
                UserDefaults.standard.removePersistentDomain(forName: "FetcherSpec")
            }

            it("will call the send function of the api client passing in a request") {
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request).toEventually(beAnInstanceOf(URLRequest.self))
            }

            it("will pass nil in the completion handler when environment is incorrectly configured") {
                var testResult: Any?
                bundleMock.mockEndpoint = "12345"
                let fetcher = Fetcher(client: APIClientMock(), environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (result) in
                    testResult = result
                })

                expect(testResult).to(beNil())
            }

            it("will prefix ras- to the request's subscription key header") {
                bundleMock.mockSubKey = "my-subkey"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })
                expect(apiClientMock.request?.allHTTPHeaderFields!["apiKey"]).toEventually(equal("ras-my-subkey"))
            }

            context("when valid key model is received as the result from the api client") {
                it("will set the config dictionary in the result passed to the completion handler") {
                    var testResult: Any?
                        let dataString = """
                        {"id":"foo","ecKey":"myKeyId","pemKey":"myPemKey"}
                        """
                    apiClientMock.data = dataString.data(using: .utf8)
                    let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                    fetcher.fetchKey(with: "key", completionHandler: { (result) in
                        testResult = result
                    })

                    expect((testResult as? KeyModel)?.key).toEventually(equal("myKeyId"))
                }
            }

            context("when error is received as the result from the api client") {
                it("will pass nil in the completion handler") {
                    var testResult: Any?
                    apiClientMock.error = NSError(domain: "Test", code: 123, userInfo: nil)
                    let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                    fetcher.fetchKey(with: "key", completionHandler: { (result) in
                        testResult = result
                    })

                    expect(testResult).to(beNil())
                }
            }
        }
    }
}
