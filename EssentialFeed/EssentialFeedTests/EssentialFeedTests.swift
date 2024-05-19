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
        var capturedErrors = [RemoteFeedLoader.LoadError]()

        sut.load { capturedErrors.append($0) }

        let clientError = NSError(domain: "test", code: 0)
        client.complete(with: clientError)

        XCTAssertEqual(capturedErrors, [.connectivity])
    }

    private func makeSUT(url: URL = URL(string: "https://test.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }
}

class HTTPClientSpy: HTTPClientProtocol {
    var requestedURL = [URL]()
    var completions = [(Error) -> Void]()

    func get(from url: URL, completion: @escaping(Error) -> Void) {
        completions.append(completion)
        requestedURL.append(url)
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](error)
    }
}
