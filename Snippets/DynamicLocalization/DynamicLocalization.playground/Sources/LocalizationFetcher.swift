import Foundation
import Combine

public class LocalizationFetcher {

    public init() { }
    
    public func fetchLocalization() -> AnyPublisher<RuntimeLocalization, Error> {

        // TODO: load from example
        return Fail(error: NSError(domain: "Unable to fetch localization", code: -1)).eraseToAnyPublisher()
    }
}
