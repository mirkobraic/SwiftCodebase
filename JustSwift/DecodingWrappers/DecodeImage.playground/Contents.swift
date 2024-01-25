import UIKit
import Combine

protocol FetchingOptions {
    static var fetchOnInit: Bool { get }
}

enum AutoFetch: FetchingOptions {
    static var fetchOnInit: Bool { true }
}

enum LazyFetch: FetchingOptions {
    static var fetchOnInit: Bool { false }
}

/// Assings URL string to wrapped value and starts fetching image emitting it as projected value.
/// Use ``AutoFetch`` and ``LazyFetch`` generic arguments to configure when the image will be fetched.
@propertyWrapper
class ImageUrl<T: FetchingOptions>: Decodable {
    private var imageSubscription: AnyCancellable?
    var wrappedValue = ""

    private var _projectedValue = CurrentValueSubject<UIImage?, Never>(nil)
    var projectedValue: AnyPublisher<UIImage?, Never> {
        if imageSubscription == nil {
            fetchImage()
        }
        return _projectedValue.eraseToAnyPublisher()
    }

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(String.self)

        if T.fetchOnInit {
            fetchImage()
        }
    }

    // TODO: use kingfisher
    private func fetchImage() {
        guard let url = URL(string: wrappedValue) else { return }

        imageSubscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { image in
                self._projectedValue.send(image)
            }
    }
}

extension KeyedDecodingContainer {
    func decode<T: FetchingOptions>(_: ImageUrl<T>.Type, forKey key: Key) throws -> ImageUrl<T> {
        if let value = try decodeIfPresent(ImageUrl<T>.self, forKey: key) {
            return value
        } else {
            return ImageUrl()
        }
    }
}

extension ImageUrl: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
