import Quick
import Nimble
@testable import RSignatureVerifier

class FetcherSpec: QuickSpec {
    override func spec() {
        describe("key fetch function") {
            let bundleMock = BundleMock()
            let userDefaults = UserDefaults(suiteName: "FetcherSpec")!
            var apiClientMock: APIClientMock!

            // Fetcher will just return if endpoint or appid are invalid
            // so need to set something valid
            bundleMock.mockEndpoint = "https://www.endpoint.com"
            bundleMock.mockAppId = "foo-id"

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

            it("will add the If-None-Match header if Etag was saved") {
                userDefaults.set("my-etag", forKey: Environment.eTagKey)
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["If-None-Match"]).toEventually(equal("my-etag"))
            }

            it("will not add the If-None-Match header if Etag cannot be found") {
                userDefaults.set(nil, forKey: Environment.eTagKey)
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["If-None-Match"]).toEventually(beNil())
            }

            it("will add the app id header") {
                bundleMock.mockAppId = "my-app-id"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-app-id"]).toEventually(equal("my-app-id"))
            }

            it("will add the app name header") {
                bundleMock.mockAppName = "my-app-name"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-app-name"]).toEventually(equal("my-app-name"))
            }

            it("will add the app version header") {
                bundleMock.mockAppVersion = "100.1.0"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-app-version"]).toEventually(equal("100.1.0"))
            }

            it("will add the device model header") {
                bundleMock.mockDeviceModel = "a-model"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-device-model"]).toEventually(equal("a-model"))
            }

            it("will add the OS version header") {
                bundleMock.mockOsVersion = "os foo"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-os-version"]).toEventually(equal("os foo"))
            }

            it("will add the sdk name header") {
                bundleMock.mockSdkName = "my sdk"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-sdk-name"]).toEventually(equal("my sdk"))
            }

            it("will add the sdk version header") {
                bundleMock.mockSdkVersion = "1.2.3"
                let fetcher = Fetcher(client: apiClientMock, environment: getEnvironment())

                fetcher.fetchKey(with: "key", completionHandler: { (_) in
                })

                expect(apiClientMock.request?.allHTTPHeaderFields!["ras-sdk-version"]).toEventually(equal("1.2.3"))
            }

            context("when valid key model is received as the result from the api client") {
                it("will set the config dictionary in the result passed to the completion handler") {
                    var testResult: Any?
                        let dataString = """
                        {"id":"foo","key":"myKeyId","createdAt":"boo"}
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
