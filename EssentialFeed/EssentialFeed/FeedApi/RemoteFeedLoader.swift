import Foundation

public enum RemoteFeedLoaderResult {
    case success(HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClientProtocol {
    func get(from url: URL, completion: @escaping(RemoteFeedLoaderResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClientProtocol

    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }

    public enum LoadError {
        case connectivity
        case invalidData
    }

    public func load(completion: @escaping(LoadError) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        }
    }
}
