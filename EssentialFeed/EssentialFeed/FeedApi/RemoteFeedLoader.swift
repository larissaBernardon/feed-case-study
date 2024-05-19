import Foundation

public protocol HTTPClientProtocol {
    func get(from url: URL, completion: @escaping(Error) -> Void)
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
    }

    public func load(completion: @escaping(LoadError) -> Void) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
