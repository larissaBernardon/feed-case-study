import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURL.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://myurl.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://myurl.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURL, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "test", code: 0)
        var capturedError: RemoteFeedLoader.LoadError?

        sut.load { capturedError = $0 }

        XCTAssertEqual(capturedError, .connectivity)
    }

    private func makeSUT(url: URL = URL(string: "https://test.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }
}

class HTTPClientSpy: HTTPClientProtocol {
    var requestedURL = [URL]()
    var error: Error?

    func get(from url: URL, completion: @escaping(Error) -> Void) {
        if let error {
            completion(error)
        }

        self.requestedURL.append(url)
    }
}
