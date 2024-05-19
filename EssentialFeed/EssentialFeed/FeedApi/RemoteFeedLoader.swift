import Foundation

public protocol HTTPClientProtocol {
    func get(from url: URL, completion: @escaping(Error?, HTTPURLResponse?) -> Void)
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
        client.get(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}
