import Foundation
import Networking
import Dependencies

public actor AwsImageUploadUseCase: ImageUploadUseCaseProtocol {

    enum ImageUploadError: Error {

        case fetchingPresignedUrlFailed

    }

    @Dependency(\.awsClient) private var awsClient: any AwsClientProtocol

    private var s3PresignedUrlProvider: S3PresignedUrlProvider

    public init() {
        @Dependency(\.s3PresignedUrlProvider) var s3PresignedUrlProvider: S3PresignedUrlProvider

        self.s3PresignedUrlProvider = s3PresignedUrlProvider
    }

    public func set(provider s3PresignedUrlProvider: S3PresignedUrlProvider) {
        self.s3PresignedUrlProvider = s3PresignedUrlProvider
    }

    /// Uploads a single image to S3 using a pre-signed URL.
    ///
    /// - Parameters:
    ///   - data: The image data to upload.
    ///   - type: The type of the image.
    /// - Returns: The final image URL after a successful upload.
    public func upload(data: Data, type: UploadDataType) async throws -> URL {
        let presignedUrls = try await s3PresignedUrlProvider.getPresignedUrls(count: 1, type: S3DataType(from: type))
        guard let s3Url = presignedUrls.first else { throw ImageUploadError.fetchingPresignedUrlFailed }

        return try await performUpload(of: data, to: s3Url, type: S3DataType(from: type))
    }

    /// Uploads multiple images concurrently using pre-signed S3 URLs.
    ///
    /// - Parameters:
    ///   - data: An array of image data identified by an ID.
    ///   - type: The type of image data.
    ///   - dataUploadCompletion: A closure called with the result of each image uploaded.
    public func batchUpload(
        data: [IdentifiedData],
        type: UploadDataType,
        dataUploadCompletion: @escaping @Sendable (ImageUploadResult) -> Void
    ) async throws {
        let presignedUrls = try await s3PresignedUrlProvider.getPresignedUrls(
            count: data.count,
            type: S3DataType(from: type))

        await withTaskGroup(of: ImageUploadResult.self) { group in
            for (index, item) in data.enumerated() {
                group.addTask {
                    guard let s3Url = presignedUrls[safe: index] else {
                        return ImageUploadResult(
                            id: item.id,
                            value: .failure(ImageUploadError.fetchingPresignedUrlFailed))
                    }

                    do {
                        let destinationUrl = try await self.performUpload(
                            of: item.data,
                            to: s3Url,
                            type: S3DataType(from: type))
                        return ImageUploadResult(id: item.id, value: .success(destinationUrl))
                    } catch {
                        return ImageUploadResult(id: item.id, value: .failure(error))
                    }
                }
            }

            for await result in group {
                dataUploadCompletion(result)
            }
        }
    }

    /// Uploads image data to a specified S3 URL.
    ///
    /// - Parameters:
    ///   - data: The image data to upload.
    ///   - s3Url: The pre-signed URL and target image URL.
    ///   - type: The image type used to determine the content type header.
    /// - Returns: The final URL of the uploaded image.
    private func performUpload(
        of data: Data,
        to s3Url: S3PresignedUrlModel,
        type: S3DataType
    ) async throws -> URL {
        try await awsClient.upload(data: data, to: s3Url.presignedUrl, contentType: type.contentType)

        return s3Url.imageUrl
    }

}
