protocol APIClientType {
    func send<T>(request: URLRequest,
                 parser: T.Type,
                 completionHandler: @escaping (Result<Response, Error>) -> Void) where T: Parsable
}

internal struct Response {
    let object: Parsable
    let httpResponse: HTTPURLResponse

    init(_ object: Parsable, _ response: HTTPURLResponse) {
        self.object = object
        self.httpResponse = response
    }
}

internal final class APIClient: APIClientType {
    let session: SessionType

    init(session: SessionType = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }

    func send<T>(request: URLRequest,
                 parser: T.Type,
                 completionHandler: @escaping (Result<Response, Error>) -> Void) where T: Parsable {

        session.startTask(with: request) { (data, response, error) in

            if let httpResponse = response as? HTTPURLResponse,
                let payloadData = data,
                let object = parser.init(data: payloadData) {
                return completionHandler(.success(Response(object, httpResponse)))
            }

            // Error handling:
            // first, check for OS-level error
            // then, for a decodable server error object
            // then if no server error object is found, handle as unspecified error
            if let err = error {
                return completionHandler(.failure(err))
            }

            do {
                let errorModel = try JSONDecoder().decode(APIError.self, from: data ?? Data())
                return completionHandler(.failure(NSError.serverError(code: errorModel.code, message: errorModel.message)))
            } catch {
                let serverError = NSError.serverError(
                    code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                    message: "Unspecified server error occurred")
                Logger.e("Error: \(serverError.description)")
                return completionHandler(.failure(serverError))
            }
        }
    }
}

private struct APIError: Decodable, Equatable {
    let code: Int
    let message: String
}

private extension NSError {
    static func serverError(code: Int, message: String) -> NSError {
        return NSError(domain: "RSignatureVerifier.APIClient", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
