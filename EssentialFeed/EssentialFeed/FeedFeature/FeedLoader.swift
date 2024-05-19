import Foundation

enum FeedLoaderResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: (FeedLoaderResult) -> Void)
}
