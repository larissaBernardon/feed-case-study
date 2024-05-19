import XCTest

class RemoteFeedLoader {
    private let client: HTTPClientProtocol
    private let url: URL

    init(client: HTTPClientProtocol, url: URL) {
        self.client = client
        self.url = url
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClientProtocol {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClientProtocol {
    var requestedURL: URL?

    func get(from url: URL) {
        self.requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }

    private func makeSUT(url: URL = URL(string: "https://test.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)

        return (sut, client)
    }
}
