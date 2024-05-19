import Foundation

public protocol HTTPClientProtocol {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClientProtocol

    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}
