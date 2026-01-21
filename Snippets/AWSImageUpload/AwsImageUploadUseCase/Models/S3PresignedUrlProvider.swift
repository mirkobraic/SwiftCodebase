import Dependencies

public protocol S3PresignedUrlProvider: Sendable {

    func getPresignedUrls(count: Int, type: S3DataType) async throws -> [S3PresignedUrlModel]

}

actor S3PresignedUrlProviderKey: DependencyKey {

    static let liveValue: S3PresignedUrlProvider = MockS3PresignedUrlProvider()

}

extension DependencyValues {

    public var s3PresignedUrlProvider: S3PresignedUrlProvider {
        get { self[S3PresignedUrlProviderKey.self] }
        set { self[S3PresignedUrlProviderKey.self] = newValue }
    }

}
