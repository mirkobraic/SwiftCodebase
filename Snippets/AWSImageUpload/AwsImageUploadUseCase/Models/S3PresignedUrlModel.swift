import Foundation

public struct S3PresignedUrlModel: Equatable, Sendable {

    /// Presigned URL to which we can upload a resource.
    let presignedUrl: URL

    /// Once the resource has been uploaded, it will be assigned to this URL.
    /// Usually, when saving an item we send this URL to the backend so the image gets saved.
    let imageUrl: URL

    public init(presignedUrl: URL, imageUrl: URL) {
        self.presignedUrl = presignedUrl
        self.imageUrl = imageUrl
    }

}
