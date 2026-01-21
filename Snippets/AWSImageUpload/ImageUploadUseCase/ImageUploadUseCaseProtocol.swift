import Foundation
import Dependencies
import Core

public protocol ImageUploadUseCaseProtocol: Sendable {

    func upload(data: Data, type: UploadDataType) async throws -> URL

    func batchUpload(
        data: [IdentifiedData],
        type: UploadDataType,
        dataUploadCompletion: @escaping @Sendable (ImageUploadResult) -> Void
    ) async throws

}

private enum ImageUploadUseCaseKey: DependencyKey {

    /// By default, this dependency is `nil`. Consumers of `ImageGalleryDomain` are not required to provide an implementation.
    /// If `imageUploadUseCase` is not set, images will only be loaded locally and will not be uploaded.
    static let liveValue: ImageUploadUseCaseProtocol? = nil
    static let previewValue: ImageUploadUseCaseProtocol? = nil
    static let testValue: ImageUploadUseCaseProtocol? = nil

}

extension DependencyValues {

    public var imageUploadUseCase: ImageUploadUseCaseProtocol? {
        get { self[ImageUploadUseCaseKey.self] }
        set { self[ImageUploadUseCaseKey.self] = newValue }
    }

}
